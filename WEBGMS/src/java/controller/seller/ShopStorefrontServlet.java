package controller.seller;

import dao.SellerDAO;
import dao.ProductDAO;
import dao.ProductImageDAO;
import dao.ProductCategoriesDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.seller.Seller;
import model.product.Products;
import model.product.ProductImages;
import model.product.ProductCategories;

/**
 * Servlet to handle shop storefront page
 * URL: /shop-storefront?sellerId=xxx
 */
@WebServlet(name = "ShopStorefrontServlet", urlPatterns = {"/shop-storefront"})
public class ShopStorefrontServlet extends HttpServlet {

    private SellerDAO sellerDAO;
    private ProductDAO productDAO;
    private ProductImageDAO imageDAO;
    private ProductCategoriesDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        sellerDAO = new SellerDAO();
        productDAO = new ProductDAO();
        imageDAO = new ProductImageDAO();
        categoryDAO = new ProductCategoriesDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get seller ID from URL parameter
        String sellerIdParam = request.getParameter("sellerId");
        
        if (sellerIdParam == null || sellerIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Seller ID is required");
            return;
        }
        
        try {
            int sellerId = Integer.parseInt(sellerIdParam);
            
            // Fetch seller data from database
            Seller seller = sellerDAO.getSellerById(sellerId);
            
            if (seller == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Shop không tồn tại");
                return;
            }
            
            // Get pagination parameters
            int page = 1;
            int pageSize = 12;
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            
            // Get category filter parameter
            String categoryParam = request.getParameter("category");
            int categoryId = 0;
            if (categoryParam != null && !categoryParam.isEmpty()) {
                try {
                    categoryId = Integer.parseInt(categoryParam);
                } catch (NumberFormatException e) {
                    categoryId = 0;
                }
            }
            
            // Fetch products của seller (dùng seller_id vì products.seller_id = sellers.seller_id)
            int sellerIdInt = seller.getSellerId();
            
            System.out.println("=== SHOP STOREFRONT DEBUG ===");
            System.out.println("Seller ID from URL: " + sellerId);
            System.out.println("Seller seller_id (DB): " + sellerIdInt);
            System.out.println("Seller user_id: " + seller.getUserId());
            System.out.println("Seller shop_name: " + seller.getShopName());
            System.out.println("Category filter: " + categoryId);
            
            // Fetch products (với hoặc không filter category)
            List<Products> products;
            if (categoryId > 0) {
                // Filter by category
                products = productDAO.searchProductsBySeller(sellerIdInt, null, "active", categoryId);
                // Apply pagination manually if needed
                int fromIndex = (page - 1) * pageSize;
                int toIndex = Math.min(fromIndex + pageSize, products.size());
                products = products.subList(fromIndex, toIndex);
            } else {
                // All products
                products = productDAO.getProductsBySellerIdWithPagination(sellerIdInt, page, pageSize);
            }
            
            System.out.println("Products found: " + (products != null ? products.size() : 0));
            
            // Fetch images cho từng product
            for (Products product : products) {
                List<ProductImages> images = imageDAO.getImagesByProductId(product.getProduct_id());
                product.setProductImages(images);
                
                System.out.println("  - Product: " + product.getName() + " (ID: " + product.getProduct_id() + ")");
                
                // Fetch category nếu có
                if (product.getCategory_id() != null && product.getCategory_id().getCategory_id() > 0) {
                    ProductCategories category = categoryDAO.getCategoryById(product.getCategory_id().getCategory_id());
                    if (category != null) {
                        product.setCategory_id(category);
                    }
                }
            }
            
            // Count total products và tính pages
            int totalProducts;
            if (categoryId > 0) {
                // Count filtered products
                List<Products> allFilteredProducts = productDAO.searchProductsBySeller(sellerIdInt, null, "active", categoryId);
                totalProducts = allFilteredProducts.size();
            } else {
                // Count all products
                totalProducts = productDAO.countBySeller(sellerIdInt);
            }
            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
            
            // Fetch all categories và đếm products cho từng category
            List<ProductCategories> allCategories = categoryDAO.getAllCategories();
            java.util.Map<Long, Integer> categoryProductCount = new java.util.HashMap<>();
            
            // Đếm products cho từng category của seller này
            for (ProductCategories cat : allCategories) {
                List<Products> categoryProducts = productDAO.searchProductsBySeller(
                    sellerIdInt, null, "active", (int) cat.getCategory_id()
                );
                int count = categoryProducts != null ? categoryProducts.size() : 0;
                if (count > 0) {
                    categoryProductCount.put(cat.getCategory_id(), count);
                }
            }
            
            System.out.println("Total products count: " + totalProducts);
            System.out.println("Categories with products: " + categoryProductCount.size());
            System.out.println("============================");
            
            // Set attributes
            request.setAttribute("seller", seller);
            request.setAttribute("products", products);
            request.setAttribute("allCategories", allCategories);
            request.setAttribute("categoryProductCount", categoryProductCount);
            request.setAttribute("selectedCategory", categoryId);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("totalSold", "1.2k"); // Hard-coded for now
            request.setAttribute("rating", 4.8); // Hard-coded for now
            
            // Forward to JSP
            request.getRequestDispatcher("/views/seller/shop-storefront.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Seller ID format");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Shop Storefront Servlet";
    }
}

