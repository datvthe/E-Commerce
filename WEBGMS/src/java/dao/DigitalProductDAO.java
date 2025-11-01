package dao;

import model.order.DigitalProduct;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DigitalProductDAO - Quản lý kho tài nguyên số
 * (Mã thẻ cào, tài khoản game, serial key, v.v.)
 */
public class DigitalProductDAO extends DBConnection {
    
    /**
     * Kiểm tra số lượng sản phẩm digital còn available
     * Ưu tiên bảng digital_products; nếu chưa có, fallback sang digital_goods_codes;
     * cuối cùng fallback về products.quantity để không chặn mua trong môi trường demo.
     */
    public int getAvailableStock(Long productId) {
        // 1) Try new table: digital_products
        String sql1 = "SELECT COUNT(*) FROM digital_products WHERE product_id = ? AND status = 'AVAILABLE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql1)) {
            ps.setLong(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int c = rs.getInt(1);
                    if (c > 0) return c;
                }
            }
        } catch (SQLException ignore) { /* may not exist yet */ }

        // 2) Fallback: legacy table digital_goods_codes (is_used = 0)
        String sql2 = "SELECT COUNT(*) FROM digital_goods_codes WHERE product_id = ? AND is_used = 0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql2)) {
            ps.setLong(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int c = rs.getInt(1);
                    if (c > 0) return c;
                }
            }
        } catch (SQLException ignore) { /* table may not exist */ }

        // 3) Try Inventory available (quantity - reserved_quantity)
        String sql3 = "SELECT (quantity - reserved_quantity) AS avail FROM Inventory WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql3)) {
            ps.setLong(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int c = rs.getInt(1);
                    if (c > 0) return c;
                }
            }
        } catch (SQLException ignore) {}

        // 4) Last resort: products.quantity
        String sql4 = "SELECT COALESCE(quantity,0) FROM products WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql4)) {
            ps.setLong(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException ignore) {}

        return 0;
    }
    
    /**
     * Lấy N digital products available (để bán)
     * Sử dụng FOR UPDATE để lock rows, tránh race condition
     */
    public List<DigitalProduct> getAvailableProducts(Long productId, int quantity, Connection conn) throws SQLException {
        List<DigitalProduct> products = new ArrayList<>();
        
        String sql = "SELECT * FROM digital_products " +
                    "WHERE product_id = ? AND status = 'AVAILABLE' " +
                    "ORDER BY digital_id ASC " +
                    "LIMIT ? " +
                    "FOR UPDATE SKIP LOCKED"; // Lock và bỏ qua row đang bị lock để tránh chờ/timeout
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, productId);
            ps.setInt(2, quantity);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(extractDigitalProductFromResultSet(rs));
                }
            }
        }
        
        return products;
    }
    
    /**
     * Đánh dấu digital product là đã bán
     */
    public boolean markAsSold(Long digitalId, Long userId, Long orderId, Connection conn) throws SQLException {
        String sql = "UPDATE digital_products " +
                    "SET status = 'SOLD', " +
                    "sold_to_user_id = ?, " +
                    "sold_in_order_id = ?, " +
                    "sold_at = NOW() " +
                    "WHERE digital_id = ? AND status = 'AVAILABLE'";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setLong(2, orderId);
            ps.setLong(3, digitalId);
            
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Lấy digital products đã mua của user trong 1 order
     */
    public List<DigitalProduct> getDigitalProductsByOrderId(Long orderId) {
        List<DigitalProduct> products = new ArrayList<>();
        
        String sql = "SELECT dp.*, p.name as product_name " +
                    "FROM order_digital_items odi " +
                    "JOIN digital_products dp ON odi.digital_id = dp.digital_id " +
                    "LEFT JOIN products p ON dp.product_id = p.product_id " +
                    "WHERE odi.order_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, orderId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DigitalProduct dp = extractDigitalProductFromResultSet(rs);
                    dp.setProductName(rs.getString("product_name"));
                    products.add(dp);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return products;
    }
    
    /**
     * Liên kết digital product với order
     */
    public boolean linkDigitalProductToOrder(Long orderId, Long digitalId, Connection conn) throws SQLException {
        String sql = "INSERT INTO order_digital_items (order_id, digital_id) VALUES (?, ?)";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            ps.setLong(2, digitalId);
            
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Thêm digital product mới vào kho (admin/seller)
     */
    public boolean addDigitalProduct(DigitalProduct digitalProduct) {
        String sql = "INSERT INTO digital_products " +
                    "(product_id, code, password, serial, additional_info, status, expires_at) " +
                    "VALUES (?, ?, ?, ?, ?, 'AVAILABLE', ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, digitalProduct.getProductId());
            ps.setString(2, digitalProduct.getCode());
            ps.setString(3, digitalProduct.getPassword());
            ps.setString(4, digitalProduct.getSerial());
            ps.setString(5, digitalProduct.getAdditionalInfo());
            ps.setTimestamp(6, digitalProduct.getExpiresAt());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Lấy tất cả digital products theo productId (admin)
     */
    public List<DigitalProduct> getAllByProductId(Long productId) {
        List<DigitalProduct> products = new ArrayList<>();
        
        String sql = "SELECT * FROM digital_products " +
                    "WHERE product_id = ? " +
                    "ORDER BY status ASC, digital_id DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, productId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(extractDigitalProductFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return products;
    }
    
    /**
     * Extract DigitalProduct từ ResultSet
     */
    private DigitalProduct extractDigitalProductFromResultSet(ResultSet rs) throws SQLException {
        DigitalProduct dp = new DigitalProduct();
        
        dp.setDigitalId(rs.getLong("digital_id"));
        dp.setProductId(rs.getLong("product_id"));
        dp.setCode(rs.getString("code"));
        dp.setPassword(rs.getString("password"));
        dp.setSerial(rs.getString("serial"));
        dp.setAdditionalInfo(rs.getString("additional_info"));
        dp.setStatus(rs.getString("status"));
        dp.setSoldToUserId(rs.getObject("sold_to_user_id") != null ? rs.getLong("sold_to_user_id") : null);
        dp.setSoldInOrderId(rs.getObject("sold_in_order_id") != null ? rs.getLong("sold_in_order_id") : null);
        dp.setSoldAt(rs.getTimestamp("sold_at"));
        dp.setExpiresAt(rs.getTimestamp("expires_at"));
        dp.setCreatedAt(rs.getTimestamp("created_at"));
        
        return dp;
    }
}

