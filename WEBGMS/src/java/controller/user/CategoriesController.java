package controller.user;

import dao.CategoryDAO;
import model.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * CategoriesController - Handles category listing page
 */
@WebServlet(name = "CategoriesController", urlPatterns = {"/categories"})
public class CategoriesController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        CategoryDAO categoryDAO = new CategoryDAO();
        
        try {
            // Get all categories
            List<Category> allCategories = categoryDAO.getAllCategories();
            
            // Get parent categories (top level)
            List<Category> parentCategories = categoryDAO.getParentCategories();
            
            // For each parent category, get its subcategories
            for (Category parent : parentCategories) {
                List<Category> subcategories = categoryDAO.getSubcategories(parent.getCategoryId());
                // Store subcategories in request attribute with parent category ID as key
                request.setAttribute("subcategories_" + parent.getCategoryId(), subcategories);
            }
            
            // Set attributes
            request.setAttribute("allCategories", allCategories);
            request.setAttribute("parentCategories", parentCategories);
            
            // Calculate total products across all categories
            int totalProducts = 0;
            for (Category cat : allCategories) {
                totalProducts += cat.getProductCount();
            }
            request.setAttribute("totalProducts", totalProducts);
            
            // Forward to JSP
            request.getRequestDispatcher("/views/user/categories.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading categories");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Categories Controller - Displays all product categories";
    }
}
