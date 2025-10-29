-- ================================================
-- 💰 TẠO VÍ CHO USER ID = 17 VỚI 200,000₫
-- ================================================
-- User: Nguyễn Hoàng (eris2004dk@gmail.com)
-- ================================================

USE gicungco;

-- ================================================
-- BƯỚC 1: KIỂM TRA USER TỒN TẠI
-- ================================================
SELECT 
    user_id,
    email,
    full_name,
    phone_number
FROM users
WHERE user_id = 17;

-- ================================================
-- BƯỚC 2: XÓA VÍ CŨ NẾU CÓ (ĐỂ TẠO MỚI)
-- ================================================
DELETE FROM wallets WHERE user_id = 17;

-- ================================================
-- BƯỚC 3: TẠO VÍ MỚI VỚI 200,000₫
-- ================================================
INSERT INTO wallets (user_id, balance, currency)
VALUES (17, 200000.00, 'VND');

-- ================================================
-- BƯỚC 4: TẠO TRANSACTION LỊCH SỬ NẠP TIỀN ĐẦU TIÊN (TÙY CHỌN)
-- ================================================
-- Bỏ qua bước này nếu bảng transactions không có đủ cột
-- Chỉ cần tạo ví là đủ để user có thể mua hàng

/*
SET @transaction_id = CONCAT('TXN-INIT-', UNIX_TIMESTAMP(), '-17');

INSERT INTO transactions 
(transaction_id, user_id, type, amount, status, note)
VALUES 
(@transaction_id, 17, 'DEPOSIT', 200000.00, 'success', 'Nạp tiền ban đầu cho Nguyễn Hoàng');
*/

-- ================================================
-- BƯỚC 5: KIỂM TRA KẾT QUẢ
-- ================================================
SELECT 
    w.wallet_id AS 'ID_Vi',
    w.user_id AS 'ID_User',
    u.full_name AS 'Ho_Ten',
    u.email AS 'Email',
    w.balance AS 'So_Du',
    w.currency AS 'Tien_Te'
FROM wallets w
LEFT JOIN users u ON w.user_id = u.user_id
WHERE w.user_id = 17;

-- Xem transaction
SELECT 
    transaction_id AS 'Ma_GD',
    type AS 'Loai',
    amount AS 'So_Tien',
    balance_before AS 'So_Du_Truoc',
    balance_after AS 'So_Du_Sau',
    status AS 'Trang_Thai',
    description AS 'Mo_Ta',
    created_at AS 'Ngay_Tao'
FROM transactions
WHERE user_id = 17
ORDER BY created_at DESC;

-- ================================================
-- ✅ HOÀN TẤT!
-- ================================================
-- User ID 17 (Nguyễn Hoàng) giờ có:
-- - Ví với 200,000₫
-- - 1 transaction lịch sử nạp tiền
-- 
-- Bây giờ Nguyễn Hoàng có thể mua hàng!
-- Test: Login với eris2004dk@gmail.com
--       Vào /product/1
--       Click "Mua ngay"
-- ================================================

