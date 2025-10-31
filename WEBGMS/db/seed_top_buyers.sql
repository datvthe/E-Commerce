-- Seed top 5 buyers with varying order counts for Admin Dashboard ranking
-- Prereq: run db/seed_test_data.sql first so products, seller, base users exist

START TRANSACTION;

-- Create 5 customers (if not exist) with wallets
INSERT INTO users (full_name, email, password_hash, phone_number, status, email_verified, default_role, created_at)
SELECT 'Buyer One', 'buyer1@example.com', '12345678', '0911000001', 'active', 1, 'customer', NOW()
WHERE NOT EXISTS (SELECT 1 FROM users WHERE email='buyer1@example.com');
INSERT INTO users (full_name, email, password_hash, phone_number, status, email_verified, default_role, created_at)
SELECT 'Buyer Two', 'buyer2@example.com', '12345678', '0911000002', 'active', 1, 'customer', NOW()
WHERE NOT EXISTS (SELECT 1 FROM users WHERE email='buyer2@example.com');
INSERT INTO users (full_name, email, password_hash, phone_number, status, email_verified, default_role, created_at)
SELECT 'Buyer Three', 'buyer3@example.com', '12345678', '0911000003', 'active', 1, 'customer', NOW()
WHERE NOT EXISTS (SELECT 1 FROM users WHERE email='buyer3@example.com');
INSERT INTO users (full_name, email, password_hash, phone_number, status, email_verified, default_role, created_at)
SELECT 'Buyer Four', 'buyer4@example.com', '12345678', '0911000004', 'active', 1, 'customer', NOW()
WHERE NOT EXISTS (SELECT 1 FROM users WHERE email='buyer4@example.com');
INSERT INTO users (full_name, email, password_hash, phone_number, status, email_verified, default_role, created_at)
SELECT 'Buyer Five', 'buyer5@example.com', '12345678', '0911000005', 'active', 1, 'customer', NOW()
WHERE NOT EXISTS (SELECT 1 FROM users WHERE email='buyer5@example.com');

-- Map role "customer"
INSERT INTO User_Roles (user_id, role_id, assigned_at)
SELECT u.user_id, r.role_id, NOW()
FROM users u JOIN Roles r ON r.role_name='customer'
WHERE u.email IN ('buyer1@example.com','buyer2@example.com','buyer3@example.com','buyer4@example.com','buyer5@example.com')
  AND NOT EXISTS (
    SELECT 1 FROM User_Roles ur WHERE ur.user_id=u.user_id AND ur.role_id=r.role_id
  );

-- Wallets with balance (not strictly needed for stats)
INSERT INTO wallets (user_id, balance, currency)
SELECT u.user_id, 2000000, 'VND'
FROM users u
WHERE u.email IN ('buyer1@example.com','buyer2@example.com','buyer3@example.com','buyer4@example.com','buyer5@example.com')
  AND NOT EXISTS (SELECT 1 FROM wallets w WHERE w.user_id=u.user_id);

-- Helper variables
SET @seller_id := (SELECT user_id FROM users WHERE email='seller@example.com' LIMIT 1);
SET @prod_id := (SELECT product_id FROM products WHERE slug='tai-khoan-genshin-impact' LIMIT 1);
SET @price := (SELECT price FROM products WHERE product_id=@prod_id);

-- Insert orders with counts: buyer1=9, buyer2=7, buyer3=5, buyer4=3, buyer5=1
-- Uses UNION ALL of numbers to generate rows

-- buyer1 (9 orders)
SET @b1 := (SELECT user_id FROM users WHERE email='buyer1@example.com');
INSERT INTO orders (order_number, buyer_id, seller_id, product_id, quantity, unit_price, total_amount, currency, payment_method, payment_status, order_status, delivery_status, transaction_id, queue_status, created_at)
SELECT CONCAT('TEST-1-', n), @b1, @seller_id, @prod_id, 1, @price, @price, 'VND', 'WALLET', 'PAID', 'COMPLETED', 'INSTANT', CONCAT('T', UNIX_TIMESTAMP(), n), 'COMPLETED', NOW()
FROM (
  SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
  UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
) t
WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.buyer_id=@b1);

-- buyer2 (7 orders)
SET @b2 := (SELECT user_id FROM users WHERE email='buyer2@example.com');
INSERT INTO orders (order_number, buyer_id, seller_id, product_id, quantity, unit_price, total_amount, currency, payment_method, payment_status, order_status, delivery_status, transaction_id, queue_status, created_at)
SELECT CONCAT('TEST-2-', n), @b2, @seller_id, @prod_id, 1, @price, @price, 'VND', 'WALLET', 'PAID', 'COMPLETED', 'INSTANT', CONCAT('T', UNIX_TIMESTAMP(), n), 'COMPLETED', NOW()
FROM (SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7) t
WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.buyer_id=@b2);

-- buyer3 (5 orders)
SET @b3 := (SELECT user_id FROM users WHERE email='buyer3@example.com');
INSERT INTO orders (order_number, buyer_id, seller_id, product_id, quantity, unit_price, total_amount, currency, payment_method, payment_status, order_status, delivery_status, transaction_id, queue_status, created_at)
SELECT CONCAT('TEST-3-', n), @b3, @seller_id, @prod_id, 1, @price, @price, 'VND', 'WALLET', 'PAID', 'COMPLETED', 'INSTANT', CONCAT('T', UNIX_TIMESTAMP(), n), 'COMPLETED', NOW()
FROM (SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) t
WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.buyer_id=@b3);

-- buyer4 (3 orders)
SET @b4 := (SELECT user_id FROM users WHERE email='buyer4@example.com');
INSERT INTO orders (order_number, buyer_id, seller_id, product_id, quantity, unit_price, total_amount, currency, payment_method, payment_status, order_status, delivery_status, transaction_id, queue_status, created_at)
SELECT CONCAT('TEST-4-', n), @b4, @seller_id, @prod_id, 1, @price, @price, 'VND', 'WALLET', 'PAID', 'COMPLETED', 'INSTANT', CONCAT('T', UNIX_TIMESTAMP(), n), 'COMPLETED', NOW()
FROM (SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3) t
WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.buyer_id=@b4);

-- buyer5 (1 order)
SET @b5 := (SELECT user_id FROM users WHERE email='buyer5@example.com');
INSERT INTO orders (order_number, buyer_id, seller_id, product_id, quantity, unit_price, total_amount, currency, payment_method, payment_status, order_status, delivery_status, transaction_id, queue_status, created_at)
SELECT 'TEST-5-1', @b5, @seller_id, @prod_id, 1, @price, @price, 'VND', 'WALLET', 'PAID', 'COMPLETED', 'INSTANT', CONCAT('T', UNIX_TIMESTAMP()), 'COMPLETED', NOW()
WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.buyer_id=@b5);

COMMIT;
