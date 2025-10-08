package controller.common;

import dao.UsersDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.user.Users;

@WebServlet(name = "CommonRegisterController", urlPatterns = {"/register"})
public class CommonRegisterController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("views/common/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String fullName = request.getParameter("full_name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone_number");
            String password = request.getParameter("password_hash");
            String confirm = request.getParameter("confirm_password");

            if (fullName == null || fullName.isEmpty()
                    || email == null || email.isEmpty()
                    || phone == null || phone.isEmpty()
                    || password == null || password.isEmpty()
                    || confirm == null || confirm.isEmpty()) {
                request.getSession().setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
                response.sendRedirect(request.getContextPath() + "/register");
                return;
            }

            if (!password.equals(confirm)) {
                request.getSession().setAttribute("error", "Mật khẩu xác nhận không khớp!");
                response.sendRedirect(request.getContextPath() + "/register");
                return;
            }

            UsersDAO usersDAO = new UsersDAO();
            if (usersDAO.isEmailExists(email)) {
                request.getSession().setAttribute("error", "Email đã được sử dụng!");
                response.sendRedirect(request.getContextPath() + "/register");
                return;
            }
            if (usersDAO.isPhoneExists(phone)) {
                request.getSession().setAttribute("error", "Số điện thoại đã được sử dụng!");
                response.sendRedirect(request.getContextPath() + "/register");
                return;
            }

            // NOTE: For demo parity with login, passwords are stored as given.
            // In production, hash the password with a strong algorithm.
            Users created = usersDAO.createUser(fullName, email, password, phone);
            if (created == null) {
                request.getSession().setAttribute("error", "Tạo tài khoản thất bại!");
                response.sendRedirect(request.getContextPath() + "/register");
                return;
            }

            usersDAO.assignDefaultUserRole(created.getUser_id());

            // Auto login after register
            request.getSession().setAttribute("user", created);
            request.getSession().setAttribute("message", "Đăng ký thành công!");
            response.sendRedirect(request.getContextPath() + "/home");
        } catch (Exception ex) {
            ex.printStackTrace();
            request.getSession().setAttribute("error", "Có lỗi hệ thống, vui lòng thử lại sau!");
            response.sendRedirect(request.getContextPath() + "/register");
        }
    }
}


