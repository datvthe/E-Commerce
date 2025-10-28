-- ========================================
-- FIX MISSING TABLES AND COLUMNS
-- Chay file nay de them cac bang va cot con thieu
-- ========================================

USE gicungco;

-- ========================================
-- 1. GOOGLE AUTH SUPPORT
-- ========================================

-- Kiem tra va them cot google_id vao bang users (neu chua co)
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'gicungco' 
    AND TABLE_NAME = 'users' 
    AND COLUMN_NAME = 'google_id');

SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE users ADD COLUMN google_id VARCHAR(255) NULL AFTER email_verified', 
    'SELECT "Column google_id already exists" AS message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Kiem tra va them cot auth_provider vao bang users (neu chua co)
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'gicungco' 
    AND TABLE_NAME = 'users' 
    AND COLUMN_NAME = 'auth_provider');

SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE users ADD COLUMN auth_provider VARCHAR(50) DEFAULT ''local'' AFTER google_id', 
    'SELECT "Column auth_provider already exists" AS message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Them index cho google_id (neu chua co)
SET @index_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS 
    WHERE TABLE_SCHEMA = 'gicungco' 
    AND TABLE_NAME = 'users' 
    AND INDEX_NAME = 'idx_google_id');

SET @sql = IF(@index_exists = 0, 
    'CREATE INDEX idx_google_id ON users(google_id)', 
    'SELECT "Index idx_google_id already exists" AS message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Tao bang google_auth
CREATE TABLE IF NOT EXISTS google_auth (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    google_id VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    picture_url TEXT,
    access_token TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_id (user_id),
    INDEX idx_google_id (google_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- 2. DIGITAL GOODS SUPPORT
-- ========================================

-- Tao bang digital_goods_codes (Luu ma serial key, license)
CREATE TABLE IF NOT EXISTS digital_goods_codes (
    code_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id BIGINT NOT NULL,
    code_value TEXT NOT NULL,
    code_type ENUM('serial_key','license','activation_code','username_password') DEFAULT 'serial_key',
    is_used BOOLEAN DEFAULT FALSE,
    used_by BIGINT NULL,
    used_at TIMESTAMP NULL,
    expires_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (used_by) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_product_id (product_id),
    INDEX idx_is_used (is_used)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tao bang digital_goods_files (Luu file tai xuong)
CREATE TABLE IF NOT EXISTS digital_goods_files (
    file_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id BIGINT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path TEXT NOT NULL,
    file_size BIGINT DEFAULT 0,
    file_type VARCHAR(50),
    download_count INT DEFAULT 0,
    max_downloads INT DEFAULT -1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    INDEX idx_product_id (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- 3. VERIFY TABLES
-- ========================================

-- Hien thi tat ca cac bang
SELECT 'List of all tables:' AS '';
SHOW TABLES;

-- Hien thi cau truc bang users (kiem tra cot google_id)
SELECT 'Structure of users table:' AS '';
DESCRIBE users;

-- Hien thi cau truc bang google_auth
SELECT 'Structure of google_auth table:' AS '';
DESCRIBE google_auth;

-- Hien thi cau truc bang digital_goods_codes
SELECT 'Structure of digital_goods_codes table:' AS '';
DESCRIBE digital_goods_codes;

-- Hien thi cau truc bang digital_goods_files
SELECT 'Structure of digital_goods_files table:' AS '';
DESCRIBE digital_goods_files;

-- ========================================
-- DONE!
-- ========================================
SELECT 'Database fix completed successfully!' AS 'Status';

