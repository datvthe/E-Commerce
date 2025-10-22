package controller.seller;

import dao.SellerDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import model.seller.Seller;
import model.user.Users;

public class RegisterSellerController extends HttpServlet {

    // Khi người dùng truy cập bằng URL (GET)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/seller/register-seller.jsp").forward(request, response);
    }

    // Khi người dùng bấm nút Gửi form (POST)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Users user = (Users) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Seller seller = new Seller();
        seller.setUserId(user.getUser_id());
        seller.setFullName(request.getParameter("fullName"));
        seller.setEmail(request.getParameter("email"));
        seller.setPhone(request.getParameter("phone"));
        seller.setShopName(request.getParameter("shopName"));
        seller.setShopDescription(request.getParameter("shopDescription"));
        seller.setMainCategory(request.getParameter("mainCategory"));
        seller.setBankName(request.getParameter("bankName"));
        seller.setBankAccount(request.getParameter("bankAccount"));
        seller.setAccountOwner(request.getParameter("accountOwner"));
        seller.setDepositAmount(Double.parseDouble(request.getParameter("depositAmount")));
        seller.setDepositStatus("UNPAID");

        SellerDAO dao = new SellerDAO();
        boolean success = dao.registerSeller(seller);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/seller/deposit");

        } else {
            response.sendRedirect(request.getContextPath() + "/views/seller/error.jsp");
        }
    }
}
