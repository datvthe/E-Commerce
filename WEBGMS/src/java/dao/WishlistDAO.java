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

        String sql = "INSERT INTO Wishlist (user_id, product_id, added_at) "
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
        String sql = "DELETE FROM Wishlist WHERE user_id = ? AND product_id = ?";

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
        String sql = "SELECT wishlist_id FROM Wishlist "
                + "WHERE user_id = ? AND product_id = ?";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setLong(2, productId);
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get all wishlist items for a user
     */
    public List<Wishlist> getWishlistByUserId(int userId) {
        List<Wishlist> wishlistItems = new ArrayList<>();
        String sql = "SELECT w.*, p.product_id, p.name, p.price, p.currency, p.slug, p.average_rating "
                + "FROM Wishlist w "
                + "JOIN Products p ON w.product_id = p.product_id "
                + "WHERE w.user_id = ? "
                + "ORDER BY w.added_at DESC";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

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
                product.setAverage_rating(rs.getDouble("average_rating"));
                wishlist.setProductId(product);
                
                wishlist.setAddedAt(rs.getTimestamp("added_at"));
                wishlistItems.add(wishlist);
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
        String sql = "SELECT COUNT(*) as count FROM Wishlist WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt("count");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
}

