package model.transaction;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * PendingTransaction - Giao dịch chờ xử lý
 * Giữ tiền tạm thời trước khi chuyển cho seller
 */
public class PendingTransaction {
    private Long pendingId;
    private Long orderId;
    private Integer buyerId;
    private Integer sellerId;
    private BigDecimal totalAmount;
    private BigDecimal sellerAmount;
    private BigDecimal platformFee;
    private String status; // PENDING, PROCESSING, COMPLETED, REFUNDED, CANCELLED
    private Timestamp holdUntil;
    private Timestamp releasedAt;
    private Long transactionId;
    private Long sellerTransactionId;
    private Long adminTransactionId;
    private String notes;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Joined fields (optional)
    private String buyerEmail;
    private String buyerName;
    private String sellerEmail;
    private String sellerName;
    private String orderNumber;
    private Long productId;
    
    public PendingTransaction() {
    }
    
    // Getters and Setters
    public Long getPendingId() {
        return pendingId;
    }
    
    public void setPendingId(Long pendingId) {
        this.pendingId = pendingId;
    }
    
    public Long getOrderId() {
        return orderId;
    }
    
    public void setOrderId(Long orderId) {
        this.orderId = orderId;
    }
    
    public Integer getBuyerId() {
        return buyerId;
    }
    
    public void setBuyerId(Integer buyerId) {
        this.buyerId = buyerId;
    }
    
    public Integer getSellerId() {
        return sellerId;
    }
    
    public void setSellerId(Integer sellerId) {
        this.sellerId = sellerId;
    }
    
    public BigDecimal getTotalAmount() {
        return totalAmount;
    }
    
    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }
    
    public BigDecimal getSellerAmount() {
        return sellerAmount;
    }
    
    public void setSellerAmount(BigDecimal sellerAmount) {
        this.sellerAmount = sellerAmount;
    }
    
    public BigDecimal getPlatformFee() {
        return platformFee;
    }
    
    public void setPlatformFee(BigDecimal platformFee) {
        this.platformFee = platformFee;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Timestamp getHoldUntil() {
        return holdUntil;
    }
    
    public void setHoldUntil(Timestamp holdUntil) {
        this.holdUntil = holdUntil;
    }
    
    public Timestamp getReleasedAt() {
        return releasedAt;
    }
    
    public void setReleasedAt(Timestamp releasedAt) {
        this.releasedAt = releasedAt;
    }
    
    public Long getTransactionId() {
        return transactionId;
    }
    
    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }
    
    public Long getSellerTransactionId() {
        return sellerTransactionId;
    }
    
    public void setSellerTransactionId(Long sellerTransactionId) {
        this.sellerTransactionId = sellerTransactionId;
    }
    
    public Long getAdminTransactionId() {
        return adminTransactionId;
    }
    
    public void setAdminTransactionId(Long adminTransactionId) {
        this.adminTransactionId = adminTransactionId;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
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
    
    // Joined fields getters/setters
    public String getBuyerEmail() {
        return buyerEmail;
    }
    
    public void setBuyerEmail(String buyerEmail) {
        this.buyerEmail = buyerEmail;
    }
    
    public String getBuyerName() {
        return buyerName;
    }
    
    public void setBuyerName(String buyerName) {
        this.buyerName = buyerName;
    }
    
    public String getSellerEmail() {
        return sellerEmail;
    }
    
    public void setSellerEmail(String sellerEmail) {
        this.sellerEmail = sellerEmail;
    }
    
    public String getSellerName() {
        return sellerName;
    }
    
    public void setSellerName(String sellerName) {
        this.sellerName = sellerName;
    }
    
    public String getOrderNumber() {
        return orderNumber;
    }
    
    public void setOrderNumber(String orderNumber) {
        this.orderNumber = orderNumber;
    }
    
    public Long getProductId() {
        return productId;
    }
    
    public void setProductId(Long productId) {
        this.productId = productId;
    }
}

