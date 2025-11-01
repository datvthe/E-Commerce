-- Kiểm tra cấu trúc bảng users
USE gicungco;

-- Xem cấu trúc bảng users
DESCRIBE users;

-- Hoặc chi tiết hơn:
SHOW CREATE TABLE users;

-- Kiểm tra kiểu dữ liệu của user_id
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    COLUMN_TYPE,
    IS_NULLABLE,
    COLUMN_KEY
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'gicungco' 
  AND TABLE_NAME = 'users'
  AND COLUMN_NAME = 'user_id';

