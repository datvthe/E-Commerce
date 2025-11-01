-- ================================================
-- INSERT ADMIN ACCOUNT
-- ================================================
USE gicungco;

-- Kiểm tra xem admin đã tồn tại chưa
SELECT user_id, email, full_name, default_role as role 
FROM users 
WHERE email = 'admin@gicungco.com' OR default_role = 'admin';

-- Nếu chưa có, insert admin mới
-- Password: admin123 (SHA-256 hash)
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
    SHA2('admin123', 256),
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

-- Verify
SELECT 
    user_id,
    email,
    full_name,
    default_role as role,
    email_verified,
    status,
    created_at
FROM users 
WHERE default_role = 'admin' OR email = 'admin@gicungco.com';

-- ================================================
-- THÔNG TIN ĐĂNG NHẬP
-- ================================================
-- Email: admin@gicungco.com
-- Password: admin123
-- Role: admin
-- ==============================================

