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
        matchBrackets: true,
        extraKeys: {
            'Ctrl-Enter': runCode,
            'Cmd-Enter': runCode
        }
    });

    // Set initial mode based on default language
    const initialLanguage = document.getElementById('language-select').value;
    editor.setOption('mode', getModeForLanguage(initialLanguage));

    // Language selector change handler
    const languageSelect = document.getElementById('language-select');
    languageSelect.addEventListener('change', function () {
        const languageId = this.value;
        const mode = getModeForLanguage(languageId);
        editor.setOption('mode', mode);
    });

    // Run code function
    async function runCode() {
        const executeForm = document.getElementById('execute-form');
        const runButton = document.querySelector('.btn-run');

        // Get code directly from editor
        const codeContent = editor.getValue();
        console.log('Code content to execute:', codeContent);

        // Validate code exists
        if (!codeContent.trim()) {
            alert('Please enter some code before running');
            return false;
        }

        // Auto-switch to Input tab if input() detected in code
        if (codeContent.includes('input(')) {
            document.querySelector('[data-tab="input"]').click();
        }

        // Show loading state
        const originalHtml = runButton.innerHTML;
        runButton.disabled = true;
        runButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Running...';

        try {
            // Create FormData object
            const formData = new FormData(executeForm);
            formData.append('code', codeContent);

            // Also grab input from the stdin textarea
            const stdinElement = document.getElementById('stdin');
            if (stdinElement) {
                formData.append('stdin', stdinElement.value);
            }

            // Submit via fetch API
            const response = await fetch('', {
                method: 'POST',
                body: formData,
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            });

            if (!response.ok) {
                throw new Error('Network response was not ok');
            }

            // Parse the JSON response
            const result = await response.json();

            // Update the output tab
            const outputTab = document.getElementById('output-tab');
            const outputElement = outputTab.querySelector('.execution-output') || 
                                 outputTab.querySelector('.execution-error') || 
                                 outputTab.querySelector('.execution-placeholder');
            
            if (result.error) {
                outputElement.className = 'execution-error';
                outputElement.textContent = result.error;
            } else if (result.output) {
                outputElement.className = 'execution-output';
                outputElement.textContent = result.output;
                
                // Update execution time if available
                const metaElement = outputTab.querySelector('.execution-meta');
                if (metaElement && result.executionTime) {
                    metaElement.innerHTML = `<span>Execution time: ${parseFloat(result.executionTime).toFixed(2)}s</span>`;
                }
            }

            // Ensure output tab is active
            document.querySelector('[data-tab="output"]').click();

        } catch (error) {
            console.error('Error:', error);
            alert('An error occurred while executing the code');
        } finally {
            runButton.disabled = false;
            runButton.innerHTML = originalHtml;
        }
    }

    // Attach runCode to form submission
    document.getElementById('execute-form').addEventListener('submit', function (e) {
        e.preventDefault();
        runCode();
    });

    function getModeForLanguage(languageId) {
        const languageModes = {
            50: 'text/x-csrc',      // C
            54: 'text/x-c++src',    // C++
            62: 'text/x-java',      // Java
            71: 'python'           // Python
        };

        return languageModes[languageId] || 'text/plain';
    }

    // Tab switching logic
    document.querySelectorAll('.tab-button').forEach(button => {
        button.addEventListener('click', () => {
            document.querySelectorAll('.tab-button').forEach(btn => btn.classList.remove('active'));
            document.querySelectorAll('.tab-content').forEach(tab => tab.classList.remove('active'));

            button.classList.add('active');
            const tabId = button.getAttribute('data-tab');
            document.getElementById(`${tabId}-tab`).classList.add('active');
        });
    });
});