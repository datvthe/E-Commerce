-- Script to hash all existing passwords in the database
-- This script will update all plain text passwords to hashed passwords

-- First, let's see what passwords we have
SELECT user_id, email, password, LENGTH(password) as password_length 
FROM Users 
WHERE status = 'active';

-- Note: This is a template script. You need to run the Java migration script instead
-- because we need to use the same hashing algorithm as the application.

-- The Java migration script will:
-- 1. Read all users with plain text passwords
-- 2. Hash them using PasswordUtil.hashPassword()
-- 3. Update the database with hashed passwords

-- Example of what the hashed password will look like:
-- Original: "123456"
-- Hashed: "a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3:random_salt_here"
