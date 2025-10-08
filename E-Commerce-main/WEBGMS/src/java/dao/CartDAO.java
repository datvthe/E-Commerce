package dao;

import model.order.Cart;
import model.product.Products;
import model.user.Users;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class for Cart operations
 */
public class CartDAO extends DBConnection {

    /**
     * Add item to cart or update quantity if exists
     */
    public boolean addToCart(int userId, long productId, int quantity) {
        // Check if item already exists in cart
        String checkSql = "SELECT cart_id, quantity FROM Cart "
                + "WHERE user_id = ? AND product_id = ?";
        
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement checkPs = conn.prepareStatement(checkSql)) {

            checkPs.setInt(1, userId);
            checkPs.setLong(2, productId);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                // Update existing cart item
                int cartId = rs.getInt("cart_id");
                int currentQuantity = rs.getInt("quantity");
                String updateSql = "UPDATE Cart SET quantity = ?, updated_at = NOW() "
                        + "WHERE cart_id = ?";
                
                try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                    updatePs.setInt(1, currentQuantity + quantity);
                    updatePs.setInt(2, cartId);
                    return updatePs.executeUpdate() > 0;
                }
            } else {
                // Insert new cart item
                String insertSql = "INSERT INTO Cart (user_id, product_id, quantity, added_at, updated_at) "
                        + "VALUES (?, ?, ?, NOW(), NOW())";
                
                try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                    insertPs.setInt(1, userId);
                    insertPs.setLong(2, productId);
                    insertPs.setInt(3, quantity);
                    return insertPs.executeUpdate() > 0;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get all cart items for a user
     */
    public List<Cart> getCartByUserId(int userId) {
        List<Cart> cartItems = new ArrayList<>();
        String sql = "SELECT c.*, p.product_id, p.name, p.price, p.currency, p.slug "
                + "FROM Cart c "
                + "JOIN Products p ON c.product_id = p.product_id "
                + "WHERE c.user_id = ? "
                + "ORDER BY c.updated_at DESC";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Cart cart = new Cart();
                cart.setCartId(rs.getInt("cart_id"));
                
                Users user = new Users();
                user.setUser_id(userId);
                cart.setUserId(user);
                
                Products product = new Products();
                product.setProduct_id(rs.getLong("product_id"));
                product.setName(rs.getString("name"));
                product.setPrice(rs.getBigDecimal("price"));
                product.setCurrency(rs.getString("currency"));
                product.setSlug(rs.getString("slug"));
                cart.setProductId(product);
                
                cart.setQuantity(rs.getInt("quantity"));
                cart.setAddedAt(rs.getTimestamp("added_at"));
                cart.setUpdatedAt(rs.getTimestamp("updated_at"));
                cartItems.add(cart);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return cartItems;
    }

    /**
     * Update cart item quantity
     */
    public boolean updateCartQuantity(int cartId, int quantity) {
        String sql = "UPDATE Cart SET quantity = ?, updated_at = NOW() WHERE cart_id = ?";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quantity);
            ps.setInt(2, cartId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Remove item from cart
     */
    public boolean removeFromCart(int cartId) {
        String sql = "DELETE FROM Cart WHERE cart_id = ?";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, cartId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Clear all cart items for a user
     */
    public boolean clearCart(int userId) {
        String sql = "DELETE FROM Cart WHERE user_id = ?";

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
     * Get cart item count for a user
     */
    public int getCartItemCount(int userId) {
        int count = 0;
        String sql = "SELECT COUNT(*) as count FROM Cart WHERE user_id = ?";

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

