package controller.common;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.GoogleAuthService;
import service.RoleBasedAccessControl;
import model.user.Users;
import model.user.UserRoles;
import dao.UsersDAO;

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
                session.setAttribute("message", "Đăng nhập Google thành công!");
                
                // Get user role and initialize RBAC
                UsersDAO userDAO = new UsersDAO();
                UserRoles userRole = userDAO.getRoleByUserId((int) user.getUser_id());
                
                if (userRole != null) {
                    // Initialize RBAC in session
                    RoleBasedAccessControl rbac = new RoleBasedAccessControl();
                    session.setAttribute("rbac", rbac);
                    session.setAttribute("userRole", userRole);
                    
                    int roleId = userRole.getRole_id().getRole_id();
                    
                    // Redirect based on role ID
                    String redirectUrl = getRedirectPathByRole(roleId);
                    response.sendRedirect(request.getContextPath() + redirectUrl);
                } else {
                    // No role found, redirect to home
                    response.sendRedirect(request.getContextPath() + "/home");
                }
                
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
     * Get redirect path based on role ID
     */
    private String getRedirectPathByRole(int roleId) {
        RoleBasedAccessControl rbac = new RoleBasedAccessControl();
        return rbac.getRedirectPathByRole(roleId);
    }
}
