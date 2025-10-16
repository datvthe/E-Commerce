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

@WebServlet("/update-profile")
public class UpdateProfileController extends HttpServlet {
    private UsersDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UsersDAO();
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
}
