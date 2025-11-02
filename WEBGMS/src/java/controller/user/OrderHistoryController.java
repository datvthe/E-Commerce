package controller.user;

import dao.OrderDAO;
import dao.DigitalGoodsCodeDAO;
import model.order.Orders;
import model.order.DigitalGoodsCode;
import model.user.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

/**
 * OrderHistoryController - Lịch sử đơn hàng đã mua
 * Hiển thị danh sách đơn hàng + digital products (mã thẻ, serial)
 */
@WebServlet("/user/order-history")
public class OrderHistoryController extends HttpServlet {
    
    private OrderDAO orderDAO = new OrderDAO();
    private DigitalGoodsCodeDAO digitalGoodsCodeDAO = new DigitalGoodsCodeDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        // Kiểm tra login
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Pagination
            int page = 1;
            int pageSize = 10;
            
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            
            int offset = (page - 1) * pageSize;
            
            // Lấy orders của user
            Long userId = Long.valueOf(user.getUser_id());
            List<Orders> orders = orderDAO.getOrdersByUserId(userId, pageSize, offset);
            
            // ✨ FIX: Lấy digital codes cho từng order (từ digital_goods_codes)
            Map<Long, List<DigitalGoodsCode>> orderDigitalProducts = new HashMap<>();
            for (Orders order : orders) {
                List<DigitalGoodsCode> digitalCodes = digitalGoodsCodeDAO.getCodesByOrderId(order.getOrderId());
                orderDigitalProducts.put(order.getOrderId(), digitalCodes);
                
                System.out.println("📦 Order " + order.getOrderId() + " has " + digitalCodes.size() + " codes");
            }
            
            // Đếm tổng số orders (để phân trang)
            int totalOrders = orderDAO.countOrdersByUserId(userId);
            int totalPages = (int) Math.ceil((double) totalOrders / pageSize);
            
            // Set attributes
            request.setAttribute("orders", orders);
            request.setAttribute("orderDigitalProducts", orderDigitalProducts);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalOrders", totalOrders);
            
            // Forward to JSP (simple version without header/footer)
            request.getRequestDispatcher("/views/user/order-history-simple.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải lịch sử đơn hàng: " + e.getMessage());
            request.getRequestDispatcher("/views/user/order-history.jsp").forward(request, response);
        }
    }
}

