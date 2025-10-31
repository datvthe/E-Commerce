# 🚀 Notification System - Quick Start Guide

## 📋 Prerequisites

1. ✅ Database có bảng `notifications` (đã có sẵn)
2. ✅ Có ít nhất 1 user trong database
3. ✅ Server đang chạy

## 🎯 Bước 1: Test Admin Panel (Gửi thông báo)

### 1.1 Truy cập Admin Panel

```
URL: http://localhost:8080/WEBGMS/admin/notifications
```

### 1.2 Gửi thông báo Broadcast (Test đầu tiên)

1. **Title**: `Chào mừng đến với Gicungco!`
2. **Message**: `Đây là thông báo chào mừng từ admin. Chúc bạn mua sắm vui vẻ!`
3. **Type**: Chọn `⚙️ Hệ thống`
4. **Người nhận**: Chọn `Tất cả người dùng`
5. Click **"Gửi thông báo"**

✅ **Kết quả mong đợi**:

- Hiện message "Đã gửi thông báo đến tất cả người dùng!"
- Thông báo xuất hiện trong "Thông báo gần đây" bên phải
- Badge "Tất cả" ở phần Recent Notifications

### 1.3 Gửi thông báo cho 1 User cụ thể

1. **Title**: `Đơn hàng #DH12345 đã được xác nhận`
2. **Message**: `Đơn hàng của bạn đang được xử lý. Dự kiến giao hàng trong 2-3 ngày.`
3. **Type**: Chọn `📦 Đơn hàng`
4. **Người nhận**: Chọn `Một người dùng`
5. Chọn user từ dropdown (ví dụ: #1 - Admin User)
6. Click **"Gửi thông báo"**

✅ **Kết quả mong đợi**:

- Hiện message "Đã gửi thông báo đến người dùng #1"
- Thông báo xuất hiện với badge "#1" (user ID)

### 1.4 Gửi Khuyến mãi cho nhiều Users

1. **Title**: `🎉 Flash Sale 50%`
2. **Message**: `Chỉ hôm nay! Giảm giá 50% cho tất cả sản phẩm. Nhập mã: FLASH50`
3. **Type**: Chọn `🎁 Khuyến mãi`
4. **Người nhận**: Chọn `Nhiều người dùng`
5. Click chọn 2-3 users từ danh sách (pill sẽ chuyển màu cam)
6. Click **"Gửi thông báo"**

✅ **Kết quả mong đợi**:

- Hiện "Đã gửi thông báo đến X/Y người dùng"
- Các users được chọn sẽ nhận được thông báo

---

## 👤 Bước 2: Test User View (Xem thông báo)

### 2.1 Login as User

```
URL: http://localhost:8080/WEBGMS/login
```

Login với account user đã được gửi thông báo ở bước 1

### 2.2 Kiểm tra Badge trên Header

- Nhìn lên góc phải header (bên trái chữ "VND")
- Icon chuông 🔔 phải có badge màu đỏ với số thông báo

✅ **Kết quả mong đợi**:

- Badge hiển thị số thông báo chưa đọc (ví dụ: "3")
- Badge không hiện nếu không có thông báo

### 2.3 Click vào Icon Thông báo

Click vào icon chuông → Chuyển đến trang `/notifications`

✅ **Kết quả mong đợi**:

- Hiển thị danh sách thông báo
- Thông báo broadcast có badge "Broadcast"
- Thông báo cá nhân có badge "Mới" (nếu unread)
- Icon khác nhau theo type:
  - 📦 Xanh dương (Order)
  - 🎁 Cam (Promotion)
  - 💰 Xanh lá (Wallet)
  - ⚙️ Tím (System)

### 2.4 Test Filter

Click các nút filter:

- **Tất cả**: Hiển thị tất cả
- **Chưa đọc**: Chỉ hiển thị unread
- **Đơn hàng**: Chỉ hiển thị type="order"
- **Khuyến mãi**: Chỉ hiển thị type="promotion"
- etc.

✅ **Kết quả mong đợi**:

- Filter hoạt động đúng
- Button active chuyển sang màu cam

### 2.5 Đánh dấu 1 thông báo đã đọc

1. Tìm 1 thông báo **cá nhân** (không phải broadcast)
2. Click nút "Đánh dấu đã đọc" (icon ✓)

✅ **Kết quả mong đợi**:

- Trang reload
- Thông báo đó mất badge "Mới"
- Background đổi từ cam nhạt → xám nhạt
- Badge số thông báo giảm đi 1

### 2.6 Đánh dấu tất cả đã đọc

1. Click nút **"Đánh dấu tất cả đã đọc"** ở trên cùng

✅ **Kết quả mong đợi**:

- Tất cả thông báo **cá nhân** chuyển sang "read"
- Broadcast notifications vẫn giữ nguyên (vì không thể đánh dấu)
- Badge header = 0 (hoặc chỉ còn số broadcast)

---

## 🔍 Bước 3: Kiểm tra Database

### 3.1 Query kiểm tra Broadcast

```sql
SELECT * FROM notifications WHERE user_id IS NULL;
```

✅ Phải có ít nhất 1 record với `user_id = NULL`

### 3.2 Query kiểm tra Personal

```sql
SELECT * FROM notifications WHERE user_id = 1;  -- Thay 1 bằng user_id của bạn
```

✅ Phải có các thông báo cá nhân

### 3.3 Query lấy thông báo như User

```sql
SELECT * FROM notifications
WHERE user_id = 1 OR user_id IS NULL
ORDER BY created_at DESC
LIMIT 50;
```

✅ Phải trả về cả personal + broadcast

### 3.4 Kiểm tra Status

```sql
SELECT status, COUNT(*) as count
FROM notifications
WHERE user_id = 1 OR user_id IS NULL
GROUP BY status;
```

✅ Sau khi đánh dấu đã đọc, phải có cả `read` và `unread`

---

## 🐛 Troubleshooting

### Issue 1: Badge không hiển thị

**Triệu chứng**: Icon chuông không có badge số

**Nguyên nhân**:

- User chưa login
- Không có thông báo unread
- `unreadNotificationCount` không được set

**Giải pháp**:

1. Kiểm tra user đã login chưa: `${sessionScope.user}`
2. Kiểm tra database có notification chưa
3. Check console log xem có lỗi SQL không

### Issue 2: Không gửi được thông báo

**Triệu chứng**: Click "Gửi thông báo" nhưng không thấy gì

**Nguyên nhân**:

- Form validation lỗi
- Database connection error
- User không tồn tại

**Giải pháp**:

1. Check browser console (F12)
2. Check server logs
3. Verify user_id tồn tại trong database

### Issue 3: Lỗi Jakarta import

**Triệu chứng**: IDE báo lỗi `jakarta cannot be resolved`

**Nguyên nhân**: IDE chưa nhận dependencies

**Giải pháp**:

1. Clean and rebuild project
2. Restart IDE
3. Verify `jakarta.servlet-api` trong dependencies
4. **Lỗi này chỉ ở IDE, runtime vẫn chạy OK**

### Issue 4: 404 Not Found - /admin/notifications

**Triệu chứng**: Truy cập admin panel bị 404

**Nguyên nhân**:

- Controller chưa được deploy
- URL mapping sai

**Giải pháp**:

1. Clean and rebuild project
2. Restart server
3. Check servlet mapping trong `@WebServlet` annotation
4. Verify URL: `/WEBGMS/admin/notifications` (có context path)

---

## ✅ Success Criteria

Hệ thống hoạt động đúng khi:

### Admin Panel:

- [x] Truy cập được `/admin/notifications`
- [x] Form hiển thị đầy đủ: Title, Message, Type, Recipients
- [x] Preview notification hoạt động
- [x] Gửi broadcast thành công
- [x] Gửi cho 1 user thành công
- [x] Gửi cho nhiều users thành công
- [x] Hiển thị thông báo gần đây

### User View:

- [x] Badge hiển thị số thông báo đúng
- [x] Truy cập được `/notifications`
- [x] Hiển thị cả broadcast + personal notifications
- [x] Filter hoạt động
- [x] Đánh dấu đã đọc thành công (personal only)
- [x] Đánh dấu tất cả đã đọc thành công
- [x] Badge update sau khi mark as read

### Database:

- [x] Record với `user_id = NULL` là broadcast
- [x] Record với `user_id = X` là personal
- [x] Query `WHERE user_id = ? OR user_id IS NULL` hoạt động
- [x] Status update từ `unread` → `read`

---

## 📞 Support

Nếu gặp vấn đề:

1. Check console logs (browser + server)
2. Check database records
3. Verify dependencies
4. Restart server
5. Xem file `NOTIFICATION_SYSTEM_PHASE1_SUMMARY.md` để biết chi tiết

---

## 🎉 Next Steps

Sau khi test xong Giai đoạn 1:

- **Giai đoạn 2**: Event-Driven Notifications (tự động gửi khi có sự kiện)
- **Giai đoạn 3**: Real-time WebSocket (push trực tiếp, không cần reload)

Happy Testing! 🚀
