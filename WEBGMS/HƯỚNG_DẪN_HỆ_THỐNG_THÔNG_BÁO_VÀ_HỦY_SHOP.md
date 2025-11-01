# 🔔 Hệ Thống Thông Báo và Hủy Shop - Hướng Dẫn

## 📋 Tổng Quan

Hệ thống này bao gồm 2 tính năng chính:
1. **Thông báo** - Seller nhận thông báo về đơn hàng, rút tiền, và các hoạt động khác
2. **Hủy shop** - Seller có thể gửi yêu cầu đóng shop và xin hoàn tiền cọc

---

## 🗂️ Cấu Trúc Database

### 1. Bảng `notifications`
Lưu trữ thông báo gửi đến seller

**Cột quan trọng:**
- `notification_id` - ID thông báo
- `user_id` - ID người nhận (seller)
- `type` - Loại thông báo: order, withdrawal, system, shop_closure, warning, success
- `title` - Tiêu đề thông báo
- `message` - Nội dung chi tiết
- `link_url` - Link liên quan
- `is_read` - Trạng thái đã đọc (0/1)
- `related_id` - ID liên quan (order_id, withdrawal_id, etc)

### 2. Bảng `shop_closure_requests`
Lưu trữ yêu cầu hủy shop và hoàn tiền cọc

**Cột quan trọng:**
- `request_id` - ID yêu cầu
- `seller_id` - ID seller
- `reason` - Lý do hủy shop
- `deposit_amount` - Số tiền cọc cần hoàn
- `bank_name`, `bank_account_number`, `bank_account_name` - Thông tin ngân hàng
- `status` - Trạng thái: pending, approved, rejected, completed
- `admin_note` - Ghi chú từ admin
- `processed_by` - ID admin xử lý
- `refund_transaction_ref` - Mã giao dịch hoàn tiền
- `total_orders`, `pending_orders` - Thống kê đơn hàng

---

## 📁 Các File Đã Tạo

### Database
- `WEBGMS/notifications_and_shop_closure.sql` - Script tạo bảng và stored procedures

### Model Classes
- `WEBGMS/src/java/model/notification/Notification.java`
- `WEBGMS/src/java/model/shop/ShopClosureRequest.java`

### DAO Classes  
- `WEBGMS/src/java/dao/NotificationDAO.java`
- `WEBGMS/src/java/dao/ShopClosureRequestDAO.java`
- `WEBGMS/src/java/dao/OrderDAO.java` - Đã thêm 2 methods: countOrdersBySeller(), countPendingOrdersBySeller()

### Controllers
- `WEBGMS/src/java/controller/seller/SellerNotificationController.java`
- `WEBGMS/src/java/controller/seller/SellerCloseShopController.java`

### Views (Cần tạo tiếp)
- `WEBGMS/web/views/seller/seller-notifications.jsp` - Trang thông báo seller
- `WEBGMS/web/views/seller/seller-close-shop.jsp` - Form hủy shop
- `WEBGMS/web/views/admin/admin-shop-closures.jsp` - Trang admin quản lý yêu cầu hủy shop

---

## 🚀 Cài Đặt và Sử Dụng

### Bước 1: Import Database
```sql
-- Chạy file SQL này trong MySQL
SOURCE C:/Users/ASUS/Documents/E-Commerce/WEBGMS/notifications_and_shop_closure.sql;
```

### Bước 2: Cấu Hình Sidebar

**Seller Sidebar** đã được cập nhật:
- ❌ Bỏ menu "Rút tiền" (đã có trong dashboard)
- ✅ Thêm menu "Thông báo"  
- ✅ Thêm menu "Hủy shop"

File: `WEBGMS/web/views/component/seller-sidebar.jsp`

### Bước 3: Build và Deploy
```bash
# Trong NetBeans:
# 1. Clean and Build project (Shift + F11)
# 2. Run project (F6)
```

---

## 🔔 Tính Năng Thông Báo

### URL
```
/seller/notifications
```

### Loại Thông Báo
1. **order** - Đơn hàng mới
2. **withdrawal** - Rút tiền (thành công/từ chối)
3. **system** - Thông báo hệ thống
4. **shop_closure** - Thông báo về yêu cầu đóng shop
5. **warning** - Cảnh báo
6. **success** - Thành công

