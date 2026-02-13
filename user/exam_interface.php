<?php
include '../includes/auth.php';
if (!isUserLoggedIn()) redirect('../login.php');

$exam_id = 1;
// We fetch Sections A-D for MCQs and E for Coding dynamically
$sections = ['A', 'B', 'C', 'D', 'E']; 
$questions_by_section = [];

foreach ($sections as $sec) {
    $stmt = $conn->prepare("SELECT * FROM questions WHERE exam_id = ? AND section = ? ORDER BY RAND(?) ASC");
    $stmt->execute([$exam_id, $sec, (int)$_SESSION['user_id']]); 
    $questions_by_section[$sec] = $stmt->fetchAll(PDO::FETCH_ASSOC);
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0">
    <title>OCP | Secure Exam Interface</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/codemirror.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/theme/neo.min.css">
    <style>
        body { background: #fdfdfd; color: #111; font-family: 'Segoe UI', sans-serif; min-height: 100vh; overflow-x: hidden; user-select: none; }
        .top-nav { background: #fff; border-bottom: 2px solid #eee; padding: 10px 15px; display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 999; }
        .timer-box { background: #000; color: #fff; padding: 6px 12px; border-radius: 4px; font-weight: 800; font-family: monospace; font-size: 1.1rem; }
        .question-card { background: #fff; border-radius: 15px; padding: 25px; border: 1px solid #eee; display: none; margin: 20px auto; max-width: 800px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); }
        .question-card.active { display: block; }
        .opt-box { display: block; padding: 15px; border: 1px solid #f0f0f0; border-radius: 12px; margin-bottom: 12px; cursor: pointer; background: #fafafa; font-weight: 600; }
        input[type="radio"]:checked + .opt-box { background: #eff6ff; border-color: #2563eb; color: #2563eb; }
        
        /* Section E Split UI */
        .split-container { display: none; flex-direction: column; gap: 15px; padding: 10px; height: calc(100vh - 100px); }
        @media (min-width: 992px) { .split-container { flex-direction: row; padding: 15px; overflow: hidden; } }
        .left-panel { flex: 4; background: #fff; border-radius: 12px; padding: 20px; border: 1px solid #e0e0e0; overflow-y: auto; }
        .right-panel { flex: 6; display: flex; flex-direction: column; gap: 10px; }
        .editor-wrapper { border-radius: 12px; overflow: hidden; border: 1px solid #ddd; flex-grow: 1; min-height: 300px; }
        .console-wrapper { height: 180px; background: #0a192f; color: #e6f1ff; padding: 15px; font-family: 'Consolas', monospace; border-radius: 12px; border: 2px solid #112240; overflow-y: auto; }
        .CodeMirror { height: 100% !important; font-size: 14px; }
        
        #start-overlay { position:fixed; top:0; left:0; width:100%; height:100%; background:#fff; z-index:10000; display:flex; flex-direction:column; justify-content:center; align-items:center; text-align:center; padding: 20px; }
        #wait-overlay { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(255,255,255,0.9); z-index:10001; flex-direction:column; justify-content:center; align-items:center; }
    </style>
</head>
<body oncontextmenu="return false;">

<div id="start-overlay">
    <h2 class="fw-bold">Security Check</h2>
    <p class="text-muted mb-4">Fullscreen is mandatory. Tab switching or exiting fullscreen auto-submits the exam.</p>
    <button class="btn btn-primary px-5 shadow" onclick="startExam()">Enter Fullscreen & Begin</button>
</div>

<div id="wait-overlay">
    <div class="spinner-border text-primary mb-3"></div>
    <h4 class="fw-bold">Securing Execution...</h4>
</div>

<div class="top-nav">
    <div class="fw-bold">ID: <?php echo $_SESSION['user_id']; ?> | <?php echo strtoupper($_SESSION['username']); ?></div>
    <div class="timer-box" id="clock">10:00</div>
</div>

<form id="exam-form" action="submit_exam.php" method="POST">
    <?php foreach ($questions_by_section as $sec => $questions): ?>
        <div class="section-group" id="sec-<?php echo $sec; ?>" style="display: none;">
            
            <?php if($sec !== 'E'): ?>
                <div class="container pb-5">
                    <?php foreach ($questions as $idx => $q): ?>
                        <div class="question-card q-item-<?php echo $sec; ?>" id="q-<?php echo $sec.'-'.$idx; ?>">
                            <div class="small fw-bold text-muted">Section <?php echo $sec; ?> - Q<?php echo ($idx+1); ?></div>
                            <h5 class="fw-bold my-3"><?php echo htmlspecialchars($q['description']); ?></h5>
                            <?php foreach(['A','B','C','D'] as $o): $col="option_".strtolower($o); ?>
                                <input type="radio" class="d-none" name="ans[<?php echo $q['id']; ?>]" id="opt-<?php echo $q['id'].$o; ?>" value="<?php echo $o; ?>">
                                <label class="opt-box" for="opt-<?php echo $q['id'].$o; ?>"><?php echo $o; ?>. <?php echo htmlspecialchars($q[$col]); ?></label>
                            <?php endforeach; ?>
                            <div class="d-flex justify-content-between mt-4">
                                <button type="button" class="btn btn-sm btn-outline-dark" onclick="navigate('<?php echo $sec; ?>', <?php echo $idx-1; ?>)" <?php echo $idx==0?'disabled':''; ?>>PREV</button>
                                <?php if($idx < count($questions)-1): ?>
                                    <button type="button" class="btn btn-sm btn-primary px-4" onclick="navigate('<?php echo $sec; ?>', <?php echo $idx+1; ?>)">NEXT</button>
                                <?php else: ?>
                                    <button type="button" class="btn btn-sm btn-success px-4" onclick="nextSec()">FINISH SECTION</button>
                                <?php endif; ?>
                            </div>
                        </div>
                    <?php endforeach; ?>
                </div>

            <?php else: ?>
                <?php foreach ($questions as $idx => $q): ?>
                    <div class="split-container q-item-E" id="q-E-<?php echo $idx; ?>">
                        <div class="left-panel shadow-sm">
                            <h5 class="fw-bold text-primary">Task <?php echo ($idx+1); ?></h5>
                            <hr>
                            <p class="small fw-semibold"><?php echo nl2br(htmlspecialchars($q['description'])); ?></p>
                            <div class="mt-3 p-2 bg-light rounded border small">
                                <b>Sample Input:</b> <pre class="m-0"><?php echo $q['option_a'] ?: 'N/A'; ?></pre><br>
                                <b>Expected Output:</b> <pre class="m-0"><?php echo $q['correct_option']; ?></pre>
                            </div>
                            <?php if($idx < count($questions)-1): ?>
                                <button type="button" class="btn btn-primary w-100 mt-4 btn-sm" onclick="navigate('E', <?php echo $idx+1; ?>)">NEXT TASK</button>
                            <?php else: ?>
                                <button type="button" class="btn btn-success w-100 mt-4 btn-sm" onclick="finalize()">FINISH EXAM</button>
                            <?php endif; ?>
                        </div>
                        <div class="right-panel">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="badge bg-secondary">Language: <?php echo ($q['language_id']==1)?'C':'Python 3'; ?></span>
                                <button type="button" class="btn btn-primary btn-sm px-3" onclick="runPiston(<?php echo $q['id']; ?>, '<?php echo ($q['language_id']==1)?'c':'python'; ?>', '<?php echo addslashes($q['correct_option']); ?>', '<?php echo addslashes($q['option_a']); ?>')">▶ RUN & TEST</button>
                            </div>
                            <div class="editor-wrapper">
                                <textarea name="code[<?php echo $q['id']; ?>]" id="ed-<?php echo $q['id']; ?>" data-mode="<?php echo ($q['language_id']==1)?'text/x-csrc':'python'; ?>"><?php echo htmlspecialchars($q['starter_code']); ?></textarea>
                            </div>
                            <div class="console-wrapper" id="console-<?php echo $q['id']; ?>">
                                <div class="console-output small text-info">// Output will appear here...</div>
                                <div class="test-status fw-bold mt-1 small"></div>
                            </div>
                        </div>
                    </div>
                <?php endforeach; ?>
            <?php endif; ?>
        </div>
    <?php endforeach; ?>
</form>

<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/codemirror.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/mode/clike/clike.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/mode/python/python.min.js"></script>

<script>
    let curSec = 'A', editors = {}, isExamActive = false, countdown;

    function startExam() {
        document.documentElement.requestFullscreen().catch(e => {
            alert("Please allow fullscreen to take the exam.");
        });
        document.getElementById('start-overlay').style.display = 'none';
        isExamActive = true; 
        navigate('A', 0); 
        startTimer('A');
    }

    // Proctoring Logic
    document.addEventListener('fullscreenchange', () => { if (!document.fullscreenElement && isExamActive) finalize(); });
    window.addEventListener('blur', () => { if(isExamActive) finalize(); });

    function startTimer(sec) {
        clearInterval(countdown);
        let t = (sec === 'E') ? 1200 : 600; // 20 mins for coding, 10 for others
        countdown = setInterval(() => {
            let m = Math.floor(t / 60), s = t % 60;
            document.getElementById('clock').textContent = `${m}:${s<10?'0':''}${s}`;
            if (--t < 0) nextSec();
        }, 1000);
    }

    function navigate(sec, idx) {
        // Hide all sections first
        document.querySelectorAll('.section-group').forEach(s => s.style.display = 'none');
        document.getElementById('sec-' + sec).style.display = 'block';
        
        // Hide all items in this section
        document.querySelectorAll('.q-item-' + sec).forEach(el => el.style.display = 'none');
        
        const card = document.getElementById('q-' + sec + '-' + idx);
        if(card) {
            card.style.display = (sec === 'E') ? 'flex' : 'block';
            card.classList.add('active');
            
            // Init CodeMirror if it's Section E
            if(sec === 'E') {
                const area = card.querySelector('textarea');
                if(area && !editors[area.id]) {
                    editors[area.id] = CodeMirror.fromTextArea(area, { 
                        lineNumbers: true, theme: 'neo', mode: area.dataset.mode 
                    });
                }
            }
        }
    }

    async function runPiston(qId, lang, expected, stdin) {
        const code = editors['ed-'+qId].getValue();
        const con = document.querySelector('#console-'+qId+' .console-output');
        const stat = document.querySelector('#console-'+qId+' .test-status');
        
        document.getElementById('wait-overlay').style.display = 'flex';
        con.textContent = "Processing...";
        stat.textContent = "";

        try {
            const res = await fetch('https://emkc.org/api/v2/piston/execute', {
                method: 'POST',
                body: JSON.stringify({
                    "language": lang,
                    "version": lang === 'python' ? "3.10.0" : "10.2.0",
                    "files": [{"content": code}],
                    "stdin": stdin
                })
            });
            const data = await res.json();
            document.getElementById('wait-overlay').style.display = 'none';
            
            const actual = (data.run.stdout || "").trim();
            con.textContent = actual || data.run.stderr;
            
            if (actual === expected.trim()) {
                stat.innerHTML = "<span class='text-success'>✔ Passed (Marks will be saved on submit)</span>";
            } else {
                stat.innerHTML = "<span class='text-danger'>✘ Failed (Output mismatch)</span>";
            }
        } catch (e) { 
            document.getElementById('wait-overlay').style.display = 'none';
            con.textContent = "Error connecting to server."; 
        }
    }

    function nextSec() {
        const order = ['A', 'B', 'C', 'D', 'E'];
        let nIdx = order.indexOf(curSec) + 1;
        if(nIdx < order.length) {
            curSec = order[nIdx];
            navigate(curSec, 0);
            startTimer(curSec);
        } else {
            finalize();
        }
    }

    function finalize() {
        isExamActive = false;
        for(let k in editors) editors[k].save();
        document.getElementById('exam-form').submit();
    }
</script>
</body>
</html>