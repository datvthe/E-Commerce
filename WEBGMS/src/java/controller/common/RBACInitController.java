package controller.common;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import service.RoleBasedAccessControl;
import model.user.Users;
import model.user.UserRoles;
import dao.UsersDAO;

/**
 * Servlet to initialize role-based access control in session
 */
@WebServlet(name = "RBACInitController", urlPatterns = {"/rbac-init"})
public class RBACInitController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            Users user = (Users) session.getAttribute("user");
            UsersDAO usersDAO = new UsersDAO();
            UserRoles userRole = usersDAO.getRoleByUserId((int) user.getUser_id());
            
            if (userRole != null) {
                RoleBasedAccessControl rbac = new RoleBasedAccessControl();
                session.setAttribute("rbac", rbac);
                session.setAttribute("userRole", userRole);
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/home");
    }
}

