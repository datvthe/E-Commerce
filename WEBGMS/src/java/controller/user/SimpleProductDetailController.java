package controller.user;

import dao.ProductDAO;
import dao.ProductImageDAO;
import dao.InventoryDAO;
import dao.WishlistDAO;
import model.product.Products;
import model.product.ProductImages;
import model.product.Inventory;
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
 * Controller for Simple Product Detail Page
 * Handles product details in a clean card layout
 */
@WebServlet(name = "SimpleProductDetailController", urlPatterns = {"/product-simple/*"})
public class SimpleProductDetailController extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();
    private ProductImageDAO imageDAO = new ProductImageDAO();
    private InventoryDAO inventoryDAO = new InventoryDAO();
    private WishlistDAO wishlistDAO = new WishlistDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        // Extract product slug or ID from path
        String identifier = pathInfo.substring(1); // Remove leading slash
        
        Products product = null;
        
        // Try to parse as ID first, if fails, treat as slug
        try {
            long productId = Long.parseLong(identifier);
            product = productDAO.getProductById(productId);
        } catch (NumberFormatException e) {
            product = productDAO.getProductBySlug(identifier);
        }

        if (product == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
            return;
        }

        // Get product images
        List<ProductImages> images = imageDAO.getImagesByProductId(product.getProduct_id());
        
        // Get inventory
        Inventory inventory = inventoryDAO.getInventoryByProductId(product.getProduct_id());
        int availableStock = inventoryDAO.getAvailableQuantity(product.getProduct_id());
        
        // Check if product is in user's wishlist
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        boolean isInWishlist = false;
        
        if (currentUser != null) {
            isInWishlist = wishlistDAO.isInWishlist(currentUser.getUser_id(), product.getProduct_id());
        }

        // Set attributes
        request.setAttribute("product", product);
        request.setAttribute("images", images);
        request.setAttribute("inventory", inventory);
        request.setAttribute("availableStock", availableStock);
        request.setAttribute("isInWishlist", isInWishlist);

        // Forward to full product detail JSP for richer layout
        request.getRequestDispatcher("/views/user/product-detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
