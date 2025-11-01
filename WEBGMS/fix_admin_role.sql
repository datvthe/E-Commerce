-- ================================================
-- FIX: Xóa role customer, chỉ giữ admin
-- ================================================
USE gicungco;

-- Lấy user_id của eris2004dk@gmail.com
SELECT @user_id := user_id FROM users WHERE email = 'eris2004dk@gmail.com';

-- Hiển thị user_id để kiểm tra
SELECT @user_id as user_id;

-- Xóa TẤT CẢ roles cũ của user này
DELETE FROM user_roles 
WHERE user_id = @user_id;

-- Insert ADMIN role (role_id = 1)
INSERT INTO user_roles (user_id, role_id, assigned_at)
VALUES (@user_id, 1, NOW());

-- Verify kết quả - PHẢI CHỈ CÓ 1 ROW với admin role
SELECT 
    ur.user_role_id,
    ur.user_id,
    ur.role_id,
    r.role_name,
    u.email,
    u.full_name,
    u.default_role,
    ur.assigned_at
FROM user_roles ur
JOIN users u ON ur.user_id = u.user_id
JOIN roles r ON ur.role_id = r.role_id
WHERE u.email = 'eris2004dk@gmail.com';

-- Kiểm tra final - PHẢI CHỈ THẤY 1 ROW
SELECT COUNT(*) as total_roles, 
       GROUP_CONCAT(r.role_name) as roles
FROM user_roles ur
JOIN roles r ON ur.role_id = r.role_id
WHERE ur.user_id = @user_id;

