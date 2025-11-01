# 📧 **SỬ DỤNG LẠI CODE RESET PASSWORD CHO EMAIL VERIFICATION**

## 🎯 **STRATEGY**

Tái sử dụng infrastructure đã có sẵn từ Forgot Password:
- ✅ `PasswordResetDAO` - Generate 6-digit code
- ✅ `EmailService` - Send email  
- ✅ `password_reset` table - Store codes
- ✅ Pattern đã proven hoạt động tốt

## 🔧 **IMPLEMENTATION PLAN**

### **Option 1: Reuse `password_reset` table (EASIEST)**

Thêm column `purpose` để phân biệt:
```sql
ALTER TABLE password_reset 
ADD COLUMN purpose ENUM('password_reset', 'email_verification') DEFAULT 'password_reset';
```

**Pros:**
- ✅ Nhanh nhất
- ✅ Tái sử dụng 100% code
- ✅ Không cần tạo table mới

**Cons:**
- ⚠️ Semantic không rõ ràng

### **Option 2: Create similar table `email_verification` (RECOMMENDED)**

Tạo table riêng với cấu trúc tương tự:
```sql
CREATE TABLE email_verification (
    verification_id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL,
    verification_code CHAR(6) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL,
    used BOOLEAN DEFAULT FALSE,
    used_at TIMESTAMP NULL,
    INDEX idx_email (email),
    INDEX idx_code (verification_code),
    INDEX idx_expires (expires_at)
);
```

**Pros:**
- ✅ Semantic rõ ràng
- ✅ Dễ maintain
- ✅ Có thể có business logic khác

**Cons:**
- ⚠️ Duplicate code (nhưng có thể refactor sau)

---

## 🚀 **RECOMMENDED APPROACH (Option 2)**

### **STEP 1: Create Table**

File: `email_verification_reuse.sql`

### **STEP 2: Create DAO (Copy & Modify)**

`EmailVerificationDAO extends PasswordResetDAO`
- Copy methods từ `PasswordResetDAO`
- Đổi tên table
- Keep logic tương tự

### **STEP 3: Reuse EmailService**

Đã có sẵn:
- `EmailService.sendPasswordResetEmail()`

Tạo method mới:
- `EmailService.sendVerificationEmail()`

### **STEP 4: Update RegisterController**

```java
// After creating user
EmailVerificationDAO dao = new EmailVerificationDAO();
String code = dao.createVerificationRequest(email);
EmailService.sendVerificationEmail(email, code);

// Set status = 'pending'
// Redirect to verification page
```

### **STEP 5: Create VerifyEmailController**

Copy pattern từ `ForgotPasswordController`:
- `handleCodeVerification()`
- Verify → Activate account → Auto login

---

## 📁 **FILES TO CREATE**

1. `email_verification_reuse.sql`
2. `EmailVerificationDAO.java` (clone from PasswordResetDAO)
3. Update `EmailService.java` (add new method)
4. Update `RegisterController.java`
5. `VerifyEmailController.java` (clone from ForgotPasswordController pattern)
6. `verify-email.jsp` (clone from forgot-password verify step)

---

## ⏱️ **ESTIMATE: 30 MINUTES**

Vì đã có sẵn pattern, chỉ cần:
- Copy code
- Đổi tên
- Minor adjustments

---

## 💡 **BẠN MUỐN TÔI IMPLEMENT THEO CÁCH NÀY KHÔNG?**

Sẽ nhanh hơn nhiều vì tái sử dụng code đã có!

