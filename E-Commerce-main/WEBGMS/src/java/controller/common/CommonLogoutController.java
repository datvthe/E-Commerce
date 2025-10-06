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

            response.sendRedirect(request.getContextPath() + "/home");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}


