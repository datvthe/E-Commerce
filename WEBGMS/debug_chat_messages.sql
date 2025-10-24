-- Debug script to check chat messages and their order
-- Run this to see the actual data and timestamps

USE gicungco;

-- Check the actual created_at values for room_id 9
SELECT 
    message_id,
    room_id,
    created_at,
    message_content,
    sender_role,
    sender_id
FROM chat_messages 
WHERE room_id = 9
ORDER BY message_id ASC;

-- Check if created_at column exists and has data
SELECT 
    COUNT(*) as total_messages,
    COUNT(created_at) as messages_with_timestamp,
    MIN(created_at) as earliest_timestamp,
    MAX(created_at) as latest_timestamp
FROM chat_messages 
WHERE room_id = 9;

-- Check the table structure
DESCRIBE chat_messages;

-- If created_at is NULL or corrupted, let's fix it
UPDATE chat_messages 
SET created_at = DATE_ADD('2024-01-01 00:00:00', INTERVAL (message_id - 1) MINUTE)
WHERE room_id = 9 
  AND (created_at IS NULL OR created_at = '0000-00-00 00:00:00' OR created_at < '2020-01-01');

-- Verify the fix
SELECT 
    message_id,
    room_id,
    created_at,
    message_content,
    sender_role
FROM chat_messages 
WHERE room_id = 9
ORDER BY message_id ASC;

