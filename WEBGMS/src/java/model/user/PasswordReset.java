package model.user;

import java.sql.Timestamp;

public class PasswordReset {
    private int reset_id;
    private String email;
    private String verification_code;
    private Timestamp created_at;
    private Timestamp expires_at;
    private boolean used;
    private Timestamp used_at;

    public PasswordReset() {
    }

    public PasswordReset(int reset_id, String email, String verification_code, 
                        Timestamp created_at, Timestamp expires_at, 
                        boolean used, Timestamp used_at) {
        this.reset_id = reset_id;
        this.email = email;
        this.verification_code = verification_code;
        this.created_at = created_at;
        this.expires_at = expires_at;
        this.used = used;
        this.used_at = used_at;
    }

    // Getters and Setters
    public int getReset_id() {
        return reset_id;
    }

    public void setReset_id(int reset_id) {
        this.reset_id = reset_id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getVerification_code() {
        return verification_code;
    }

    public void setVerification_code(String verification_code) {
        this.verification_code = verification_code;
    }

    public Timestamp getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Timestamp created_at) {
        this.created_at = created_at;
    }

    public Timestamp getExpires_at() {
        return expires_at;
    }

    public void setExpires_at(Timestamp expires_at) {
        this.expires_at = expires_at;
    }

    public boolean isUsed() {
        return used;
    }

    public void setUsed(boolean used) {
        this.used = used;
    }

    public Timestamp getUsed_at() {
        return used_at;
    }

    public void setUsed_at(Timestamp used_at) {
        this.used_at = used_at;
    }

    // Camel case getters for better Java ergonomics
    public int getResetId() {
        return reset_id;
    }

    public void setResetId(int resetId) {
        this.reset_id = resetId;
    }

    public String getVerificationCode() {
        return verification_code;
    }

    public void setVerificationCode(String verificationCode) {
        this.verification_code = verificationCode;
    }

    public Timestamp getCreatedAt() {
        return created_at;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.created_at = createdAt;
    }

    public Timestamp getExpiresAt() {
        return expires_at;
    }

    public void setExpiresAt(Timestamp expiresAt) {
        this.expires_at = expiresAt;
    }

    public boolean getUsed() {
        return used;
    }

    public Timestamp getUsedAt() {
        return used_at;
    }

    public void setUsedAt(Timestamp usedAt) {
        this.used_at = usedAt;
    }

    @Override
    public String toString() {
        return "PasswordReset{" +
                "reset_id=" + reset_id +
                ", email='" + email + '\'' +
                ", verification_code='" + verification_code + '\'' +
                ", created_at=" + created_at +
                ", expires_at=" + expires_at +
                ", used=" + used +
                ", used_at=" + used_at +
                '}';
    }
}
