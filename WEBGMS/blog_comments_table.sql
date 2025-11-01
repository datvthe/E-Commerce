-- ================================================
-- BLOG COMMENTS TABLE
-- ================================================
-- Drop existing triggers first (if any)
DROP TRIGGER IF EXISTS after_comment_insert;
DROP TRIGGER IF EXISTS after_comment_delete;

-- Create table for storing blog comments
-- Supports nested replies (1 level deep)
CREATE TABLE IF NOT EXISTS blog_comments (
  comment_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  blog_id BIGINT NOT NULL COMMENT 'Blog post ID',
  user_id BIGINT NOT NULL COMMENT 'Commenter user ID',
  content TEXT NOT NULL COMMENT 'Comment content',
  parent_comment_id BIGINT NULL COMMENT 'Parent comment for replies',
  is_deleted BOOLEAN DEFAULT FALSE COMMENT 'Soft delete flag',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  -- Foreign Keys
  FOREIGN KEY (blog_id) REFERENCES blogs(blog_id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (parent_comment_id) REFERENCES blog_comments(comment_id) ON DELETE CASCADE,
  
  -- Indexes
  INDEX idx_blog (blog_id),
  INDEX idx_user (user_id),
  INDEX idx_parent (parent_comment_id),
  INDEX idx_created (created_at DESC),
  INDEX idx_blog_parent (blog_id, parent_comment_id)
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Blog comments with nested replies support';

-- ================================================
-- TRIGGER: Update blog comment_count
-- ================================================
-- Must create triggers AFTER table creation

DELIMITER $$

CREATE TRIGGER after_comment_insert
AFTER INSERT ON blog_comments
FOR EACH ROW
BEGIN
  IF NEW.is_deleted = FALSE THEN
    UPDATE blogs 
    SET comment_count = comment_count + 1 
    WHERE blog_id = NEW.blog_id;
  END IF;
END$$

CREATE TRIGGER after_comment_delete
AFTER UPDATE ON blog_comments
FOR EACH ROW
BEGIN
  IF NEW.is_deleted = TRUE AND OLD.is_deleted = FALSE THEN
    UPDATE blogs 
    SET comment_count = comment_count - 1 
    WHERE blog_id = NEW.blog_id;
  END IF;
END$$

DELIMITER ;

-- ================================================
-- SAMPLE DATA (Optional - for testing)
-- ================================================
-- Add some sample comments
INSERT INTO blog_comments (blog_id, user_id, content, parent_comment_id) VALUES
(1, 1, 'Bài viết rất hay và bổ ích! Cảm ơn tác giả đã chia sẻ.', NULL),
(1, 2, 'Tôi hoàn toàn đồng ý với bạn. Nội dung rất chất lượng.', 1),
(1, 3, 'Mình đã áp dụng theo hướng dẫn này và thấy rất hiệu quả.', NULL),
(1, 1, 'Cảm ơn bạn đã phản hồi tích cực!', 3);

-- ================================================
-- UTILITY QUERIES
-- ================================================

-- Get all comments for a blog (with user info)
SELECT 
  bc.*,
  u.full_name as user_name,
  u.avatar_url as user_avatar,
  (SELECT COUNT(*) FROM blog_comments WHERE parent_comment_id = bc.comment_id AND is_deleted = FALSE) as reply_count
FROM blog_comments bc
JOIN users u ON bc.user_id = u.user_id
WHERE bc.blog_id = 1 AND bc.is_deleted = FALSE
ORDER BY bc.created_at DESC;

-- Get top-level comments only
SELECT 
  bc.*,
  u.full_name as user_name,
  (SELECT COUNT(*) FROM blog_comments WHERE parent_comment_id = bc.comment_id AND is_deleted = FALSE) as reply_count
FROM blog_comments bc
JOIN users u ON bc.user_id = u.user_id
WHERE bc.blog_id = 1 AND bc.parent_comment_id IS NULL AND bc.is_deleted = FALSE
ORDER BY bc.created_at DESC;

-- Get replies for a comment
SELECT 
  bc.*,
  u.full_name as user_name
FROM blog_comments bc
JOIN users u ON bc.user_id = u.user_id
WHERE bc.parent_comment_id = 1 AND bc.is_deleted = FALSE
ORDER BY bc.created_at ASC;

-- Update comment count for all blogs
UPDATE blogs b
SET comment_count = (
  SELECT COUNT(*) 
  FROM blog_comments 
  WHERE blog_id = b.blog_id AND is_deleted = FALSE
);

-- ================================================
-- DONE!
-- ================================================

