-- Quick seed for instant checkout testing
-- Assumes database `gicungco` with tables already created.
-- Safe to run multiple times (idempotent inserts).

START TRANSACTION;

-- 1) Make sure product with id=1 is digital and active
UPDATE products
SET status='active', is_digital=1, delivery_type='instant', quantity=100, price=95000.00, currency='VND'
WHERE product_id=1;

-- 2) Seed 20 digital items for product_id=1 if missing
INSERT INTO digital_products (product_id, code, serial, status, expires_at)
SELECT 1,
       CONCAT('VT-TEST-', LPAD(n,4,'0')),
       CONCAT('SER', LPAD(n,6,'0')),
       'AVAILABLE',
       DATE_ADD(NOW(), INTERVAL 365 DAY)
FROM (
  SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
  UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
  UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15
  UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL SELECT 20
) nums
WHERE NOT EXISTS (
  SELECT 1 FROM digital_products dp
  WHERE dp.product_id=1 AND dp.code=CONCAT('VT-TEST-', LPAD(nums.n,4,'0'))
);

-- 3) Ensure wallet for admin (user_id=1) exists and has enough balance
INSERT INTO wallets (user_id, balance, currency)
SELECT 1, 1000000.00, 'VND'
WHERE NOT EXISTS (SELECT 1 FROM wallets w WHERE w.user_id=1);

-- Raise to at least 1,000,000 VND for testing
UPDATE wallets SET balance = GREATEST(balance, 1000000.00) WHERE user_id=1;

COMMIT;

-- Usage:
-- 1. If you have not created digital tables yet, run WEBGMS/update_orders_for_digital_goods.sql first.
-- 2. Then run this file.
-- 3. Login as user_id=1 (admin) or any user; visit /WEBGMS/checkout/instant?productId=1&quantity=1
