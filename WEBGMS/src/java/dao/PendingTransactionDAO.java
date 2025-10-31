package dao;

import model.transaction.PendingTransaction;
import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * PendingTransactionDAO - Quản lý giao dịch pending
 */
public class PendingTransactionDAO extends DBConnection {
    
    /**
     * Tạo pending transaction mới
     */
    public Long createPendingTransaction(Connection conn, Long orderId, Integer buyerId, Integer sellerId,
                                         BigDecimal totalAmount, int holdDays, Long transactionId) throws SQLException {
        
        // Tính seller amount (95%) và platform fee (5%)
        BigDecimal sellerAmount = totalAmount.multiply(new BigDecimal("0.95"));
        BigDecimal platformFee = totalAmount.multiply(new BigDecimal("0.05"));
        
        String sql = "INSERT INTO pending_transactions " +
                    "(order_id, buyer_id, seller_id, total_amount, seller_amount, platform_fee, " +
                    "status, hold_until, transaction_id, notes) " +
                    "VALUES (?, ?, ?, ?, ?, ?, 'PENDING', DATE_ADD(NOW(), INTERVAL ? DAY), ?, ?)";
        
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, orderId);
            ps.setInt(2, buyerId);
            ps.setInt(3, sellerId);
            ps.setBigDecimal(4, totalAmount);
            ps.setBigDecimal(5, sellerAmount);
            ps.setBigDecimal(6, platformFee);
            ps.setInt(7, holdDays);
            ps.setLong(8, transactionId);
            ps.setString(9, String.format("Hold %d days. Seller: %.2f (95%%), Fee: %.2f (5%%)", 
                                         holdDays, sellerAmount.doubleValue(), platformFee.doubleValue()));
            
