package controller.user;

import dao.ProductDAO;
import dao.ProductImageDAO;
import model.product.Products;
import model.product.ProductImages;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Controller for Products Listing Page
 * Handles product listing, filtering, and search
 */
@WebServlet(name = "ProductsController", urlPatterns = {"/products"})
public class ProductsController extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();
    private ProductImageDAO imageDAO = new ProductImageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get parameters
        String pageParam = request.getParameter("page");
        String categoryParam = request.getParameter("category");
        String sortParam = request.getParameter("sort");
        String searchParam = request.getParameter("search");
        
        int page = 1;
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        int pageSize = 12; // 12 products per page
        
        // Get products
        List<Products> products = productDAO.getAllProducts(page, pageSize);
        
        // Get primary images for each product
        for (Products product : products) {
            ProductImages primaryImage = imageDAO.getPrimaryImage(product.getProduct_id());
            if (primaryImage != null) {
                // Store primary image URL in a custom attribute for easy access in JSP
                product.setName(product.getName() + "|IMAGE_URL:" + primaryImage.getUrl());
            }
        }
        
        // Set attributes
        request.setAttribute("products", products);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("category", categoryParam);
        request.setAttribute("sort", sortParam);
        request.setAttribute("search", searchParam);
        
        // Calculate pagination info
        int totalPages = (int) Math.ceil(100.0 / pageSize); // Assuming 100 total products for now
        request.setAttribute("totalPages", totalPages);
        
        // Forward to JSP
        request.getRequestDispatcher("/views/user/products.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
