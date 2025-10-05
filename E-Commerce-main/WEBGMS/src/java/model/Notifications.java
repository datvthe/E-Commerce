/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import model.user.Users;
import java.time.LocalDateTime;

public class Notifications {

    public enum NotificationType { ORDER, PROMOTION, WALLET, SYSTEM }
    public enum NotificationStatus { UNREAD, READ }

    private int notificationId;
    private Users userId;       
    private String title;    
    private String message;    
    private String type;        // kept for compatibility; use getTypeEnum/setTypeEnum
    private String status;      // kept for compatibility; use getStatusEnum/setStatusEnum
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

    public NotificationType getTypeEnum() {
        if (type == null) return null;
        return NotificationType.valueOf(type.trim().toUpperCase());
    }

    public void setTypeEnum(NotificationType typeEnum) {
        this.type = typeEnum == null ? null : typeEnum.name().toLowerCase();
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public NotificationStatus getStatusEnum() {
        if (status == null) return null;
        return NotificationStatus.valueOf(status.trim().toUpperCase());
    }

    public void setStatusEnum(NotificationStatus statusEnum) {
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
        return "Notifications{"
                + "notificationId=" + notificationId
                + ", userId=" + (userId == null ? null : userId.getUser_id())
                + ", title=" + title
                + ", messageLength=" + (message == null ? 0 : message.length())
                + ", type=" + type
                + ", status=" + status
                + ", createdAt=" + createdAt
                + '}';
    }

    @Override
    public int hashCode() { return Integer.hashCode(notificationId); }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Notifications other = (Notifications) obj;
        return this.notificationId == other.notificationId;
    }

}
