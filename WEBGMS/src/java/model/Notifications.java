/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import model.user.Users;
import java.time.LocalDateTime;

public class Notifications {

    private int notificationId;
    private Users userId;       
    private String title;    
    private String message;    
    private String type;        // ENUM: order, promotion, wallet, system
    private String status;      // ENUM: unread, read
    private LocalDateTime createdAt;

    public Notifications() {
    }

    public Notifications(int notificationId, Users userId, String title, String message, String type, String status, LocalDateTime createdAt) {
        this.notificationId = notificationId;
        this.userId = userId;
        this.title = title;
        this.message = message;
        this.type = type;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }

    public Users getUserId() {
        return userId;
    }

    public void setUserId(Users userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
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
        return "Notifications{" + "notificationId=" + notificationId + ", userId=" + userId + ", title=" + title + ", message=" + message + ", type=" + type + ", status=" + status + ", createdAt=" + createdAt + '}';
    }

}
