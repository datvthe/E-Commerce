package util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

public class PasswordUtil {
    
    private static final String ALGORITHM = "SHA-256";
    private static final int SALT_LENGTH = 16;
    
    /**
     * Generate a random salt
     */
    public static String generateSalt() {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[SALT_LENGTH];
        random.nextBytes(salt);
        return Base64.getEncoder().encodeToString(salt);
    }
    
    /**
     * Hash password with salt using SHA-256
     */
    public static String hashPassword(String password, String salt) {
        try {
            MessageDigest md = MessageDigest.getInstance(ALGORITHM);
            md.update(Base64.getDecoder().decode(salt));
            byte[] hashedPassword = md.digest(password.getBytes());
            return Base64.getEncoder().encodeToString(hashedPassword);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }
    
    /**
     * Hash password with auto-generated salt
     */
    public static String hashPassword(String password) {
        String salt = generateSalt();
        return hashPassword(password, salt) + ":" + salt;
    }
    
    /**
     * Verify password against hashed password
     */
    public static boolean verifyPassword(String password, String hashedPassword) {
        try {
            String[] parts = hashedPassword.split(":");
            if (parts.length != 2) {
                return false;
            }
            
            String storedHash = parts[0];
            String salt = parts[1];
            
            String computedHash = hashPassword(password, salt);
            return storedHash.equals(computedHash);
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * Check if password is already hashed (contains salt)
     */
    public static boolean isHashed(String password) {
        return password != null && password.contains(":");
    }
}
