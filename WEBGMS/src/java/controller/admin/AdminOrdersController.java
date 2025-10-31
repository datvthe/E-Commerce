package controller.admin;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import model.order.OrderItems;
import model.order.Orders;
import model.user.Users;
import model.order.DigitalProduct;
import dao.DigitalProductDAO;
import service.RoleBasedAccessControl;

@WebServlet(name = "AdminOrdersController", urlPatterns = {
        "/admin/orders",
        "/admin/orders/view",
        "/admin/orders/create",
        "/admin/orders/save",
        "/admin/orders/update-status",
        "/admin/orders/delete"
})
public class AdminOrdersController extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final DigitalProductDAO digitalProductDAO = new DigitalProductDAO();
    private final RoleBasedAccessControl rbac = new RoleBasedAccessControl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!rbac.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/home?error=access_denied");
            return;
        }

        String path = request.getServletPath();

        if ("/admin/orders".equals(path)) {
            String status = request.getParameter("status");
            int page = 1;
            int pageSize = 10;
            try {
                String pageStr = request.getParameter("page");
                if (pageStr != null && !pageStr.trim().isEmpty()) page = Integer.parseInt(pageStr);
            } catch (NumberFormatException ignored) {}

            List<Orders> orders = orderDAO.getAllOrders(status, page, pageSize);
            int totalOrders = orderDAO.getOrderCount(status);
            int totalPages = (int) Math.ceil((double) totalOrders / pageSize);

            request.setAttribute("orders", orders);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("status", status);

            // Flash messages from session (POST-redirect)
            HttpSession sess = request.getSession(false);
            if (sess != null) {
                Object fs = sess.getAttribute("flash_success");
                Object fe = sess.getAttribute("flash_error");
                if (fs != null) { request.setAttribute("success", fs); sess.removeAttribute("flash_success"); }
                if (fe != null) { request.setAttribute("error", fe); sess.removeAttribute("flash_error"); }
            }
            // Also accept query-string messages
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            if (success != null) request.setAttribute("success", success);
            if (error != null) request.setAttribute("error", error);

            request.getRequestDispatcher("/views/admin/admin-orders.jsp").forward(request, response);
            return;
        }

        if ("/admin/orders/view".equals(path)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("id"));
                Orders order = orderDAO.getOrderById(orderId);
                if (order == null) {
                    response.sendRedirect(request.getContextPath() + "/admin/orders?error=Đơn hàng không tồn tại");
                    return;
                }
                List<OrderItems> items = orderDAO.getOrderItems(orderId);
                List<DigitalProduct> digitalItems = digitalProductDAO.getDigitalProductsByOrderId((long) orderId);
                request.setAttribute("order", order);
                request.setAttribute("orderItems", items);
                request.setAttribute("digitalItems", digitalItems);
                request.getRequestDispatcher("/views/admin/admin-order-detail.jsp").forward(request, response);
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/admin/orders?error=ID đơn hàng không hợp lệ");
            }
            return;
        }

        if ("/admin/orders/create".equals(path)) {
            request.getRequestDispatcher("/views/admin/admin-order-create.jsp").forward(request, response);
            return;
        }

        // Safeguard: if someone hits update-status with GET, redirect back
        if ("/admin/orders/update-status".equals(path)) {
            String msg = URLEncoder.encode("Use POST via buttons", StandardCharsets.UTF_8.name());
            response.sendRedirect(request.getContextPath() + "/admin/orders?error=" + msg);
            return;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!rbac.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/home?error=access_denied");
            return;
        }

        String path = request.getServletPath();

        if ("/admin/orders/update-status".equals(path)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("order_id"));
                String newStatus = request.getParameter("status");
                boolean ok = orderDAO.updateOrderStatus(orderId, newStatus);
                if (ok) {
                    // Notify buyer when approved
                    try {
                        Orders order = orderDAO.getOrderById(orderId);
                        if (order != null && order.getBuyerId() != null) {
                            String title = "Đơn hàng đã được duyệt";
                            String msg = String.format("Đơn #%d đã được duyệt. Trạng thái: %s.", orderId, newStatus);
                            new service.NotificationService().sendNotificationToUser(order.getBuyerId().intValue(), title, msg, "order");
                        }
                    } catch (Exception ignore) {}
                    // Redirect admin to product management with success message
                    request.getSession().setAttribute("flash_success", "Duyệt/Cập nhật đơn #" + orderId + " thành công");
                    response.sendRedirect(request.getContextPath() + "/admin/orders");
                } else {
                    request.getSession().setAttribute("flash_error", "Có lỗi khi cập nhật trạng thái");
                    response.sendRedirect(request.getContextPath() + "/admin/orders");
                }
            } catch (Exception e) {
                request.getSession().setAttribute("flash_error", "Dữ liệu không hợp lệ");
                response.sendRedirect(request.getContextPath() + "/admin/orders");
            }
            return;
        }

        if ("/admin/orders/delete".equals(path)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("id"));
                boolean success = orderDAO.deleteOrder(orderId);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/orders?success=Đã xóa đơn hàng");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/orders?error=Không thể xóa đơn hàng");
                }
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/admin/orders?error=Dữ liệu không hợp lệ");
            }
            return;
        }

        if ("/admin/orders/save".equals(path)) {
            try {
                int buyerId = Integer.parseInt(request.getParameter("buyer_id"));
                int sellerId = Integer.parseInt(request.getParameter("seller_id"));
                BigDecimal totalAmount = new BigDecimal(request.getParameter("total_amount"));
                String currency = request.getParameter("currency");
                String shippingAddress = request.getParameter("shipping_address");
                String shippingMethod = request.getParameter("shipping_method");
                String trackingNumber = request.getParameter("tracking_number");
                String status = request.getParameter("status");

                Orders order = new Orders();
                Users buyer = new Users(); buyer.setUser_id(buyerId); order.setBuyer(buyer);
                Users seller = new Users(); seller.setUser_id(sellerId); order.setSeller(seller);
                order.setTotalAmount(totalAmount);
                order.setCurrency(currency);
                order.setShippingAddress(shippingAddress);
                order.setShippingMethod(shippingMethod);
                order.setTrackingNumber(trackingNumber);
                order.setOrderStatus(status);

                int newId = orderDAO.createOrder(order);
                if (newId > 0) {
                    response.sendRedirect(request.getContextPath() + "/admin/orders/view?id=" + newId + "&success=Tạo đơn hàng thành công");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/orders?error=Không thể tạo đơn hàng");
                }
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/admin/orders?error=Dữ liệu tạo đơn không hợp lệ");
            }
        }
    }
}