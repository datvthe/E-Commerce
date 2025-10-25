package model.cms;

import java.time.LocalDateTime;
import model.user.Users;

public class Page {
    private int id;
    private String slug; // about, contact, return-policy, custom
    private String title;
    private String content; // HTML
    private String status; // draft, published
    private Users updatedBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Users getUpdatedBy() { return updatedBy; }
    public void setUpdatedBy(Users updatedBy) { this.updatedBy = updatedBy; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
