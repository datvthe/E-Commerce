package controller.seller;

import dao.SellerDAO;
import dao.WalletDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.seller.Seller;
import model.user.Users;

@WebServlet("/seller/dashboard")
public class SellerDashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        // 🧩 Nếu chưa đăng nhập → quay về login
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        SellerDAO sellerDAO = new SellerDAO();
        WalletDAO walletDAO = new WalletDAO();

        // 🟢 Lấy seller theo user_id hiện tại
        Seller seller = sellerDAO.getSellerByUserId(user.getUser_id());

        if (seller == null) {
            // ❌ Nếu user chưa có shop → quay về trang đăng ký
            response.sendRedirect(request.getContextPath() + "/seller/register");
            return;
        }

        // ✅ Lấy số dư ví chính xác của user hiện tại
        double balance = walletDAO.getBalance(user.getUser_id());

        // Gửi dữ liệu sang JSP
        request.setAttribute("seller", seller);
        request.setAttribute("walletBalance", balance);

        // Mở trang cửa hàng
        request.getRequestDispatcher("/views/seller/seller-dashboard.jsp").forward(request, response);
    }
}
