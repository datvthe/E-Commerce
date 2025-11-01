package dao;

import model.user.EmailVerification;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Random;

/**
 * DAO for email verification
 * Cloned from PasswordResetDAO with modifications
 */
public class EmailVerificationDAO extends DBConnection {

    /**
     * Create a new email verification request
     */
    public EmailVerification createEmailVerificationRequest(String email) {
        EmailVerification emailVerification = null;
        
        // First, invalidate any existing verification requests for this email
        invalidateExistingRequests(email);
        
        // Generate a 6-digit verification code
        String verificationCode = generateVerificationCode();
        
        String sql = "INSERT INTO email_verification (email, verification_code, created_at, expires_at, used) " +
                    "VALUES (?, ?, NOW(), DATE_ADD(NOW(), INTERVAL 15 MINUTE), 0)";
        
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, email);
            ps.setString(2, verificationCode);
            
            int affected = ps.executeUpdate();
            if (affected > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    int verificationId = keys.getInt(1);
                    emailVerification = getEmailVerificationById(verificationId);
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return emailVerification;
    }

    /**
     * Get email verification request by ID
     */
    public EmailVerification getEmailVerificationById(int verificationId) {
        EmailVerification emailVerification = null;
        String sql = "SELECT * FROM email_verification WHERE verification_id = ?";
        
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, verificationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    emailVerification = new EmailVerification();
                    emailVerification.setVerificationId(rs.getInt("verification_id"));
                    emailVerification.setEmail(rs.getString("email"));
                    emailVerification.setVerificationCode(rs.getString("verification_code"));
                    emailVerification.setCreatedAt(rs.getTimestamp("created_at"));
                    emailVerification.setExpiresAt(rs.getTimestamp("expires_at"));
                    emailVerification.setUsed(rs.getBoolean("used"));
                    emailVerification.setUsedAt(rs.getTimestamp("used_at"));
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return emailVerification;
    }

    /**
     * Get valid email verification request by email and verification code
     */
    public EmailVerification getValidEmailVerification(String email, String verificationCode) {
        EmailVerification emailVerification = null;
        String sql = "SELECT * FROM email_verification " +
                    "WHERE email = ? AND verification_code = ? " +
                    "AND used = 0 AND expires_at > NOW()";
        
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.setString(2, verificationCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    emailVerification = new EmailVerification();
                    emailVerification.setVerificationId(rs.getInt("verification_id"));
                    emailVerification.setEmail(rs.getString("email"));
                    emailVerification.setVerificationCode(rs.getString("verification_code"));
                    emailVerification.setCreatedAt(rs.getTimestamp("created_at"));
                    emailVerification.setExpiresAt(rs.getTimestamp("expires_at"));
                    emailVerification.setUsed(rs.getBoolean("used"));
                    emailVerification.setUsedAt(rs.getTimestamp("used_at"));
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return emailVerification;
    }

    /**
     * Mark email verification request as used
     */
    public boolean markAsUsed(int verificationId) {
        String sql = "UPDATE email_verification SET used = 1, used_at = NOW() WHERE verification_id = ?";
        
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, verificationId);
            int affected = ps.executeUpdate();
            return affected > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return false;
    }

    /**
     * Invalidate existing email verification requests for an email
     */
    public void invalidateExistingRequests(String email) {
        String sql = "UPDATE email_verification SET used = 1 WHERE email = ? AND used = 0";
        
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Clean up expired email verification requests
     */
    public void cleanupExpiredRequests() {
        String sql = "DELETE FROM email_verification WHERE expires_at < NOW()";
        
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
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

