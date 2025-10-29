package controller.order;

import dao.OrderDAO;
import dao.DigitalProductDAO;
import dao.WalletDAO;
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
import java.util.List;

/**
 * OrderSuccessController - Hiển thị mã thẻ/tài khoản sau khi mua thành công
 */
@WebServlet(name = "OrderSuccessController", urlPatterns = {"/order/success"})
public class OrderSuccessController extends HttpServlet {
    
    private final OrderDAO orderDAO = new OrderDAO();
    private final DigitalProductDAO digitalProductDAO = new DigitalProductDAO();
    private final WalletDAO walletDAO = new WalletDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        // Check login
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // 1. Lấy order ID
            String orderIdStr = request.getParameter("orderId");
            if (orderIdStr == null) {
                request.setAttribute("error", "❌ Không tìm thấy đơn hàng!");
                request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
                return;
            }
            
            long orderId = Long.parseLong(orderIdStr);
            
            // 2. Lấy order info
            Orders order = orderDAO.getOrderById(orderId);
            
            if (order == null) {
                request.setAttribute("error", "❌ Đơn hàng không tồn tại!");
                request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
                return;
            }
            
            // 3. Kiểm tra quyền truy cập (chỉ buyer mới xem được)
            if (!order.getBuyerId().equals((long) user.getUser_id())) {
                request.setAttribute("error", "❌ Bạn không có quyền xem đơn hàng này!");
                request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
                return;
            }
            
            // 4. Lấy digital products (mã thẻ/tài khoản)
            List<DigitalProduct> digitalItems = digitalProductDAO.getDigitalProductsByOrderId(orderId);
            
            // 5. Lấy số dư ví hiện tại
            double currentBalance = walletDAO.getBalance(user.getUser_id());
            
            // 6. Set attributes
            request.setAttribute("order", order);
            request.setAttribute("digitalItems", digitalItems);
            request.setAttribute("currentBalance", currentBalance);
            
            // 7. Forward to success page
            request.getRequestDispatcher("/views/user/order-success.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "❌ ID đơn hàng không hợp lệ!");
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "❌ Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
        }
    }
}

