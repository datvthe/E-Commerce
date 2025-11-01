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
    
    /**
     * ✨ SYNC INVENTORY FROM DIGITAL_GOODS_CODES
     * Cập nhật hoặc tạo mới inventory records dựa trên số lượng codes còn
     * Nên chạy định kỳ hoặc sau khi có thay đổi về digital_goods_codes
     */
    public void syncInventoryFromDigitalCodes() {
        DigitalGoodsCodeDAO digitalDAO = new DigitalGoodsCodeDAO();
        ProductDAO productDAO = new ProductDAO();
        
        System.out.println("🔄 Starting inventory sync from digital_goods_codes...");
        
        // 1. Lấy số lượng codes available cho tất cả products
        java.util.Map<Long, Integer> productCounts = digitalDAO.countAllAvailableCodes();
        
        if (productCounts.isEmpty()) {
            System.out.println("⚠️ No digital products found with available codes");
            return;
        }
        
        // 2. Chuẩn bị SQL để INSERT hoặc UPDATE
        // MySQL: ON DUPLICATE KEY UPDATE
        String sql = "INSERT INTO inventory (product_id, seller_id, quantity, reserved_quantity, min_threshold, last_restocked_at) " +
                    "VALUES (?, ?, ?, 0, 5, NOW()) " +
                    "ON DUPLICATE KEY UPDATE " +
                    "quantity = VALUES(quantity), " +
                    "last_restocked_at = NOW()";
        
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            
            int successCount = 0;
            int failCount = 0;
            
            // 3. Loop qua từng product và INSERT/UPDATE
            for (java.util.Map.Entry<Long, Integer> entry : productCounts.entrySet()) {
                Long productId = entry.getKey();
                Integer quantity = entry.getValue();
                
                try {
                    // Lấy seller_id từ products
                    Products product = productDAO.getProductById(productId);
                    if (product == null) {
                        System.out.println("⚠️ Product not found: " + productId);
                        failCount++;
                        continue;
                    }
                    
                    Long sellerId = Long.valueOf(product.getSeller_id().getUser_id());
                    
                    ps.setLong(1, productId);
                    ps.setLong(2, sellerId);
                    ps.setInt(3, quantity);
                    
                    ps.addBatch();
                    successCount++;
                    
                    System.out.println("  ✓ Product " + productId + ": " + quantity + " codes");
                    
                } catch (Exception e) {
                    System.err.println("  ✗ Failed to sync product " + productId + ": " + e.getMessage());
                    failCount++;
                }
            }
            
            // 4. Execute batch
            if (successCount > 0) {
                int[] results = ps.executeBatch();
                System.out.println("✅ Sync completed: " + successCount + " products synced, " + failCount + " failed");
            } else {
                System.out.println("⚠️ No products to sync");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error syncing inventory: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    
    /**
     * Sync inventory cho 1 product cụ thể
     * Dùng khi cần update ngay sau khi thêm/bán codes
     */
    public boolean syncInventoryForProduct(Long productId) {
        DigitalGoodsCodeDAO digitalDAO = new DigitalGoodsCodeDAO();
        ProductDAO productDAO = new ProductDAO();
        
        // Đếm số codes available
        int availableCount = digitalDAO.countAvailableCodes(productId);
        
        // Lấy seller_id
        Products product = productDAO.getProductById(productId);
        if (product == null) {
            System.err.println("❌ Product not found: " + productId);
            return false;
        }
        
        Long sellerId = Long.valueOf(product.getSeller_id().getUser_id());
        
        String sql = "INSERT INTO inventory (product_id, seller_id, quantity, reserved_quantity, min_threshold, last_restocked_at) " +
                    "VALUES (?, ?, ?, 0, 5, NOW()) " +
                    "ON DUPLICATE KEY UPDATE " +
                    "quantity = ?, " +
                    "last_restocked_at = NOW()";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, productId);
            ps.setLong(2, sellerId);
            ps.setInt(3, availableCount);
            ps.setInt(4, availableCount); // Cho UPDATE clause
            
            int affected = ps.executeUpdate();
            
            if (affected > 0) {
                System.out.println("✅ Synced inventory for product " + productId + ": " + availableCount + " codes");
                return true;
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error syncing inventory for product " + productId + ": " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
}
