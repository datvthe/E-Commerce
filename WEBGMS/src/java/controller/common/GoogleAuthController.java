package controller.common;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.GoogleAuthService;

import java.io.IOException;

@WebServlet("/auth/google")
public class GoogleAuthController extends HttpServlet {
    
    private GoogleAuthService googleAuthService = new GoogleAuthService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("login".equals(action)) {
            // Redirect to Google OAuth
            String googleAuthUrl = googleAuthService.getGoogleAuthUrl();
            if (googleAuthUrl != null) {
                response.sendRedirect(googleAuthUrl);
            } else {
                request.setAttribute("error", "Không thể kết nối với Google. Vui lòng thử lại sau.");
                request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            }
        } else {
            // Default action - redirect to login
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
}
