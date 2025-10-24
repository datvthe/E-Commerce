-- Create Chat Tables for AI Bot System

-- 1. Chat Rooms Table
CREATE TABLE IF NOT EXISTS `chat_rooms` (
  `room_id` BIGINT AUTO_INCREMENT PRIMARY KEY,
  `room_type` VARCHAR(50) NOT NULL COMMENT 'ai_bot, customer_seller, customer_admin, etc',
  `room_name` VARCHAR(255) NOT NULL,
  `product_id` BIGINT NULL,
  `order_id` BIGINT NULL,
  `is_active` BOOLEAN DEFAULT TRUE,
  `last_message_at` TIMESTAMP NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_room_type (room_type),
  INDEX idx_active (is_active),
  INDEX idx_last_message (last_message_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Chat Participants Table
CREATE TABLE IF NOT EXISTS `chat_participants` (
  `participant_id` BIGINT AUTO_INCREMENT PRIMARY KEY,
  `room_id` BIGINT NOT NULL,
  `user_id` BIGINT NOT NULL,
  `user_role` VARCHAR(50) NOT NULL COMMENT 'customer, seller, admin',
  `joined_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `last_read_at` TIMESTAMP NULL,
  `unread_count` INT DEFAULT 0,
  `is_active` BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (room_id) REFERENCES chat_rooms(room_id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  UNIQUE KEY unique_room_user (room_id, user_id),
  INDEX idx_user (user_id),
  INDEX idx_room (room_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Chat Messages Table
CREATE TABLE IF NOT EXISTS `chat_messages` (
  `message_id` BIGINT AUTO_INCREMENT PRIMARY KEY,
  `room_id` BIGINT NOT NULL,
  `sender_id` BIGINT NULL COMMENT 'NULL for AI messages',
  `sender_role` VARCHAR(50) NOT NULL COMMENT 'customer, seller, admin, ai',
  `message_type` VARCHAR(50) DEFAULT 'text' COMMENT 'text, image, file, system',
  `message_content` TEXT NOT NULL,
  `attachment_url` VARCHAR(500) NULL,
  `metadata` TEXT NULL COMMENT 'JSON data',
  `is_ai_response` BOOLEAN DEFAULT FALSE,
  `is_read` BOOLEAN DEFAULT FALSE,
  `is_edited` BOOLEAN DEFAULT FALSE,
  `is_deleted` BOOLEAN DEFAULT FALSE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (room_id) REFERENCES chat_rooms(room_id) ON DELETE CASCADE,
  INDEX idx_room (room_id),
  INDEX idx_sender (sender_id),
  INDEX idx_created (created_at),
  INDEX idx_is_read (is_read)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert initial data (optional)
-- You can run this if you want some test data
-- INSERT INTO chat_rooms (room_type, room_name) VALUES ('ai_bot', 'AI Bot Test Room');
