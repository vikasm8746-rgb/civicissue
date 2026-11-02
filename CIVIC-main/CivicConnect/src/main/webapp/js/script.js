/**
 * CivicConnect - Global JavaScript Helper & Form Enhancements
 */

document.addEventListener('DOMContentLoaded', () => {
    // 1. Initialize Bootstrap Tooltips & Popovers
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl));

    // 2. Image Upload Preview Handler
    const imageInputs = document.querySelectorAll('input[type="file"][accept*="image"]');
    imageInputs.forEach(input => {
        input.addEventListener('change', function () {
            const previewContainer = document.getElementById(this.dataset.previewTarget || 'imagePreviewBox');
            if (!previewContainer) return;

            if (this.files && this.files[0]) {
                const file = this.files[0];
                
                // Validate file size (< 10MB)
                if (file.size > 10 * 1024 * 1024) {
                    alert('File size exceeds 10MB limit. Please choose a smaller image.');
                    this.value = '';
                    previewContainer.innerHTML = '<span class="text-muted"><i class="bi bi-image"></i> Preview will appear here</span>';
                    return;
                }

                const reader = new FileReader();
                reader.onload = function (e) {
                    previewContainer.innerHTML = `<img src="${e.target.result}" alt="Preview" class="img-fluid rounded shadow-sm" style="max-height: 200px;">`;
                };
                reader.readAsDataURL(file);
            }
        });
    });

    // 3. Auto dismiss alert messages after 5 seconds
    const autoAlerts = document.querySelectorAll('.alert-auto-dismiss');
    autoAlerts.forEach(alertEl => {
        setTimeout(() => {
            const bsAlert = new bootstrap.Alert(alertEl);
            bsAlert.close();
        }, 5000);
    });

    // 4. Live Table Search Filter
    const tableSearchInput = document.getElementById('tableSearchInput');
    if (tableSearchInput) {
        tableSearchInput.addEventListener('keyup', function () {
            const query = this.value.toLowerCase().trim();
            const targetTable = document.querySelector(this.dataset.targetTable || '.table-searchable');
            if (!targetTable) return;

            const rows = targetTable.querySelectorAll('tbody tr');
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(query) ? '' : 'none';
            });
        });
    }
});

// Helper: Quick-fill demo credentials in login page
function fillDemoCredentials(username, password) {
    const userInput = document.getElementById('username');
    const passInput = document.getElementById('password');
    if (userInput && passInput) {
        userInput.value = username;
        passInput.value = password;
        userInput.focus();
    }
}

// Helper: Print page report
function printReport() {
    window.print();
}
