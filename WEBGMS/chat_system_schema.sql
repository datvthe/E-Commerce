-- ========================================
-- REAL-TIME CHAT SYSTEM SCHEMA
-- ========================================
USE gicungco;

-- Chat Rooms Table
CREATE TABLE IF NOT EXISTS `chat_rooms` (
    `room_id` BIGINT NOT NULL AUTO_INCREMENT,
    `room_type` ENUM('customer_seller', 'customer_admin', 'seller_admin', 'group') DEFAULT 'customer_seller',
    `room_name` VARCHAR(200) DEFAULT NULL,
    `product_id` BIGINT DEFAULT NULL,
    `order_id` BIGINT DEFAULT NULL,
    `is_active` BOOLEAN DEFAULT TRUE,
    `last_message_at` DATETIME DEFAULT NULL,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`room_id`),
    KEY `product_id` (`product_id`),
    KEY `order_id` (`order_id`),
    KEY `is_active` (`is_active`),
    CONSTRAINT `chat_rooms_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE SET NULL,
    CONSTRAINT `chat_rooms_ibfk_2` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Chat Participants Table
CREATE TABLE IF NOT EXISTS `chat_participants` (
    `participant_id` BIGINT NOT NULL AUTO_INCREMENT,
    `room_id` BIGINT NOT NULL,
    `user_id` BIGINT NOT NULL,
    `user_role` ENUM('customer', 'seller', 'admin') NOT NULL,
    `joined_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `last_read_at` DATETIME DEFAULT NULL,
    `unread_count` INT DEFAULT 0,
    `is_active` BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (`participant_id`),
    UNIQUE KEY `unique_room_user` (`room_id`, `user_id`),
    KEY `room_id` (`room_id`),
    KEY `user_id` (`user_id`),
    CONSTRAINT `chat_participants_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `chat_rooms` (`room_id`) ON DELETE CASCADE,
    CONSTRAINT `chat_participants_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Chat Messages Table
CREATE TABLE IF NOT EXISTS `chat_messages` (
    `message_id` BIGINT NOT NULL AUTO_INCREMENT,
    `room_id` BIGINT NOT NULL,
    `sender_id` BIGINT DEFAULT NULL,
    `sender_role` ENUM('customer', 'seller', 'admin', 'ai') DEFAULT 'customer',
    `message_type` ENUM('text', 'image', 'file', 'product', 'order', 'system') DEFAULT 'text',
    `message_content` LONGTEXT NOT NULL,
    `attachment_url` LONGTEXT DEFAULT NULL,
    `metadata` JSON DEFAULT NULL,
    `is_ai_response` BOOLEAN DEFAULT FALSE,
    `is_read` BOOLEAN DEFAULT FALSE,
    `is_edited` BOOLEAN DEFAULT FALSE,
    `is_deleted` BOOLEAN DEFAULT FALSE,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`message_id`),
    KEY `room_id` (`room_id`),
    KEY `sender_id` (`sender_id`),
    KEY `created_at` (`created_at`),
    KEY `is_ai_response` (`is_ai_response`),
    CONSTRAINT `chat_messages_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `chat_rooms` (`room_id`) ON DELETE CASCADE,
    CONSTRAINT `chat_messages_ibfk_2` FOREIGN KEY (`sender_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- AI Chat Templates Table (for automated responses)
CREATE TABLE IF NOT EXISTS `ai_chat_templates` (
    `template_id` INT NOT NULL AUTO_INCREMENT,
    `keyword` VARCHAR(200) NOT NULL,
    `response_text` LONGTEXT NOT NULL,
    `template_type` ENUM('greeting', 'faq', 'product_info', 'order_status', 'general') DEFAULT 'general',
    `priority` INT DEFAULT 0,
    `is_active` BOOLEAN DEFAULT TRUE,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`template_id`),
    KEY `keyword` (`keyword`),
    KEY `is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Chat Typing Indicators Table (for real-time typing status)
CREATE TABLE IF NOT EXISTS `chat_typing_status` (
    `typing_id` BIGINT NOT NULL AUTO_INCREMENT,
    `room_id` BIGINT NOT NULL,
    `user_id` BIGINT NOT NULL,
    `is_typing` BOOLEAN DEFAULT FALSE,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`typing_id`),
    UNIQUE KEY `unique_room_user_typing` (`room_id`, `user_id`),
    KEY `room_id` (`room_id`),
    KEY `user_id` (`user_id`),
    CONSTRAINT `chat_typing_status_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `chat_rooms` (`room_id`) ON DELETE CASCADE,
    CONSTRAINT `chat_typing_status_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default AI templates
INSERT INTO `ai_chat_templates` (`keyword`, `response_text`, `template_type`, `priority`, `is_active`) VALUES
('xin chào|hello|hi|chào', 'Xin chào! Tôi là trợ lý AI. Tôi có thể giúp gì cho bạn?', 'greeting', 10, TRUE),
('cảm ơn|thank|thanks', 'Không có gì! Tôi luôn sẵn sàng hỗ trợ bạn.', 'general', 5, TRUE),
('giá|price|bao nhiêu', 'Để biết thông tin giá cả chi tiết, vui lòng xem trang sản phẩm hoặc liên hệ với người bán.', 'product_info', 8, TRUE),
('đơn hàng|order|track', 'Bạn có thể theo dõi đơn hàng của mình trong mục "Đơn hàng" hoặc cung cấp mã đơn hàng để tôi kiểm tra.', 'order_status', 8, TRUE),
('hoàn tiền|refund|return', 'Chính sách hoàn tiền của chúng tôi được áp dụng trong vòng 7 ngày. Vui lòng liên hệ với người bán hoặc bộ phận hỗ trợ.', 'general', 7, TRUE),
('thanh toán|payment|pay', 'Chúng tôi hỗ trợ nhiều phương thức thanh toán: thẻ tín dụng, ví điện tử, và chuyển khoản ngân hàng.', 'general', 7, TRUE);
