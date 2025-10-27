package controller.seller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.seller.Seller;
import model.user.Users;

@WebServlet(name = "SellerProfileController", urlPatterns = {"/seller/profile"})
public class SellerProfileController extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Lấy thông tin seller hiện tại
            Seller seller = new dao.SellerDAO().getSellerByUserId(user.getUser_id());
            if (seller == null) {
                request.setAttribute("error", "❌ Không tìm thấy thông tin seller! Vui lòng đăng ký làm seller trước.");
                request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
                return;
            }

            // Set attributes
            request.setAttribute("seller", seller);
            request.setAttribute("user", user);

            request.getRequestDispatcher("/views/seller/seller-profile.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "❌ Có lỗi xảy ra khi tải trang: " + e.getMessage());
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
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

        try {
            // Lấy dữ liệu từ form
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String shopName = request.getParameter("shopName");
            String shopDescription = request.getParameter("shopDescription");
            String mainCategory = request.getParameter("mainCategory");
            String bankName = request.getParameter("bankName");
            String bankAccount = request.getParameter("bankAccount");
            String accountOwner = request.getParameter("accountOwner");

            // Validation
            if (fullName == null || fullName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                shopName == null || shopName.trim().isEmpty()) {
                
                request.setAttribute("error", "❌ Vui lòng điền đầy đủ thông tin bắt buộc!");
                Seller seller = new dao.SellerDAO().getSellerByUserId(user.getUser_id());
                request.setAttribute("seller", seller);
                request.getRequestDispatcher("/views/seller/seller-profile.jsp").forward(request, response);
                return;
            }

            // Tạo đối tượng Seller với dữ liệu mới
            Seller seller = new dao.SellerDAO().getSellerByUserId(user.getUser_id());
            if (seller == null) {
                request.setAttribute("error", "❌ Không tìm thấy thông tin seller!");
                request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
                return;
            }

            // Cập nhật thông tin
            seller.setFullName(fullName.trim());
            seller.setEmail(email.trim());
            seller.setPhone(phone.trim());
            seller.setShopName(shopName.trim());
            seller.setShopDescription(shopDescription != null ? shopDescription.trim() : "");
            seller.setMainCategory(mainCategory != null ? mainCategory.trim() : "");
            seller.setBankName(bankName != null ? bankName.trim() : "");
            seller.setBankAccount(bankAccount != null ? bankAccount.trim() : "");
            seller.setAccountOwner(accountOwner != null ? accountOwner.trim() : "");

            // Lưu vào database
            boolean success = new dao.SellerDAO().updateSeller(seller);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/seller/profile?success=updated");
            } else {
                request.setAttribute("error", "❌ Có lỗi xảy ra khi cập nhật thông tin. Vui lòng thử lại!");
                request.setAttribute("seller", seller);
                request.getRequestDispatcher("/views/seller/seller-profile.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "❌ Có lỗi xảy ra: " + e.getMessage());
            try {
                Seller seller = new dao.SellerDAO().getSellerByUserId(user.getUser_id());
                request.setAttribute("seller", seller);
                request.getRequestDispatcher("/views/seller/seller-profile.jsp").forward(request, response);
            } catch (Exception ex) {
                request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
            }
        }
    }
}
