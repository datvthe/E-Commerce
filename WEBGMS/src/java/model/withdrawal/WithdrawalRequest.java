package model.withdrawal;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Model class for Withdrawal Requests
 * Đại diện cho yêu cầu rút tiền của seller
 */
public class WithdrawalRequest {
    
    // Enums
    public enum Status {
        PENDING("pending", "Chờ duyệt"),
        APPROVED("approved", "Đã duyệt"),
        REJECTED("rejected", "Từ chối"),
        PROCESSING("processing", "Đang xử lý"),
        COMPLETED("completed", "Hoàn thành");
        
        private final String value;
        private final String label;
        
        Status(String value, String label) {
            this.value = value;
            this.label = label;
        }
        
        public String getValue() {
            return value;
        }
        
        public String getLabel() {
            return label;
        }
        
        public static Status fromValue(String value) {
            for (Status status : Status.values()) {
                if (status.value.equals(value)) {
                    return status;
                }
            }
            return PENDING;
        }
    }
    
    // Fields
    private Long requestId;
    private Long sellerId;
    private BigDecimal amount;
    private String bankName;
    private String bankAccountNumber;
    private String bankAccountName;
    private Status status;
    private String requestNote;
    private String adminNote;
    private Timestamp requestedAt;
    private Timestamp processedAt;
    private Long processedBy;
    private String transactionReference;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Additional fields for display (JOIN data)
    private String sellerName;
    private String sellerEmail;
    private String adminName;
    
    // Constructors
    public WithdrawalRequest() {
        this.status = Status.PENDING;
    }
    
    public WithdrawalRequest(Long sellerId, BigDecimal amount, String bankName, 
                            String bankAccountNumber, String bankAccountName) {
        this.sellerId = sellerId;
        this.amount = amount;
        this.bankName = bankName;
        this.bankAccountNumber = bankAccountNumber;
        this.bankAccountName = bankAccountName;
        this.status = Status.PENDING;
    }
    
    // Getters and Setters
    public Long getRequestId() {
        return requestId;
    }
    
    public void setRequestId(Long requestId) {
        this.requestId = requestId;
    }
    
    public Long getSellerId() {
        return sellerId;
    }
    
    public void setSellerId(Long sellerId) {
        this.sellerId = sellerId;
    }
    
    public BigDecimal getAmount() {
        return amount;
    }
    
    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
    
    public String getBankName() {
        return bankName;
    }
    
    public void setBankName(String bankName) {
        this.bankName = bankName;
    }
    
    public String getBankAccountNumber() {
        return bankAccountNumber;
    }
    
    public void setBankAccountNumber(String bankAccountNumber) {
        this.bankAccountNumber = bankAccountNumber;
    }
    
    public String getBankAccountName() {
        return bankAccountName;
    }
    
    public void setBankAccountName(String bankAccountName) {
        this.bankAccountName = bankAccountName;
    }
    
    public Status getStatus() {
        return status;
    }
    
    public void setStatus(Status status) {
        this.status = status;
    }
    
    public String getStatusValue() {
        return status != null ? status.getValue() : "pending";
    }
    
    public String getStatusLabel() {
        return status != null ? status.getLabel() : "Chờ duyệt";
    }
    
    public void setStatusFromString(String statusStr) {
        this.status = Status.fromValue(statusStr);
    }
    
    public String getRequestNote() {
        return requestNote;
    }
    
    public void setRequestNote(String requestNote) {
        this.requestNote = requestNote;
    }
    
    public String getAdminNote() {
        return adminNote;
    }
    
    public void setAdminNote(String adminNote) {
        this.adminNote = adminNote;
    }
    
    public Timestamp getRequestedAt() {
        return requestedAt;
    }
    
    public void setRequestedAt(Timestamp requestedAt) {
        this.requestedAt = requestedAt;
    }
    
    public Timestamp getProcessedAt() {
        return processedAt;
    }
    
    public void setProcessedAt(Timestamp processedAt) {
        this.processedAt = processedAt;
    }
    
    public Long getProcessedBy() {
        return processedBy;
    }
    
    public void setProcessedBy(Long processedBy) {
        this.processedBy = processedBy;
    }
    
    public String getTransactionReference() {
        return transactionReference;
    }
    
    public void setTransactionReference(String transactionReference) {
        this.transactionReference = transactionReference;
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
    
    // Additional display fields
    public String getSellerName() {
        return sellerName;
    }
    
    public void setSellerName(String sellerName) {
        this.sellerName = sellerName;
    }
    
    public String getSellerEmail() {
        return sellerEmail;
    }
    
    public void setSellerEmail(String sellerEmail) {
        this.sellerEmail = sellerEmail;
    }
    
    public String getAdminName() {
        return adminName;
    }
    
    public void setAdminName(String adminName) {
        this.adminName = adminName;
    }
    
    // Utility methods
    public boolean isPending() {
        return status == Status.PENDING;
    }
    
    public boolean isApproved() {
        return status == Status.APPROVED;
    }
    
    public boolean isRejected() {
        return status == Status.REJECTED;
    }
    
    public boolean isProcessing() {
        return status == Status.PROCESSING;
    }
    
    public boolean isCompleted() {
        return status == Status.COMPLETED;
    }
    
    public boolean canBeProcessed() {
        return status == Status.PENDING || status == Status.PROCESSING;
    }
    
    public String getStatusBadgeClass() {
        switch (status) {
            case PENDING:
                return "badge-warning";
            case APPROVED:
                return "badge-info";
            case PROCESSING:
                return "badge-primary";
            case COMPLETED:
                return "badge-success";
            case REJECTED:
                return "badge-danger";
            default:
                return "badge-secondary";
        }
    }
    
    @Override
    public String toString() {
        return "WithdrawalRequest{" +
                "requestId=" + requestId +
                ", sellerId=" + sellerId +
                ", amount=" + amount +
                ", status=" + status +
                ", requestedAt=" + requestedAt +
                '}';
    }
}


