-- Simple fix for chat message order
-- Run this in your database management tool

USE gicungco;

-- Check current state
SELECT 
    message_id,
    room_id,
    created_at,
    message_content
FROM chat_messages 
WHERE room_id = 9
ORDER BY message_id;

-- Fix timestamps for room 9
UPDATE chat_messages 
SET created_at = DATE_ADD('2024-01-01 00:00:00', INTERVAL (message_id - 32) MINUTE)
WHERE room_id = 9;

-- Verify the fix
SELECT 
    message_id,
    room_id,
    created_at,
    message_content
FROM chat_messages 
WHERE room_id = 9
ORDER BY message_id;

