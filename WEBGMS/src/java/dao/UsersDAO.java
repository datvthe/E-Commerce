package dao;

import model.user.Users;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.user.Roles;
import model.user.UserRoles;
import util.PasswordUtil;

public class UsersDAO extends DBConnection {

    public Users checkLogin(String account, String password) {
        Users user = null;
        String sql = "SELECT * FROM Users "
                + "WHERE (email = ? OR phone_number = ?) "
                + "AND status = 'active'";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, account);
            ps.setString(2, account);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String storedPassword = rs.getString("password_hash");
                
                // Check if password is hashed or plain text (for migration)
                boolean passwordMatch = false;
                if (PasswordUtil.isHashed(storedPassword)) {
                    // Password is hashed, verify with hash
                    passwordMatch = PasswordUtil.verifyPassword(password, storedPassword);
                } else {
                    // Password is plain text, check directly (for migration)
                    passwordMatch = password.equals(storedPassword);
                }
                
                if (passwordMatch) {
                    user = new Users();
                    user.setUser_id(rs.getInt("user_id"));
                    user.setFull_name(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password_hash"));
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
                user.setUser_id(rs.getInt("user_id"));
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

    public void removeUserTokens(long userId) {
        String sql = "DELETE FROM User_Tokens WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public UserRoles getRoleByUserId(int user_id) {
        UserRoles userRole = null;
        String sql = "SELECT * FROM User_Roles "
                + "WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, user_id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                UsersDAO userDao = new UsersDAO();
                Users user = userDao.getUserById(rs.getInt("user_id"));

                RoleDAO roleDao = new RoleDAO();
                Roles role = roleDao.getRoleById(rs.getInt("role_id"));

                userRole = new UserRoles();
                userRole.setUser_role_id(rs.getInt("user_role_id"));
                userRole.setUser_id(user);
                userRole.setRole_id(role);
                userRole.setAssigned_at(rs.getTimestamp("assigned_at"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return userRole;
    }

    public Users getUserById(int userId) {
        Users user = null;
        String sql = "SELECT * FROM Users WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = new Users();
                user.setUser_id(rs.getInt("user_id"));
                user.setFull_name(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password_hash"));
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

    public boolean isEmailExists(String email) {
        String sql = "SELECT 1 FROM Users WHERE email = ? LIMIT 1";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isPhoneExists(String phoneNumber) {
        String sql = "SELECT 1 FROM Users WHERE phone_number = ? LIMIT 1";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phoneNumber);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public Users createUser(String fullName, String email, String password, String phoneNumber) {
        Users user = null;
        String hashedPassword = PasswordUtil.hashPassword(password);
        String sql = "INSERT INTO Users (full_name, email, password_hash, phone_number, status, email_verified, created_at) VALUES (?, ?, ?, ?, 'active', 0, NOW())";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, hashedPassword);
            ps.setString(4, phoneNumber);
            int affected = ps.executeUpdate();
            if (affected > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    int userId = keys.getInt(1);
                    user = getUserById(userId);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public void assignDefaultUserRole(int userId) {
        String sql = "INSERT INTO User_Roles (user_id, role_id, assigned_at) VALUES (?, 3, NOW())";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public Users getUserByEmail(String email) {
        Users user = null;
        String sql = "SELECT * FROM Users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = new Users();
                user.setUser_id(rs.getInt("user_id"));
                user.setFull_name(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password_hash"));
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
    
    public boolean updateUser(Users user) {
        String sql = "UPDATE Users SET full_name = ?, email = ?, phone_number = ?, address = ?, updated_at = NOW() WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFull_name());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone_number());
            ps.setString(4, user.getAddress());
            ps.setInt(5, user.getUser_id());
            
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updatePassword(int userId, String newPassword) {
        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        String sql = "UPDATE Users SET password_hash = ?, updated_at = NOW() WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setInt(2, userId);
            
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
