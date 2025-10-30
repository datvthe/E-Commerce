package model.blog;

import model.user.Users;
import java.sql.Timestamp;
import java.util.List;

/**
 * Model cho Blog
 * - User/Seller có thể tạo blog
 * - Admin phê duyệt/từ chối
 * - Hiển thị blog đã approved trên trang chủ
 */
public class Blog {
    
    // Primary fields
    private Long blogId;
    private Integer userId;
    
    // Content fields
    private String title;
    private String slug;
    private String summary;
    private String content;
    private String featuredImage;
    
    // Moderation fields
    private String status; // DRAFT, PENDING, APPROVED, REJECTED
    private Integer moderatorId;
    private String moderationNote;
    private Timestamp moderatedAt;
    
    // SEO fields
    private String metaTitle;
    private String metaDescription;
    private String metaKeywords;
    
    // Statistics
    private int viewCount;
    private int likeCount;
    private int commentCount;
    
    // Timestamps
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Timestamp publishedAt;
    
    // Relationships (for JOIN queries)
    private Users author; // Tác giả
    private Users moderator; // Admin phê duyệt
    private List<BlogImage> images; // Ảnh trong blog
    private List<BlogComment> comments; // Bình luận
    
    // Derived fields
    private boolean isLikedByCurrentUser;
    
    // ================================================
    // CONSTRUCTORS
    // ================================================
    
    public Blog() {
    }
    
    public Blog(Long blogId, Integer userId, String title, String slug, 
                String summary, String content, String status) {
        this.blogId = blogId;
        this.userId = userId;
        this.title = title;
        this.slug = slug;
        this.summary = summary;
        this.content = content;
        this.status = status;
    }
    
    // ================================================
    // GETTERS & SETTERS
    // ================================================
    
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
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getSlug() {
        return slug;
    }
    
    public void setSlug(String slug) {
        this.slug = slug;
    }
    
    public String getSummary() {
        return summary;
    }
    
    public void setSummary(String summary) {
        this.summary = summary;
    }
    
    public String getContent() {
        return content;
    }
    
    public void setContent(String content) {
        this.content = content;
    }
    
    public String getFeaturedImage() {
        return featuredImage;
    }
    
    public void setFeaturedImage(String featuredImage) {
        this.featuredImage = featuredImage;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Integer getModeratorId() {
        return moderatorId;
    }
    
    public void setModeratorId(Integer moderatorId) {
        this.moderatorId = moderatorId;
    }
    
    public String getModerationNote() {
        return moderationNote;
    }
    
    public void setModerationNote(String moderationNote) {
        this.moderationNote = moderationNote;
    }
    
    public Timestamp getModeratedAt() {
        return moderatedAt;
    }
    
    public void setModeratedAt(Timestamp moderatedAt) {
        this.moderatedAt = moderatedAt;
    }
    
    public String getMetaTitle() {
        return metaTitle;
    }
    
    public void setMetaTitle(String metaTitle) {
        this.metaTitle = metaTitle;
    }
    
    public String getMetaDescription() {
        return metaDescription;
    }
    
    public void setMetaDescription(String metaDescription) {
        this.metaDescription = metaDescription;
    }
    
    public String getMetaKeywords() {
        return metaKeywords;
    }
    
    public void setMetaKeywords(String metaKeywords) {
        this.metaKeywords = metaKeywords;
    }
    
    public int getViewCount() {
        return viewCount;
    }
    
    public void setViewCount(int viewCount) {
        this.viewCount = viewCount;
    }
    
    public int getLikeCount() {
        return likeCount;
    }
    
    public void setLikeCount(int likeCount) {
        this.likeCount = likeCount;
    }
    
    public int getCommentCount() {
        return commentCount;
    }
    
    public void setCommentCount(int commentCount) {
        this.commentCount = commentCount;
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
    
    public Timestamp getPublishedAt() {
        return publishedAt;
    }
    
    public void setPublishedAt(Timestamp publishedAt) {
        this.publishedAt = publishedAt;
    }
    
    public Users getAuthor() {
        return author;
    }
    
    public void setAuthor(Users author) {
        this.author = author;
    }
    
    public Users getModerator() {
        return moderator;
    }
    
    public void setModerator(Users moderator) {
        this.moderator = moderator;
    }
    
    public List<BlogImage> getImages() {
        return images;
    }
    
    public void setImages(List<BlogImage> images) {
        this.images = images;
    }
    
    public List<BlogComment> getComments() {
        return comments;
    }
    
    public void setComments(List<BlogComment> comments) {
        this.comments = comments;
    }
    
    public boolean isLikedByCurrentUser() {
        return isLikedByCurrentUser;
    }
    
    public void setLikedByCurrentUser(boolean likedByCurrentUser) {
        isLikedByCurrentUser = likedByCurrentUser;
    }
    
    // ================================================
    // UTILITY METHODS
    // ================================================
    
    /**
     * Check if blog is editable by user
     * Only DRAFT or REJECTED can be edited
     */
    public boolean isEditable() {
        return "DRAFT".equals(status) || "REJECTED".equals(status);
    }
    
    /**
     * Check if blog is deletable by user
     * Can delete if not APPROVED
     */
    public boolean isDeletable() {
        return !"APPROVED".equals(status);
    }
    
    /**
     * Check if blog is public (visible to everyone)
     */
    public boolean isPublic() {
        return "APPROVED".equals(status);
    }
    
    /**
     * Check if blog is waiting for moderation
     */
    public boolean isPending() {
        return "PENDING".equals(status);
    }
    
    /**
     * Generate slug from title (URL-friendly)
     * Example: "My Blog Title" -> "my-blog-title"
     */
    public static String generateSlug(String title) {
        if (title == null || title.trim().isEmpty()) {
            return "";
        }
        
        return title.toLowerCase()
                    .trim()
                    .replaceAll("[àáạảãâầấậẩẫăằắặẳẵ]", "a")
                    .replaceAll("[èéẹẻẽêềếệểễ]", "e")
                    .replaceAll("[ìíịỉĩ]", "i")
                    .replaceAll("[òóọỏõôồốộổỗơờớợởỡ]", "o")
                    .replaceAll("[ùúụủũưừứựửữ]", "u")
                    .replaceAll("[ỳýỵỷỹ]", "y")
                    .replaceAll("[đ]", "d")
                    .replaceAll("[^a-z0-9\\s-]", "") // Remove special chars
                    .replaceAll("\\s+", "-") // Replace spaces with -
                    .replaceAll("-+", "-") // Remove duplicate -
                    .replaceAll("^-|-$", ""); // Remove leading/trailing -
    }
    
    /**
     * Get short summary for display (max 200 chars)
     */
    public String getShortSummary() {
        if (summary == null) return "";
        if (summary.length() <= 200) return summary;
        return summary.substring(0, 197) + "...";
    }
    
    /**
     * Get reading time estimate (minutes)
     */
    public int getReadingTime() {
        if (content == null) return 0;
        // Average reading speed: 200 words/minute
        int wordCount = content.split("\\s+").length;
        return Math.max(1, wordCount / 200);
    }
    
    @Override
    public String toString() {
        return "Blog{" +
                "blogId=" + blogId +
                ", userId=" + userId +
                ", title='" + title + '\'' +
                ", slug='" + slug + '\'' +
                ", status='" + status + '\'' +
                ", viewCount=" + viewCount +
                ", likeCount=" + likeCount +
                ", commentCount=" + commentCount +
                ", createdAt=" + createdAt +
                ", publishedAt=" + publishedAt +
                '}';
    }
}

