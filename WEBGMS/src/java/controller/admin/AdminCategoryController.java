package controller.admin;

import dao.CategoryDAO;
import model.product.ProductCategories;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminCategoryController", urlPatterns = {"/admin/categories"})
public class AdminCategoryController extends HttpServlet {
    
    private static final int PAGE_SIZE = 10;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                listCategories(request, response);
                break;
            case "create":
                showCreateForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteCategory(request, response);
                break;
            default:
                listCategories(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "create":
                createCategory(request, response);
                break;
            case "update":
                updateCategory(request, response);
                break;
            default:
                listCategories(request, response);
                break;
        }
    }
    
    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");
        String pageStr = request.getParameter("page");
        
        int page = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        CategoryDAO categoryDAO = new CategoryDAO();
        List<ProductCategories> categories;
        int totalCategories;
        
        if ((keyword != null && !keyword.trim().isEmpty()) || 
            (status != null && !status.equals("all"))) {
            categories = categoryDAO.searchCategories(keyword, status, page, PAGE_SIZE);
            totalCategories = categoryDAO.countCategories(keyword, status);
        } else {
            categories = categoryDAO.getAllCategories(page, PAGE_SIZE);
            totalCategories = categoryDAO.getTotalCategories();
        }
        
        int totalPages = (int) Math.ceil((double) totalCategories / PAGE_SIZE);
        
        request.setAttribute("categories", categories);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCategories", totalCategories);
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);
        
        request.getRequestDispatcher("/views/admin/categories-list.jsp").forward(request, response);
    }
    
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/views/admin/category-form.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String categoryIdStr = request.getParameter("id");
        if (categoryIdStr == null || categoryIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }
        
        long categoryId = Long.parseLong(categoryIdStr);
        CategoryDAO categoryDAO = new CategoryDAO();
        ProductCategories category = categoryDAO.getCategoryById(categoryId);
        
        if (category == null) {
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }
        
        request.setAttribute("category", category);
        request.setAttribute("isEdit", true);
        
        request.getRequestDispatcher("/views/admin/category-form.jsp").forward(request, response);
    }
    
    private void createCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String slug = request.getParameter("slug");
        String description = request.getParameter("description");
        String status = request.getParameter("status");
        
        CategoryDAO categoryDAO = new CategoryDAO();
        
        if (categoryDAO.isCategoryNameExists(name, null)) {
            request.setAttribute("error", "Tên danh mục đã tồn tại");
            showCreateForm(request, response);
            return;
        }
        
        ProductCategories category = new ProductCategories();
        category.setName(name);
        category.setSlug(slug);
        category.setDescription(description);
        category.setStatus(status);
        
        boolean success = categoryDAO.createCategory(category);
        
        if (success) {
            request.getSession().setAttribute("success", "Tạo danh mục thành công");
            response.sendRedirect(request.getContextPath() + "/admin/categories");
        } else {
            request.setAttribute("error", "Tạo danh mục thất bại");
            showCreateForm(request, response);
        }
    }
    
    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String categoryIdStr = request.getParameter("categoryId");
        String name = request.getParameter("name");
        String slug = request.getParameter("slug");
        String description = request.getParameter("description");
        String status = request.getParameter("status");
        
        long categoryId = Long.parseLong(categoryIdStr);
        CategoryDAO categoryDAO = new CategoryDAO();
        ProductCategories category = categoryDAO.getCategoryById(categoryId);
        
        if (category == null) {
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }
        
        if (categoryDAO.isCategoryNameExists(name, categoryId)) {
            request.setAttribute("error", "Tên danh mục đã tồn tại");
            request.setAttribute("category", category);
            request.setAttribute("isEdit", true);
            request.getRequestDispatcher("/views/admin/category-form.jsp").forward(request, response);
            return;
        }
        
        category.setName(name);
        category.setSlug(slug);
        category.setDescription(description);
        category.setStatus(status);
        
        boolean success = categoryDAO.updateCategory(category);
        
        if (success) {
            request.getSession().setAttribute("success", "Cập nhật danh mục thành công");
            response.sendRedirect(request.getContextPath() + "/admin/categories");
        } else {
            request.setAttribute("error", "Cập nhật danh mục thất bại");
            request.setAttribute("category", category);
            request.setAttribute("isEdit", true);
            request.getRequestDispatcher("/views/admin/category-form.jsp").forward(request, response);
        }
    }
    
    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String categoryIdStr = request.getParameter("id");
        if (categoryIdStr == null || categoryIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }
        
        long categoryId = Long.parseLong(categoryIdStr);
        CategoryDAO categoryDAO = new CategoryDAO();
        boolean success = categoryDAO.deleteCategory(categoryId);
        
        if (success) {
            request.getSession().setAttribute("success", "Xóa danh mục thành công");
        } else {
            request.getSession().setAttribute("error", "Xóa danh mục thất bại");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }
}
