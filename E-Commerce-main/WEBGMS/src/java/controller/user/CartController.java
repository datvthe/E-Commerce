package controller.user;

import dao.CartDAO;
import dao.InventoryDAO;
import model.user.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

/**
 * Controller for Cart operations
 * Handles Add to Cart, Update Cart, Remove from Cart, Buy Now
 */
@WebServlet(name = "CartController", urlPatterns = {"/cart/*"})
public class CartController extends HttpServlet {

    private CartDAO cartDAO = new CartDAO();
    private InventoryDAO inventoryDAO = new InventoryDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        if (currentUser == null) {
            sendJsonResponse(response, false, "Please login to add items to cart");
            return;
        }

        String action = request.getParameter("action");
        String productIdStr = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity");
        String cartIdStr = request.getParameter("cartId");

        try {
            // Input validation
            if (productIdStr == null || productIdStr.trim().isEmpty()) {
                sendJsonResponse(response, false, "Product ID is required");
                return;
            }
            if (quantityStr != null && (Integer.parseInt(quantityStr) < 1 || Integer.parseInt(quantityStr) > 100)) {
                sendJsonResponse(response, false, "Quantity must be between 1 and 100");
                return;
            }
            
            long productId = Long.parseLong(productIdStr);
            int quantity = quantityStr != null ? Integer.parseInt(quantityStr) : 1;

            switch (action) {
                case "add":
                    addToCart(currentUser.getUser_id(), productId, quantity, response);
                    break;
                case "update":
                    int cartId = Integer.parseInt(cartIdStr);
                    updateCart(cartId, quantity, response);
                    break;
                case "remove":
                    cartId = Integer.parseInt(cartIdStr);
                    removeFromCart(cartId, response);
                    break;
                case "buyNow":
                    buyNow(currentUser.getUser_id(), productId, quantity, response);
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
        
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?force=1");
            return;
        }

        // Get cart items
        CartDAO cartDAO = new CartDAO();
        request.setAttribute("cartItems", cartDAO.getCartByUserId(currentUser.getUser_id()));
        request.setAttribute("cartItemCount", cartDAO.getCartItemCount(currentUser.getUser_id()));

        request.getRequestDispatcher("/views/user/cart.jsp").forward(request, response);
    }

    private void addToCart(int userId, long productId, int quantity, HttpServletResponse response) 
            throws IOException {
        
        // Check stock availability
        int availableStock = inventoryDAO.getAvailableQuantity(productId);
        if (availableStock < quantity) {
            sendJsonResponse(response, false, "Insufficient stock. Available: " + availableStock);
            return;
        }

        boolean success = cartDAO.addToCart(userId, productId, quantity);
        
        if (success) {
            // Reserve quantity
            inventoryDAO.reserveQuantity(productId, quantity);
            sendJsonResponse(response, true, "Product added to cart successfully");
        } else {
            sendJsonResponse(response, false, "Failed to add product to cart");
        }
    }

    private void updateCart(int cartId, int quantity, HttpServletResponse response) 
            throws IOException {
        
        if (quantity <= 0) {
            sendJsonResponse(response, false, "Quantity must be greater than 0");
            return;
        }

        boolean success = cartDAO.updateCartQuantity(cartId, quantity);
        
        if (success) {
            sendJsonResponse(response, true, "Cart updated successfully");
        } else {
            sendJsonResponse(response, false, "Failed to update cart");
        }
    }

    private void removeFromCart(int cartId, HttpServletResponse response) 
            throws IOException {
        
        boolean success = cartDAO.removeFromCart(cartId);
        
        if (success) {
            sendJsonResponse(response, true, "Item removed from cart");
        } else {
            sendJsonResponse(response, false, "Failed to remove item from cart");
        }
    }

    private void buyNow(int userId, long productId, int quantity, HttpServletResponse response) 
            throws IOException {
        
        // Check stock availability
        int availableStock = inventoryDAO.getAvailableQuantity(productId);
        if (availableStock < quantity) {
            sendJsonResponse(response, false, "Insufficient stock. Available: " + availableStock);
            return;
        }

        // Add to cart first
        boolean cartSuccess = cartDAO.addToCart(userId, productId, quantity);
        
        if (cartSuccess) {
            // Reserve quantity
            inventoryDAO.reserveQuantity(productId, quantity);
            
            // Redirect to checkout
            JsonObject jsonResponse = new JsonObject();
            jsonResponse.addProperty("success", true);
            jsonResponse.addProperty("message", "Redirecting to checkout...");
            jsonResponse.addProperty("redirectUrl", getServletContext().getContextPath() + "/checkout");
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(new Gson().toJson(jsonResponse));
        } else {
            sendJsonResponse(response, false, "Failed to process order");
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
