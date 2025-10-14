# Thêm Thư Viện JavaMail cho WEBGMS

## Lỗi hiện tại:
```
java.lang.NoClassDefFoundError: com/sun/mail/util/MailLogger
```

## Giải pháp: Thêm các JAR files cần thiết

### 1. Tải các thư viện cần thiết:

**Tải từ Maven Central:**
- **javax.mail.jar**: https://repo1.maven.org/maven2/com/sun/mail/javax.mail/1.6.2/javax.mail-1.6.2.jar
- **javax.activation.jar**: https://repo1.maven.org/maven2/javax/activation/activation/1.1.1/activation-1.1.1.jar

**Hoặc tải từ GitHub:**
- **javax.mail.jar**: https://github.com/javaee/javamail/releases
- **javax.activation.jar**: https://github.com/javaee/activation/releases

### 2. Cách thêm vào project:

1. **Tải 2 file JAR:**
   - `javax.mail-1.6.2.jar`
   - `activation-1.1.1.jar`

2. **Copy vào thư mục lib:**
   ```
   WEBGMS/web/WEB-INF/lib/
   ```

3. **Restart server** (Tomcat)

### 3. Kiểm tra thư mục lib hiện tại:
```
WEBGMS/web/WEB-INF/lib/
├── gson-2.10.1.jar
├── jakarta.servlet.jsp.jstl-3.0.1.jar
├── jakarta.servlet.jsp.jstl-api-2.0.0.jar
├── jakarta.servlet.jsp.jstl-api-3.0.0.jar
├── jakarta.servlet.jsp.jstl-api-3.0.1.jar
├── javax.servlet.jsp.jstl-3.0.1.jar
├── mysql-connector-j-8.3.0-javadoc.jar
├── mysql-connector-j-9.4.0/
└── [THÊM 2 FILE JAR Ở ĐÂY]
```

### 4. Sau khi thêm, thư mục sẽ có:
```
WEBGMS/web/WEB-INF/lib/
├── gson-2.10.1.jar
├── jakarta.servlet.jsp.jstl-3.0.1.jar
├── jakarta.servlet.jsp.jstl-api-2.0.0.jar
├── jakarta.servlet.jsp.jstl-api-3.0.0.jar
├── jakarta.servlet.jsp.jstl-api-3.0.1.jar
├── javax.servlet.jsp.jstl-3.0.1.jar
├── mysql-connector-j-8.3.0-javadoc.jar
├── mysql-connector-j-9.4.0/
├── javax.mail-1.6.2.jar          ← THÊM VÀO
└── activation-1.1.1.jar           ← THÊM VÀO
```

### 5. Test sau khi thêm:
1. Restart Tomcat server
2. Truy cập: `http://localhost:9999/WEBGMS/forgot-password`
3. Nhập email và test

## Lưu ý:
- Phải restart server sau khi thêm JAR
- Đảm bảo 2 file JAR được copy đúng vào `WEB-INF/lib/`
- Nếu vẫn lỗi, kiểm tra version Java (cần Java 8+)
