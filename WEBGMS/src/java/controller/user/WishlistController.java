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
@WebServlet(name = "WishlistController", urlPatterns = {"/wishlist/*"})
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

        String action = request.getParameter("action");
        String productIdStr = request.getParameter("productId");

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
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?force=1");
            return;
        }

        // Get wishlist items
        request.setAttribute("wishlistItems", wishlistDAO.getWishlistByUserId(currentUser.getUser_id()));
        request.setAttribute("wishlistItemCount", wishlistDAO.getWishlistItemCount(currentUser.getUser_id()));

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
