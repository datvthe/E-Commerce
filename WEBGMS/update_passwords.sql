-- Update passwords to hashed format
-- This script will update all plain text passwords to hashed passwords

-- First, let's check current passwords
SELECT user_id, email, password_hash, LENGTH(password_hash) as password_length 
FROM users 
WHERE status = 'active';

-- Update passwords to hashed format
-- Note: These are example hashed passwords. In production, use the Java migration script.

-- Admin password: "admin123" -> hashed
UPDATE users SET password_hash = 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3:random_salt_1' WHERE user_id = 1;

-- Seller password: "seller123" -> hashed  
UPDATE users SET password_hash = 'b665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae4:random_salt_2' WHERE user_id = 2;

-- Customer password: "customer123" -> hashed
UPDATE users SET password_hash = 'c665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae5:random_salt_3' WHERE user_id = 3;

-- Moderator password: "moderator123" -> hashed
UPDATE users SET password_hash = 'd665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae6:random_salt_4' WHERE user_id = 4;

-- Admin2 password: "admin2123" -> hashed
UPDATE users SET password_hash = 'e665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae7:random_salt_5' WHERE user_id = 10;

-- Verify the updates
SELECT user_id, email, password_hash, LENGTH(password_hash) as password_length 
FROM users 
WHERE status = 'active';
