# 📦 WORKFLOW ĐẶT HÀNG - 1 ORDER = 1 CODE DUY NHẤT

## 🎯 NGUYÊN TẮC THIẾT KẾ

```
┌─────────────────────────────────────────────────────────────┐
│  ⚠️ 1 ORDER = 1 CODE DUY NHẤT (Quantity = 1)              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ✅ MỖI ORDER CHỈ CHỨA:                                     │
│  - 1 code duy nhất                                          │
│  - quantity = 1 (luôn cố định)                              │
│  - total_amount = giá 1 code                                │
│                                                             │
│  ✅ NẾU USER MUỐN MUA 3 CODES:                              │
│  - Tạo 3 orders riêng biệt                                  │
│  - Mỗi order chứa 1 code                                    │
│  - Trừ tiền 1 lần cho cả 3 codes                            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 📊 CẤU TRÚC DATABASE

### 1️⃣ Bảng `orders` (Thông tin order cơ bản)

```sql
CREATE TABLE orders (
  order_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  buyer_id BIGINT,
  seller_id BIGINT,
  status ENUM('pending','paid','shipped','delivered','cancelled','refunded'),
  total_amount DECIMAL(15,2),         -- Giá 1 code
  currency VARCHAR(10),
  shipping_address TEXT,
  shipping_method VARCHAR(100),
  tracking_number VARCHAR(100),
  created_at TIMESTAMP,
  updated_at TIMESTAMP
)
```

**Đặc điểm:**

- ❌ KHÔNG có `product_id`, `quantity`, `unit_price`
- ✅ Chỉ có thông tin chung: buyer, seller, total_amount

---

### 2️⃣ Bảng `order_items` (Link order ↔ product)

```sql
CREATE TABLE order_items (
  order_item_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  order_id BIGINT,
  product_id BIGINT,                  -- Product được mua
  quantity INT DEFAULT 1,              -- LUÔN = 1
  price_at_purchase DECIMAL(15,2),    -- Giá 1 code
  discount_applied DECIMAL(10,2),
  subtotal DECIMAL(15,2)              -- = price_at_purchase
)
```

**Đặc điểm:**

- ✅ Link giữa order và product
- ✅ `quantity` luôn = 1 (cố định)

---

### 3️⃣ Bảng `digital_goods_codes` (Mã codes thật)

```sql
CREATE TABLE digital_goods_codes (
  code_id INT PRIMARY KEY AUTO_INCREMENT,
  product_id BIGINT,
  code_value TEXT,                    -- Mã thẻ/tài khoản
  code_type ENUM(...),
  is_used TINYINT(1) DEFAULT 0,      -- 0 = còn, 1 = đã bán
  used_by BIGINT,                     -- User đã mua
  used_at TIMESTAMP
)
```

**Đặc điểm:**

- ✅ Mỗi dòng = 1 code thực tế
- ✅ Link với user qua `used_by`

---

## 🔄 WORKFLOW ĐẶT HÀNG CHI TIẾT

### Kịch bản: User mua 3 codes của "Thẻ cào Viettel 100K"

```
User chọn:
- Product: Thẻ cào Viettel 100K (product_id = 1, price = 95,000đ)
- Quantity: 3 codes
- Total: 285,000đ

═══════════════════════════════════════════════════════════
BƯỚC 1: Lock 3 codes từ digital_goods_codes
═══════════════════════════════════════════════════════════

SELECT * FROM digital_goods_codes
WHERE product_id = 1 AND is_used = 0
ORDER BY code_id ASC
LIMIT 3
FOR UPDATE;

→ Kết quả:
  code_id=1, code_value="VT100K001..."
  code_id=2, code_value="VT100K002..."
  code_id=3, code_value="VT100K003..."

═══════════════════════════════════════════════════════════
BƯỚC 2: Trừ tiền wallet (1 lần cho cả 3 codes)
═══════════════════════════════════════════════════════════

UPDATE wallets
SET balance = balance - 285000
WHERE user_id = 11;

INSERT INTO transactions (...)
VALUES (..., 'WITHDRAW', 285000, ...);

═══════════════════════════════════════════════════════════
BƯỚC 3: Tạo 3 ORDERS riêng biệt (1 order per code)
═══════════════════════════════════════════════════════════

┌─────────────────────────────────────────────────────┐
│ ORDER 1 (cho code 1)                                │
├─────────────────────────────────────────────────────┤
│ INSERT INTO orders (                                │
│   buyer_id = 11,                                    │
│   seller_id = 2,                                    │
│   status = 'paid',                                  │
│   total_amount = 95000     ◄── Giá 1 code          │
│ )                                                   │
│ → order_id = 101                                    │
│                                                     │
│ INSERT INTO order_items (                           │
│   order_id = 101,                                   │
│   product_id = 1,                                   │
│   quantity = 1,            ◄── LUÔN = 1            │
│   price_at_purchase = 95000,                        │
│   subtotal = 95000                                  │
│ )                                                   │
│                                                     │
│ UPDATE digital_goods_codes                          │
│ SET is_used = 1, used_by = 11                      │
│ WHERE code_id = 1;                                  │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│ ORDER 2 (cho code 2)                                │
├─────────────────────────────────────────────────────┤
│ [Tương tự]                                          │
│ → order_id = 102                                    │
│ → code_id = 2                                       │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│ ORDER 3 (cho code 3)                                │
├─────────────────────────────────────────────────────┤
│ [Tương tự]                                          │
│ → order_id = 103                                    │
│ → code_id = 3                                       │
└─────────────────────────────────────────────────────┘

