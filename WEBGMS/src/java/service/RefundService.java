package service;

import dao.*;
import model.order.Orders;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.math.BigDecimal;

/**
 * RefundService - Xử lý hoàn tiền cho orders
 * 
 * CASES:
 * 1. Auto refund khi hết code (status = 'cancelled')
 * 2. Manual refund khi user yêu cầu (status = 'refunded')
 */
public class RefundService {
    
    private final OrderDAO orderDAO = new OrderDAO();
    private final WalletDAO walletDAO = new WalletDAO();
    
    /**
     * Xử lý hoàn tiền cho 1 order
     * 
     * @param orderId Order cần hoàn tiền
     * @param reason Lý do hoàn tiền
     * @return true nếu thành công
     */
    public boolean processRefund(Long orderId, String reason) {
        Connection conn = null;
        
        try {
            // 1. Lấy order info
            Orders order = orderDAO.getOrderById(orderId);
            
            if (order == null) {
                System.err.println("❌ [Refund] Order not found: " + orderId);
                return false;
            }
            
            // 2. Kiểm tra đã thanh toán chưa
            if (!"paid".equalsIgnoreCase(order.getPaymentStatus()) && 
                !"cancelled".equalsIgnoreCase(order.getPaymentStatus())) {
                System.err.println("❌ [Refund] Order not paid/cancelled: " + orderId);
                return false;
            }
            
            // 3. Kiểm tra đã refund chưa
            if ("refunded".equalsIgnoreCase(order.getPaymentStatus())) {
                System.out.println("ℹ️ [Refund] Order already refunded: " + orderId);
                return true;
            }
            
            // 4. BEGIN TRANSACTION
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // 5. Hoàn tiền vào ví buyer
            BigDecimal refundAmount = order.getTotalAmount();
            if (refundAmount == null || refundAmount.compareTo(BigDecimal.ZERO) <= 0) {
                System.err.println("❌ [Refund] Invalid refund amount: " + refundAmount);
                return false;
            }
            
            int buyerId = order.getBuyerId().intValue();
            
            boolean walletUpdated = addToWallet(conn, buyerId, refundAmount.doubleValue(), 
                                                orderId, "Refund: " + reason);
            
            if (!walletUpdated) {
                conn.rollback();
                System.err.println("❌ [Refund] Failed to add money to wallet: " + orderId);
                return false;
            }
            
            // 6. Update order status to REFUNDED
            boolean orderUpdated = orderDAO.updateOrderToRefunded(orderId, reason, conn);
            
            if (!orderUpdated) {
                conn.rollback();
                System.err.println("❌ [Refund] Failed to update order status: " + orderId);
                return false;
            }
            
            // 7. COMMIT
            conn.commit();
            
            System.out.println("✅ [Refund] Successfully refunded order: " + orderId + 
                             " | Amount: " + refundAmount + " VND");
            
            return true;
            
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ignored) {}
            }
            
            System.err.println("════════════════════════════════════════");
            System.err.println("❌ [Refund] FAILED for order " + orderId);
            System.err.println("❌ Error: " + e.getMessage());
            System.err.println("❌ Reason: " + reason);
            System.err.println("════════════════════════════════════════");
            e.printStackTrace();
            return false;
            
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    /**
     * Thêm tiền vào ví user
     */
    private boolean addToWallet(Connection conn, int userId, double amount, 
                                Long orderId, String description) throws SQLException {
        
        // 1. Lấy wallet info
        String sqlGetWallet = "SELECT wallet_id, balance FROM wallets WHERE user_id = ? FOR UPDATE";
        long walletId = 0;
        double oldBalance = 0;
        
        try (PreparedStatement ps = conn.prepareStatement(sqlGetWallet)) {
            ps.setInt(1, userId);
            try (var rs = ps.executeQuery()) {
                if (rs.next()) {
                    walletId = rs.getLong("wallet_id");
                    oldBalance = rs.getDouble("balance");
                } else {
                    return false; // Wallet không tồn tại
                }
            }
        }
        
        // 2. Cộng tiền vào ví
        double newBalance = oldBalance + amount;
        
        String sqlUpdate = "UPDATE wallets SET balance = ? WHERE wallet_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
            ps.setDouble(1, newBalance);
            ps.setLong(2, walletId);
            ps.executeUpdate();
        }
        
        // 3. Insert transaction (DEPOSIT vì đây là cộng tiền)
        String sqlTrans = "INSERT INTO transactions " +
                         "(user_id, type, amount, currency, status, note) " +
                         "VALUES (?, 'DEPOSIT', ?, 'VND', 'success', ?)";
        
        try (PreparedStatement ps = conn.prepareStatement(sqlTrans)) {
            ps.setInt(1, userId);
            ps.setDouble(2, amount);
            ps.setString(3, description + " (Order #" + orderId + ")");
            ps.executeUpdate();
        }
        
        return true;
    }
    
    /**
     * Kiểm tra order có thể refund không
     */
    public boolean canRefund(Long orderId) {
        try {
            Orders order = orderDAO.getOrderById(orderId);
            
            if (order == null) {
                return false;
            }
            
            // Chỉ refund được khi:
            // 1. Đã thanh toán (paid)
            // 2. Đã delivered nhưng có vấn đề
            // 3. Bị cancelled
            
            String status = order.getPaymentStatus();
            return "paid".equalsIgnoreCase(status) || 
                   "delivered".equalsIgnoreCase(status) ||
                   "cancelled".equalsIgnoreCase(status);
                   
        } catch (Exception e) {
            return false;
        }
    }
}

