-- ═══════════════════════════════════════════════════════════════
-- SETUP NOTIFICATIONS - CHAY FILE NAY TRUOC KHI TEST
-- ═══════════════════════════════════════════════════════════════

-- BUOC 1: TIM USER_ID CUA BAN
-- Thay 'your_email@example.com' bang email cua ban
SELECT user_id, email, full_name 
FROM gicungco_users 
WHERE email = 'your_email@example.com';

-- GHI LAI user_id tu ket qua tren. Vi du: user_id = 5
-- Sau do thay THE 3 CHO CO user_id O DUOI DAY


-- BUOC 2: TAO BANG NOTIFICATIONS
CREATE TABLE IF NOT EXISTS gicungco_notifications (
    notification_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) DEFAULT 'system',
    is_read BOOLEAN DEFAULT FALSE,
    link_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_user_id (user_id),
    INDEX idx_is_read (is_read),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- BUOC 3: THEM THONG BAO MAU
-- ⚠️ THAY 1 BANG user_id CUA BAN (tu buoc 1)
INSERT INTO gicungco_notifications (user_id, title, message, type) VALUES
(1, 'Chào mừng!', 'Chào mừng bạn đến với hệ thống seller', 'system'),
(1, 'Đơn hàng mới', 'Bạn có 1 đơn hàng mới cần xử lý', 'order'),
(1, 'Thanh toán', 'Giao dịch thanh toán thành công', 'payment');


-- BUOC 4: KIEM TRA
SELECT * FROM gicungco_notifications;

-- Ket qua phai co 3 dong voi user_id cua ban


-- ═══════════════════════════════════════════════════════════════
-- SAU KHI CHAY SQL THANH CONG:
-- 1. Clean and Build project trong NetBeans
-- 2. Restart Tomcat
-- 3. Login vao he thong
-- 4. Truy cap: http://localhost:9999/WEBGMS/seller/notifications
-- ═══════════════════════════════════════════════════════════════