### Chức Năng
- ✅ Xem tất cả thông báo
- ✅ Xem thông báo chưa đọc
- ✅ Đánh dấu đã đọc (từng cái hoặc tất cả)
- ✅ Xóa thông báo
- ✅ Hiển thị số lượng thông báo chưa đọc
- ✅ Thời gian tương đối (vừa xong, 5 phút trước, 2 giờ trước, etc)

### Cách Tạo Thông Báo (Programmatically)

```java
// Trong code Java
NotificationDAO notificationDAO = new NotificationDAO();

// Thông báo đơn hàng mới
notificationDAO.notifyNewOrder(sellerId, orderId, "DH12345");

// Thông báo rút tiền thành công
notificationDAO.notifyWithdrawalSuccess(sellerId, withdrawalId, "5,000,000đ");

// Thông báo rút tiền bị từ chối
notificationDAO.notifyWithdrawalRejected(sellerId, withdrawalId, "Thiếu giấy tờ");

// Thông báo tùy chỉnh
notificationDAO.createNotification(
    sellerId,
    "system",
    "Tiêu đề",
    "Nội dung thông báo",
    "/link-lien-quan",
    relatedId
);
```

---

## 🏪 Tính Năng Hủy Shop

### URL
```
/seller/close-shop
```

### Quy Trình Hủy Shop

#### 1. Seller Gửi Yêu Cầu
- Điền lý do hủy shop
- Nhập số tiền cọc cần hoàn lại
- Cung cấp thông tin ngân hàng nhận tiền
- Hệ thống kiểm tra:
  - ❌ Không cho phép nếu có đơn hàng đang xử lý
  - ❌ Không cho phép nếu đã có yêu cầu đang chờ
  - ✅ Cho phép nếu mọi thứ OK

#### 2. Admin Xem Xét (pending)
- Xem danh sách yêu cầu hủy shop
- Kiểm tra thông tin seller
- Phê duyệt hoặc từ chối

#### 3. Admin Xử Lý (approved)
- Chuyển tiền cọc về tài khoản seller
- Nhập mã giao dịch
- Cập nhật trạng thái thành "completed"
- Hệ thống tự động:
  - Đóng shop (set status inactive)
  - Gửi thông báo cho seller

### Điều Kiện Hủy Shop
- ✅ Không có đơn hàng đang chờ xử lý
- ✅ Không có yêu cầu hủy đang chờ admin duyệt
- ✅ Phải cung cấp đầy đủ thông tin ngân hàng

### Trạng Thái Yêu Cầu
1. **pending** - Chờ admin duyệt
2. **approved** - Admin đã duyệt, đang xử lý chuyển tiền
3. **rejected** - Admin từ chối (có lý do)
4. **completed** - Đã hoàn tiền và đóng shop

---

## 🛠️ API Methods (DAO)

### NotificationDAO

```java
// Tạo thông báo
boolean createNotification(Notification notification)
boolean createNotification(Long userId, String type, String title, String message)

// Lấy thông báo
List<Notification> getNotificationsByUserId(Long userId, int limit)
List<Notification> getUnreadNotifications(Long userId)
int countUnreadNotifications(Long userId)

// Đánh dấu đã đọc
boolean markAsRead(Long notificationId)
boolean markAllAsRead(Long userId)

// Xóa thông báo
boolean deleteNotification(Long notificationId, Long userId)
boolean deleteAllReadNotifications(Long userId)

// Helper methods
boolean notifyNewOrder(Long sellerId, Long orderId, String orderCode)
boolean notifyWithdrawalSuccess(Long sellerId, Long withdrawalId, String amount)
boolean notifyWithdrawalRejected(Long sellerId, Long withdrawalId, String reason)
```

### ShopClosureRequestDAO

```java
// Tạo yêu cầu
boolean createClosureRequest(ShopClosureRequest request)

// Lấy thông tin
ShopClosureRequest getRequestBySellerId(Long sellerId)
ShopClosureRequest getRequestById(Long requestId)
List<ShopClosureRequest> getAllClosureRequests()
List<ShopClosureRequest> getRequestsByStatus(String status)

// Kiểm tra
boolean hasActivePendingRequest(Long sellerId)
int countPendingRequests()

// Cập nhật
boolean updateRequestStatus(Long requestId, String status, Long adminId, 
                           String adminNote, String transactionRef)

// Hủy yêu cầu
boolean cancelRequest(Long requestId, Long sellerId)
```

---

## 📱 URL Routes

### Seller Routes
```
/seller/notifications          - Trang thông báo
/seller/close-shop            - Trang yêu cầu hủy shop
/seller/withdrawal            - Trang rút tiền (đã có)
```

