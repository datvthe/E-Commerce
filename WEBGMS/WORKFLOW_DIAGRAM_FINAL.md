# 📊 WORKFLOW ĐẶT HÀNG DIGITAL GOODS - DIAGRAM HOÀN CHỈNH

## 🎯 NGUYÊN TẮC CỐT LÕI

```
╔═══════════════════════════════════════════════════════════════╗
║  ⚠️ 1 ORDER = 1 CODE DUY NHẤT (QUANTITY LUÔN = 1)            ║
╠═══════════════════════════════════════════════════════════════╣
║                                                               ║
║  User muốn 3 codes → Hệ thống tạo 3 orders riêng biệt        ║
║  Mỗi order chỉ chứa 1 code, quantity cố định = 1             ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
```

---

## 📦 KỊCH BẢN MUA HÀNG

### User muốn mua 3 codes "Thẻ cào Viettel 100K"

```
Input:
- Product ID: 1 (Thẻ cào Viettel 100K)
- Quantity: 3
- Price: 95,000đ/code
- Total: 285,000đ

Output:
- 3 orders riêng biệt (101, 102, 103)
- Mỗi order chứa 1 code duy nhất
- Trừ tiền 1 lần: 285,000đ
```

---

## 🔄 WORKFLOW CHI TIẾT

