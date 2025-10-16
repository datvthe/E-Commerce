-- Complete Database Schema for Gicungco Digital Goods Marketplace
-- This file contains all necessary tables for the marketplace

-- Create database
CREATE DATABASE IF NOT EXISTS gicungco;
USE gicungco;

-- ========================================
-- CORE TABLES
-- ========================================

-- Drop existing tables if they exist (in correct order due to foreign keys)
DROP TABLE IF EXISTS `order_items`;
DROP TABLE IF EXISTS `orders`;
DROP TABLE IF EXISTS `reviews`;
DROP TABLE IF EXISTS `wishlist`;
DROP TABLE IF EXISTS `digital_goods_codes`;
DROP TABLE IF EXISTS `digital_goods_files`;
DROP TABLE IF EXISTS `product_images`;
DROP TABLE IF EXISTS `inventory`;
DROP TABLE IF EXISTS `products`;
DROP TABLE IF EXISTS `product_categories`;
DROP TABLE IF EXISTS `password_reset`;
DROP TABLE IF EXISTS `user_roles`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `roles`;

-- Create Users table
CREATE TABLE `users` (
    `user_id` BIGINT NOT NULL AUTO_INCREMENT,
    `full_name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(150) NOT NULL UNIQUE,
    `password_hash` LONGTEXT NOT NULL,
    `phone_number` VARCHAR(20) DEFAULT NULL,
    `gender` ENUM('male','female','other') DEFAULT NULL,
    `date_of_birth` DATE DEFAULT NULL,
    `address` LONGTEXT DEFAULT NULL,
    `avatar_url` LONGTEXT DEFAULT NULL,
    `default_role` VARCHAR(50) DEFAULT NULL,
    `status` ENUM('active','inactive','banned','pending') DEFAULT 'pending',
    `email_verified` BOOLEAN DEFAULT FALSE,
    `last_login_at` DATETIME DEFAULT NULL,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` DATETIME DEFAULT NULL,
    PRIMARY KEY (`user_id`),
    UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Roles table
CREATE TABLE `roles` (
    `role_id` INT NOT NULL AUTO_INCREMENT,
    `role_name` VARCHAR(50) NOT NULL UNIQUE,
    `description` LONGTEXT DEFAULT NULL,
    PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create User_Roles table
CREATE TABLE `user_roles` (
    `user_role_id` BIGINT NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL,
    `role_id` INT NOT NULL,
    `assigned_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`user_role_id`),
    KEY `user_id` (`user_id`),
    KEY `role_id` (`role_id`),
    CONSTRAINT `user_roles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
    CONSTRAINT `user_roles_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Product_Categories table
CREATE TABLE `product_categories` (
    `category_id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `slug` VARCHAR(100) NOT NULL UNIQUE,
    `description` TEXT DEFAULT NULL,
    `parent_id` INT DEFAULT NULL,
    `is_active` BOOLEAN DEFAULT TRUE,
    `is_digital` BOOLEAN DEFAULT TRUE,
    `icon` VARCHAR(100) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`category_id`),
    KEY `parent_id` (`parent_id`),
    CONSTRAINT `product_categories_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `product_categories` (`category_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Products table
CREATE TABLE `products` (
    `product_id` BIGINT NOT NULL AUTO_INCREMENT,
    `seller_id` BIGINT NOT NULL,
    `name` VARCHAR(150) NOT NULL,
    `slug` VARCHAR(200) DEFAULT NULL,
    `description` TEXT DEFAULT NULL,
    `price` DECIMAL(15,2) NOT NULL,
    `currency` VARCHAR(10) DEFAULT 'VND',
    `category_id` INT DEFAULT NULL,
    `is_digital` BOOLEAN DEFAULT TRUE,
    `delivery_type` ENUM('instant', 'manual', 'email') DEFAULT 'instant',
    `delivery_time` VARCHAR(50) DEFAULT 'Tức thì',
    `warranty_days` INT DEFAULT 7,
    `status` ENUM('draft','pending','approved','rejected','active','inactive') DEFAULT 'pending',
    `average_rating` DECIMAL(3,2) DEFAULT 0.00,
    `total_reviews` INT DEFAULT 0,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` DATETIME DEFAULT NULL,
    PRIMARY KEY (`product_id`),
    UNIQUE KEY `slug` (`slug`),
    KEY `seller_id` (`seller_id`),
    KEY `category_id` (`category_id`),
    CONSTRAINT `products_ibfk_1` FOREIGN KEY (`seller_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
    CONSTRAINT `products_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `product_categories` (`category_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Product_Images table
CREATE TABLE `product_images` (
    `image_id` BIGINT NOT NULL AUTO_INCREMENT,
    `product_id` BIGINT NOT NULL,
    `url` LONGTEXT NOT NULL,
    `alt_text` LONGTEXT DEFAULT NULL,
    `is_primary` BOOLEAN DEFAULT FALSE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`image_id`),
    KEY `product_id` (`product_id`),
    CONSTRAINT `product_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Digital_Goods_Codes table
CREATE TABLE `digital_goods_codes` (
    `code_id` INT NOT NULL AUTO_INCREMENT,
    `product_id` BIGINT NOT NULL,
    `code_value` TEXT NOT NULL,
    `code_type` ENUM('serial', 'account', 'license', 'gift_card', 'file_url') NOT NULL,
    `is_used` BOOLEAN DEFAULT FALSE,
    `used_by` BIGINT DEFAULT NULL,
    `used_at` TIMESTAMP NULL,
    `expires_at` TIMESTAMP NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`code_id`),
    KEY `product_id` (`product_id`),
    KEY `is_used` (`is_used`),
    KEY `used_by` (`used_by`),
    CONSTRAINT `digital_goods_codes_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
    CONSTRAINT `digital_goods_codes_ibfk_2` FOREIGN KEY (`used_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Digital_Goods_Files table
CREATE TABLE `digital_goods_files` (
    `file_id` INT NOT NULL AUTO_INCREMENT,
    `product_id` BIGINT NOT NULL,
    `file_name` VARCHAR(255) NOT NULL,
    `file_path` VARCHAR(500) NOT NULL,
    `file_size` BIGINT DEFAULT NULL,
    `file_type` VARCHAR(100) DEFAULT NULL,
    `download_count` INT DEFAULT 0,
    `max_downloads` INT DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`file_id`),
    KEY `product_id` (`product_id`),
    CONSTRAINT `digital_goods_files_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Inventory table
CREATE TABLE `inventory` (
    `inventory_id` BIGINT NOT NULL AUTO_INCREMENT,
    `product_id` BIGINT NOT NULL,
    `seller_id` BIGINT NOT NULL,
    `quantity` INT DEFAULT 0,
    `reserved_quantity` INT DEFAULT 0,
    `min_threshold` INT DEFAULT 0,
    `last_restocked_at` DATETIME DEFAULT NULL,
    PRIMARY KEY (`inventory_id`),
    KEY `product_id` (`product_id`),
    KEY `seller_id` (`seller_id`),
    CONSTRAINT `inventory_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
    CONSTRAINT `inventory_ibfk_2` FOREIGN KEY (`seller_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Orders table
CREATE TABLE `orders` (
    `order_id` BIGINT NOT NULL AUTO_INCREMENT,
    `buyer_id` BIGINT NOT NULL,
    `seller_id` BIGINT NOT NULL,
    `order_number` VARCHAR(50) NOT NULL UNIQUE,
    `total_amount` DECIMAL(15,2) NOT NULL,
    `currency` VARCHAR(10) DEFAULT 'VND',
    `status` ENUM('pending', 'paid', 'delivered', 'cancelled', 'refunded') DEFAULT 'pending',
    `payment_method` VARCHAR(50) DEFAULT NULL,
    `payment_reference` VARCHAR(100) DEFAULT NULL,
    `delivery_status` ENUM('pending', 'processing', 'delivered', 'failed') DEFAULT 'pending',
    `delivery_method` VARCHAR(50) DEFAULT 'digital',
    `notes` TEXT DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`order_id`),
    KEY `buyer_id` (`buyer_id`),
    KEY `seller_id` (`seller_id`),
    KEY `order_number` (`order_number`),
    KEY `status` (`status`),
    CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`buyer_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
    CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`seller_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Order_Items table
CREATE TABLE `order_items` (
    `order_item_id` BIGINT NOT NULL AUTO_INCREMENT,
    `order_id` BIGINT NOT NULL,
    `product_id` BIGINT NOT NULL,
    `quantity` INT NOT NULL DEFAULT 1,
    `unit_price` DECIMAL(15,2) NOT NULL,
    `total_price` DECIMAL(15,2) NOT NULL,
    `digital_code_id` INT DEFAULT NULL,
    `delivery_status` ENUM('pending', 'delivered', 'failed') DEFAULT 'pending',
    `delivered_at` TIMESTAMP NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`order_item_id`),
    KEY `order_id` (`order_id`),
    KEY `product_id` (`product_id`),
    KEY `digital_code_id` (`digital_code_id`),
    CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
    CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
    CONSTRAINT `order_items_ibfk_3` FOREIGN KEY (`digital_code_id`) REFERENCES `digital_goods_codes` (`code_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Reviews table
CREATE TABLE `reviews` (
    `review_id` BIGINT NOT NULL AUTO_INCREMENT,
    `product_id` BIGINT NOT NULL,
    `buyer_id` BIGINT NOT NULL,
    `rating` TINYINT DEFAULT NULL,
    `comment` TEXT DEFAULT NULL,
    `images` JSON DEFAULT NULL,
    `status` ENUM('visible','hidden','flagged') DEFAULT 'visible',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`review_id`),
    KEY `product_id` (`product_id`),
    KEY `buyer_id` (`buyer_id`),
    CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
    CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`buyer_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
    CONSTRAINT `reviews_chk_1` CHECK (`rating` BETWEEN 1 AND 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Wishlist table
CREATE TABLE `wishlist` (
    `wishlist_id` INT NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL,
    `product_id` BIGINT NOT NULL,
    `added_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`wishlist_id`),
    UNIQUE KEY `user_product` (`user_id`, `product_id`),
    KEY `user_id` (`user_id`),
    KEY `product_id` (`product_id`),
    CONSTRAINT `wishlist_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
    CONSTRAINT `wishlist_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Password_Reset table
CREATE TABLE `password_reset` (
    `reset_id` INT NOT NULL AUTO_INCREMENT,
    `email` VARCHAR(150) NOT NULL,
    `verification_code` VARCHAR(10) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `expires_at` TIMESTAMP NOT NULL,
    `used` BOOLEAN DEFAULT FALSE,
    `used_at` TIMESTAMP NULL,
    PRIMARY KEY (`reset_id`),
    KEY `email` (`email`),
    KEY `verification_code` (`verification_code`),
    KEY `expires_at` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- INSERT SAMPLE DATA
-- ========================================

-- Insert roles
INSERT INTO `roles` (`role_name`, `description`) VALUES
('admin', 'System administrator with full access'),
('seller', 'Can create and manage products'),
('customer', 'Regular user who can make purchases'),
('moderator', 'Can moderate content and users');

-- Insert users with hashed passwords
INSERT INTO `users` (`full_name`, `email`, `password_hash`, `phone_number`, `gender`, `date_of_birth`, `address`, `status`, `email_verified`, `created_at`, `updated_at`) VALUES
('Admin User', 'admin@example.com', '43Uo6E1/2ZcZl7yA5UR1jEPsyU7uznmLRHWhbQ0IgYA=:n1NxeFQRRJR2NLWkC0Qp2Q==', '0901234567', 'male', '1990-01-01', 'Ha Noi, Vietnam', 'active', TRUE, NOW(), NOW()),
('Seller One', 'seller1@example.com', 'GnhFhFHEhHYamueG4UwSHG64spFo1/FwoCaE3KPdVLU=:wqMm7NhbRXCUP2DTWCDuPg==', '0901234568', 'female', '1992-03-15', 'Ho Chi Minh City, Vietnam', 'active', TRUE, NOW(), NOW()),
('Customer One', 'customer1@example.com', 'pDockmjy4Xv+AAi+K9bxHv6tPydWGqYMssCPHxK4tWM=:rkFBp4YkQ3ruY9+whLbT8A==', '0901234569', 'male', '1995-06-20', 'Da Nang, Vietnam', 'active', TRUE, NOW(), NOW()),
('Moderator One', 'moderator1@example.com', 'M9wB1bI/rGEoW+UlERiUni4FYf+QsRinlm7JH7MbQ0s=:g2JFRHHKdoePUBVm+95wlw==', '0901234570', 'female', '1988-12-10', 'Can Tho, Vietnam', 'active', TRUE, NOW(), NOW());

-- Insert user roles
INSERT INTO `user_roles` (`user_id`, `role_id`, `assigned_at`) VALUES
(1, 1, NOW()), -- Admin
(2, 2, NOW()), -- Seller
(3, 3, NOW()), -- Customer
(4, 4, NOW()); -- Moderator

-- Insert digital goods categories
INSERT INTO `product_categories` (`name`, `slug`, `description`, `is_digital`, `icon`) VALUES
('Thẻ cào', 'the-cao', 'Thẻ cào điện thoại, internet, game', TRUE, 'fas fa-gift'),
('Tài khoản Game', 'tai-khoan-game', 'Tài khoản game, tài khoản premium', TRUE, 'fas fa-user-circle'),
('Phần mềm', 'phan-mem', 'Phần mềm, ứng dụng, license', TRUE, 'fas fa-download'),
('App & Tools', 'app-tools', 'Ứng dụng di động, công cụ', TRUE, 'fas fa-mobile-alt'),
('Code & Script', 'code-script', 'Mã nguồn, script, template', TRUE, 'fas fa-file-code'),
('Media & Content', 'media-content', 'Hình ảnh, video, âm thanh', TRUE, 'fas fa-music'),
('Dịch vụ số', 'dich-vu-so', 'Dịch vụ online, hosting, domain', TRUE, 'fas fa-server'),
('Khóa học', 'khoa-hoc', 'Khóa học online, ebook', TRUE, 'fas fa-graduation-cap');

-- Insert sample digital goods products
INSERT INTO `products` (`seller_id`, `name`, `slug`, `description`, `price`, `currency`, `category_id`, `is_digital`, `delivery_type`, `delivery_time`, `warranty_days`, `status`, `average_rating`, `total_reviews`, `created_at`, `updated_at`) VALUES
(2, 'Thẻ cào Viettel 100K', 'the-cao-viettel-100k', 'Thẻ cào Viettel mệnh giá 100,000 VNĐ. Giao ngay sau khi thanh toán.', 95000, 'VND', 1, TRUE, 'instant', 'Tức thì', 7, 'active', 4.8, 156, NOW(), NOW()),
(2, 'Tài khoản PUBG Mobile VIP', 'tai-khoan-pubg-mobile-vip', 'Tài khoản PUBG Mobile cấp VIP với skin hiếm và vũ khí mạnh. Đảm bảo 100% chính chủ.', 250000, 'VND', 2, TRUE, 'instant', 'Tức thì', 7, 'active', 4.5, 89, NOW(), NOW()),
(2, 'Adobe Photoshop 2024 Full', 'adobe-photoshop-2024-full', 'Phần mềm Adobe Photoshop 2024 bản full với license vĩnh viễn. Hỗ trợ cài đặt 24/7.', 1500000, 'VND', 3, TRUE, 'instant', 'Tức thì', 30, 'active', 4.9, 234, NOW(), NOW()),
(2, 'Premium App Bundle', 'premium-app-bundle', 'Gói ứng dụng premium bao gồm: Spotify, Netflix, YouTube Premium, Canva Pro. Thời hạn 1 tháng.', 500000, 'VND', 4, TRUE, 'instant', 'Tức thì', 7, 'active', 4.6, 78, NOW(), NOW()),
(2, 'Thẻ cào VinaPhone 200K', 'the-cao-vinaphone-200k', 'Thẻ cào VinaPhone mệnh giá 200,000 VNĐ. Tích điểm và nhận ưu đãi.', 195000, 'VND', 1, TRUE, 'instant', 'Tức thì', 7, 'active', 4.7, 123, NOW(), NOW()),
(2, 'Tài khoản Genshin Impact', 'tai-khoan-genshin-impact', 'Tài khoản Genshin Impact cấp cao với nhân vật 5 sao và vũ khí mạnh. Server Asia.', 800000, 'VND', 2, TRUE, 'instant', 'Tức thì', 7, 'active', 4.4, 67, NOW(), NOW()),
(2, 'Microsoft Office 2024', 'microsoft-office-2024', 'Bộ Microsoft Office 2024 full bao gồm Word, Excel, PowerPoint, Outlook. License vĩnh viễn.', 2000000, 'VND', 3, TRUE, 'instant', 'Tức thì', 30, 'active', 4.8, 145, NOW(), NOW()),
(2, 'Template Website Responsive', 'template-website-responsive', 'Bộ template website responsive HTML/CSS/JS. Bao gồm 10 mẫu đẹp và code sạch.', 300000, 'VND', 5, TRUE, 'instant', 'Tức thì', 7, 'active', 4.6, 45, NOW(), NOW());

-- Insert sample product images
INSERT INTO `product_images` (`product_id`, `url`, `alt_text`, `is_primary`) VALUES
(1, '/views/assets/electro/img/product-1.png', 'Thẻ cào Viettel 100K', TRUE),
(2, '/views/assets/electro/img/product-2.png', 'Tài khoản PUBG Mobile VIP', TRUE),
(3, '/views/assets/electro/img/product-3.png', 'Adobe Photoshop 2024', TRUE),
(4, '/views/assets/electro/img/product-4.png', 'Premium App Bundle', TRUE),
(5, '/views/assets/electro/img/product-5.png', 'Thẻ cào VinaPhone 200K', TRUE),
(6, '/views/assets/electro/img/product-1.png', 'Tài khoản Genshin Impact', TRUE),
(7, '/views/assets/electro/img/product-2.png', 'Microsoft Office 2024', TRUE),
(8, '/views/assets/electro/img/product-3.png', 'Template Website', TRUE);

-- Insert sample inventory
INSERT INTO `inventory` (`product_id`, `seller_id`, `quantity`, `reserved_quantity`, `min_threshold`) VALUES
(1, 2, 1000, 0, 50),
(2, 2, 50, 0, 5),
(3, 2, 200, 0, 10),
(4, 2, 100, 0, 10),
(5, 2, 500, 0, 25),
(6, 2, 30, 0, 3),
(7, 2, 150, 0, 15),
(8, 2, 80, 0, 8);

-- Insert sample digital codes
INSERT INTO `digital_goods_codes` (`product_id`, `code_value`, `code_type`, `is_used`) VALUES
-- Viettel 100K cards
(1, 'VT100K001234567890', 'gift_card', FALSE),
(1, 'VT100K001234567891', 'gift_card', FALSE),
(1, 'VT100K001234567892', 'gift_card', FALSE),
(1, 'VT100K001234567893', 'gift_card', FALSE),
(1, 'VT100K001234567894', 'gift_card', FALSE),
-- PUBG Mobile accounts
(2, 'PUBG_ACCOUNT_001:Username:Player123|Password:Pass456|Level:50|Skins:RoyalPass', 'account', FALSE),
(2, 'PUBG_ACCOUNT_002:Username:ProGamer|Password:Game789|Level:45|Skins:ElitePass', 'account', FALSE),
(2, 'PUBG_ACCOUNT_003:Username:Winner2024|Password:Win123|Level:60|Skins:Premium', 'account', FALSE),
-- Adobe Photoshop licenses
(3, 'ADOBE_PS_2024_001:Serial:1234-5678-9012-3456|Activation:Online', 'license', FALSE),
(3, 'ADOBE_PS_2024_002:Serial:2345-6789-0123-4567|Activation:Online', 'license', FALSE),
(3, 'ADOBE_PS_2024_003:Serial:3456-7890-1234-5678|Activation:Online', 'license', FALSE),
-- App Bundle accounts
(4, 'APP_BUNDLE_001:Spotify:user1@email.com|Netflix:user1@email.com|YouTube:user1@email.com|Canva:user1@email.com', 'account', FALSE),
(4, 'APP_BUNDLE_002:Spotify:user2@email.com|Netflix:user2@email.com|YouTube:user2@email.com|Canva:user2@email.com', 'account', FALSE),
-- VinaPhone 200K cards
(5, 'VP200K001234567890', 'gift_card', FALSE),
(5, 'VP200K001234567891', 'gift_card', FALSE),
(5, 'VP200K001234567892', 'gift_card', FALSE),
-- Genshin Impact accounts
(6, 'GENSHIN_ACCOUNT_001:Username:GenshinPlayer|Password:Gen123|AR:55|Characters:5Star|Weapons:Legendary', 'account', FALSE),
(6, 'GENSHIN_ACCOUNT_002:Username:AnemoMaster|Password:Wind456|AR:50|Characters:5Star|Weapons:Epic', 'account', FALSE),
-- Microsoft Office licenses
(7, 'MS_OFFICE_2024_001:ProductKey:XXXXX-XXXXX-XXXXX-XXXXX-XXXXX|Activation:Online', 'license', FALSE),
(7, 'MS_OFFICE_2024_002:ProductKey:YYYYY-YYYYY-YYYYY-YYYYY-YYYYY|Activation:Online', 'license', FALSE),
-- Template files
(8, 'https://download.example.com/template-bundle-001.zip', 'file_url', FALSE),
(8, 'https://download.example.com/template-bundle-002.zip', 'file_url', FALSE);

-- Create indexes for better performance
CREATE INDEX `idx_products_status` ON `products` (`status`);
CREATE INDEX `idx_products_seller` ON `products` (`seller_id`);
CREATE INDEX `idx_products_category` ON `products` (`category_id`);
CREATE INDEX `idx_products_digital` ON `products` (`is_digital`);
CREATE INDEX `idx_products_delivery` ON `products` (`delivery_type`);
CREATE INDEX `idx_wishlist_user` ON `wishlist` (`user_id`);
CREATE INDEX `idx_reviews_product` ON `reviews` (`product_id`);
CREATE INDEX `idx_reviews_status` ON `reviews` (`status`);
CREATE INDEX `idx_digital_codes_product` ON `digital_goods_codes` (`product_id`);
CREATE INDEX `idx_digital_codes_used` ON `digital_goods_codes` (`is_used`);
CREATE INDEX `idx_digital_files_product` ON `digital_goods_files` (`product_id`);

-- ========================================
-- DIGITAL GOODS MARKETPLACE SETUP COMPLETE!
-- ========================================
-- This database is now optimized for selling digital goods (tài nguyên online)
-- Features included:
-- ✅ Digital product categories
-- ✅ Digital codes management  
-- ✅ File downloads
-- ✅ Order management
-- ✅ Inventory tracking
-- ✅ User wishlist
-- ✅ Product reviews
-- ✅ Digital delivery system
-- ✅ Hashed passwords for security
-- ✅ Multi-vendor marketplace support
-- ✅ Password reset functionality

-- Test login credentials:
-- Admin: admin@example.com / admin123
-- Seller: seller1@example.com / seller123  
-- Customer: customer1@example.com / customer123
-- Moderator: moderator1@example.com / moderator123
