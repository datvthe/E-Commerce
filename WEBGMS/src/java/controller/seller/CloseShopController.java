package controller.seller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import dao.OrderDAO;
import dao.SellerDAO;
import model.seller.Seller;
import model.user.Users;

@WebServlet(name = "CloseShopController", urlPatterns = {"/seller/close-shop"})
public class CloseShopController extends HttpServlet {

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
            SellerDAO sellerDAO = new SellerDAO();
            OrderDAO orderDAO = new OrderDAO();

            // Lấy thông tin seller
            Seller seller = sellerDAO.getSellerWithDepositByUserId(user.getUser_id());
            if (seller == null) {
                request.setAttribute("error", "❌ Không tìm thấy thông tin seller! Vui lòng đăng ký làm seller trước.");
                request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
                return;
            }

            // Kiểm tra xem shop đã đóng chưa
            if (sellerDAO.isShopClosed(user.getUser_id())) {
                request.setAttribute("error", "❌ Shop của bạn đã được đóng rồi!");
                request.setAttribute("seller", seller);
                request.getRequestDispatcher("/views/seller/seller-close-shop.jsp").forward(request, response);
                return;
            }

            // Lấy số đơn hàng
            int totalOrders = orderDAO.getOrderCountBySeller(user.getUser_id(), null);
            int pendingOrders = orderDAO.getOrderCountBySeller(user.getUser_id(), "pending");

            // Set attributes
            request.setAttribute("seller", seller);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("pendingOrders", pendingOrders);
            request.setAttribute("user", user);

            request.getRequestDispatcher("/views/seller/seller-close-shop.jsp").forward(request, response);

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
            SellerDAO sellerDAO = new SellerDAO();
            OrderDAO orderDAO = new OrderDAO();

            // Lấy dữ liệu từ form
            String reason = request.getParameter("reason");
            String bankName = request.getParameter("bankName");
            String bankAccount = request.getParameter("bankAccount");
            String accountOwner = request.getParameter("accountOwner");

            // Validation
            if (reason == null || reason.trim().length() < 20) {
                request.setAttribute("error", "❌ Lý do đóng shop phải có ít nhất 20 ký tự!");
                loadPageData(request, user, sellerDAO, orderDAO);
                request.getRequestDispatcher("/views/seller/seller-close-shop.jsp").forward(request, response);
                return;
            }

            if (bankName == null || bankName.trim().isEmpty() ||
                bankAccount == null || bankAccount.trim().isEmpty() ||
                accountOwner == null || accountOwner.trim().isEmpty()) {
                request.setAttribute("error", "❌ Vui lòng điền đầy đủ thông tin ngân hàng để nhận hoàn tiền cọc!");
                loadPageData(request, user, sellerDAO, orderDAO);
                request.getRequestDispatcher("/views/seller/seller-close-shop.jsp").forward(request, response);
                return;
            }

            // Kiểm tra xem shop đã đóng chưa
            if (sellerDAO.isShopClosed(user.getUser_id())) {
                request.setAttribute("error", "❌ Shop của bạn đã được đóng rồi!");
                loadPageData(request, user, sellerDAO, orderDAO);
                request.getRequestDispatcher("/views/seller/seller-close-shop.jsp").forward(request, response);
                return;
            }

            // Kiểm tra đơn hàng đang chờ xử lý
            int pendingOrders = orderDAO.getOrderCountBySeller(user.getUser_id(), "pending");
            if (pendingOrders > 0) {
                request.setAttribute("error", "❌ Bạn không thể đóng shop khi còn " + pendingOrders + " đơn hàng đang chờ xử lý!");
                loadPageData(request, user, sellerDAO, orderDAO);
                request.getRequestDispatcher("/views/seller/seller-close-shop.jsp").forward(request, response);
                return;
            }

            // Cập nhật thông tin ngân hàng trước (nếu thay đổi)
            Seller seller = sellerDAO.getSellerWithDepositByUserId(user.getUser_id());
            if (seller != null) {
                seller.setBankName(bankName.trim());
                seller.setBankAccount(bankAccount.trim());
                seller.setAccountOwner(accountOwner.trim());
                sellerDAO.updateSeller(seller);
            }

            // Thực hiện đóng shop
            boolean success = sellerDAO.closeShop(user.getUser_id(), reason.trim());
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/seller/close-shop?success=closed");
            } else {
                request.setAttribute("error", "❌ Có lỗi xảy ra khi đóng shop. Vui lòng thử lại!");
                loadPageData(request, user, sellerDAO, orderDAO);
                request.getRequestDispatcher("/views/seller/seller-close-shop.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "❌ Có lỗi xảy ra: " + e.getMessage());
            try {
                SellerDAO sellerDAO = new SellerDAO();
                OrderDAO orderDAO = new OrderDAO();
                loadPageData(request, user, sellerDAO, orderDAO);
                request.getRequestDispatcher("/views/seller/seller-close-shop.jsp").forward(request, response);
            } catch (Exception ex) {
                request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
            }
        }
    }

    /**
     * Helper method to load page data
     */
    private void loadPageData(HttpServletRequest request, Users user, SellerDAO sellerDAO, OrderDAO orderDAO) {
        try {
            Seller seller = sellerDAO.getSellerWithDepositByUserId(user.getUser_id());
            int totalOrders = orderDAO.getOrderCountBySeller(user.getUser_id(), null);
            int pendingOrders = orderDAO.getOrderCountBySeller(user.getUser_id(), "pending");

            request.setAttribute("seller", seller);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("pendingOrders", pendingOrders);
            request.setAttribute("user", user);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}


