/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import model.user.Users;
import java.time.LocalDateTime;

public class Messages {

    public enum MessageType { CHAT, SYSTEM }
    public enum MessageStatus { SENT, DELIVERED, READ }

    private int messageId;
    private Users senderId;       
    private Users receiverId;   
    private String content;      
    private String type;         // kept for compatibility; use getTypeEnum/setTypeEnum
    private String status;       // kept for compatibility; use getStatusEnum/setStatusEnum
    private LocalDateTime createdAt;

    public Messages() {
    }

    public Messages(int messageId, Users senderId, Users receiverId, String content, String type, String status, LocalDateTime createdAt) {
        this.messageId = messageId;
        this.senderId = senderId;
        this.receiverId = receiverId;
        this.content = content;
        this.type = type;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getMessageId() {
        return messageId;
    }

    public void setMessageId(int messageId) {
        this.messageId = messageId;
    }

    public Users getSenderId() {
        return senderId;
    }

    public void setSenderId(Users senderId) {
        this.senderId = senderId;
    }

    public Users getReceiverId() {
        return receiverId;
    }

    public void setReceiverId(Users receiverId) {
        this.receiverId = receiverId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public MessageType getTypeEnum() {
        if (type == null) return null;
        return MessageType.valueOf(type.trim().toUpperCase());
    }

    public void setTypeEnum(MessageType typeEnum) {
        this.type = typeEnum == null ? null : typeEnum.name().toLowerCase();
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public MessageStatus getStatusEnum() {
        if (status == null) return null;
        return MessageStatus.valueOf(status.trim().toUpperCase());
    }

    public void setStatusEnum(MessageStatus statusEnum) {
        this.status = statusEnum == null ? null : statusEnum.name().toLowerCase();
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Messages{"
                + "messageId=" + messageId
                + ", senderId=" + (senderId == null ? null : senderId.getUser_id())
                + ", receiverId=" + (receiverId == null ? null : receiverId.getUser_id())
                + ", contentLength=" + (content == null ? 0 : content.length())
                + ", type=" + type
                + ", status=" + status
                + ", createdAt=" + createdAt
                + '}';
    }

    @Override
    public int hashCode() { return Integer.hashCode(messageId); }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Messages other = (Messages) obj;
        return this.messageId == other.messageId;
    }

}
