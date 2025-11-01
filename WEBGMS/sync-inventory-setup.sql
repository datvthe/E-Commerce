-- ═══════════════════════════════════════════════════════════════════════════
-- SETUP SCRIPT: SYNC INVENTORY FROM DIGITAL_GOODS_CODES
-- ═══════════════════════════════════════════════════════════════════════════
-- Mục đích: Chuẩn bị database để sync inventory từ digital_goods_codes
-- Chạy file này TRƯỚC KHI sử dụng DAO sync
-- ═══════════════════════════════════════════════════════════════════════════

USE gicungco;

-- ═══════════════════════════════════════════════════════════════════════════
-- BƯỚC 1: Tạo UNIQUE constraint cho inventory.product_id
-- ═══════════════════════════════════════════════════════════════════════════
-- Cần thiết để ON DUPLICATE KEY UPDATE hoạt động

-- Kiểm tra xem UNIQUE constraint đã tồn tại chưa
SELECT COUNT(*) as constraint_exists
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'gicungco'
  AND TABLE_NAME = 'inventory'
  AND CONSTRAINT_NAME = 'unique_product_id'
  AND CONSTRAINT_TYPE = 'UNIQUE';

-- Nếu chưa có, chạy lệnh này:
ALTER TABLE inventory 
ADD CONSTRAINT unique_product_id UNIQUE (product_id);

-- Hoặc dùng lệnh này nếu muốn đơn giản hơn:
-- ALTER TABLE inventory ADD UNIQUE (product_id);

-- ═══════════════════════════════════════════════════════════════════════════
-- BƯỚC 2: Kiểm tra dữ liệu hiện tại
-- ═══════════════════════════════════════════════════════════════════════════

-- 2.1. Xem số lượng digital codes có sẵn cho mỗi product
SELECT 
    product_id,
    COUNT(*) as total_codes,
    SUM(CASE WHEN is_used = 0 THEN 1 ELSE 0 END) as available_codes,
    SUM(CASE WHEN is_used = 1 THEN 1 ELSE 0 END) as used_codes
FROM digital_goods_codes
GROUP BY product_id
ORDER BY product_id;

-- 2.2. Xem inventory hiện tại (nếu có)
SELECT * FROM inventory ORDER BY product_id;

-- ═══════════════════════════════════════════════════════════════════════════
-- BƯỚC 3: (OPTIONAL) Xóa dữ liệu inventory cũ nếu muốn sync lại từ đầu
-- ═══════════════════════════════════════════════════════════════════════════
-- CẢNH BÁO: Chỉ chạy lệnh này nếu bạn muốn reset inventory!
-- TRUNCATE TABLE inventory;

-- ═══════════════════════════════════════════════════════════════════════════
-- BƯỚC 4: Chạy sync thủ công bằng SQL (nếu không dùng Java)
-- ═══════════════════════════════════════════════════════════════════════════

-- 4.1. Sync tất cả products
INSERT INTO inventory (product_id, seller_id, quantity, reserved_quantity, min_threshold, last_restocked_at)
SELECT 
    dgc.product_id,
    p.seller_id,
    COUNT(*) as quantity,
    0 as reserved_quantity,
    5 as min_threshold,
    NOW() as last_restocked_at
FROM digital_goods_codes dgc
JOIN products p ON dgc.product_id = p.product_id
WHERE dgc.is_used = 0
GROUP BY dgc.product_id, p.seller_id
ON DUPLICATE KEY UPDATE
    quantity = VALUES(quantity),
    last_restocked_at = NOW();

-- 4.2. Kiểm tra kết quả
SELECT 
    i.inventory_id,
    i.product_id,
    p.name as product_name,
    i.seller_id,
    i.quantity,
    i.reserved_quantity,
    i.last_restocked_at
FROM inventory i
LEFT JOIN products p ON i.product_id = p.product_id
ORDER BY i.product_id;

