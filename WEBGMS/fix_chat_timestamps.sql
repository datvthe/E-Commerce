-- ========================================
-- FIX CORRUPTED CHAT MESSAGE TIMESTAMPS
-- ========================================
-- This script will repair corrupted timestamps in chat_messages table
-- Run this script in your MySQL database

USE gicungco;

-- First, let's see what we're dealing with
SELECT 
    message_id,
    room_id,
    created_at,
    message_content,
    sender_role
FROM chat_messages 
ORDER BY message_id 
LIMIT 20;

-- Create a backup table first (safety measure)
CREATE TABLE IF NOT EXISTS chat_messages_backup AS 
SELECT * FROM chat_messages;

-- Method 1: Fix timestamps based on message_id order
-- This assumes message_id reflects the actual chronological order
UPDATE chat_messages 
SET created_at = DATE_ADD(
    (SELECT MIN(created_at) FROM chat_messages WHERE room_id = cm.room_id),
    INTERVAL (cm.message_id - (SELECT MIN(message_id) FROM chat_messages WHERE room_id = cm.message_id)) MINUTE
)
WHERE message_id IN (
    SELECT message_id FROM chat_messages cm
    WHERE created_at IS NULL 
    OR created_at < '2020-01-01' 
    OR created_at > '2030-01-01'
    OR created_at = '0000-00-00 00:00:00'
);

-- Method 2: If Method 1 doesn't work, reset all timestamps based on message_id
-- This will set timestamps in 1-minute intervals starting from a base time
UPDATE chat_messages cm1
SET created_at = DATE_ADD(
    '2024-01-01 00:00:00',
    INTERVAL (cm1.message_id - (SELECT MIN(message_id) FROM chat_messages WHERE room_id = cm1.room_id)) MINUTE
)
WHERE cm1.room_id IN (
    SELECT DISTINCT room_id FROM chat_messages 
    WHERE created_at IS NULL 
    OR created_at < '2020-01-01' 
    OR created_at > '2030-01-01'
    OR created_at = '0000-00-00 00:00:00'
);

-- Method 3: For messages with completely wrong timestamps, use a more aggressive approach
-- This will set timestamps based on message_id with 30-second intervals
UPDATE chat_messages 
SET created_at = DATE_ADD(
    '2024-01-01 00:00:00',
    INTERVAL (message_id - (SELECT MIN(message_id) FROM chat_messages)) * 30 SECOND
)
WHERE created_at < '2020-01-01' 
   OR created_at > '2030-01-01'
   OR created_at = '0000-00-00 00:00:00'
   OR created_at IS NULL;

-- Verify the fix
SELECT 
    message_id,
    room_id,
    created_at,
    message_content,
    sender_role
FROM chat_messages 
ORDER BY created_at ASC
LIMIT 20;

-- Check for any remaining issues
SELECT COUNT(*) as corrupted_timestamps
FROM chat_messages 
WHERE created_at IS NULL 
   OR created_at < '2020-01-01' 
   OR created_at > '2030-01-01'
   OR created_at = '0000-00-00 00:00:00';

-- If you want to restore from backup (if something goes wrong):
-- DROP TABLE chat_messages;
-- RENAME TABLE chat_messages_backup TO chat_messages;
