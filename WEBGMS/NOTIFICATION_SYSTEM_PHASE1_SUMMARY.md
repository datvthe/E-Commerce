# 📢 Notification System - Phase 1 Implementation Summary

## 🎯 Mục tiêu đã hoàn thành

Triển khai **Giai đoạn 1** - Admin gửi thông báo thủ công với các tính năng:

- ✅ Admin có thể gửi thông báo cho tất cả người dùng (broadcast)
- ✅ Admin có thể gửi thông báo cho 1 người dùng cụ thể
- ✅ Admin có thể gửi thông báo cho nhiều người dùng
- ✅ User xem danh sách thông báo (cả cá nhân và broadcast)
- ✅ User đánh dấu đã đọc thông báo cá nhân
- ✅ Hiển thị badge số thông báo chưa đọc trên header

## 📦 Các file đã tạo mới

### 1. Backend - DAO Layer

**`WEBGMS/src/java/dao/NotificationDAO.java`**

- CRUD operations cho notifications
- Các method chính:
  - `createNotification(Notifications n)` - Tạo thông báo
  - `createBroadcastNotification(title, message, type)` - Tạo broadcast (user_id = NULL)
  - `createUserNotification(userId, title, message, type)` - Tạo thông báo cho 1 user
  - `getNotificationsByUserId(userId)` - Lấy thông báo của user (cá nhân + broadcast)
  - `getUnreadCount(userId)` - Đếm thông báo chưa đọc
  - `markAsRead(notificationId)` - Đánh dấu đã đọc
  - `markAllAsRead(userId)` - Đánh dấu tất cả đã đọc (chỉ thông báo cá nhân)
  - `deleteNotification(notificationId)` - Xóa thông báo
  - `getAllNotifications(limit)` - Lấy tất cả (cho admin)

### 2. Backend - Service Layer

**`WEBGMS/src/java/service/NotificationService.java`**

- Business logic và validation
- Các method chính:
  - `sendBroadcastNotification(title, message, type)` - Gửi tới tất cả
  - `sendNotificationToUser(userId, title, message, type)` - Gửi cho 1 user
  - `sendNotificationToMultipleUsers(List<userId>, ...)` - Gửi cho nhiều users
  - `getUserNotifications(userId)` - Lấy thông báo của user
  - `getUnreadCount(userId)` - Số thông báo chưa đọc
  - `markAsRead(notificationId)` - Đánh dấu đã đọc
  - Validate notification type (order, promotion, wallet, system)
  - Kiểm tra user tồn tại trước khi gửi

### 3. Backend - Controllers

**`WEBGMS/src/java/controller/admin/AdminNotificationController.java`**

- Route: `/admin/notifications`, `/admin/notifications/send`
- Admin panel để gửi thông báo
- GET: Hiển thị form + danh sách users + thông báo gần đây
- POST: Xử lý gửi thông báo (all/single/multiple)

**`WEBGMS/src/java/controller/common/NotificationController.java`** (Updated)

- Route: `/notifications`, `/notifications/mark-read`, `/notifications/mark-all-read`
- GET: Lấy và hiển thị thông báo của user
- POST: Đánh dấu đã đọc

**`WEBGMS/src/java/controller/common/CommonHomeController.java`** (Updated)

- Thêm logic lấy số thông báo chưa đọc cho header badge

### 4. Frontend - Admin Panel

**`WEBGMS/web/views/admin/admin-notifications.jsp`**

- Giao diện admin gửi thông báo
- Form đầy đủ: Title, Message, Type, Recipients
- 3 chế độ gửi:
  - **Broadcast** - Tất cả người dùng
  - **Single** - Chọn 1 người từ dropdown
  - **Multiple** - Click chọn nhiều người (pill selection)
- Live preview thông báo trước khi gửi
- Hiển thị thông báo gần đây
- Thống kê nhanh

### 5. Frontend - User Pages

