package util;

import dao.UsersDAO;
import model.user.Users;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import dao.DBConnection;

/**
 * Migration script to hash all plain text passwords in the database
 * Run this once to migrate from plain text to hashed passwords
 */
public class PasswordMigration {
    
    public static void main(String[] args) {
        System.out.println("Starting password migration...");
        
        try {
            // Get all users with plain text passwords
            String sql = "SELECT user_id, password FROM Users WHERE status = 'active' AND password NOT LIKE '%:%'";
            
            try (Connection conn = DBConnection.getConnection(); 
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                
                ResultSet rs = ps.executeQuery();
                int updatedCount = 0;
                
                while (rs.next()) {
                    int userId = rs.getInt("user_id");
                    String plainPassword = rs.getString("password");
                    
                    // Skip if password is already hashed (contains salt separator)
                    if (PasswordUtil.isHashed(plainPassword)) {
                        System.out.println("User " + userId + " already has hashed password, skipping...");
                        continue;
                    }
                    
                    // Hash the password
                    String hashedPassword = PasswordUtil.hashPassword(plainPassword);
                    
                    // Update the password in database
                    String updateSql = "UPDATE Users SET password = ?, updated_at = NOW() WHERE user_id = ?";
                    try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                        updatePs.setString(1, hashedPassword);
                        updatePs.setInt(2, userId);
                        
                        int affected = updatePs.executeUpdate();
                        if (affected > 0) {
                            updatedCount++;
                            System.out.println("Updated password for user " + userId);
                        }
                    }
                }
                
                System.out.println("Migration completed! Updated " + updatedCount + " passwords.");
                
            }
            
        } catch (Exception e) {
            System.err.println("Error during migration: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Hash a specific user's password
     */
    public static boolean hashUserPassword(int userId, String plainPassword) {
        try {
            String hashedPassword = PasswordUtil.hashPassword(plainPassword);
            
            String sql = "UPDATE Users SET password = ?, updated_at = NOW() WHERE user_id = ?";
            try (Connection conn = DBConnection.getConnection(); 
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                
                ps.setString(1, hashedPassword);
                ps.setInt(2, userId);
                
                int affected = ps.executeUpdate();
                return affected > 0;
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Check if all passwords are hashed
     */
    public static boolean areAllPasswordsHashed() {
        try {
            String sql = "SELECT COUNT(*) as count FROM Users WHERE status = 'active' AND password NOT LIKE '%:%'";
            
            try (Connection conn = DBConnection.getConnection(); 
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    int plainTextCount = rs.getInt("count");
                    return plainTextCount == 0;
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return false;
    }
}