═══════════════════════════════════════════════════════════
KẾT QUẢ DATABASE
═══════════════════════════════════════════════════════════

orders:
order_id | buyer_id | seller_id | status | total_amount
---------|----------|-----------|--------|-------------
101      | 11       | 2         | paid   | 95,000      ← Order 1
102      | 11       | 2         | paid   | 95,000      ← Order 2
103      | 11       | 2         | paid   | 95,000      ← Order 3

order_items:
item_id | order_id | product_id | quantity | price  | subtotal
--------|----------|------------|----------|--------|----------
1       | 101      | 1          | 1        | 95,000 | 95,000
2       | 102      | 1          | 1        | 95,000 | 95,000
3       | 103      | 1          | 1        | 95,000 | 95,000

digital_goods_codes:
code_id | product_id | code_value   | is_used | used_by
--------|------------|--------------|---------|--------
1       | 1          | VT100K001... | 1       | 11     ← Order 101
2       | 1          | VT100K002... | 1       | 11     ← Order 102
3       | 1          | VT100K003... | 1       | 11     ← Order 103
4       | 1          | VT100K004... | 0       | NULL   ← Còn lại
```

---

## 🔄 WORKFLOW HOÀN CHỈNH

```
┌───────────────────────────────────────────────────────────┐
│              1 ORDER = 1 CODE WORKFLOW                    │
└───────────────────────────────────────────────────────────┘

User chọn: Product A × 3 codes
        │
        ▼
┌─────────────────────────────────┐
│ InstantCheckoutController       │
├─────────────────────────────────┤
│ COUNT available codes           │
│ IF >= 3 → OK                    │
│ Show confirm page               │
└─────────────────────────────────┘
        │ User xác nhận
        ▼
┌─────────────────────────────────────────────────────┐
│ CheckoutProcessController                           │
├─────────────────────────────────────────────────────┤
│ 🔒 START TRANSACTION                                 │
│                                                      │
│ 1. LOCK 3 codes (FOR UPDATE)                        │
│                                                      │
│ 2. Trừ tiền: 285,000đ (1 lần)                       │
│                                                      │
│ 3. TẠO 3 ORDERS:                                    │
│    FOR i = 0 to 2:                                  │
│      a. INSERT INTO orders (total = 95,000)         │
│         → order_id = 101, 102, 103                  │
│                                                      │
│      b. INSERT INTO order_items (                   │
│           order_id = 101/102/103,                   │
│           product_id = 1,                           │
│           quantity = 1    ◄── LUÔN = 1              │
│         )                                           │
│                                                      │
│      c. UPDATE digital_goods_codes                  │
│         SET is_used = 1, used_by = 11               │
│         WHERE code_id = i                           │
│                                                      │
│ 4. Sync inventory                                   │
│                                                      │
│ 🔓 COMMIT                                            │
└─────────────────────────────────────────────────────┘
        │
        ▼
┌─────────────────────────────────┐
│ OrderSuccessController          │
├─────────────────────────────────┤
│ SELECT codes từ                 │
│ digital_goods_codes             │
│ WHERE used_by = 11              │
│   AND product_id = 1            │
│                                 │
│ → Hiển thị 3 codes đã mua       │
└─────────────────────────────────┘
```

---

## 💡 TẠI SAO LẠI TH

Ế KẾ NHƯ VẬY?

### ✅ **Ưu điểm:**

1. **Đơn giản:** Mỗi order = 1 code → Dễ quản lý
2. **Refund dễ:** Muốn refund 1 code → Chỉ cần cancel 1 order
3. **Tracking tốt:** Mỗi code có order_id riêng
4. **Không cần logic phức tạp:** Không cần tính toán quantity

### ❌ **Nhược điểm:**

1. Nhiều records trong bảng orders (nếu user mua số lượng lớn)
2. Nhiều pending_transactions

### 💡 **Giải pháp thay thế (nếu muốn tối ưu):**

Nếu lo ngại quá nhiều orders, có thể:

- Giới hạn quantity tối đa = 5 mỗi lần checkout
- Hoặc nhóm thành 1 order nhưng vẫn track từng code qua bảng riêng

**Nhưng theo thiết kế hiện tại: 1 ORDER = 1 CODE là CHUẨN!**

---

## 🗂️ CẤU TRÚC BẢNG

```
orders
├── order_id (PK)         ← Identifier
├── buyer_id
├── seller_id
├── status                ← 'paid', 'cancelled', ...
├── total_amount          ← Giá 1 code (95,000đ)
└── currency

