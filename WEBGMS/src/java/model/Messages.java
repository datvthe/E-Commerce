/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import model.user.Users;
import java.time.LocalDateTime;

public class Messages {

    private int messageId;
    private Users senderId;       
    private Users receiverId;   
    private String content;      
    private String type;         // ENUM: chat, system
    private String status;       // ENUM: sent, delivered, read
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Messages{" + "messageId=" + messageId + ", senderId=" + senderId + ", receiverId=" + receiverId + ", content=" + content + ", type=" + type + ", status=" + status + ", createdAt=" + createdAt + '}';
    }

}
