package controller.user;

import dao.ProductDAO;
import dao.ProductImageDAO;
import dao.InventoryDAO;
import dao.DigitalProductDAO;
import dao.ReviewDAO;
import dao.WishlistDAO;
import model.product.Products;
import model.product.ProductImages;
import model.product.Inventory;
import model.feedback.Reviews;
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
 * Controller for Product Detail Page
 * Handles product details, images, inventory, and reviews
 */
@WebServlet(name = "ProductDetailController", urlPatterns = {"/product/*"})
public class ProductDetailController extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();
    private ProductImageDAO imageDAO = new ProductImageDAO();
    private InventoryDAO inventoryDAO = new InventoryDAO();
    private DigitalProductDAO digitalDAO = new DigitalProductDAO();
    private ReviewDAO reviewDAO = new ReviewDAO();
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
        
        // Get stock (digital products use digital_products; otherwise Inventory)
        Inventory inventory = null;
        int availableStock;
        boolean isDigitalGoods;
        try {
            long categoryId = (product.getCategory_id() != null) ? product.getCategory_id().getCategory_id() : 0;
            // Heuristic stays the same as before
            isDigitalGoods = product.getCategory_id() != null && 
                (product.getCategory_id().getName().toLowerCase().contains("thẻ cào") ||
                 product.getCategory_id().getName().toLowerCase().contains("tài khoản") ||
                 product.getCategory_id().getName().toLowerCase().contains("phần mềm") ||
                 product.getCategory_id().getName().toLowerCase().contains("digital") ||
                 product.getCategory_id().getName().toLowerCase().contains("số"));
        } catch (Exception e) { isDigitalGoods = false; }
        if (isDigitalGoods) {
            availableStock = digitalDAO.getAvailableStock(product.getProduct_id());
        } else {
            inventory = inventoryDAO.getInventoryByProductId(product.getProduct_id());
            availableStock = inventoryDAO.getAvailableQuantity(product.getProduct_id());
        }
        
        // Get reviews (first page, 10 per page)
        int reviewPage = 1;
        int reviewPageSize = 10;
        String pageParam = request.getParameter("reviewPage");
        if (pageParam != null) {
            try {
                reviewPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                reviewPage = 1;
            }
        }
        List<Reviews> reviews = reviewDAO.getReviewsByProductId(product.getProduct_id(), reviewPage, reviewPageSize);
        
        // Get rating distribution
        int[] ratingDistribution = reviewDAO.getRatingDistribution(product.getProduct_id());
        
        // Get similar products
        long categoryId = (product.getCategory_id() != null) ? product.getCategory_id().getCategory_id() : 0;
        List<Products> similarProducts = productDAO.getSimilarProducts(product.getProduct_id(), (int) categoryId, 6);
        
        // Check if product is in user's wishlist
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        boolean isInWishlist = false;
        
        if (currentUser != null) {
            isInWishlist = wishlistDAO.isInWishlist(currentUser.getUser_id(), product.getProduct_id());
        }

        // Check if product is digital goods (already computed above)

        // Set attributes
        request.setAttribute("product", product);
        request.setAttribute("images", images);
        request.setAttribute("inventory", inventory);
        request.setAttribute("availableStock", availableStock);
        request.setAttribute("reviews", reviews);
        request.setAttribute("ratingDistribution", ratingDistribution);
        request.setAttribute("similarProducts", similarProducts);
        request.setAttribute("isInWishlist", isInWishlist);
        request.setAttribute("isDigitalGoods", isDigitalGoods);
        request.setAttribute("reviewPage", reviewPage);

        // Forward to JSP
        request.getRequestDispatcher("/views/user/product-detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