order_items
├── order_item_id (PK)
├── order_id (FK)         ← Link với orders
├── product_id (FK)       ← Product được mua
├── quantity              ← LUÔN = 1
├── price_at_purchase     ← Giá 1 code
└── subtotal              ← = price_at_purchase

digital_goods_codes
├── code_id (PK)
├── product_id (FK)
├── code_value            ← Mã thật
├── is_used               ← 0 → 1
└── used_by (FK)          ← buyer_id
```

**Mapping:**

```
1 User mua 3 codes
→ 3 orders
→ 3 order_items
→ 3 digital_goods_codes (is_used = 1)
```

---

## 📝 VÍ DỤ CỤ THỂ

### User 11 mua 3 codes Viettel:

**TRƯỚC KHI MUA:**

```sql
digital_goods_codes:
code_id | is_used | used_by
1       | 0       | NULL    ← Chưa bán
2       | 0       | NULL    ← Chưa bán
3       | 0       | NULL    ← Chưa bán
4       | 0       | NULL
5       | 0       | NULL
```

**SAU KHI MUA:**

```sql
orders:
order_id | buyer_id | status | total_amount
101      | 11       | paid   | 95,000      ← Order cho code 1
102      | 11       | paid   | 95,000      ← Order cho code 2
103      | 11       | paid   | 95,000      ← Order cho code 3

order_items:
item_id | order_id | product_id | quantity | price_at_purchase
1       | 101      | 1          | 1        | 95,000
2       | 102      | 1          | 1        | 95,000
3       | 103      | 1          | 1        | 95,000

digital_goods_codes:
code_id | is_used | used_by
1       | 1       | 11      ← ĐÃ BÁN (Order 101)
2       | 1       | 11      ← ĐÃ BÁN (Order 102)
3       | 1       | 11      ← ĐÃ BÁN (Order 103)
4       | 0       | NULL    ← Còn lại
5       | 0       | NULL    ← Còn lại

wallet_history:
user_id | amount    | type     | description
11      | -285,000  | WITHDRAW | Mua 3 codes (tổng)
```

---

## 🎨 HIỂN THỊ TRÊN UI

### Trang Order Success:

```
✅ ĐẶT HÀNG THÀNH CÔNG!
Đã tạo 3 đơn hàng

📦 DANH SÁCH MÃ:
┌──────────────────────────────┐
│ Order #101                   │
│ Mã: VT100K001234567890       │
│ Loại: Gift Card              │
└──────────────────────────────┘
┌──────────────────────────────┐
│ Order #102                   │
│ Mã: VT100K001234567891       │
│ Loại: Gift Card              │
└──────────────────────────────┘
┌──────────────────────────────┐
│ Order #103                   │
│ Mã: VT100K001234567892       │
│ Loại: Gift Card              │
└──────────────────────────────┘

💰 Tổng thanh toán: 285,000đ
💵 Số dư còn lại: 215,000đ
```

### Trang Order History:

```
📋 LỊCH SỬ ĐƠN HÀNG

Order #103 - Thẻ cào Viettel 100K (1 mã) - 95,000đ - Paid
Order #102 - Thẻ cào Viettel 100K (1 mã) - 95,000đ - Paid
Order #101 - Thẻ cào Viettel 100K (1 mã) - 95,000đ - Paid
```

---

## 🔍 QUERY HỮU ÍCH

### Lấy tất cả orders và codes của 1 user:

```sql
SELECT
    o.order_id,
    o.total_amount,
    o.status,
    oi.product_id,
    p.name as product_name,
    dgc.code_value,
    dgc.code_type
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN digital_goods_codes dgc ON dgc.used_by = o.buyer_id
    AND dgc.product_id = oi.product_id
WHERE o.buyer_id = 11
ORDER BY o.created_at DESC;
```

### Đếm số orders của 1 product:

```sql
SELECT
    p.product_id,
    p.name,
    COUNT(o.order_id) as total_orders,
    SUM(o.total_amount) as total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE p.product_id = 1
GROUP BY p.product_id, p.name;
```

---

## ✅ FILES ĐÃ CẬP NHẬT

1. `OrderDAO.java`:

   - `createInstantOrder()` - Tạo 1 order cho 1 code
   - `insertOrderItem()` - Insert với quantity = 1
   - `extractOrderFromResultSet()` - JOIN với order_items

2. `CheckoutProcessController.java`:

   - Loop tạo NHIỀU orders (1 per code)
   - Mỗi order quantity = 1

3. `DigitalGoodsCodeDAO.java`:
   - Lock codes
   - Mark as used

---

**Thiết kế này HOÀN TOÀN ĐÚNG cho digital goods marketplace! 🎯**
