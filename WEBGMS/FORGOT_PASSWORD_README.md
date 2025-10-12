# Forgot Password Functionality

This document describes the forgot password functionality implemented for the Gicungco Marketplace System.

## Overview

The forgot password feature allows users to reset their password by receiving a verification code via email. The system follows a secure 3-step process:

1. **Request Reset**: User enters their email address
2. **Verify Code**: User enters the 6-digit verification code sent to their email
3. **Reset Password**: User sets a new password

## Features

- ✅ Email-based password reset
- ✅ 6-digit verification code generation
- ✅ 15-minute expiration for verification codes
- ✅ Secure email sending using Gmail SMTP
- ✅ Beautiful HTML email templates
- ✅ Form validation and error handling
- ✅ Responsive Bootstrap UI
- ✅ Session management for multi-step process

## Files Created/Modified

### New Files Created:

1. **Model**: `src/java/model/user/PasswordReset.java`
   - Represents password reset requests in the database

2. **DAO**: `src/java/dao/PasswordResetDAO.java`
   - Handles all database operations for password reset functionality

3. **Service**: `src/java/service/EmailService.java`
   - Handles email sending using Gmail SMTP
   - Creates beautiful HTML email templates

4. **Controller**: `src/java/controller/common/ForgotPasswordController.java`
   - Handles all HTTP requests for forgot password functionality
   - Manages the 3-step process

5. **View**: `web/views/common/forgot-password.jsp`
   - Multi-step form interface for password reset
   - Responsive Bootstrap design

6. **Database**: `password_reset_table.sql`
   - SQL script to create the Password_Reset table

### Modified Files:

1. **web.xml**: Added servlet mapping for ForgotPasswordController
2. **login.jsp**: Already has "Forgot Password?" link pointing to `/forgot-password`

## Database Schema

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

## Email Configuration

The system uses Gmail SMTP with the following configuration:
- **Email**: gicungco.marketplace@gmail.com
- **Password**: wltf drfp blty wjje (App Password)
- **SMTP Host**: smtp.gmail.com
- **SMTP Port**: 587
- **Security**: TLS/SSL enabled

## Security Features

1. **Code Expiration**: Verification codes expire after 15 minutes
2. **One-time Use**: Each verification code can only be used once
3. **Email Validation**: Only valid email addresses are accepted
4. **User Existence Check**: System checks if email exists before sending code
5. **Session Management**: Secure session handling for multi-step process
6. **Input Validation**: All inputs are validated on both client and server side

## Usage Instructions

### For Users:

1. Go to the login page
2. Click "Forgot Password?" link
3. Enter your email address
4. Check your email for the 6-digit verification code
5. Enter the verification code
6. Set your new password
7. Login with your new password

### For Developers:

1. **Setup Database**: Run the `password_reset_table.sql` script
2. **Email Configuration**: Update email credentials in `EmailService.java` if needed
3. **Deploy**: Deploy the application with all new files
4. **Test**: Test the complete flow with a valid email address

## API Endpoints

- `GET /forgot-password` - Show forgot password form
- `POST /forgot-password` with `action=request-reset` - Send verification code
- `POST /forgot-password` with `action=verify-code` - Verify code
- `POST /forgot-password` with `action=reset-password` - Reset password

## Error Handling

The system handles various error scenarios:
- Invalid email addresses
- Non-existent user accounts
- Expired verification codes
- Invalid verification codes
- Password mismatch
- Email sending failures
- Database connection issues

## Testing

To test the functionality:

1. **Setup**: Ensure database table is created and email service is configured
2. **Test Email**: Use a valid email address that exists in the Users table
3. **Test Flow**: Complete the entire 3-step process
4. **Test Security**: Try invalid codes, expired codes, etc.
5. **Test UI**: Verify responsive design on different devices

## Troubleshooting

### Common Issues:

1. **Email not received**: Check spam folder, verify email configuration
2. **Database errors**: Ensure Password_Reset table exists
3. **Code expired**: Request a new verification code
4. **Invalid code**: Double-check the 6-digit code from email

### Debug Steps:

1. Check server logs for error messages
2. Verify database connection
3. Test email configuration separately
4. Check browser console for JavaScript errors

## Future Enhancements

Potential improvements for the future:
- SMS verification as alternative to email
- Rate limiting for password reset requests
- Password strength requirements
- Account lockout after multiple failed attempts
- Audit logging for security events
- Multi-language support

## Security Considerations

- Verification codes are randomly generated 6-digit numbers
- Codes expire after 15 minutes for security
- Each code can only be used once
- Email addresses are validated before sending codes
- Session data is properly managed and cleaned up
- No sensitive information is logged

---

**Note**: This functionality is now fully integrated into the Gicungco Marketplace System and ready for use.
