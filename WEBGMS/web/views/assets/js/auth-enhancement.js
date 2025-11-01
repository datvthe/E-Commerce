/**
 * Authentication Enhancement Script
 * Handles UX improvements for Login, Register, and Email Verification
 */

(function() {
    'use strict';

    // ========================================
    // 1. FORM VALIDATION & UX
    // ========================================

    /**
     * Add loading state to form submission
     */
    function enhanceFormSubmission() {
        const forms = document.querySelectorAll('form[data-auth-form]');
        
        forms.forEach(form => {
            form.addEventListener('submit', function(e) {
                const submitBtn = form.querySelector('button[type="submit"]');
                if (submitBtn && !submitBtn.disabled) {
                    // Disable button
                    submitBtn.disabled = true;
                    
                    // Save original text
                    const originalText = submitBtn.innerHTML;
                    submitBtn.setAttribute('data-original-text', originalText);
                    
                    // Add loading spinner
                    submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Đang xử lý...';
                    
                    // Re-enable after 5 seconds (in case of error)
                    setTimeout(() => {
                        if (submitBtn.disabled) {
                            submitBtn.disabled = false;
                            submitBtn.innerHTML = originalText;
                        }
                    }, 5000);
                }
            });
        });
    }

    /**
     * Auto-hide alerts after 5 seconds
     */
    function autoHideAlerts() {
        const alerts = document.querySelectorAll('.alert[data-auto-dismiss="true"]');
        alerts.forEach(alert => {
            setTimeout(() => {
                if (typeof bootstrap !== 'undefined' && bootstrap.Alert) {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                }
            }, 5000);
        });
    }

    /**
     * Auto-focus on first input
     */
    function autoFocusFirstInput() {
        const firstInput = document.querySelector('input[autofocus], input[type="text"]:not([readonly]), input[type="email"]:not([readonly]), input[type="password"]:not([readonly])');
        if (firstInput && !firstInput.value) {
            firstInput.focus();
        }
    }

    // ========================================
    // 2. PASSWORD VISIBILITY TOGGLE
    // ========================================

    /**
     * Add show/hide password functionality
     */
    function enhancePasswordInputs() {
        const passwordInputs = document.querySelectorAll('input[type="password"][data-toggle-password]');
        
        passwordInputs.forEach(input => {
            const wrapper = input.parentElement;
            
            // Remove any existing toggle buttons first (cleanup duplicates)
            const existingButtons = wrapper.querySelectorAll('.password-toggle-btn');
            if (existingButtons.length > 0) {
                existingButtons.forEach(btn => btn.remove());
            }
            
            // Check if this input already has toggle marker
            if (input.hasAttribute('data-toggle-initialized')) {
                return; // Skip if already processed
            }
            
            // Mark as initialized
            input.setAttribute('data-toggle-initialized', 'true');
            
            // Create toggle button
            const toggleBtn = document.createElement('button');
            toggleBtn.type = 'button';
            toggleBtn.className = 'password-toggle-btn';
            toggleBtn.style.cssText = 'position: absolute; right: 12px; top: 50%; transform: translateY(-50%); border: none; background: transparent; z-index: 1000; padding: 4px 6px; display: flex; align-items: center; justify-content: center; cursor: pointer; outline: none;';
            toggleBtn.innerHTML = '<i class="fas fa-eye" style="font-size: 14px; color: #6c757d;"></i>';
            toggleBtn.setAttribute('tabindex', '-1'); // Don't focus on tab
            
            // Make wrapper position relative and add padding to input
            if (!wrapper.style.position || wrapper.style.position === 'static') {
                wrapper.style.position = 'relative';
            }
            wrapper.style.display = 'block';
            
            // Add more padding if input has validation feedback
            const hasValidation = input.classList.contains('is-valid') || input.classList.contains('is-invalid');
            input.style.paddingRight = hasValidation ? '70px' : '40px';
            
            wrapper.appendChild(toggleBtn);
            
            // Toggle visibility
            toggleBtn.addEventListener('click', function() {
                const icon = this.querySelector('i');
                if (input.type === 'password') {
                    input.type = 'text';
                    icon.classList.remove('fa-eye');
                    icon.classList.add('fa-eye-slash');
                    icon.style.color = '#ff6b35';
                } else {
                    input.type = 'password';
                    icon.classList.remove('fa-eye-slash');
                    icon.classList.add('fa-eye');
                    icon.style.color = '#6c757d';
                }
            });
            
            // Hover effect
            toggleBtn.addEventListener('mouseenter', function() {
                this.style.opacity = '0.7';
            });
            toggleBtn.addEventListener('mouseleave', function() {
                this.style.opacity = '1';
            });
        });
    }

    // ========================================
    // 3. PASSWORD STRENGTH INDICATOR
    // ========================================

    /**
     * Add password strength indicator
     */
    function addPasswordStrengthIndicator() {
        const registerPassword = document.querySelector('input[name="password"][data-strength-check]');
        
        if (!registerPassword) return;
        
        // Create strength indicator
        const strengthDiv = document.createElement('div');
        strengthDiv.className = 'password-strength mt-2';
        strengthDiv.innerHTML = `
            <div class="progress" style="height: 5px;">
                <div class="progress-bar" role="progressbar" style="width: 0%"></div>
            </div>
            <small class="text-muted mt-1 d-block">Độ mạnh mật khẩu: <span class="strength-text">Chưa nhập</span></small>
        `;
        
        registerPassword.parentElement.appendChild(strengthDiv);
        
        const progressBar = strengthDiv.querySelector('.progress-bar');
        const strengthText = strengthDiv.querySelector('.strength-text');
        
        // Check strength on input
        registerPassword.addEventListener('input', function() {
            const password = this.value;
            const strength = calculatePasswordStrength(password);
            
            // Update progress bar
            progressBar.style.width = strength.percentage + '%';
            progressBar.className = 'progress-bar ' + strength.class;
            strengthText.textContent = strength.text;
            strengthText.className = strength.textClass;
        });
    }

    /**
     * Calculate password strength
     */
    function calculatePasswordStrength(password) {
        if (!password) {
            return { percentage: 0, class: '', text: 'Chưa nhập', textClass: 'text-muted' };
        }
        
        let strength = 0;
        
        // Length
        if (password.length >= 8) strength += 25;
        if (password.length >= 12) strength += 15;
        
        // Has lowercase
        if (/[a-z]/.test(password)) strength += 15;
        
        // Has uppercase
        if (/[A-Z]/.test(password)) strength += 15;
        
        // Has number
        if (/[0-9]/.test(password)) strength += 15;
        
        // Has special character
        if (/[^a-zA-Z0-9]/.test(password)) strength += 15;
        
        if (strength < 30) {
            return { percentage: strength, class: 'bg-danger', text: 'Yếu', textClass: 'text-danger' };
        } else if (strength < 60) {
            return { percentage: strength, class: 'bg-warning', text: 'Trung bình', textClass: 'text-warning' };
        } else if (strength < 80) {
            return { percentage: strength, class: 'bg-info', text: 'Khá', textClass: 'text-info' };
        } else {
            return { percentage: strength, class: 'bg-success', text: 'Mạnh', textClass: 'text-success' };
        }
    }

    // ========================================
    // 4. EMAIL/PHONE VALIDATION
    // ========================================

    /**
     * Real-time validation for email/phone
     */
    function enhanceAccountInput() {
        const accountInput = document.querySelector('input[name="account"], input[name="email"]');
        
        if (!accountInput) return;
        
        accountInput.addEventListener('blur', function() {
            const value = this.value.trim();
            if (!value) return;
            
            const isEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value);
            const isPhone = /^[0-9]{10,11}$/.test(value);
            
            // Remove existing feedback
            const existingFeedback = this.parentElement.querySelector('.validation-feedback');
            if (existingFeedback) {
                existingFeedback.remove();
            }
            
            // Add validation feedback
            if (!isEmail && !isPhone) {
                const feedback = document.createElement('small');
                feedback.className = 'validation-feedback text-danger mt-1 d-block';
                feedback.textContent = 'Vui lòng nhập email hoặc số điện thoại hợp lệ';
                this.parentElement.appendChild(feedback);
                this.classList.add('is-invalid');
            } else {
                this.classList.remove('is-invalid');
                this.classList.add('is-valid');
            }
        });
    }

    // ========================================
    // 5. CONFIRM PASSWORD VALIDATION
    // ========================================

    /**
     * Real-time password confirmation check
     */
    function enhancePasswordConfirmation() {
        const password = document.querySelector('input[name="password"]');
        const confirmPassword = document.querySelector('input[name="confirm_password"], input[name="repassword"]');
        
        if (!password || !confirmPassword) return;
        
        confirmPassword.addEventListener('input', function() {
            // Remove existing feedback
            const existingFeedback = this.parentElement.querySelector('.validation-feedback');
            if (existingFeedback) {
                existingFeedback.remove();
            }
            
            if (this.value && this.value !== password.value) {
                const feedback = document.createElement('small');
                feedback.className = 'validation-feedback text-danger mt-1 d-block';
                feedback.textContent = 'Mật khẩu xác nhận không khớp';
                this.parentElement.appendChild(feedback);
                this.classList.add('is-invalid');
                this.classList.remove('is-valid');
                // Adjust padding for toggle button + validation icon
                this.style.paddingRight = '70px';
            } else if (this.value) {
                this.classList.remove('is-invalid');
                this.classList.add('is-valid');
                // Adjust padding for toggle button + validation icon
                this.style.paddingRight = '70px';
            } else {
                this.classList.remove('is-invalid', 'is-valid');
                // Default padding for toggle button only
                this.style.paddingRight = '40px';
            }
        });
    }

    // ========================================
    // 6. VERIFICATION CODE INPUT
    // ========================================

    /**
     * Auto-format verification code input
     */
    function enhanceVerificationCodeInput() {
        const codeInput = document.querySelector('input[name="code"]');
        
        if (!codeInput) return;
        
        // Format as user types
        codeInput.addEventListener('input', function() {
            // Remove non-digits
            this.value = this.value.replace(/[^0-9]/g, '');
            
            // Limit to 6 digits
            if (this.value.length > 6) {
                this.value = this.value.slice(0, 6);
            }
            
            // Auto-submit when 6 digits entered (optional)
            if (this.value.length === 6 && this.hasAttribute('data-auto-submit')) {
                setTimeout(() => {
                    this.form.submit();
                }, 300);
            }
        });
        
        // Allow paste
        codeInput.addEventListener('paste', function(e) {
            e.preventDefault();
            const pastedText = (e.clipboardData || window.clipboardData).getData('text');
            const digits = pastedText.replace(/[^0-9]/g, '').slice(0, 6);
            this.value = digits;
            this.dispatchEvent(new Event('input'));
        });
    }

    // ========================================
    // 7. REMEMBER ME TOOLTIP
    // ========================================

    /**
     * Add helpful tooltip to remember me checkbox
     */
    function enhanceRememberMe() {
        const rememberCheckbox = document.querySelector('input[name="remember"]');
        
        if (!rememberCheckbox) return;
        
        const label = rememberCheckbox.closest('label') || rememberCheckbox.nextElementSibling;
        if (label && !label.hasAttribute('title')) {
            label.setAttribute('title', 'Bạn sẽ tự động đăng nhập trong 3 ngày tới');
            label.setAttribute('data-bs-toggle', 'tooltip');
            
            // Initialize tooltip if Bootstrap is available
            if (typeof bootstrap !== 'undefined' && bootstrap.Tooltip) {
                new bootstrap.Tooltip(label);
            }
        }
    }

    // ========================================
    // INITIALIZATION
    // ========================================

    function init() {
        // Prevent multiple initializations
        if (window.authEnhancementsInitialized) {
            console.log('⚠️ Auth enhancements already initialized, skipping...');
            return;
        }
        
        // Wait for DOM to be ready
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', init);
            return;
        }
        
        // Mark as initialized
        window.authEnhancementsInitialized = true;
        
        // Run all enhancements
        enhanceFormSubmission();
        autoHideAlerts();
        autoFocusFirstInput();
        enhancePasswordInputs();
        addPasswordStrengthIndicator();
        enhanceAccountInput();
        enhancePasswordConfirmation();
        enhanceVerificationCodeInput();
        enhanceRememberMe();
        
        console.log('✅ Auth enhancements loaded');
    }

    // Start initialization
    init();
})();

