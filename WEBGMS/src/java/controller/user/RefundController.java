package controller.user;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.OrderDAO;
import model.order.Orders;
import model.user.Users;
import service.RefundService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * RefundController - API cho user yêu cầu hoàn tiền
 * 
 * Endpoint: POST /user/refund
 * Body: { "orderId": 123, "reason": "Sản phẩm lỗi" }
 */
@WebServlet(name = "RefundController", urlPatterns = {"/user/refund"})
public class RefundController extends HttpServlet {
    
    private final RefundService refundService = new RefundService();
    private final OrderDAO orderDAO = new OrderDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        JsonObject jsonResponse = new JsonObject();
        
        // 1. Kiểm tra login
        if (user == null) {
            jsonResponse.addProperty("status", "ERROR");
            jsonResponse.addProperty("message", "Vui lòng đăng nhập!");
            response.getWriter().write(new Gson().toJson(jsonResponse));
            return;
        }
        
        try {
            // 2. Parse request
            JsonObject requestData = new Gson().fromJson(request.getReader(), JsonObject.class);
            
            if (!requestData.has("orderId")) {
                jsonResponse.addProperty("status", "ERROR");
                jsonResponse.addProperty("message", "Thiếu orderId!");
                response.getWriter().write(new Gson().toJson(jsonResponse));
                return;
            }
            
            long orderId = requestData.get("orderId").getAsLong();
            String reason = requestData.has("reason") ? 
                           requestData.get("reason").getAsString() : 
                           "User requested refund";
            
            // 3. Kiểm tra order thuộc về user này không
            Orders order = orderDAO.getOrderById(orderId);
            
            if (order == null) {
                jsonResponse.addProperty("status", "ERROR");
                jsonResponse.addProperty("message", "Đơn hàng không tồn tại!");
                response.getWriter().write(new Gson().toJson(jsonResponse));
                return;
            }
            
            if (!order.getBuyerId().equals((long) user.getUser_id())) {
                jsonResponse.addProperty("status", "ERROR");
                jsonResponse.addProperty("message", "Bạn không có quyền thao tác đơn hàng này!");
                response.getWriter().write(new Gson().toJson(jsonResponse));
                return;
            }
            
            // 4. Kiểm tra có thể refund không
            if (!refundService.canRefund(orderId)) {
                jsonResponse.addProperty("status", "ERROR");
                jsonResponse.addProperty("message", "Đơn hàng không thể hoàn tiền!");
                jsonResponse.addProperty("currentStatus", order.getPaymentStatus());
                response.getWriter().write(new Gson().toJson(jsonResponse));
                return;
            }
            
            // 5. Process refund
            boolean success = refundService.processRefund(orderId, reason);
            
            if (success) {
                jsonResponse.addProperty("status", "SUCCESS");
                jsonResponse.addProperty("message", "Hoàn tiền thành công! Tiền đã được cộng vào ví của bạn.");
                jsonResponse.addProperty("orderId", orderId);
            } else {
                jsonResponse.addProperty("status", "ERROR");
                jsonResponse.addProperty("message", "Có lỗi xảy ra khi xử lý hoàn tiền!");
            }
            
            response.getWriter().write(new Gson().toJson(jsonResponse));
            
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("status", "ERROR");
            jsonResponse.addProperty("message", "Lỗi hệ thống: " + e.getMessage());
            response.getWriter().write(new Gson().toJson(jsonResponse));
        }
    }
    
    /**
     * GET method - Kiểm tra order có thể refund không
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        JsonObject jsonResponse = new JsonObject();
        
        if (user == null) {
            jsonResponse.addProperty("status", "ERROR");
            jsonResponse.addProperty("message", "Vui lòng đăng nhập!");
            response.getWriter().write(new Gson().toJson(jsonResponse));
            return;
        }
        
        try {
            String orderIdStr = request.getParameter("orderId");
            
            if (orderIdStr == null) {
                jsonResponse.addProperty("status", "ERROR");
                jsonResponse.addProperty("message", "Thiếu orderId!");
                response.getWriter().write(new Gson().toJson(jsonResponse));
                return;
            }
            
            long orderId = Long.parseLong(orderIdStr);
            
            // Kiểm tra ownership
            Orders order = orderDAO.getOrderById(orderId);
            
            if (order == null || !order.getBuyerId().equals((long) user.getUser_id())) {
                jsonResponse.addProperty("status", "ERROR");
                jsonResponse.addProperty("canRefund", false);
                jsonResponse.addProperty("message", "Đơn hàng không hợp lệ!");
                response.getWriter().write(new Gson().toJson(jsonResponse));
                return;
            }
            
            // Check refundable
            boolean canRefund = refundService.canRefund(orderId);
            
            jsonResponse.addProperty("status", "SUCCESS");
            jsonResponse.addProperty("canRefund", canRefund);
            jsonResponse.addProperty("currentStatus", order.getPaymentStatus());
            
            response.getWriter().write(new Gson().toJson(jsonResponse));
            
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("status", "ERROR");
            jsonResponse.addProperty("message", "Lỗi hệ thống: " + e.getMessage());
            response.getWriter().write(new Gson().toJson(jsonResponse));
        }
    }
}

