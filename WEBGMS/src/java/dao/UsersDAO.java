package dao;

import model.user.Users;
import model.user.Roles;
import model.user.UserRoles;
import util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UsersDAO extends DBConnection {

    public Users checkLogin(String account, String password) {
        Users user = null;
        String sql = "SELECT * FROM users "
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
                    // Password is hashed with new format (hash:salt), verify with hash
                    passwordMatch = PasswordUtil.verifyPassword(password, storedPassword);
                } else if (storedPassword.length() > 50 && !storedPassword.contains(":")) {
                    // Password is hashed with old format (Base64 combined), verify with old method
                    passwordMatch = verifyOldPassword(password, storedPassword);
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
        String sql = "SELECT u.* FROM users u "
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
    
    /**
     * Verify password with old format (Base64 combined salt + hash)
     */
    private boolean verifyOldPassword(String password, String hashedPassword) {
        try {
            // Decode the combined salt + hash
            byte[] combined = java.util.Base64.getDecoder().decode(hashedPassword);
            
            // Extract salt (first 16 bytes)
            byte[] salt = new byte[16];
            System.arraycopy(combined, 0, salt, 0, 16);
            
            // Extract hash (remaining bytes)
            byte[] storedHash = new byte[combined.length - 16];
            System.arraycopy(combined, 16, storedHash, 0, storedHash.length);
            
            // Hash the input password with the same salt
            java.security.MessageDigest md = java.security.MessageDigest.getInstance("SHA-256");
            md.update(salt);
            byte[] computedHash = md.digest(password.getBytes());
            
            // Compare hashes
            return java.security.MessageDigest.isEqual(storedHash, computedHash);
        } catch (Exception e) {
            return false;
        }
    }

    public Users getUserById(int userId) {
        Users user = null;
        String sql = "SELECT * FROM users WHERE user_id = ?";

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
        String sql = "SELECT 1 FROM users WHERE email = ? LIMIT 1";
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
        String sql = "SELECT 1 FROM users WHERE phone_number = ? LIMIT 1";
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
        // Password is already hashed in CommonRegisterController, don't hash again
        String sql = "INSERT INTO users (full_name, email, password_hash, phone_number, status, email_verified, default_role, created_at) VALUES (?, ?, ?, ?, 'active', 0, 'customer', NOW())";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, password);
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
        // Resolve role ID by name to avoid mismatches between seeds and code
        int roleId = 3; // default fallback to CUSTOMER in code constants
        try {
            Roles customer = new RoleDAO().getRoleByName("customer");
            if (customer != null) {
                roleId = customer.getRole_id();
            }
        } catch (Exception ignore) {
        }

        String sql = "INSERT INTO User_Roles (user_id, role_id, assigned_at) VALUES (?, ?, NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, roleId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public Users getUserByEmail(String email) {
        Users user = null;
        String sql = "SELECT * FROM users WHERE email = ?";
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
        String sql = "UPDATE users SET full_name = ?, email = ?, phone_number = ?, address = ?, default_role = ?, gender = ?, date_of_birth = ?, avatar_url = ?, updated_at = NOW() WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFull_name());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone_number());
            ps.setString(4, user.getAddress());
            ps.setString(5, user.getDefault_role());
            ps.setString(6, user.getGender());
            ps.setDate(7, user.getDate_of_birth());
            ps.setString(8, user.getAvatar_url());
            ps.setInt(9, user.getUser_id());
            
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updatePassword(int userId, String newPassword) {
        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        String sql = "UPDATE users SET password_hash = ?, updated_at = NOW() WHERE user_id = ?";
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
    
    public boolean updateAvatar(int userId, String avatarUrl) {
        String sql = "UPDATE users SET avatar_url = ?, updated_at = NOW() WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, avatarUrl);
            ps.setInt(2, userId);
            
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ===== Admin dashboard helpers =====
    public List<Users> getRecentUsers(int limit) {
        List<Users> list = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapUser(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private Users mapUser(ResultSet rs) throws Exception {
        Users user = new Users();
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
        user.setDefault_role(rs.getString("default_role"));
        return user;
    }

    // ===== Admin: Users listing & management =====
    public List<Users> getAllUsers(int page, int pageSize) {
        List<Users> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT * FROM users WHERE deleted_at IS NULL ORDER BY created_at DESC LIMIT ? OFFSET ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pageSize);
            ps.setInt(2, offset);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapUser(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Users> searchUsers(String keyword, String status, String role, int page, int pageSize) {
        List<Users> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        StringBuilder sql = new StringBuilder("SELECT * FROM users WHERE deleted_at IS NULL ");
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (full_name LIKE ? OR email LIKE ? OR phone_number LIKE ?) ");
            String k = "%" + keyword.trim() + "%";
            params.add(k); params.add(k); params.add(k);
        }
        if (status != null && !status.trim().isEmpty() && !"all".equalsIgnoreCase(status)) {
            sql.append("AND status = ? ");
            params.add(status);
        }
        if (role != null && !role.trim().isEmpty() && !"all".equalsIgnoreCase(role)) {
            sql.append("AND default_role = ? ");
            params.add(role.toLowerCase());
        }
        sql.append("ORDER BY created_at DESC LIMIT ? OFFSET ?");
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Object p : params) {
                if (p instanceof String) ps.setString(idx++, (String) p);
                else if (p instanceof Integer) ps.setInt(idx++, (Integer) p);
            }
            ps.setInt(idx++, pageSize);
            ps.setInt(idx, offset);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapUser(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countUsers(String keyword, String status, String role) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM users WHERE deleted_at IS NULL ");
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (full_name LIKE ? OR email LIKE ? OR phone_number LIKE ?) ");
            String k = "%" + keyword.trim() + "%";
            params.add(k); params.add(k); params.add(k);
        }
        if (status != null && !status.trim().isEmpty() && !"all".equalsIgnoreCase(status)) {
            sql.append("AND status = ? ");
            params.add(status);
        }
        if (role != null && !role.trim().isEmpty() && !"all".equalsIgnoreCase(role)) {
            sql.append("AND default_role = ? ");
            params.add(role.toLowerCase());
        }
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Object p : params) {
                if (p instanceof String) ps.setString(idx++, (String) p);
                else if (p instanceof Integer) ps.setInt(idx++, (Integer) p);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM users WHERE deleted_at IS NULL";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean deleteUser(int userId) {
        String sql = "UPDATE users SET status = 'inactive', deleted_at = NOW() WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateUserStatus(int userId, String status) {
        String sql = "UPDATE users SET status = ?, updated_at = NOW() WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
