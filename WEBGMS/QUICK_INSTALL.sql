-- =====================================================
-- QUICK INSTALL: THÔNG BÁO VÀ HỦY SHOP
-- Copy toàn bộ file này và paste vào MySQL Workbench
-- =====================================================

USE gicungco;

-- 1. Bảng notifications
CREATE TABLE IF NOT EXISTS `notifications` (
  `notification_id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT(20) NOT NULL,
  `type` ENUM('order', 'withdrawal', 'system', 'shop_closure', 'warning', 'success') NOT NULL DEFAULT 'system',
  `title` VARCHAR(255) NOT NULL,
  `message` TEXT NOT NULL,
  `link_url` VARCHAR(500) NULL,
  `is_read` TINYINT(1) NOT NULL DEFAULT 0,
  `related_id` BIGINT(20) NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `read_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`notification_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_is_read` (`is_read`),
  KEY `idx_user_read` (`user_id`, `is_read`),
  CONSTRAINT `fk_notification_user` FOREIGN KEY (`user_id`) REFERENCES `gicungco_users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Bảng shop_closure_requests
CREATE TABLE IF NOT EXISTS `shop_closure_requests` (
  `request_id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `seller_id` BIGINT(20) NOT NULL,
  `reason` TEXT NOT NULL,
  `deposit_amount` DECIMAL(15,2) NOT NULL DEFAULT 0.00,
  `bank_name` VARCHAR(100) NOT NULL,
  `bank_account_number` VARCHAR(50) NOT NULL,
  `bank_account_name` VARCHAR(100) NOT NULL,
  `status` ENUM('pending', 'approved', 'rejected', 'completed') NOT NULL DEFAULT 'pending',
  `admin_note` TEXT NULL,
  `requested_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `processed_at` TIMESTAMP NULL DEFAULT NULL,
  `processed_by` BIGINT(20) NULL,
  `refund_transaction_ref` VARCHAR(100) NULL,
  `shop_status_before` VARCHAR(50) NULL,
  `total_orders` INT(11) DEFAULT 0,
  `pending_orders` INT(11) DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`request_id`),
  KEY `idx_seller_id` (`seller_id`),
  KEY `idx_status` (`status`),
  CONSTRAINT `fk_closure_seller` FOREIGN KEY (`seller_id`) REFERENCES `gicungco_sellers` (`seller_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_closure_admin` FOREIGN KEY (`processed_by`) REFERENCES `gicungco_users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Kiểm tra kết quả
SELECT 'Bảng notifications đã tạo!' AS result;
SELECT 'Bảng shop_closure_requests đã tạo!' AS result;
SELECT 'HOÀN THÀNH! Bạn có thể chạy project ngay.' AS result;





