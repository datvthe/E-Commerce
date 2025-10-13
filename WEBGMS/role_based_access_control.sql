-- Role-Based Access Control Database Setup
-- Run this script to create the roles table and insert default roles

-- Create Roles table if it doesn't exist
CREATE TABLE IF NOT EXISTS `Roles` (
    `role_id` INT NOT NULL AUTO_INCREMENT,
    `role_name` VARCHAR(50) NOT NULL UNIQUE,
    `description` TEXT DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create User_Roles table if it doesn't exist
CREATE TABLE IF NOT EXISTS `User_Roles` (
    `user_role_id` INT NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL,
    `role_id` INT NOT NULL,
    `assigned_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`user_role_id`),
    UNIQUE KEY `user_role_unique` (`user_id`, `role_id`),
    KEY `user_id` (`user_id`),
    KEY `role_id` (`role_id`),
    CONSTRAINT `user_roles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`) ON DELETE CASCADE,
    CONSTRAINT `user_roles_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `Roles` (`role_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default roles
INSERT INTO `Roles` (`role_id`, `role_name`, `description`) VALUES
(1, 'admin', 'Quản trị viên hệ thống - có quyền truy cập tất cả chức năng'),
(2, 'seller', 'Người bán - có quyền quản lý sản phẩm và đơn hàng của mình'),
(3, 'manager', 'Quản lý - có quyền quản lý người dùng và đơn hàng'),
(4, 'customer', 'Khách hàng - có quyền mua sắm và quản lý đơn hàng của mình'),
(5, 'guest', 'Khách - chỉ có quyền xem sản phẩm và đăng ký tài khoản')
ON DUPLICATE KEY UPDATE 
    `description` = VALUES(`description`),
    `updated_at` = CURRENT_TIMESTAMP;

-- Create User_Tokens table for remember me functionality
CREATE TABLE IF NOT EXISTS `User_Tokens` (
    `token_id` INT NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL,
    `token` VARCHAR(255) NOT NULL UNIQUE,
    `expiry` TIMESTAMP NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`token_id`),
    KEY `user_id` (`user_id`),
    KEY `token` (`token`),
    KEY `expiry` (`expiry`),
    CONSTRAINT `user_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS `idx_user_roles_user` ON `User_Roles` (`user_id`);
CREATE INDEX IF NOT EXISTS `idx_user_roles_role` ON `User_Roles` (`role_id`);
CREATE INDEX IF NOT EXISTS `idx_roles_name` ON `Roles` (`role_name`);

-- Insert sample admin user (if not exists)
-- Note: You should change the password hash for production
INSERT IGNORE INTO `Users` (`user_id`, `full_name`, `email`, `password`, `phone_number`, `status`, `email_verified`, `created_at`) VALUES
(1, 'System Administrator', 'admin@gicungco.com', 'admin123', '0123456789', 'active', 1, NOW());

-- Assign admin role to the admin user
INSERT IGNORE INTO `User_Roles` (`user_id`, `role_id`, `assigned_at`) VALUES
(1, 1, NOW());

-- Insert sample seller user (if not exists)
INSERT IGNORE INTO `Users` (`user_id`, `full_name`, `email`, `password`, `phone_number`, `status`, `email_verified`, `created_at`) VALUES
(2, 'Sample Seller', 'seller@gicungco.com', 'seller123', '0987654321', 'active', 1, NOW());

-- Assign seller role to the seller user
INSERT IGNORE INTO `User_Roles` (`user_id`, `role_id`, `assigned_at`) VALUES
(2, 2, NOW());

-- Insert sample manager user (if not exists)
INSERT IGNORE INTO `Users` (`user_id`, `full_name`, `email`, `password`, `phone_number`, `status`, `email_verified`, `created_at`) VALUES
(3, 'Sample Manager', 'manager@gicungco.com', 'manager123', '0555666777', 'active', 1, NOW());

-- Assign manager role to the manager user
INSERT IGNORE INTO `User_Roles` (`user_id`, `role_id`, `assigned_at`) VALUES
(3, 3, NOW());

-- Insert sample customer user (if not exists)
INSERT IGNORE INTO `Users` (`user_id`, `full_name`, `email`, `password`, `phone_number`, `status`, `email_verified`, `created_at`) VALUES
(4, 'Sample Customer', 'customer@gicungco.com', 'customer123', '0333444555', 'active', 1, NOW());

-- Assign customer role to the customer user
INSERT IGNORE INTO `User_Roles` (`user_id`, `role_id`, `assigned_at`) VALUES
(4, 4, NOW());

-- Update existing users to have customer role by default (if they don't have any role)
INSERT IGNORE INTO `User_Roles` (`user_id`, `role_id`, `assigned_at`)
SELECT u.user_id, 4, NOW()
FROM `Users` u
LEFT JOIN `User_Roles` ur ON u.user_id = ur.user_id
WHERE ur.user_id IS NULL AND u.user_id > 4;

-- Create role permissions table for fine-grained access control
CREATE TABLE IF NOT EXISTS `Role_Permissions` (
    `permission_id` INT NOT NULL AUTO_INCREMENT,
    `role_id` INT NOT NULL,
    `permission_name` VARCHAR(100) NOT NULL,
    `resource` VARCHAR(100) NOT NULL,
    `action` VARCHAR(50) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`permission_id`),
    UNIQUE KEY `role_permission_unique` (`role_id`, `permission_name`),
    KEY `role_id` (`role_id`),
    CONSTRAINT `role_permissions_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `Roles` (`role_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default permissions for each role
-- Admin permissions (full access)
INSERT INTO `Role_Permissions` (`role_id`, `permission_name`, `resource`, `action`) VALUES
(1, 'admin.dashboard.view', 'dashboard', 'view'),
(1, 'admin.users.manage', 'users', 'manage'),
(1, 'admin.products.manage', 'products', 'manage'),
(1, 'admin.orders.manage', 'orders', 'manage'),
(1, 'admin.reports.view', 'reports', 'view'),
(1, 'admin.settings.manage', 'settings', 'manage');

-- Seller permissions
INSERT INTO `Role_Permissions` (`role_id`, `permission_name`, `resource`, `action`) VALUES
(2, 'seller.dashboard.view', 'dashboard', 'view'),
(2, 'seller.products.manage', 'products', 'manage'),
(2, 'seller.orders.view', 'orders', 'view'),
(2, 'seller.analytics.view', 'analytics', 'view');

-- Manager permissions
INSERT INTO `Role_Permissions` (`role_id`, `permission_name`, `resource`, `action`) VALUES
(3, 'manager.dashboard.view', 'dashboard', 'view'),
(3, 'manager.users.manage', 'users', 'manage'),
(3, 'manager.orders.manage', 'orders', 'manage'),
(3, 'manager.reports.view', 'reports', 'view');

-- Customer permissions
INSERT INTO `Role_Permissions` (`role_id`, `permission_name`, `resource`, `action`) VALUES
(4, 'customer.profile.manage', 'profile', 'manage'),
(4, 'customer.orders.view', 'orders', 'view'),
(4, 'customer.wishlist.manage', 'wishlist', 'manage'),
(4, 'customer.support.access', 'support', 'access');

-- Guest permissions
INSERT INTO `Role_Permissions` (`role_id`, `permission_name`, `resource`, `action`) VALUES
(5, 'guest.products.view', 'products', 'view'),
(5, 'guest.register', 'auth', 'register'),
(5, 'guest.login', 'auth', 'login');

-- Create indexes for permissions
CREATE INDEX IF NOT EXISTS `idx_role_permissions_role` ON `Role_Permissions` (`role_id`);
CREATE INDEX IF NOT EXISTS `idx_role_permissions_resource` ON `Role_Permissions` (`resource`);
CREATE INDEX IF NOT EXISTS `idx_role_permissions_action` ON `Role_Permissions` (`action`);

