/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.common;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.UUID;
import model.user.Users;

@WebServlet(name = "CommonLoginController", urlPatterns = {"/login"})
public class CommonLoginController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
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

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            if (request.getSession().getAttribute("user") != null) {
                request.getSession().setAttribute("message", "Đăng nhập thành công!");
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            String token = null;
            if (request.getCookies() != null) {
                for (Cookie c : request.getCookies()) {
                    if ("remember_token".equals(c.getName())) {
                        token = c.getValue();
                        break;
                    }
                }
            }

            if (token != null) {
                dao.UsersDAO userDAO = new dao.UsersDAO();
                Users user = userDAO.getUserByToken(token);

                if (user != null) {
                    request.getSession().setAttribute("user", user);
                    request.getSession().setAttribute("message", "Đăng nhập thành công!");
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

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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

                if ("on".equals(remember)) {
                    String token = UUID.randomUUID().toString();
                    Cookie cookie = new Cookie("remember_token", token);
                    cookie.setMaxAge(60 * 60 * 24 * 3);
                    cookie.setPath(request.getContextPath());
                    response.addCookie(cookie);

                    userDAO.saveUserToken(user.getUser_id(), token, 3);
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

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
