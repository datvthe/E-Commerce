-- ================================================
-- INSERT ADMIN ACCOUNT - SIMPLE VERSION
-- ================================================
USE gicungco;

-- Insert admin với PLAIN PASSWORD
-- Hệ thống sẽ tự động hash lần đầu login
INSERT INTO users (
    email, 
    password_hash, 
    full_name, 
    phone_number, 
    default_role, 
    email_verified,
    status,
    created_at
) 
SELECT 
    'admin@gicungco.com',
    'admin123',  -- Plain text password, sẽ tự hash lần đầu login
    'Administrator',
    '0123456789',
    'admin',
    1,
    'active',
    NOW()
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM users WHERE email = 'admin@gicungco.com'
);

-- Verify admin created
SELECT 
    user_id,
    email,
    full_name,
    password_hash,
    default_role,
    email_verified,
    status
FROM users 
WHERE email = 'admin@gicungco.com';

-- ================================================
-- THÔNG TIN ĐĂNG NHẬP
-- ================================================
-- Email: admin@gicungco.com
-- Password: admin123
-- ================================================

