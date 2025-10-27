package dao;

import model.product.Inventory;
import model.product.Products;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * DAO class for Inventory operations
 */
public class InventoryDAO extends DBConnection {

    /**
     * Get inventory by product ID
     */
    public Inventory getInventoryByProductId(long productId) {
        Inventory inventory = null;
        String sql = "SELECT * FROM Inventory WHERE product_id = ?";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    inventory = new Inventory();
                    inventory.setInventory_id(rs.getInt("inventory_id"));
                    
                    Products product = new Products();
                    product.setProduct_id(productId);
                    inventory.setProduct_id(product);
                    
                    inventory.setQuantity(rs.getInt("quantity"));
                    inventory.setReserved_quantity(rs.getInt("reserved_quantity"));
                    inventory.setMin_threshold(rs.getInt("min_threshold"));
                    inventory.setLast_restocked_at(rs.getTimestamp("last_restocked_at"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return inventory;
    }

    /**
     * Get available quantity (quantity - reserved_quantity)
     */
    public int getAvailableQuantity(long productId) {
        int available = 0;
        String sql = "SELECT (quantity - reserved_quantity) as available "
                + "FROM Inventory WHERE product_id = ?";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    available = rs.getInt("available");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return Math.max(0, available);
    }

    /**
     * Reserve quantity for cart/order
     */
    public boolean reserveQuantity(long productId, int quantity) {
        String sql = "UPDATE Inventory "
                + "SET reserved_quantity = reserved_quantity + ? "
                + "WHERE product_id = ? "
                + "AND (quantity - reserved_quantity) >= ?";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quantity);
            ps.setLong(2, productId);
            ps.setInt(3, quantity);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
