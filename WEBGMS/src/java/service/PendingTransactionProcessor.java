package service;

import dao.PendingTransactionDAO;
import dao.WalletDAO;
import dao.DBConnection;
import model.transaction.PendingTransaction;
import java.sql.*;
import java.util.List;

/**
 * PendingTransactionProcessor - Background job xử lý pending transactions
 * Chạy mỗi 5 phút để kiểm tra và giải phóng tiền cho seller
 */
public class PendingTransactionProcessor implements Runnable {
    
    private final PendingTransactionDAO pendingDAO = new PendingTransactionDAO();
    private final WalletDAO walletDAO = new WalletDAO();
    private volatile boolean running = true;
    
    @Override
    public void run() {
        System.out.println("🔄 PendingTransactionProcessor started!");
        
        while (running) {
            try {
                System.out.println("⏰ Checking pending transactions...");
                
                // Lấy danh sách pending cần xử lý
                List<PendingTransaction> pendingList = pendingDAO.getPendingTransactionsToProcess();
                
                if (!pendingList.isEmpty()) {
                    System.out.println("✅ Found " + pendingList.size() + " pending transactions to process");
                    
                    for (PendingTransaction pt : pendingList) {
                        processPendingTransaction(pt);
                    }
                } else {
                    System.out.println("✓ No pending transactions to process");
                }
                
                // Sleep 5 phút
                Thread.sleep(5 * 60 * 1000); // 5 minutes
                
            } catch (InterruptedException e) {
                System.out.println("⚠️ PendingTransactionProcessor interrupted!");
                running = false;
                Thread.currentThread().interrupt();
            } catch (Exception e) {
                System.err.println("❌ Error in PendingTransactionProcessor:");
                e.printStackTrace();
                
                try {
                    Thread.sleep(60 * 1000); // Sleep 1 minute on error
                } catch (InterruptedException ignored) {}
            }
        }
        
        System.out.println("🛑 PendingTransactionProcessor stopped!");
    }
    
    /**
     * Xử lý 1 pending transaction
     */
    private void processPendingTransaction(PendingTransaction pt) {
        System.out.println("💰 Processing pending #" + pt.getPendingId() + 
                          " - Order #" + pt.getOrderNumber());
        
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // 1. Cộng tiền cho SELLER (95%)
            long sellerTransactionId = System.currentTimeMillis();
            boolean sellerPaid = addToWallet(
                conn, pt.getSellerId(), pt.getSellerAmount().doubleValue(), 
                sellerTransactionId, 
                "Nhận tiền từ đơn hàng " + pt.getOrderNumber() + " (95%)"
            );
            
            if (!sellerPaid) {
                conn.rollback();
                System.err.println("❌ Failed to pay seller for pending #" + pt.getPendingId());
                return;
            }
            
            Thread.sleep(100); // Đợi 100ms để tránh duplicate transaction ID
            
            // 2. Cộng tiền cho ADMIN (5% phí)
            long adminTransactionId = System.currentTimeMillis();
            
            // TODO: Lấy admin user_id từ config (tạm thời dùng user_id = 1)
            int adminUserId = 1;
            
            boolean adminPaid = addToWallet(
                conn, adminUserId, pt.getPlatformFee().doubleValue(),
                adminTransactionId,
                "Phí hệ thống từ đơn hàng " + pt.getOrderNumber() + " (5%)"
            );
            
            if (!adminPaid) {
                conn.rollback();
                System.err.println("❌ Failed to pay admin fee for pending #" + pt.getPendingId());
                return;
            }
            
            // 3. Cập nhật trạng thái pending transaction thành COMPLETED
            boolean updated = pendingDAO.updateStatus(
                pt.getPendingId(), "COMPLETED", 
                sellerTransactionId, adminTransactionId
            );
            
            if (!updated) {
                conn.rollback();
                System.err.println("❌ Failed to update pending status #" + pt.getPendingId());
                return;
            }
            
            // 4. COMMIT
            conn.commit();
            
            System.out.println("✅ Successfully processed pending #" + pt.getPendingId() +
                              " - Seller: +" + pt.getSellerAmount() + 
                              " - Admin: +" + pt.getPlatformFee());
            
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ignored) {}
            }
            System.err.println("❌ Error processing pending #" + pt.getPendingId() + ":");
            e.printStackTrace();
            
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
     * Cộng tiền vào ví user (tương tự DEPOSIT)
     */
    private boolean addToWallet(Connection conn, int userId, double amount, 
                                long transactionId, String note) throws SQLException {
        
        // Lấy wallet info
        String sqlGetWallet = "SELECT wallet_id, balance FROM wallets WHERE user_id = ? FOR UPDATE";
        long walletId = 0;
        double oldBalance = 0;
        
        try (PreparedStatement ps = conn.prepareStatement(sqlGetWallet)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    walletId = rs.getLong("wallet_id");
                    oldBalance = rs.getDouble("balance");
                } else {
                    return false; // Wallet không tồn tại
                }
            }
        }
        
        double newBalance = oldBalance + amount;
        
        // Update wallet
        String sqlUpdate = "UPDATE wallets SET balance = ? WHERE wallet_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
            ps.setDouble(1, newBalance);
            ps.setLong(2, walletId);
            ps.executeUpdate();
        }
        
        // Insert transaction (DEPOSIT type)
        String sqlTrans = "INSERT INTO transactions " +
                         "(transaction_id, user_id, type, amount, currency, status, note) " +
                         "VALUES (?, ?, 'DEPOSIT', ?, 'VND', 'success', ?)";
        
        try (PreparedStatement ps = conn.prepareStatement(sqlTrans)) {
            ps.setLong(1, transactionId);
            ps.setInt(2, userId);
            ps.setDouble(3, amount);
            ps.setString(4, note);
            ps.executeUpdate();
        }
        
        return true;
    }
    
    /**
     * Stop processor
     */
    public void stop() {
        running = false;
    }
}

