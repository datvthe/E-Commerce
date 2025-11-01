package controller.order;

import dao.OrderDAO;
import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.product.Products;
import model.user.Users;

import java.io.IOException;
import java.math.BigDecimal;

/**
 * Create a PENDING order when customer clicks "Payment" (before redirecting to gateway)
 * POST /orders/create
 * params: productId, quantity
 */
@WebServlet(name = "OrderCreateController", urlPatterns = {"/orders/create"})
public class OrderCreateController extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=checkout");
            return;
        }
        try {
            long productId = Long.parseLong(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            Products product = productDAO.getProductById(productId);
            if (product == null) {
                response.sendRedirect(request.getContextPath() + "/products?error=product_not_found");
                return;
            }
            BigDecimal total = product.getPrice().multiply(BigDecimal.valueOf(quantity));
            Long orderId = orderDAO.createPendingOrder(
                    Long.valueOf(user.getUser_id()),
                    Long.valueOf(product.getSeller_id() != null ? product.getSeller_id().getUser_id() : 0),
                    productId, quantity, product.getPrice(), total, "GATEWAY"
            );
            if (orderId != null) {
                // optional: add single order item row
                try { orderDAO.addOrderItem(orderId, productId, quantity, product.getPrice()); } catch (Exception ignore) {}
                // Redirect to a fake gateway page or show order pending info
                response.sendRedirect(request.getContextPath() + "/payment/redirect?orderId=" + orderId);
            } else {
                response.sendRedirect(request.getContextPath() + "/products?error=cannot_create_order");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/products?error=invalid_data");
        }
    }
}
