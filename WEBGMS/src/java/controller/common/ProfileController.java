package controller.common;

import dao.UsersDAO;
import dao.WalletDAO;
import dao.SellerDAO;
import dao.ProductDAO;
import dao.OrderDAO;
import model.user.Users;
import model.seller.Seller;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import util.PasswordUtil;

@WebServlet("/profile")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
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

            // ✅ Lấy số dư ví của user
            WalletDAO walletDAO = new WalletDAO();
            double walletBalance = walletDAO.getBalance(user.getUser_id());
            request.setAttribute("walletBalance", walletBalance);

            // ✅ Lấy thống kê shop nếu user là seller
            try {
                SellerDAO sellerDAO = new SellerDAO();
                Seller seller = sellerDAO.getSellerByUserId(user.getUser_id());
                if (seller != null) {
                    // Lấy thống kê sản phẩm
                    ProductDAO productDAO = new ProductDAO();
                    int totalProducts = productDAO.getProductCountBySeller(user.getUser_id());
                    int activeProducts = productDAO.getProductCountBySellerWithStatus(user.getUser_id(), "active");
                    
                    // Lấy thống kê đơn hàng
                    OrderDAO orderDAO = new OrderDAO();
                    int totalOrders = orderDAO.getOrderCountBySeller(user.getUser_id(), null);
                    int pendingOrders = orderDAO.getOrderCountBySeller(user.getUser_id(), "pending");
                    
                    request.setAttribute("seller", seller);
                    request.setAttribute("totalProducts", totalProducts);
                    request.setAttribute("activeProducts", activeProducts);
                    request.setAttribute("totalOrders", totalOrders);
                    request.setAttribute("pendingOrders", pendingOrders);
                }
            } catch (Exception e) {
                // Nếu không phải seller hoặc có lỗi, set giá trị mặc định
                request.setAttribute("totalProducts", 0);
                request.setAttribute("activeProducts", 0);
                request.setAttribute("totalOrders", 0);
                request.setAttribute("pendingOrders", 0);
            }

            // ✅ Truyền user và số dư sang JSP
            request.setAttribute("user", user);

            // ✅ Chuyển đến trang hồ sơ
            request.getRequestDispatcher("/views/common/profile.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            if (!response.isCommitted()) {
                response.sendRedirect(request.getContextPath() + "/login?error=profile_error");
            }
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
        } else if ("update_avatar".equals(action)) {
            updateAvatar(request, response, user);
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
            String gender = request.getParameter("gender");
            String dateOfBirth = request.getParameter("date_of_birth");

            // Validate input
            if (fullName == null || fullName.trim().isEmpty()
                    || email == null || email.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/profile?error=missing_fields");
                return;
            }

            // Check if email is already used by another user
            Users existingUser = userDAO.getUserByEmail(email);
            if (existingUser != null && existingUser.getUser_id() != user.getUser_id()) {
                response.sendRedirect(request.getContextPath() + "/profile?error=email_exists");
                return;
            }

            // Handle avatar upload
            String avatarUrl = user.getAvatar_url(); // Keep existing avatar by default
            try {
                jakarta.servlet.http.Part avatarPart = request.getPart("avatar");
                if (avatarPart != null && avatarPart.getSize() > 0) {
                    // Simple avatar handling - in production, you'd want to save to file system
                    // For now, we'll just keep the existing avatar or set a default
                    avatarUrl = request.getContextPath() + "/views/assets/electro/img/avatar.jpg";
                }
            } catch (Exception e) {
                // If avatar upload fails, keep existing avatar
                System.out.println("Avatar upload error: " + e.getMessage());
            }

            // Update user information
            user.setFull_name(fullName.trim());
            user.setEmail(email.trim());
            user.setPhone_number(phone != null ? phone.trim() : null);
            user.setAddress(address != null ? address.trim() : null);
            user.setGender(gender != null && !gender.trim().isEmpty() ? gender.trim() : null);
            user.setAvatar_url(avatarUrl);

            // Handle date of birth
            if (dateOfBirth != null && !dateOfBirth.trim().isEmpty()) {
                try {
                    user.setDate_of_birth(java.sql.Date.valueOf(dateOfBirth));
                } catch (Exception e) {
                    System.out.println("Date parsing error: " + e.getMessage());
                }
            }

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

        // 🔹 Kiểm tra input trống
        if (currentPassword == null || newPassword == null || confirmPassword == null ||
            currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/profile?error=missing_fields");
            return;
        }

        // 🔹 Kiểm tra độ dài mật khẩu
        if (newPassword.length() < 8) {
            response.sendRedirect(request.getContextPath() + "/profile?error=password_too_short");
            return;
        }

        // 🔹 Kiểm tra xác nhận mật khẩu
        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect(request.getContextPath() + "/profile?error=password_mismatch");
            return;
        }

        // ✅ Lấy thông tin user hiện tại từ DB
        UsersDAO userDAO = new UsersDAO();
        Users dbUser = userDAO.getUserById(user.getUser_id());

        // ✅ Xác minh mật khẩu cũ (hash cũ)
        if (!util.PasswordUtil.verifyPassword(currentPassword, dbUser.getPassword())) {
            response.sendRedirect(request.getContextPath() + "/profile?error=wrong_current_password");
            return;
        }

        // ✅ Hash mật khẩu mới
        String newHashed = util.PasswordUtil.hashPassword(newPassword);

        // ✅ Cập nhật mật khẩu mới (đã hash)
        boolean updated = userDAO.updatePassword(user.getUser_id(), newHashed);

        if (updated) {
            // Cập nhật session để tránh lỗi mật khẩu cũ trong phiên
            dbUser.setPassword(newHashed);
            request.getSession().setAttribute("user", dbUser);

            // ✅ Redirect hiển thị toast thành công
            response.sendRedirect(request.getContextPath() + "/profile?success=password_changed");
        } else {
            // ❌ Nếu cập nhật DB thất bại
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

    private void updateAvatar(HttpServletRequest request, HttpServletResponse response, Users user)
            throws ServletException, IOException {
        try {
            Part filePart = request.getPart("avatar");
            if (filePart != null && filePart.getSize() > 0) {
                // Tạo thư mục upload
                String uploadPath = request.getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "avatars";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // Tên file (unique)
                String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String filePath = uploadPath + File.separator + fileName;

                // Ghi file lên server
                filePart.write(filePath);

                // Đường dẫn ảnh để hiển thị
                String avatarUrl = request.getContextPath() + "/uploads/avatars/" + fileName;

                // Cập nhật DB
                user.setAvatar_url(avatarUrl);
                boolean updated = userDAO.updateAvatar(user.getUser_id(), avatarUrl);

                if (updated) {
                    request.getSession().setAttribute("user", user);
                    response.sendRedirect(request.getContextPath() + "/profile?avatar_updated=true");
                    return;
                }
            }

            response.sendRedirect(request.getContextPath() + "/profile?error=avatar_failed");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/profile?error=server_error");
        }
    }

}
