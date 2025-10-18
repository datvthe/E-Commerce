package controller.common;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/about")
public class AboutController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set page title and meta description
        request.setAttribute("pageTitle", "Về Chúng Tôi - Gicungco Marketplace");
        request.setAttribute("pageDescription", "Tìm hiểu về Gicungco - Nền tảng thương mại điện tử hàng đầu Việt Nam");
        
        // Forward to about page
        request.getRequestDispatcher("/views/common/about.jsp").forward(request, response);
    }
}
