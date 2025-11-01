package service;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class EmailService {
    
    // FPT Email SMTP configuration
    private static final String SMTP_HOST = "smtp.gmail.com"; // FPT sử dụng Gmail SMTP
    private static final String SMTP_PORT = "587";
    private static final String EMAIL_USERNAME = "phinhhe181076@fpt.edu.vn";
    private static final String EMAIL_PASSWORD = "ynrl urhe xndd zlkl"; // Cần App Password từ Gmail
    
    /**
     * Gửi email mã xác thực đặt lại mật khẩu
     */
    public boolean sendPasswordResetEmail(String toEmail, String verificationCode) {
        try {
            // Nội dung email
            String subject = "Mã Xác Thực Đặt Lại Mật Khẩu - Gicungco Marketplace";
            String body = buildPasswordResetEmailBody(verificationCode);
            
            return sendEmail(toEmail, subject, body);
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Gửi email xác thực đăng ký tài khoản
     */
    public boolean sendRegistrationVerificationEmail(String toEmail, String verificationCode) {
        try {
            String subject = "Xac Thuc Dang Ky Tai Khoan - Gicungco Marketplace";
            String body = buildRegistrationVerificationEmailBody(verificationCode);
            return sendEmail(toEmail, subject, body);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Gửi email sử dụng Gmail SMTP
     */
    private boolean sendEmail(String toEmail, String subject, String body) {
        try {
            // Thiết lập thuộc tính máy chủ mail
            Properties props = new Properties();
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.ssl.trust", SMTP_HOST);
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            
            // Tạo phiên với xác thực
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
                }
            });
            
            // Tạo tin nhắn
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_USERNAME, "Gicungco Marketplace"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(body, "text/html; charset=utf-8");
            
            // Gửi email
            Transport.send(message);
            return true;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Tạo nội dung HTML cho email đặt lại mật khẩu
     */
    private String buildPasswordResetEmailBody(String verificationCode) {
        return "<!DOCTYPE html>" +
               "<html>" +
               "<head>" +
               "<meta charset='UTF-8'>" +
               "<style>" +
               "body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }" +
               ".container { max-width: 600px; margin: 0 auto; padding: 20px; }" +
               ".header { background-color: #007bff; color: white; padding: 20px; text-align: center; border-radius: 5px 5px 0 0; }" +
               ".content { background-color: #f8f9fa; padding: 30px; border-radius: 0 0 5px 5px; }" +
               ".code-box { background-color: #e9ecef; border: 2px solid #007bff; border-radius: 5px; padding: 20px; text-align: center; margin: 20px 0; }" +
               ".verification-code { font-size: 32px; font-weight: bold; color: #007bff; letter-spacing: 5px; }" +
               ".warning { background-color: #fff3cd; border: 1px solid #ffeaa7; color: #856404; padding: 15px; border-radius: 5px; margin: 20px 0; }" +
               ".footer { text-align: center; margin-top: 30px; color: #6c757d; font-size: 14px; }" +
               "</style>" +
               "</head>" +
               "<body>" +
               "<div class='container'>" +
               "<div class='header'>" +
               "<h1>Gicungco Marketplace</h1>" +
               "<h2>Yêu Cầu Đặt Lại Mật Khẩu</h2>" +
               "</div>" +
               "<div class='content'>" +
               "<p>Xin chào,</p>" +
               "<p>Chúng tôi đã nhận được yêu cầu đặt lại mật khẩu cho tài khoản Gicungco Marketplace của bạn.</p>" +
               "<p>Vui lòng sử dụng mã xác thực sau để đặt lại mật khẩu:</p>" +
               "<div class='code-box'>" +
               "<div class='verification-code'>" + verificationCode + "</div>" +
               "</div>" +
               "<div class='warning'>" +
               "<strong>Quan trọng:</strong><br>" +
               "• Mã này sẽ hết hạn sau 15 phút<br>" +
               "• Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này<br>" +
               "• Không bao giờ chia sẻ mã này với bất kỳ ai" +
               "</div>" +
               "<p>Nếu bạn có bất kỳ câu hỏi nào hoặc cần hỗ trợ, vui lòng liên hệ với đội ngũ hỗ trợ của chúng tôi.</p>" +
               "<p>Trân trọng,<br>Đội ngũ Gicungco Marketplace</p>" +
               "</div>" +
               "<div class='footer'>" +
               "<p>Đây là tin nhắn tự động. Vui lòng không trả lời email này.</p>" +
               "</div>" +
               "</div>" +
               "</body>" +
               "</html>";
    }
    
    /**
     * Tạo nội dung HTML cho email xác thực đăng ký
     */
    private String buildRegistrationVerificationEmailBody(String verificationCode) {
        return "<!DOCTYPE html>" +
               "<html>" +
               "<head>" +
               "<meta charset='UTF-8'>" +
               "<style>" +
               "body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }" +
               ".container { max-width: 600px; margin: 0 auto; padding: 20px; }" +
               ".header { background: linear-gradient(135deg, #ff6b35, #f7931e); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }" +
               ".content { background-color: #f8f9fa; padding: 30px; border-radius: 0 0 10px 10px; }" +
               ".code-box { background-color: #ffffff; border: 3px solid #ff6b35; border-radius: 10px; padding: 25px; text-align: center; margin: 25px 0; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }" +
               ".verification-code { font-size: 36px; font-weight: bold; color: #ff6b35; letter-spacing: 8px; font-family: 'Courier New', monospace; }" +
               ".warning { background-color: #fff3cd; border: 1px solid #ffeaa7; color: #856404; padding: 15px; border-radius: 5px; margin: 20px 0; }" +
               ".footer { text-align: center; margin-top: 30px; color: #6c757d; font-size: 14px; }" +
               ".icon { font-size: 50px; margin-bottom: 10px; }" +
               "</style>" +
               "</head>" +
               "<body>" +
               "<div class='container'>" +
               "<div class='header'>" +
               "<h1>Chao Mung Ban Den Voi Gicungco!</h1>" +
               "<h2>Xac Thuc Email Dang Ky</h2>" +
               "</div>" +
               "<div class='content'>" +
               "<p>Xin chao,</p>" +
               "<p>Cam on ban da dang ky tai khoan tai <strong>Gicungco Marketplace</strong>!</p>" +
               "<p>De hoan tat qua trinh dang ky, vui long nhap ma xac thuc sau:</p>" +
               "<div class='code-box'>" +
               "<p style='margin: 0; font-size: 14px; color: #666;'>Ma xac thuc cua ban</p>" +
               "<div class='verification-code'>" + verificationCode + "</div>" +
               "</div>" +
               "<div class='warning'>" +
               "<strong>Quan trong:</strong><br>" +
               "- Ma nay se het han sau <strong>15 phut</strong><br>" +
               "- Khong chia se ma nay voi bat ky ai<br>" +
               "- Neu ban khong thuc hien dang ky, vui long bo qua email nay" +
               "</div>" +
               "<p>Sau khi xac thuc thanh cong, ban co the bat dau mua sam va trai nghiem cac dich vu tuyet voi cua chung toi!</p>" +
               "<p>Tran trong,<br><strong>Doi ngu Gicungco Marketplace</strong></p>" +
               "</div>" +
               "<div class='footer'>" +
               "<p>2025 Gicungco Marketplace. All rights reserved.</p>" +
               "<p>Day la tin nhan tu dong. Vui long khong tra loi email nay.</p>" +
               "</div>" +
               "</div>" +
               "</body>" +
               "</html>";
    }
    
    /**
     * Kiểm tra cấu hình email
     */
    public boolean testEmailConfiguration() {
        try {
            String testEmail = "test@example.com";
            String subject = "Email Kiểm Tra - Gicungco Marketplace";
            String body = "<h1>Email Kiểm Tra</h1><p>Đây là email kiểm tra để xác minh cấu hình email.</p>";
            
            return sendEmail(testEmail, subject, body);
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
