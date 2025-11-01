package controller.blog;

import dao.BlogDAO;
import model.blog.Blog;
import model.user.Users;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Controller quản lý blog của user
 * - Xem danh sách blog của mình
 * - Filter theo status (DRAFT, PENDING, APPROVED, REJECTED)
 * - Xóa blog (chỉ được xóa nếu không phải APPROVED)
 */
@WebServlet("/user/my-blogs")
public class UserBlogController extends HttpServlet {
    
    private BlogDAO blogDAO = new BlogDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        // Check login
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
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
            int pageSize = 10;
            
            // Filter by status
            String statusFilter = request.getParameter("status");
            
            // Get blogs
            List<Blog> blogs;
            int totalBlogs;
            
            if (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equals("ALL")) {
                // Filter by specific status
                blogs = blogDAO.getBlogsByUserId(user.getUser_id(), page, pageSize);
                // Filter in memory (hoặc tạo method mới trong DAO)
                blogs = blogs.stream()
                        .filter(b -> b.getStatus().equals(statusFilter))
                        .toList();
                totalBlogs = (int) blogDAO.getBlogsByUserId(user.getUser_id(), 1, 1000).stream()
                        .filter(b -> b.getStatus().equals(statusFilter))
                        .count();
            } else {
                // Get all blogs
                blogs = blogDAO.getBlogsByUserId(user.getUser_id(), page, pageSize);
                totalBlogs = blogDAO.countBlogsByUserId(user.getUser_id());
            }
            
            // Calculate pagination
            int totalPages = (int) Math.ceil((double) totalBlogs / pageSize);
            
            // Statistics
            List<Blog> allBlogs = blogDAO.getBlogsByUserId(user.getUser_id(), 1, 1000);
            int draftCount = (int) allBlogs.stream().filter(b -> "DRAFT".equals(b.getStatus())).count();
            int pendingCount = (int) allBlogs.stream().filter(b -> "PENDING".equals(b.getStatus())).count();
            int approvedCount = (int) allBlogs.stream().filter(b -> "APPROVED".equals(b.getStatus())).count();
            int rejectedCount = (int) allBlogs.stream().filter(b -> "REJECTED".equals(b.getStatus())).count();
            
            // Set attributes
            request.setAttribute("blogs", blogs);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalBlogs", totalBlogs);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("draftCount", draftCount);
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("approvedCount", approvedCount);
            request.setAttribute("rejectedCount", rejectedCount);
            
            // Forward to JSP
            request.getRequestDispatcher("/views/user/my-blogs.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải danh sách blog: " + e.getMessage());
            request.getRequestDispatcher("/views/user/my-blogs.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        // Check login
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("delete".equals(action)) {
            deleteBlog(request, response, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/user/my-blogs");
        }
    }
    
    /**
     * Xóa blog (chỉ được xóa nếu không phải APPROVED)
     */
    private void deleteBlog(HttpServletRequest request, HttpServletResponse response, Users user)
            throws ServletException, IOException {
        
        try {
            String blogIdStr = request.getParameter("blogId");
            if (blogIdStr == null || blogIdStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/user/my-blogs?error=missing_id");
                return;
            }
            
            Long blogId = Long.parseLong(blogIdStr);
            
            // Check ownership and status
            Blog blog = blogDAO.getBlogById(blogId);
            if (blog == null) {
                response.sendRedirect(request.getContextPath() + "/user/my-blogs?error=not_found");
                return;
            }
            
            if (blog.getUserId() != user.getUser_id()) {
                response.sendRedirect(request.getContextPath() + "/user/my-blogs?error=not_owner");
                return;
            }
            
            if ("APPROVED".equals(blog.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/user/my-blogs?error=cannot_delete_approved");
                return;
            }
            
            // Delete
            boolean success = blogDAO.deleteBlog(blogId, user.getUser_id());
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/user/my-blogs?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/user/my-blogs?error=delete_failed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/my-blogs?error=" + e.getMessage());
        }
    }
}

