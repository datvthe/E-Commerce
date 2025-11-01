-- =====================================================
-- QUICK INSTALL - KHÔNG CẦN FOREIGN KEY
-- File này bỏ qua foreign key để tránh lỗi
-- =====================================================

USE gicungco;

-- 1. Bảng notifications (KHÔNG CÓ FOREIGN KEY)
DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications` (
  `notification_id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT(20) NOT NULL COMMENT 'ID người nhận thông báo',
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
  KEY `idx_user_read` (`user_id`, `is_read`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Bảng shop_closure_requests (KHÔNG CÓ FOREIGN KEY)
DROP TABLE IF EXISTS `shop_closure_requests`;
CREATE TABLE `shop_closure_requests` (
  `request_id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `seller_id` BIGINT(20) NOT NULL COMMENT 'ID của seller',
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
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Kiểm tra kết quả
SELECT '✅ Bảng notifications đã tạo!' AS status;
SELECT '✅ Bảng shop_closure_requests đã tạo!' AS status;
SELECT '🎉 HOÀN THÀNH! Giờ có thể Build & Run project!' AS status;

-- Hiển thị cấu trúc bảng
SHOW CREATE TABLE notifications;
SHOW CREATE TABLE shop_closure_requests;





