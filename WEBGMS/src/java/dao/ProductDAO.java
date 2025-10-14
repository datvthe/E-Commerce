package dao;

import model.product.Products;
import model.product.ProductCategories;
import model.user.Users;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

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

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

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

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

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

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

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

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

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

    /**
     * Check if there are any products in the database
     */
    public boolean hasProducts() {
        String sql = "SELECT COUNT(*) as count FROM Products WHERE deleted_at IS NULL";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
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

    /**
     * Get total product count
     */
    public int getTotalProductCount() {
        String sql = "SELECT COUNT(*) as count FROM Products WHERE deleted_at IS NULL";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
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
}

