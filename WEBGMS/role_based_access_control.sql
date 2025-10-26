-- Role-Based Access Control Database Setup (aligned with application code)
USE gicungco;

-- Roles table (lowercase)
CREATE TABLE IF NOT EXISTS `roles` (
    `role_id` INT NOT NULL AUTO_INCREMENT,
    `role_name` VARCHAR(50) NOT NULL UNIQUE,
    `description` TEXT DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- User roles table (lowercase)
CREATE TABLE IF NOT EXISTS `user_roles` (
    `user_role_id` BIGINT NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL,
    `role_id` INT NOT NULL,
    `assigned_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`user_role_id`),
    UNIQUE KEY `user_role_unique` (`user_id`, `role_id`),
    KEY `user_id` (`user_id`),
    KEY `role_id` (`role_id`),
    CONSTRAINT `user_roles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
    CONSTRAINT `user_roles_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Seed default roles with expected IDs
INSERT INTO `roles` (`role_id`, `role_name`, `description`) VALUES
(1, 'admin', 'Quản trị viên hệ thống'),
(2, 'seller', 'Người bán'),
(3, 'customer', 'Khách hàng'),
(4, 'moderator', 'Kiểm duyệt')
ON DUPLICATE KEY UPDATE 
    `description` = VALUES(`description`),
    `updated_at` = CURRENT_TIMESTAMP;

-- Remember-me store used by CommonLoginController
CREATE TABLE IF NOT EXISTS `auth_sessions` (
    `session_id` BIGINT NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL,
    `access_token` VARCHAR(255) NOT NULL UNIQUE,
    `login_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`session_id`),
    KEY `user_id` (`user_id`),
    CONSTRAINT `auth_sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Index helpers
CREATE INDEX IF NOT EXISTS `idx_user_roles_user` ON `user_roles` (`user_id`);
CREATE INDEX IF NOT EXISTS `idx_user_roles_role` ON `user_roles` (`role_id`);
CREATE INDEX IF NOT EXISTS `idx_roles_name` ON `roles` (`role_name`);

