-- ================================================
-- 💰 BẢNG PENDING TRANSACTIONS
-- Giữ tiền tạm thời trước khi chuyển cho seller
-- ================================================

USE gicungco;

-- Bảng pending_transactions: Giao dịch chờ xử lý
CREATE TABLE IF NOT EXISTS `pending_transactions` (
  `pending_id` BIGINT NOT NULL AUTO_INCREMENT,
  `order_id` BIGINT NOT NULL COMMENT 'ID đơn hàng',
  `buyer_id` BIGINT NOT NULL COMMENT 'Người mua',
  `seller_id` BIGINT NOT NULL COMMENT 'Người bán',
  `total_amount` DECIMAL(15,2) NOT NULL COMMENT 'Tổng tiền',
  `seller_amount` DECIMAL(15,2) NOT NULL COMMENT 'Tiền seller nhận (95%)',
  `platform_fee` DECIMAL(15,2) NOT NULL COMMENT 'Phí hệ thống (5%)',
  `status` ENUM('PENDING', 'PROCESSING', 'COMPLETED', 'REFUNDED', 'CANCELLED') DEFAULT 'PENDING',
  `hold_until` TIMESTAMP NOT NULL COMMENT 'Giữ đến ngày nào',
  `released_at` TIMESTAMP NULL COMMENT 'Ngày giải phóng tiền',
  `transaction_id` BIGINT NULL COMMENT 'ID giao dịch gốc (từ buyer)',
  `seller_transaction_id` BIGINT NULL COMMENT 'ID giao dịch cho seller',
  `admin_transaction_id` BIGINT NULL COMMENT 'ID giao dịch phí admin',
  `notes` TEXT COMMENT 'Ghi chú',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (`pending_id`),
  FOREIGN KEY (`order_id`) REFERENCES `orders`(`order_id`) ON DELETE CASCADE,
  FOREIGN KEY (`buyer_id`) REFERENCES `users`(`user_id`) ON DELETE CASCADE,
  FOREIGN KEY (`seller_id`) REFERENCES `users`(`user_id`) ON DELETE CASCADE,
  
  INDEX `idx_status` (`status`),
  INDEX `idx_hold_until` (`hold_until`),
  INDEX `idx_order` (`order_id`),
  INDEX `idx_buyer` (`buyer_id`),
  INDEX `idx_seller` (`seller_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

COMMENT='Giao dịch pending - giữ tiền tạm thời';

-- ================================================
-- 📊 VIEW: Pending transactions cần xử lý
-- ================================================
CREATE OR REPLACE VIEW `pending_transactions_to_process` AS
SELECT 
    pt.*,
    b.email as buyer_email,
    b.full_name as buyer_name,
    s.email as seller_email,
    s.full_name as seller_name,
    o.order_number,
    o.product_id
FROM pending_transactions pt
LEFT JOIN users b ON pt.buyer_id = b.user_id
LEFT JOIN users s ON pt.seller_id = s.user_id
LEFT JOIN orders o ON pt.order_id = o.order_id
WHERE pt.status = 'PENDING' 
  AND pt.hold_until <= NOW()
ORDER BY pt.hold_until ASC;

-- ================================================
-- 🔍 QUERIES HỮU ÍCH
-- ================================================

-- Xem tất cả pending transactions
SELECT * FROM pending_transactions ORDER BY created_at DESC;

-- Xem pending transactions cần xử lý (đã hết thời gian hold)
SELECT * FROM pending_transactions_to_process;

-- Tổng tiền đang pending
SELECT 
    COUNT(*) as total_pending,
    SUM(total_amount) as total_pending_amount,
    SUM(seller_amount) as total_seller_pending,
    SUM(platform_fee) as total_fee_pending
FROM pending_transactions
WHERE status = 'PENDING';

-- Pending transactions của 1 seller
SELECT 
    pt.*,
    o.order_number,
    b.full_name as buyer_name
FROM pending_transactions pt
LEFT JOIN orders o ON pt.order_id = o.order_id
LEFT JOIN users b ON pt.buyer_id = b.user_id
WHERE pt.seller_id = ? 
ORDER BY pt.created_at DESC;

-- Pending transactions của 1 buyer
SELECT 
    pt.*,
    o.order_number,
    s.full_name as seller_name
FROM pending_transactions pt
LEFT JOIN orders o ON pt.order_id = o.order_id
LEFT JOIN users s ON pt.seller_id = s.user_id
WHERE pt.buyer_id = ? 
ORDER BY pt.created_at DESC;

