/**
 * Proctoring & Timed Section Logic
 */

// 1. SECURITY: Disable Copy, Paste, and Context Menu
document.addEventListener('copy', (e) => e.preventDefault());
document.addEventListener('paste', (e) => e.preventDefault());
document.addEventListener('contextmenu', (e) => e.preventDefault());

// 2. TAB CHANGE DETECTION
document.addEventListener("visibilitychange", function() {
    if (document.hidden) {
        alert("CRITICAL VIOLATION: Tab change detected! Final submission processing...");
        submitExamFinal();
    }
});

// 3. SECTION TIMING CONFIG
let timePerSection = { 'A': 600, 'B': 600, 'C': 600, 'D': 600, 'E': 1200 }; 
let sections = ['A', 'B', 'C', 'D', 'E'];
let currentSectionIndex = 0;
let timerInterval;

function startSectionTimer() {
    let currentSec = sections[currentSectionIndex];
    let timeLeft = timePerSection[currentSec];

    clearInterval(timerInterval);
    
    timerInterval = setInterval(() => {
        let mins = Math.floor(timeLeft / 60);
        let secs = timeLeft % 60;
        document.getElementById('section-timer').textContent = 
            (mins < 10 ? "0" : "") + mins + ":" + (secs < 10 ? "0" : "") + secs;

        if (timeLeft <= 0) {
            clearInterval(timerInterval);
            alert("Time up for Section " + currentSec + "! Moving to next section.");
            autoMoveToNext();
        }
        timeLeft--;
    }, 1000);
}

function manualNextSection() {
    if(confirm("Are you sure you want to submit this section? You cannot go back.")) {
        autoMoveToNext();
    }
}

function autoMoveToNext() {
    let currentSec = sections[currentSectionIndex];
    
    // Mark sidebar as completed
    document.getElementById('btn-sec-' + currentSec).classList.add('completed');
    document.getElementById('btn-sec-' + currentSec).classList.remove('active');
    document.getElementById('btn-sec-' + currentSec).classList.add('list-group-item-success');

    currentSectionIndex++;

    if (currentSectionIndex < sections.length) {
        let nextSec = sections[currentSectionIndex];
        
        // UI Updates
        document.querySelectorAll('.section-pane').forEach(p => p.classList.remove('active'));
        document.getElementById('pane-' + nextSec).classList.add('active');
        
        let nextBtn = document.getElementById('btn-sec-' + nextSec);
        nextBtn.classList.remove('disabled');
        nextBtn.classList.add('active');

        // Reset timer for the new section
        startSectionTimer();
    } else {
        submitExamFinal();
    }
}

function submitExamFinal() {
    clearInterval(timerInterval);
    alert("Exam finished! Thank you.");
    // AJAX call to submit the form data to a processing PHP file
    document.getElementById('exam-form').submit(); 
}

// Initialize on load
window.onload = startSectionTimer;

// AUTO-SAVE PROGRESS EVERY 30 SECONDS
setInterval(() => {
    let formData = new FormData(document.getElementById('exam-form'));
    fetch('auto_save.php', {
        method: 'POST',
        body: formData
    }).then(response => console.log("Progress Auto-Saved"));
}, 30000); 

// Update the final submit function to call the real PHP file
function submitExamFinal() {
    clearInterval(timerInterval);
    document.getElementById('exam-form').action = 'submit_exam.php';
    document.getElementById('exam-form').method = 'POST';
    document.getElementById('exam-form').submit(); 
}