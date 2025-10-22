package controller.user;

import dao.WishlistDAO;
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
 * Controller for Wishlist operations
 * Handles Add to Wishlist, Remove from Wishlist
 */
@WebServlet(name = "WishlistController", urlPatterns = {"/wishlist", "/wishlist/*", "/addToWishlist", "/removeFromWishlist", "/clearWishlist", "/api/wishlist/count"})
public class WishlistController extends HttpServlet {

    private WishlistDAO wishlistDAO = new WishlistDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        if (currentUser == null) {
            sendJsonResponse(response, false, "Please login to manage wishlist");
            return;
        }

        String path = request.getServletPath();
        String action = request.getParameter("action");
        String productIdStr = request.getParameter("productId");
        
        // Handle different URL patterns
        switch (path) {
            case "/addToWishlist":
                handleAddToWishlist(request, response, currentUser);
                break;
            case "/removeFromWishlist":
                handleRemoveFromWishlist(request, response, currentUser);
                break;
            case "/clearWishlist":
                handleClearWishlist(request, response, currentUser);
                break;
            default:
                // Legacy handling for action parameter
                if (action != null && productIdStr != null) {
                    try {
                        long productId = Long.parseLong(productIdStr);
                        switch (action) {
                            case "add":
                                addToWishlist(currentUser.getUser_id(), productId, response);
                                break;
                            case "remove":
                                removeFromWishlist(currentUser.getUser_id(), productId, response);
                                break;
                            case "toggle":
                                toggleWishlist(currentUser.getUser_id(), productId, response);
                                break;
                            default:
                                sendJsonResponse(response, false, "Invalid action");
                        }
                    } catch (NumberFormatException e) {
                        sendJsonResponse(response, false, "Invalid product ID");
                    }
                } else {
                    sendJsonResponse(response, false, "Invalid request");
                }
                break;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        String path = request.getServletPath();
        
        // Handle API endpoint for wishlist count
        if ("/api/wishlist/count".equals(path)) {
            if (currentUser == null) {
                sendJsonResponse(response, false, "User not logged in");
                return;
            }
            
            int count = wishlistDAO.getWishlistItemCount(currentUser.getUser_id());
            JsonObject jsonResponse = new JsonObject();
            jsonResponse.addProperty("success", true);
            jsonResponse.addProperty("count", count);
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(new Gson().toJson(jsonResponse));
            return;
        }
        
        // Regular wishlist page
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?force=1");
            return;
        }

        // Pagination params with sensible defaults
        int page = 1;
        int pageSize = 10;
        try {
            String p = request.getParameter("page");
            String s = request.getParameter("size");
            if (p != null) page = Math.max(1, Integer.parseInt(p));
            if (s != null) pageSize = Math.min(50, Math.max(5, Integer.parseInt(s))); // clamp size 5..50
        } catch (NumberFormatException ignore) {}

        int totalItems = wishlistDAO.getWishlistItemCount(currentUser.getUser_id());
        int offset = (page - 1) * pageSize;
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);

        // Get paged wishlist items
        request.setAttribute("wishlistItems", wishlistDAO.getWishlistByUserIdPaged(currentUser.getUser_id(), pageSize, offset));
        request.setAttribute("wishlistItemCount", totalItems);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/views/user/wishlist.jsp").forward(request, response);
    }

    private void addToWishlist(int userId, long productId, HttpServletResponse response) 
            throws IOException {
        
        boolean success = wishlistDAO.addToWishlist(userId, productId);
        
        if (success) {
            sendJsonResponse(response, true, "Product added to wishlist");
        } else {
            sendJsonResponse(response, false, "Product already in wishlist or failed to add");
        }
    }

    private void removeFromWishlist(int userId, long productId, HttpServletResponse response) 
            throws IOException {
        
        boolean success = wishlistDAO.removeFromWishlist(userId, productId);
        
        if (success) {
            sendJsonResponse(response, true, "Product removed from wishlist");
        } else {
            sendJsonResponse(response, false, "Failed to remove product from wishlist");
        }
    }

    private void toggleWishlist(int userId, long productId, HttpServletResponse response) 
            throws IOException {
        
        boolean isInWishlist = wishlistDAO.isInWishlist(userId, productId);
        
        if (isInWishlist) {
            removeFromWishlist(userId, productId, response);
        } else {
            addToWishlist(userId, productId, response);
        }
    }

    /**
     * Handle add to wishlist request
     */
    private void handleAddToWishlist(HttpServletRequest request, HttpServletResponse response, Users user) 
            throws IOException {
        String productIdStr = request.getParameter("productId");
        try {
            long productId = Long.parseLong(productIdStr);
            addToWishlist(user.getUser_id(), productId, response);
        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "Invalid product ID");
        }
    }
    
    /**
     * Handle remove from wishlist request
     */
    private void handleRemoveFromWishlist(HttpServletRequest request, HttpServletResponse response, Users user) 
            throws IOException {
        String productIdStr = request.getParameter("productId");
        try {
            long productId = Long.parseLong(productIdStr);
            removeFromWishlist(user.getUser_id(), productId, response);
        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "Invalid product ID");
        }
    }
    
    /**
     * Handle clear all wishlist items request
     */
    private void handleClearWishlist(HttpServletRequest request, HttpServletResponse response, Users user) 
            throws IOException {
        boolean success = wishlistDAO.clearWishlist(user.getUser_id());
        
        if (success) {
            sendJsonResponse(response, true, "All items cleared from wishlist");
        } else {
            sendJsonResponse(response, false, "Failed to clear wishlist");
        }
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
