-- Missing Database Tables for WEBGMS Project
-- Run this script to create the missing tables

-- Create Cart table
CREATE TABLE IF NOT EXISTS `cart` (
    `cart_id` INT NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL,
    `product_id` BIGINT NOT NULL,
    `quantity` INT NOT NULL DEFAULT 1,
    `added_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`cart_id`),
    KEY `user_id` (`user_id`),
    KEY `product_id` (`product_id`),
    CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
    CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Wishlist table
CREATE TABLE IF NOT EXISTS `wishlist` (
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

-- Create Product_Images table
CREATE TABLE IF NOT EXISTS `product_images` (
    `image_id` INT NOT NULL AUTO_INCREMENT,
    `product_id` BIGINT NOT NULL,
    `url` VARCHAR(500) NOT NULL,
    `alt_text` VARCHAR(255) DEFAULT NULL,
    `is_primary` BOOLEAN DEFAULT FALSE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`image_id`),
    KEY `product_id` (`product_id`),
    CONSTRAINT `product_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Product_Categories table
CREATE TABLE IF NOT EXISTS `product_categories` (
    `category_id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `slug` VARCHAR(100) NOT NULL UNIQUE,
    `description` TEXT DEFAULT NULL,
    `parent_id` INT DEFAULT NULL,
    `is_active` BOOLEAN DEFAULT TRUE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`category_id`),
    KEY `parent_id` (`parent_id`),
    CONSTRAINT `product_categories_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `product_categories` (`category_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert sample categories
INSERT INTO `product_categories` (`name`, `slug`, `description`) VALUES
('Electronics', 'electronics', 'Electronic devices and accessories'),
('Fashion', 'fashion', 'Clothing and fashion items'),
('Home & Garden', 'home-garden', 'Home improvement and garden supplies'),
('Sports', 'sports', 'Sports equipment and accessories'),
('Books', 'books', 'Books and educational materials');

-- Update products table to reference categories
ALTER TABLE `products` 
ADD COLUMN IF NOT EXISTS `category_id` INT DEFAULT NULL AFTER `currency`,
ADD CONSTRAINT `products_ibfk_category` FOREIGN KEY (`category_id`) REFERENCES `product_categories` (`category_id`) ON DELETE SET NULL;

-- Add slug column to products if it doesn't exist
ALTER TABLE `products` 
ADD COLUMN IF NOT EXISTS `slug` VARCHAR(200) DEFAULT NULL AFTER `name`;

-- Create index for slug
CREATE INDEX IF NOT EXISTS `idx_products_slug` ON `products` (`slug`);

-- Insert sample products with categories
INSERT INTO `products` (`seller_id`, `name`, `slug`, `description`, `price`, `currency`, `category_id`, `status`, `average_rating`, `total_reviews`, `created_at`, `updated_at`) VALUES
(2, 'iPhone 15 Pro Max', 'iphone-15-pro-max', 'Latest iPhone with advanced features', 25000000, 'VND', 1, 'active', 4.5, 0, NOW(), NOW()),
(2, 'Samsung Galaxy S24', 'samsung-galaxy-s24', 'Premium Android smartphone', 20000000, 'VND', 1, 'active', 4.3, 0, NOW(), NOW()),
(2, 'Nike Air Max 270', 'nike-air-max-270', 'Comfortable running shoes', 3000000, 'VND', 4, 'active', 4.7, 0, NOW(), NOW()),
(2, 'MacBook Pro M3', 'macbook-pro-m3', 'Professional laptop for creators', 45000000, 'VND', 1, 'active', 4.8, 0, NOW(), NOW());

-- Insert sample product images
INSERT INTO `product_images` (`product_id`, `url`, `alt_text`, `is_primary`) VALUES
(1, '/views/assets/user/img/product-1.png', 'iPhone 15 Pro Max', TRUE),
(1, '/views/assets/user/img/product-2.png', 'iPhone 15 Pro Max back', FALSE),
(2, '/views/assets/user/img/product-3.png', 'Samsung Galaxy S24', TRUE),
(3, '/views/assets/user/img/product-4.png', 'Nike Air Max 270', TRUE),
(4, '/views/assets/user/img/product-5.png', 'MacBook Pro M3', TRUE);

-- Insert sample inventory
INSERT INTO `inventory` (`product_id`, `seller_id`, `quantity`, `reserved_quantity`, `min_threshold`) VALUES
(1, 2, 50, 0, 5),
(2, 2, 30, 0, 3),
(3, 2, 100, 0, 10),
(4, 2, 20, 0, 2);

-- Update existing products to have slugs
UPDATE `products` SET `slug` = LOWER(REPLACE(REPLACE(`name`, ' ', '-'), '&', 'and')) WHERE `slug` IS NULL;

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS `idx_products_status` ON `products` (`status`);
CREATE INDEX IF NOT EXISTS `idx_products_seller` ON `products` (`seller_id`);
CREATE INDEX IF NOT EXISTS `idx_products_category` ON `products` (`category_id`);
CREATE INDEX IF NOT EXISTS `idx_cart_user` ON `cart` (`user_id`);
CREATE INDEX IF NOT EXISTS `idx_wishlist_user` ON `wishlist` (`user_id`);
CREATE INDEX IF NOT EXISTS `idx_reviews_product` ON `reviews` (`product_id`);
CREATE INDEX IF NOT EXISTS `idx_reviews_status` ON `reviews` (`status`);

-- Add Gson library note
-- Note: You need to download gson-2.10.1.jar and place it in web/WEB-INF/lib/
-- Download from: https://mvnrepository.com/artifact/com.google.code.gson/gson/2.10.1
