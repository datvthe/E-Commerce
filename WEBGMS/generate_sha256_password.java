import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Generate SHA-256 hash for password "12345678"
 * Format: hash:salt (same as PasswordUtil)
 */
public class generate_sha256_password {
    
    private static final String ALGORITHM = "SHA-256";
    private static final int SALT_LENGTH = 16;
    
    public static String generateSalt() {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[SALT_LENGTH];
        random.nextBytes(salt);
        return Base64.getEncoder().encodeToString(salt);
    }
    
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
    
    public static void main(String[] args) {
        String password = "12345678";
        
        System.out.println("================================================");
        System.out.println("SHA-256 PASSWORD GENERATOR");
        System.out.println("================================================");
        System.out.println();
        System.out.println("Password: " + password);
        System.out.println();
        
        // Generate 5 different hashes (mỗi lần salt khác nhau)
        for (int i = 1; i <= 5; i++) {
            String salt = generateSalt();
            String hash = hashPassword(password, salt);
            String fullHash = hash + ":" + salt;
            
            System.out.println("Hash #" + i + ":");
            System.out.println("  Salt: " + salt);
            System.out.println("  Hash: " + hash);
            System.out.println("  Full: " + fullHash);
            System.out.println();
        }
        
        System.out.println("================================================");
        System.out.println("COPY 'Full' value vao SQL:");
        System.out.println("UPDATE users SET password_hash = 'FULL_HASH_HERE'");
        System.out.println("WHERE user_id IN (1, 2);");
        System.out.println("================================================");
    }
}

