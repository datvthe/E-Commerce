package controller.seller;

import dao.OrderDAO;
import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import model.seller.Seller;
import model.user.Users;

@WebServlet(name = "SellerDashboardController", urlPatterns = {"/seller/dashboard"})
public class SellerDashboardController extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final ProductDAO productDAO = new ProductDAO();

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
            // Lấy thông tin seller
            Seller seller = new dao.SellerDAO().getSellerByUserId(user.getUser_id());
            if (seller == null) {
                request.setAttribute("error", "❌ Không tìm thấy thông tin seller! Vui lòng đăng ký làm seller trước.");
                request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
                return;
            }

            // Set basic attributes first
            request.setAttribute("seller", seller);
            request.setAttribute("user", user);

            // Try to get wallet balance safely
            try {
                BigDecimal walletBalance = new dao.WalletDAO().getBalanceByUserId(user.getUser_id());
                request.setAttribute("walletBalance", walletBalance != null ? walletBalance : BigDecimal.ZERO);
            } catch (Exception e) {
                request.setAttribute("walletBalance", BigDecimal.ZERO);
            }

            // Try to get product stats safely
            try {
                int totalProducts = productDAO.getProductCountBySeller(user.getUser_id());
                int activeProducts = productDAO.getProductCountBySellerWithStatus(user.getUser_id(), "active");
                request.setAttribute("totalProducts", totalProducts);
                request.setAttribute("activeProducts", activeProducts);
            } catch (Exception e) {
                request.setAttribute("totalProducts", 0);
                request.setAttribute("activeProducts", 0);
            }

            // Try to get order stats safely
            try {
                int totalOrders = orderDAO.getOrderCountBySeller(user.getUser_id(), null); // null = all statuses
                int pendingOrders = orderDAO.getOrderCountBySeller(user.getUser_id(), "pending");
                int paidOrders = orderDAO.getOrderCountBySeller(user.getUser_id(), "paid");
                request.setAttribute("totalOrders", totalOrders);
                request.setAttribute("pendingOrders", pendingOrders);
                request.setAttribute("paidOrders", paidOrders);
            } catch (Exception e) {
                request.setAttribute("totalOrders", 0);
                request.setAttribute("pendingOrders", 0);
                request.setAttribute("paidOrders", 0);
            }

            // Try to get withdraw count safely
            try {
                int withdrawCount = new dao.WalletDAO().getWithdrawCountByUserId(user.getUser_id());
                request.setAttribute("withdrawCount", withdrawCount);
            } catch (Exception e) {
                request.setAttribute("withdrawCount", 0);
            }

            request.getRequestDispatcher("/views/seller/seller-dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "❌ Có lỗi xảy ra khi tải trang chủ: " + e.getMessage());
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
        }
    }
}