-- ================================================
-- UPDATE USER TO ADMIN ROLE
-- ================================================
USE gicungco;

-- Kiểm tra user hiện tại
SELECT 
    user_id,
    email,
    full_name,
    default_role,
    email_verified,
    status
FROM users 
WHERE email = 'eris2004dk@gmail.com';

-- Update thành admin trong bảng users
UPDATE users 
SET 
    default_role = 'admin',
    email_verified = 1,
    status = 'active'
WHERE email = 'eris2004dk@gmail.com';

-- Lấy user_id
SET @user_id = (SELECT user_id FROM users WHERE email = 'eris2004dk@gmail.com');

-- Xóa role cũ trong user_roles (nếu có)
DELETE FROM user_roles WHERE user_id = @user_id;

-- Insert admin role vào user_roles
-- role_id = 1 là admin
INSERT INTO user_roles (user_id, role_id, assigned_at)
VALUES (@user_id, 1, NOW());

-- Verify đã update thành công
SELECT 
    u.user_id,
    u.email,
    u.full_name,
    u.default_role,
    u.email_verified,
    u.status,
    r.role_name as role_from_user_roles,
    'Account đã được cập nhật thành Admin!' as message
FROM users u
LEFT JOIN user_roles ur ON u.user_id = ur.user_id
LEFT JOIN roles r ON ur.role_id = r.role_id
WHERE u.email = 'eris2004dk@gmail.com';

-- Kiểm tra tất cả admin
SELECT 
    u.user_id,
    u.email,
    u.full_name,
    u.default_role,
    r.role_name as assigned_role,
    u.status
FROM users u
LEFT JOIN user_roles ur ON u.user_id = ur.user_id
LEFT JOIN roles r ON ur.role_id = r.role_id
WHERE u.default_role = 'admin' OR r.role_name = 'admin';

