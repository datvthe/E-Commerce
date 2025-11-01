package dao;

import model.order.DigitalGoodsCode;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO cho bảng digital_goods_codes
 * Quản lý các mã digital (thẻ cào, tài khoản, key...)
 */
public class DigitalGoodsCodeDAO extends DBConnection {
    
    /**
     * Đếm số lượng codes còn available cho 1 product (is_used = 0)
     * @param productId ID sản phẩm
     * @return Số lượng codes chưa sử dụng
     */
    public int countAvailableCodes(Long productId) {
        String sql = "SELECT COUNT(*) FROM digital_goods_codes " +
                    "WHERE product_id = ? AND is_used = 0";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, productId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ Error counting available codes: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Lấy số lượng codes available cho TẤT CẢ products
     * @return Map<product_id, count>
     */
    public Map<Long, Integer> countAllAvailableCodes() {
        Map<Long, Integer> productCounts = new HashMap<>();
        
        String sql = "SELECT product_id, COUNT(*) as count " +
                    "FROM digital_goods_codes " +
                    "WHERE is_used = 0 " +
                    "GROUP BY product_id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Long productId = rs.getLong("product_id");
                Integer count = rs.getInt("count");
                productCounts.put(productId, count);
            }
            
            System.out.println("📊 Found " + productCounts.size() + " digital products with available codes");
            
        } catch (SQLException e) {
            System.err.println("❌ Error counting all available codes: " + e.getMessage());
            e.printStackTrace();
        }
        
        return productCounts;
    }
    
    /**
     * Kiểm tra xem product có phải là digital goods không
     * (có ít nhất 1 code trong digital_goods_codes)
     */
    public boolean isDigitalProduct(Long productId) {
        String sql = "SELECT COUNT(*) FROM digital_goods_codes WHERE product_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, productId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * ✨ Lấy N digital codes available và LOCK (FOR UPDATE)
     * Dùng trong TRANSACTION để tránh race condition
     */
    public List<DigitalGoodsCode> getAvailableCodesWithLock(Long productId, int quantity, Connection conn) throws SQLException {
        List<DigitalGoodsCode> codes = new ArrayList<>();
        
        String sql = "SELECT * FROM digital_goods_codes " +
                    "WHERE product_id = ? AND is_used = 0 " +
                    "ORDER BY code_id ASC " +
                    "LIMIT ? " +
                    "FOR UPDATE"; // LOCK để tránh 2 user mua cùng 1 mã
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, productId);
            ps.setInt(2, quantity);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    codes.add(extractCodeFromResultSet(rs));
                }
            }
        }
        
        System.out.println("🔒 Locked " + codes.size() + " codes for product " + productId);
        
        return codes;
    }
    
    /**
     * ✨ Đánh dấu code đã sử dụng
     */
    public boolean markCodeAsUsed(Integer codeId, Long userId, Connection conn) throws SQLException {
        String sql = "UPDATE digital_goods_codes " +
                    "SET is_used = 1, " +
                    "used_by = ?, " +
                    "used_at = NOW() " +
                    "WHERE code_id = ? AND is_used = 0";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setInt(2, codeId);
            
            int affected = ps.executeUpdate();
            
            if (affected > 0) {
                System.out.println("  ✓ Marked code " + codeId + " as used by user " + userId);
                return true;
            }
        }
        
        return false;
    }
    
    /**
     * Lấy codes đã mua của user trong 1 order
     */
    public List<DigitalGoodsCode> getCodesByUserId(Long userId, Long productId) {
        List<DigitalGoodsCode> codes = new ArrayList<>();
        
        String sql = "SELECT * FROM digital_goods_codes " +
                    "WHERE used_by = ? AND product_id = ? " +
                    "ORDER BY used_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, userId);
            ps.setLong(2, productId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    codes.add(extractCodeFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return codes;
    }
    
    /**
     * Extract DigitalGoodsCode từ ResultSet
     */
    private DigitalGoodsCode extractCodeFromResultSet(ResultSet rs) throws SQLException {
        DigitalGoodsCode code = new DigitalGoodsCode();
        
        code.setCodeId(rs.getInt("code_id"));
        code.setProductId(rs.getLong("product_id"));
        code.setCodeValue(rs.getString("code_value"));
        code.setCodeType(rs.getString("code_type"));
        code.setIsUsed(rs.getBoolean("is_used"));
        
        // Handle nullable fields
        Long usedBy = rs.getObject("used_by", Long.class);
        code.setUsedBy(usedBy);
        
        code.setUsedAt(rs.getTimestamp("used_at"));
        code.setExpiresAt(rs.getTimestamp("expires_at"));
        code.setCreatedAt(rs.getTimestamp("created_at"));
        code.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        return code;
    }
}

