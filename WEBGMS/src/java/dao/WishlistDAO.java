package dao;

import model.user.Wishlist;
import model.product.Products;
import model.user.Users;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class for Wishlist operations
 */
public class WishlistDAO extends DBConnection {

    /**
     * Add product to wishlist
     */
    public boolean addToWishlist(int userId, long productId) {
        // Check if already exists
        if (isInWishlist(userId, productId)) {
            return false; // Already in wishlist
        }

        String sql = "INSERT INTO wishlist (user_id, product_id, added_at) "
                + "VALUES (?, ?, NOW())";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setLong(2, productId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Remove product from wishlist
     */
    public boolean removeFromWishlist(int userId, long productId) {
        String sql = "DELETE FROM wishlist WHERE user_id = ? AND product_id = ?";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setLong(2, productId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Check if product is in user's wishlist
     */
    public boolean isInWishlist(int userId, long productId) {
        String sql = "SELECT wishlist_id FROM wishlist "
                + "WHERE user_id = ? AND product_id = ?";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setLong(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get all wishlist items for a user with full product details
     */
    public List<Wishlist> getWishlistByUserId(int userId) {
        // Default to first 20 items to avoid heavy loads
        return getWishlistByUserIdPaged(userId, 20, 0);
    }

    /**
     * Paged wishlist items to reduce payload size
     */
    public List<Wishlist> getWishlistByUserIdPaged(int userId, int limit, int offset) {
        List<Wishlist> wishlistItems = new ArrayList<>();
        String sql = "SELECT w.wishlist_id, w.user_id, w.product_id, w.added_at, " +
                    "p.name, p.price, p.currency, p.slug, p.description, p.average_rating, p.total_reviews, " +
                    "pc.name as category_name, " +
                    "pi.url as image_url " +
                    "FROM wishlist w " +
                    "JOIN products p ON w.product_id = p.product_id " +
                    "LEFT JOIN product_categories pc ON p.category_id = pc.category_id " +
                    "LEFT JOIN product_images pi ON p.product_id = pi.product_id AND pi.is_primary = 1 " +
                    "WHERE w.user_id = ? AND p.status = 'active' " +
                    "ORDER BY w.added_at DESC " +
                    "LIMIT ? OFFSET ?";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, limit);
            ps.setInt(3, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Wishlist wishlist = new Wishlist();
                    wishlist.setWishlistId(rs.getInt("wishlist_id"));
                    
                    Users user = new Users();
                    user.setUser_id(userId);
                    wishlist.setUserId(user);
                    
                    Products product = new Products();
                    product.setProduct_id(rs.getLong("product_id"));
                    product.setName(rs.getString("name"));
                    product.setPrice(rs.getBigDecimal("price"));
                    product.setCurrency(rs.getString("currency"));
                    product.setSlug(rs.getString("slug"));
                    product.setDescription(rs.getString("description"));
                    product.setAverage_rating(rs.getDouble("average_rating"));
                    product.setTotal_reviews(rs.getInt("total_reviews"));
                    
                    if (rs.getString("category_name") != null) {
                        product.setCategory_name(rs.getString("category_name"));
                    }
                    if (rs.getString("image_url") != null) {
                        product.setImageUrl(rs.getString("image_url"));
                    }
                    
                    wishlist.setProductId(product);
                    wishlist.setAddedAt(rs.getTimestamp("added_at"));
                    wishlistItems.add(wishlist);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return wishlistItems;
    }

    /**
     * Get wishlist item count for a user
     */
    public int getWishlistItemCount(int userId) {
        int count = 0;
        String sql = "SELECT COUNT(*) as count FROM wishlist w " +
                    "JOIN products p ON w.product_id = p.product_id " +
                    "WHERE w.user_id = ? AND p.status = 'active'";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt("count");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
    
    /**
     * Clear all items from user's wishlist
     */
    public boolean clearWishlist(int userId) {
        String sql = "DELETE FROM wishlist WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Get wishlist summary statistics
     */
    public WishlistSummary getWishlistSummary(int userId) {
        WishlistSummary summary = new WishlistSummary();
        String sql = "SELECT COUNT(*) as total_items, " +
                    "SUM(p.price) as total_value, " +
                    "AVG(p.price) as avg_price " +
                    "FROM wishlist w " +
                    "JOIN products p ON w.product_id = p.product_id " +
                    "WHERE w.user_id = ? AND p.status = 'active'";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    summary.setTotalItems(rs.getInt("total_items"));
                    summary.setTotalValue(rs.getBigDecimal("total_value"));
                    summary.setAveragePrice(rs.getBigDecimal("avg_price"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return summary;
    }
    
    /**
     * Inner class for wishlist summary data
     */
    public static class WishlistSummary {
        private int totalItems;
        private java.math.BigDecimal totalValue;
        private java.math.BigDecimal averagePrice;
        
        // Getters and setters
        public int getTotalItems() { return totalItems; }
        public void setTotalItems(int totalItems) { this.totalItems = totalItems; }
        
        public java.math.BigDecimal getTotalValue() { return totalValue; }
        public void setTotalValue(java.math.BigDecimal totalValue) { this.totalValue = totalValue; }
        
        public java.math.BigDecimal getAveragePrice() { return averagePrice; }
        public void setAveragePrice(java.math.BigDecimal averagePrice) { this.averagePrice = averagePrice; }
    }
}
