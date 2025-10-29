package controller.user;

import dao.WalletDAO;
import model.wallet.Transaction;
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
 * PaymentHistoryController - Lịch sử giao dịch ví
 * Hiển thị lịch sử nạp/trừ tiền
 */
@WebServlet("/user/payment-history")
public class PaymentHistoryController extends HttpServlet {
    
    private WalletDAO walletDAO = new WalletDAO();
    
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
            // Lấy lịch sử giao dịch
            int userId = user.getUser_id();
            List<Transaction> transactions = walletDAO.getTransactions(userId);
            
            // Lấy số dư hiện tại
            double currentBalance = walletDAO.getBalance(userId);
            
            // Set attributes
            request.setAttribute("transactions", transactions);
            request.setAttribute("currentBalance", currentBalance);
            
            // Forward to JSP (simple version without header/footer)
            request.getRequestDispatcher("/views/user/payment-history-simple.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải lịch sử giao dịch: " + e.getMessage());
            request.getRequestDispatcher("/views/user/payment-history.jsp").forward(request, response);
        }
    }
}

