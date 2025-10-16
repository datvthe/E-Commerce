-- Final hashed passwords for database update
-- Generated using the same algorithm as PasswordUtil.java

-- First, let's see current passwords
SELECT user_id, email, password_hash, LENGTH(password_hash) as password_length 
FROM users 
WHERE status = 'active';

-- Update passwords to hashed format
-- Admin password: "admin123" -> hashed
UPDATE users SET password_hash = '43Uo6E1/2ZcZl7yA5UR1jEPsyU7uznmLRHWhbQ0IgYA=:n1NxeFQRRJR2NLWkC0Qp2Q==' WHERE user_id = 1;

-- Seller password: "seller123" -> hashed  
UPDATE users SET password_hash = 'GnhFhFHEhHYamueG4UwSHG64spFo1/FwoCaE3KPdVLU=:wqMm7NhbRXCUP2DTWCDuPg==' WHERE user_id = 2;

-- Customer password: "customer123" -> hashed
UPDATE users SET password_hash = 'pDockmjy4Xv+AAi+K9bxHv6tPydWGqYMssCPHxK4tWM=:rkFBp4YkQ3ruY9+whLbT8A==' WHERE user_id = 3;

-- Moderator password: "moderator123" -> hashed
UPDATE users SET password_hash = 'M9wB1bI/rGEoW+UlERiUni4FYf+QsRinlm7JH7MbQ0s=:g2JFRHHKdoePUBVm+95wlw==' WHERE user_id = 4;

-- Admin2 password: "admin2123" -> hashed
UPDATE users SET password_hash = 'T9qsfU/WBeJ78GxlAYafFXllqGd0C0HWhNqArLdOqfQ=:TbFqMHWQvNAGvrftKp2JuA==' WHERE user_id = 10;

-- Verify the updates
SELECT user_id, email, password_hash, LENGTH(password_hash) as password_length 
FROM users 
WHERE status = 'active';

-- Test login credentials:
-- Admin: admin@example.com / admin123
-- Seller: seller1@example.com / seller123  
-- Customer: customer1@example.com / customer123
-- Moderator: moderator1@example.com / moderator123
-- Admin2: admin2@example.com / admin2123

-- Note: The format is "hashed_password:salt" where both are Base64 encoded
-- This matches the format used by PasswordUtil.java in the application
