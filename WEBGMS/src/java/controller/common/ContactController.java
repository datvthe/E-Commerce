package controller.common;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/contact")
public class ContactController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set page title and meta description
        request.setAttribute("pageTitle", "Liên Hệ - Gicungco Marketplace");
        request.setAttribute("pageDescription", "Liên hệ với Gicungco - Hỗ trợ khách hàng 24/7");
        
        // Forward to contact page
        request.getRequestDispatcher("/views/common/contact.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get form data
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");
        String agree = request.getParameter("agree");
        
        // Validate form data
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            subject == null || subject.trim().isEmpty() ||
            message == null || message.trim().isEmpty() ||
            agree == null) {
            
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin và đồng ý với điều khoản sử dụng.");
            request.getRequestDispatcher("/views/common/contact.jsp").forward(request, response);
            return;
        }
        
        // Email validation
        if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            request.setAttribute("error", "Vui lòng nhập địa chỉ email hợp lệ.");
            request.getRequestDispatcher("/views/common/contact.jsp").forward(request, response);
            return;
        }
        
        try {
            // Log the contact form data
            System.out.println("Contact Form Submission:");
            System.out.println("Name: " + name);
            System.out.println("Email: " + email);
            System.out.println("Phone: " + phone);
            System.out.println("Subject: " + subject);
            System.out.println("Message: " + message);
            
            // Set success message
            request.setAttribute("success", "Cảm ơn bạn đã liên hệ! Chúng tôi sẽ phản hồi trong vòng 24 giờ.");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi gửi tin nhắn. Vui lòng thử lại sau.");
        }
        
        // Forward back to contact page with message
        request.getRequestDispatcher("/views/common/contact.jsp").forward(request, response);
    }
}
