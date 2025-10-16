-- Update password column to password_hash in users table
-- This script will rename the password column to password_hash

USE gicungco;

-- First, add the new password_hash column
ALTER TABLE `users` ADD COLUMN `password_hash` LONGTEXT NOT NULL AFTER `password`;

-- Copy existing password data to password_hash column
UPDATE `users` SET `password_hash` = `password`;

-- Drop the old password column
ALTER TABLE `users` DROP COLUMN `password`;

-- Rename password_hash to password (to match the code expectations)
ALTER TABLE `users` CHANGE `password_hash` `password` LONGTEXT NOT NULL;

-- Verify the changes
SELECT user_id, username, email, password, full_name, role FROM users LIMIT 5;
