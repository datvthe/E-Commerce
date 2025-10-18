package service;

public class EmailService {
    
    /**
     * Gửi email mã xác thực đặt lại mật khẩu (Mock implementation)
     */
    public boolean sendPasswordResetEmail(String toEmail, String verificationCode) {
        try {
            // Mock implementation - chỉ in ra console
            System.out.println("=== EMAIL SERVICE (MOCK) ===");
            System.out.println("To: " + toEmail);
            System.out.println("Subject: Mã Xác Thực Đặt Lại Mật Khẩu - Gicungco Marketplace");
            System.out.println("Verification Code: " + verificationCode);
            System.out.println("=== END EMAIL ===");
            
            // Simulate email sending
            return true;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Kiểm tra cấu hình email (Mock)
     */
    public boolean testEmailConfiguration() {
        System.out.println("=== EMAIL CONFIGURATION TEST (MOCK) ===");
        System.out.println("Email service is working (mock mode)");
        System.out.println("=== END TEST ===");
        return true;
    }
}