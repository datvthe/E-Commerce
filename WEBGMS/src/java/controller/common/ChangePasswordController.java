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
import util.PasswordUtil;

@WebServlet("/change-password")
public class ChangePasswordController extends HttpServlet {
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
            String currentPassword = request.getParameter("current_password");
            String newPassword = request.getParameter("new_password");
            String confirmPassword = request.getParameter("confirm_password");

            // 🔹 Validate input
            if (currentPassword == null || currentPassword.trim().isEmpty()
                    || newPassword == null || newPassword.trim().isEmpty()
                    || confirmPassword == null || confirmPassword.trim().isEmpty()) {
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

            // 🔹 Verify current password
            boolean currentPasswordValid = PasswordUtil.verifyPassword(currentPassword, user.getPassword());
            if (!currentPasswordValid) {
                response.sendRedirect(request.getContextPath() + "/profile?error=wrong_current_password");
                return;
            }

            // ✅ Hash new password (hash + salt)
            String hashedPassword = PasswordUtil.hashPassword(newPassword);

            // ✅ Update password in DB
            boolean updated = userDAO.updatePassword(user.getUser_id(), hashedPassword);

            if (updated) {
                // Cập nhật lại đối tượng user trong session
                user.setPassword(hashedPassword);
                session.setAttribute("user", user);
                response.sendRedirect(request.getContextPath() + "/profile?password_changed=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/profile?error=update_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/profile?error=server_error");
        }
    }
}
