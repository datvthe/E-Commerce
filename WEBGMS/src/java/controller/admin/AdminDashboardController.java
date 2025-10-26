package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import service.RoleBasedAccessControl;

/**
 * Admin Dashboard Controller
 */
@WebServlet(name = "AdminDashboardController", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        RoleBasedAccessControl rbac = new RoleBasedAccessControl();
        
        // Check if user has admin access
        if (!rbac.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/home?error=access_denied");
            return;
        }
        
        // Load metrics
        dao.UsersDAO usersDAO = new dao.UsersDAO();
        dao.ProductDAO productDAO = new dao.ProductDAO();
        dao.OrderDAO orderDAO = new dao.OrderDAO();
        dao.ProductCategoriesDAO cateDAO = new dao.ProductCategoriesDAO();
        
        int totalUsers = usersDAO.getTotalUsers();
        int totalProducts = productDAO.getTotalProductCount();
        int totalOrders = orderDAO.getTotalOrders();
        int ordersToday = orderDAO.getOrdersToday();
        java.math.BigDecimal revenueToday = orderDAO.getRevenueTodayAll();
        int totalCategories = cateDAO.getTotalCategories();
        
        java.util.List<model.user.Users> recentUsers = usersDAO.getRecentUsers(5);
        java.util.List<model.order.Orders> recentOrders = orderDAO.getRecentOrders(5);
        java.util.List<model.product.ProductCategories> adminCategories = cateDAO.getAllCategories(1, 10); // top 10 for dashboard
        
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("ordersToday", ordersToday);
        request.setAttribute("revenueToday", revenueToday);
        request.setAttribute("recentUsers", recentUsers);
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("totalCategories", totalCategories);
        request.setAttribute("adminCategories", adminCategories);
        
        request.getRequestDispatcher("/views/admin/admin-dashboard.jsp").forward(request, response);
    }
}
