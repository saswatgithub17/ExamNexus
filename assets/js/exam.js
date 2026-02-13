document.addEventListener('DOMContentLoaded', function () {
    // Initialize CodeMirror
    const editor = CodeMirror.fromTextArea(document.getElementById('code-editor'), {
        lineNumbers: true,
        theme: 'dracula',
        mode: 'python',
        indentUnit: 4,
        tabSize: 4,
        lineWrapping: true,
        autoCloseBrackets: true,
        matchBrackets: true
    });

    // Language selector change handler
    const languageSelect = document.getElementById('language-select');
    languageSelect.addEventListener('change', function () {
        const languageId = this.value;
        const mode = getModeForLanguage(languageId);
        editor.setOption('mode', mode);
    });

    // Form submission handler
    document.getElementById('execute-form').addEventListener('submit', function (e) {
        e.preventDefault();
        
        // Update hidden code field with editor content
        document.getElementById('hidden-code').value = editor.getValue();
        
        // Submit form
        this.submit();
    });

    // Timer functionality
    function startTimer(duration) {
        let timer = duration, minutes, seconds;
        const timerElement = document.getElementById('timer');
        
        const interval = setInterval(function () {
            minutes = parseInt(timer / 60, 10);
            seconds = parseInt(timer % 60, 10);

            minutes = minutes < 10 ? "0" + minutes : minutes;
            seconds = seconds < 10 ? "0" + seconds : seconds;

            timerElement.textContent = minutes + ":" + seconds;

            if (--timer < 0) {
                clearInterval(interval);
                alert("Time's up! Your exam will be submitted automatically.");
                // Auto-submit logic can be added here
            }
        }, 1000);
    }

    // Initialize timer if exists
    const timerElement = document.getElementById('timer');
    if (timerElement) {
        const timeArray = timerElement.textContent.split(':');
        const totalSeconds = parseInt(timeArray[0]) * 60 + parseInt(timeArray[1]);
        startTimer(totalSeconds);
    }

    function getModeForLanguage(languageId) {
        const languageModes = {
            50: 'text/x-csrc',      // C
            54: 'text/x-c++src',    // C++
            62: 'text/x-java',      // Java
            71: 'python'           // Python
        };
        return languageModes[languageId] || 'text/plain';
    }
});