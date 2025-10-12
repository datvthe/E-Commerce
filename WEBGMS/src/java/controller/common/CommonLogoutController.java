package controller.common;

import dao.UsersDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.user.Users;

@WebServlet(name = "LogoutController", urlPatterns = {"/logout"})
public class CommonLogoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String ajax = request.getParameter("ajax");
        
        HttpSession session = request.getSession(false);
        try {
            if (session != null) {
                Object userObj = session.getAttribute("user");
                if (userObj instanceof Users) {
                    Users user = (Users) userObj;
                    UsersDAO usersDAO = new UsersDAO();
                    usersDAO.removeUserTokens(user.getUser_id());
                }
                session.invalidate();
            }

            // clear remember cookies
            Cookie token = new Cookie("remember_token", "");
            token.setMaxAge(0);
            token.setPath(request.getContextPath());
            response.addCookie(token);

            Cookie role = new Cookie("role_id", "");
            role.setMaxAge(0);
            role.setPath(request.getContextPath());
            response.addCookie(role);

            if ("true".equals(ajax)) {
                // AJAX response
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": true, \"message\": \"Đăng xuất thành công!\"}");
            } else {
                // Regular redirect response
                request.getSession(true).setAttribute("message", "Đăng xuất thành công!");
                response.sendRedirect(request.getContextPath() + "/home");
            }
        } catch (Exception e) {
            if ("true".equals(ajax)) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": false, \"message\": \"Có lỗi xảy ra khi đăng xuất!\"}");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
        }
    }
}


