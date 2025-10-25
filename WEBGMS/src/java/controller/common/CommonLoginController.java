package controller.common;

import dao.UsersDAO;
import dao.SellerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.UUID;
import model.user.UserRoles;
import model.user.Users;
import service.RoleBasedAccessControl;

@WebServlet(name = "CommonLoginController", urlPatterns = {"/login"})
public class CommonLoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String force = request.getParameter("force");

            if ("1".equals(force) || "true".equalsIgnoreCase(force)) {
                HttpSession session = request.getSession(false);
                if (session != null) {
                    Object userObj = session.getAttribute("user");
                    if (userObj != null) {
                        Users current = (Users) userObj;
                        new UsersDAO().removeUserTokens(current.getUser_id());
                    }
                    session.invalidate();
                }

                Cookie token = new Cookie("remember_token", "");
                token.setMaxAge(0);
                token.setPath(request.getContextPath());
                response.addCookie(token);

                Cookie role = new Cookie("role_id", "");
                role.setMaxAge(0);
                role.setPath(request.getContextPath());
                response.addCookie(role);

                request.getRequestDispatcher("views/common/login.jsp").forward(request, response);
                return;
            }

            if (request.getSession().getAttribute("user") != null) {
                Users user = (Users) request.getSession().getAttribute("user");
                UserRoles ur = new UsersDAO().getRoleByUserId(user.getUser_id());
                int roleId = (ur != null && ur.getRole_id() != null)
                        ? ur.getRole_id().getRole_id()
                        : RoleBasedAccessControl.ROLE_CUSTOMER;
                response.sendRedirect(request.getContextPath() + getRedirectPathByRole(roleId));
                return;
            }

            String token = null;
            String roleCookieVal = null;

            if (request.getCookies() != null) {
                for (Cookie c : request.getCookies()) {
                    if ("remember_token".equals(c.getName())) token = c.getValue();
                    if ("role_id".equals(c.getName())) roleCookieVal = c.getValue();
                }
            }

            if (token != null) {
                Users user = new UsersDAO().getUserByToken(token);
                if (user != null) {
                    request.getSession().setAttribute("user", user);
                    request.getSession().setAttribute("message", "Đăng nhập thành công!");
                    if (roleCookieVal != null) {
                        int roleId = Integer.parseInt(roleCookieVal);
                        response.sendRedirect(request.getContextPath() + getRedirectPathByRole(roleId));
                        return;
                    }
                    response.sendRedirect(request.getContextPath() + "/home");
                    return;
                }
            }

            request.getRequestDispatcher("views/common/login.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.getRequestDispatcher("views/common/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String account = request.getParameter("account");
            String password = request.getParameter("password");
            String remember = request.getParameter("remember");

            if (account == null || account.isEmpty() || password == null || password.isEmpty()) {
                request.getSession().setAttribute("error", "Vui lòng nhập đầy đủ Email/SĐT và Mật khẩu!");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            UsersDAO userDAO = new UsersDAO();
            Users user = userDAO.checkLogin(account, password);

            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("message", "Đăng nhập thành công!");

                SellerDAO sellerDAO = new SellerDAO();
                boolean isSeller = sellerDAO.existsByUserId(user.getUser_id());
                session.setAttribute("isSeller", isSeller);

                UserRoles userRole = userDAO.getRoleByUserId(user.getUser_id());
                RoleBasedAccessControl rbac = new RoleBasedAccessControl();
                session.setAttribute("rbac", rbac);
                session.setAttribute("userRole", userRole);

                int roleId = (userRole != null && userRole.getRole_id() != null)
                        ? userRole.getRole_id().getRole_id()
                        : RoleBasedAccessControl.ROLE_CUSTOMER;

                if ("on".equalsIgnoreCase(remember) || "true".equalsIgnoreCase(remember) || "1".equals(remember)) {
                    String token = UUID.randomUUID().toString();
                    Cookie cookie = new Cookie("remember_token", token);
                    cookie.setMaxAge(60 * 60 * 24 * 3);
                    cookie.setPath(request.getContextPath());
                    response.addCookie(cookie);

                    Cookie roleCookie = new Cookie("role_id", String.valueOf(roleId));
                    roleCookie.setMaxAge(60 * 60 * 24 * 3);
                    roleCookie.setPath(request.getContextPath());
                    response.addCookie(roleCookie);

                    try {
                        userDAO.saveUserToken(user.getUser_id(), token, 3);
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                }

                response.sendRedirect(request.getContextPath() + getRedirectPathByRole(roleId));
                return;
            }

            request.getSession().setAttribute("error", "Sai email/số điện thoại hoặc mật khẩu!");
            response.sendRedirect(request.getContextPath() + "/login");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Có lỗi hệ thống, vui lòng thử lại sau!");
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }

    private String getRedirectPathByRole(int roleId) {
        RoleBasedAccessControl rbac = new RoleBasedAccessControl();
        return rbac.getRedirectPathByRole(roleId);
    }
}
