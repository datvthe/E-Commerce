package dao;

import model.user.PasswordReset;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.Random;

public class PasswordResetDAO extends DBConnection {

    /**
     * Create a new password reset request
     */
    public PasswordReset createPasswordResetRequest(String email) {
        PasswordReset passwordReset = null;
        
        // First, invalidate any existing reset requests for this email
        invalidateExistingRequests(email);
        
        // Generate a 6-digit verification code
        String verificationCode = generateVerificationCode();
        
        String sql = "INSERT INTO Password_Reset (email, verification_code, created_at, expires_at, used) " +
                    "VALUES (?, ?, NOW(), DATE_ADD(NOW(), INTERVAL 15 MINUTE), 0)";
        
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, email);
            ps.setString(2, verificationCode);
            
            int affected = ps.executeUpdate();
            if (affected > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    int resetId = keys.getInt(1);
                    passwordReset = getPasswordResetById(resetId);
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return passwordReset;
    }

    /**
     * Get password reset request by ID
     */
    public PasswordReset getPasswordResetById(int resetId) {
        PasswordReset passwordReset = null;
        String sql = "SELECT * FROM Password_Reset WHERE reset_id = ?";
        
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, resetId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                passwordReset = new PasswordReset();
                passwordReset.setReset_id(rs.getInt("reset_id"));
                passwordReset.setEmail(rs.getString("email"));
                passwordReset.setVerification_code(rs.getString("verification_code"));
                passwordReset.setCreated_at(rs.getTimestamp("created_at"));
                passwordReset.setExpires_at(rs.getTimestamp("expires_at"));
                passwordReset.setUsed(rs.getBoolean("used"));
                passwordReset.setUsed_at(rs.getTimestamp("used_at"));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return passwordReset;
    }

    /**
     * Get valid password reset request by email and verification code
     */
    public PasswordReset getValidPasswordReset(String email, String verificationCode) {
        PasswordReset passwordReset = null;
        String sql = "SELECT * FROM Password_Reset " +
                    "WHERE email = ? AND verification_code = ? " +
                    "AND used = 0 AND expires_at > NOW()";
        
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.setString(2, verificationCode);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                passwordReset = new PasswordReset();
                passwordReset.setReset_id(rs.getInt("reset_id"));
                passwordReset.setEmail(rs.getString("email"));
                passwordReset.setVerification_code(rs.getString("verification_code"));
                passwordReset.setCreated_at(rs.getTimestamp("created_at"));
                passwordReset.setExpires_at(rs.getTimestamp("expires_at"));
                passwordReset.setUsed(rs.getBoolean("used"));
                passwordReset.setUsed_at(rs.getTimestamp("used_at"));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return passwordReset;
    }

    /**
     * Mark password reset request as used
     */
    public boolean markAsUsed(int resetId) {
        String sql = "UPDATE Password_Reset SET used = 1, used_at = NOW() WHERE reset_id = ?";
        
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, resetId);
            int affected = ps.executeUpdate();
            return affected > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return false;
    }

    /**
     * Invalidate existing password reset requests for an email
     */
    public void invalidateExistingRequests(String email) {
        String sql = "UPDATE Password_Reset SET used = 1 WHERE email = ? AND used = 0";
        
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Clean up expired password reset requests
     */
    public void cleanupExpiredRequests() {
        String sql = "DELETE FROM Password_Reset WHERE expires_at < NOW()";
        
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Check if user exists by email
     */
    public boolean userExistsByEmail(String email) {
        String sql = "SELECT 1 FROM Users WHERE email = ? AND status = 'active' LIMIT 1";
        
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return false;
    }

    /**
     * Update user password
     */
    public boolean updateUserPassword(String email, String newPassword) {
        String sql = "UPDATE Users SET password = ?, updated_at = NOW() WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, newPassword);
            ps.setString(2, email);
            int affected = ps.executeUpdate();
            return affected > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return false;
    }

    /**
     * Generate a 6-digit verification code
     */
    private String generateVerificationCode() {
        Random random = new Random();
        int code = 100000 + random.nextInt(900000); // Generate 6-digit number
        return String.valueOf(code);
    }
}
