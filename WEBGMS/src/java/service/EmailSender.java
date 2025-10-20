package service;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

/**
 * Helper class for sending emails using JavaMail API
 * This class is only loaded when JavaMail is available
 */
public class EmailSender {
    
    private final String smtpHost;
    private final String smtpPort;
    private final String username;
    private final String password;
    private final String fromEmail;
    private final String fromName;
    
    public EmailSender(String smtpHost, String smtpPort, String username, String password, String fromEmail, String fromName) {
        this.smtpHost = smtpHost;
        this.smtpPort = smtpPort;
        this.username = username;
        this.password = password;
        this.fromEmail = fromEmail;
        this.fromName = fromName;
    }
    
    public boolean sendPasswordResetEmail(String toEmail, String verificationCode) {
        try {
            // Email properties
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", smtpHost);
            props.put("mail.smtp.port", smtpPort);
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            
            // Create session
            Session session = Session.getInstance(props, new javax.mail.Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(username, password);
                }
            });
            
            // Create email message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail, fromName));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Mã Xác Thực Đặt Lại Mật Khẩu - Gicungco Marketplace");
            
            // Email content
            String emailContent = 
                "<html><body>" +
                "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;'>" +
                "<h2 style='color: #ff6600;'>Gicungco Marketplace</h2>" +
                "<h3>Yêu cầu đặt lại mật khẩu</h3>" +
                "<p>Bạn đã yêu cầu đặt lại mật khẩu cho tài khoản: <strong>" + toEmail + "</strong></p>" +
                "<div style='background-color: #f0f0f0; padding: 20px; text-align: center; margin: 20px 0;'>" +
                "<h2 style='color: #ff6600; font-size: 32px; margin: 0;'>" + verificationCode + "</h2>" +
                "<p><strong>Mã xác thực của bạn</strong></p>" +
                "</div>" +
                "<p><strong>Lưu ý:</strong></p>" +
                "<ul>" +
                "<li>Mã xác thực có hiệu lực trong 15 phút</li>" +
                "<li>Không chia sẻ mã này với ai khác</li>" +
                "<li>Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này</li>" +
                "</ul>" +
                "<hr>" +
                "<p style='color: #666; font-size: 12px;'>" +
                "Email này được gửi tự động từ hệ thống Gicungco Marketplace. Vui lòng không trả lời email này." +
                "</p>" +
                "</div>" +
                "</body></html>";
            
            message.setContent(emailContent, "text/html; charset=utf-8");
            
            // Send email
            Transport.send(message);
            
            System.out.println("Email sent successfully to: " + toEmail);
            return true;
            
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Failed to send email to: " + toEmail);
            System.err.println("Error: " + e.getMessage());
            return false;
        }
    }
}