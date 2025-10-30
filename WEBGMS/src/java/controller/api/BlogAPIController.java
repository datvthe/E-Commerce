package controller.api;

import com.google.gson.Gson;
import dao.BlogDAO;
import model.blog.Blog;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Blog API Controller
 * - Provides JSON endpoints for blog operations
 * - Used by AJAX requests (homepage, etc.)
 */
@WebServlet("/api/blogs/*")
public class BlogAPIController extends HttpServlet {
    
    private BlogDAO blogDAO = new BlogDAO();
    private Gson gson = new Gson();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String pathInfo = request.getPathInfo();
        
        try {
            if ("/latest".equals(pathInfo)) {
                // Get latest approved blogs
                getLatestBlogs(request, response);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                writeError(response, "Endpoint not found");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            writeError(response, "Server error: " + e.getMessage());
        }
    }
    
    /**
     * Get latest approved blogs
     * Query params:
     *  - limit: number of blogs (default 3)
     */
    private void getLatestBlogs(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        int limit = 3;
        String limitParam = request.getParameter("limit");
        if (limitParam != null) {
            try {
                limit = Integer.parseInt(limitParam);
                if (limit < 1) limit = 3;
                if (limit > 10) limit = 10; // Max 10
            } catch (NumberFormatException ignored) {
            }
        }
        
        // Get blogs
        List<Blog> blogs = blogDAO.getLatestApprovedBlogs(limit);
        
        // Convert to simplified DTO
        List<Map<String, Object>> blogDTOs = blogs.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
        
        // Write response
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(blogDTOs));
        out.flush();
    }
    
    /**
     * Convert Blog to DTO for JSON response
     */
    private Map<String, Object> convertToDTO(Blog blog) {
        Map<String, Object> dto = new HashMap<>();
        dto.put("blogId", blog.getBlogId());
        dto.put("title", blog.getTitle());
        dto.put("slug", blog.getSlug());
        dto.put("summary", blog.getSummary());
        dto.put("featuredImage", blog.getFeaturedImage());
        dto.put("authorName", blog.getAuthor() != null ? blog.getAuthor().getFull_name() : "");
        dto.put("viewCount", blog.getViewCount());
        dto.put("likeCount", blog.getLikeCount());
        dto.put("commentCount", blog.getCommentCount());
        dto.put("createdAt", blog.getCreatedAt() != null ? blog.getCreatedAt().getTime() : null);
        dto.put("publishedAt", blog.getPublishedAt() != null ? blog.getPublishedAt().getTime() : null);
        dto.put("readingTime", blog.getReadingTime());
        return dto;
    }
    
    /**
     * Write error response
     */
    private void writeError(HttpServletResponse response, String message) throws IOException {
        Map<String, String> error = new HashMap<>();
        error.put("error", message);
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(error));
        out.flush();
    }
}