```
┌─────────────────────────────────────────────────────────────────┐
│                    BƯỚC 1: USER CHỌN SẢN PHẨM                   │
└─────────────────────────────────────────────────────────────────┘

User ở product-detail.jsp:
- Chọn "Thẻ cào Viettel 100K"
- Nhập quantity = 3
- Nhấn "Mua ngay"
        │
        ▼
GET /checkout/instant?productId=1&quantity=3

┌─────────────────────────────────────────────────────────────────┐
│ InstantCheckoutController                                       │
├─────────────────────────────────────────────────────────────────┤
│ 📊 CHECK STOCK:                                                 │
│                                                                 │
│   SELECT COUNT(*) FROM digital_goods_codes                      │
│   WHERE product_id = 1 AND is_used = 0                         │
│   → availableStock = 5 codes                                    │
│                                                                 │
│ ✅ 3 <= 5 → OK, đủ hàng                                         │
│                                                                 │
│ 💰 CHECK WALLET:                                                │
│   SELECT balance FROM wallets WHERE user_id = 11                │
│   → balance = 500,000đ                                          │
│   → required = 285,000đ (95,000 × 3)                           │
│                                                                 │
│ ✅ 500,000 >= 285,000 → OK, đủ tiền                            │
│                                                                 │
│ → Forward to checkout-instant.jsp (trang xác nhận)              │
└─────────────────────────────────────────────────────────────────┘
        │
        │ User nhấn "Xác nhận thanh toán"
        ▼
POST /checkout/process 
{productId: 1, quantity: 3}

┌─────────────────────────────────────────────────────────────────┐
│ CheckoutProcessController                                       │
├─────────────────────────────────────────────────────────────────┤
│ 🔒 START TRANSACTION                                             │
│    conn.setAutoCommit(false)                                    │
│                                                                 │
│ ═══════════════════════════════════════════════════════════════│
│ STEP 1: LOCK 3 codes                                           │
│ ═══════════════════════════════════════════════════════════════│
│                                                                 │
│   SELECT * FROM digital_goods_codes                             │
│   WHERE product_id = 1 AND is_used = 0                         │
│   LIMIT 3                                                       │
│   FOR UPDATE;                                                   │
│                                                                 │
│   → codes: [code_id=1, code_id=2, code_id=3]                   │
│                                                                 │
│ ═══════════════════════════════════════════════════════════════│
│ STEP 2: Trừ tiền wallet (1 LẦN cho tổng tiền)                 │
│ ═══════════════════════════════════════════════════════════════│
│                                                                 │
│   UPDATE wallets                                                │
│   SET balance = balance - 285000                                │
│   WHERE user_id = 11;                                           │
│                                                                 │
│   INSERT INTO transactions (                                    │
│     type = 'WITHDRAW',                                          │
│     amount = 285000,                                            │
│     note = 'Mua 3 codes Thẻ cào Viettel'                       │
│   )                                                            │
│                                                                 │
│ ═══════════════════════════════════════════════════════════════│
│ STEP 3: TẠO 3 ORDERS (1 order per code)                       │
│ ═══════════════════════════════════════════════════════════════│
│                                                                 │
│ FOR i = 0 to 2:                                                │
│   code = availableCodes[i]                                      │
│                                                                 │
│   ┌───────────────────────────────────────┐                   │
│   │ Order 1 (cho code_id=1)               │                   │
│   ├───────────────────────────────────────┤                   │
│   │ INSERT INTO orders (                  │                   │
│   │   buyer_id = 11,                      │                   │
│   │   seller_id = 2,                      │                   │
│   │   status = 'paid',                    │                   │
│   │   total_amount = 95000   ◄── 1 code   │                   │
│   │ )                                     │                   │
│   │ → order_id = 101                      │                   │
│   │                                       │                   │
│   │ INSERT INTO order_items (             │                   │
│   │   order_id = 101,                     │                   │
│   │   product_id = 1,                     │                   │
│   │   quantity = 1,          ◄── LUÔN = 1 │                   │
│   │   price_at_purchase = 95000,          │                   │
│   │   subtotal = 95000                    │                   │
│   │ )                                     │                   │
│   │                                       │                   │
│   │ UPDATE digital_goods_codes            │                   │
│   │ SET is_used = 1, used_by = 11         │                   │
│   │ WHERE code_id = 1;                    │                   │
│   └───────────────────────────────────────┘                   │
│                                                                 │
│   ┌───────────────────────────────────────┐                   │
│   │ Order 2 (cho code_id=2)               │                   │
│   ├───────────────────────────────────────┤                   │
│   │ → order_id = 102                      │                   │
│   │ [Tương tự]                            │                   │
│   └───────────────────────────────────────┘                   │
│                                                                 │
│   ┌───────────────────────────────────────┐                   │
│   │ Order 3 (cho code_id=3)               │                   │
│   ├───────────────────────────────────────┤                   │
│   │ → order_id = 103                      │                   │
│   │ [Tương tự]                            │                   │
│   └───────────────────────────────────────┘                   │
│                                                                 │
│ ═══════════════════════════════════════════════════════════════│
│ STEP 4: COMMIT                                                 │
│ ═══════════════════════════════════════════════════════════════│
│                                                                 │
│   conn.commit();                                                │
│   ✅ 3 orders created: [101, 102, 103]                         │
│                                                                 │
│ ═══════════════════════════════════════════════════════════════│
│ STEP 5: Sync inventory (sau khi commit)                       │
│ ═══════════════════════════════════════════════════════════════│
│                                                                 │
│   UPDATE inventory                                              │
│   SET quantity = (SELECT COUNT(*) FROM digital_goods_codes     │
│                   WHERE product_id = 1 AND is_used = 0)        │
│   WHERE product_id = 1;                                         │
│                                                                 │
│   → inventory.quantity: 5 → 2                                  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
        │
        ▼
Response: {
  "status": "SUCCESS",
  "message": "Đặt hàng thành công! Đã tạo 3 đơn hàng",
  "orderId": 101,
  "totalOrders": 3
}
        │
        ▼
GET /order/success?orderId=101

┌─────────────────────────────────────────────────────────────────┐
│ OrderSuccessController                                          │
├─────────────────────────────────────────────────────────────────┤
│ Lấy tất cả codes của user cho product này:                      │
│                                                                 │
│   SELECT * FROM digital_goods_codes                             │
│   WHERE used_by = 11 AND product_id = 1                        │
│   ORDER BY used_at DESC                                         │
│                                                                 │
│   → Kết quả: 3 codes                                           │
│     [code_id=1, VT100K001...]                                  │
│     [code_id=2, VT100K002...]                                  │
│     [code_id=3, VT100K003...]                                  │
│                                                                 │
│ → Forward to order-success.jsp                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📊 TRẠNG THÁI DATABASE SAU KHI MUA

### `orders` table:
```
order_id | buyer_id | seller_id | status | total_amount | created_at
---------|----------|-----------|--------|--------------|--------------------
101      | 11       | 2         | paid   | 95,000       | 2025-11-01 10:30:01
102      | 11       | 2         | paid   | 95,000       | 2025-11-01 10:30:01
103      | 11       | 2         | paid   | 95,000       | 2025-11-01 10:30:01
```

### `order_items` table:
```
item_id | order_id | product_id | quantity | price_at_purchase | subtotal
--------|----------|------------|----------|-------------------|----------
1       | 101      | 1          | 1        | 95,000            | 95,000
2       | 102      | 1          | 1        | 95,000            | 95,000
3       | 103      | 1          | 1        | 95,000            | 95,000
```

### `digital_goods_codes` table:
```
code_id | product_id | code_value      | is_used | used_by | used_at
--------|------------|-----------------|---------|---------|--------------------
1       | 1          | VT100K001...    | 1       | 11      | 2025-11-01 10:30:01
2       | 1          | VT100K002...    | 1       | 11      | 2025-11-01 10:30:01
3       | 1          | VT100K003...    | 1       | 11      | 2025-11-01 10:30:01
4       | 1          | VT100K004...    | 0       | NULL    | NULL
5       | 1          | VT100K005...    | 0       | NULL    | NULL
```

### `wallets` table:
```
wallet_id | user_id | balance (TRƯỚC) | balance (SAU)
----------|---------|-----------------|---------------
1         | 11      | 500,000         | 215,000       ← Trừ 285,000
```

### `inventory` table (sau sync):
```
inventory_id | product_id | quantity (TRƯỚC) | quantity (SAU)
-------------|------------|------------------|----------------
1            | 1          | 5                | 2              ← Sync từ COUNT
```

---

## 🎨 HIỂN THỊ TRÊN UI

### Trang Order Success (`order-success.jsp`):
```
╔═══════════════════════════════════════════════════════════╗
║        ✅ ĐẶT HÀNG THÀNH CÔNG!                            ║
╠═══════════════════════════════════════════════════════════╣
║                                                           ║
║  Đã tạo 3 đơn hàng cho sản phẩm: Thẻ cào Viettel 100K    ║
║  💰 Tổng thanh toán: 285,000đ                             ║
║  💵 Số dư còn lại: 215,000đ                               ║
║                                                           ║
║ ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓  ║
║ ┃ 🎁 DANH SÁCH MÃ ĐÃ MUA (3 MÃ)                       ┃  ║
║ ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛  ║
║                                                           ║
║  ┌────────────────────────────────────────────────┐      ║
║  │ Order #101                                     │      ║
║  │ ─────────────────────────────────────────────  │      ║
║  │ 📱 Mã: VT100K001234567890                      │      ║
║  │ 🏷️  Loại: Gift Card                            │      ║
║  │ 💵 Giá: 95,000đ                                │      ║
║  │ 📅 Ngày: 2025-11-01 10:30:01                   │      ║
║  └────────────────────────────────────────────────┘      ║
║                                                           ║
║  ┌────────────────────────────────────────────────┐      ║
║  │ Order #102                                     │      ║
║  │ ─────────────────────────────────────────────  │      ║
║  │ 📱 Mã: VT100K001234567891                      │      ║
║  │ 🏷️  Loại: Gift Card                            │      ║
║  │ 💵 Giá: 95,000đ                                │      ║
║  │ 📅 Ngày: 2025-11-01 10:30:01                   │      ║
║  └────────────────────────────────────────────────┘      ║
║                                                           ║
║  ┌────────────────────────────────────────────────┐      ║
║  │ Order #103                                     │      ║
║  │ ─────────────────────────────────────────────  │      ║
║  │ 📱 Mã: VT100K001234567892                      │      ║
║  │ 🏷️  Loại: Gift Card                            │      ║
║  │ 💵 Giá: 95,000đ                                │      ║
║  │ 📅 Ngày: 2025-11-01 10:30:01                   │      ║
║  └────────────────────────────────────────────────┘      ║
║                                                           ║
║  [Tải lại mã]  [Xem lịch sử đơn hàng]                    ║
╚═══════════════════════════════════════════════════════════╝
```

---

## 📋 MAPPING GIỮA CÁC BẢNG

```
┌─────────┐      ┌──────────────┐      ┌────────────┐      ┌────────────────────┐
│ wallets │      │ transactions │      │   orders   │      │    order_items     │
└─────────┘      └──────────────┘      └────────────┘      └────────────────────┘
    │                    │                    │                       │
    │                    │                    │                       │
    │ 1 transaction      │                    │ 3 orders              │
    │ -285,000đ          │                    │ (101, 102, 103)       │
    └────────────────────┘                    └───────────────────────┘
                                                       │
                                                       │ 3 order_items
                                                       │ (quantity=1 each)
                                                       │
                                              ┌────────▼───────────┐
                                              │  digital_goods_    │
                                              │     codes          │
                                              └────────────────────┘
                                              3 codes marked:
                                              - code_id=1 (used_by=11)
                                              - code_id=2 (used_by=11)
                                              - code_id=3 (used_by=11)
