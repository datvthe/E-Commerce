# Hướng Dẫn Khắc Phục Lỗi Project WEBGMS

## 📋 Tóm Tắt Vấn Đề

Sau khi phân tích, tôi phát hiện các vấn đề sau:

### ✅ Các Thành Phần Hoạt Động Tốt:
- ✅ **Java 17** - Đã cài đặt và hoạt động (`Java version "17.0.12"`)
- ✅ **MySQL 9.4** - Đang chạy và lắng nghe trên port 3306
- ✅ **Tomcat 10.1** - Đã cài đặt tại `C:\Program Files\Apache Software Foundation\Tomcat 10.1`
- ✅ **Project đã được build** - Thư mục `build\web` tồn tại
- ✅ **Deployment descriptor** - File `WEBGMS.xml` đã được cấu hình

### ❌ Vấn Đề Chính:

#### 1. **🔴 TOMCAT SERVER ĐANG DỪNG** (Vấn đề nghiêm trọng nhất)
   - **Trạng thái**: Service Tomcat10 đang ở trạng thái `Stopped`
   - **Port**: Tomcat được cấu hình chạy trên port **9999** (không phải 8080 mặc định)
   - **Nguyên nhân**: Server chưa được khởi động

#### 2. **⚠️ APACHE ANT KHÔNG CÓ TRONG PATH**
   - **Vấn đề**: Không thể chạy lệnh `ant` để build project
   - **Ảnh hưởng**: Không thể build project từ command line

#### 3. **⚠️ MYSQL CLI KHÔNG CÓ TRONG PATH**
   - **Vấn đề**: Không thể chạy lệnh `mysql` từ command line
   - **Ảnh hưởng**: Nhỏ - vẫn có thể dùng MySQL Workbench hoặc phpMyAdmin

---

## 🔧 Giải Pháp Chi Tiết

### Giải Pháp 1: Khởi Động Tomcat Server (QUAN TRỌNG NHẤT)

#### Cách 1: Sử dụng NetBeans (Khuyến Nghị)
1. Mở **NetBeans IDE**
2. Mở project **WEBGMS**
3. Nhấn **F6** hoặc click chuột phải vào project → **Run**
4. NetBeans sẽ tự động:
   - Build project
   - Khởi động Tomcat
   - Deploy ứng dụng
   - Mở trình duyệt

#### Cách 2: Khởi Động Service Tomcat10 (Cần quyền Admin)
1. Mở **Command Prompt hoặc PowerShell với quyền Administrator**
2. Chạy lệnh:
   ```powershell
   net start Tomcat10
   ```
   hoặc
   ```powershell
   Start-Service -Name "Tomcat10"
   ```

3. Kiểm tra trạng thái:
   ```powershell
   Get-Service -Name Tomcat10
   ```

4. Kiểm tra port 9999 đang lắng nghe:
   ```powershell
   netstat -an | findstr "9999"
   ```

#### Cách 3: Sử dụng Script Startup (Nếu cách 2 không hoạt động)
1. Mở **PowerShell với quyền Administrator**
2. Chạy:
   ```powershell
   & "C:\Program Files\Apache Software Foundation\Tomcat 10.1\bin\startup.bat"
   ```

#### Cách 4: Sử dụng Tomcat Manager GUI
1. Mở **Tomcat Monitor** (biểu tượng trong System Tray)
2. Click **Start Service**

---

### Giải Pháp 2: Cài Đặt Apache Ant (Tùy Chọn)

#### Tại Sao Cần Ant?
- Để build project từ command line
- NetBeans đã tích hợp Ant nội bộ, nên không bắt buộc phải cài

#### Cách Cài Đặt (Nếu Muốn):
1. **Download Apache Ant**:
   - Truy cập: https://ant.apache.org/bindownload.cgi
   - Download phiên bản mới nhất (zip file)

2. **Giải Nén**:
   - Giải nén vào `C:\apache-ant\` (hoặc thư mục bất kỳ)

3. **Thêm Vào PATH**:
   - Mở **System Properties** → **Environment Variables**
   - Thêm `C:\apache-ant\bin` vào biến **Path**

4. **Kiểm Tra**:
   ```powershell
   ant -version
   ```

---

### Giải Pháp 3: Kiểm Tra Và Sửa Database

#### Kiểm Tra Database Tồn Tại:
1. Mở **MySQL Workbench** hoặc **Command Prompt với MySQL PATH**
2. Kết nối tới MySQL:
   - Host: `localhost`
   - Port: `3306`
   - User: `root`
   - Password: `Tunxinhso1`

3. Kiểm tra database:
   ```sql
   SHOW DATABASES LIKE 'gicungco';
   ```

4. Nếu không có, import database:
   ```sql
   CREATE DATABASE gicungco CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   USE gicungco;
   SOURCE C:/Users/ASUS/Documents/E-Commerce/gicungco.sql;
   ```

---

## 🚀 Quy Trình Chạy Project Đầy Đủ

### Phương Án A: Sử Dụng NetBeans (Khuyến Nghị)

1. **Mở NetBeans IDE**
2. **File** → **Open Project**
3. Chọn thư mục `WEBGMS`
4. Nhấn **F6** hoặc click chuột phải → **Run**
5. Đợi build và deploy hoàn tất
6. Trình duyệt sẽ tự động mở tại: `http://localhost:9999/WEBGMS/`

