-- ================================================
-- 🔐 ĐỔI PASSWORD CHO USER ID 1 VÀ 2
-- Password mới: 12345678
-- ================================================

USE gicungco;

-- BCrypt hash của "12345678" (cost=10)
-- Hash: $2a$10$N9qo8uLOickgx2ZMRZoMye6p.IzEjLJq4j6Y.hklVXHlPBjXq3J8u

-- Cập nhật password cho User ID 1
UPDATE users 
SET password = '$2a$10$N9qo8uLOickgx2ZMRZoMye6p.IzEjLJq4j6Y.hklVXHlPBjXq3J8u'
WHERE user_id = 1;

-- Cập nhật password cho User ID 2
UPDATE users 
SET password = '$2a$10$N9qo8uLOickgx2ZMRZoMye6p.IzEjLJq4j6Y.hklVXHlPBjXq3J8u'
WHERE user_id = 2;

-- ================================================
-- KIỂM TRA KẾT QUẢ
-- ================================================

SELECT 
    user_id,
    email,
    full_name,
    LEFT(password, 20) as password_hash,
    role
FROM users
WHERE user_id IN (1, 2);

-- ================================================
-- THÔNG TIN LOGIN
-- ================================================
-- User ID 1: [email từ database] / 12345678
-- User ID 2: [email từ database] / 12345678
-- ================================================

