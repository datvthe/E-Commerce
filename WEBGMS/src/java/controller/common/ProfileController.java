package controller.common;

import dao.UsersDAO;
import model.user.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

@WebServlet("/profile")
public class ProfileController extends HttpServlet {
    private UsersDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UsersDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            HttpSession session = request.getSession();
            Users user = (Users) session.getAttribute("user");
            
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            // Set user data for JSP
            request.setAttribute("user", user);
            
            // Forward to profile page
            request.getRequestDispatcher("/views/common/profile.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login?error=profile_error");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("update_profile".equals(action)) {
            updateProfile(request, response, user);
        } else if ("change_password".equals(action)) {
            changePassword(request, response, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/profile");
        }
    }
    
    private void updateProfile(HttpServletRequest request, HttpServletResponse response, Users user) 
            throws ServletException, IOException {
        
        try {
            String fullName = request.getParameter("full_name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            
            // Validate input
            if (fullName == null || fullName.trim().isEmpty() || 
                email == null || email.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/profile?error=missing_fields");
                return;
            }
            
            // Check if email is already used by another user
            Users existingUser = userDAO.getUserByEmail(email);
            if (existingUser != null && existingUser.getUser_id() != user.getUser_id()) {
                response.sendRedirect(request.getContextPath() + "/profile?error=email_exists");
                return;
            }
            
            // Update user information
            user.setFull_name(fullName.trim());
            user.setEmail(email.trim());
            user.setPhone_number(phone != null ? phone.trim() : null);
            user.setAddress(address != null ? address.trim() : null);
            
            boolean updated = userDAO.updateUser(user);
            
            if (updated) {
                // Update session
                request.getSession().setAttribute("user", user);
                response.sendRedirect(request.getContextPath() + "/profile?updated=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/profile?error=update_failed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/profile?error=server_error");
        }
    }
    
    private void changePassword(HttpServletRequest request, HttpServletResponse response, Users user) 
            throws ServletException, IOException {
        
        try {
            String currentPassword = request.getParameter("current_password");
            String newPassword = request.getParameter("new_password");
            String confirmPassword = request.getParameter("confirm_password");
            
            // Validate input
            if (currentPassword == null || currentPassword.trim().isEmpty() ||
                newPassword == null || newPassword.trim().isEmpty() ||
                confirmPassword == null || confirmPassword.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/profile?error=missing_fields");
                return;
            }
            
            if (newPassword.length() < 6) {
                response.sendRedirect(request.getContextPath() + "/profile?error=password_too_short");
                return;
            }
            
            if (!newPassword.equals(confirmPassword)) {
                response.sendRedirect(request.getContextPath() + "/profile?error=password_mismatch");
                return;
            }
            
            // Verify current password
            String hashedCurrentPassword = hashPassword(currentPassword);
            if (!hashedCurrentPassword.equals(user.getPassword())) {
                response.sendRedirect(request.getContextPath() + "/profile?error=wrong_current_password");
                return;
            }
            
            // Update password
            String hashedNewPassword = hashPassword(newPassword);
            user.setPassword(hashedNewPassword);
            
            boolean updated = userDAO.updateUser(user);
            
            if (updated) {
                // Update session
                request.getSession().setAttribute("user", user);
                response.sendRedirect(request.getContextPath() + "/profile?password_changed=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/profile?error=update_failed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/profile?error=server_error");
        }
    }
    
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes());
            StringBuilder hexString = new StringBuilder();
            
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return password; // Fallback to plain text (not recommended for production)
        }
    }
}
