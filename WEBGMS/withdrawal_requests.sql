-- Table: withdrawal_requests
-- Bảng lưu trữ các yêu cầu rút tiền của seller

CREATE TABLE IF NOT EXISTS `withdrawal_requests` (
  `request_id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `seller_id` BIGINT(20) NOT NULL COMMENT 'ID của seller yêu cầu rút tiền',
  `amount` DECIMAL(15,2) NOT NULL COMMENT 'Số tiền yêu cầu rút',
  `bank_name` VARCHAR(100) NOT NULL COMMENT 'Tên ngân hàng',
  `bank_account_number` VARCHAR(50) NOT NULL COMMENT 'Số tài khoản',
  `bank_account_name` VARCHAR(100) NOT NULL COMMENT 'Tên chủ tài khoản',
  `status` ENUM('pending', 'approved', 'rejected', 'processing', 'completed') NOT NULL DEFAULT 'pending' COMMENT 'Trạng thái: pending=chờ duyệt, approved=đã duyệt, rejected=từ chối, processing=đang xử lý, completed=hoàn thành',
  `request_note` TEXT NULL COMMENT 'Ghi chú của seller',
  `admin_note` TEXT NULL COMMENT 'Ghi chú của admin khi xử lý',
  `requested_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian gửi yêu cầu',
  `processed_at` TIMESTAMP NULL DEFAULT NULL COMMENT 'Thời gian admin xử lý',
  `processed_by` BIGINT(20) NULL COMMENT 'ID của admin xử lý',
  `transaction_reference` VARCHAR(100) NULL COMMENT 'Mã giao dịch chuyển tiền',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`request_id`),
  KEY `idx_seller_id` (`seller_id`),
  KEY `idx_status` (`status`),
  KEY `idx_requested_at` (`requested_at`),
  CONSTRAINT `fk_withdrawal_seller` FOREIGN KEY (`seller_id`) REFERENCES `gicungco_sellers` (`seller_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_withdrawal_admin` FOREIGN KEY (`processed_by`) REFERENCES `gicungco_users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng quản lý yêu cầu rút tiền của seller';

-- Indexes for better performance
CREATE INDEX `idx_seller_status` ON `withdrawal_requests` (`seller_id`, `status`);
CREATE INDEX `idx_status_requested` ON `withdrawal_requests` (`status`, `requested_at`);

-- Sample data (optional)
-- INSERT INTO `withdrawal_requests` (`seller_id`, `amount`, `bank_name`, `bank_account_number`, `bank_account_name`, `status`, `request_note`) 
-- VALUES (1, 5000000, 'Vietcombank', '1234567890', 'NGUYEN VAN A', 'pending', 'Rút tiền bán hàng tháng 10');


