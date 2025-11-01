package model.blog;

import java.sql.Timestamp;

/**
 * Model cho Blog Images
 * - Ảnh gallery trong blog
 * - Có thể có nhiều ảnh cho 1 blog
 */
public class BlogImage {
    
    private Long imageId;
    private Long blogId;
    private String imageUrl;
    private String caption;
    private int displayOrder;
    private Timestamp createdAt;
    
    // ================================================
    // CONSTRUCTORS
    // ================================================
    
    public BlogImage() {
    }
    
    public BlogImage(Long blogId, String imageUrl, String caption, int displayOrder) {
        this.blogId = blogId;
        this.imageUrl = imageUrl;
        this.caption = caption;
        this.displayOrder = displayOrder;
    }
    
    // ================================================
    // GETTERS & SETTERS
    // ================================================
    
    public Long getImageId() {
        return imageId;
    }
    
    public void setImageId(Long imageId) {
        this.imageId = imageId;
    }
    
    public Long getBlogId() {
        return blogId;
    }
    
    public void setBlogId(Long blogId) {
        this.blogId = blogId;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public String getCaption() {
        return caption;
    }
    
    public void setCaption(String caption) {
        this.caption = caption;
    }
    
    public int getDisplayOrder() {
        return displayOrder;
    }
    
    public void setDisplayOrder(int displayOrder) {
        this.displayOrder = displayOrder;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    @Override
    public String toString() {
        return "BlogImage{" +
                "imageId=" + imageId +
                ", blogId=" + blogId +
                ", imageUrl='" + imageUrl + '\'' +
                ", displayOrder=" + displayOrder +
                '}';
    }
}

