package model.chat;

import java.sql.Timestamp;

public class ChatMessage {
    private Long messageId;
    private Long roomId;
    private Long senderId;
    private String senderRole; // customer, seller, admin, ai
    private String messageType; // text, image, file, product, order, system
    private String messageContent;
    private String attachmentUrl;
    private String metadata; // JSON string
    private boolean isAiResponse;
    private boolean isRead;
    private boolean isEdited;
    private boolean isDeleted;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Additional fields for display
    private String senderName;
    private String senderAvatar;

    public ChatMessage() {
    }

    public ChatMessage(Long messageId, Long roomId, Long senderId, String senderRole, 
                      String messageType, String messageContent, String attachmentUrl, 
                      String metadata, boolean isAiResponse, boolean isRead, boolean isEdited, 
                      boolean isDeleted, Timestamp createdAt, Timestamp updatedAt) {
        this.messageId = messageId;
        this.roomId = roomId;
        this.senderId = senderId;
        this.senderRole = senderRole;
        this.messageType = messageType;
        this.messageContent = messageContent;
        this.attachmentUrl = attachmentUrl;
        this.metadata = metadata;
        this.isAiResponse = isAiResponse;
        this.isRead = isRead;
        this.isEdited = isEdited;
        this.isDeleted = isDeleted;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
    public Long getMessageId() {
        return messageId;
    }

    public void setMessageId(Long messageId) {
        this.messageId = messageId;
    }

    public Long getRoomId() {
        return roomId;
    }

    public void setRoomId(Long roomId) {
        this.roomId = roomId;
    }

    public Long getSenderId() {
        return senderId;
    }

    public void setSenderId(Long senderId) {
        this.senderId = senderId;
    }

    public String getSenderRole() {
        return senderRole;
    }

    public void setSenderRole(String senderRole) {
        this.senderRole = senderRole;
    }

    public String getMessageType() {
        return messageType;
    }

    public void setMessageType(String messageType) {
        this.messageType = messageType;
    }

    public String getMessageContent() {
        return messageContent;
    }

    public void setMessageContent(String messageContent) {
        this.messageContent = messageContent;
    }

    public String getAttachmentUrl() {
        return attachmentUrl;
    }

    public void setAttachmentUrl(String attachmentUrl) {
        this.attachmentUrl = attachmentUrl;
    }

    public String getMetadata() {
        return metadata;
    }

    public void setMetadata(String metadata) {
        this.metadata = metadata;
    }

    public boolean isAiResponse() {
        return isAiResponse;
    }

    public void setAiResponse(boolean aiResponse) {
        isAiResponse = aiResponse;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean read) {
        isRead = read;
    }

    public boolean isEdited() {
        return isEdited;
    }

    public void setEdited(boolean edited) {
        isEdited = edited;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public void setDeleted(boolean deleted) {
        isDeleted = deleted;
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

    public String getSenderName() {
        return senderName;
    }

    public void setSenderName(String senderName) {
        this.senderName = senderName;
    }

    public String getSenderAvatar() {
        return senderAvatar;
    }

    public void setSenderAvatar(String senderAvatar) {
        this.senderAvatar = senderAvatar;
    }

    @Override
    public String toString() {
        return "ChatMessage{" +
                "messageId=" + messageId +
                ", roomId=" + roomId +
                ", senderId=" + senderId +
                ", senderRole='" + senderRole + '\'' +
                ", messageType='" + messageType + '\'' +
                ", messageContent='" + messageContent + '\'' +
                ", isAiResponse=" + isAiResponse +
                ", isRead=" + isRead +
                ", createdAt=" + createdAt +
                '}';
    }
}
