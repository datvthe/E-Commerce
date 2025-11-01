-- SCRIPT NHANH: THÊM SELLER RECORD CHO USER

-- BƯỚC 1: TÌM USER_ID CỦA BẠN
-- Chạy query này trước để lấy user_id
SELECT user_id, email, full_name 
FROM gicungco_users 
WHERE email = 'YOUR_EMAIL@example.com';  -- ⚠️ THAY EMAIL CỦA BẠN VÀO ĐÂY

-- Ghi lại user_id từ kết quả trên, ví dụ: 123


-- BƯỚC 2: THÊM SELLER RECORD
-- Thay YOUR_USER_ID bằng số user_id vừa tìm được ở trên
INSERT INTO gicungco_sellers (
    user_id,
    shop_name,
    shop_description,
    business_type,
    business_address,
    phone_number,
    status,
    rating,
    total_products,
    total_orders,
    commission_rate,
    created_at,
    updated_at
) VALUES (
    123,                              -- ⚠️ THAY 123 BẰNG USER_ID CỦA BẠN
    'My Test Shop',                   -- Tên shop (có thể đổi)
    'Shop test của tôi',             -- Mô tả (có thể đổi)
    'individual',                     -- Loại: individual hoặc company
    '123 Test Street, Hanoi',        -- Địa chỉ (có thể đổi)
    '0123456789',                    -- SĐT (có thể đổi)
    'active',                        -- ⚠️ QUAN TRỌNG: phải là 'active'
    5.0,                             -- Rating mặc định
    0,                               -- Số sản phẩm ban đầu
    0,                               -- Số đơn hàng ban đầu
    10.00,                           -- Hoa hồng 10%
    NOW(),
    NOW()
);


-- BƯỚC 3: KIỂM TRA LẠI
-- Chạy query này để confirm đã thêm thành công
SELECT 
    u.user_id,
    u.email,
    s.seller_id,
    s.shop_name,
    s.status,
    CASE 
        WHEN s.seller_id IS NULL THEN '❌ CHƯA CÓ SELLER'
        WHEN s.status = 'active' THEN '✅ SELLER ACTIVE - OK!'
        ELSE '⚠️ CHECK STATUS'
    END as result
FROM gicungco_users u
LEFT JOIN gicungco_sellers s ON u.user_id = s.user_id
WHERE u.user_id = 123;  -- ⚠️ THAY 123 BẰNG USER_ID CỦA BẠN


-- SAU KHI CHẠY SQL THÀNH CÔNG:
-- 1. Build lại project trong NetBeans (Clean and Build)
-- 2. Restart Tomcat
-- 3. Đăng xuất và đăng nhập lại
-- 4. Test các URL:
--    - http://localhost:9999/WEBGMS/seller/notifications
--    - http://localhost:9999/WEBGMS/seller/close-shop




