package dao;

import model.product.Products;
import model.product.ProductCategories;
import model.user.Users;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.product.ProductImages;

/**
 * DAO class for Products operations
 */
public class ProductDAO extends DBConnection {

    /**
     * Get product by ID with full details
     */
    public Products getProductById(long productId) {
        Products product = null;
        String sql = "SELECT p.*, pc.category_id, pc.name as category_name, pc.slug as category_slug, "
                + "u.user_id, u.full_name, u.email, u.avatar_url "
                + "FROM Products p "
                + "LEFT JOIN Product_Categories pc ON p.category_id = pc.category_id "
                + "LEFT JOIN Users u ON p.seller_id = u.user_id "
                + "WHERE p.product_id = ? AND p.deleted_at IS NULL";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, productId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                product = new Products();
                product.setProduct_id(rs.getLong("product_id"));
                product.setName(rs.getString("name"));
                product.setSlug(rs.getString("slug"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getBigDecimal("price"));
                product.setCurrency(rs.getString("currency"));
                try { product.setQuantity(rs.getInt("quantity")); } catch (Exception ignored) {}
                product.setStatus(rs.getString("status"));
                product.setIs_digital(rs.getInt("is_digital"));
                product.setDelivery_time(rs.getString("delivery_time"));
                product.setAverage_rating(rs.getDouble("average_rating"));
                product.setTotal_reviews(rs.getInt("total_reviews"));
                product.setCreated_at(rs.getTimestamp("created_at"));
                product.setUpdated_at(rs.getTimestamp("updated_at"));

                // Set category
                if (rs.getLong("category_id") > 0) {
                    ProductCategories category = new ProductCategories();
                    category.setCategory_id(rs.getInt("category_id"));
                    category.setName(rs.getString("category_name"));
                    category.setSlug(rs.getString("category_slug"));
                    product.setCategory_id(category);
                }

                // Set seller
                if (rs.getInt("user_id") > 0) {
                    Users seller = new Users();
                    seller.setUser_id(rs.getInt("user_id"));
                    seller.setFull_name(rs.getString("full_name"));
                    seller.setEmail(rs.getString("email"));
                    seller.setAvatar_url(rs.getString("avatar_url"));
                    product.setSeller_id(seller);
                }
            }

        } catch (Exception e) {
            System.err.println("Error getting product by ID: " + productId + " - " + e.getMessage());
            e.printStackTrace();
        }
        return product;
    }

    /**
     * Get product by slug
     */
    public Products getProductBySlug(String slug) {
        Products product = null;
        String sql = "SELECT p.*, pc.category_id, pc.name as category_name, pc.slug as category_slug, "
                + "u.user_id, u.full_name, u.email, u.avatar_url "
                + "FROM Products p "
                + "LEFT JOIN Product_Categories pc ON p.category_id = pc.category_id "
                + "LEFT JOIN Users u ON p.seller_id = u.user_id "
                + "WHERE p.slug = ? AND p.deleted_at IS NULL";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, slug);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                product = new Products();
                product.setProduct_id(rs.getLong("product_id"));
                product.setName(rs.getString("name"));
                product.setSlug(rs.getString("slug"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getBigDecimal("price"));
                product.setCurrency(rs.getString("currency"));
                try { product.setQuantity(rs.getInt("quantity")); } catch (Exception ignored) {}
                product.setStatus(rs.getString("status"));
                product.setIs_digital(rs.getInt("is_digital"));
                product.setDelivery_time(rs.getString("delivery_time"));
                product.setAverage_rating(rs.getDouble("average_rating"));
                product.setTotal_reviews(rs.getInt("total_reviews"));
                product.setCreated_at(rs.getTimestamp("created_at"));
                product.setUpdated_at(rs.getTimestamp("updated_at"));

                // Set category
                if (rs.getInt("category_id") > 0) {
                    ProductCategories category = new ProductCategories();
                    category.setCategory_id(rs.getInt("category_id"));
                    category.setName(rs.getString("category_name"));
                    category.setSlug(rs.getString("category_slug"));
                    product.setCategory_id(category);
                }

                // Set seller
                if (rs.getInt("user_id") > 0) {
                    Users seller = new Users();
                    seller.setUser_id(rs.getInt("user_id"));
                    seller.setFull_name(rs.getString("full_name"));
                    seller.setEmail(rs.getString("email"));
                    seller.setAvatar_url(rs.getString("avatar_url"));
                    product.setSeller_id(seller);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return product;
    }

    /**
     * Get similar/recommended products based on category
     */
    public List<Products> getSimilarProducts(long productId, int categoryId, int limit) {
        List<Products> products = new ArrayList<>();
        String sql = "SELECT p.* FROM Products p "
                + "WHERE p.category_id = ? AND p.product_id != ? "
                + "AND p.status = 'active' AND p.deleted_at IS NULL "
                + "ORDER BY p.average_rating DESC, p.created_at DESC "
                + "LIMIT ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            ps.setLong(2, productId);
            ps.setInt(3, limit);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Products product = new Products();
                product.setProduct_id(rs.getLong("product_id"));
                product.setName(rs.getString("name"));
                product.setSlug(rs.getString("slug"));
                product.setPrice(rs.getBigDecimal("price"));
                product.setCurrency(rs.getString("currency"));
                product.setAverage_rating(rs.getDouble("average_rating"));
                product.setTotal_reviews(rs.getInt("total_reviews"));
                products.add(product);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return products;
    }

    /**
     * Get all active products with pagination
     */
    public List<Products> getAllProducts(int page, int pageSize) {
        List<Products> products = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        String sql = "SELECT * FROM Products "
                + "WHERE status = 'active' AND deleted_at IS NULL "
                + "ORDER BY created_at DESC "
                + "LIMIT ? OFFSET ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, pageSize);
            ps.setInt(2, offset);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Products product = new Products();
                product.setProduct_id(rs.getLong("product_id"));
                product.setName(rs.getString("name"));
                product.setSlug(rs.getString("slug"));
                product.setPrice(rs.getBigDecimal("price"));
                product.setCurrency(rs.getString("currency"));
                product.setAverage_rating(rs.getDouble("average_rating"));
                product.setTotal_reviews(rs.getInt("total_reviews"));
                products.add(product);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return products;
    }

    public List<Products> filterProducts(int page, int pageSize, String search, String category, String sort) {
        List<Products> products = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        StringBuilder sql = new StringBuilder("SELECT * FROM Products WHERE status = 'active' AND deleted_at IS NULL");

        // Filter by category
        if (category != null && !category.isEmpty()) {
            sql.append(" AND category_id = ?");
        }

        // Search by name
        if (search != null && !search.isEmpty()) {
            sql.append(" AND name LIKE ?");
        }

        // Sorting
        if ("priceAsc".equals(sort)) {
            sql.append(" ORDER BY price ASC");
        } else if ("priceDesc".equals(sort)) {
            sql.append(" ORDER BY price DESC");
        } else if ("rating".equals(sort)) {
            sql.append(" ORDER BY average_rating DESC");
        } else if ("newest".equals(sort)) {
            sql.append(" ORDER BY created_at DESC");
        } else {
            sql.append(" ORDER BY created_at DESC"); // Default
        }

        sql.append(" LIMIT ? OFFSET ?");

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;

            if (category != null && !category.isEmpty()) {
                ps.setString(paramIndex++, category);
            }

            if (search != null && !search.isEmpty()) {
                ps.setString(paramIndex++, "%" + search + "%");
            }

            ps.setInt(paramIndex++, pageSize);
            ps.setInt(paramIndex, offset);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Products product = new Products();
                product.setProduct_id(rs.getLong("product_id"));
                product.setName(rs.getString("name"));
                product.setSlug(rs.getString("slug"));
                product.setPrice(rs.getBigDecimal("price"));
                product.setCurrency(rs.getString("currency"));
                product.setAverage_rating(rs.getDouble("average_rating"));
                product.setTotal_reviews(rs.getInt("total_reviews"));

                List<ProductImages> images = getProductImages(conn, product.getProduct_id());
                product.setProductImages(images);

                products.add(product);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return products;
    }

    /**
     * Search products by keyword with optional category filter
     */
    public List<Products> searchProducts(String keyword, Long categoryId, int page, int pageSize) {
        List<Products> products = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        String sql = "SELECT * FROM Products "
                + "WHERE (name LIKE ? OR description LIKE ?) "
                + "AND status = 'active' AND deleted_at IS NULL ";
        
        if (categoryId != null) {
            sql += "AND category_id = ? ";
        }
        
        sql += "ORDER BY created_at DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            
            int paramIndex = 3;
            if (categoryId != null) {
                ps.setLong(paramIndex++, categoryId);
            }
            
            ps.setInt(paramIndex++, pageSize);
            ps.setInt(paramIndex, offset);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Products product = new Products();
                product.setProduct_id(rs.getLong("product_id"));
                product.setName(rs.getString("name"));
                product.setSlug(rs.getString("slug"));
                product.setPrice(rs.getBigDecimal("price"));
                product.setCurrency(rs.getString("currency"));
                product.setAverage_rating(rs.getDouble("average_rating"));
                product.setTotal_reviews(rs.getInt("total_reviews"));
                products.add(product);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return products;
    }
    
    /**
     * Get products by category with pagination
     */
    public List<Products> getProductsByCategory(Long categoryId, int page, int pageSize) {
        List<Products> products = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        String sql = "SELECT * FROM Products "
                + "WHERE category_id = ? AND status = 'active' AND deleted_at IS NULL "
                + "ORDER BY created_at DESC "
                + "LIMIT ? OFFSET ?";
        
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, categoryId);
            ps.setInt(2, pageSize);
            ps.setInt(3, offset);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Products product = new Products();
                product.setProduct_id(rs.getLong("product_id"));
                product.setName(rs.getString("name"));
                product.setSlug(rs.getString("slug"));
                product.setPrice(rs.getBigDecimal("price"));
                product.setCurrency(rs.getString("currency"));
                product.setAverage_rating(rs.getDouble("average_rating"));
                product.setTotal_reviews(rs.getInt("total_reviews"));
                products.add(product);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return products;
    }

    /**
     * Check if there are any products in the database
     */
    public boolean hasProducts() {
        String sql = "SELECT COUNT(*) as count FROM Products WHERE deleted_at IS NULL";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int count = rs.getInt("count");
                System.out.println("Total products in database: " + count);
                return count > 0;
            }

        } catch (Exception e) {
            System.err.println("Error checking products count: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public int countBySeller(int sellerId) {
        String sql = "SELECT COUNT(*) FROM Products WHERE seller_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sellerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get total product count
     */
    public int getTotalProductCount() {
        String sql = "SELECT COUNT(*) as count FROM Products WHERE deleted_at IS NULL";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("count");
            }

        } catch (Exception e) {
            System.err.println("Error getting product count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public int countFilteredProducts(String search, String category) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) AS total FROM Products WHERE status = 'active' AND deleted_at IS NULL");

        if (category != null && !category.isEmpty()) {
            sql.append(" AND category_id = ?");
        }

        if (search != null && !search.isEmpty()) {
            sql.append(" AND name LIKE ?");
        }

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;

            if (category != null && !category.isEmpty()) {
                ps.setString(paramIndex++, category);
            }

            if (search != null && !search.isEmpty()) {
                ps.setString(paramIndex++, "%" + search + "%");
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public List<ProductCategories> getAllCategories() {
        List<ProductCategories> categories = new ArrayList<>();
        String sql = "SELECT * FROM product_categories";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductCategories category = new ProductCategories();
                category.setCategory_id(rs.getLong("category_id"));
                //category.setParent_id(rs.getLong("parent_id"));
                category.setName(rs.getString("name"));
                category.setDescription(rs.getString("description"));
                category.setSlug(rs.getString("slug"));
                category.setUpdated_at(rs.getTimestamp("updated_at"));
                category.setCreated_at(rs.getTimestamp("created_at"));
                categories.add(category);
            }
        } catch (Exception e) {
            System.err.println("Error getting categories: " + e.getMessage());
            e.printStackTrace();
        }
        return categories;
    }

    private List<ProductImages> getProductImages(Connection conn, long productId) throws SQLException {
        List<ProductImages> images = new ArrayList<>();
        String sql = "SELECT * FROM product_images WHERE product_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductImages img = new ProductImages();
                img.setImage_id(rs.getInt("image_id"));
                img.setUrl(rs.getString("url"));
                img.setAlt_text(rs.getString("alt_text"));
                img.setIs_primary(rs.getBoolean("is_primary"));
                images.add(img);
            }
        }
        return images;
    }

}
