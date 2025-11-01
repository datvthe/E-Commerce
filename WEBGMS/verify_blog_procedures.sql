-- Verify Blog Stored Procedures

-- 1. Check if stored procedures exist
SELECT 
    ROUTINE_NAME,
    ROUTINE_TYPE,
    CREATED,
    LAST_ALTERED
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = 'gicungco'
  AND ROUTINE_NAME IN ('sp_approve_blog', 'sp_reject_blog')
ORDER BY ROUTINE_NAME;

-- 2. If procedures don't exist, create them

-- Drop existing procedures (if any)
DROP PROCEDURE IF EXISTS sp_approve_blog;
DROP PROCEDURE IF EXISTS sp_reject_blog;

-- Create sp_approve_blog
DELIMITER $$
CREATE PROCEDURE sp_approve_blog(
    IN p_blog_id BIGINT,
    IN p_moderator_id INT
)
BEGIN
    UPDATE blogs
    SET status = 'APPROVED',
        moderator_id = p_moderator_id,
        moderated_at = NOW(),
        published_at = NOW()
    WHERE blog_id = p_blog_id;
    
    -- Tạo notification cho tác giả
    INSERT INTO blog_notifications (blog_id, user_id, type, title, message)
    SELECT 
        blog_id,
        user_id,
        'APPROVED',
        'Blog của bạn đã được phê duyệt! 🎉',
        CONCAT('Blog "', title, '" đã được phê duyệt và đang hiển thị công khai.')
    FROM blogs
    WHERE blog_id = p_blog_id;
END$$
DELIMITER ;

-- Create sp_reject_blog
DELIMITER $$
CREATE PROCEDURE sp_reject_blog(
    IN p_blog_id BIGINT,
    IN p_moderator_id INT,
    IN p_reason TEXT
)
BEGIN
    UPDATE blogs
    SET status = 'REJECTED',
        moderator_id = p_moderator_id,
        moderated_at = NOW(),
        moderation_note = p_reason
    WHERE blog_id = p_blog_id;
    
    -- Tạo notification cho tác giả
    INSERT INTO blog_notifications (blog_id, user_id, type, title, message)
    SELECT 
        blog_id,
        user_id,
        'REJECTED',
        'Blog của bạn bị từ chối ❌',
        CONCAT('Blog "', title, '" đã bị từ chối. Lý do: ', p_reason)
    FROM blogs
    WHERE blog_id = p_blog_id;
END$$
DELIMITER ;

-- 3. Verify creation
SELECT 
    ROUTINE_NAME,
    ROUTINE_TYPE,
    'Created Successfully' AS Status
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = 'gicungco'
  AND ROUTINE_NAME IN ('sp_approve_blog', 'sp_reject_blog')
ORDER BY ROUTINE_NAME;

-- 4. Test with a sample blog (optional - comment out if not needed)
-- CALL sp_approve_blog(1, 1);
-- CALL sp_reject_blog(1, 1, 'Test rejection reason');

