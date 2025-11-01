package dao;

import model.withdrawal.WithdrawalRequest;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class for Withdrawal Requests
 * Xử lý các thao tác database cho yêu cầu rút tiền
 */
public class WithdrawalRequestDAO {
    
    /**
     * Tạo yêu cầu rút tiền mới
     */
    public boolean createWithdrawalRequest(WithdrawalRequest request) {
        String sql = "INSERT INTO withdrawal_requests (seller_id, amount, bank_name, bank_account_number, " +
                    "bank_account_name, request_note, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setLong(1, request.getSellerId());
            ps.setBigDecimal(2, request.getAmount());
            ps.setString(3, request.getBankName());
            ps.setString(4, request.getBankAccountNumber());
            ps.setString(5, request.getBankAccountName());
            ps.setString(6, request.getRequestNote());
            ps.setString(7, request.getStatusValue());
            
            int affected = ps.executeUpdate();
            
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        request.setRequestId(rs.getLong(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Lấy danh sách yêu cầu rút tiền của một seller
     */
    public List<WithdrawalRequest> getWithdrawalRequestsBySeller(long sellerId) {
        List<WithdrawalRequest> requests = new ArrayList<>();
        String sql = "SELECT wr.*, u.full_name as admin_name " +
                    "FROM withdrawal_requests wr " +
                    "LEFT JOIN gicungco_users u ON wr.processed_by = u.user_id " +
                    "WHERE wr.seller_id = ? " +
                    "ORDER BY wr.requested_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, sellerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    requests.add(mapResultSetToWithdrawalRequest(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return requests;
    }
    
    /**
     * Lấy tất cả yêu cầu rút tiền (cho admin)
     */
    public List<WithdrawalRequest> getAllWithdrawalRequests() {
        List<WithdrawalRequest> requests = new ArrayList<>();
        String sql = "SELECT wr.*, s.shop_name as seller_name, u_seller.email as seller_email, " +
                    "u_admin.full_name as admin_name " +
                    "FROM withdrawal_requests wr " +
                    "INNER JOIN gicungco_sellers s ON wr.seller_id = s.seller_id " +
                    "INNER JOIN gicungco_users u_seller ON s.user_id = u_seller.user_id " +
                    "LEFT JOIN gicungco_users u_admin ON wr.processed_by = u_admin.user_id " +
                    "ORDER BY wr.requested_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                WithdrawalRequest request = mapResultSetToWithdrawalRequest(rs);
                request.setSellerName(rs.getString("seller_name"));
                request.setSellerEmail(rs.getString("seller_email"));
                requests.add(request);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return requests;
    }
    
    /**
     * Lấy yêu cầu rút tiền theo trạng thái (cho admin)
     */
    public List<WithdrawalRequest> getWithdrawalRequestsByStatus(String status) {
        List<WithdrawalRequest> requests = new ArrayList<>();
        String sql = "SELECT wr.*, s.shop_name as seller_name, u_seller.email as seller_email, " +
                    "u_admin.full_name as admin_name " +
                    "FROM withdrawal_requests wr " +
                    "INNER JOIN gicungco_sellers s ON wr.seller_id = s.seller_id " +
                    "INNER JOIN gicungco_users u_seller ON s.user_id = u_seller.user_id " +
                    "LEFT JOIN gicungco_users u_admin ON wr.processed_by = u_admin.user_id " +
                    "WHERE wr.status = ? " +
                    "ORDER BY wr.requested_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    WithdrawalRequest request = mapResultSetToWithdrawalRequest(rs);
                    request.setSellerName(rs.getString("seller_name"));
                    request.setSellerEmail(rs.getString("seller_email"));
                    requests.add(request);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return requests;
    }
    
    /**
     * Lấy chi tiết một yêu cầu rút tiền
     */
    public WithdrawalRequest getWithdrawalRequestById(Long requestId) {
        String sql = "SELECT wr.*, s.shop_name as seller_name, u_seller.email as seller_email, " +
                    "u_admin.full_name as admin_name " +
                    "FROM withdrawal_requests wr " +
                    "INNER JOIN gicungco_sellers s ON wr.seller_id = s.seller_id " +
                    "INNER JOIN gicungco_users u_seller ON s.user_id = u_seller.user_id " +
                    "LEFT JOIN gicungco_users u_admin ON wr.processed_by = u_admin.user_id " +
                    "WHERE wr.request_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    WithdrawalRequest request = mapResultSetToWithdrawalRequest(rs);
                    request.setSellerName(rs.getString("seller_name"));
                    request.setSellerEmail(rs.getString("seller_email"));
                    return request;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Cập nhật trạng thái yêu cầu rút tiền (admin xử lý)
     */
    public boolean updateWithdrawalStatus(Long requestId, String status, Long adminId, 
                                         String adminNote, String transactionRef) {
        String sql = "UPDATE withdrawal_requests SET status = ?, processed_by = ?, " +
                    "admin_note = ?, transaction_reference = ?, processed_at = CURRENT_TIMESTAMP " +
                    "WHERE request_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setLong(2, adminId);
            ps.setString(3, adminNote);
            ps.setString(4, transactionRef);
            ps.setLong(5, requestId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Đếm số yêu cầu chờ duyệt (cho admin dashboard)
     */
    public int countPendingRequests() {
        String sql = "SELECT COUNT(*) FROM withdrawal_requests WHERE status = 'pending'";
        
        try (Connection conn = DBConnection.getConnection();
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
     * Tính tổng số tiền đã rút của seller
     */
    public BigDecimal getTotalWithdrawnAmount(long sellerId) {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM withdrawal_requests " +
                    "WHERE seller_id = ? AND status = 'completed'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, sellerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }
    
    /**
     * Tính tổng số tiền đang chờ duyệt của seller
     */
    public BigDecimal getPendingWithdrawalAmount(long sellerId) {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM withdrawal_requests " +
                    "WHERE seller_id = ? AND status IN ('pending', 'approved', 'processing')";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, sellerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }
    
    /**
     * Kiểm tra xem seller có yêu cầu đang chờ xử lý không
     */
    public boolean hasActivePendingRequest(long sellerId) {
        String sql = "SELECT COUNT(*) FROM withdrawal_requests " +
                    "WHERE seller_id = ? AND status IN ('pending', 'processing')";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, sellerId);
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
     * Xóa yêu cầu rút tiền (chỉ cho phép xóa khi pending)
     */
    public boolean deleteWithdrawalRequest(Long requestId, long sellerId) {
        String sql = "DELETE FROM withdrawal_requests WHERE request_id = ? AND seller_id = ? AND status = 'pending'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, requestId);
            ps.setLong(2, sellerId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Map ResultSet to WithdrawalRequest object
     */
    private WithdrawalRequest mapResultSetToWithdrawalRequest(ResultSet rs) throws SQLException {
        WithdrawalRequest request = new WithdrawalRequest();
        request.setRequestId(rs.getLong("request_id"));
        request.setSellerId(rs.getLong("seller_id"));
        request.setAmount(rs.getBigDecimal("amount"));
        request.setBankName(rs.getString("bank_name"));
        request.setBankAccountNumber(rs.getString("bank_account_number"));
        request.setBankAccountName(rs.getString("bank_account_name"));
        request.setStatusFromString(rs.getString("status"));
        request.setRequestNote(rs.getString("request_note"));
        request.setAdminNote(rs.getString("admin_note"));
        request.setRequestedAt(rs.getTimestamp("requested_at"));
        request.setProcessedAt(rs.getTimestamp("processed_at"));
        
        long processedBy = rs.getLong("processed_by");
        if (!rs.wasNull()) {
            request.setProcessedBy(processedBy);
        }
        
        request.setTransactionReference(rs.getString("transaction_reference"));
        request.setCreatedAt(rs.getTimestamp("created_at"));
        request.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        String adminName = rs.getString("admin_name");
        if (adminName != null) {
            request.setAdminName(adminName);
        }
        
        return request;
    }
}

