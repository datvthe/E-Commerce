package model.order;

import java.sql.Timestamp;

/**
 * Model cho digital_goods_codes table
 */
public class DigitalGoodsCode {
    
    private Integer codeId;
    private Long productId;
    private String codeValue;
    private String codeType;  // gift_card, account, license, file_url
    private Boolean isUsed;
    private Long usedBy;
    private Timestamp usedAt;
    private Timestamp expiresAt;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // For complex code_type (accounts, licenses)
    private String serial;
    private String password;
    
    public DigitalGoodsCode() {
    }
    
    // Getters and Setters
    public Integer getCodeId() {
        return codeId;
    }
    
    public void setCodeId(Integer codeId) {
        this.codeId = codeId;
    }
    
    public Long getProductId() {
        return productId;
    }
    
    public void setProductId(Long productId) {
        this.productId = productId;
    }
    
    public String getCodeValue() {
        return codeValue;
    }
    
    public void setCodeValue(String codeValue) {
        this.codeValue = codeValue;
    }
    
    public String getCodeType() {
        return codeType;
    }
    
    public void setCodeType(String codeType) {
        this.codeType = codeType;
    }
    
    public Boolean getIsUsed() {
        return isUsed;
    }
    
    public void setIsUsed(Boolean isUsed) {
        this.isUsed = isUsed;
    }
    
    public Long getUsedBy() {
        return usedBy;
    }
    
    public void setUsedBy(Long usedBy) {
        this.usedBy = usedBy;
    }
    
    public Timestamp getUsedAt() {
        return usedAt;
    }
    
    public void setUsedAt(Timestamp usedAt) {
        this.usedAt = usedAt;
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
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public String getSerial() {
        return serial;
    }
    
    public void setSerial(String serial) {
        this.serial = serial;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    @Override
    public String toString() {
        return "DigitalGoodsCode{" +
                "codeId=" + codeId +
                ", productId=" + productId +
                ", codeValue='" + codeValue + '\'' +
                ", codeType='" + codeType + '\'' +
                ", isUsed=" + isUsed +
                '}';
    }
}

