package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.wallet.Transaction;

public class WalletDAO extends DBConnection {

    /** ✅ Lấy số dư của người dùng */
public double getBalance(int userId) {
    String sql = "SELECT balance FROM wallets WHERE user_id = ?";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, userId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble("balance");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return 0.0;
}


public void processTopUp(int userId, double amount, String transactionId, String bank) throws SQLException {
    Connection conn = null;
    PreparedStatement ps1 = null;
    PreparedStatement ps2 = null;
    try {
        conn = DBConnection.getConnection();
        conn.setAutoCommit(false);

        // 1️⃣ Ghi lịch sử
        String sql1 = "INSERT INTO transactions (transaction_id, user_id, amount, status, note, created_at) VALUES (?, ?, ?, ?, ?, NOW())";
        ps1 = conn.prepareStatement(sql1);
        ps1.setString(1, transactionId);
        ps1.setInt(2, userId);
        ps1.setDouble(3, amount);
        ps1.setString(4, "SUCCESS");
        ps1.setString(5, "Auto deposit via SePay (" + bank + ")");
        ps1.executeUpdate();

        // 2️⃣ Cập nhật số dư ví
        String sql2 = "UPDATE wallets SET balance = balance + ? WHERE user_id = ?";
        ps2 = conn.prepareStatement(sql2);
        ps2.setDouble(1, amount);
        ps2.setInt(2, userId);
        ps2.executeUpdate();

        conn.commit();
    } catch (Exception e) {
        if (conn != null) conn.rollback();
        throw e;
    } finally {
        if (ps1 != null) try { ps1.close(); } catch (Exception ignored) {}
        if (ps2 != null) try { ps2.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
}



    /** ✅ Lấy danh sách lịch sử giao dịch của user */
    public List<Transaction> getTransactions(int userId) {
        List<Transaction> list = new ArrayList<>();
        String sql = "SELECT * FROM transactions WHERE user_id = ? ORDER BY created_at DESC LIMIT 20";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Transaction t = new Transaction();
                t.setTransaction_id(rs.getString("transaction_id"));
                t.setUser_id(rs.getInt("user_id"));
                t.setType(rs.getString("type"));
                t.setAmount(rs.getDouble("amount"));
                t.setCurrency(rs.getString("currency"));
                t.setStatus(rs.getString("status"));
                t.setNote(rs.getString("note"));
                t.setCreated_at(rs.getTimestamp("created_at"));
                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** ✅ Dùng cho webhook: tìm userId qua mô tả chuyển khoản (VD: "TOPUP-5") */
public int findUserIdByDescription(String desc) {
    try {
        if (desc == null || !desc.toUpperCase().contains("TOPUP-")) {
            return -1;
        }
        String[] parts = desc.split("TOPUP-");
        if (parts.length < 2) return -1;

        String idPart = parts[1].trim().split("\s+")[0]; // cắt theo khoảng trắng nếu có
        return Integer.parseInt(idPart);
    } catch (Exception e) {
        e.printStackTrace();
        return -1;
    }
}

   public boolean addBalanceByCode(String userCode, double amount, String tranId) {
    Connection conn = null;
    PreparedStatement psSelect = null, psUpdate = null, psInsert = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();
        conn.setAutoCommit(false);

        // Lấy user_id từ userCode
        String sqlUser = "SELECT user_id FROM users WHERE user_id = ?";
        psSelect = conn.prepareStatement(sqlUser);
        psSelect.setString(1, userCode);
        rs = psSelect.executeQuery();

        if (!rs.next()) {
            System.out.println("❌ Không tìm thấy user_id " + userCode);
            return false;
        }
        int userId = rs.getInt("user_id");

        // ✅ Cập nhật ví
        String update = "UPDATE wallets SET balance = balance + ? WHERE user_id = ?";
        psUpdate = conn.prepareStatement(update);
        psUpdate.setDouble(1, amount);
        psUpdate.setInt(2, userId);
        psUpdate.executeUpdate();

        // ✅ Ghi lịch sử giao dịch
        String insert = "INSERT INTO transactions (transaction_id, user_id, type, amount, status, created_at) VALUES (?, ?, 'TOPUP', ?, 'SUCCESS', NOW())";
        psInsert = conn.prepareStatement(insert);
        psInsert.setString(1, tranId);
        psInsert.setInt(2, userId);
        psInsert.setDouble(3, amount);
        psInsert.executeUpdate();

        conn.commit();
        return true;

    } catch (Exception e) {
        e.printStackTrace();
        try { if (conn != null) conn.rollback(); } catch (Exception ignored) {}
        return false;
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception ignored) {}
        try { if (psSelect != null) psSelect.close(); } catch (Exception ignored) {}
        try { if (psUpdate != null) psUpdate.close(); } catch (Exception ignored) {}
        try { if (psInsert != null) psInsert.close(); } catch (Exception ignored) {}
        try { if (conn != null) conn.close(); } catch (Exception ignored) {}
    }
}

public boolean deductBalance(int userId, double amount) {
    String sql = "UPDATE wallets SET balance = balance - ? WHERE user_id = ? AND balance >= ?";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setDouble(1, amount);
        ps.setInt(2, userId);
        ps.setDouble(3, amount);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}

    /** ✅ Lấy số dư của người dùng (BigDecimal) */
    public java.math.BigDecimal getBalanceByUserId(int userId) {
        String sql = "SELECT balance FROM wallets WHERE user_id = ?";
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("balance");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return java.math.BigDecimal.ZERO;
    }

    /** ✅ Đếm số lần rút tiền của user */
    public int getWithdrawCountByUserId(int userId) {
        String sql = "SELECT COUNT(*) FROM transactions WHERE user_id = ? AND type = 'WITHDRAW'";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}