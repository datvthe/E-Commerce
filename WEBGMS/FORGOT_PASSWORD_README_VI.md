# Chức Năng Quên Mật Khẩu

Tài liệu này mô tả chức năng quên mật khẩu được triển khai cho Hệ Thống Gicungco Marketplace.

## Tổng Quan

Chức năng quên mật khẩu cho phép người dùng đặt lại mật khẩu bằng cách nhận mã xác thực qua email. Hệ thống tuân theo quy trình 3 bước an toàn:

1. **Yêu Cầu Đặt Lại**: Người dùng nhập địa chỉ email của họ
2. **Xác Thực Mã**: Người dùng nhập mã xác thực 6 chữ số được gửi đến email
3. **Đặt Lại Mật Khẩu**: Người dùng đặt mật khẩu mới

## Tính Năng

- ✅ Đặt lại mật khẩu qua email
- ✅ Tạo mã xác thực 6 chữ số
- ✅ Mã xác thực hết hạn sau 15 phút
- ✅ Gửi email an toàn sử dụng Gmail SMTP
- ✅ Mẫu email HTML đẹp mắt
- ✅ Xác thực form và xử lý lỗi
- ✅ Giao diện Bootstrap phản hồi
- ✅ Quản lý phiên cho quy trình nhiều bước

## Các Tệp Được Tạo/Chỉnh Sửa

### Tệp Mới Được Tạo:

1. **Model**: `src/java/model/user/PasswordReset.java`
   - Đại diện cho các yêu cầu đặt lại mật khẩu trong cơ sở dữ liệu

2. **DAO**: `src/java/dao/PasswordResetDAO.java`
   - Xử lý tất cả các thao tác cơ sở dữ liệu cho chức năng đặt lại mật khẩu

3. **Service**: `src/java/service/EmailService.java`
   - Xử lý việc gửi email sử dụng Gmail SMTP
   - Tạo mẫu email HTML đẹp mắt

4. **Controller**: `src/java/controller/common/ForgotPasswordController.java`
   - Xử lý tất cả các yêu cầu HTTP cho chức năng quên mật khẩu
   - Quản lý quy trình 3 bước

5. **View**: `web/views/common/forgot-password.jsp`
   - Giao diện form nhiều bước cho đặt lại mật khẩu
   - Thiết kế Bootstrap phản hồi

6. **Database**: `password_reset_table.sql`
   - Script SQL để tạo bảng Password_Reset

### Tệp Được Chỉnh Sửa:

1. **web.xml**: Đã thêm ánh xạ servlet cho ForgotPasswordController
2. **login.jsp**: Đã có liên kết "Quên mật khẩu?" trỏ đến `/forgot-password`

## Lược Đồ Cơ Sở Dữ Liệu

```sql
CREATE TABLE Password_Reset (
    reset_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    verification_code VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL,
    used BOOLEAN DEFAULT FALSE,
    used_at TIMESTAMP NULL,
    INDEX idx_email (email),
    INDEX idx_verification_code (verification_code),
    INDEX idx_expires_at (expires_at)
);
```

## Cấu Hình Email

Hệ thống sử dụng Gmail SMTP với cấu hình sau:
- **Email**: gicungco.marketplace@gmail.com
- **Mật khẩu**: wltf drfp blty wjje (Mật khẩu Ứng dụng)
- **SMTP Host**: smtp.gmail.com
- **SMTP Port**: 587
- **Bảo mật**: TLS/SSL được bật

## Tính Năng Bảo Mật

1. **Hết Hạn Mã**: Mã xác thực hết hạn sau 15 phút
2. **Sử Dụng Một Lần**: Mỗi mã xác thực chỉ có thể sử dụng một lần
3. **Xác Thực Email**: Chỉ chấp nhận địa chỉ email hợp lệ
4. **Kiểm Tra Tồn Tại Người Dùng**: Hệ thống kiểm tra xem email có tồn tại trước khi gửi mã
5. **Quản Lý Phiên**: Xử lý phiên an toàn cho quy trình nhiều bước
6. **Xác Thực Đầu Vào**: Tất cả đầu vào được xác thực ở cả phía khách hàng và máy chủ

