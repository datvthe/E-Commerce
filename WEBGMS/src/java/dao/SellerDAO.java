package dao;

import java.sql.*;
import model.seller.Seller;

public class SellerDAO {

    public boolean registerSeller(Seller seller) {
        String sql = "INSERT INTO sellers (user_id, full_name, email, phone, shop_name, shop_description, main_category, " +
                     "bank_name, bank_account, account_owner, deposit_amount, deposit_status, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, seller.getUserId());
            ps.setString(2, seller.getFullName());
            ps.setString(3, seller.getEmail());
            ps.setString(4, seller.getPhone());
            ps.setString(5, seller.getShopName());
            ps.setString(6, seller.getShopDescription());
            ps.setString(7, seller.getMainCategory());
            ps.setString(8, seller.getBankName());
            ps.setString(9, seller.getBankAccount());
            ps.setString(10, seller.getAccountOwner());
            ps.setDouble(11, seller.getDepositAmount());
            ps.setString(12, seller.getDepositStatus());
            ps.setString(13, "PENDING");

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean updateDeposit(long userId, double amount, String proofFile) {
    String sql = "UPDATE sellers SET deposit_amount=?, deposit_proof=?, deposit_status='PAID' WHERE user_id=?";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setDouble(1, amount);
        ps.setString(2, proofFile);
        ps.setLong(3, userId);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}
    public boolean existsByUserId(int userId) {
    String sql = "SELECT 1 FROM sellers WHERE user_id = ? LIMIT 1";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, userId);
        try (ResultSet rs = ps.executeQuery()) {
            return rs.next();
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}
    public Seller getSellerByUserId(int userId) {
    String sql = "SELECT * FROM sellers WHERE user_id = ?";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, userId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                Seller s = new Seller();
                s.setSellerId(rs.getInt("seller_id"));
                s.setUserId(rs.getInt("user_id"));
                s.setFullName(rs.getString("full_name"));
                s.setEmail(rs.getString("email"));
                s.setPhone(rs.getString("phone"));
                s.setShopName(rs.getString("shop_name"));
                s.setShopDescription(rs.getString("shop_description"));
                s.setMainCategory(rs.getString("main_category"));
                s.setBankName(rs.getString("bank_name"));
                s.setBankAccount(rs.getString("bank_account"));
                s.setAccountOwner(rs.getString("account_owner"));
                s.setDepositAmount(rs.getDouble("deposit_amount"));
                s.setDepositStatus(rs.getString("deposit_status"));
                s.setStatus(rs.getString("status"));
                return s;
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}

    public boolean updateSeller(Seller seller) {
        String sql = "UPDATE sellers SET full_name=?, email=?, phone=?, shop_name=?, shop_description=?, " +
                     "main_category=?, bank_name=?, bank_account=?, account_owner=?, updated_at=NOW() " +
                     "WHERE user_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, seller.getFullName());
            ps.setString(2, seller.getEmail());
            ps.setString(3, seller.getPhone());
            ps.setString(4, seller.getShopName());
            ps.setString(5, seller.getShopDescription());
            ps.setString(6, seller.getMainCategory());
            ps.setString(7, seller.getBankName());
            ps.setString(8, seller.getBankAccount());
            ps.setString(9, seller.getAccountOwner());
            ps.setLong(10, seller.getUserId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Close shop by updating status to CLOSED
     */
    public boolean closeShop(int userId, String reason) {
        String sql = "UPDATE sellers SET status = 'CLOSED', updated_at = NOW() WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            boolean success = ps.executeUpdate() > 0;
            
            // Also deactivate all products of this seller
            if (success) {
                String deactivateProductsSQL = "UPDATE Products SET status = 'inactive', updated_at = NOW() WHERE seller_id = ? AND deleted_at IS NULL";
                try (PreparedStatement ps2 = conn.prepareStatement(deactivateProductsSQL)) {
                    ps2.setInt(1, userId);
                    ps2.executeUpdate();
                }
            }
            
            return success;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get seller with full information including deposit info
     */
    public Seller getSellerWithDepositByUserId(int userId) {
        String sql = "SELECT * FROM sellers WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Seller s = new Seller();
                    s.setSellerId(rs.getInt("seller_id"));
                    s.setUserId(rs.getInt("user_id"));
                    s.setFullName(rs.getString("full_name"));
                    s.setEmail(rs.getString("email"));
                    s.setPhone(rs.getString("phone"));
                    s.setShopName(rs.getString("shop_name"));
                    s.setShopDescription(rs.getString("shop_description"));
                    s.setMainCategory(rs.getString("main_category"));
                    s.setBankName(rs.getString("bank_name"));
                    s.setBankAccount(rs.getString("bank_account"));
                    s.setAccountOwner(rs.getString("account_owner"));
                    s.setDepositAmount(rs.getDouble("deposit_amount"));
                    s.setDepositStatus(rs.getString("deposit_status"));
                    s.setStatus(rs.getString("status"));
                    return s;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Check if shop is already closed
     */
    public boolean isShopClosed(int userId) {
        String sql = "SELECT status FROM sellers WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String status = rs.getString("status");
                    return "CLOSED".equals(status);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

}