```

---

## 🔍 CÁC BẢNG ĐƯỢC SỬ DỤNG

| Bảng | Vai trò | SQL Operations |
|------|---------|----------------|
| `digital_goods_codes` | Nguồn gốc codes | SELECT (lock), UPDATE (is_used) |
| `wallets` | Ví điện tử | SELECT (check), UPDATE (trừ tiền) |
| `transactions` | Lịch sử giao dịch | INSERT (1 record) |
| **`orders`** | **Thông tin order** | **INSERT (3 records)** |
| **`order_items`** | **Link order ↔ product** | **INSERT (3 records)** |
| `inventory` | Cache số lượng | UPDATE (sau commit) |
| `pending_transactions` | Giữ tiền 7 ngày | INSERT (1 record) |

---

## 📂 FILES XỬ LÝ NGHIỆP VỤ

### Controllers:
1. `InstantCheckoutController.java` - Check stock & wallet
2. **`CheckoutProcessController.java`** - **Tạo NHIỀU orders (1 per code)**
3. `OrderSuccessController.java` - Hiển thị codes đã mua

### DAOs:
1. **`OrderDAO.java`** - **createInstantOrder(1 code), insertOrderItem()**
2. `DigitalGoodsCodeDAO.java` - Lock & mark codes
3. `WalletDAO.java` - Trừ tiền
4. `InventoryDAO.java` - Sync số lượng

### Models:
1. `Orders.java` - Order model
2. `OrderItems.java` - Order item model
3. `DigitalGoodsCode.java` - Digital code model

---

## ⚡ CONSOLE LOG MONG ĐỢI

```
═══════════════════════════════════════════════
🛒 CHECKOUT: 1 ORDER = 1 CODE DUY NHẤT
   User muốn: 3 codes
   → Tạo: 3 orders riêng biệt
