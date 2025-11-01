-- Tạo bảng notifications ĐƠN GIẢN

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

-- Thêm vài thông báo mẫu để test
INSERT INTO gicungco_notifications (user_id, title, message, type) VALUES
(1, 'Chào mừng!', 'Chào mừng bạn đến với hệ thống seller', 'system'),
(1, 'Đơn hàng mới', 'Bạn có 1 đơn hàng mới cần xử lý', 'order'),
(1, 'Thanh toán', 'Giao dịch thanh toán thành công', 'payment');

-- Kiểm tra
SELECT * FROM gicungco_notifications;




