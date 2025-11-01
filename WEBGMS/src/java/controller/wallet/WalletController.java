package controller.wallet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import dao.UsersDAO;
import dao.WalletDAO;
import model.user.Users;
import java.util.List;
import model.wallet.Transaction;

@WebServlet("/wallet")
public class WalletController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Users user = (Users) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        WalletDAO dao = new WalletDAO();
        UsersDAO usersDAO = new UsersDAO();

        boolean isAdmin = false;
        try {
            isAdmin = "admin".equalsIgnoreCase(user.getDefault_role());
            if (!isAdmin) {
                var ur = usersDAO.getRoleByUserId(user.getUser_id());
                isAdmin = ur != null && ur.getRole_id() != null &&
                          "admin".equalsIgnoreCase(ur.getRole_id().getRole_name());
            }
        } catch (Exception ignored) {}

        double balance;
        List<Transaction> transactions;
        if (isAdmin) {
            balance = dao.getAdminGroupBalance();
            transactions = dao.getAdminGroupTransactions(20);
            request.setAttribute("isAdminGroupView", true);
        } else {
            balance = dao.getBalance(user.getUser_id());
            transactions = dao.getTransactions(user.getUser_id());
        }

        request.setAttribute("balance", balance);
        request.setAttribute("transactions", transactions);
        request.getRequestDispatcher("/views/common/wallet.jsp").forward(request, response);
    }
}

