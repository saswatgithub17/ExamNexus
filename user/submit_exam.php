<?php
include '../includes/auth.php';

// 1. Session and Request Security
if (!isUserLoggedIn() || $_SERVER['REQUEST_METHOD'] !== 'POST') {
    header("Location: ../login.php");
    exit;
}

// Roll number from session (this is the unique identifier)
$roll_no = $_SESSION['user_id'];
$exam_id = 1; 

// 2. Resolve or Create User (Auto-Sync)
// We need the numeric ID from the 'users' table for the foreign key
$stmt = $conn->prepare("SELECT id FROM users WHERE username = ? LIMIT 1");
$stmt->execute([$roll_no]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$user) {
    // If student isn't in the coding users table yet, create them automatically
    $full_name = $_SESSION['username'] ?? 'Student';
    $email = $roll_no . "@exam.ocp";
    $temp_pass = password_hash($roll_no, PASSWORD_DEFAULT);

    $ins = $conn->prepare("INSERT INTO users (username, password, email, full_name, is_active) VALUES (?, ?, ?, ?, 1)");
    $ins->execute([$roll_no, $temp_pass, $email, $full_name]);
    
    $user_db_id = (int)$conn->lastInsertId();
} else {
    $user_db_id = (int)$user['id'];
}

// 3. Prevent Duplicate Submission
$check = $conn->prepare("SELECT id FROM exam_results WHERE user_id = ? AND exam_id = ?");
$check->execute([$user_db_id, $exam_id]);
if ($check->rowCount() > 0) { 
    header("Location: thank_you.php"); 
    exit; 
}

$total_score = 0;

// 4. Score MCQs (Sections A-D)
if (isset($_POST['ans']) && is_array($_POST['ans'])) {
    foreach ($_POST['ans'] as $qid => $ans) {
        $st = $conn->prepare("SELECT correct_option, marks FROM questions WHERE id = ?");
        $st->execute([(int)$qid]);
        $q = $st->fetch(PDO::FETCH_ASSOC);
        
        if ($q && strval($q['correct_option']) === strval($ans)) {
            $total_score += (int)$q['marks'];
        }
    }
}

// 5. Score Coding Tasks (Section E) Dynamically
if (isset($_POST['code']) && is_array($_POST['code'])) {
    foreach ($_POST['code'] as $qid => $code) {
        if (empty(trim($code))) continue;

        $st = $conn->prepare("SELECT correct_option, option_a, language_id FROM questions WHERE id = ?");
        $st->execute([(int)$qid]);
        $q_data = $st->fetch(PDO::FETCH_ASSOC);
        
        if (!$q_data) continue;

        $lang = ($q_data['language_id'] == 1) ? 'c' : 'python';
        $expected = trim($q_data['correct_option']);
        $stdin = $q_data['option_a']; // Using option_a as stdin for the test case
        
        // Backend Verification via Piston API
        $ch = curl_init('https://emkc.org/api/v2/piston/execute');
        $payload = json_encode([
            "language" => $lang,
            "version" => ($lang == 'python') ? "3.10.0" : "10.2.0",
            "files" => [["content" => $code]],
            "stdin" => $stdin
        ]);
        
        curl_setopt($ch, CURLOPT_POSTFIELDS, $payload);
        curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type:application/json']);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_TIMEOUT, 10);
        
        $response = json_decode(curl_exec($ch), true);
        curl_close($ch);
        
        $actual_output = trim($response['run']['stdout'] ?? "");
        
        if ($actual_output === $expected) {
            $total_score += 5; // Fixed 5 marks for coding tasks
        }

        // Log the student's code attempt
        $log_code = $conn->prepare("INSERT INTO student_attempts (user_id, question_id, code_submitted) VALUES (?, ?, ?)");
        $log_code->execute([$user_db_id, (int)$qid, $code]);
    }
}

// 6. Save Final Result
$percentage = ($total_score / 50) * 100;



$final = $conn->prepare("INSERT INTO exam_results (user_id, exam_id, total_marks_obtained, percentage, is_completed) 
                         VALUES (:uid, :eid, :score, :perc, 1)");

$success = $final->execute([
    ':uid'   => $user_db_id,
    ':eid'   => $exam_id,
    ':score' => $total_score,
    ':perc'  => $percentage
]);

if ($success) {
    header("Location: thank_you.php");
} else {
    // Detailed error logging for debugging
    error_log("DB Error: " . implode(" ", $final->errorInfo()));
    die("Submission failed. Please contact the exam administrator.");
}
exit;