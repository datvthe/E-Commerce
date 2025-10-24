# 📧 Email Setup Guide - Gicungco Marketplace

## 🎯 Overview
This guide will help you configure real email sending for password reset functionality using Gmail SMTP.

## 📋 Prerequisites
- Gmail account
- App-specific password (required for Gmail)
- JavaMail dependencies (already included in your project)

## 🔧 Step 1: Setup Gmail App Password

### 1.1 Enable 2-Factor Authentication
1. Go to [Google Account Settings](https://myaccount.google.com/)
2. Click **Security** → **2-Step Verification**
3. Follow the setup process

### 1.2 Generate App Password
1. Go to [Google Account Settings](https://myaccount.google.com/)
2. Click **Security** → **2-Step Verification** → **App passwords**
3. Select **Other (Custom name)**
4. Enter name: `Gicungco Marketplace`
5. Click **Generate**
6. **Copy the 16-character password** (you'll need this)

## ⚙️ Step 2: Configure EmailService.java

Edit the file: `WEBGMS/src/java/service/EmailService.java`

Replace these lines (around line 12-14):
```java
private static final String EMAIL_USERNAME = "your-email@gmail.com"; // Change this
private static final String EMAIL_PASSWORD = "your-app-password";    // Change this
private static final String FROM_EMAIL = "your-email@gmail.com";     // Change this
```

With your actual Gmail credentials:
```java
private static final String EMAIL_USERNAME = "youremail@gmail.com";     // Your Gmail
private static final String EMAIL_PASSWORD = "abcd efgh ijkl mnop";     // App Password
private static final String FROM_EMAIL = "youremail@gmail.com";         // Your Gmail
```

## 🧪 Step 3: Test Email Configuration

### 3.1 Create Test Servlet (Optional)
Create `TestEmailController.java` to test email functionality:

```java
@WebServlet("/test-email")
public class TestEmailController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        EmailService emailService = new EmailService();
        
        // Test configuration
        boolean configTest = emailService.testEmailConfiguration();
        
        // Test sending email
        boolean emailTest = emailService.sendPasswordResetEmail("your-test-email@gmail.com", "123456");
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<h2>Email Test Results</h2>");
        out.println("<p>Configuration Test: " + (configTest ? "✅ PASSED" : "❌ FAILED") + "</p>");
        out.println("<p>Email Send Test: " + (emailTest ? "✅ PASSED" : "❌ FAILED") + "</p>");
    }
}
```

### 3.2 Test Password Reset Flow
1. Go to: `http://localhost:9999/WEBGMS/forgot-password`
2. Enter your email address
3. Check your email inbox for the verification code
4. Enter the code to complete password reset

## 🔍 Step 4: Troubleshooting

### Common Issues & Solutions

#### ❌ "Authentication failed"
- **Solution**: Make sure you're using the **App Password**, not your regular Gmail password
- **Check**: 2-Factor Authentication is enabled

#### ❌ "Connection timeout"
- **Solution**: Check firewall/antivirus settings
- **Try**: Different SMTP port (465 for SSL)

#### ❌ "Less secure app access"
- **Solution**: Use App Password instead (recommended)
- **Alternative**: Enable "Less secure app access" (not recommended)

#### ❌ "Username and Password not accepted"
- **Check**: Email username is complete (including @gmail.com)
- **Verify**: App password is copied correctly (16 characters, no spaces)

## 🚀 Step 5: Alternative Email Providers

### If you don't want to use Gmail:

#### Outlook/Hotmail:
```java
private static final String SMTP_HOST = "smtp-mail.outlook.com";
private static final String SMTP_PORT = "587";
```

#### Yahoo Mail:
```java
private static final String SMTP_HOST = "smtp.mail.yahoo.com";
private static final String SMTP_PORT = "587";
```

#### Custom SMTP:
```java
private static final String SMTP_HOST = "your-smtp-server.com";
private static final String SMTP_PORT = "587"; // or 25, 465
```

## ✅ Step 6: Security Notes

1. **Never commit credentials** to version control
2. **Use environment variables** for production:
   ```java
   private static final String EMAIL_USERNAME = System.getenv("EMAIL_USERNAME");
   private static final String EMAIL_PASSWORD = System.getenv("EMAIL_PASSWORD");
   ```
3. **Rotate app passwords** regularly
4. **Use separate email account** for application sending

## 📞 Support

If you encounter issues:
1. Check server console logs for detailed error messages
2. Test with `testEmailConfiguration()` method
3. Verify Gmail settings are correct
4. Check network connectivity

---

**✨ Once configured, users will receive beautifully formatted HTML emails with their password reset codes!**