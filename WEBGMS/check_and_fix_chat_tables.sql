-- Comprehensive Chat System Check and Fix Script
USE gicungco;

-- Step 1: Check if tables exist
SHOW TABLES LIKE 'chat%';

-- Step 2: Check chat_rooms structure
DESCRIBE chat_rooms;

-- Step 3: If room_type is ENUM, convert it to VARCHAR
-- Run this only if room_type is ENUM (check the DESCRIBE output first)
-- ALTER TABLE chat_rooms MODIFY COLUMN room_type VARCHAR(50) NOT NULL;

-- Step 4: If room_type is already VARCHAR, this should show it
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    COLUMN_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'gicungco' 
  AND TABLE_NAME = 'chat_rooms' 
  AND COLUMN_NAME = 'room_type';

-- Step 5: Check if any ai_bot rooms exist
SELECT * FROM chat_rooms WHERE room_type = 'ai_bot';

-- Step 6: Check if chat tables are created correctly
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'gicungco' 
  AND TABLE_NAME IN ('chat_rooms', 'chat_participants', 'chat_messages');
