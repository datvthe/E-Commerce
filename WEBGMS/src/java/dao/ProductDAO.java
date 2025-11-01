package dao;

import model.product.Products;
import model.product.ProductCategories;
import model.user.Users;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
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
                product.setStatus(rs.getString("status"));
                try { product.setQuantity(rs.getInt("quantity")); } catch (Exception ignore) {}
                product.setAverage_rating(rs.getDouble("average_rating"));
                product.setTotal_reviews(rs.getInt("total_reviews"));
                product.setCreated_at(rs.getTimestamp("created_at"));
                product.setUpdated_at(rs.getTimestamp("updated_at"));

                // Set category
                if (rs.getLong("category_id") > 0) {
                    ProductCategories category = new ProductCategories();
                    category.setCategory_id(rs.getLong("category_id"));
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
                product.setStatus(rs.getString("status"));
                try { product.setQuantity(rs.getInt("quantity")); } catch (Exception ignore) {}
                product.setAverage_rating(rs.getDouble("average_rating"));
                product.setTotal_reviews(rs.getInt("total_reviews"));
                product.setCreated_at(rs.getTimestamp("created_at"));
                product.setUpdated_at(rs.getTimestamp("updated_at"));

                // Set category
                if (rs.getLong("category_id") > 0) {
                    ProductCategories category = new ProductCategories();
                    category.setCategory_id(rs.getLong("category_id"));
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

        StringBuilder sql = new StringBuilder(
            "SELECT p.*, u.user_id, u.full_name, u.email, u.avatar_url " +
            "FROM Products p " +
            "LEFT JOIN Users u ON p.seller_id = u.user_id " +
            "WHERE p.status = 'active' AND p.deleted_at IS NULL"
        );

        // Filter by category
        if (category != null && !category.isEmpty()) {
            sql.append(" AND p.category_id = ?");
        }

        // Search by name
        if (search != null && !search.isEmpty()) {
            sql.append(" AND p.name LIKE ?");
        }

        // Sorting
        if ("priceAsc".equals(sort)) {
            sql.append(" ORDER BY p.price ASC");
        } else if ("priceDesc".equals(sort)) {
            sql.append(" ORDER BY p.price DESC");
        } else if ("rating".equals(sort)) {
            sql.append(" ORDER BY p.average_rating DESC");
        } else if ("newest".equals(sort)) {
            sql.append(" ORDER BY p.created_at DESC");
        } else {
            sql.append(" ORDER BY p.created_at DESC"); // Default
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

                // Set seller info
                if (rs.getInt("user_id") > 0) {
                    Users seller = new Users();
                    seller.setUser_id(rs.getInt("user_id"));
                    seller.setFull_name(rs.getString("full_name"));
                    seller.setEmail(rs.getString("email"));
                    seller.setAvatar_url(rs.getString("avatar_url"));
                    product.setSeller_id(seller);
                }

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
        String sql = "SELECT COUNT(*) FROM Products WHERE seller_id = ? AND deleted_at IS NULL";
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

    public int getProductCountBySeller(int sellerId) {
        return countBySeller(sellerId);
    }

    public int getProductCountBySellerWithStatus(int sellerId, String status) {
        String sql = "SELECT COUNT(*) FROM Products WHERE seller_id = ? AND status = ? AND deleted_at IS NULL";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sellerId);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Products> searchProductsBySeller(int sellerId, String keyword, String status, int categoryId) {
        List<Products> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT p.* FROM Products p WHERE p.deleted_at IS NULL AND p.seller_id = ? ");
        List<Object> params = new ArrayList<>();
        params.add(sellerId);
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (p.name LIKE ? OR p.description LIKE ?) ");
            String k = "%" + keyword.trim() + "%";
            params.add(k); params.add(k);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND p.status = ? ");
            params.add(status);
        }
        if (categoryId > 0) {
            sql.append("AND p.category_id = ? ");
            params.add(categoryId);
        }
        sql.append("ORDER BY p.created_at DESC");
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Object p : params) {
                if (p instanceof Integer) ps.setInt(idx++, (Integer) p);
                else if (p instanceof String) ps.setString(idx++, (String) p);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapProductLite(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Products> getProductsBySellerIdWithPagination(int sellerId, int page, int pageSize) {
        List<Products> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT p.* FROM Products p WHERE p.seller_id = ? AND p.deleted_at IS NULL ORDER BY p.created_at DESC LIMIT ? OFFSET ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sellerId);
            ps.setInt(2, pageSize);
            ps.setInt(3, offset);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapProductLite(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public long insertProductReturningId(Products p) {
        String sql = "INSERT INTO Products (seller_id, name, slug, description, price, currency, status, category_id, quantity, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            if (conn == null) {
                System.err.println("ERROR: Cannot get database connection in insertProductReturningId!");
                return -1;
            }
            
            // Validate seller
            if (p.getSeller_id() == null || p.getSeller_id().getUser_id() <= 0) {
                System.err.println("ERROR: Invalid seller_id in insertProductReturningId!");
                return -1;
            }
            
            ps.setInt(1, p.getSeller_id().getUser_id());
            ps.setString(2, p.getName());
            ps.setString(3, slugify(p.getName()));
            ps.setString(4, p.getDescription());
            ps.setBigDecimal(5, p.getPrice());
            ps.setString(6, p.getCurrency() == null ? "VND" : p.getCurrency());
            ps.setString(7, p.getStatus() == null ? "active" : p.getStatus());
            
            // Handle category_id - set NULL if not provided or invalid
            if (p.getCategory_id() != null && p.getCategory_id().getCategory_id() > 0) {
                ps.setLong(8, p.getCategory_id().getCategory_id());
            } else {
                ps.setNull(8, java.sql.Types.BIGINT);
            }
            
            ps.setInt(9, p.getQuantity());
            
            System.out.println("Inserting product: " + p.getName() + ", seller_id: " + p.getSeller_id().getUser_id());
            int affected = ps.executeUpdate();
            
            if (affected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    long productId = rs.getLong(1);
                    System.out.println("Product inserted successfully with ID: " + productId);
                    return productId;
                } else {
                    System.err.println("ERROR: No generated keys returned after insert!");
                }
            } else {
                System.err.println("ERROR: No rows affected by insert!");
            }
        } catch (SQLException e) {
            System.err.println("SQLException in insertProductReturningId: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Exception in insertProductReturningId: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    public boolean updateProduct(Products p) {
        String sql = "UPDATE Products SET name=?, description=?, price=?, currency=?, status=?, category_id=?, quantity=?, updated_at=CURRENT_TIMESTAMP WHERE product_id=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getName());
            ps.setString(2, p.getDescription());
            ps.setBigDecimal(3, p.getPrice());
            ps.setString(4, p.getCurrency() == null ? "VND" : p.getCurrency());
            ps.setString(5, p.getStatus());
            ps.setLong(6, p.getCategory_id() == null ? 0 : p.getCategory_id().getCategory_id());
            ps.setInt(7, p.getQuantity());
            ps.setLong(8, p.getProduct_id());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean softDeleteProduct(long productId) {
        String sql = "UPDATE Products SET status='inactive', deleted_at=CURRENT_TIMESTAMP WHERE product_id=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, productId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
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
    private Products mapProductLite(ResultSet rs) throws Exception {
        Products product = new Products();
        product.setProduct_id(rs.getLong("product_id"));
        product.setName(rs.getString("name"));
        product.setPrice(rs.getBigDecimal("price"));
        product.setCurrency(rs.getString("currency"));
        product.setStatus(rs.getString("status"));
        product.setCreated_at(rs.getTimestamp("created_at"));
        product.setUpdated_at(rs.getTimestamp("updated_at"));
        product.setQuantity(rs.getInt("quantity"));
        return product;
    }

    private String slugify(String input) {
        if (input == null) return null;
        String s = input.trim().toLowerCase();
        s = s.replaceAll("[^a-z0-9\s-]", "");
        s = s.replaceAll("\s+", "-");
        s = s.replaceAll("-+", "-");
        return s;
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

    // ===== Admin filter without forcing status = 'active' =====
    public List<Products> adminFilterProducts(int page, int pageSize, String search, String category, String status) {
        List<Products> products = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        StringBuilder sql = new StringBuilder("SELECT * FROM Products WHERE deleted_at IS NULL");
        List<Object> params = new ArrayList<>();
        if (category != null && !category.isEmpty()) { sql.append(" AND category_id = ?"); params.add(category); }
        if (search != null && !search.isEmpty()) { sql.append(" AND name LIKE ?"); params.add("%" + search + "%"); }
        if (status != null && !status.isEmpty() && !"all".equalsIgnoreCase(status)) { sql.append(" AND status = ?"); params.add(status); }
        sql.append(" ORDER BY created_at DESC LIMIT ? OFFSET ?");
        params.add(pageSize); params.add(offset);
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1; for (Object p : params) { if (p instanceof String) ps.setString(idx++, (String)p); else if (p instanceof Integer) ps.setInt(idx++, (Integer)p);}            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Products product = mapProductLite(rs);
                products.add(product);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return products;
    }
    public int adminCountFilteredProducts(String search, String category, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) AS total FROM Products WHERE deleted_at IS NULL");
        List<Object> params = new ArrayList<>();
        if (category != null && !category.isEmpty()) { sql.append(" AND category_id = ?"); params.add(category); }
        if (search != null && !search.isEmpty()) { sql.append(" AND name LIKE ?"); params.add("%" + search + "%"); }
        if (status != null && !status.isEmpty() && !"all".equalsIgnoreCase(status)) { sql.append(" AND status = ?"); params.add(status); }
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1; for (Object p : params) { if (p instanceof String) ps.setString(idx++, (String)p); }
            ResultSet rs = ps.executeQuery(); if (rs.next()) return rs.getInt("total");
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
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
