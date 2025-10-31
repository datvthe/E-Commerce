-- ================================================
-- 🔐 ĐỔI PASSWORD CHO USER ID 1 VÀ 2 (SHA-256)
-- Password: 12345678
-- Format: hash:salt
-- ================================================

USE gicungco;

-- SHA-256 hash của "12345678" với salt
-- Sử dụng cùng 1 hash cho cả 2 user để dễ quản lý

-- Hash được generate từ PasswordUtil (SHA-256 + Salt)
SET @password_hash = 'B5r2I8p2r1tviItrHsCXcAxcGsGu9dAqiuzSxZ8UAgk=:xr2txyHfcMY95HhhLpEvlQ==';

-- Cập nhật password cho User ID 1
UPDATE users 
SET password_hash = @password_hash
WHERE user_id = 1;

-- Cập nhật password cho User ID 2
UPDATE users 
SET password_hash = @password_hash
WHERE user_id = 2;

-- ================================================
-- KIỂM TRA KẾT QUẢ
-- ================================================

SELECT 
    user_id,
    email,
    full_name,
    password_hash,
    role
FROM users
WHERE user_id IN (1, 2);

-- ================================================
-- THÔNG TIN LOGIN
-- ================================================
-- User ID 1: admin@example.com / 12345678
-- User ID 2: seller1@example.com / 12345678
-- 
-- Format: hash:salt (SHA-256)
-- Hash: B5r2I8p2r1tviItrHsCXcAxcGsGu9dAqiuzSxZ8UAgk=
-- Salt: xr2txyHfcMY95HhhLpEvlQ==
-- ================================================

