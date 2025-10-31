package controller.order;

import dao.OrderDAO;
import dao.DigitalProductDAO;
import model.order.Orders;
import model.order.DigitalProduct;
import model.user.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * OrderDownloadController - Download order info as TXT file
 */
@WebServlet(name = "OrderDownloadController", urlPatterns = {"/order/download"})
public class OrderDownloadController extends HttpServlet {
    
    private final OrderDAO orderDAO = new OrderDAO();
    private final DigitalProductDAO digitalProductDAO = new DigitalProductDAO();
    
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
            long orderId = Long.parseLong(request.getParameter("orderId"));
            
            // Get order
            Orders order = orderDAO.getOrderById(orderId);
            
            if (order == null || !order.getBuyerId().equals((long) user.getUser_id())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }
            
            // Get digital items
            List<DigitalProduct> digitalItems = digitalProductDAO.getDigitalProductsByOrderId(orderId);
            
            // Generate TXT content
            StringBuilder content = new StringBuilder();
            content.append("=".repeat(60)).append("\n");
            content.append("       GICUNGCO - THÔNG TIN ĐƠN HÀNG\n");
            content.append("=".repeat(60)).append("\n\n");
            content.append("Mã đơn hàng: ").append(order.getOrderNumber()).append("\n");
            content.append("Ngày mua: ").append(order.getCreatedAt()).append("\n");
            content.append("Sản phẩm: ").append(order.getProduct() != null ? order.getProduct().getName() : "N/A").append("\n");
            content.append("Số lượng: ").append(digitalItems.size()).append("\n");
            content.append("Tổng tiền: ").append(order.getTotalAmount()).append("₫\n\n");
            content.append("=".repeat(60)).append("\n");
            content.append("       CHI TIẾT SẢN PHẨM\n");
            content.append("=".repeat(60)).append("\n\n");
            
            int index = 1;
            for (DigitalProduct item : digitalItems) {
                content.append("[").append(index++).append("] ").append(item.getProductName() != null ? item.getProductName() : "Sản phẩm").append("\n");
                content.append("-".repeat(60)).append("\n");
                content.append("MÃ: ").append(item.getCode()).append("\n");
                
                if (item.getSerial() != null && !item.getSerial().isEmpty()) {
                    content.append("SERIAL: ").append(item.getSerial()).append("\n");
                }
                
                if (item.getPassword() != null && !item.getPassword().isEmpty()) {
                    content.append("MẬT KHẨU: ").append(item.getPassword()).append("\n");
                }
                
                if (item.getExpiresAt() != null) {
                    content.append("HẠN SỬ DỤNG: ").append(item.getExpiresAt()).append("\n");
                }
                
                content.append("\n");
            }
            
            content.append("=".repeat(60)).append("\n");
            content.append("Cảm ơn bạn đã mua hàng tại Gicungco!\n");
            content.append("Hỗ trợ: support@gicungco.com | Hotline: 1900-xxxx\n");
            content.append("=".repeat(60)).append("\n");
            
            // Set response headers for download
            response.setContentType("text/plain; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Content-Disposition", 
                "attachment; filename=" + order.getOrderNumber() + ".txt");
            
            // Write content
            PrintWriter out = response.getWriter();
            out.write(content.toString());
            out.flush();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error generating file");
        }
    }
}

