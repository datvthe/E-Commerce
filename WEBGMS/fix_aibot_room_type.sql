-- Fix chat_rooms table to support ai_bot room type
USE gicungco;

-- Alter the chat_rooms table to add 'ai_bot' to the room_type ENUM
ALTER TABLE `chat_rooms` 
MODIFY COLUMN `room_type` ENUM('customer_seller', 'customer_admin', 'seller_admin', 'group', 'ai_bot') 
DEFAULT 'customer_seller';

-- Verify the change
DESCRIBE chat_rooms;
