-- Script to identify plain-text passwords and migrate them
-- This is a template. Prefer running util.PasswordMigration.java for consistent hashing.

-- Check current passwords (app uses password_hash)
SELECT user_id, email, LEFT(password_hash, 8) as hash_prefix, LOCATE(':', password_hash) has_colon
FROM users
WHERE status = 'active';

-- If you still have a legacy `password` column, migrate with update_to_password_hash.sql first.
