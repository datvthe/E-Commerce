-- ================================================
-- 📝 BLOG SYSTEM - COMPLETE DATABASE SCHEMA
-- ================================================
-- Purpose: Hệ thống blog với workflow phê duyệt
-- Features:
--   - User/Seller tạo blog (DRAFT/PENDING)
--   - Admin phê duyệt/từ chối (APPROVED/REJECTED)
--   - Hiển thị blog mới nhất trên trang chủ
--   - Comment & Like system
--   - Notification system
-- ================================================

USE gicungco;

-- ================================================
-- 1. BẢNG BLOGS (Core blog data)
-- ================================================

CREATE TABLE IF NOT EXISTS blogs (
  blog_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL COMMENT 'Tác giả blog',
  
  -- Content fields
  title VARCHAR(255) NOT NULL COMMENT 'Tiêu đề blog',
  slug VARCHAR(255) UNIQUE NOT NULL COMMENT 'URL-friendly slug',
  summary TEXT COMMENT 'Tóm tắt ngắn (hiển thị trên card)',
  content LONGTEXT NOT NULL COMMENT 'Nội dung blog (HTML)',
  featured_image VARCHAR(500) COMMENT 'Ảnh đại diện',
  
  -- Moderation fields
  status ENUM('DRAFT', 'PENDING', 'APPROVED', 'REJECTED') 
    DEFAULT 'DRAFT' COMMENT 'Trạng thái blog',
  moderator_id INT COMMENT 'Admin phê duyệt',
  moderation_note TEXT COMMENT 'Lý do từ chối',
  moderated_at TIMESTAMP NULL COMMENT 'Thời gian phê duyệt',
  
  -- SEO fields
  meta_title VARCHAR(255) COMMENT 'SEO title',
  meta_description TEXT COMMENT 'SEO description',
  meta_keywords VARCHAR(500) COMMENT 'SEO keywords',
  
  -- Statistics
  view_count INT DEFAULT 0 COMMENT 'Số lượt xem',
  like_count INT DEFAULT 0 COMMENT 'Số lượt thích',
  comment_count INT DEFAULT 0 COMMENT 'Số bình luận',
  
  -- Timestamps
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  published_at TIMESTAMP NULL COMMENT 'Thời gian publish (khi approved)',
  
  -- Foreign Keys
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (moderator_id) REFERENCES users(user_id) ON DELETE SET NULL,
  
  -- Indexes for performance
  INDEX idx_user (user_id),
  INDEX idx_status (status),
  INDEX idx_slug (slug),
  INDEX idx_created (created_at DESC),
  INDEX idx_published (published_at DESC),
  INDEX idx_status_published (status, published_at DESC)
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Bảng lưu trữ blog posts';

-- ================================================
-- 2. BẢNG BLOG_IMAGES (Blog image gallery)
-- ================================================

CREATE TABLE IF NOT EXISTS blog_images (
  image_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  blog_id BIGINT NOT NULL,
  image_url VARCHAR(500) NOT NULL COMMENT 'URL ảnh',
  caption TEXT COMMENT 'Mô tả ảnh',
  display_order INT DEFAULT 0 COMMENT 'Thứ tự hiển thị',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (blog_id) REFERENCES blogs(blog_id) ON DELETE CASCADE,
  INDEX idx_blog (blog_id),
  INDEX idx_order (display_order)
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Ảnh trong blog';

-- ================================================
-- 3. BẢNG BLOG_COMMENTS (Comment system)
-- ================================================

CREATE TABLE IF NOT EXISTS blog_comments (
  comment_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  blog_id BIGINT NOT NULL,
  user_id INT NOT NULL COMMENT 'Người comment',
  parent_comment_id BIGINT NULL COMMENT 'Reply to comment',
  content TEXT NOT NULL COMMENT 'Nội dung comment',
  status ENUM('PENDING', 'APPROVED', 'SPAM') 
    DEFAULT 'APPROVED' COMMENT 'Trạng thái comment',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  FOREIGN KEY (blog_id) REFERENCES blogs(blog_id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (parent_comment_id) REFERENCES blog_comments(comment_id) ON DELETE CASCADE,
  
  INDEX idx_blog (blog_id),
  INDEX idx_user (user_id),
  INDEX idx_parent (parent_comment_id),
  INDEX idx_status (status)
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Bình luận trên blog';

-- ================================================
-- 4. BẢNG BLOG_LIKES (Like system)
-- ================================================

CREATE TABLE IF NOT EXISTS blog_likes (
  like_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  blog_id BIGINT NOT NULL,
  user_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (blog_id) REFERENCES blogs(blog_id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  
  UNIQUE KEY unique_like (blog_id, user_id) COMMENT 'Mỗi user chỉ like 1 lần',
  INDEX idx_blog (blog_id),
  INDEX idx_user (user_id)
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Lượt thích blog';

-- ================================================
-- 5. BẢNG BLOG_NOTIFICATIONS (Notification system)
-- ================================================

CREATE TABLE IF NOT EXISTS blog_notifications (
  notification_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  blog_id BIGINT NOT NULL,
  user_id INT NOT NULL COMMENT 'Người nhận notification',
  type ENUM('APPROVED', 'REJECTED', 'COMMENT', 'LIKE') NOT NULL,
  title VARCHAR(255) NOT NULL COMMENT 'Tiêu đề notification',
  message TEXT NOT NULL COMMENT 'Nội dung notification',
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (blog_id) REFERENCES blogs(blog_id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  
  INDEX idx_user_read (user_id, is_read),
  INDEX idx_created (created_at DESC),
  INDEX idx_type (type)
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Thông báo về blog';

-- ================================================
-- 6. INSERT SAMPLE DATA (Optional - for testing)
-- ================================================

-- Sample blog (APPROVED - for homepage display)
INSERT INTO blogs 
(user_id, title, slug, summary, content, featured_image, status, published_at, view_count, like_count, comment_count)
VALUES
(1, 
 'Hướng dẫn mua sắm online an toàn', 
 'huong-dan-mua-sam-online-an-toan',
 'Những lưu ý quan trọng khi mua sắm trực tuyến để bảo vệ thông tin và tài khoản của bạn.',
 '<h2>1. Chọn website uy tín</h2><p>Luôn kiểm tra domain và certificate của website...</p><h2>2. Bảo mật thông tin</h2><p>Không chia sẻ mật khẩu hoặc mã OTP với bất kỳ ai...</p>',
 '/assets/img/blog/shopping-guide.jpg',
 'APPROVED',
 NOW(),
 1250,
 45,
 12
),
(2,
 'Top 5 sản phẩm công nghệ hot nhất 2025',
 'top-5-san-pham-cong-nghe-hot-nhat-2025',
 'Điểm qua 5 sản phẩm công nghệ được săn đón nhiều nhất trong năm 2025.',
 '<h2>1. Smartphone AI</h2><p>Công nghệ AI tích hợp sâu vào smartphone...</p><h2>2. VR Headset</h2><p>Thực tế ảo ngày càng phổ biến...</p>',
 '/assets/img/blog/tech-products.jpg',
 'APPROVED',
 DATE_SUB(NOW(), INTERVAL 1 DAY),
 890,
 67,
 23
),
(1,
 'Cách tối ưu hóa trải nghiệm game',
 'cach-toi-uu-hoa-trai-nghiem-game',
 'Các mẹo và thủ thuật để cải thiện hiệu suất chơi game trên PC và console.',
 '<h2>1. Tối ưu cấu hình</h2><p>Điều chỉnh settings phù hợp với cấu hình...</p><h2>2. Update driver</h2><p>Luôn cập nhật driver card màn hình...</p>',
 '/assets/img/blog/gaming-tips.jpg',
 'APPROVED',
 DATE_SUB(NOW(), INTERVAL 2 DAY),
 560,
 34,
 8
);

-- Sample blog (PENDING - waiting for moderation)
INSERT INTO blogs 
(user_id, title, slug, summary, content, status)
VALUES
(17,
 'Review chi tiết game mới ra mắt',
 'review-chi-tiet-game-moi-ra-mat',
 'Đánh giá toàn diện về game XYZ vừa ra mắt tuần trước.',
 '<h2>Đồ họa</h2><p>Đồ họa game rất đẹp...</p><h2>Gameplay</h2><p>Lối chơi hấp dẫn...</p>',
 'PENDING'
);

-- Sample comments
INSERT INTO blog_comments (blog_id, user_id, content, status)
VALUES
(1, 2, 'Bài viết rất hữu ích, cảm ơn tác giả!', 'APPROVED'),
(1, 17, 'Mình đã áp dụng và thấy hiệu quả.', 'APPROVED'),
(2, 1, 'Bài viết hay, đang đợi mua sản phẩm số 3.', 'APPROVED');

-- Sample likes
INSERT INTO blog_likes (blog_id, user_id)
VALUES
(1, 2),
(1, 17),
(2, 1),
(2, 17),
(3, 2);

-- ================================================
-- 7. VIEWS (Useful queries)
-- ================================================

-- View: Blog đang chờ phê duyệt
CREATE OR REPLACE VIEW v_pending_blogs AS
SELECT 
    b.blog_id,
    b.title,
    b.slug,
    b.summary,
    b.created_at,
    u.user_id,
    u.full_name AS author_name,
    u.email AS author_email,
    u.role AS author_role
FROM blogs b
JOIN users u ON b.user_id = u.user_id
WHERE b.status = 'PENDING'
ORDER BY b.created_at ASC;

-- View: Blog đã được phê duyệt (public)
CREATE OR REPLACE VIEW v_approved_blogs AS
SELECT 
    b.blog_id,
    b.title,
    b.slug,
    b.summary,
    b.featured_image,
    b.view_count,
    b.like_count,
    b.comment_count,
    b.published_at,
    u.user_id,
    u.full_name AS author_name
FROM blogs b
JOIN users u ON b.user_id = u.user_id
WHERE b.status = 'APPROVED'
ORDER BY b.published_at DESC;

-- View: Blog statistics by user
CREATE OR REPLACE VIEW v_blog_stats_by_user AS
SELECT 
    u.user_id,
    u.full_name,
    u.email,
    COUNT(b.blog_id) AS total_blogs,
    SUM(CASE WHEN b.status = 'APPROVED' THEN 1 ELSE 0 END) AS approved_blogs,
    SUM(CASE WHEN b.status = 'PENDING' THEN 1 ELSE 0 END) AS pending_blogs,
    SUM(CASE WHEN b.status = 'REJECTED' THEN 1 ELSE 0 END) AS rejected_blogs,
    SUM(CASE WHEN b.status = 'DRAFT' THEN 1 ELSE 0 END) AS draft_blogs,
    SUM(b.view_count) AS total_views,
    SUM(b.like_count) AS total_likes,
    SUM(b.comment_count) AS total_comments
FROM users u
LEFT JOIN blogs b ON u.user_id = b.user_id
GROUP BY u.user_id, u.full_name, u.email;

-- ================================================
-- 8. TRIGGERS (Auto-update counters)
-- ================================================

-- Trigger: Tăng comment_count khi có comment mới
DELIMITER $$
CREATE TRIGGER after_comment_insert
AFTER INSERT ON blog_comments
FOR EACH ROW
BEGIN
    IF NEW.status = 'APPROVED' THEN
        UPDATE blogs 
        SET comment_count = comment_count + 1 
        WHERE blog_id = NEW.blog_id;
    END IF;
END$$
DELIMITER ;

-- Trigger: Tăng like_count khi có like mới
DELIMITER $$
CREATE TRIGGER after_like_insert
AFTER INSERT ON blog_likes
FOR EACH ROW
BEGIN
    UPDATE blogs 
    SET like_count = like_count + 1 
    WHERE blog_id = NEW.blog_id;
END$$
DELIMITER ;

-- Trigger: Giảm like_count khi unlike
DELIMITER $$
CREATE TRIGGER after_like_delete
AFTER DELETE ON blog_likes
FOR EACH ROW
BEGIN
    UPDATE blogs 
    SET like_count = like_count - 1 
    WHERE blog_id = OLD.blog_id;
END$$
DELIMITER ;

-- ================================================
-- 9. STORED PROCEDURES (Common operations)
-- ================================================

-- Procedure: Phê duyệt blog
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

-- Procedure: Từ chối blog
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

-- ================================================
-- 10. VERIFY TABLES
-- ================================================

SELECT 
    TABLE_NAME,
    TABLE_ROWS,
    ROUND(((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024), 2) AS 'Size (MB)'
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'gicungco'
  AND TABLE_NAME LIKE 'blog%'
ORDER BY TABLE_NAME;

-- ================================================
-- ✅ BLOG SYSTEM DATABASE - COMPLETED!
-- ================================================
-- Tiếp theo: Tạo Model classes và DAO classes
-- ================================================

