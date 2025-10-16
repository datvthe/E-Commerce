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
        
        request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
    }
}
