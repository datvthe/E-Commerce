-- ========================================
-- FORCE FIX CHAT MESSAGE ORDER
-- ========================================
-- This script will completely fix the chat message ordering issue
-- by resetting all timestamps based on message_id order

USE gicungco;

-- Step 1: Check current state
SELECT 
    'BEFORE FIX' as status,
    message_id,
    room_id,
    created_at,
    message_content
FROM chat_messages 
WHERE room_id = 9
ORDER BY message_id;

-- Step 2: Create backup
CREATE TABLE IF NOT EXISTS chat_messages_backup_$(date +%Y%m%d) AS 
SELECT * FROM chat_messages;

-- Step 3: Fix timestamps for room 9 based on message_id
-- Set timestamps in 1-minute intervals starting from a base time
UPDATE chat_messages 
SET created_at = DATE_ADD('2024-01-01 00:00:00', INTERVAL (message_id - (SELECT MIN(message_id) FROM chat_messages WHERE room_id = 9)) MINUTE)
WHERE room_id = 9;

-- Step 4: Verify the fix
SELECT 
    'AFTER FIX' as status,
    message_id,
    room_id,
    created_at,
    message_content
FROM chat_messages 
WHERE room_id = 9
ORDER BY message_id;

-- Step 5: Check if there are any remaining issues
SELECT 
    COUNT(*) as total_messages,
    COUNT(created_at) as messages_with_timestamp,
    MIN(created_at) as earliest_timestamp,
    MAX(created_at) as latest_timestamp
FROM chat_messages 
WHERE room_id = 9;

