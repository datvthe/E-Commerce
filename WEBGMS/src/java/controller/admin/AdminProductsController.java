package controller.admin;

import dao.ProductDAO;
import dao.ProductCategoriesDAO;
import dao.ProductImageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;
import model.product.ProductCategories;
import model.product.ProductImages;
import model.product.Products;
import model.user.Users;

@WebServlet(name = "AdminProductsController", urlPatterns = {"/admin/products", "/admin/products/edit", "/admin/products/update", "/admin/products/delete", "/admin/products/change-status"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 1, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 15)
public class AdminProductsController extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/admin/products".equals(path)) {
            String keyword = request.getParameter("keyword");
            String status = request.getParameter("status");
            String category = request.getParameter("category_id");
            int page = 1; int pageSize = 12;
            try { String p = request.getParameter("page"); if (p != null) page = Integer.parseInt(p);} catch (Exception ignore) {}
            List<Products> list = productDAO.adminFilterProducts(page, pageSize, keyword, category, status);
            int total = productDAO.adminCountFilteredProducts(keyword, category, status);
            int totalPages = (int)Math.ceil((double)total / pageSize);
            ProductCategoriesDAO cateDAO = new ProductCategoriesDAO();
            List<ProductCategories> categories = cateDAO.getAllCategories();
            request.setAttribute("products", list);
            request.setAttribute("categories", categories);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalProducts", total);
            request.setAttribute("keyword", keyword);
            request.setAttribute("status", status);
            request.setAttribute("categoryId", category);
            request.getRequestDispatcher("/views/admin/admin-products.jsp").forward(request, response);
            return;
        }
        if ("/admin/products/edit".equals(path)) {
            long id = Long.parseLong(request.getParameter("id"));
            Products product = productDAO.getProductById(id);
            if (product == null) { response.sendRedirect(request.getContextPath()+"/admin/products"); return; }
            ProductCategoriesDAO cateDAO = new ProductCategoriesDAO();
            List<ProductCategories> categories = cateDAO.getAllCategories();
            request.setAttribute("product", product);
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/views/admin/admin-product-edit.jsp").forward(request, response);
            return;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/admin/products/update".equals(path)) {
            try {
                long productId = Long.parseLong(request.getParameter("product_id"));
                Products existing = productDAO.getProductById(productId);
                if (existing == null) { response.sendRedirect(request.getContextPath()+"/admin/products"); return; }
                String name = request.getParameter("name");
                String description = request.getParameter("description");
                BigDecimal price = new BigDecimal(request.getParameter("price"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                int categoryId = Integer.parseInt(request.getParameter("category_id"));
                String status = request.getParameter("status");
                Part imagePart = request.getPart("image");
                existing.setName(name);
                existing.setDescription(description);
                existing.setPrice(price);
                existing.setQuantity(quantity);
                existing.setStatus(status);
                existing.setUpdated_at(new Timestamp(System.currentTimeMillis()));
                ProductCategories cate = new ProductCategories(); cate.setCategory_id(categoryId); existing.setCategory_id(cate);
                if (imagePart != null && imagePart.getSize() > 0) {
                    String lower = imagePart.getSubmittedFileName()==null?"":imagePart.getSubmittedFileName().toLowerCase();
                    if (!(lower.endsWith(".jpg")||lower.endsWith(".jpeg")||lower.endsWith(".png")||lower.endsWith(".webp"))) {
                        request.setAttribute("error","Định dạng ảnh không hợp lệ");
                        request.setAttribute("product", existing);
                        request.getRequestDispatcher("/views/admin/admin-product-edit.jsp").forward(request, response);
                        return;
                    }
                    String uploadPath = request.getServletContext().getRealPath("")+File.separator+"uploads"+File.separator+"products";
                    new File(uploadPath).mkdirs();
                    String fileName = System.currentTimeMillis()+"_"+imagePart.getSubmittedFileName();
                    imagePart.write(uploadPath+File.separator+fileName);
                    String imageUrl = request.getContextPath()+"/uploads/products/"+fileName;
                    new ProductImageDAO().updatePrimaryImage(productId, imageUrl, "Ảnh sản phẩm "+name);
                }
                boolean ok = productDAO.updateProduct(existing);
                response.sendRedirect(request.getContextPath()+"/admin/products"+(ok?"?success=update":"?error=1"));
                return;
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath()+"/admin/products?error=1");
                return;
            }
        }
        if ("/admin/products/delete".equals(path)) {
            try { long id = Long.parseLong(request.getParameter("id")); boolean ok = productDAO.softDeleteProduct(id); response.sendRedirect(request.getContextPath()+"/admin/products"+(ok?"?success=delete":"?error=1")); return;} catch(Exception e){ response.sendRedirect(request.getContextPath()+"/admin/products?error=1"); return; }
        }
        if ("/admin/products/change-status".equals(path)) {
            long id = Long.parseLong(request.getParameter("id")); String newStatus = request.getParameter("status");
            Products p = productDAO.getProductById(id); if (p!=null){ p.setStatus(newStatus); p.setUpdated_at(new Timestamp(System.currentTimeMillis())); productDAO.updateProduct(p);} 
            response.sendRedirect(request.getContextPath()+"/admin/products?success=status");
        }
    }
}