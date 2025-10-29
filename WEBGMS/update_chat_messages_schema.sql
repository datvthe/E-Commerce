-- Update chat_messages table schema to support image uploads and additional features
-- Run this script to add missing columns

USE gicungco;

-- Show current table structure
DESCRIBE chat_messages;

-- Add attachment_url column for image/file uploads
ALTER TABLE chat_messages 
ADD COLUMN IF NOT EXISTS attachment_url LONGTEXT DEFAULT NULL 
COMMENT 'URL to uploaded image or file'
AFTER message_content;

-- Add metadata column for storing additional message data (JSON format)
ALTER TABLE chat_messages 
ADD COLUMN IF NOT EXISTS metadata JSON DEFAULT NULL 
COMMENT 'Additional message metadata in JSON format'
AFTER attachment_url;

-- Add is_edited column if it doesn't exist
ALTER TABLE chat_messages 
ADD COLUMN IF NOT EXISTS is_edited BOOLEAN DEFAULT FALSE 
COMMENT 'Whether message has been edited'
AFTER is_read;

-- Add is_deleted column if it doesn't exist
ALTER TABLE chat_messages 
ADD COLUMN IF NOT EXISTS is_deleted BOOLEAN DEFAULT FALSE 
COMMENT 'Soft delete flag'
AFTER is_edited;

-- Add updated_at column if it doesn't exist
ALTER TABLE chat_messages 
ADD COLUMN IF NOT EXISTS updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
COMMENT 'Last update timestamp'
AFTER created_at;

-- Verify the updated schema
DESCRIBE chat_messages;

-- Show sample data with new columns
SELECT 
    message_id,
    room_id,
    sender_role,
    message_type,
    LEFT(message_content, 50) as message_preview,
    attachment_url,
    metadata,
    is_ai_response,
    is_read,
    is_edited,
    is_deleted,
    created_at,
    updated_at
FROM chat_messages 
ORDER BY message_id DESC
LIMIT 10;

-- Success message
SELECT 'Schema updated successfully! Image upload is now supported.' as status;
