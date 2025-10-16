package controller.seller;

import dao.ProductDAO;
import dao.OrderDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class SellerDashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy ID người bán từ session
        Integer sellerId = (Integer) request.getSession().getAttribute("userId");

        // Nếu chưa login, tạm cho test bằng sellerId = 1
        if (sellerId == null) {
            sellerId = 1;
        }

        ProductDAO productDao = new ProductDAO();
        OrderDAO orderDao = new OrderDAO();

        int totalProducts = productDao.countBySeller(sellerId);
        int totalOrders = orderDao.countBySeller(sellerId);
        double todayRevenue = orderDao.revenueToday(sellerId);

        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("todayRevenue", todayRevenue);

        request.getRequestDispatcher("/views/seller/seller-dashboard.jsp").forward(request, response);
    }
}