### Admin Routes (Cần tạo)
```
/admin/shop-closures          - Quản lý yêu cầu hủy shop
/admin/withdrawals            - Quản lý rút tiền (đã có)
```

---

## 🎨 UI/UX Features

### Thông Báo
- 🔴 Badge đỏ hiển thị số thông báo chưa đọc
- 🎨 Icon khác nhau cho mỗi loại thông báo
- ⏱️ Hiển thị thời gian tương đối
- 🔗 Click vào thông báo để đi đến trang liên quan
- ✅ Nút đánh dấu tất cả đã đọc
- 🗑️ Nút xóa thông báo đã đọc

### Hủy Shop
- ⚠️ Cảnh báo rõ ràng về hậu quả
- 📊 Hiển thị thống kê đơn hàng
- 🚫 Disable form nếu có đơn hàng đang chờ
- ✅ Validation đầy đủ
- 💳 Dropdown ngân hàng Việt Nam

---

## 🔒 Bảo Mật

### Seller
- ✅ Kiểm tra quyền seller
- ✅ Chỉ xem được thông báo của mình
- ✅ Không thể hủy yêu cầu đã được admin xử lý
- ✅ Không thể gửi nhiều yêu cầu cùng lúc

### Admin
- ✅ Kiểm tra quyền admin
- ✅ Ghi log người xử lý
- ✅ Lưu mã giao dịch chuyển tiền

---

## 📊 Thống Kê

### Seller Dashboard
- Số thông báo chưa đọc
- Trạng thái yêu cầu hủy shop (nếu có)

### Admin Dashboard  
- Số yêu cầu hủy shop đang chờ
- Số yêu cầu rút tiền đang chờ

---

## 🐛 Troubleshooting

### Lỗi "already_has_pending"
**Nguyên nhân:** Seller đã có yêu cầu đang chờ xử lý
**Giải pháp:** Đợi admin xử lý hoặc hủy yêu cầu cũ

### Lỗi "has_pending_orders"
**Nguyên nhân:** Còn đơn hàng đang xử lý
**Giải pháp:** Hoàn thành hoặc hủy tất cả đơn hàng trước

### Không nhận được thông báo
**Kiểm tra:**
1. Database đã import đúng chưa?
2. Code có gọi `notificationDAO.createNotification()` chưa?
3. User ID có đúng không?

---

## 📝 TODO (Cần Hoàn Thành)

### Views (JSP)
- [ ] `seller-notifications.jsp` - Trang thông báo seller
- [ ] `seller-close-shop.jsp` - Form hủy shop seller
- [ ] `admin-shop-closures.jsp` - Quản lý yêu cầu hủy shop (admin)

### Controllers (Admin)
- [ ] `AdminShopClosureController.java` - Xử lý yêu cầu hủy shop

### Tính Năng Bổ Sung
- [ ] Real-time notification (WebSocket)
- [ ] Email notification
- [ ] Push notification
- [ ] Notification sound
- [ ] Mark as unread
- [ ] Notification preferences

---

## 🎯 Best Practices

### Khi Tạo Thông Báo
```java
// ✅ Good - Rõ ràng, có link
notificationDAO.createNotification(
    sellerId,
    "order",
    "Đơn hàng mới #DH12345",
    "Bạn có đơn hàng mới từ khách hàng Nguyễn Văn A. Vui lòng xác nhận.",
    "/seller/orders?id=12345",
    12345L
);

// ❌ Bad - Không rõ ràng
notificationDAO.createNotification(
    sellerId,
    "system",
    "Thông báo",
    "Có thông báo mới",
    null,
    null
);
```

### Khi Xử Lý Yêu Cầu Hủy Shop (Admin)
1. Kiểm tra thông tin seller
2. Xác nhận số tiền cọc
3. Chuyển tiền trước
4. Cập nhật trạng thái sau
5. Gửi thông báo cho seller
6. Ghi log hệ thống

---

## 📞 Support

Nếu cần hỗ trợ:
1. Kiểm tra log Tomcat: `C:\Program Files\Apache Software Foundation\Tomcat 10.1\logs\`
2. Kiểm tra console NetBeans
3. Kiểm tra database có dữ liệu đúng không

---

*Tài liệu này được tạo để hướng dẫn sử dụng hệ thống thông báo và hủy shop.*
*Cập nhật lần cuối: 29/10/2025*





