package dao;

import model.user.Users;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UsersDAO extends DBConnection {

    public Users checkLogin(String account, String password) {
        Users user = null;
        String sql = "SELECT * FROM Users "
                + "WHERE (email = ? OR phone_number = ?) "
                + "AND password_hash = ? "
                + "AND status = 'active'";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, account);
            ps.setString(2, account);
            ps.setString(3, password);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = new Users();
                user.setUser_id(rs.getLong("user_id"));
                user.setFull_name(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPassword_hash(rs.getString("password_hash"));
                user.setPhone_number(rs.getString("phone_number"));
                user.setGender(rs.getString("gender"));
                user.setDate_of_birth(rs.getDate("date_of_birth"));
                user.setAddress(rs.getString("address"));
                user.setAvatar_url(rs.getString("avatar_url"));
                user.setStatus(rs.getString("status"));
                user.setEmail_verified(rs.getBoolean("email_verified"));
                user.setLast_login_at(rs.getDate("last_login_at"));
                user.setCreated_at(rs.getDate("created_at"));
                user.setUpdated_at(rs.getDate("updated_at"));
                user.setDeleted_at(rs.getDate("deleted_at"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public void saveUserToken(long userId, String token, int days) {
        String sql = "INSERT INTO User_Tokens(user_id, token, expiry) VALUES (?, ?, NOW() + INTERVAL ? DAY)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setString(2, token);
            ps.setInt(3, days);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Users getUserByToken(String token) {
        Users user = null;
        String sql = "SELECT u.* FROM Users u "
                + "JOIN User_Tokens t ON u.user_id = t.user_id "
                + "WHERE t.token = ? AND t.expiry > NOW()";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = new Users();
                user.setUser_id(rs.getLong("user_id"));
                user.setFull_name(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone_number(rs.getString("phone_number"));
                user.setStatus(rs.getString("status"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

}
