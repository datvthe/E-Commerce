# 📦 WORKFLOW ĐẶT HÀNG DIGITAL GOODS - 1 ORDER = 1 PRODUCT

## 🎯 NGUYÊN TẮC THIẾT KẾ

### ⚠️ Quy tắc vàng: **1 ORDER = 1 PRODUCT ONLY**

```
┌─────────────────────────────────────────────────────────────┐
│  TẠI SAO BÁN DIGITAL GOODS NÊN 1 ORDER = 1 PRODUCT?       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ✅ ƯU ĐIỂM:                                                │
│  1. Đơn giản hóa logic xử lý                                │
│  2. Dễ quản lý codes (mỗi order map với 1 product)         │
│  3. Dễ tracking và refund                                   │
│  4. Phù hợp với instant delivery                            │
│  5. Không cần bảng order_items phức tạp                     │
│                                                             │
│  ❌ Nếu 1 order chứa nhiều products:                        │
│  - Phải có order_items table                                │
│  - Phức tạp khi giao codes (product nào trước?)            │
│  - Khó xử lý khi 1 product hết hàng, product khác còn     │
│  - Khó refund từng phần                                     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 📊 CẤU TRÚC BẢNG ORDERS

### Bảng `orders` (Đã XÓA cột order_number)

```sql
CREATE TABLE orders (
  order_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  -- ❌ KHÔNG CÓ order_number (dùng order_id làm identifier)
  
  buyer_id BIGINT,                    -- Người mua
  seller_id BIGINT,                   -- Người bán
  
  -- ✅ 1 ORDER = 1 PRODUCT
  product_id BIGINT,                  -- Sản phẩm (singular, NOT plural)
  quantity INT,                       -- Số lượng codes/mã
  
  unit_price DECIMAL(15,2),           -- Giá 1 code
  total_amount DECIMAL(15,2),         -- Tổng tiền = unit_price × quantity
  
  currency VARCHAR(10) DEFAULT 'VND',
  payment_method VARCHAR(50),         -- 'WALLET'
  payment_status VARCHAR(20),         -- 'PAID'
  order_status VARCHAR(20),           -- 'PENDING' → 'COMPLETED'
  delivery_status VARCHAR(20),        -- 'INSTANT'
  transaction_id VARCHAR(100),        -- ID giao dịch wallet
  queue_status VARCHAR(20),           -- 'WAITING' → 'COMPLETED'
  
  created_at TIMESTAMP,
  updated_at TIMESTAMP
)
```

**Identifier:** Dùng `order_id` (số tự tăng) thay vì `order_number` (string)

---

## 🔄 WORKFLOW CHI TIẾT

### KỊCH BẢN 1: User mua 3 codes của 1 product

```
User muốn mua:
- Product: Thẻ cào Viettel 100K (product_id = 1)
- Quantity: 3 codes

WORKFLOW:
┌─────────────────────────────────────────────────────────┐
│ 1. Tạo 1 ORDER duy nhất                                 │
├─────────────────────────────────────────────────────────┤
│    INSERT INTO orders (                                 │
│      buyer_id = 11,                                     │
│      seller_id = 2,                                     │
│      product_id = 1,        ◄── CHỈ 1 PRODUCT          │
│      quantity = 3,          ◄── 3 codes                │
│      unit_price = 95000,                                │
│      total_amount = 285000  ◄── 95000 × 3              │
│    )                                                    │
│    → order_id = 123                                     │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ 2. Lock 3 codes từ digital_goods_codes                  │
├─────────────────────────────────────────────────────────┤
│    SELECT * FROM digital_goods_codes                    │
│    WHERE product_id = 1 AND is_used = 0                │
│    LIMIT 3                                              │
│    FOR UPDATE;                                          │
│                                                         │
│    → codes: [1, 2, 3]                                   │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ 3. Đánh dấu 3 codes đã bán                             │
├─────────────────────────────────────────────────────────┤
│    UPDATE digital_goods_codes                           │
│    SET is_used = 1,                                     │
│        used_by = 11                                     │
│    WHERE code_id IN (1, 2, 3);                         │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ 4. User nhận 3 codes trong 1 order                      │
├─────────────────────────────────────────────────────────┤
│    Order ID: 123                                        │
│    Mã 1: VT100K001234567890                            │
│    Mã 2: VT100K001234567891                            │
│    Mã 3: VT100K001234567892                            │
└─────────────────────────────────────────────────────────┘
```

---

### KỊCH BẢN 2: User muốn mua 2 products khác nhau

```
User muốn mua:
- Product A: Thẻ cào Viettel 100K (product_id = 1) × 2 codes
- Product B: PUBG Account (product_id = 2) × 1 code

