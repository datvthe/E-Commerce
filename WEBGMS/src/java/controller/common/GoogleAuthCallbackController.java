package controller.common;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.GoogleAuthService;
import model.user.Users;

import java.io.IOException;

@WebServlet("/auth/google/callback")
public class GoogleAuthCallbackController extends HttpServlet {
    
    private GoogleAuthService googleAuthService = new GoogleAuthService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String code = request.getParameter("code");
        String error = request.getParameter("error");
        
        if (error != null) {
            // User denied permission or error occurred
            request.setAttribute("error", "Đăng nhập Google bị từ chối. Vui lòng thử lại.");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }
        
        if (code == null || code.isEmpty()) {
            request.setAttribute("error", "Mã xác thực không hợp lệ. Vui lòng thử lại.");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }
        
        try {
            // Process Google OAuth
            Users user = googleAuthService.processGoogleLogin(code);
            
            if (user != null) {
                // Login successful
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userRole", user.getDefault_role());
                
                // Google OAuth login successful - redirect directly
                System.out.println("Google OAuth - Login successful for: " + user.getEmail());
                
                // Redirect based on user role
                String redirectUrl = getRedirectUrlByRole(user.getDefault_role());
                response.sendRedirect(request.getContextPath() + redirectUrl);
                
            } else {
                // Login failed
                request.setAttribute("error", "Đăng nhập Google thất bại. Vui lòng thử lại.");
                request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra trong quá trình đăng nhập. Vui lòng thử lại.");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
        }
    }
    
    /**
     * Get redirect URL based on user role
     */
    private String getRedirectUrlByRole(String role) {
        switch (role) {
            case "admin":
                return "/admin/dashboard";
            case "seller":
                return "/seller/dashboard";
            case "moderator":
                return "/moderator/dashboard";
            case "customer":
            default:
                return "/home";
        }
    }
}