### Phương Án B: Chạy Thủ Công

1. **Build Project** (nếu cần):
   ```powershell
   cd "C:\Users\ASUS\Documents\E-Commerce\WEBGMS"
   # Nếu đã cài Ant:
   ant clean
   ant build
   ```

2. **Khởi Động Tomcat** (với quyền Admin):
   ```powershell
   Start-Service -Name "Tomcat10"
   ```

3. **Kiểm Tra Server Đang Chạy**:
   ```powershell
   netstat -an | findstr "9999"
   ```
   Phải thấy: `TCP 0.0.0.0:9999 ... LISTENING`

4. **Truy Cập Ứng Dụng**:
   - URL: `http://localhost:9999/WEBGMS/`
   - Hoặc: `http://localhost:9999/WEBGMS/home` (tùy cấu hình)

---

## 🔍 Kiểm Tra Lỗi

### Kiểm Tra Log Tomcat:
```powershell
Get-Content "C:\Program Files\Apache Software Foundation\Tomcat 10.1\logs\catalina.*.log" -Tail 100
```

### Kiểm Tra Log NetBeans:
- Xem tab **Output** trong NetBeans
- Tìm thông báo lỗi màu đỏ

### Lỗi Thường Gặp:

#### 1. **Port 9999 Đã Bị Chiếm**
```
Address already in use: bind
```
**Giải pháp**:
```powershell
# Tìm process đang dùng port 9999
netstat -ano | findstr "9999"
# Kill process (thay PID bằng số process ID)
taskkill /PID <PID> /F
```

#### 2. **Không Kết Nối Được Database**
```
Access denied for user 'root'@'localhost'
```
**Giải pháp**:
- Kiểm tra mật khẩu MySQL trong `DBConnection.java`
- Đảm bảo database `gicungco` tồn tại

#### 3. **ClassNotFoundException**
```
java.lang.ClassNotFoundException: com.mysql.cj.jdbc.Driver
```
**Giải pháp**:
- Kiểm tra thư viện MySQL Connector trong `web/WEB-INF/lib/`
- File `mysql-connector-j-9.4.0.jar` phải tồn tại

---

## 📝 Cấu Hình Quan Trọng

### Thông Tin Kết Nối Database:
- **URL**: `jdbc:mysql://localhost:3306/gicungco`
- **User**: `root`
- **Password**: `Tunxinhso1`
- **Database**: `gicungco`

### Thông Tin Tomcat:
- **Version**: Apache Tomcat 10.1.17
- **Port**: `9999` (không phải 8080)
- **Context Path**: `/WEBGMS`
- **Deployment Path**: `C:\Users\ASUS\Documents\E-Commerce\WEBGMS\build\web`

### URLs Quan Trọng:
- **Trang chủ**: `http://localhost:9999/WEBGMS/`
- **Home**: `http://localhost:9999/WEBGMS/home`
- **Admin**: `http://localhost:9999/WEBGMS/admin/`
- **Seller**: `http://localhost:9999/WEBGMS/seller/`

---

## ✅ Checklist Trước Khi Chạy

- [ ] MySQL service đang chạy
- [ ] Database `gicungco` đã được tạo và import
- [ ] Tomcat service đang chạy hoặc sẽ khởi động qua NetBeans
- [ ] Port 9999 không bị chiếm bởi process khác
- [ ] Project đã được build (thư mục `build/web` tồn tại)
- [ ] File `WEBGMS.xml` tồn tại trong Tomcat config

---

## 🆘 Nếu Vẫn Không Chạy Được

### Bước 1: Reset Hoàn Toàn
```powershell
# Dừng Tomcat
Stop-Service -Name "Tomcat10"

# Clean build
cd "C:\Users\ASUS\Documents\E-Commerce\WEBGMS"
# Xóa thư mục build nếu có Ant
# ant clean

# Hoặc xóa thủ công thư mục build
Remove-Item -Recurse -Force "build"
```

### Bước 2: Rebuild Trong NetBeans
1. Mở NetBeans
2. **Clean and Build** project (Shift+F11)
3. Chờ build hoàn tất
4. **Run** project (F6)

### Bước 3: Kiểm Tra Lỗi Chi Tiết
- Xem tab **Output** trong NetBeans
- Copy toàn bộ lỗi và search Google hoặc hỏi AI

---

## 📞 Liên Hệ Hỗ Trợ

Nếu gặp lỗi khác, cung cấp thông tin sau:
1. Thông báo lỗi chi tiết từ NetBeans
2. Nội dung file log Tomcat
3. Screenshot nếu có
4. Các bước đã thử

---

## 🎯 Tóm Tắt Nhanh

**Vấn đề chính**: Tomcat Server đang dừng

**Giải pháp nhanh nhất**: 
1. Mở NetBeans
2. Mở project WEBGMS
3. Nhấn F6 (Run)
4. Chờ và truy cập `http://localhost:9999/WEBGMS/`

**Lưu ý**: Port là **9999**, không phải 8080!

---

*Tài liệu này được tạo tự động dựa trên phân tích project của bạn.*


