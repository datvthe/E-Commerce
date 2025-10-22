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
}
