package model.blog;

import java.sql.Timestamp;

/**
 * Model cho Blog Notifications
 * - Thông báo khi blog được approved/rejected
 * - Thông báo khi có comment/like mới
 */
public class BlogNotification {
    
    private Long notificationId;
    private Long blogId;
    private Integer userId;
    private String type; // APPROVED, REJECTED, COMMENT, LIKE
    private String title;
    private String message;
    private boolean isRead;
    private Timestamp createdAt;
    
    // Relationship
    private Blog blog;
    
    // ================================================
    // CONSTRUCTORS
    // ================================================
    
    public BlogNotification() {
    }
    
    public BlogNotification(Long blogId, Integer userId, String type, 
                           String title, String message) {
        this.blogId = blogId;
        this.userId = userId;
        this.type = type;
        this.title = title;
        this.message = message;
        this.isRead = false;
    }
    
    // ================================================
    // GETTERS & SETTERS
    // ================================================
    
    public Long getNotificationId() {
        return notificationId;
    }
    
    public void setNotificationId(Long notificationId) {
        this.notificationId = notificationId;
    }
    
    public Long getBlogId() {
        return blogId;
    }
    
    public void setBlogId(Long blogId) {
        this.blogId = blogId;
    }
    
    public Integer getUserId() {
        return userId;
    }
    
    public void setUserId(Integer userId) {
        this.userId = userId;
    }
    
    public String getType() {
        return type;
    }
    
    public void setType(String type) {
        this.type = type;
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
    
    public boolean isRead() {
        return isRead;
    }
    
    public void setRead(boolean read) {
        isRead = read;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Blog getBlog() {
        return blog;
    }
    
    public void setBlog(Blog blog) {
        this.blog = blog;
    }
    
    // ================================================
    // UTILITY METHODS
    // ================================================
    
    /**
     * Get icon for notification type
     */
    public String getIcon() {
        switch (type) {
            case "APPROVED":
                return "🎉";
            case "REJECTED":
                return "❌";
            case "COMMENT":
                return "💬";
            case "LIKE":
                return "❤️";
            default:
                return "🔔";
        }
    }
    
    /**
     * Get CSS class for notification type
     */
    public String getCssClass() {
        switch (type) {
            case "APPROVED":
                return "success";
            case "REJECTED":
                return "danger";
            case "COMMENT":
                return "info";
            case "LIKE":
                return "warning";
            default:
                return "secondary";
        }
    }
    
    @Override
    public String toString() {
        return "BlogNotification{" +
                "notificationId=" + notificationId +
                ", blogId=" + blogId +
                ", userId=" + userId +
                ", type='" + type + '\'' +
                ", title='" + title + '\'' +
                ", isRead=" + isRead +
                ", createdAt=" + createdAt +
                '}';
    }
}

