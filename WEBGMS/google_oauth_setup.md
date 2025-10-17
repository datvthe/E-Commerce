# Google OAuth Setup Guide

## 1. Tạo Google Cloud Project

1. Truy cập [Google Cloud Console](https://console.cloud.google.com/)
2. Tạo project mới hoặc chọn project hiện có
3. Kích hoạt Google+ API

## 2. Tạo OAuth 2.0 Credentials

1. Vào **APIs & Services** > **Credentials**
2. Click **Create Credentials** > **OAuth 2.0 Client IDs**
3. Chọn **Web application**
4. Đặt tên: `WEBGMS OAuth Client`

### 5. Cấu hình Authorized JavaScript origins:
Thêm các origins sau vào **Authorized JavaScript origins**:
- `http://localhost:9999`
- `https://yourdomain.com` (cho production)

### 6. Cấu hình Authorized redirect URIs:
Thêm các URIs sau vào **Authorized redirect URIs**:
- `http://localhost:9999/WEBGMS/auth/google/callback`
- `https://yourdomain.com/WEBGMS/auth/google/callback` (cho production)

## 3. Cấu hình Application

1. Copy **Client ID** và **Client Secret** từ Google Cloud Console
2. Cập nhật file `GoogleAuthService.java`:

### **Bước 1: Mở file GoogleAuthService.java**
```bash
WEBGMS/src/java/service/GoogleAuthService.java
```

### **Bước 2: Thay thế placeholder values**
Tìm dòng 27-28 và thay thế:
```java
// TỪ:
private static final String GOOGLE_CLIENT_ID = "YOUR_GOOGLE_CLIENT_ID";
private static final String GOOGLE_CLIENT_SECRET = "YOUR_GOOGLE_CLIENT_SECRET";

// THÀNH:
private static final String GOOGLE_CLIENT_ID = "123456789-abcdefghijklmnop.apps.googleusercontent.com";
private static final String GOOGLE_CLIENT_SECRET = "GOCSPX-abcdefghijklmnopqrstuvwxyz";
```

### **Bước 3: Lấy Client ID và Secret từ Google Console**
1. Vào [Google Cloud Console](https://console.cloud.google.com/)
2. Chọn project của bạn
3. Vào **APIs & Services** > **Credentials**
4. Click vào OAuth 2.0 Client ID
5. Copy **Client ID** và **Client Secret**

### **Bước 4: Test OAuth Flow**
Sau khi cập nhật Client ID và Secret:
1. Restart Tomcat server
2. Truy cập: `http://localhost:9999/WEBGMS/login`
3. Click "Đăng nhập với Google"
4. Đăng nhập bằng tài khoản Google
5. Kiểm tra redirect về trang chủ

### **Bước 5: Kiểm Tra Database**
Sau khi đăng nhập thành công, kiểm tra:
```sql
-- Kiểm tra user mới được tạo
SELECT * FROM users WHERE auth_provider = 'google';

-- Kiểm tra thông tin Google OAuth
SELECT * FROM google_auth;
```

## 4. Cấu hình Database

Chạy file `abcs.sql` để tạo các bảng cần thiết:
```bash
mysql -u root -p < abcs.sql
```

## 5. Test Google Login

1. Khởi động ứng dụng
2. Truy cập `/login`
3. Click "Đăng nhập với Google"
4. Đăng nhập bằng tài khoản Google
5. Kiểm tra redirect về trang chủ

## 6. Troubleshooting

### Lỗi "redirect_uri_mismatch"
- Kiểm tra redirect URI trong Google Console
- Đảm bảo URL chính xác (không có trailing slash)
- **Quan trọng**: Phải có cả JavaScript origins và redirect URIs

### Lỗi "invalid_client"
- Kiểm tra Client ID và Client Secret
- Đảm bảo OAuth consent screen đã được cấu hình
- Kiểm tra JavaScript origins có đúng domain không

### Lỗi "access_denied"
- User đã từ chối quyền truy cập
- Kiểm tra OAuth consent screen configuration

### Lỗi "origin_mismatch"
- Kiểm tra **Authorized JavaScript origins**
- Đảm bảo domain chính xác (không có path, chỉ domain)
- Ví dụ: `http://localhost:9999` (đúng) vs `http://localhost:9999/WEBGMS` (sai)

## 7. Production Setup

1. Thêm domain production vào **Authorized redirect URIs**
2. Cập nhật `GOOGLE_REDIRECT_URI` trong code
3. Cấu hình HTTPS (bắt buộc cho production)
4. Cập nhật OAuth consent screen với domain thực

## 8. Security Notes

- Không commit Client Secret vào Git
- Sử dụng environment variables cho production
- Cấu hình HTTPS cho production
- Kiểm tra và validate tất cả OAuth responses
