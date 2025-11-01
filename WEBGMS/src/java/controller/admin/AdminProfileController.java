package controller.admin;

import dao.UsersDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.user.Users;
import java.io.File;
import java.io.IOException;

@WebServlet(name = "AdminProfileController", urlPatterns = {"/admin/profile"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class AdminProfileController extends HttpServlet {
    private UsersDAO usersDAO;

    @Override
    public void init() throws ServletException {
        usersDAO = new UsersDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        request.setAttribute("user", user);
        request.getRequestDispatcher("/views/admin/admin-profile.jsp").forward(request, response);
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
        } else if ("update_avatar".equals(action)) {
            updateAvatar(request, response, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/profile");
        }
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response, Users user)
            throws IOException {
        try {
            String fullName = request.getParameter("full_name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");

            if (fullName == null || fullName.trim().isEmpty() ||
                email == null || email.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/profile?error=missing_fields");
                return;
            }

            // Email uniqueness (allow unchanged)
            Users existing = usersDAO.getUserByEmail(email);
            if (existing != null && existing.getUser_id() != user.getUser_id()) {
                response.sendRedirect(request.getContextPath() + "/admin/profile?error=email_exists");
                return;
            }

            user.setFull_name(fullName.trim());
            user.setEmail(email.trim());
            user.setPhone_number(phone != null ? phone.trim() : null);
            user.setAddress(address != null ? address.trim() : null);

            boolean updated = usersDAO.updateUser(user);
            if (updated) {
                request.getSession().setAttribute("user", user);
                response.sendRedirect(request.getContextPath() + "/admin/profile?updated=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/profile?error=update_failed");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/profile?error=server_error");
        }
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response, Users user)
            throws IOException {
        try {
            String currentPassword = request.getParameter("current_password");
            String newPassword = request.getParameter("new_password");
            String confirmPassword = request.getParameter("confirm_password");

            if (currentPassword == null || newPassword == null || confirmPassword == null ||
                currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/profile?error=missing_fields");
                return;
            }
            if (newPassword.length() < 8) {
                response.sendRedirect(request.getContextPath() + "/admin/profile?error=password_too_short");
                return;
            }
            if (!newPassword.equals(confirmPassword)) {
                response.sendRedirect(request.getContextPath() + "/admin/profile?error=password_mismatch");
                return;
            }

            Users dbUser = usersDAO.getUserById(user.getUser_id());
            if (!util.PasswordUtil.verifyPassword(currentPassword, dbUser.getPassword())) {
                response.sendRedirect(request.getContextPath() + "/admin/profile?error=wrong_current_password");
                return;
            }
            String hashed = util.PasswordUtil.hashPassword(newPassword);
            boolean updated = usersDAO.updatePassword(user.getUser_id(), hashed);
            if (updated) {
                dbUser.setPassword(hashed);
                request.getSession().setAttribute("user", dbUser);
                response.sendRedirect(request.getContextPath() + "/admin/profile?success=password_changed");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/profile?error=update_failed");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/profile?error=server_error");
        }
    }

    private void updateAvatar(HttpServletRequest request, HttpServletResponse response, Users user)
            throws IOException, ServletException {
        try {
            Part filePart = request.getPart("avatar");
            if (filePart != null && filePart.getSize() > 0) {
                String uploadPath = request.getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "avatars";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String filePath = uploadPath + File.separator + fileName;
                filePart.write(filePath);

                String avatarUrl = request.getContextPath() + "/uploads/avatars/" + fileName;
                user.setAvatar_url(avatarUrl);
                boolean updated = usersDAO.updateAvatar(user.getUser_id(), avatarUrl);
                if (updated) {
                    request.getSession().setAttribute("user", user);
                    response.sendRedirect(request.getContextPath() + "/admin/profile?avatar_updated=true");
                    return;
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/profile?error=avatar_failed");
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/profile?error=server_error");
        }
    }
}