-- Script to create digital_goods_codes table if it doesn't exist
-- Run this in your MySQL database: gicungco

USE gicungco;

-- Create Digital_Goods_Codes table for storing digital codes/accounts
CREATE TABLE IF NOT EXISTS `digital_goods_codes` (
    `code_id` INT NOT NULL AUTO_INCREMENT,
    `product_id` BIGINT NOT NULL,
    `code_value` TEXT NOT NULL,
    `code_type` ENUM('serial', 'account', 'license', 'gift_card', 'file_url') NOT NULL,
    `is_used` TINYINT(1) DEFAULT 0,
    `used_by` BIGINT DEFAULT NULL,
    `used_at` TIMESTAMP NULL DEFAULT NULL,
    `expires_at` TIMESTAMP NULL DEFAULT NULL,
    `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`code_id`),
    KEY `product_id` (`product_id`),
    KEY `is_used` (`is_used`),
    KEY `used_by` (`used_by`),
    CONSTRAINT `digital_goods_codes_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
    CONSTRAINT `digital_goods_codes_ibfk_2` FOREIGN KEY (`used_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Verify table was created
SELECT 'Table digital_goods_codes created successfully!' AS Status;


