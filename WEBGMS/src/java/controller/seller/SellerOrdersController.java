package controller.seller;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.order.Orders;
import model.order.OrderItems;
import model.user.Users;

@WebServlet(name = "SellerOrdersController", urlPatterns = {"/seller/orders", "/seller/orders/view", "/seller/orders/update-status"})
public class SellerOrdersController extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users seller = (Users) session.getAttribute("user");

        if (seller == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();

        // 🟧 Trang danh sách đơn hàng
        if ("/seller/orders".equals(path)) {
            // Lấy tham số lọc và phân trang
            String status = request.getParameter("status");
            String pageStr = request.getParameter("page");
            
            int page = 1;
            int pageSize = 10;
            
            try {
                if (pageStr != null && !pageStr.trim().isEmpty()) {
                    page = Integer.parseInt(pageStr);
                }
            } catch (NumberFormatException e) {
                // Sử dụng giá trị mặc định
            }
            
            // Lấy danh sách đơn hàng
            List<Orders> orders = orderDAO.getOrdersBySeller(seller.getUser_id(), status, page, pageSize);
            
            // Lấy tổng số đơn hàng để tính phân trang
            int totalOrders = orderDAO.getOrderCountBySeller(seller.getUser_id(), status);
            int totalPages = (int) Math.ceil((double) totalOrders / pageSize);
            
            // Lấy thống kê doanh thu
            double revenueToday = orderDAO.revenueToday(seller.getUser_id());
            double totalRevenue = orderDAO.getRevenueBySeller(seller.getUser_id(), null).doubleValue();
            
            request.setAttribute("orders", orders);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("status", status);
            request.setAttribute("revenueToday", revenueToday);
            request.setAttribute("totalRevenue", totalRevenue);
            
            // Hiển thị thông báo thành công
            String success = request.getParameter("success");
            if ("status".equals(success)) {
                request.setAttribute("success", "✅ Cập nhật trạng thái đơn hàng thành công!");
            }
            
            request.getRequestDispatcher("/views/seller/seller-orders.jsp").forward(request, response);
            return;
        }

        // 🟧 Xem chi tiết đơn hàng
        if ("/seller/orders/view".equals(path)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("id"));
                Orders order = orderDAO.getOrderById(orderId);
                
                // Kiểm tra quyền sở hữu
                if (order == null || (order.getSellerId() != null && order.getSellerId().intValue() != seller.getUser_id())) {
                    request.setAttribute("error", "❌ Đơn hàng không tồn tại hoặc bạn không có quyền xem!");
                    response.sendRedirect(request.getContextPath() + "/seller/orders");
                    return;
                }
                
                // Lấy chi tiết sản phẩm trong đơn hàng
                List<OrderItems> orderItems = orderDAO.getOrderItems(orderId);
                
                request.setAttribute("order", order);
                request.setAttribute("orderItems", orderItems);
                request.getRequestDispatcher("/views/seller/seller-order-detail.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "❌ ID đơn hàng không hợp lệ!");
                response.sendRedirect(request.getContextPath() + "/seller/orders");
            }
            return;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users seller = (Users) session.getAttribute("user");

        if (seller == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();

        // 🟧 Cập nhật trạng thái đơn hàng
        if ("/seller/orders/update-status".equals(path)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("order_id"));
                String newStatus = request.getParameter("status");
                
                // Kiểm tra quyền sở hữu
                Orders order = orderDAO.getOrderById(orderId);
                if (order == null || (order.getSellerId() != null && order.getSellerId().intValue() != seller.getUser_id())) {
                    request.setAttribute("error", "❌ Đơn hàng không tồn tại hoặc bạn không có quyền cập nhật!");
                    response.sendRedirect(request.getContextPath() + "/seller/orders");
                    return;
                }

                // Validate status transition
                String currentStatus = order.getOrderStatus();
                if (!isValidStatusTransition(currentStatus, newStatus)) {
                    request.setAttribute("error", "❌ Không thể chuyển từ trạng thái '" + currentStatus + "' sang '" + newStatus + "'!");
                    response.sendRedirect(request.getContextPath() + "/seller/orders");
                    return;
                }

                // Cập nhật trạng thái
                boolean success = orderDAO.updateOrderStatus(orderId, newStatus);
                
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/seller/orders?success=status");
                } else {
                    request.setAttribute("error", "❌ Có lỗi xảy ra khi cập nhật trạng thái đơn hàng!");
                    response.sendRedirect(request.getContextPath() + "/seller/orders");
                }

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "❌ Có lỗi xảy ra khi cập nhật trạng thái đơn hàng. Vui lòng thử lại!");
                response.sendRedirect(request.getContextPath() + "/seller/orders");
            }
        }
    }

    /**
     * Validate order status transition
     */
    private boolean isValidStatusTransition(String currentStatus, String newStatus) {
        if (currentStatus == null || newStatus == null) return false;
        
        switch (currentStatus.toLowerCase()) {
            case "pending":
                return "paid".equals(newStatus.toLowerCase()) || "cancelled".equals(newStatus.toLowerCase());
            case "paid":
                return "shipped".equals(newStatus.toLowerCase()) || "cancelled".equals(newStatus.toLowerCase());
            case "shipped":
                return "delivered".equals(newStatus.toLowerCase());
            case "delivered":
                return "refunded".equals(newStatus.toLowerCase());
            case "cancelled":
            case "refunded":
                return false; // Final states
            default:
                return false;
        }
    }
}