-- ═══════════════════════════════════════════════════════════════════════════
-- BƯỚC 5: Tạo VIEW để so sánh inventory vs digital_goods_codes
-- ═══════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE VIEW v_inventory_sync_check AS
SELECT 
    i.product_id,
    p.name as product_name,
    i.quantity as inventory_quantity,
    (SELECT COUNT(*) 
     FROM digital_goods_codes 
     WHERE product_id = i.product_id AND is_used = 0) as actual_available,
    i.quantity - (SELECT COUNT(*) 
                  FROM digital_goods_codes 
                  WHERE product_id = i.product_id AND is_used = 0) as difference,
    CASE 
        WHEN i.quantity = (SELECT COUNT(*) 
                           FROM digital_goods_codes 
                           WHERE product_id = i.product_id AND is_used = 0)
        THEN '✅ SYNCED'
        ELSE '⚠️ OUT OF SYNC'
    END as sync_status,
    i.last_restocked_at
FROM inventory i
LEFT JOIN products p ON i.product_id = p.product_id;

-- Xem kết quả sync
SELECT * FROM v_inventory_sync_check;

-- ═══════════════════════════════════════════════════════════════════════════
-- BƯỚC 6: (OPTIONAL) Tạo TRIGGER tự động sync khi có thay đổi
-- ═══════════════════════════════════════════════════════════════════════════
-- CẢNH BÁO: Trigger có thể ảnh hưởng performance, cân nhắc trước khi dùng

DELIMITER $$

CREATE TRIGGER after_digital_code_update
AFTER UPDATE ON digital_goods_codes
FOR EACH ROW
BEGIN
    -- Chỉ update khi is_used thay đổi
    IF OLD.is_used != NEW.is_used THEN
        -- Update inventory quantity
        UPDATE inventory
        SET quantity = (
            SELECT COUNT(*) 
            FROM digital_goods_codes 
            WHERE product_id = NEW.product_id AND is_used = 0
        ),
        last_restocked_at = NOW()
        WHERE product_id = NEW.product_id;
    END IF;
END$$

-- Trigger khi INSERT code mới
CREATE TRIGGER after_digital_code_insert
AFTER INSERT ON digital_goods_codes
FOR EACH ROW
BEGIN
    -- Insert hoặc update inventory
    INSERT INTO inventory (product_id, seller_id, quantity, reserved_quantity, min_threshold, last_restocked_at)
    SELECT 
        NEW.product_id,
        p.seller_id,
        (SELECT COUNT(*) FROM digital_goods_codes WHERE product_id = NEW.product_id AND is_used = 0),
        0,
        5,
        NOW()
    FROM products p
    WHERE p.product_id = NEW.product_id
    ON DUPLICATE KEY UPDATE
        quantity = (SELECT COUNT(*) FROM digital_goods_codes WHERE product_id = NEW.product_id AND is_used = 0),
        last_restocked_at = NOW();
END$$

DELIMITER ;

-- Xem các trigger đã tạo
SHOW TRIGGERS WHERE `Table` = 'digital_goods_codes';

-- ═══════════════════════════════════════════════════════════════════════════
-- BƯỚC 7: Test sync
-- ═══════════════════════════════════════════════════════════════════════════

-- 7.1. Test: Mark 1 code là đã sử dụng
UPDATE digital_goods_codes
SET is_used = 1, used_by = 11, used_at = NOW()
WHERE code_id = 1;

-- 7.2. Kiểm tra inventory có tự động update không (nếu dùng trigger)
SELECT * FROM v_inventory_sync_check WHERE product_id = 1;

-- 7.3. Rollback test
UPDATE digital_goods_codes
SET is_used = 0, used_by = NULL, used_at = NULL
WHERE code_id = 1;

-- ═══════════════════════════════════════════════════════════════════════════
-- ✅ HOÀN TẤT SETUP!
-- ═══════════════════════════════════════════════════════════════════════════
-- 
-- BÂY GIỜ BẠN CÓ THỂ:
-- 1. Chạy Java servlet: http://localhost:8080/WEBGMS/admin/sync-inventory
-- 2. Hoặc gọi DAO: inventoryDAO.syncInventoryFromDigitalCodes()
-- 3. Hoặc để trigger tự động sync (nếu đã tạo)
--
-- ═══════════════════════════════════════════════════════════════════════════