            int affected = ps.executeUpdate();
            
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getLong(1);
                    }
                }
            }
        }
        
        return null;
    }
    
    /**
     * Lấy pending transactions cần xử lý (đã hết thời gian hold)
     */
    public List<PendingTransaction> getPendingTransactionsToProcess() {
        List<PendingTransaction> list = new ArrayList<>();
        
        String viewSql = "SELECT * FROM pending_transactions_to_process";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(viewSql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                list.add(extractPendingTransaction(rs));
            }
        } catch (SQLException e) {
            // Fallback when the VIEW doesn't exist: query base table with joins
            boolean isMissing = false;
            try {
                String state = e.getSQLState();
                int code = e.getErrorCode();
                isMissing = ("42S02".equals(state) || code == 1146 || e.getMessage().toLowerCase().contains("doesn't exist"));
            } catch (Exception ignore) {}
            if (!isMissing) {
                e.printStackTrace();
                return list;
            }
            
            String fallbackSql = "SELECT pt.*, b.email as buyer_email, b.full_name as buyer_name, " +
                                 "s.email as seller_email, s.full_name as seller_name, " +
                                 "o.order_number, o.product_id " +
                                 "FROM pending_transactions pt " +
                                 "LEFT JOIN users b ON pt.buyer_id = b.user_id " +
                                 "LEFT JOIN users s ON pt.seller_id = s.user_id " +
                                 "LEFT JOIN orders o ON pt.order_id = o.order_id " +
                                 "WHERE pt.status = 'PENDING' AND pt.hold_until <= NOW() " +
                                 "ORDER BY pt.hold_until ASC";
            
            try (Connection conn = getConnection();
                 PreparedStatement ps = conn.prepareStatement(fallbackSql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractPendingTransaction(rs));
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        
        return list;
    }
    
    /**
     * Lấy pending transactions của seller
     */
    public List<PendingTransaction> getPendingBySellerId(Integer sellerId) {
        List<PendingTransaction> list = new ArrayList<>();
        
        String sql = "SELECT pt.*, o.order_number, b.full_name as buyer_name " +
                    "FROM pending_transactions pt " +
                    "LEFT JOIN orders o ON pt.order_id = o.order_id " +
                    "LEFT JOIN users b ON pt.buyer_id = b.user_id " +
                    "WHERE pt.seller_id = ? " +
                    "ORDER BY pt.created_at DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, sellerId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractPendingTransaction(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return list;
    }
    
    /**
     * Lấy pending transactions của buyer
     */
    public List<PendingTransaction> getPendingByBuyerId(Integer buyerId) {
        List<PendingTransaction> list = new ArrayList<>();
        
        String sql = "SELECT pt.*, o.order_number, s.full_name as seller_name " +
                    "FROM pending_transactions pt " +
                    "LEFT JOIN orders o ON pt.order_id = o.order_id " +
                    "LEFT JOIN users s ON pt.seller_id = s.user_id " +
                    "WHERE pt.buyer_id = ? " +
                    "ORDER BY pt.created_at DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, buyerId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractPendingTransaction(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return list;
    }
    
    /**
     * Cập nhật trạng thái pending transaction
     */
    public boolean updateStatus(Long pendingId, String status, Long sellerTransactionId, Long adminTransactionId) {
        String sql = "UPDATE pending_transactions " +
                    "SET status = ?, seller_transaction_id = ?, admin_transaction_id = ?, " +
                    "released_at = IF(? = 'COMPLETED', NOW(), released_at) " +
                    "WHERE pending_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            
            if (sellerTransactionId != null) {
                ps.setLong(2, sellerTransactionId);
            } else {
                ps.setNull(2, Types.BIGINT);
            }
            
            if (adminTransactionId != null) {
                ps.setLong(3, adminTransactionId);
            } else {
                ps.setNull(3, Types.BIGINT);
            }
            
            ps.setString(4, status);
            ps.setLong(5, pendingId);
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Đếm tổng số pending transactions
     */
    public int countPending() {
        String sql = "SELECT COUNT(*) FROM pending_transactions WHERE status = 'PENDING'";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Tổng tiền đang pending
     */
    public BigDecimal getTotalPendingAmount() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM pending_transactions WHERE status = 'PENDING'";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return BigDecimal.ZERO;
    }
    
    /**
     * Extract PendingTransaction từ ResultSet
     */
    private PendingTransaction extractPendingTransaction(ResultSet rs) throws SQLException {
        PendingTransaction pt = new PendingTransaction();
        
        pt.setPendingId(rs.getLong("pending_id"));
        pt.setOrderId(rs.getLong("order_id"));
        pt.setBuyerId(rs.getInt("buyer_id"));
        pt.setSellerId(rs.getInt("seller_id"));
        pt.setTotalAmount(rs.getBigDecimal("total_amount"));
        pt.setSellerAmount(rs.getBigDecimal("seller_amount"));
        pt.setPlatformFee(rs.getBigDecimal("platform_fee"));
        pt.setStatus(rs.getString("status"));
        pt.setHoldUntil(rs.getTimestamp("hold_until"));
        pt.setReleasedAt(rs.getTimestamp("released_at"));
        
        // Transaction IDs (có thể null)
        long transId = rs.getLong("transaction_id");
        pt.setTransactionId(rs.wasNull() ? null : transId);
        
        long sellerTransId = rs.getLong("seller_transaction_id");
        pt.setSellerTransactionId(rs.wasNull() ? null : sellerTransId);
        
        long adminTransId = rs.getLong("admin_transaction_id");
        pt.setAdminTransactionId(rs.wasNull() ? null : adminTransId);
        
        pt.setNotes(rs.getString("notes"));
        pt.setCreatedAt(rs.getTimestamp("created_at"));
        pt.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        // Joined fields (optional)
        try {
            pt.setBuyerEmail(rs.getString("buyer_email"));
            pt.setBuyerName(rs.getString("buyer_name"));
            pt.setSellerEmail(rs.getString("seller_email"));
            pt.setSellerName(rs.getString("seller_name"));
            pt.setOrderNumber(rs.getString("order_number"));
            
            long prodId = rs.getLong("product_id");
            pt.setProductId(rs.wasNull() ? null : prodId);
        } catch (SQLException ignored) {
            // Joined columns không tồn tại
        }
        
        return pt;
    }
}

