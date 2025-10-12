package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import service.RoleBasedAccessControl;
import model.user.Users;
import model.user.UserRoles;
import dao.UsersDAO;

/**
 * Role-Based Access Control Filter
 * Intercepts requests and checks user permissions based on their role
 */
@WebFilter(filterName = "RoleBasedAccessFilter", urlPatterns = {"/admin/*", "/seller/*", "/manager/*", "/customer/*"})
public class RoleBasedAccessFilter implements Filter {
    
    private RoleBasedAccessControl rbac;
    private UsersDAO usersDAO;
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        this.rbac = new RoleBasedAccessControl();
        this.usersDAO = new UsersDAO();
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            // Redirect to login for protected areas
            if (path.startsWith("/admin") || path.startsWith("/seller") || 
                path.startsWith("/manager") || path.startsWith("/customer")) {
                httpResponse.sendRedirect(contextPath + "/login?redirect=" + java.net.URLEncoder.encode(path, "UTF-8"));
                return;
            }
        } else {
            // User is logged in, check role permissions
            Users user = (Users) session.getAttribute("user");
            UserRoles userRole = usersDAO.getRoleByUserId((int) user.getUser_id());
            
            if (userRole != null) {
                int roleId = userRole.getRole_id().getRole_id();
                
                // Check admin access
                if (path.startsWith("/admin") && roleId != RoleBasedAccessControl.ROLE_ADMIN) {
                    httpResponse.sendRedirect(contextPath + "/home?error=access_denied");
                    return;
                }
                
                // Check seller access
                if (path.startsWith("/seller") && roleId != RoleBasedAccessControl.ROLE_SELLER && 
                    roleId != RoleBasedAccessControl.ROLE_ADMIN) {
                    httpResponse.sendRedirect(contextPath + "/home?error=access_denied");
                    return;
                }
                
                // Check manager access
                if (path.startsWith("/manager") && roleId != RoleBasedAccessControl.ROLE_MANAGER && 
                    roleId != RoleBasedAccessControl.ROLE_ADMIN) {
                    httpResponse.sendRedirect(contextPath + "/home?error=access_denied");
                    return;
                }
                
                // Check customer access
                if (path.startsWith("/customer") && roleId != RoleBasedAccessControl.ROLE_CUSTOMER && 
                    roleId != RoleBasedAccessControl.ROLE_ADMIN) {
                    httpResponse.sendRedirect(contextPath + "/home?error=access_denied");
                    return;
                }
            }
        }
        
        // Continue with the request
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Cleanup if needed
    }
}
