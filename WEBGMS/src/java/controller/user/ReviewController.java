package controller.user;

import dao.ReviewDAO;
import model.user.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

/**
 * Controller for Review operations
 * Handles Add Review, Get Reviews
 */
@WebServlet(name = "ReviewController", urlPatterns = {"/review/*"})
public class ReviewController extends HttpServlet {

    private ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        if (currentUser == null) {
            sendJsonResponse(response, false, "Please login to submit a review");
            return;
        }

        String action = request.getParameter("action");
        String productIdStr = request.getParameter("productId");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");
        String images = request.getParameter("images");

        try {
            // Input validation
            if (productIdStr == null || productIdStr.trim().isEmpty()) {
                sendJsonResponse(response, false, "Product ID is required");
                return;
            }
            if (ratingStr == null || ratingStr.trim().isEmpty()) {
                sendJsonResponse(response, false, "Rating is required");
                return;
            }
            if (comment == null || comment.trim().isEmpty()) {
                sendJsonResponse(response, false, "Comment is required");
                return;
            }
            if (comment.length() > 1000) {
                sendJsonResponse(response, false, "Comment is too long (max 1000 characters)");
                return;
            }
            
            int productId = Integer.parseInt(productIdStr);
            int rating = Integer.parseInt(ratingStr);

            if (rating < 1 || rating > 5) {
                sendJsonResponse(response, false, "Rating must be between 1 and 5");
                return;
            }

            switch (action) {
                case "add":
                    addReview(currentUser.getUser_id(), productId, rating, comment, images, response);
                    break;
                default:
                    sendJsonResponse(response, false, "Invalid action");
            }
        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "Invalid parameters");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String productIdStr = request.getParameter("productId");
        String pageStr = request.getParameter("page");

        try {
            int productId = Integer.parseInt(productIdStr);
            int page = pageStr != null ? Integer.parseInt(pageStr) : 1;

            switch (action) {
                case "get":
                    getReviews(productId, page, response);
                    break;
                case "distribution":
                    getRatingDistribution(productId, response);
                    break;
                default:
                    sendJsonResponse(response, false, "Invalid action");
            }
        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "Invalid parameters");
        }
    }

    private void addReview(int userId, int productId, int rating, String comment, String images, 
                          HttpServletResponse response) throws IOException {
        
        boolean success = reviewDAO.addReview(productId, userId, rating, comment, images);
        
        if (success) {
            sendJsonResponse(response, true, "Review submitted successfully. It will be reviewed before publishing.");
        } else {
            sendJsonResponse(response, false, "Failed to submit review");
        }
    }

    private void getReviews(int productId, int page, HttpServletResponse response) 
            throws IOException {
        
        int pageSize = 10;
        var reviews = reviewDAO.getReviewsByProductId(productId, page, pageSize);
        
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("success", true);
        jsonResponse.add("reviews", new Gson().toJsonTree(reviews));
        jsonResponse.addProperty("page", page);
        jsonResponse.addProperty("pageSize", pageSize);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(new Gson().toJson(jsonResponse));
    }

    private void getRatingDistribution(int productId, HttpServletResponse response) 
            throws IOException {
        
        int[] distribution = reviewDAO.getRatingDistribution(productId);
        
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("success", true);
        jsonResponse.add("distribution", new Gson().toJsonTree(distribution));
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(new Gson().toJson(jsonResponse));
    }

    private void sendJsonResponse(HttpServletResponse response, boolean success, String message) 
            throws IOException {
        
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("success", success);
        jsonResponse.addProperty("message", message);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(new Gson().toJson(jsonResponse));
    }
}
