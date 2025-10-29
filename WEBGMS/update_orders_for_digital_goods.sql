-- ================================================
-- 🔧 CẬP NHẬT BẢNG ORDERS CHO DIGITAL GOODS
-- ================================================
-- File này SẼ:
-- 1. Thêm các cột còn thiếu vào bảng orders
-- 2. Tạo các bảng mới cần thiết
-- 3. KHÔNG xóa dữ liệu hiện tại
-- ================================================

USE gicungco;

-- ================================================
-- BƯỚC 1: KIỂM TRA VÀ THÊM CỘT VÀO BẢNG ORDERS
-- ================================================

-- Thêm cột order_number (nếu chưa có)
SET @col_exists = 0;
SELECT COUNT(*) INTO @col_exists 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'gicungco' 
  AND TABLE_NAME = 'orders' 
  AND COLUMN_NAME = 'order_number';

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE orders ADD COLUMN order_number VARCHAR(50) UNIQUE AFTER order_id',
    'SELECT "Column order_number already exists" AS message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Thêm cột product_id (nếu chưa có)
SET @col_exists = 0;
SELECT COUNT(*) INTO @col_exists 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'gicungco' 
  AND TABLE_NAME = 'orders' 
  AND COLUMN_NAME = 'product_id';

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE orders ADD COLUMN product_id BIGINT AFTER seller_id',
    'SELECT "Column product_id already exists" AS message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Thêm cột quantity (nếu chưa có)
SET @col_exists = 0;
SELECT COUNT(*) INTO @col_exists 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'gicungco' 
  AND TABLE_NAME = 'orders' 
  AND COLUMN_NAME = 'quantity';

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE orders ADD COLUMN quantity INT DEFAULT 1 AFTER product_id',
    'SELECT "Column quantity already exists" AS message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Thêm cột unit_price (nếu chưa có)
SET @col_exists = 0;
SELECT COUNT(*) INTO @col_exists 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'gicungco' 
  AND TABLE_NAME = 'orders' 
  AND COLUMN_NAME = 'unit_price';

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE orders ADD COLUMN unit_price DECIMAL(15,2) AFTER quantity',
    'SELECT "Column unit_price already exists" AS message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Thêm cột payment_method (nếu chưa có)
SET @col_exists = 0;
SELECT COUNT(*) INTO @col_exists 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'gicungco' 
  AND TABLE_NAME = 'orders' 
  AND COLUMN_NAME = 'payment_method';

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE orders ADD COLUMN payment_method VARCHAR(50) DEFAULT ''WALLET'' AFTER total_amount',
    'SELECT "Column payment_method already exists" AS message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Thêm cột payment_status (nếu chưa có)
SET @col_exists = 0;
SELECT COUNT(*) INTO @col_exists 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'gicungco' 
  AND TABLE_NAME = 'orders' 
  AND COLUMN_NAME = 'payment_status';

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE orders ADD COLUMN payment_status VARCHAR(20) DEFAULT ''PENDING'' AFTER payment_method',
    'SELECT "Column payment_status already exists" AS message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Thêm cột order_status (nếu chưa có, khác với status)
SET @col_exists = 0;
SELECT COUNT(*) INTO @col_exists 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'gicungco' 
  AND TABLE_NAME = 'orders' 
  AND COLUMN_NAME = 'order_status';

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE orders ADD COLUMN order_status VARCHAR(20) DEFAULT ''PENDING'' AFTER payment_status',
    'SELECT "Column order_status already exists" AS message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Thêm cột delivery_status (nếu chưa có)
SET @col_exists = 0;
SELECT COUNT(*) INTO @col_exists 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'gicungco' 
  AND TABLE_NAME = 'orders' 
  AND COLUMN_NAME = 'delivery_status';

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE orders ADD COLUMN delivery_status VARCHAR(20) DEFAULT ''INSTANT'' AFTER order_status',
    'SELECT "Column delivery_status already exists" AS message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Thêm cột transaction_id (nếu chưa có)
SET @col_exists = 0;
SELECT COUNT(*) INTO @col_exists 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'gicungco' 
  AND TABLE_NAME = 'orders' 
  AND COLUMN_NAME = 'transaction_id';

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE orders ADD COLUMN transaction_id VARCHAR(100) AFTER delivery_status',
    'SELECT "Column transaction_id already exists" AS message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Thêm cột queue_status (nếu chưa có)
SET @col_exists = 0;
SELECT COUNT(*) INTO @col_exists 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'gicungco' 
  AND TABLE_NAME = 'orders' 
  AND COLUMN_NAME = 'queue_status';

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE orders ADD COLUMN queue_status VARCHAR(20) DEFAULT ''WAITING'' AFTER transaction_id',
    'SELECT "Column queue_status already exists" AS message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Thêm cột processed_at (nếu chưa có)
