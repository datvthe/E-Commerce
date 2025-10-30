package controller.blog;

import dao.BlogDAO;
import model.blog.Blog;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Public Blog View Controller
 * - Xem chi tiết blog (chỉ APPROVED blogs)
 * - Tăng view count
 * - Hiển thị comments (future)
 * - Like/Unlike (future)
 */
@WebServlet("/blog/*")
public class PublicBlogViewController extends HttpServlet {
    
    private BlogDAO blogDAO = new BlogDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get slug from path: /blog/slug-here
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                // List all blogs
                response.sendRedirect(request.getContextPath() + "/blogs");
                return;
            }
            
            String slug = pathInfo.substring(1); // Remove leading /
            
            // Get blog by slug
            Blog blog = blogDAO.getBlogBySlug(slug);
            
            if (blog == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Blog không tồn tại");
                return;
            }
            
            // Increment view count
            blogDAO.incrementViewCount(blog.getBlogId());
            blog.setViewCount(blog.getViewCount() + 1);
            
            // Set attribute
            request.setAttribute("blog", blog);
            
            // Forward to JSP
            request.getRequestDispatcher("/views/common/blog-detail.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi: " + e.getMessage());
        }
    }
}

