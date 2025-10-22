package controller.seller;

import dao.SellerDAO;
import dao.WalletDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import model.seller.Seller;
import model.user.Users;

@WebServlet(name = "RegisterSellerController", urlPatterns = {"/seller/register"})
public class RegisterSellerController extends HttpServlet {

    private static final double REQUIRED_DEPOSIT = 200000.0;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Users user = (Users) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // ✅ Lấy số dư ví hiện tại
        WalletDAO walletDAO = new WalletDAO();
        double walletBalance = walletDAO.getBalance(user.getUser_id());
        request.setAttribute("walletBalance", walletBalance);

        // ✅ Nếu có thông báo lỗi từ doPost thì giữ lại
        String errorMessage = (String) request.getAttribute("errorMessage");
        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
        }

        request.getRequestDispatcher("/views/seller/register-seller.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        SellerDAO sellerDAO = new SellerDAO();
        Users user = (Users) request.getSession().getAttribute("user");
// ✅ Nếu user đã có shop → không cho đăng ký nữa
        if (sellerDAO.existsByUserId(user.getUser_id())) {
            request.setAttribute("errorMessage", "Bạn đã đăng ký cửa hàng rồi. Mỗi tài khoản chỉ được tạo 1 cửa hàng.");
            request.getRequestDispatcher("/views/seller/register-seller.jsp").forward(request, response);
            return;
        }


        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        WalletDAO walletDAO = new WalletDAO();
        double balance = walletDAO.getBalance(user.getUser_id());

        // ❌ Nếu không đủ số dư
        if (balance < REQUIRED_DEPOSIT) {
            request.setAttribute("errorMessage",
                    "Số dư hiện tại của bạn là " + String.format("%,.0f", balance) + "₫ — chưa đủ để đăng ký bán hàng. "
                    + "Vui lòng nạp thêm " + String.format("%,.0f", REQUIRED_DEPOSIT - balance) + "₫ để tiếp tục.");

            // Gửi lại số dư để JSP hiển thị đúng
            request.setAttribute("walletBalance", balance);
            request.getRequestDispatcher("/views/seller/register-seller.jsp").forward(request, response);
            return;
        }

        // ✅ Có đủ tiền → tạo seller
        Seller seller = new Seller();
        seller.setUserId(user.getUser_id());
        seller.setFullName(getSafeParam(request, "fullName"));
        seller.setEmail(getSafeParam(request, "email"));
        seller.setPhone(getSafeParam(request, "phone"));
        seller.setShopName(getSafeParam(request, "shopName"));
        seller.setShopDescription(getSafeParam(request, "shopDescription"));
        seller.setMainCategory(getSafeParam(request, "mainCategory"));
        seller.setBankName(getSafeParam(request, "bankName"));
        seller.setBankAccount(getSafeParam(request, "bankAccount"));
        seller.setAccountOwner(getSafeParam(request, "accountOwner"));
        seller.setDepositAmount(REQUIRED_DEPOSIT);
        seller.setDepositStatus("PAID");

        SellerDAO dao = new SellerDAO();
        boolean success = dao.registerSeller(seller);

        if (success) {
            // ✅ Trừ 200k khỏi ví
            walletDAO.deductBalance(user.getUser_id(), REQUIRED_DEPOSIT);

            // ✅ Cập nhật session
            HttpSession session = request.getSession();
            session.setAttribute("isSeller", true);
            session.setAttribute("sellerShopName", seller.getShopName());

// Cập nhật lại đối tượng user nếu cần
            Users updatedUser = user;
            updatedUser.setDefault_role("seller"); // hoặc thêm trường trạng thái nếu bạn có
            session.setAttribute("user", updatedUser);

            response.sendRedirect(request.getContextPath() + "/profile");
        } else {
            request.setAttribute("errorMessage", "Đăng ký không thành công. Vui lòng thử lại sau.");
            request.setAttribute("walletBalance", balance);
            request.getRequestDispatcher("/views/seller/register-seller.jsp").forward(request, response);
        }
    }

    private String getSafeParam(HttpServletRequest request, String name) {
        String val = request.getParameter(name);
        return (val != null) ? val.trim() : "";
    }
}