SET @col_exists = 0;
SELECT COUNT(*) INTO @col_exists 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'gicungco' 
  AND TABLE_NAME = 'orders' 
  AND COLUMN_NAME = 'processed_at';

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE orders ADD COLUMN processed_at TIMESTAMP NULL AFTER queue_status',
    'SELECT "Column processed_at already exists" AS message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- ================================================
-- BƯỚC 2: TẠO CÁC BẢNG MỚI
-- ================================================

-- 2.1. BẢNG DIGITAL_PRODUCTS (KHO TÀI NGUYÊN SỐ)
CREATE TABLE IF NOT EXISTS `digital_products` (
  `digital_id` BIGINT NOT NULL AUTO_INCREMENT,
  `product_id` BIGINT NOT NULL COMMENT 'Sản phẩm gốc',
  `code` VARCHAR(255) NOT NULL COMMENT 'Mã thẻ/Serial/Username',
  `password` VARCHAR(255) COMMENT 'Mật khẩu (nếu là tài khoản)',
  `serial` VARCHAR(255) COMMENT 'Serial (nếu là thẻ cào)',
  `additional_info` TEXT COMMENT 'Thông tin thêm (JSON)',
  `status` VARCHAR(20) DEFAULT 'AVAILABLE' COMMENT 'AVAILABLE, SOLD, EXPIRED, INVALID',
  `sold_to_user_id` BIGINT COMMENT 'User đã mua',
  `sold_in_order_id` BIGINT COMMENT 'Order đã bán',
  `sold_at` TIMESTAMP NULL,
  `expires_at` TIMESTAMP NULL COMMENT 'Ngày hết hạn (nếu có)',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`digital_id`),
  UNIQUE KEY `unique_code_per_product` (`product_id`, `code`),
  INDEX `idx_digital_product` (`product_id`),
  INDEX `idx_digital_status` (`status`),
  INDEX `idx_digital_user` (`sold_to_user_id`),
  INDEX `idx_digital_order` (`sold_in_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2.2. BẢNG ORDER_DIGITAL_ITEMS (SẢN PHẨM SỐ ĐÃ GIAO)
CREATE TABLE IF NOT EXISTS `order_digital_items` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `order_id` BIGINT NOT NULL,
  `digital_id` BIGINT NOT NULL,
  `delivered_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_digital_per_order` (`order_id`, `digital_id`),
  INDEX `idx_order_digital` (`order_id`),
  INDEX `idx_digital_item` (`digital_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2.3. BẢNG ORDER_QUEUE (HÀNG ĐỢI XỬ LÝ)
CREATE TABLE IF NOT EXISTS `order_queue` (
  `queue_id` BIGINT NOT NULL AUTO_INCREMENT,
  `order_id` BIGINT NOT NULL,
  `priority` INT DEFAULT 0 COMMENT 'Độ ưu tiên',
  `status` VARCHAR(20) DEFAULT 'WAITING' COMMENT 'WAITING, PROCESSING, COMPLETED, FAILED',
  `attempts` INT DEFAULT 0 COMMENT 'Số lần thử xử lý',
  `error_message` TEXT,
  `processor_id` VARCHAR(100) COMMENT 'ID của worker',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `started_at` TIMESTAMP NULL,
  `completed_at` TIMESTAMP NULL,
  PRIMARY KEY (`queue_id`),
  UNIQUE KEY `unique_order_queue` (`order_id`),
  INDEX `idx_queue_status` (`status`),
  INDEX `idx_queue_priority` (`priority` DESC),
  INDEX `idx_queue_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2.4. BẢNG ORDER_HISTORY (LỊCH SỬ THAY ĐỔI)
CREATE TABLE IF NOT EXISTS `order_history` (
  `history_id` BIGINT NOT NULL AUTO_INCREMENT,
  `order_id` BIGINT NOT NULL,
  `old_status` VARCHAR(20),
  `new_status` VARCHAR(20),
  `changed_by` BIGINT COMMENT 'User/Admin thay đổi',
  `note` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`history_id`),
  INDEX `idx_history_order` (`order_id`),
  INDEX `idx_history_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================
-- BƯỚC 3: TẠO INDEX CHO BẢNG ORDERS (TỐI ƯU)
-- ================================================

-- Index cho order_number
SET @index_exists = 0;
SELECT COUNT(*) INTO @index_exists 
FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_SCHEMA = 'gicungco' 
  AND TABLE_NAME = 'orders' 
  AND INDEX_NAME = 'idx_order_number';

SET @sql = IF(@index_exists = 0,
    'CREATE INDEX idx_order_number ON orders(order_number)',
    'SELECT "Index idx_order_number already exists" AS message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Index cho product_id
SET @index_exists = 0;
SELECT COUNT(*) INTO @index_exists 
FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_SCHEMA = 'gicungco' 
  AND TABLE_NAME = 'orders' 
  AND INDEX_NAME = 'idx_order_product';

SET @sql = IF(@index_exists = 0,
    'CREATE INDEX idx_order_product ON orders(product_id)',
    'SELECT "Index idx_order_product already exists" AS message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Index cho queue_status
SET @index_exists = 0;
SELECT COUNT(*) INTO @index_exists 
FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_SCHEMA = 'gicungco' 
  AND TABLE_NAME = 'orders' 
  AND INDEX_NAME = 'idx_order_queue';

SET @sql = IF(@index_exists = 0,
    'CREATE INDEX idx_order_queue ON orders(queue_status, processed_at)',
    'SELECT "Index idx_order_queue already exists" AS message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- ================================================
-- BƯỚC 4: INSERT SAMPLE DIGITAL PRODUCTS
-- ================================================

-- Sample: Thẻ cào Viettel 100K (product_id = 1)
-- Chỉ insert nếu chưa có
INSERT INTO `digital_products` 
(product_id, code, serial, status, expires_at)
SELECT 1, '1234567890123', '9876543210', 'AVAILABLE', DATE_ADD(NOW(), INTERVAL 365 DAY)
WHERE NOT EXISTS (SELECT 1 FROM digital_products WHERE code = '1234567890123');

INSERT INTO `digital_products` 
(product_id, code, serial, status, expires_at)
SELECT 1, '2345678901234', '8765432109', 'AVAILABLE', DATE_ADD(NOW(), INTERVAL 365 DAY)
WHERE NOT EXISTS (SELECT 1 FROM digital_products WHERE code = '2345678901234');

INSERT INTO `digital_products` 
(product_id, code, serial, status, expires_at)
SELECT 1, '3456789012345', '7654321098', 'AVAILABLE', DATE_ADD(NOW(), INTERVAL 365 DAY)
WHERE NOT EXISTS (SELECT 1 FROM digital_products WHERE code = '3456789012345');

INSERT INTO `digital_products` 
(product_id, code, serial, status, expires_at)
SELECT 1, '4567890123456', '6543210987', 'AVAILABLE', DATE_ADD(NOW(), INTERVAL 365 DAY)
WHERE NOT EXISTS (SELECT 1 FROM digital_products WHERE code = '4567890123456');

INSERT INTO `digital_products` 
(product_id, code, serial, status, expires_at)
SELECT 1, '5678901234567', '5432109876', 'AVAILABLE', DATE_ADD(NOW(), INTERVAL 365 DAY)
WHERE NOT EXISTS (SELECT 1 FROM digital_products WHERE code = '5678901234567');

-- ================================================
-- BƯỚC 5: KIỂM TRA KẾT QUẢ
-- ================================================

-- Xem cấu trúc bảng orders sau khi update
SELECT 
    COLUMN_NAME AS 'Cot',
    DATA_TYPE AS 'Kieu_Du_Lieu',
    CHARACTER_MAXIMUM_LENGTH AS 'Do_Dai',
    IS_NULLABLE AS 'Cho_Phep_NULL',
    COLUMN_KEY AS 'Khoa',
    COLUMN_DEFAULT AS 'Gia_Tri_Mac_Dinh'
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'gicungco'
  AND TABLE_NAME = 'orders'
ORDER BY ORDINAL_POSITION;

-- Xem các bảng digital goods đã tạo
SELECT 
    TABLE_NAME AS 'Bang',
    TABLE_ROWS AS 'So_Dong',
    CREATE_TIME AS 'Ngay_Tao'
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'gicungco'
  AND TABLE_NAME IN (
      'digital_products',
      'order_digital_items',
      'order_queue',
      'order_history'
  )
ORDER BY TABLE_NAME;

-- Xem digital products có sẵn
SELECT 
    dp.digital_id,
    dp.product_id,
    p.name AS product_name,
    dp.code,
    dp.serial,
    dp.status,
    dp.expires_at
FROM digital_products dp
LEFT JOIN products p ON dp.product_id = p.product_id
WHERE dp.status = 'AVAILABLE'
ORDER BY dp.product_id, dp.digital_id;

-- ================================================
-- ✅ HOÀN TẤT CẬP NHẬT!
-- ================================================
-- 
-- ĐÃ THỰC HIỆN:
-- 1. ✅ Thêm 9 cột mới vào bảng orders
-- 2. ✅ Tạo 4 bảng mới (digital_products, order_digital_items, order_queue, order_history)
-- 3. ✅ Tạo indexes để tối ưu
-- 4. ✅ Insert 5 sample digital products
--
-- BÂY GIỜ BẠN CÓ THỂ:
-- - Xem cấu trúc bảng orders mới
-- - Xem danh sách digital products
-- - Bắt đầu implement code Java
--
-- ================================================

