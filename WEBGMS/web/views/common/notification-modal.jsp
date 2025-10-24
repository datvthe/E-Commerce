<%-- Notification Modal Component --%>
<!-- Notification Modal -->
<div class="modal fade" id="notificationModal" tabindex="-1" aria-labelledby="notificationModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header border-0 pb-0">
                <div class="d-flex align-items-center w-100">
                    <div id="modalIcon" class="me-3 fs-1"></div>
                    <div class="flex-grow-1">
                        <h5 class="modal-title mb-0" id="notificationModalLabel"></h5>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
            </div>
            <div class="modal-body pt-2">
                <p id="modalMessage" class="mb-0 text-muted"></p>
            </div>
            <div class="modal-footer border-0 pt-0">
                <button type="button" class="btn btn-primary rounded-pill px-4" data-bs-dismiss="modal">
                    <i class="fas fa-check me-2"></i>OK
                </button>
            </div>
        </div>
    </div>
</div>

<style>
/* Modal styling */
.modal-content {
    border-radius: 15px;
    overflow: hidden;
}

.modal-header {
    background: linear-gradient(135deg, #f8f9fa, #ffffff);
}

.modal-footer {
    background: linear-gradient(135deg, #ffffff, #f8f9fa);
}

/* Icon animations */
.modal-icon-success {
    color: #28a745;
    animation: bounceIn 0.6s ease-out;
}

.modal-icon-error {
    color: #dc3545;
    animation: shakeX 0.6s ease-out;
}

.modal-icon-warning {
    color: #ffc107;
    animation: pulse 0.6s ease-out;
}

.modal-icon-info {
    color: #17a2b8;
    animation: fadeInUp 0.6s ease-out;
}

@keyframes bounceIn {
    0% { transform: scale(0.3); opacity: 0; }
    50% { transform: scale(1.05); }
    70% { transform: scale(0.9); }
    100% { transform: scale(1); opacity: 1; }
}

@keyframes shakeX {
    0%, 100% { transform: translateX(0); }
    10%, 30%, 50%, 70%, 90% { transform: translateX(-10px); }
    20%, 40%, 60%, 80% { transform: translateX(10px); }
}

@keyframes pulse {
    0% { transform: scale(1); }
    50% { transform: scale(1.1); }
    100% { transform: scale(1); }
}

@keyframes fadeInUp {
    0% { transform: translateY(20px); opacity: 0; }
    100% { transform: translateY(0); opacity: 1; }
}

/* Button hover effects */
.modal-footer .btn-primary {
    transition: all 0.3s ease;
}

.modal-footer .btn-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 15px rgba(255, 107, 53, 0.3);
}
</style>

<script>
// Notification Modal Functions
function showNotificationModal(title, message, type = 'info') {
    const modal = document.getElementById('notificationModal');
    const modalTitle = document.getElementById('notificationModalLabel');
    const modalMessage = document.getElementById('modalMessage');
    const modalIcon = document.getElementById('modalIcon');
    
    // Set title and message
    modalTitle.textContent = title;
    modalMessage.textContent = message;
    
    // Set icon based on type
    modalIcon.className = 'me-3 fs-1';
    let iconClass = '';
    
    switch(type) {
        case 'success':
            iconClass = 'fas fa-check-circle modal-icon-success';
            break;
        case 'error':
            iconClass = 'fas fa-times-circle modal-icon-error';
            break;
        case 'warning':
            iconClass = 'fas fa-exclamation-triangle modal-icon-warning';
            break;
        case 'info':
        default:
            iconClass = 'fas fa-info-circle modal-icon-info';
            break;
    }
    
    modalIcon.className += ' ' + iconClass;
    
    // Show modal
    const bootstrapModal = new bootstrap.Modal(modal);
    bootstrapModal.show();
    
    // Auto-hide for success messages after 3 seconds
    if (type === 'success') {
        setTimeout(() => {
            bootstrapModal.hide();
        }, 3000);
    }
}

// Convenience functions for different notification types
function showSuccessModal(title, message) {
    showNotificationModal(title, message, 'success');
}

function showErrorModal(title, message) {
    showNotificationModal(title, message, 'error');
}

function showWarningModal(title, message) {
    showNotificationModal(title, message, 'warning');
}

function showInfoModal(title, message) {
    showNotificationModal(title, message, 'info');
}

// Handle URL parameters for notifications (for redirect scenarios)
document.addEventListener('DOMContentLoaded', function() {
    const urlParams = new URLSearchParams(window.location.search);
    
    if (urlParams.has('success')) {
        const successMessage = urlParams.get('success');
        showSuccessModal('Success!', decodeURIComponent(successMessage));
        
        // Clean URL
        const cleanUrl = window.location.pathname;
        window.history.replaceState({}, document.title, cleanUrl);
    }
    
    if (urlParams.has('error')) {
        const errorMessage = urlParams.get('error');
        showErrorModal('Error!', decodeURIComponent(errorMessage));
        
        // Clean URL
        const cleanUrl = window.location.pathname;
        window.history.replaceState({}, document.title, cleanUrl);
    }
    
    if (urlParams.has('warning')) {
        const warningMessage = urlParams.get('warning');
        showWarningModal('Warning!', decodeURIComponent(warningMessage));
        
        // Clean URL
        const cleanUrl = window.location.pathname;
        window.history.replaceState({}, document.title, cleanUrl);
    }
    
    if (urlParams.has('info')) {
        const infoMessage = urlParams.get('info');
        showInfoModal('Information!', decodeURIComponent(infoMessage));
        
        // Clean URL
        const cleanUrl = window.location.pathname;
        window.history.replaceState({}, document.title, cleanUrl);
    }
});
</script>