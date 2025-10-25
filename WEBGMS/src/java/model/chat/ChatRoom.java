package model.chat;

import java.sql.Timestamp;

public class ChatRoom {
    private Long roomId;
    private String roomType; // customer_seller, customer_admin, seller_admin, group
    private String roomName;
    private Long productId;
    private Long orderId;
    private boolean isActive;
    private Timestamp lastMessageAt;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public ChatRoom() {
    }

    public ChatRoom(Long roomId, String roomType, String roomName, Long productId, Long orderId, 
                    boolean isActive, Timestamp lastMessageAt, Timestamp createdAt, Timestamp updatedAt) {
        this.roomId = roomId;
        this.roomType = roomType;
        this.roomName = roomName;
        this.productId = productId;
        this.orderId = orderId;
        this.isActive = isActive;
        this.lastMessageAt = lastMessageAt;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
    public Long getRoomId() {
        return roomId;
    }

    public void setRoomId(Long roomId) {
        this.roomId = roomId;
    }

    public String getRoomType() {
        return roomType;
    }

    public void setRoomType(String roomType) {
        this.roomType = roomType;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public Long getProductId() {
        return productId;
    }

    public void setProductId(Long productId) {
        this.productId = productId;
    }

    public Long getOrderId() {
        return orderId;
    }

    public void setOrderId(Long orderId) {
        this.orderId = orderId;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public Timestamp getLastMessageAt() {
        return lastMessageAt;
    }

    public void setLastMessageAt(Timestamp lastMessageAt) {
        this.lastMessageAt = lastMessageAt;
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

    @Override
    public String toString() {
        return "ChatRoom{" +
                "roomId=" + roomId +
                ", roomType='" + roomType + '\'' +
                ", roomName='" + roomName + '\'' +
                ", productId=" + productId +
                ", orderId=" + orderId +
                ", isActive=" + isActive +
                ", lastMessageAt=" + lastMessageAt +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}
