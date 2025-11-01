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
 * Admin Blog Moderation Controller
 * - Xem danh sách blog PENDING
 * - Phê duyệt blog (APPROVED)
 * - Từ chối blog (REJECTED) với lý do
 * - Xóa blog bất kỳ
 */
@WebServlet("/admin/blog-moderation")
public class AdminBlogModerationController extends HttpServlet {
    
    private BlogDAO blogDAO = new BlogDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        // Check login and admin role
        if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
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
            
            // Filter by status (default: PENDING)
            String statusFilter = request.getParameter("status");
            if (statusFilter == null || statusFilter.isEmpty()) {
                statusFilter = "PENDING";
            }
            
            // Get blogs
            List<Blog> blogs = blogDAO.getBlogsByStatus(statusFilter, page, pageSize);
            int totalBlogs = blogDAO.countBlogsByStatus(statusFilter);
            int totalPages = (int) Math.ceil((double) totalBlogs / pageSize);
            
            // Get counts for all statuses
            int pendingCount = blogDAO.countBlogsByStatus("PENDING");
            int approvedCount = blogDAO.countBlogsByStatus("APPROVED");
            int rejectedCount = blogDAO.countBlogsByStatus("REJECTED");
            
            // Set attributes
            request.setAttribute("blogs", blogs);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalBlogs", totalBlogs);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("approvedCount", approvedCount);
            request.setAttribute("rejectedCount", rejectedCount);
            
            // Forward to JSP
            request.getRequestDispatcher("/views/admin/blog-moderation.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải danh sách blog: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/blog-moderation.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        // Check login and admin role
        if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        switch (action) {
            case "approve":
                approveBlog(request, response, user);
                break;
            case "reject":
                rejectBlog(request, response, user);
                break;
            case "delete":
                deleteBlog(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/blog-moderation");
                break;
        }
    }
    
    /**
     * Phê duyệt blog
     */
    private void approveBlog(HttpServletRequest request, HttpServletResponse response, Users user)
            throws ServletException, IOException {
        
        try {
            String blogIdStr = request.getParameter("blogId");
            if (blogIdStr == null || blogIdStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/blog-moderation?error=missing_id");
                return;
            }
            
            Long blogId = Long.parseLong(blogIdStr);
            
            // Approve blog (sử dụng stored procedure - tự động tạo notification)
            boolean success = blogDAO.approveBlog(blogId, user.getUser_id());
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/blog-moderation?success=approved");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/blog-moderation?error=approve_failed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/blog-moderation?error=" + e.getMessage());
        }
    }
    
    /**
     * Từ chối blog với lý do
     */
    private void rejectBlog(HttpServletRequest request, HttpServletResponse response, Users user)
            throws ServletException, IOException {
        
        try {
            String blogIdStr = request.getParameter("blogId");
            String reason = request.getParameter("reason");
            
            if (blogIdStr == null || blogIdStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/blog-moderation?error=missing_id");
                return;
            }
            
            if (reason == null || reason.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/blog-moderation?error=missing_reason");
                return;
            }
            
            Long blogId = Long.parseLong(blogIdStr);
            
            // Reject blog (sử dụng stored procedure - tự động tạo notification)
            boolean success = blogDAO.rejectBlog(blogId, user.getUser_id(), reason);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/blog-moderation?success=rejected");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/blog-moderation?error=reject_failed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/blog-moderation?error=" + e.getMessage());
        }
    }
    
    /**
     * Xóa blog (Admin có thể xóa bất kỳ blog nào)
     */
    private void deleteBlog(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String blogIdStr = request.getParameter("blogId");
            if (blogIdStr == null || blogIdStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/blog-moderation?error=missing_id");
                return;
            }
            
            Long blogId = Long.parseLong(blogIdStr);
            
            // Delete
            boolean success = blogDAO.deleteBlogByAdmin(blogId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/blog-moderation?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/blog-moderation?error=delete_failed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/blog-moderation?error=" + e.getMessage());
        }
    }
}

