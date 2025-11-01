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
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.product.ProductCategories;
import model.product.ProductImages;
import model.product.Products;
import model.user.Users;

@WebServlet(name = "SellerProductsController", urlPatterns = {"/seller/products", "/seller/products/add", "/seller/products/edit", "/seller/products/update", "/seller/products/delete", "/seller/products/view", "/seller/products/bulk-action", "/seller/products/change-status"})
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
            // Lấy tham số tìm kiếm và lọc
            String keyword = request.getParameter("keyword");
            String status = request.getParameter("status");
            String categoryIdStr = request.getParameter("category_id");
            String pageStr = request.getParameter("page");
            
            int categoryId = 0;
            int page = 1;
            int pageSize = 10;
            
            try {
                if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                    categoryId = Integer.parseInt(categoryIdStr);
                }
                if (pageStr != null && !pageStr.trim().isEmpty()) {
                    page = Integer.parseInt(pageStr);
                }
            } catch (NumberFormatException e) {
                // Sử dụng giá trị mặc định
            }
            
            List<Products> productList;
            
            // Nếu có tìm kiếm hoặc lọc
            if ((keyword != null && !keyword.trim().isEmpty()) || 
                (status != null && !status.trim().isEmpty()) || 
                categoryId > 0) {
                productList = productDAO.searchProductsBySeller(user.getUser_id(), keyword, status, categoryId);
            } else {
                // Lấy với phân trang
                productList = productDAO.getProductsBySellerIdWithPagination(user.getUser_id(), page, pageSize);
            }
            
            // Lấy tổng số sản phẩm để tính phân trang
            int totalProducts = productDAO.getProductCountBySeller(user.getUser_id());
            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
            
            // Lấy danh sách categories cho filter
            ProductCategoriesDAO cateDAO = new ProductCategoriesDAO();
            // Ensure default digital categories exist
            cateDAO.ensureDefaultDigitalCategories();
            List<ProductCategories> categories = cateDAO.getAllCategories();
            
            request.setAttribute("products", productList);
            request.setAttribute("categories", categories);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("keyword", keyword);
            request.setAttribute("status", status);
            request.setAttribute("categoryId", categoryId);
            
            // Hiển thị thông báo thành công
            String success = request.getParameter("success");
            if ("update".equals(success)) {
                request.setAttribute("success", "✅ Cập nhật sản phẩm thành công!");
            } else if ("delete".equals(success)) {
                request.setAttribute("success", "✅ Xóa sản phẩm thành công!");
            } else if ("status".equals(success)) {
                request.setAttribute("success", "✅ Thay đổi trạng thái sản phẩm thành công!");
            } else if ("bulk".equals(success)) {
                String message = request.getParameter("message");
                if (message != null) {
                    request.setAttribute("success", message);
                } else {
                    request.setAttribute("success", "✅ Thao tác hàng loạt thành công!");
                }
            }
            
            request.getRequestDispatcher("/views/seller/seller-products.jsp").forward(request, response);
            return;
        }

        // 🟧 Trang thêm sản phẩm
        if ("/seller/products/add".equals(path)) {
            try {
                ProductCategoriesDAO cateDAO = new ProductCategoriesDAO();
                List<ProductCategories> categories = cateDAO.getAllCategories();
                
                if (categories == null) {
                    categories = new ArrayList<>();
                    System.err.println("WARNING: Categories list is null, using empty list");
                }
                
                request.setAttribute("categories", categories);
                request.getRequestDispatcher("/views/seller/seller-add-product.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                System.err.println("ERROR loading add product page: " + e.getMessage());
                request.setAttribute("error", "❌ Có lỗi xảy ra khi tải trang thêm sản phẩm: " + e.getMessage());
                try {
                    request.getRequestDispatcher("/views/seller/seller-products.jsp").forward(request, response);
                } catch (Exception ex) {
                    response.sendRedirect(request.getContextPath() + "/seller/products?error=page_load_failed");
                }
            }
            return;
        }

        // 🟧 Trang chỉnh sửa sản phẩm
        if ("/seller/products/edit".equals(path)) {
            try {
                long productId = Long.parseLong(request.getParameter("id"));
                Products product = productDAO.getProductById(productId);
                
                // Kiểm tra quyền sở hữu
                if (product == null || product.getSeller_id().getUser_id() != user.getUser_id()) {
                    request.setAttribute("error", "❌ Sản phẩm không tồn tại hoặc bạn không có quyền chỉnh sửa!");
                    request.getRequestDispatcher("/views/seller/seller-products.jsp").forward(request, response);
                    return;
                }
                
                ProductCategoriesDAO cateDAO = new ProductCategoriesDAO();
                List<ProductCategories> categories = cateDAO.getAllCategories();
                
                request.setAttribute("product", product);
                request.setAttribute("categories", categories);
                request.getRequestDispatcher("/views/seller/seller-edit-product.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "❌ ID sản phẩm không hợp lệ!");
                response.sendRedirect(request.getContextPath() + "/seller/products");
            }
            return;
        }

        // 🟧 Xem chi tiết sản phẩm
        if ("/seller/products/view".equals(path)) {
            try {
                long productId = Long.parseLong(request.getParameter("id"));
                Products product = productDAO.getProductById(productId);
                
                // Kiểm tra quyền sở hữu
                if (product == null || product.getSeller_id().getUser_id() != user.getUser_id()) {
                    request.setAttribute("error", "❌ Sản phẩm không tồn tại hoặc bạn không có quyền xem!");
                    request.getRequestDispatcher("/views/seller/seller-products.jsp").forward(request, response);
                    return;
                }
                
                // Lấy ảnh sản phẩm
                ProductImageDAO imageDAO = new ProductImageDAO();
                List<ProductImages> images = imageDAO.getImagesByProductId(productId);
                
                String success = request.getParameter("success");
                if ("added".equals(success)) {
                    request.setAttribute("success", "✅ Thêm sản phẩm thành công!");
                }

                request.setAttribute("product", product);
                request.setAttribute("images", images);
                request.getRequestDispatcher("/views/seller/seller-product-detail.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "❌ ID sản phẩm không hợp lệ!");
                response.sendRedirect(request.getContextPath() + "/seller/products");
            }
            return;
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

                // Validate category and image
                if (categoryId <= 0) {
                    request.setAttribute("error", "❌ Vui lòng chọn danh mục hợp lệ!");
                    request.getRequestDispatcher("/views/seller/seller-add-product.jsp").forward(request, response);
                    return;
                }
                if (imagePart == null || imagePart.getSize() == 0) {
                    request.setAttribute("error", "❌ Vui lòng tải lên ảnh sản phẩm!");
                    request.getRequestDispatcher("/views/seller/seller-add-product.jsp").forward(request, response);
                    return;
                }
                String submitted = imagePart.getSubmittedFileName();
                String lower = submitted == null ? "" : submitted.toLowerCase();
                if (!(lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".png") || lower.endsWith(".webp"))) {
                    request.setAttribute("error", "❌ Định dạng ảnh không hợp lệ (chỉ hỗ trợ JPG, PNG, WEBP)!");
                    request.getRequestDispatcher("/views/seller/seller-add-product.jsp").forward(request, response);
                    return;
                }

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
                // Lưu và lấy ID bằng generated keys cùng kết nối
                long newProductId = productDAO.insertProductReturningId(p);
                if (newProductId <= 0) {
                    throw new RuntimeException("Không lấy được ID sản phẩm vừa thêm");
                }

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
                response.sendRedirect(request.getContextPath() + "/seller/products/view?id=" + newProductId + "&success=added");
            } catch (NumberFormatException e) {
                e.printStackTrace();
                System.err.println("NumberFormatException in add product: " + e.getMessage());
                request.setAttribute("error", "❌ Dữ liệu nhập vào không hợp lệ! Vui lòng kiểm tra lại các trường số.");
                try {
                    ProductCategoriesDAO cateDAO = new ProductCategoriesDAO();
                    request.setAttribute("categories", cateDAO.getAllCategories());
                    request.getRequestDispatcher("/views/seller/seller-add-product.jsp").forward(request, response);
                } catch (Exception ex) {
                    response.sendRedirect(request.getContextPath() + "/seller/products?error=invalid_data");
                }
            } catch (NullPointerException e) {
                e.printStackTrace();
                System.err.println("NullPointerException in add product: " + e.getMessage());
                request.setAttribute("error", "❌ Thiếu thông tin bắt buộc! Vui lòng điền đầy đủ các trường.");
                try {
                    ProductCategoriesDAO cateDAO = new ProductCategoriesDAO();
                    request.setAttribute("categories", cateDAO.getAllCategories());
                    request.getRequestDispatcher("/views/seller/seller-add-product.jsp").forward(request, response);
                } catch (Exception ex) {
                    response.sendRedirect(request.getContextPath() + "/seller/products?error=missing_data");
                }
            } catch (Exception e) {
                e.printStackTrace();
                System.err.println("Exception in add product: " + e.getMessage());
                System.err.println("Exception type: " + e.getClass().getName());
                
                // Check if it's a SQLException or has SQLException as cause
                String errorMsg = "❌ Có lỗi xảy ra khi thêm sản phẩm: " + e.getMessage();
                if (e instanceof java.sql.SQLException) {
                    java.sql.SQLException sqlEx = (java.sql.SQLException) e;
                    System.err.println("SQLException - SQL State: " + sqlEx.getSQLState());
                    errorMsg = "❌ Lỗi database: " + sqlEx.getMessage();
                } else if (e.getCause() instanceof java.sql.SQLException) {
                    java.sql.SQLException sqlEx = (java.sql.SQLException) e.getCause();
                    System.err.println("SQLException (as cause) - SQL State: " + sqlEx.getSQLState());
                    errorMsg = "❌ Lỗi database: " + sqlEx.getMessage();
                }
                
                request.setAttribute("error", errorMsg);
                try {
                    ProductCategoriesDAO cateDAO = new ProductCategoriesDAO();
                    request.setAttribute("categories", cateDAO.getAllCategories());
                    request.getRequestDispatcher("/views/seller/seller-add-product.jsp").forward(request, response);
                } catch (Exception ex) {
                    System.err.println("Failed to forward to add product page: " + ex.getMessage());
                    response.sendRedirect(request.getContextPath() + "/seller/products?error=add_failed");
                }
            }
        }

        // 🟧 Cập nhật sản phẩm
        if ("/seller/products/update".equals(path)) {
            try {
                HttpSession session = request.getSession();
                Users seller = (Users) session.getAttribute("user");

                if (seller == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }

                long productId = Long.parseLong(request.getParameter("product_id"));
                
                // Kiểm tra quyền sở hữu
                Products existingProduct = productDAO.getProductById(productId);
                if (existingProduct == null || existingProduct.getSeller_id().getUser_id() != seller.getUser_id()) {
                    request.setAttribute("error", "❌ Sản phẩm không tồn tại hoặc bạn không có quyền chỉnh sửa!");
                    response.sendRedirect(request.getContextPath() + "/seller/products");
                    return;
                }

                // Lấy dữ liệu từ form
                String name = request.getParameter("name");
                String description = request.getParameter("description");
                BigDecimal price = new BigDecimal(request.getParameter("price"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                int categoryId = Integer.parseInt(request.getParameter("category_id"));
                String status = request.getParameter("status");
                Part imagePart = request.getPart("image");

                // Cập nhật thông tin sản phẩm
                existingProduct.setName(name);
                existingProduct.setDescription(description);
                existingProduct.setPrice(price);
                existingProduct.setQuantity(quantity);
                existingProduct.setStatus(status);
                existingProduct.setUpdated_at(new Timestamp(System.currentTimeMillis()));

                // Cập nhật category
                ProductCategories category = new ProductCategories();
                category.setCategory_id(categoryId);
                existingProduct.setCategory_id(category);

                // Cập nhật ảnh nếu có
                if (imagePart != null && imagePart.getSize() > 0) {
                    String submitted2 = imagePart.getSubmittedFileName();
                    String lower2 = submitted2 == null ? "" : submitted2.toLowerCase();
                    if (!(lower2.endsWith(".jpg") || lower2.endsWith(".jpeg") || lower2.endsWith(".png") || lower2.endsWith(".webp"))) {
                        request.setAttribute("error", "❌ Định dạng ảnh không hợp lệ (chỉ hỗ trợ JPG, PNG, WEBP)!");
                        request.getRequestDispatcher("/views/seller/seller-edit-product.jsp").forward(request, response);
                        return;
                    }
                    String uploadPath = request.getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "products";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }

                    String fileName = System.currentTimeMillis() + "_" + imagePart.getSubmittedFileName();
                    String filePath = uploadPath + File.separator + fileName;
                    imagePart.write(filePath);

                    String imageUrl = request.getContextPath() + "/uploads/products/" + fileName;

                    // Cập nhật ảnh chính
                    ProductImageDAO imageDAO = new ProductImageDAO();
                    imageDAO.updatePrimaryImage(productId, imageUrl, "Ảnh sản phẩm " + name);
                }

                // Lưu cập nhật
                boolean success = productDAO.updateProduct(existingProduct);
                
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/seller/products?success=update");
                } else {
                    request.setAttribute("error", "❌ Có lỗi xảy ra khi cập nhật sản phẩm!");
                    request.getRequestDispatcher("/views/seller/seller-edit-product.jsp").forward(request, response);
                }

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "❌ Có lỗi xảy ra khi cập nhật sản phẩm. Vui lòng thử lại!");
                response.sendRedirect(request.getContextPath() + "/seller/products");
            }
        }

        // 🟧 Xóa sản phẩm (soft delete)
        if ("/seller/products/delete".equals(path)) {
            try {
                HttpSession session = request.getSession();
                Users seller = (Users) session.getAttribute("user");

                if (seller == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }

                long productId = Long.parseLong(request.getParameter("id"));
                
                // Kiểm tra quyền sở hữu
                Products product = productDAO.getProductById(productId);
                if (product == null || product.getSeller_id().getUser_id() != seller.getUser_id()) {
                    request.setAttribute("error", "❌ Sản phẩm không tồn tại hoặc bạn không có quyền xóa!");
                    response.sendRedirect(request.getContextPath() + "/seller/products");
                    return;
                }

                // Thực hiện soft delete
                boolean success = productDAO.softDeleteProduct(productId);
                
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/seller/products?success=delete");
                } else {
                    request.setAttribute("error", "❌ Có lỗi xảy ra khi xóa sản phẩm!");
                    response.sendRedirect(request.getContextPath() + "/seller/products");
                }

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "❌ Có lỗi xảy ra khi xóa sản phẩm. Vui lòng thử lại!");
                response.sendRedirect(request.getContextPath() + "/seller/products");
            }
        }

        // 🟧 Thay đổi trạng thái sản phẩm
        if ("/seller/products/change-status".equals(path)) {
            try {
                HttpSession session = request.getSession();
                Users seller = (Users) session.getAttribute("user");

                if (seller == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }

                long productId = Long.parseLong(request.getParameter("id"));
                String newStatus = request.getParameter("status");
                
                // Kiểm tra quyền sở hữu
                Products product = productDAO.getProductById(productId);
                if (product == null || product.getSeller_id().getUser_id() != seller.getUser_id()) {
                    request.setAttribute("error", "❌ Sản phẩm không tồn tại hoặc bạn không có quyền thay đổi trạng thái!");
                    response.sendRedirect(request.getContextPath() + "/seller/products");
                    return;
                }

                // Cập nhật trạng thái
                product.setStatus(newStatus);
                product.setUpdated_at(new Timestamp(System.currentTimeMillis()));
                
                boolean success = productDAO.updateProduct(product);
                
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/seller/products?success=status");
                } else {
                    request.setAttribute("error", "❌ Có lỗi xảy ra khi thay đổi trạng thái sản phẩm!");
                    response.sendRedirect(request.getContextPath() + "/seller/products");
                }

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "❌ Có lỗi xảy ra khi thay đổi trạng thái sản phẩm. Vui lòng thử lại!");
                response.sendRedirect(request.getContextPath() + "/seller/products");
            }
        }

        // 🟧 Thao tác hàng loạt
        if ("/seller/products/bulk-action".equals(path)) {
            try {
                HttpSession session = request.getSession();
                Users seller = (Users) session.getAttribute("user");

                if (seller == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }

                String action = request.getParameter("action");
                String[] productIds = request.getParameterValues("product_ids");
                
                if (productIds == null || productIds.length == 0) {
                    request.setAttribute("error", "❌ Vui lòng chọn ít nhất một sản phẩm!");
                    response.sendRedirect(request.getContextPath() + "/seller/products");
                    return;
                }

                int successCount = 0;
                int totalCount = productIds.length;

                for (String productIdStr : productIds) {
                    try {
                        long productId = Long.parseLong(productIdStr);
                        
                        // Kiểm tra quyền sở hữu
                        Products product = productDAO.getProductById(productId);
                        if (product == null || product.getSeller_id().getUser_id() != seller.getUser_id()) {
                            continue; // Bỏ qua sản phẩm không thuộc về seller
                        }

                        boolean success = false;
                        switch (action) {
                            case "activate":
                                product.setStatus("active");
                                product.setUpdated_at(new Timestamp(System.currentTimeMillis()));
                                success = productDAO.updateProduct(product);
                                break;
                            case "deactivate":
                                product.setStatus("inactive");
                                product.setUpdated_at(new Timestamp(System.currentTimeMillis()));
                                success = productDAO.updateProduct(product);
                                break;
                            case "delete":
                                success = productDAO.softDeleteProduct(productId);
                                break;
                            case "draft":
                                product.setStatus("draft");
                                product.setUpdated_at(new Timestamp(System.currentTimeMillis()));
                                success = productDAO.updateProduct(product);
                                break;
                        }
                        
                        if (success) successCount++;
                    } catch (NumberFormatException e) {
                        // Bỏ qua ID không hợp lệ
                    }
                }

                String message = String.format("✅ Thành công: %d/%d sản phẩm được xử lý!", successCount, totalCount);
                response.sendRedirect(request.getContextPath() + "/seller/products?success=bulk&message=" + 
                    java.net.URLEncoder.encode(message, "UTF-8"));

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "❌ Có lỗi xảy ra khi thực hiện thao tác hàng loạt. Vui lòng thử lại!");
                response.sendRedirect(request.getContextPath() + "/seller/products");
            }
        }
    }
}