## Hướng Dẫn Sử Dụng

### Cho Người Dùng:

1. Đi đến trang đăng nhập
2. Nhấp vào liên kết "Quên mật khẩu?"
3. Nhập địa chỉ email của bạn
4. Kiểm tra email để lấy mã xác thực 6 chữ số
5. Nhập mã xác thực
6. Đặt mật khẩu mới của bạn
7. Đăng nhập bằng mật khẩu mới

### Cho Nhà Phát Triển:

1. **Thiết Lập Cơ Sở Dữ Liệu**: Chạy script `password_reset_table.sql`
2. **Cấu Hình Email**: Cập nhật thông tin đăng nhập email trong `EmailService.java` nếu cần
3. **Triển Khai**: Triển khai ứng dụng với tất cả các tệp mới
4. **Kiểm Tra**: Kiểm tra quy trình hoàn chỉnh với địa chỉ email hợp lệ

## API Endpoints

- `GET /forgot-password` - Hiển thị form quên mật khẩu
- `POST /forgot-password` với `action=request-reset` - Gửi mã xác thực
- `POST /forgot-password` với `action=verify-code` - Xác thực mã
- `POST /forgot-password` với `action=reset-password` - Đặt lại mật khẩu

## Xử Lý Lỗi

Hệ thống xử lý các tình huống lỗi khác nhau:
- Địa chỉ email không hợp lệ
- Tài khoản người dùng không tồn tại
- Mã xác thực hết hạn
- Mã xác thực không hợp lệ
- Mật khẩu không khớp
- Lỗi gửi email
- Vấn đề kết nối cơ sở dữ liệu

## Kiểm Tra

Để kiểm tra chức năng:

1. **Thiết Lập**: Đảm bảo bảng cơ sở dữ liệu được tạo và dịch vụ email được cấu hình
2. **Kiểm Tra Email**: Sử dụng địa chỉ email hợp lệ tồn tại trong bảng Users
3. **Kiểm Tra Quy Trình**: Hoàn thành toàn bộ quy trình 3 bước
4. **Kiểm Tra Bảo Mật**: Thử mã không hợp lệ, mã hết hạn, v.v.
5. **Kiểm Tra Giao Diện**: Xác minh thiết kế phản hồi trên các thiết bị khác nhau

## Khắc Phục Sự Cố

### Vấn Đề Thường Gặp:

1. **Không nhận được email**: Kiểm tra thư mục spam, xác minh cấu hình email
2. **Lỗi cơ sở dữ liệu**: Đảm bảo bảng Password_Reset tồn tại
3. **Mã hết hạn**: Yêu cầu mã xác thực mới
4. **Mã không hợp lệ**: Kiểm tra lại mã 6 chữ số từ email

### Các Bước Gỡ Lỗi:

1. Kiểm tra nhật ký máy chủ để tìm thông báo lỗi
2. Xác minh kết nối cơ sở dữ liệu
3. Kiểm tra cấu hình email riêng biệt
4. Kiểm tra console trình duyệt để tìm lỗi JavaScript

## Cải Tiến Trong Tương Lai

Các cải tiến tiềm năng cho tương lai:
- Xác thực SMS như một phương án thay thế cho email
- Giới hạn tốc độ cho yêu cầu đặt lại mật khẩu
- Yêu cầu độ mạnh mật khẩu
- Khóa tài khoản sau nhiều lần thử thất bại
- Ghi log kiểm toán cho các sự kiện bảo mật
- Hỗ trợ đa ngôn ngữ

## Cân Nhắc Bảo Mật

- Mã xác thực là các số ngẫu nhiên 6 chữ số
- Mã hết hạn sau 15 phút để bảo mật
- Mỗi mã chỉ có thể sử dụng một lần
- Địa chỉ email được xác thực trước khi gửi mã
- Dữ liệu phiên được quản lý và dọn dẹp đúng cách
- Không có thông tin nhạy cảm nào được ghi log

---

**Lưu ý**: Chức năng này hiện đã được tích hợp đầy đủ vào Hệ Thống Gicungco Marketplace và sẵn sàng sử dụng.