❌ KHÔNG TẠO 1 ORDER CHO CẢ 2 PRODUCTS!

✅ TẠO 2 ORDERS RIÊNG BIỆT:

┌─────────────────────────────────────────────────────────┐
│ ORDER 1 (cho Product A)                                 │
├─────────────────────────────────────────────────────────┤
│    order_id = 123                                       │
│    product_id = 1                                       │
│    quantity = 2                                         │
│    total_amount = 190,000đ                              │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ ORDER 2 (cho Product B)                                 │
├─────────────────────────────────────────────────────────┤
│    order_id = 124                                       │
│    product_id = 2                                       │
│    quantity = 1                                         │
│    total_amount = 250,000đ                              │
└─────────────────────────────────────────────────────────┘

→ Tổng cộng: 2 orders riêng biệt
```

---

## 🏗️ CẤU TRÚC DATABASE

### ❌ KHÔNG DÙNG (Cho e-commerce thông thường):
```
orders (order_id, buyer_id, total_amount)
  └── order_items (order_item_id, order_id, product_id, quantity)
```

### ✅ DÙNG (Cho digital goods):
```
orders (order_id, buyer_id, product_id, quantity, total_amount)
  └── digital_goods_codes (code_id, is_used, used_by)
```

**Mapping:**
- 1 order có `product_id` trực tiếp
- 1 order có `quantity` = số codes
- Link qua `digital_goods_codes.used_by` = buyer_id

---

## 📝 IDENTIFIER: order_id vs order_number

### ❌ order_number (String - Không cần)
```
ORDER-20251101-12345
ORDER-20251101-67890
```
- Phức tạp
- Cần generate unique
- Tốn bộ nhớ

### ✅ order_id (BIGINT - Đơn giản)
```
123
124
125
```
- Tự động tăng (AUTO_INCREMENT)
- Unique by default
- Hiệu quả

**Format hiển thị (nếu cần):**
```java
String displayOrderNumber = "ORD-" + orderId;
// ORD-123, ORD-124, ...
```

---

## 🔄 WORKFLOW ORDER HOÀN CHỈNH

```
┌──────────────────────────────────────────────────────────────┐
│ 1 ORDER = 1 PRODUCT WORKFLOW                                │
└──────────────────────────────────────────────────────────────┘

User chọn product & quantity
        │
        ▼
┌────────────────────────────────────────┐
│ InstantCheckoutController              │
├────────────────────────────────────────┤
│ COUNT codes từ digital_goods_codes     │
│ IF enough → Show confirm page          │
└────────────────────────────────────────┘
        │
        │ User xác nhận
        ▼
┌────────────────────────────────────────┐
│ CheckoutProcessController              │
├────────────────────────────────────────┤
│ 🔒 START TRANSACTION                   │
│                                        │
│ 1. LOCK codes (FOR UPDATE)             │
│    SELECT ... LIMIT quantity           │
│                                        │
│ 2. Trừ tiền wallet                     │
│                                        │
│ 3. ✅ INSERT INTO orders (             │
│      product_id = X,  ◄── 1 product   │
│      quantity = N     ◄── N codes     │
│    )                                   │
│    → order_id = 123                    │
│                                        │
│ 4. UPDATE digital_goods_codes          │
│    SET is_used = 1                     │
│    WHERE code_id IN (...)              │
│                                        │
│ 5. Sync inventory (optional)           │
│                                        │
│ 🔓 COMMIT                               │
└────────────────────────────────────────┘
        │
        ▼
