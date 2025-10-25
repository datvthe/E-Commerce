-- Migrate legacy `password` column to `password_hash` (what the app uses)
USE gicungco;

-- Add password_hash if missing
ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `password_hash` LONGTEXT NULL AFTER `email`;

-- Copy legacy values if present
UPDATE `users` SET `password_hash` = `password` 
WHERE (`password_hash` IS NULL OR `password_hash` = '') AND `password` IS NOT NULL;

-- Drop legacy column if present (MySQL 8+)
ALTER TABLE `users` DROP COLUMN IF EXISTS `password`;

-- Verify
SELECT user_id, email, LEFT(password_hash, 16) AS hash_prefix, LOCATE(':', password_hash) AS colon_pos 
FROM users LIMIT 5;
