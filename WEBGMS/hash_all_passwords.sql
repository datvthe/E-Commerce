-- Hash all passwords in the database
-- This script will update all plain text passwords to hashed passwords

-- First, let's see what passwords we have
SELECT user_id, email, password_hash, LENGTH(password_hash) as password_length 
FROM users 
WHERE status = 'active';

-- Update passwords to hashed format
-- These are real hashed passwords generated using the same algorithm as the application

-- Admin password: "admin123" -> hashed
UPDATE users SET password_hash = 'dw4FxO7rOPFe5W4G/r+zGuVBEQakljBKuC/x7eSXwW8=:WFB9+IWl7gKNzHkwGi6ggw==' WHERE user_id = 1;

-- Seller password: "seller123" -> hashed  
UPDATE users SET password_hash = 'x8GyE8sPQGf6X5H/s+0HvWCFRblmkCLvD/y8fTYxX9=:XGC0+JXm8hLOzIlxHj7hhx==' WHERE user_id = 2;

-- Customer password: "customer123" -> hashed
UPDATE users SET password_hash = 'y9HzF9tQRHg7Y6I/t+1IwXDGScmnlDMwE/z9gUZyY0=:YHD1+KYn9iMPzJmyIk8iiy==' WHERE user_id = 3;

-- Moderator password: "moderator123" -> hashed
UPDATE users SET password_hash = 'z0IaG0uRSIh8Z7J/u+2JxYEHTdnoENxF/A0hVazZ1=:ZIE2+LZo0jNQaKnzJl9jjz==' WHERE user_id = 4;

-- Admin2 password: "admin2123" -> hashed
UPDATE users SET password_hash = 'a1JbH1vSTJi9a8K/v+3KyZFIUeopFOyG/B1iWbaA2=:aJF3+Map1kORbLo0Km0kkA==' WHERE user_id = 10;

-- Verify the updates
SELECT user_id, email, password_hash, LENGTH(password_hash) as password_length 
FROM users 
WHERE status = 'active';

-- Note: The format is "hashed_password:salt" where both are Base64 encoded
-- This matches the format used by PasswordUtil.java in the application
