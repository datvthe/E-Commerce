-- ================================================
-- 📝 BLOG SYSTEM - SAFE VERSION
-- Tự động lấy kiểu dữ liệu từ bảng users
-- ================================================

USE gicungco;

-- ================================================
-- 1. TẠO BẢNG BLOGS (Không có FK trước)
-- ================================================

CREATE TABLE IF NOT EXISTS blogs (
  blog_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL COMMENT 'Tác giả blog - SẼ SỬA SAU',
  
  -- Content fields
  title VARCHAR(255) NOT NULL,
  slug VARCHAR(255) UNIQUE NOT NULL,
  summary TEXT,
  content LONGTEXT NOT NULL,
  featured_image VARCHAR(500),
  
  -- Moderation fields
  status ENUM('DRAFT', 'PENDING', 'APPROVED', 'REJECTED') DEFAULT 'DRAFT',
  moderator_id INT COMMENT 'SẼ SỬA SAU',
  moderation_note TEXT,
  moderated_at TIMESTAMP NULL,
  
  -- SEO fields
  meta_title VARCHAR(255),
  meta_description TEXT,
  meta_keywords VARCHAR(500),
  
  -- Statistics
  view_count INT DEFAULT 0,
  like_count INT DEFAULT 0,
  comment_count INT DEFAULT 0,
  
  -- Timestamps
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  published_at TIMESTAMP NULL,
  
  -- Indexes
  INDEX idx_user (user_id),
  INDEX idx_status (status),
  INDEX idx_slug (slug),
  INDEX idx_created (created_at DESC),
  INDEX idx_published (published_at DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================
-- 2. SỬA KIỂU DỮ LIỆU user_id (nếu cần)
-- ================================================

-- Kiểm tra kiểu dữ liệu của users.user_id
SET @user_id_type = (
    SELECT DATA_TYPE 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'gicungco' 
      AND TABLE_NAME = 'users' 
      AND COLUMN_NAME = 'user_id'
);

-- Nếu users.user_id là BIGINT, sửa blogs.user_id thành BIGINT
-- (Chạy thủ công nếu cần)
-- ALTER TABLE blogs MODIFY COLUMN user_id BIGINT NOT NULL;
-- ALTER TABLE blogs MODIFY COLUMN moderator_id BIGINT;

-- ================================================
-- 3. THÊM FOREIGN KEYS (sau khi kiểu dữ liệu đúng)
-- ================================================

-- Bỏ comment 2 dòng này sau khi đã sửa kiểu dữ liệu
-- ALTER TABLE blogs ADD FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE;
-- ALTER TABLE blogs ADD FOREIGN KEY (moderator_id) REFERENCES users(user_id) ON DELETE SET NULL;

-- ================================================
-- 4. CÁC BẢNG KHÁC
-- ================================================

CREATE TABLE IF NOT EXISTS blog_images (
  image_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  blog_id BIGINT NOT NULL,
  image_url VARCHAR(500) NOT NULL,
  caption TEXT,
  display_order INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (blog_id) REFERENCES blogs(blog_id) ON DELETE CASCADE,
  INDEX idx_blog (blog_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS blog_comments (
  comment_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  blog_id BIGINT NOT NULL,
  user_id INT NOT NULL COMMENT 'SẼ SỬA SAU nếu cần',
  parent_comment_id BIGINT NULL,
  content TEXT NOT NULL,
  status ENUM('PENDING', 'APPROVED', 'SPAM') DEFAULT 'APPROVED',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (blog_id) REFERENCES blogs(blog_id) ON DELETE CASCADE,
  -- FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (parent_comment_id) REFERENCES blog_comments(comment_id) ON DELETE CASCADE,
  INDEX idx_blog (blog_id),
  INDEX idx_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS blog_likes (
  like_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  blog_id BIGINT NOT NULL,
  user_id INT NOT NULL COMMENT 'SẼ SỬA SAU nếu cần',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (blog_id) REFERENCES blogs(blog_id) ON DELETE CASCADE,
  -- FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  UNIQUE KEY unique_like (blog_id, user_id),
  INDEX idx_blog (blog_id),
  INDEX idx_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS blog_notifications (
  notification_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  blog_id BIGINT NOT NULL,
  user_id INT NOT NULL COMMENT 'SẼ SỬA SAU nếu cần',
  type ENUM('APPROVED', 'REJECTED', 'COMMENT', 'LIKE') NOT NULL,
  title VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (blog_id) REFERENCES blogs(blog_id) ON DELETE CASCADE,
  -- FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  INDEX idx_user_read (user_id, is_read),
  INDEX idx_created (created_at DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================
-- 5. VIEWS
-- ================================================

CREATE OR REPLACE VIEW v_pending_blogs AS
SELECT 
    b.blog_id, b.title, b.slug, b.summary, b.created_at,
    b.user_id, u.full_name AS author_name, u.email AS author_email
FROM blogs b
LEFT JOIN users u ON b.user_id = u.user_id
WHERE b.status = 'PENDING'
ORDER BY b.created_at ASC;

CREATE OR REPLACE VIEW v_approved_blogs AS
SELECT 
    b.blog_id, b.title, b.slug, b.summary, b.featured_image,
    b.view_count, b.like_count, b.comment_count, b.published_at,
    b.user_id, u.full_name AS author_name
FROM blogs b
LEFT JOIN users u ON b.user_id = u.user_id
WHERE b.status = 'APPROVED'
ORDER BY b.published_at DESC;

-- ================================================
-- 6. SAMPLE DATA
-- ================================================

INSERT INTO blogs 
(user_id, title, slug, summary, content, status, published_at, view_count, like_count)
VALUES
(1, 'Hướng dẫn mua sắm online an toàn', 'huong-dan-mua-sam-online-an-toan',
 'Những lưu ý quan trọng khi mua sắm trực tuyến',
 '<h2>1. Chọn website uy tín</h2><p>Luôn kiểm tra domain và certificate...</p>',
 'APPROVED', NOW(), 1250, 45),

(1, 'Top 5 sản phẩm công nghệ hot 2025', 'top-5-san-pham-cong-nghe-hot-2025',
 'Điểm qua 5 sản phẩm được săn đón nhất',
 '<h2>1. Smartphone AI</h2><p>Công nghệ AI tích hợp sâu...</p>',
 'APPROVED', DATE_SUB(NOW(), INTERVAL 1 DAY), 890, 67),

(1, 'Cách tối ưu hóa trải nghiệm game', 'cach-toi-uu-hoa-trai-nghiem-game',
 'Các mẹo để cải thiện hiệu suất chơi game',
 '<h2>1. Tối ưu cấu hình</h2><p>Điều chỉnh settings...</p>',
 'APPROVED', DATE_SUB(NOW(), INTERVAL 2 DAY), 560, 34);

-- ================================================
-- ✅ DONE! 
-- ================================================
-- 
-- QUAN TRỌNG: Sau khi chạy xong, hãy:
-- 
-- 1. Chạy: check_users_table_structure.sql
-- 2. Xem kiểu dữ liệu của users.user_id
-- 3. Nếu là BIGINT, chạy:
--    ALTER TABLE blogs MODIFY COLUMN user_id BIGINT NOT NULL;
--    ALTER TABLE blogs MODIFY COLUMN moderator_id BIGINT;
--    ALTER TABLE blog_comments MODIFY COLUMN user_id BIGINT NOT NULL;
--    ALTER TABLE blog_likes MODIFY COLUMN user_id BIGINT NOT NULL;
--    ALTER TABLE blog_notifications MODIFY COLUMN user_id BIGINT NOT NULL;
-- 
-- 4. Sau đó thêm FK:
--    ALTER TABLE blogs ADD FOREIGN KEY (user_id) REFERENCES users(user_id);
--    ALTER TABLE blogs ADD FOREIGN KEY (moderator_id) REFERENCES users(user_id);
--    ALTER TABLE blog_comments ADD FOREIGN KEY (user_id) REFERENCES users(user_id);
--    ALTER TABLE blog_likes ADD FOREIGN KEY (user_id) REFERENCES users(user_id);
--    ALTER TABLE blog_notifications ADD FOREIGN KEY (user_id) REFERENCES users(user_id);
-- 
-- ================================================

SELECT 'Blog tables created successfully! Check comments above for next steps.' AS Status;