═══════════════════════════════════════════════
🔒 Locked 3 codes for product 1
  ✓ Order 1/3: ID=101, Code=1
  ✓ Added order_item: order=101, product=1, code=1
  ✓ Marked code 1 as used by user 11
  ✓ Order 2/3: ID=102, Code=2
  ✓ Added order_item: order=102, product=1, code=2
  ✓ Marked code 2 as used by user 11
  ✓ Order 3/3: ID=103, Code=3
  ✓ Added order_item: order=103, product=1, code=3
  ✓ Marked code 3 as used by user 11
✅ Committed 3 orders successfully!
✅ Synced inventory for product 1: 2 codes
```

---

## 🎯 TẠI SAO LẠI THIẾT KẾ NHƯ VẬY?

### ✅ Ưu điểm:

1. **Đơn giản nhất:** Mỗi order = 1 code, dễ hiểu, dễ code
2. **Refund dễ:** Cancel 1 order = refund 1 code
3. **Tracking tốt:** Biết chính xác code nào thuộc order nào
4. **Không phức tạp:** Quantity luôn = 1, không cần tính toán

### ⚠️ Lưu ý:

- Nếu user mua nhiều codes → Nhiều orders
- Cần group hiển thị cho đẹp UI

---

**Thiết kế này CHUẨN 100% theo yêu cầu của bạn! 🎯**

