package controller.blog;

import com.google.gson.Gson;
import dao.BlogCommentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user.Users;
import model.blog.BlogComment;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Controller for Blog Comments
 */
@WebServlet(name = "BlogCommentController", urlPatterns = {"/api/blog/comments/*"})
public class BlogCommentController extends HttpServlet {
    
    private BlogCommentDAO commentDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        commentDAO = new BlogCommentDAO();
        gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Get comments for a blog
                String blogIdStr = request.getParameter("blogId");
                if (blogIdStr == null) {
                    sendError(response, "Missing blogId parameter");
                    return;
                }
                
                Long blogId = Long.parseLong(blogIdStr);
                List<BlogComment> comments = commentDAO.getParentComments(blogId);
                
                Map<String, Object> result = new HashMap<>();
                result.put("success", true);
                result.put("comments", comments);
                out.print(gson.toJson(result));
                
            } else if (pathInfo.startsWith("/replies/")) {
                // Get replies for a comment
                String commentIdStr = pathInfo.substring("/replies/".length());
                Long commentId = Long.parseLong(commentIdStr);
                
                List<BlogComment> replies = commentDAO.getReplies(commentId);
                
                Map<String, Object> result = new HashMap<>();
                result.put("success", true);
                result.put("replies", replies);
                out.print(gson.toJson(result));
                
            } else {
                sendError(response, "Invalid endpoint");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            sendError(response, "Database error: " + e.getMessage());
        } catch (NumberFormatException e) {
            sendError(response, "Invalid ID format");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        
        // Check login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            sendError(response, "Please login to comment");
            return;
        }
        
        Users user = (Users) session.getAttribute("user");
        
        try {
            // Parse request body
            BlogComment comment = gson.fromJson(request.getReader(), BlogComment.class);
            
            // Validate
            if (comment.getBlogId() == null || comment.getContent() == null || comment.getContent().trim().isEmpty()) {
                sendError(response, "Missing required fields");
                return;
            }
            
            // Set user ID (cast to Long)
            comment.setUserId(Long.valueOf(user.getUser_id()));
            
            // Add comment
            BlogComment savedComment = commentDAO.addComment(comment);
            
            // Get full comment with user info
            savedComment = commentDAO.getCommentById(savedComment.getCommentId());
            
            // Send response
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("comment", savedComment);
            result.put("message", "Comment added successfully");
            
            response.getWriter().print(gson.toJson(result));
            
        } catch (SQLException e) {
            e.printStackTrace();
            sendError(response, "Database error: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            sendError(response, "Error: " + e.getMessage());
        }
    }
    
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        
        // Check login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            sendError(response, "Please login");
            return;
        }
        
        Users user = (Users) session.getAttribute("user");
        
        try {
            // Parse request
            Map<String, Object> requestData = gson.fromJson(request.getReader(), Map.class);
            
            Long commentId = ((Double) requestData.get("commentId")).longValue();
            String content = (String) requestData.get("content");
            
            if (content == null || content.trim().isEmpty()) {
                sendError(response, "Content cannot be empty");
                return;
            }
            
            // Get comment to check ownership
            BlogComment comment = commentDAO.getCommentById(commentId);
            if (comment == null) {
                sendError(response, "Comment not found");
                return;
            }
            
            if (!comment.getUserId().equals(Long.valueOf(user.getUser_id()))) {
                sendError(response, "You can only edit your own comments");
                return;
            }
            
            // Update
            boolean success = commentDAO.updateComment(commentId, content);
            
            Map<String, Object> result = new HashMap<>();
            result.put("success", success);
            result.put("message", success ? "Comment updated" : "Update failed");
            
            response.getWriter().print(gson.toJson(result));
            
        } catch (SQLException e) {
            e.printStackTrace();
            sendError(response, "Database error: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            sendError(response, "Error: " + e.getMessage());
        }
    }
    
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        
        // Check login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            sendError(response, "Please login");
            return;
        }
        
        Users user = (Users) session.getAttribute("user");
        
        try {
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.length() <= 1) {
                sendError(response, "Missing comment ID");
                return;
            }
            
            Long commentId = Long.parseLong(pathInfo.substring(1));
            
            // Get comment to check ownership
            BlogComment comment = commentDAO.getCommentById(commentId);
            if (comment == null) {
                sendError(response, "Comment not found");
                return;
            }
            
            if (!comment.getUserId().equals(Long.valueOf(user.getUser_id()))) {
                sendError(response, "You can only delete your own comments");
                return;
            }
            
            // Delete
            boolean success = commentDAO.deleteComment(commentId);
            
            Map<String, Object> result = new HashMap<>();
            result.put("success", success);
            result.put("message", success ? "Comment deleted" : "Delete failed");
            
            response.getWriter().print(gson.toJson(result));
            
        } catch (SQLException e) {
            e.printStackTrace();
            sendError(response, "Database error: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            sendError(response, "Error: " + e.getMessage());
        }
    }
    
    private void sendError(HttpServletResponse response, String message) throws IOException {
        Map<String, Object> result = new HashMap<>();
        result.put("success", false);
        result.put("message", message);
        response.getWriter().print(gson.toJson(result));
    }
}

