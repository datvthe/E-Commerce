-- Add Google OAuth columns to users table
ALTER TABLE users 
ADD COLUMN google_id VARCHAR(255) NULL AFTER email_verified,
ADD COLUMN auth_provider VARCHAR(50) DEFAULT 'local' AFTER google_id,
ADD INDEX idx_google_id (google_id);

-- Create google_auth table if it doesn't exist
CREATE TABLE IF NOT EXISTS google_auth (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
