package model.order;

import java.sql.Timestamp;

/**
 * DigitalProduct Model - Tài nguyên số (mã thẻ, tài khoản, serial)
 */
public class DigitalProduct {
    
    public enum ProductStatus { AVAILABLE, SOLD, EXPIRED, INVALID }
    
    private Long digitalId;
    private Long productId;
    private String code;           // Mã thẻ cào / Username
    private String password;       // Mật khẩu (nếu là tài khoản)
    private String serial;         // Serial (nếu là thẻ cào)
    private String additionalInfo; // JSON thông tin thêm
    private String status;         // AVAILABLE, SOLD, EXPIRED, INVALID
    private Long soldToUserId;
    private Long soldInOrderId;
    private Timestamp soldAt;
    private Timestamp expiresAt;
    private Timestamp createdAt;
    
    // Joined data
    private String productName;

    // Constructors
    public DigitalProduct() {
    }

    public DigitalProduct(Long digitalId, Long productId, String code, String status) {
        this.digitalId = digitalId;
        this.productId = productId;
        this.code = code;
        this.status = status;
    }

    // Getters and Setters
    public Long getDigitalId() {
        return digitalId;
    }

    public void setDigitalId(Long digitalId) {
        this.digitalId = digitalId;
    }

    public Long getProductId() {
        return productId;
    }

    public void setProductId(Long productId) {
        this.productId = productId;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getSerial() {
        return serial;
    }

    public void setSerial(String serial) {
        this.serial = serial;
    }

    public String getAdditionalInfo() {
        return additionalInfo;
    }

    public void setAdditionalInfo(String additionalInfo) {
        this.additionalInfo = additionalInfo;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Long getSoldToUserId() {
        return soldToUserId;
    }

    public void setSoldToUserId(Long soldToUserId) {
        this.soldToUserId = soldToUserId;
    }

    public Long getSoldInOrderId() {
        return soldInOrderId;
    }

    public void setSoldInOrderId(Long soldInOrderId) {
        this.soldInOrderId = soldInOrderId;
    }

    public Timestamp getSoldAt() {
        return soldAt;
    }

    public void setSoldAt(Timestamp soldAt) {
        this.soldAt = soldAt;
    }

    public Timestamp getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(Timestamp expiresAt) {
        this.expiresAt = expiresAt;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    @Override
    public String toString() {
        return "DigitalProduct{" +
                "digitalId=" + digitalId +
                ", productId=" + productId +
                ", code='" + code + '\'' +
                ", status='" + status + '\'' +
                ", soldToUserId=" + soldToUserId +
                ", soldInOrderId=" + soldInOrderId +
                '}';
    }
}

