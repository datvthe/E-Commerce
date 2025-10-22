package dao;

import model.user.Users;
import model.user.Roles;
import model.user.UserRoles;
import util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UsersDAO extends DBConnection {

    /**
     * ✅ Check login with support for new + old password formats
     */
    public Users checkLogin(String account, String password) {
        String sql = "SELECT * FROM users WHERE email = ? OR phone_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, account);
            ps.setString(2, account);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("password_hash");

                    if (storedHash == null || storedHash.isEmpty()) {
                        System.out.println("⚠️ User " + account + " chưa có mật khẩu hợp lệ!");
                        return null;
                    }

                    boolean verified = PasswordUtil.verifyPassword(password, storedHash);

                    // ✅ fallback: kiểm tra định dạng hash cũ (Base64 salt+hash)
                    if (!verified) {
                        verified = verifyOldPassword(password, storedHash);
                        if (verified) {
                            System.out.println("⚠️ Đăng nhập bằng hash cũ, tự động cập nhật sang hash mới...");
                            String newHash = PasswordUtil.hashPassword(password);
                            updatePassword(rs.getInt("user_id"), newHash);
                        }
                    }

                    if (verified) {
                        Users user = new Users();
                        user.setUser_id(rs.getInt("user_id"));
                        user.setFull_name(rs.getString("full_name"));
                        user.setEmail(rs.getString("email"));
                        user.setPhone_number(rs.getString("phone_number"));
                        user.setAvatar_url(rs.getString("avatar_url"));
                        user.setAddress(rs.getString("address"));
                        user.setGender(rs.getString("gender"));
                        user.setPassword_hash(storedHash);
                        user.setStatus(rs.getString("status"));
                        return user;
                    } else {
                        System.out.println("❌ verifyPassword() = false → sai mật khẩu");
                    }
                } else {
                    System.out.println("❌ Không tìm thấy tài khoản: " + account);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * ✅ Verify old password format (Base64 encoded salt + hash)
     */
    private boolean verifyOldPassword(String password, String hashedPassword) {
        try {
            byte[] combined = java.util.Base64.getDecoder().decode(hashedPassword);
            byte[] salt = new byte[16];
            System.arraycopy(combined, 0, salt, 0, 16);

            byte[] storedHash = new byte[combined.length - 16];
            System.arraycopy(combined, 16, storedHash, 0, storedHash.length);

            java.security.MessageDigest md = java.security.MessageDigest.getInstance("SHA-256");
            md.update(salt);
            byte[] computedHash = md.digest(password.getBytes());

            return java.security.MessageDigest.isEqual(storedHash, computedHash);
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * ✅ Update password with new hashed format
     */
    public boolean updatePassword(int userId, String hashedPassword) {
        String sql = "UPDATE users SET password_hash = ?, updated_at = NOW() WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * ✅ Create new user (auto-hash password if not hashed)
     */
    public Users createUser(String fullName, String email, String password, String phoneNumber) {
        Users user = null;

        // Hash nếu chưa hash
        if (password != null && !password.contains(":")) {
            password = PasswordUtil.hashPassword(password);
        }

        String sql = "INSERT INTO users (full_name, email, password_hash, phone_number, status, email_verified, default_role, created_at) "
                   + "VALUES (?, ?, ?, ?, 'active', 0, 'customer', NOW())";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, phoneNumber);
            int affected = ps.executeUpdate();
            if (affected > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    user = getUserById(keys.getInt(1));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    /**
     * ✅ Update user info
     */
    public boolean updateUser(Users user) {
        String sql = "UPDATE users SET full_name = ?, email = ?, phone_number = ?, address = ?, gender = ?, date_of_birth = ?, avatar_url = ?, updated_at = NOW() WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFull_name());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone_number());
            ps.setString(4, user.getAddress());
            ps.setString(5, user.getGender());

            if (user.getDate_of_birth() != null) {
                ps.setDate(6, user.getDate_of_birth());
            } else {
                ps.setNull(6, java.sql.Types.DATE);
            }

            ps.setString(7, user.getAvatar_url());
            ps.setInt(8, user.getUser_id());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("❌ updateUser() failed: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * ✅ Update user avatar
     */
    public boolean updateAvatar(int userId, String avatarUrl) {
        String sql = "UPDATE users SET avatar_url = ?, updated_at = NOW() WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, avatarUrl);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * ✅ Get user by email
     */
    public Users getUserByEmail(String email) {
        Users user = null;
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = mapUser(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    /**
     * ✅ Get user by account (email or phone)
     */
    public Users getUserByAccount(String account) {
        String sql = "SELECT * FROM users WHERE email = ? OR phone_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, account);
            ps.setString(2, account);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapUser(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * ✅ Get user by ID
     */
    public Users getUserById(int userId) {
        Users user = null;
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = mapUser(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    /**
     * ✅ Map ResultSet → User model
     */
    private Users mapUser(ResultSet rs) throws Exception {
        Users u = new Users();
        u.setUser_id(rs.getInt("user_id"));
        u.setFull_name(rs.getString("full_name"));
        u.setEmail(rs.getString("email"));
        u.setPhone_number(rs.getString("phone_number"));
        u.setPassword(rs.getString("password_hash"));
        u.setGender(rs.getString("gender"));
        u.setAddress(rs.getString("address"));
        u.setAvatar_url(rs.getString("avatar_url"));
        u.setStatus(rs.getString("status"));
        u.setEmail_verified(rs.getBoolean("email_verified"));
        u.setCreated_at(rs.getDate("created_at"));
        u.setUpdated_at(rs.getDate("updated_at"));
        return u;
    }

    /**
     * ✅ Token management (remember me)
     */
    public void saveUserToken(long userId, String token, int days) {
        String sql = "INSERT INTO auth_sessions (user_id, access_token, login_time) VALUES (?, ?, NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setString(2, token);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Users getUserByToken(String token) {
        Users user = null;
        String sql = "SELECT u.* FROM users u JOIN auth_sessions s ON u.user_id = s.user_id WHERE s.access_token = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = mapUser(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public void removeUserTokens(long userId) {
        String sql = "DELETE FROM auth_sessions WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * ✅ Role handling
     */
    public UserRoles getRoleByUserId(int user_id) {
        UserRoles userRole = null;
        String sql = "SELECT * FROM User_Roles WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, user_id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Users user = getUserById(rs.getInt("user_id"));
                Roles role = new RoleDAO().getRoleById(rs.getInt("role_id"));
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

    public void assignDefaultUserRole(int userId) {
        String sql = "INSERT INTO User_Roles (user_id, role_id, assigned_at) VALUES (?, 3, NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
