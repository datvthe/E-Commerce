package controller.blog;

import dao.BlogDAO;
import model.blog.Blog;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Blog List Controller
 * - Hiển thị danh sách tất cả blog đã approved
 * - Pagination
 * - Search
 */
@WebServlet("/blogs")
public class BlogListController extends HttpServlet {
    
    private BlogDAO blogDAO = new BlogDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Pagination
            int page = 1;
            String pageStr = request.getParameter("page");
            if (pageStr != null) {
                try {
                    page = Integer.parseInt(pageStr);
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            int pageSize = 12;
            
            // Search keyword
            String keyword = request.getParameter("q");
            
            // Get blogs
            List<Blog> blogs;
            int totalBlogs;
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                // Search
                blogs = blogDAO.searchBlogs(keyword, page, pageSize);
                // For simplicity, count all approved blogs (hoặc tạo method countSearchResults)
                totalBlogs = blogDAO.countBlogsByStatus("APPROVED");
            } else {
                // Get all approved blogs
                blogs = blogDAO.getBlogsByStatus("APPROVED", page, pageSize);
                totalBlogs = blogDAO.countBlogsByStatus("APPROVED");
            }
            
            int totalPages = (int) Math.ceil((double) totalBlogs / pageSize);
            
            // Set attributes
            request.setAttribute("blogs", blogs);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalBlogs", totalBlogs);
            request.setAttribute("keyword", keyword);
            
            // Forward to JSP
            request.getRequestDispatcher("/views/common/blog-list.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải danh sách blog: " + e.getMessage());
            request.getRequestDispatcher("/views/common/blog-list.jsp").forward(request, response);
        }
    }
}

