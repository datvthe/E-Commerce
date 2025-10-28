-- Add columns for message edit/delete functionality
USE gicungco;

-- Check and add is_edited column
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'gicungco' 
    AND TABLE_NAME = 'chat_messages' 
    AND COLUMN_NAME = 'is_edited');

SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE chat_messages ADD COLUMN is_edited BOOLEAN DEFAULT FALSE AFTER message_content', 
    'SELECT "Column is_edited already exists" AS message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check and add is_deleted column
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'gicungco' 
    AND TABLE_NAME = 'chat_messages' 
    AND COLUMN_NAME = 'is_deleted');

SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE chat_messages ADD COLUMN is_deleted BOOLEAN DEFAULT FALSE AFTER message_content', 
    'SELECT "Column is_deleted already exists" AS message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check and add deleted_at column
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'gicungco' 
    AND TABLE_NAME = 'chat_messages' 
    AND COLUMN_NAME = 'deleted_at');

SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE chat_messages ADD COLUMN deleted_at DATETIME NULL AFTER is_deleted', 
    'SELECT "Column deleted_at already exists" AS message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Add index for better query performance
-- Check and create idx_chat_messages_deleted
SET @index_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS 
    WHERE TABLE_SCHEMA = 'gicungco' 
    AND TABLE_NAME = 'chat_messages' 
    AND INDEX_NAME = 'idx_chat_messages_deleted');

SET @sql = IF(@index_exists = 0, 
    'CREATE INDEX idx_chat_messages_deleted ON chat_messages(is_deleted)', 
    'SELECT "Index idx_chat_messages_deleted already exists" AS message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check and create idx_chat_messages_sender
SET @index_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS 
    WHERE TABLE_SCHEMA = 'gicungco' 
    AND TABLE_NAME = 'chat_messages' 
    AND INDEX_NAME = 'idx_chat_messages_sender');

SET @sql = IF(@index_exists = 0, 
    'CREATE INDEX idx_chat_messages_sender ON chat_messages(sender_id)', 
    'SELECT "Index idx_chat_messages_sender already exists" AS message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Show final structure
SELECT 'Message edit/delete columns added successfully!' AS Status;
DESCRIBE chat_messages;

