-- Add attachment_url column to chat_messages table for image uploads
-- Run this script to enable image upload functionality

USE gicungco;

-- Add attachment_url column if it doesn't exist
ALTER TABLE chat_messages 
ADD COLUMN IF NOT EXISTS attachment_url LONGTEXT DEFAULT NULL 
AFTER message_content;

-- Verify the column was added
DESCRIBE chat_messages;

-- Check current data
SELECT 
    message_id,
    room_id,
    sender_role,
    message_type,
    message_content,
    attachment_url,
    is_ai_response
FROM chat_messages 
ORDER BY message_id DESC
LIMIT 10;
