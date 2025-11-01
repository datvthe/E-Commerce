-- ================================================
-- 📧 EMAIL VERIFICATION TABLE
-- ================================================
-- Purpose: Store verification codes for email verification during registration
-- Reusing pattern from password_reset table
-- ================================================

USE gicungco;

-- Create email_verification table (similar structure to password_reset)
CREATE TABLE IF NOT EXISTS email_verification (
    verification_id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL,
    verification_code CHAR(6) NOT NULL COMMENT '6-digit code',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL COMMENT 'Code expires after 15 minutes',
    used BOOLEAN DEFAULT FALSE COMMENT 'Whether code has been used',
    used_at TIMESTAMP NULL COMMENT 'When code was used',
    
    INDEX idx_email (email),
    INDEX idx_code (verification_code),
    INDEX idx_expires (expires_at),
    INDEX idx_used (used)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Email verification codes for registration';

-- ================================================
-- CLEANUP: Delete expired verification codes older than 1 hour
-- ================================================
CREATE EVENT IF NOT EXISTS cleanup_expired_email_verifications
ON SCHEDULE EVERY 1 HOUR
DO
    DELETE FROM email_verification 
    WHERE expires_at < DATE_SUB(NOW(), INTERVAL 1 HOUR);

-- Enable event scheduler
SET GLOBAL event_scheduler = ON;

-- ================================================
-- ✅ DONE!
-- ================================================

