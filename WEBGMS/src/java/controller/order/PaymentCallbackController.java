package controller.order;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Gateway callback simulation: marks order as PAID
 * GET/POST /payment/callback?orderId=...&txn=...&method=VNPay
 */
@WebServlet(name = "PaymentCallbackController", urlPatterns = {"/payment/callback"})
public class PaymentCallbackController extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        handle(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        handle(request, response);
    }

    private void handle(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            Long orderId = Long.valueOf(request.getParameter("orderId"));
            String txn = request.getParameter("txn");
            String method = request.getParameter("method");
            boolean ok = orderDAO.markOrderPaid(orderId, txn != null ? txn : String.valueOf(System.currentTimeMillis()), method);
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/user/orders?success=payment_success");
            } else {
                response.sendRedirect(request.getContextPath() + "/user/orders?error=update_failed");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/user/orders?error=invalid_request");
        }
    }
}
