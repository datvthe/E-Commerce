# 📋 TÓM TẮT: WORKFLOW ĐẶT HÀNG DIGITAL GOODS

## ⚡ NGUYÊN TẮC CỐT LÕI

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  1 ORDER = 1 CODE DUY NHẤT (Quantity = 1)  ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

User mua 3 codes → Tạo 3 orders riêng biệt
```

---

## 📊 CẤU TRÚC

| Bảng | Số Records | Nội dung |
|------|------------|----------|
| `orders` | **3** | 3 orders (mỗi order = 1 code) |
| `order_items` | **3** | Link order ↔ product (quantity=1) |
| `digital_goods_codes` | 3 updated | is_used: 0→1, used_by: NULL→11 |
| `wallets` | 1 updated | Trừ tiền 1 lần (tổng) |
| `inventory` | 1 updated | Sync: quantity giảm 3 |

---

## 🔄 WORKFLOW

```
1. User chọn product × 3
   ↓
2. Check stock (COUNT is_used=0)
   ↓
3. START TRANSACTION
   ↓
4. LOCK 3 codes (FOR UPDATE)
   ↓
5. Trừ tiền: 285,000đ (1 lần)
   ↓
6. FOR i=0 to 2:
     - CREATE order (total=95,000)
     - INSERT order_item (quantity=1)
     - UPDATE code (is_used=1)
   ↓
7. COMMIT
   ↓
8. Sync inventory
   ↓
9. Hiển thị 3 codes
```

---

## 📁 FILES CHÍNH

| File | Chức năng |
|------|-----------|
| `CheckoutProcessController.java` | Loop tạo NHIỀU orders |
| `OrderDAO.java` | createInstantOrder(1 code), insertOrderItem() |
| `DigitalGoodsCodeDAO.java` | Lock & mark codes |
| `OrderSuccessController.java` | Lấy codes đã mua |

---

## 🗄️ DATABASE TABLES

### orders (Không có product_id, quantity)
```sql
order_id | buyer_id | seller_id | status | total_amount
101      | 11       | 2         | paid   | 95,000      ← Code 1
102      | 11       | 2         | paid   | 95,000      ← Code 2
103      | 11       | 2         | paid   | 95,000      ← Code 3
```

### order_items (Quantity luôn = 1)
```sql
item_id | order_id | product_id | quantity | price
1       | 101      | 1          | 1        | 95,000
2       | 102      | 1          | 1        | 95,000
3       | 103      | 1          | 1        | 95,000
```

### digital_goods_codes (is_used = 1)
```sql
code_id | product_id | is_used | used_by
1       | 1          | 1       | 11      ← Order 101
2       | 1          | 1       | 11      ← Order 102
3       | 1          | 1       | 11      ← Order 103
```

---

## ✅ ĐÃ SỬA

1. ✅ Xóa `order_number` khỏi INSERT
2. ✅ Dùng `order_id` làm identifier
3. ✅ Loop tạo NHIỀU orders (1 per code)
4. ✅ Mỗi order_item có quantity = 1
5. ✅ JOIN order_items để lấy product_id
6. ✅ Dùng digital_goods_codes thay digital_products

---

## 🚀 TEST

```
1. Build project (Shift + F11)
2. Restart Tomcat
3. Test: http://localhost:8080/WEBGMS/checkout/instant?productId=1&quantity=3
4. Xác nhận thanh toán
5. Xem console → 3 orders created
6. Check database → 3 orders, 3 order_items, 3 codes used
```

---

**Xem chi tiết:** `ORDER_WORKFLOW_1CODE_PER_ORDER.md` 📖

