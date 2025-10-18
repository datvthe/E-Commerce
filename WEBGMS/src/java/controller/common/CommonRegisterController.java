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
            String password = request.getParameter("password");
            String confirm = request.getParameter("confirm_password");
            if (confirm == null || confirm.isEmpty()) {
                confirm = request.getParameter("confirm");
            }

            if (fullName != null) fullName = fullName.trim();
            if (email != null) email = email.trim();
            if (phone != null) phone = phone.trim();
            if (password != null) password = password.trim();
            if (confirm != null) confirm = confirm.trim();

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
            // Validate phone number format (Vietnamese phone numbers)
            if (!isValidVietnamesePhone(phone)) {
                request.getSession().setAttribute("error", "Số điện thoại không hợp lệ! Vui lòng nhập số điện thoại Việt Nam (9-10 chữ số).");
                response.sendRedirect(request.getContextPath() + "/register");
                return;
            }
            
            if (usersDAO.isPhoneExists(phone)) {
                request.getSession().setAttribute("error", "Số điện thoại đã được sử dụng!");
                response.sendRedirect(request.getContextPath() + "/register");
                return;
            }

            // Hash the password before storing
            String hashedPassword = util.PasswordUtil.hashPassword(password);
            Users created = usersDAO.createUser(fullName, email, hashedPassword, phone);
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
    
    /**
     * Validate Vietnamese phone number format
     * @param phone Phone number to validate
     * @return true if valid Vietnamese phone number
     */
    private boolean isValidVietnamesePhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }
        
        // Remove all non-digit characters
        String cleanPhone = phone.replaceAll("\\D", "");
        
        // Check length (9-10 digits)
        if (cleanPhone.length() < 9 || cleanPhone.length() > 10) {
            return false;
        }
        
        // Check if it starts with valid Vietnamese mobile prefixes
        if (cleanPhone.length() == 10) {
            // 10-digit numbers should start with 0
            if (!cleanPhone.startsWith("0")) {
                return false;
            }
            // Check valid Vietnamese mobile prefixes
            String prefix = cleanPhone.substring(0, 3);
            return prefix.equals("032") || prefix.equals("033") || prefix.equals("034") || 
                   prefix.equals("035") || prefix.equals("036") || prefix.equals("037") || 
                   prefix.equals("038") || prefix.equals("039") || prefix.equals("056") || 
                   prefix.equals("058") || prefix.equals("059") || prefix.equals("070") || 
                   prefix.equals("076") || prefix.equals("077") || prefix.equals("078") || 
                   prefix.equals("079") || prefix.equals("081") || prefix.equals("082") || 
                   prefix.equals("083") || prefix.equals("084") || prefix.equals("085") || 
                   prefix.equals("086") || prefix.equals("087") || prefix.equals("088") || 
                   prefix.equals("089") || prefix.equals("090") || prefix.equals("091") || 
                   prefix.equals("092") || prefix.equals("093") || prefix.equals("094") || 
                   prefix.equals("095") || prefix.equals("096") || prefix.equals("097") || 
                   prefix.equals("098") || prefix.equals("099");
        } else if (cleanPhone.length() == 9) {
            // 9-digit numbers (without leading 0)
            String prefix = cleanPhone.substring(0, 2);
            return prefix.equals("32") || prefix.equals("33") || prefix.equals("34") || 
                   prefix.equals("35") || prefix.equals("36") || prefix.equals("37") || 
                   prefix.equals("38") || prefix.equals("39") || prefix.equals("56") || 
                   prefix.equals("58") || prefix.equals("59") || prefix.equals("70") || 
                   prefix.equals("76") || prefix.equals("77") || prefix.equals("78") || 
                   prefix.equals("79") || prefix.equals("81") || prefix.equals("82") || 
                   prefix.equals("83") || prefix.equals("84") || prefix.equals("85") || 
                   prefix.equals("86") || prefix.equals("87") || prefix.equals("88") || 
                   prefix.equals("89") || prefix.equals("90") || prefix.equals("91") || 
                   prefix.equals("92") || prefix.equals("93") || prefix.equals("94") || 
                   prefix.equals("95") || prefix.equals("96") || prefix.equals("97") || 
                   prefix.equals("98") || prefix.equals("99");
        }
        
        return false;
    }
    
}

