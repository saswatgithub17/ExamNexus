document.addEventListener('DOMContentLoaded', function() {
    // Add animation to form elements
    const formGroups = document.querySelectorAll('.form-group');
    formGroups.forEach((group, index) => {
        group.style.opacity = '0';
        group.style.transform = 'translateY(20px)';
        group.style.transition = `all 0.3s ease ${index * 0.1}s`;
        
        setTimeout(() => {
            group.style.opacity = '1';
            group.style.transform = 'translateY(0)';
        }, 100);
    });
    
    // Add focus effects
    const inputs = document.querySelectorAll('input, select');
    inputs.forEach(input => {
        input.addEventListener('focus', function() {
            this.parentElement.querySelector('label').style.color = '#3b82f6';
        });
        
        input.addEventListener('blur', function() {
            this.parentElement.querySelector('label').style.color = '#f8fafc';
        });
    });
    
    // Password visibility toggle (can be added later)
});