-- Seed test data for WEBGMS
-- Run this in your MySQL database used by the app.
-- Safe, idempotent inserts using INSERT ... SELECT WHERE NOT EXISTS.

START TRANSACTION;

-- 1) Roles
INSERT INTO Roles (role_name, description)
SELECT 'admin', 'Administrator'
WHERE NOT EXISTS (SELECT 1 FROM Roles WHERE role_name='admin');

INSERT INTO Roles (role_name, description)
SELECT 'seller', 'Seller'
WHERE NOT EXISTS (SELECT 1 FROM Roles WHERE role_name='seller');

INSERT INTO Roles (role_name, description)
SELECT 'customer', 'Customer'
WHERE NOT EXISTS (SELECT 1 FROM Roles WHERE role_name='customer');

INSERT INTO Roles (role_name, description)
SELECT 'moderator', 'Moderator'
WHERE NOT EXISTS (SELECT 1 FROM Roles WHERE role_name='moderator');

-- 2) Users (password stored in plain text for dev; login supports legacy/plain)
INSERT INTO users (full_name, email, password_hash, phone_number, status, email_verified, default_role, created_at)
SELECT 'Adam Admin', 'admin@example.com', '12345678', '0900000001', 'active', 1, 'admin', NOW()
WHERE NOT EXISTS (SELECT 1 FROM users WHERE email='admin@example.com');

INSERT INTO users (full_name, email, password_hash, phone_number, status, email_verified, default_role, created_at)
SELECT 'Sam Seller', 'seller@example.com', '12345678', '0900000002', 'active', 1, 'seller', NOW()
WHERE NOT EXISTS (SELECT 1 FROM users WHERE email='seller@example.com');

INSERT INTO users (full_name, email, password_hash, phone_number, status, email_verified, default_role, created_at)
SELECT 'Cathy Customer', 'customer@example.com', '12345678', '0900000003', 'active', 1, 'customer', NOW()
WHERE NOT EXISTS (SELECT 1 FROM users WHERE email='customer@example.com');

-- 3) User Roles mapping
-- Admin
INSERT INTO User_Roles (user_id, role_id, assigned_at)
SELECT u.user_id, r.role_id, NOW()
FROM users u JOIN Roles r ON r.role_name='admin'
WHERE u.email='admin@example.com'
  AND NOT EXISTS (
      SELECT 1 FROM User_Roles ur
      WHERE ur.user_id = u.user_id AND ur.role_id = r.role_id
  );

-- Seller
INSERT INTO User_Roles (user_id, role_id, assigned_at)
SELECT u.user_id, r.role_id, NOW()
FROM users u JOIN Roles r ON r.role_name='seller'
WHERE u.email='seller@example.com'
  AND NOT EXISTS (
      SELECT 1 FROM User_Roles ur
      WHERE ur.user_id = u.user_id AND ur.role_id = r.role_id
  );

-- Customer
INSERT INTO User_Roles (user_id, role_id, assigned_at)
SELECT u.user_id, r.role_id, NOW()
FROM users u JOIN Roles r ON r.role_name='customer'
WHERE u.email='customer@example.com'
  AND NOT EXISTS (
      SELECT 1 FROM User_Roles ur
      WHERE ur.user_id = u.user_id AND ur.role_id = r.role_id
  );

-- 4) Wallets
-- Admin wallet
INSERT INTO wallets (user_id, balance, currency)
SELECT u.user_id, 0.00, 'VND'
FROM users u
WHERE u.email='admin@example.com'
  AND NOT EXISTS (SELECT 1 FROM wallets w WHERE w.user_id=u.user_id);

-- Seller wallet
INSERT INTO wallets (user_id, balance, currency)
SELECT u.user_id, 0.00, 'VND'
FROM users u
WHERE u.email='seller@example.com'
  AND NOT EXISTS (SELECT 1 FROM wallets w WHERE w.user_id=u.user_id);

-- Customer wallet with enough balance
INSERT INTO wallets (user_id, balance, currency)
SELECT u.user_id, 5000000.00, 'VND'
FROM users u
WHERE u.email='customer@example.com'
  AND NOT EXISTS (SELECT 1 FROM wallets w WHERE w.user_id=u.user_id);

-- 5) Categories
INSERT INTO product_categories (name, slug, description, created_at)
SELECT 'Gaming', 'gaming', 'Danh mục game', NOW()
WHERE NOT EXISTS (SELECT 1 FROM product_categories WHERE slug='gaming');

-- Grab category and seller IDs for subsequent inserts
SET @cat_id := (SELECT category_id FROM product_categories WHERE slug='gaming' LIMIT 1);
SET @seller_id := (SELECT user_id FROM users WHERE email='seller@example.com' LIMIT 1);

-- 6) Product (digital) with stock > 0
INSERT INTO products (seller_id, name, slug, description, price, currency, status, category_id, quantity, created_at)
SELECT @seller_id,
       'Tài khoản Genshin Impact',
       'tai-khoan-genshin-impact',
       'Tài khoản Genshin Impact cày sẵn, bảo hành 7 ngày.',
       800000, 'VND', 'active', @cat_id, 100, NOW()
WHERE NOT EXISTS (SELECT 1 FROM products WHERE slug='tai-khoan-genshin-impact');

-- Optional preview image
SET @prod_id := (SELECT product_id FROM products WHERE slug='tai-khoan-genshin-impact' LIMIT 1);
INSERT INTO product_images (product_id, url, alt_text, is_primary)
SELECT @prod_id,
       '/uploads/sample/genshin-acc.png',
       'Genshin account',
       1
WHERE NOT EXISTS (
    SELECT 1 FROM product_images WHERE product_id=@prod_id AND is_primary=1
);

-- 7) Digital inventory (codes/accounts) - 15 items AVAILABLE
-- If table has extra columns they should have defaults; adjust as needed.
INSERT INTO digital_products (product_id, code, password, serial, additional_info, status)
SELECT @prod_id, CONCAT('GEN-', LPAD(n,3,'0')), 'pass123', CONCAT('SN', LPAD(n,5,'0')), 'Region: Asia', 'AVAILABLE'
FROM (
  SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
  UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
  UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15
) nums
WHERE NOT EXISTS (
  SELECT 1 FROM digital_products dp WHERE dp.product_id=@prod_id AND dp.code=CONCAT('GEN-', LPAD(nums.n,3,'0'))
);

-- 8) Another sample product (optional)
INSERT INTO products (seller_id, name, slug, description, price, currency, status, category_id, quantity, created_at)
SELECT @seller_id, 'Thẻ cào Viettel 100K', 'the-cao-viettel-100k', 'Mã thẻ Viettel 100.000đ', 100000, 'VND', 'active', @cat_id, 50, NOW()
WHERE NOT EXISTS (SELECT 1 FROM products WHERE slug='the-cao-viettel-100k');

SET @viettel_id := (SELECT product_id FROM products WHERE slug='the-cao-viettel-100k' LIMIT 1);
INSERT INTO digital_products (product_id, code, serial, additional_info, status)
SELECT @viettel_id, CONCAT('VT', LPAD(n,10,'1')), CONCAT('SV', LPAD(n,8,'9')), 'Viettel Prepaid', 'AVAILABLE'
FROM (
  SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
  UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
) nums
WHERE NOT EXISTS (
  SELECT 1 FROM digital_products dp WHERE dp.product_id=@viettel_id AND dp.code=CONCAT('VT', LPAD(nums.n,10,'1'))
);

COMMIT;
