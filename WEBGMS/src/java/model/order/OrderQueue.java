package model.order;

import java.sql.Timestamp;

/**
 * OrderQueue Model - Hàng đợi xử lý đơn hàng
 */
public class OrderQueue {
    
    public enum QueueStatus { WAITING, PROCESSING, COMPLETED, FAILED }
    
    private Long queueId;
    private Long orderId;
    private Integer priority;        // Độ ưu tiên (số càng cao càng ưu tiên)
    private String status;           // WAITING, PROCESSING, COMPLETED, FAILED
    private Integer attempts;        // Số lần thử xử lý
    private String errorMessage;
    private String processorId;      // ID của worker đang xử lý
    private Timestamp createdAt;
    private Timestamp startedAt;
    private Timestamp completedAt;
    
    // Joined data
    private Orders order;

    // Constructors
    public OrderQueue() {
    }

    public OrderQueue(Long queueId, Long orderId, Integer priority, String status) {
        this.queueId = queueId;
        this.orderId = orderId;
        this.priority = priority;
        this.status = status;
    }

    // Getters and Setters
    public Long getQueueId() {
        return queueId;
    }

    public void setQueueId(Long queueId) {
        this.queueId = queueId;
    }

    public Long getOrderId() {
        return orderId;
    }

    public void setOrderId(Long orderId) {
        this.orderId = orderId;
    }

    public Integer getPriority() {
        return priority;
    }

    public void setPriority(Integer priority) {
        this.priority = priority;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getAttempts() {
        return attempts;
    }

    public void setAttempts(Integer attempts) {
        this.attempts = attempts;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public String getProcessorId() {
        return processorId;
    }

    public void setProcessorId(String processorId) {
        this.processorId = processorId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getStartedAt() {
        return startedAt;
    }

    public void setStartedAt(Timestamp startedAt) {
        this.startedAt = startedAt;
    }

    public Timestamp getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(Timestamp completedAt) {
        this.completedAt = completedAt;
    }

    public Orders getOrder() {
        return order;
    }

    public void setOrder(Orders order) {
        this.order = order;
    }

    @Override
    public String toString() {
        return "OrderQueue{" +
                "queueId=" + queueId +
                ", orderId=" + orderId +
                ", priority=" + priority +
                ", status='" + status + '\'' +
                ", attempts=" + attempts +
                ", processorId='" + processorId + '\'' +
                '}';
    }
}