┌────────────────────────────────────────┐
│ OrderSuccessController                 │
├────────────────────────────────────────┤
│ Lấy codes đã mua:                      │
│                                        │
│ SELECT * FROM digital_goods_codes      │
│ WHERE used_by = userId                 │
│   AND product_id = X                   │
│                                        │
│ → Hiển thị codes cho user              │
└────────────────────────────────────────┘
```

---

## 📊 VÍ DỤ DATABASE SAU ORDER

### orders table:
```
order_id | buyer_id | seller_id | product_id | quantity | total_amount
---------|----------|-----------|------------|----------|-------------
123      | 11       | 2         | 1          | 3        | 285,000
124      | 11       | 2         | 5          | 1        | 195,000
125      | 15       | 2         | 1          | 2        | 190,000
```

### digital_goods_codes table:
```
code_id | product_id | code_value      | is_used | used_by
--------|------------|-----------------|---------|--------
1       | 1          | VT100K001...    | 1       | 11      ← Order 123
2       | 1          | VT100K002...    | 1       | 11      ← Order 123
3       | 1          | VT100K003...    | 1       | 11      ← Order 123
4       | 1          | VT100K004...    | 1       | 15      ← Order 125
5       | 1          | VT100K005...    | 1       | 15      ← Order 125
6       | 5          | VP200K001...    | 1       | 11      ← Order 124
```

**Mapping:**
- Order 123 → 3 codes (code_id: 1, 2, 3)
- Order 124 → 1 code (code_id: 6)
- Order 125 → 2 codes (code_id: 4, 5)

---

## 🆚 SO SÁNH VỚI E-COMMERCE THÔNG THƯỜNG

### E-commerce truyền thống (Physical goods):
```
User mua:
- Áo thun đỏ × 2
- Quần jean × 1
- Giày × 1

→ 1 ORDER chứa 3 products
→ Cần bảng order_items
```

### Digital goods (Code của bạn):
```
User mua:
- Thẻ cào Viettel × 3 codes

→ 1 ORDER chứa 1 product
→ KHÔNG cần order_items
→ Codes link qua digital_goods_codes.used_by
```

**Nếu user muốn mua nhiều products digital:**
```
User mua:
- Thẻ cào Viettel × 3 codes
- PUBG Account × 1 code

→ TẠO 2 ORDERS RIÊNG:
  - Order 1: Thẻ cào × 3
  - Order 2: PUBG × 1
```

---

## 💡 TRƯỜNG HỢP ĐẶC BIỆT

### Nếu bạn THỰC SỰ cần 1 order chứa nhiều products:

**Cần thay đổi:**
1. Tạo bảng `order_items`:
```sql
CREATE TABLE order_items (
  order_item_id BIGINT PRIMARY KEY,
  order_id BIGINT,
  product_id BIGINT,
  quantity INT,
  price_at_purchase DECIMAL(15,2),
  subtotal DECIMAL(15,2)
)
```

2. Xóa `product_id`, `quantity` khỏi bảng `orders`

3. Sửa toàn bộ logic checkout

**Nhưng với digital goods → KHÔNG khuyến nghị!**

---

## ✅ KẾT LUẬN

**Thiết kế hiện tại (1 ORDER = 1 PRODUCT) là ĐÚNG cho digital goods vì:**

1. ✅ Đơn giản, dễ maintain
2. ✅ Phù hợp instant delivery
3. ✅ Dễ tracking codes
4. ✅ Dễ refund/hủy order
5. ✅ Performance tốt

**Identifier:**
- ✅ Dùng `order_id` (số tự tăng)
- ❌ Không cần `order_number` (string phức tạp)
- ✅ Format hiển thị: "ORD-123" (từ order_id)

---

## 📞 REFERENCE

**Files đã sửa:**
- `OrderDAO.java` - Xóa order_number, dùng order_id
- `CheckoutProcessController.java` - 1 order = 1 product
- `DigitalGoodsCodeDAO.java` - Link codes qua used_by

**Database tables:**
- `orders` (product_id, quantity) - Không có order_number
- `digital_goods_codes` (is_used, used_by) - Link với buyer

---

**Thiết kế này là CHUẨN cho digital marketplace! 🎯**

