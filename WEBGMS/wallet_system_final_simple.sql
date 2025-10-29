-- ================================================
-- 💰 HỆ THỐNG VÍ ẢO - PHIÊN BẢN ĐƠN GIẢN
-- ================================================
-- Chỉ tạo 2 bảng còn thiếu (nếu cần)
-- KHÔNG thay đổi bảng hiện tại
-- ================================================

USE gicungco;

-- ================================================
-- 1. BẢNG WITHDRAWAL_REQUESTS (YÊU CẦU RÚT TIỀN)
-- ================================================
-- Chỉ tạo nếu chưa có
CREATE TABLE IF NOT EXISTS `withdrawal_requests` (
  `request_id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `wallet_id` BIGINT NOT NULL,
  `amount` DECIMAL(15,2) NOT NULL,
  `fee` DECIMAL(15,2) DEFAULT 0.00,
  `net_amount` DECIMAL(15,2) NOT NULL COMMENT 'amount - fee',
  `bank_name` VARCHAR(100) NOT NULL,
  `bank_account` VARCHAR(50) NOT NULL,
  `account_holder` VARCHAR(100) NOT NULL,
  `status` VARCHAR(20) DEFAULT 'pending' COMMENT 'pending, processing, completed, rejected',
  `transaction_id` BIGINT COMMENT 'ID giao dịch khi hoàn tất',
  `reject_reason` TEXT,
  `processed_by` BIGINT COMMENT 'Admin xử lý',
  `note` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `processed_at` TIMESTAMP NULL,
  PRIMARY KEY (`request_id`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE CASCADE,
  FOREIGN KEY (`wallet_id`) REFERENCES `wallets`(`wallet_id`) ON DELETE CASCADE,
  INDEX `idx_withdraw_user` (`user_id`),
  INDEX `idx_withdraw_wallet` (`wallet_id`),
  INDEX `idx_withdraw_status` (`status`),
  INDEX `idx_withdraw_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================
-- 2. BẢNG WALLET_TRANSFERS (CHUYỂN TIỀN GIỮA VÍ)
-- ================================================
-- Chỉ tạo nếu chưa có
CREATE TABLE IF NOT EXISTS `wallet_transfers` (
  `transfer_id` BIGINT NOT NULL AUTO_INCREMENT,
  `from_user_id` BIGINT NOT NULL,
  `to_user_id` BIGINT NOT NULL,
  `from_wallet_id` BIGINT NOT NULL,
  `to_wallet_id` BIGINT NOT NULL,
  `amount` DECIMAL(15,2) NOT NULL,
  `fee` DECIMAL(15,2) DEFAULT 0.00,
  `net_amount` DECIMAL(15,2) NOT NULL,
  `status` VARCHAR(20) DEFAULT 'completed',
  `transaction_id_from` BIGINT COMMENT 'ID giao dịch trừ tiền',
  `transaction_id_to` BIGINT COMMENT 'ID giao dịch cộng tiền',
  `description` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`transfer_id`),
  FOREIGN KEY (`from_user_id`) REFERENCES `users`(`user_id`) ON DELETE CASCADE,
  FOREIGN KEY (`to_user_id`) REFERENCES `users`(`user_id`) ON DELETE CASCADE,
  FOREIGN KEY (`from_wallet_id`) REFERENCES `wallets`(`wallet_id`) ON DELETE CASCADE,
  FOREIGN KEY (`to_wallet_id`) REFERENCES `wallets`(`wallet_id`) ON DELETE CASCADE,
  INDEX `idx_transfer_from` (`from_user_id`),
  INDEX `idx_transfer_to` (`to_user_id`),
  INDEX `idx_transfer_status` (`status`),
  INDEX `idx_transfer_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================
-- ✅ HOÀN TẤT!
-- ================================================
-- 
-- HỆ THỐNG VÍ ẢO BÂY GIỜ CÓ:
-- ✅ wallets (có sẵn - 2 ví)
-- ✅ transactions (có sẵn - 2 giao dịch)
-- ✅ wallet_history (có sẵn - trống)
-- ✅ commissions (có sẵn - trống)
-- ✅ withdrawal_requests (mới tạo)
-- ✅ wallet_transfers (mới tạo)
--
-- TỔNG: 6 BẢNG HOÀN CHỈNH!
-- ================================================

-- Kiểm tra kết quả
SELECT 
    TABLE_NAME AS 'Bang',
    TABLE_ROWS AS 'So_Dong',
    CREATE_TIME AS 'Ngay_Tao'
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'gicungco'
  AND TABLE_NAME IN (
      'wallets',
      'transactions', 
      'wallet_history',
      'commissions',
      'withdrawal_requests',
      'wallet_transfers'
  )
ORDER BY TABLE_NAME;