**`WEBGMS/web/views/common/notifications.jsp`** (Replaced)

- Trang danh sách thông báo động từ database
- Hiển thị thông báo cá nhân + broadcast
- Filter theo loại (all, unread, order, promotion, wallet, system)
- Đánh dấu đã đọc (chỉ cho thông báo cá nhân)
- Badge "Broadcast" cho thông báo toàn hệ thống
- Empty state khi chưa có thông báo

**`WEBGMS/web/views/common/home.jsp`** (Updated)

- Badge động hiển thị số thông báo chưa đọc
- Badge chỉ hiện khi có thông báo mới (> 0)
- Hiển thị "99+" nếu > 99 thông báo

## 🗄️ Database Design

### Sử dụng bảng hiện có: `notifications`

```sql
CREATE TABLE notifications (
  notification_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT DEFAULT NULL,  -- NULL = broadcast to all users
  title VARCHAR(150),
  message TEXT,
  type ENUM('order','promotion','wallet','system'),
  status ENUM('unread','read') DEFAULT 'unread',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);
```

### Quy tắc:

- `user_id = NULL` → Thông báo broadcast (gửi tất cả)
- `user_id = 123` → Thông báo cá nhân cho user 123
- Query lấy thông báo: `WHERE user_id = ? OR user_id IS NULL`

## 📊 Luồng hoạt động

### Flow 1: Admin gửi thông báo broadcast

```
Admin Panel → POST /admin/notifications/send
  ↓
AdminNotificationController
  ↓
NotificationService.sendBroadcastNotification()
  ↓
NotificationDAO.createBroadcastNotification()
  ↓
INSERT INTO notifications (user_id=NULL, ...)
  ↓
Success → Redirect với message
```

### Flow 2: Admin gửi cho 1 user

```
Admin chọn user từ dropdown → POST
  ↓
NotificationService.sendNotificationToUser(userId, ...)
  ↓
Validate user exists
  ↓
NotificationDAO.createUserNotification(userId, ...)
  ↓
INSERT INTO notifications (user_id=123, ...)
```

### Flow 3: User xem thông báo

```
User click vào icon chuông → GET /notifications
  ↓
NotificationController
  ↓
NotificationService.getUserNotifications(userId)
  ↓
NotificationDAO.getNotificationsByUserId(userId)
  ↓
Query: WHERE user_id = ? OR user_id IS NULL
  ↓
Hiển thị trên notifications.jsp
```

### Flow 4: User đánh dấu đã đọc

```
User click "Đánh dấu đã đọc" → POST /notifications/mark-read
  ↓
NotificationService.markAsRead(notificationId)
  ↓
UPDATE notifications SET status='read' WHERE notification_id=?
  ↓
Redirect về /notifications
```

## ⚠️ Giới hạn hiện tại (By Design)

### 1. Không track read status cho broadcast

- ❌ Không biết user nào đã đọc broadcast notification
- ✅ Chấp nhận vì không tạo bảng mới (theo yêu cầu)
- Giải pháp: Giai đoạn 2/3 có thể nâng cấp

### 2. Không thể đánh dấu broadcast đã đọc

- Broadcast là shared cho tất cả users
- Nếu cho phép đánh dấu → ảnh hưởng tới users khác
- Chỉ thông báo cá nhân mới có thể mark as read

### 3. Badge count bao gồm cả broadcast unread

- Badge hiển thị tổng (cá nhân + broadcast chưa đọc)
- Broadcast luôn có status = 'unread' (không thể update)

## 🎨 UI/UX Features

### Admin Panel:

- ✅ Form validation đầy đủ
- ✅ Live preview notification
- ✅ Icon động theo loại thông báo
- ✅ Multi-select user với pill UI
- ✅ Hiển thị thông báo gần đây
- ✅ Responsive design

### User Page:

