package model.user;

import java.sql.Timestamp;

/**
 * Model for email verification
 * Similar to PasswordReset model
 */
public class EmailVerification {
    
    private int verificationId;
    private String email;
    private String verificationCode;
    private Timestamp createdAt;
    private Timestamp expiresAt;
    private boolean used;
    private Timestamp usedAt;
    
    // Constructors
    public EmailVerification() {}
    
    public EmailVerification(String email, String verificationCode) {
        this.email = email;
        this.verificationCode = verificationCode;
    }
    
    // Getters and Setters
    public int getVerificationId() {
        return verificationId;
    }
    
    public void setVerificationId(int verificationId) {
        this.verificationId = verificationId;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getVerificationCode() {
        return verificationCode;
    }
    
    public void setVerificationCode(String verificationCode) {
        this.verificationCode = verificationCode;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getExpiresAt() {
        return expiresAt;
    }
    
    public void setExpiresAt(Timestamp expiresAt) {
        this.expiresAt = expiresAt;
    }
    
    public boolean isUsed() {
        return used;
    }
    
    public void setUsed(boolean used) {
        this.used = used;
    }
    
    public Timestamp getUsedAt() {
        return usedAt;
    }
    
    public void setUsedAt(Timestamp usedAt) {
        this.usedAt = usedAt;
    }
    
    // Utility method
    public boolean isExpired() {
        if (expiresAt == null) return true;
        return System.currentTimeMillis() > expiresAt.getTime();
    }
    
    @Override
    public String toString() {
        return "EmailVerification{" +
                "verificationId=" + verificationId +
                ", email='" + email + '\'' +
                ", verificationCode='" + verificationCode + '\'' +
                ", used=" + used +
                ", expired=" + isExpired() +
                '}';
    }
}

