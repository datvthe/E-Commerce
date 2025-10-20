package controller.common;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.PasswordResetDAO;
import service.EmailService;
import model.user.PasswordReset;

@WebServlet(name = "ForgotPasswordController", urlPatterns = {"/forgot-password"})
public class ForgotPasswordController extends HttpServlet {

    private PasswordResetDAO passwordResetDAO;
    private EmailService emailService;

    @Override
    public void init() throws ServletException {
        super.init();
        // Initialize only DAO - EmailService will be initialized when needed
        passwordResetDAO = new PasswordResetDAO();
    }
    
    private EmailService getEmailService() {
        if (emailService == null) {
            emailService = new EmailService();
        }
        return emailService;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Show forgot password form
        request.getRequestDispatcher("views/common/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("request-reset".equals(action)) {
            handlePasswordResetRequest(request, response);
        } else if ("verify-code".equals(action)) {
            handleCodeVerification(request, response);
        } else if ("reset-password".equals(action)) {
            handlePasswordReset(request, response);
        } else {
            // Invalid action
            request.getSession().setAttribute("error", "Hành động không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/forgot-password");
        }
    }

    /**
     * Handle password reset request - send verification code
     */
    private void handlePasswordResetRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String email = request.getParameter("email");
            
            if (email == null || email.trim().isEmpty()) {
                request.getSession().setAttribute("error", "Vui lòng nhập địa chỉ email của bạn!");
                response.sendRedirect(request.getContextPath() + "/forgot-password");
                return;
            }
            
            // Check if user exists
            if (!passwordResetDAO.userExistsByEmail(email)) {
                // For security, don't reveal if email exists or not
                request.getSession().setAttribute("message", 
                    "Nếu địa chỉ email tồn tại trong hệ thống, bạn sẽ nhận được mã xác thực trong thời gian ngắn.");
                response.sendRedirect(request.getContextPath() + "/forgot-password");
                return;
            }
            
            // Create password reset request
            PasswordReset passwordReset = passwordResetDAO.createPasswordResetRequest(email);
            
            if (passwordReset != null) {
                // Send verification code via email
                boolean emailSent = getEmailService().sendPasswordResetEmail(email, passwordReset.getVerification_code());
                
                if (emailSent) {
                    request.getSession().setAttribute("message", 
                        "Mã xác thực đã được gửi đến địa chỉ email của bạn. Vui lòng kiểm tra hộp thư.");
                    request.getSession().setAttribute("reset_email", email);
                    response.sendRedirect(request.getContextPath() + "/forgot-password?step=verify");
                } else {
                    request.getSession().setAttribute("error", 
                        "Không thể gửi mã xác thực. Vui lòng thử lại sau.");
                    response.sendRedirect(request.getContextPath() + "/forgot-password");
                }
            } else {
                request.getSession().setAttribute("error", 
                    "Không thể tạo yêu cầu đặt lại mật khẩu. Vui lòng thử lại.");
                response.sendRedirect(request.getContextPath() + "/forgot-password");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Đã xảy ra lỗi. Vui lòng thử lại sau.");
            response.sendRedirect(request.getContextPath() + "/forgot-password");
        }
    }

    /**
     * Handle verification code verification
     */
    private void handleCodeVerification(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String email = request.getParameter("email");
            String verificationCode = request.getParameter("verification_code");
            
            if (email == null || email.trim().isEmpty() || 
                verificationCode == null || verificationCode.trim().isEmpty()) {
                request.getSession().setAttribute("error", "Vui lòng nhập cả email và mã xác thực!");
                response.sendRedirect(request.getContextPath() + "/forgot-password?step=verify");
                return;
            }
            
            // Verify the code
            PasswordReset passwordReset = passwordResetDAO.getValidPasswordReset(email, verificationCode);
            
            if (passwordReset != null) {
                // Code is valid, proceed to password reset form
                request.getSession().setAttribute("reset_email", email);
                request.getSession().setAttribute("reset_id", passwordReset.getReset_id());
                request.getSession().setAttribute("message", "Mã xác thực hợp lệ. Vui lòng nhập mật khẩu mới của bạn.");
                response.sendRedirect(request.getContextPath() + "/forgot-password?step=reset");
            } else {
                request.getSession().setAttribute("error", 
                    "Mã xác thực không hợp lệ hoặc đã hết hạn. Vui lòng thử lại.");
                response.sendRedirect(request.getContextPath() + "/forgot-password?step=verify");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Đã xảy ra lỗi. Vui lòng thử lại sau.");
            response.sendRedirect(request.getContextPath() + "/forgot-password?step=verify");
        }
    }

    /**
     * Handle password reset
     */
    private void handlePasswordReset(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String email = request.getParameter("email");
            String newPassword = request.getParameter("new_password");
            String confirmPassword = request.getParameter("confirm_password");
            String resetIdStr = request.getParameter("reset_id");
            
            if (email == null || email.trim().isEmpty() || 
                newPassword == null || newPassword.trim().isEmpty() ||
                confirmPassword == null || confirmPassword.trim().isEmpty() ||
                resetIdStr == null || resetIdStr.trim().isEmpty()) {
                request.getSession().setAttribute("error", "Vui lòng điền đầy đủ tất cả các trường!");
                response.sendRedirect(request.getContextPath() + "/forgot-password?step=reset");
                return;
            }
            
            // Validate password confirmation
            if (!newPassword.equals(confirmPassword)) {
                request.getSession().setAttribute("error", "Mật khẩu không khớp!");
                response.sendRedirect(request.getContextPath() + "/forgot-password?step=reset");
                return;
            }
            
            // Validate password strength (basic validation)
            if (newPassword.length() < 6) {
                request.getSession().setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự!");
                response.sendRedirect(request.getContextPath() + "/forgot-password?step=reset");
                return;
            }
            
            int resetId = Integer.parseInt(resetIdStr);
            
            // Verify the reset request is still valid
            PasswordReset passwordReset = passwordResetDAO.getPasswordResetById(resetId);
            if (passwordReset == null || !email.equals(passwordReset.getEmail()) || passwordReset.isUsed()) {
                request.getSession().setAttribute("error", "Yêu cầu đặt lại không hợp lệ hoặc đã hết hạn!");
                response.sendRedirect(request.getContextPath() + "/forgot-password");
                return;
            }
            
            // Update user password (using plain text as per existing system)
            boolean passwordUpdated = passwordResetDAO.updateUserPassword(email, newPassword);
            
            if (passwordUpdated) {
                // Mark reset request as used
                passwordResetDAO.markAsUsed(resetId);
                
                // Clear session attributes
                request.getSession().removeAttribute("reset_email");
                request.getSession().removeAttribute("reset_id");
                
                request.getSession().setAttribute("message", 
                    "Mật khẩu đã được đặt lại thành công! Bạn có thể đăng nhập bằng mật khẩu mới.");
                response.sendRedirect(request.getContextPath() + "/login");
            } else {
                request.getSession().setAttribute("error", 
                    "Không thể cập nhật mật khẩu. Vui lòng thử lại.");
                response.sendRedirect(request.getContextPath() + "/forgot-password?step=reset");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Yêu cầu đặt lại không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/forgot-password");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Đã xảy ra lỗi. Vui lòng thử lại sau.");
            response.sendRedirect(request.getContextPath() + "/forgot-password?step=reset");
        }
    }

    @Override
    public String getServletInfo() {
        return "Forgot Password Controller";
    }
}