- ✅ Filter theo loại thông báo
- ✅ Badge "Mới" cho unread
- ✅ Badge "Broadcast" cho thông báo chung
- ✅ Icon màu sắc theo loại
- ✅ Animation hover
- ✅ Empty state
- ✅ Responsive

## 🚀 Cách sử dụng

### Admin gửi thông báo:

1. Truy cập: `/admin/notifications`
2. Điền form: Title, Message, Type
3. Chọn người nhận:
   - **Tất cả**: Broadcast tới toàn bộ users
   - **Một người**: Chọn từ dropdown
   - **Nhiều người**: Click chọn từ danh sách
4. Xem preview → Click "Gửi thông báo"

### User xem thông báo:

1. Click icon chuông trên header (có badge số lượng)
2. Xem danh sách thông báo
3. Filter theo loại nếu cần
4. Click "Đánh dấu đã đọc" cho từng thông báo (chỉ cá nhân)
5. Hoặc "Đánh dấu tất cả đã đọc" (chỉ cá nhân)

## 📝 Testing Checklist

### Test Cases cần chạy:

#### Admin:

- [ ] Gửi broadcast notification → Kiểm tra tất cả users nhận được
- [ ] Gửi notification cho 1 user → Chỉ user đó nhận
- [ ] Gửi cho nhiều users → Các users được chọn nhận
- [ ] Validate form: Để trống title/message → Error
- [ ] Validate: Chọn type invalid → Error
- [ ] Preview notification → Hiển thị đúng icon/content

#### User:

- [ ] Login → Xem badge số thông báo đúng
- [ ] Vào /notifications → Hiển thị thông báo cá nhân + broadcast
- [ ] Filter "Chưa đọc" → Chỉ hiển thị unread
- [ ] Filter theo type → Hiển thị đúng type
- [ ] Đánh dấu 1 thông báo đã đọc → Badge giảm
- [ ] Đánh dấu tất cả đã đọc → Badge = 0 (hoặc chỉ còn broadcast)

#### Database:

- [ ] user_id = NULL cho broadcast → Query đúng
- [ ] user_id = X cho personal → Query đúng
- [ ] `WHERE user_id = ? OR user_id IS NULL` → Lấy đúng cả 2 loại

## 🔮 Roadmap - Giai đoạn tiếp theo

### Giai đoạn 2: Event-Driven Notifications

- [ ] Tự động gửi khi đơn hàng được tạo
- [ ] Tự động gửi khi thanh toán thành công
- [ ] Tự động gửi khi nạp tiền vào ví
- [ ] Event Listener pattern
- [ ] Notification templates

### Giai đoạn 3: Real-time với WebSocket

- [ ] WebSocket Server
- [ ] Push notification trực tiếp tới browser
- [ ] Popup toast khi có thông báo mới
- [ ] Live badge update (không cần reload)
- [ ] Notification sound

## 🐛 Known Issues / Limitations

1. **Jakarta import warnings**: IDE có thể báo lỗi import jakarta.\*, nhưng sẽ chạy OK ở runtime nếu có dependency đúng

2. **Broadcast không có read tracking**: Không biết user nào đã đọc broadcast. Đây là trade-off để không tạo bảng mới.

3. **Performance với nhiều users**: Nếu có 10,000+ users, query `user_id IS NULL` có thể chậm. Cần index:

   ```sql
   CREATE INDEX idx_user_null ON notifications(user_id, status);
   ```

4. **Admin access control**: Hiện tại chưa check role admin nghiêm ngặt trong AdminNotificationController. Cần add RBAC check.

## 📚 Dependencies

Các thư viện cần có:

- Jakarta Servlet API
- JSTL (Jakarta Tags)
- MySQL Connector
- Bootstrap 5.3.2
- Bootstrap Icons
- jQuery 3.6.0

## 👥 Credits

Developed by: AI Assistant
Project: Gicungco E-Commerce Platform
Phase: 1 - Manual Admin Notifications
Date: 2025
