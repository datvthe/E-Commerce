package controller.common;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.user.UserRoles;
import model.user.Users;

@WebServlet(name = "CommonLoginController", urlPatterns = {"/login"})
public class CommonLoginController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CommonLoginController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CommonLoginController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            if (request.getSession().getAttribute("user") != null) {
                request.getSession().setAttribute("message", "Đăng nhập thành công!");

                dao.UsersDAO userDAO = new dao.UsersDAO();
                Users user = (Users) request.getSession().getAttribute("user");
                UserRoles userRole = userDAO.getRoleByUserId((int) user.getUser_id());

                if (userRole != null) {
                    int roleId = userRole.getRole_id().getRole_id();
                    String path = getRedirectPathByRole(roleId);
                    response.sendRedirect(request.getContextPath() + path);
                } else {
                    response.sendRedirect(request.getContextPath() + "/home");
                }
                return;
            }

            String token = null;
            String roleCookieVal = null;

            if (request.getCookies() != null) {
                for (Cookie c : request.getCookies()) {
                    if ("remember_token".equals(c.getName())) {
                        token = c.getValue();
                    } else if ("role_id".equals(c.getName())) {
                        roleCookieVal = c.getValue();
                    }
                }
            }

            if (token != null) {
                dao.UsersDAO userDAO = new dao.UsersDAO();
                Users user = userDAO.getUserByToken(token);

                if (user != null) {
                    request.getSession().setAttribute("user", user);
                    request.getSession().setAttribute("message", "Đăng nhập thành công!");

                    if (roleCookieVal != null) {
                        int roleId = Integer.parseInt(roleCookieVal);
                        String path = getRedirectPathByRole(roleId);
                        response.sendRedirect(request.getContextPath() + path);
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

            dao.UsersDAO userDAO = new dao.UsersDAO();
            Users user = userDAO.checkLogin(account, password);

            if (user != null) {
                request.getSession().setAttribute("user", user);
                request.getSession().setAttribute("message", "Đăng nhập thành công!");

                UserRoles userRole = userDAO.getRoleByUserId((int) user.getUser_id());
                if (userRole != null) {
                    int roleId = userRole.getRole_id().getRole_id();

                    if ("on".equals(remember)) {
                        String token = UUID.randomUUID().toString();
                        Cookie cookie = new Cookie("remember_token", token);
                        cookie.setMaxAge(60 * 60 * 24 * 3); // 3 ngày
                        cookie.setPath(request.getContextPath());
                        response.addCookie(cookie);

                        Cookie roleCookie = new Cookie("role_id", String.valueOf(roleId));
                        roleCookie.setMaxAge(60 * 60 * 24 * 3); // 3 ngày
                        roleCookie.setPath(request.getContextPath());
                        response.addCookie(roleCookie);

                        userDAO.saveUserToken(user.getUser_id(), token, 3);
                    }

                    String path = getRedirectPathByRole(roleId);
                    response.sendRedirect(request.getContextPath() + path);
                    return;
                }

                response.sendRedirect(request.getContextPath() + "/home");

            } else {
                request.getSession().setAttribute("error", "Sai email/số điện thoại hoặc mật khẩu!");
                response.sendRedirect(request.getContextPath() + "/login");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Có lỗi hệ thống, vui lòng thử lại sau!");
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }

    @Override
    public String getServletInfo() {
        return "Common login controller";
    }

    private String getRedirectPathByRole(int roleId) {
        switch (roleId) {
            case 1:
                return "/admin/admin-dashboard";
            case 2:
                return "/seller/seller-dashboard";
            case 3:
                return "/home";
            case 4:
                return "/manager/manager-dashboard";
            default:
                return "/home";
        }
    }
}
