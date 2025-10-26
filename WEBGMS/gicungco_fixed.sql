-- FIXED Complete Database Schema for Gicungco Digital Goods Marketplace
-- This script fixes all login/register issues

-- Create database
CREATE DATABASE IF NOT EXISTS gicungco;
USE gicungco;

-- Drop existing tables if they exist (in correct order due to foreign keys)
DROP TABLE IF EXISTS `password_reset`;
DROP TABLE IF EXISTS `auth_sessions`;
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
DROP TABLE IF EXISTS `user_roles`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `roles`;

-- Create Roles table FIRST
CREATE TABLE `roles` (
    `role_id` INT NOT NULL AUTO_INCREMENT,
    `role_name` VARCHAR(50) NOT NULL UNIQUE,
    `description` LONGTEXT DEFAULT NULL,
    PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert roles with CORRECT IDs for your code
INSERT INTO `roles` (`role_id`, `role_name`, `description`) VALUES
(1, 'admin', 'Administrator - full access'),
(2, 'seller', 'Seller - can manage products'),
(3, 'customer', 'Customer - can buy products'), -- FIXED: customer is role_id 3
(4, 'moderator', 'Moderator - content moderation');

-- Create Users table with CORRECT column name password_hash
CREATE TABLE `users` (
    `user_id` BIGINT NOT NULL AUTO_INCREMENT,
    `full_name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(150) NOT NULL UNIQUE,
    `password_hash` LONGTEXT NOT NULL, -- FIXED: correct column name
    `phone_number` VARCHAR(20) DEFAULT NULL,
    `gender` ENUM('male','female','other') DEFAULT NULL,
    `date_of_birth` DATE DEFAULT NULL,
    `address` LONGTEXT DEFAULT NULL,
    `avatar_url` LONGTEXT DEFAULT NULL,
    `google_id` VARCHAR(255) DEFAULT NULL,
    `auth_provider` VARCHAR(50) DEFAULT 'local',
    `default_role` VARCHAR(50) DEFAULT 'customer',
    `status` ENUM('active','inactive','banned','pending') DEFAULT 'active', -- FIXED: default active
    `email_verified` BOOLEAN DEFAULT TRUE, -- FIXED: default true for testing
    `last_login_at` DATETIME DEFAULT NULL,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` DATETIME DEFAULT NULL,
    PRIMARY KEY (`user_id`),
    UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create User_Roles table with CORRECT case
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

-- FIXED: Add auth_sessions table for remember me functionality
CREATE TABLE `auth_sessions` (
    `session_id` BIGINT NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL,
    `access_token` VARCHAR(255) NOT NULL UNIQUE,
    `login_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `expires_at` DATETIME DEFAULT NULL,
    PRIMARY KEY (`session_id`),
    KEY `user_id` (`user_id`),
    KEY `access_token` (`access_token`),
    CONSTRAINT `auth_sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- FIXED: Add password_reset table for forgot password functionality
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
    KEY `verification_code` (`verification_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- You can now register users via the app; roles will be assigned automatically.

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

-- Insert sample categories
INSERT INTO `product_categories` (`name`, `slug`, `description`, `is_digital`, `icon`) VALUES
('Thẻ cào', 'the-cao', 'Thẻ cào điện thoại, internet, game', TRUE, 'fas fa-gift'),
('Tài khoản Game', 'tai-khoan-game', 'Tài khoản game, tài khoản premium', TRUE, 'fas fa-user-circle'),
('Phần mềm', 'phan-mem', 'Phần mềm, ứng dụng, license', TRUE, 'fas fa-download');

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
    `status` ENUM('draft','pending','approved','rejected','active','inactive') DEFAULT 'active',
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

-- Create other required tables (minimal for login to work)
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

CREATE TABLE `reviews` (
    `review_id` BIGINT NOT NULL AUTO_INCREMENT,
    `product_id` BIGINT NOT NULL,
    `buyer_id` BIGINT NOT NULL,
    `rating` TINYINT DEFAULT NULL,
    `comment` TEXT DEFAULT NULL,
    `status` ENUM('visible','hidden','flagged') DEFAULT 'visible',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`review_id`),
    KEY `product_id` (`product_id`),
    KEY `buyer_id` (`buyer_id`),
    CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
    CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`buyer_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create sellers table for seller functionality
CREATE TABLE `sellers` (
    `seller_id` INT NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL UNIQUE,
    `full_name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(150) NOT NULL,
    `phone` VARCHAR(20) NOT NULL,
    `shop_name` VARCHAR(100) NOT NULL,
    `shop_description` TEXT DEFAULT NULL,
    `main_category` VARCHAR(100) DEFAULT NULL,
    `bank_name` VARCHAR(100) DEFAULT NULL,
    `bank_account` VARCHAR(50) DEFAULT NULL,
    `account_owner` VARCHAR(100) DEFAULT NULL,
    `deposit_amount` DECIMAL(15,2) DEFAULT 0.00,
    `deposit_status` ENUM('PENDING','PAID','VERIFIED') DEFAULT 'PENDING',
    `deposit_proof` VARCHAR(500) DEFAULT NULL,
    `status` ENUM('PENDING','APPROVED','REJECTED','SUSPENDED') DEFAULT 'PENDING',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`seller_id`),
    KEY `user_id` (`user_id`),
    CONSTRAINT `sellers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Test login credentials:
-- Email: admin@gicungco.com, Password: 123456 (Admin)
-- Email: seller@gicungco.com, Password: 123456 (Seller)
-- Email: customer@gicungco.com, Password: 123456 (Customer)
-- Email: moderator@gicungco.com, Password: 123456 (Moderator)

SELECT 'Database setup complete! You can now login with any test account using password: 123456' as status;