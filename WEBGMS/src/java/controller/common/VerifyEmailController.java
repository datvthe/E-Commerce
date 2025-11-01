package controller.common;

import dao.EmailVerificationDAO;
import dao.UsersDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user.EmailVerification;
import model.user.Users;
import service.EmailService;

import java.io.IOException;

/**
 * Controller for email verification
 * Cloned from ForgotPasswordController pattern
 */
@WebServlet(name = "VerifyEmailController", urlPatterns = {"/verify-email"})
public class VerifyEmailController extends HttpServlet {

    private EmailVerificationDAO emailVerificationDAO;
    private UsersDAO usersDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        emailVerificationDAO = new EmailVerificationDAO();
        usersDAO = new UsersDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Show verification form
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("verification_email");
        
        if (email == null || email.trim().isEmpty()) {
            session.setAttribute("error", "Không tìm thấy thông tin xác thực. Vui lòng đăng ký lại!");
            response.sendRedirect(request.getContextPath() + "/register");
            return;
        }
        
        request.setAttribute("email", email);
        request.getRequestDispatcher("/views/common/verify-email.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("verify".equals(action)) {
            handleVerification(request, response);
        } else if ("resend".equals(action)) {
            handleResendCode(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/register");
        }
    }

    /**
     * Handle code verification
     */
    private void handleVerification(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String email = request.getParameter("email");
            String code = request.getParameter("code");
            
            if (email == null || code == null || code.trim().isEmpty()) {
                request.getSession().setAttribute("error", "Vui lòng nhập mã xác thực!");
                response.sendRedirect(request.getContextPath() + "/verify-email");
                return;
            }
            
            // Get valid verification
            EmailVerification verification = emailVerificationDAO.getValidEmailVerification(email, code);
            
            if (verification == null) {
                request.getSession().setAttribute("error", 
                    "Mã xác thực không đúng, đã được sử dụng, hoặc đã hết hạn. " +
                    "Nếu bạn đã nhấn 'Gửi Lại Mã', vui lòng sử dụng mã MỚI NHẤT từ email!");
                response.sendRedirect(request.getContextPath() + "/verify-email");
                return;
            }
            
            // Mark verification as used
            emailVerificationDAO.markAsUsed(verification.getVerificationId());
            
            // Get user and activate account
            Users user = usersDAO.getUserByEmail(email);
            if (user != null) {
                // Update status to 'active'
                usersDAO.updateUserStatus(user.getUser_id(), "active");
                
                // Auto login
                user.setStatus("active");
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.removeAttribute("verification_email");
                session.setAttribute("message", "✅ Xác thực thành công! Chào mừng bạn đến với Gicungco!");
                
                response.sendRedirect(request.getContextPath() + "/home");
            } else {
                request.getSession().setAttribute("error", 
                    "Không tìm thấy tài khoản. Vui lòng đăng ký lại!");
                response.sendRedirect(request.getContextPath() + "/register");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", 
                "Lỗi hệ thống khi xác thực. Vui lòng thử lại!");
            response.sendRedirect(request.getContextPath() + "/verify-email");
        }
    }

    /**
     * Handle resend verification code
     */
    private void handleResendCode(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String email = request.getParameter("email");
            
            if (email == null || email.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/register");
                return;
            }
            
            // Get user
            Users user = usersDAO.getUserByEmail(email);
            if (user == null) {
                request.getSession().setAttribute("error", "Không tìm thấy tài khoản!");
                response.sendRedirect(request.getContextPath() + "/register");
                return;
            }
            
            // Create new verification code
            EmailVerification verification = emailVerificationDAO.createEmailVerificationRequest(email);
            
            if (verification != null) {
                // Send email
                EmailService emailService = new EmailService();
                boolean emailSent = emailService.sendRegistrationVerificationEmail(
                    email,
                    verification.getVerificationCode()
                );
                
                if (emailSent) {
                    request.getSession().setAttribute("message", 
                        "✅ Mã xác thực mới đã được gửi đến email của bạn!");
                } else {
                    request.getSession().setAttribute("error", 
                        "⚠️ Không thể gửi email. Vui lòng thử lại sau!");
                }
            } else {
                request.getSession().setAttribute("error", 
                    "Không thể tạo mã xác thực mới. Vui lòng thử lại!");
            }
            
            response.sendRedirect(request.getContextPath() + "/verify-email");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", 
                "Lỗi hệ thống. Vui lòng thử lại!");
            response.sendRedirect(request.getContextPath() + "/verify-email");
        }
    }
}

