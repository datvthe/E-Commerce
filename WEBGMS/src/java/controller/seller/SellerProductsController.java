package controller.seller;

import dao.ProductCategoriesDAO;
import dao.ProductDAO;
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

@WebServlet(name = "SellerProductsController", urlPatterns = {"/seller/products", "/seller/products/add"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 15 // 15MB
)
public class SellerProductsController extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();

        // 🟧 Trang danh sách sản phẩm
        if ("/seller/products".equals(path)) {
            List<Products> productList = productDAO.getProductsBySellerId(user.getUser_id());
            request.setAttribute("products", productList);
            request.getRequestDispatcher("/views/seller/seller-products.jsp").forward(request, response);
            return;
        }

        // 🟧 Trang thêm sản phẩm
        if ("/seller/products/add".equals(path)) {
            ProductCategoriesDAO cateDAO = new ProductCategoriesDAO();
            List<ProductCategories> categories = cateDAO.getAllCategories();
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/views/seller/seller-add-product.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/seller/products/add".equals(path)) {
            try {
                HttpSession session = request.getSession();
                Users seller = (Users) session.getAttribute("user");

                if (seller == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }

                // 🧱 Lấy dữ liệu từ form
                String name = request.getParameter("name");
                String description = request.getParameter("description");
                BigDecimal price = new BigDecimal(request.getParameter("price"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                int categoryId = Integer.parseInt(request.getParameter("category_id"));
                Part imagePart = request.getPart("image");

                // 🖼️ Lưu file ảnh
                String uploadPath = request.getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "products";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                String fileName = System.currentTimeMillis() + "_" + imagePart.getSubmittedFileName();
                String filePath = uploadPath + File.separator + fileName;
                imagePart.write(filePath);

                // Đường dẫn hiển thị ảnh
                String imageUrl = request.getContextPath() + "/uploads/products/" + fileName;

                // 🧾 Tạo đối tượng sản phẩm
                Products p = new Products();
                p.setSeller_id(seller);
                p.setName(name);
                p.setDescription(description);
                p.setPrice(price);
                p.setCurrency("VND");
                p.setStatus("active");
                p.setCreated_at(new Timestamp(System.currentTimeMillis()));

                ProductCategories cate = new ProductCategories();
                cate.setCategory_id(categoryId);
                p.setCategory_id(cate);

                // Gán thêm các trường mới
                p.setQuantity(quantity);
      

                // 🟢 Lưu DB
                productDAO.insertProduct(p);
                // ✅ Lấy product_id mới vừa thêm (id tự tăng)
                long newProductId = productDAO.getLastInsertedId();

// ✅ Tạo đối tượng ảnh sản phẩm
                ProductImages img = new ProductImages();
                Products productRef = new Products(); // vì product_id trong ProductImages là kiểu Products
                productRef.setProduct_id(newProductId);
                img.setProduct_id(productRef);

                img.setUrl(imageUrl); // imageUrl bạn đã tạo khi upload ảnh
                img.setAlt_text("Ảnh sản phẩm " + p.getName());
                img.setIs_primary(true);

// ✅ Gọi DAO để lưu ảnh vào bảng product_images
                ProductImageDAO imageDAO = new ProductImageDAO();
                imageDAO.insertProductImage(img);
                response.sendRedirect(request.getContextPath() + "/seller/products");
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "❌ Có lỗi xảy ra khi thêm sản phẩm. Vui lòng thử lại!");
                request.getRequestDispatcher("/views/seller/seller-add-product.jsp").forward(request, response);
            }
        }
    }
}
