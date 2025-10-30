package model.blog;

import java.sql.Timestamp;

/**
 * Blog Comment Model
 */
public class BlogComment {
    private Long commentId;
    private Long blogId;
    private Long userId;  // Changed from Integer to Long
    private String userName;
    private String userAvatar;
    private String content;
    private Long parentCommentId;
    private Boolean isDeleted;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // For nested replies
    private int replyCount;
    
    // Constructors
    public BlogComment() {
        this.isDeleted = false;
        this.replyCount = 0;
    }
    
    public BlogComment(Long blogId, Long userId, String content, Long parentCommentId) {
        this.blogId = blogId;
        this.userId = userId;
        this.content = content;
        this.parentCommentId = parentCommentId;
        this.isDeleted = false;
        this.replyCount = 0;
    }
    
    // Getters and Setters
    public Long getCommentId() {
        return commentId;
    }
    
    public void setCommentId(Long commentId) {
        this.commentId = commentId;
    }
    
    public Long getBlogId() {
        return blogId;
    }
    
    public void setBlogId(Long blogId) {
        this.blogId = blogId;
    }
    
    public Long getUserId() {
        return userId;
    }
    
    public void setUserId(Long userId) {
        this.userId = userId;
    }
    
    public String getUserName() {
        return userName;
    }
    
    public void setUserName(String userName) {
        this.userName = userName;
    }
    
    public String getUserAvatar() {
        return userAvatar;
    }
    
    public void setUserAvatar(String userAvatar) {
        this.userAvatar = userAvatar;
    }
    
    public String getContent() {
        return content;
    }
    
    public void setContent(String content) {
        this.content = content;
    }
    
    public Long getParentCommentId() {
        return parentCommentId;
    }
    
    public void setParentCommentId(Long parentCommentId) {
        this.parentCommentId = parentCommentId;
    }
    
    public Boolean getIsDeleted() {
        return isDeleted;
    }
    
    public void setIsDeleted(Boolean isDeleted) {
        this.isDeleted = isDeleted;
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
    
    public int getReplyCount() {
        return replyCount;
    }
    
    public void setReplyCount(int replyCount) {
        this.replyCount = replyCount;
    }
    
    @Override
    public String toString() {
        return "BlogComment{" +
                "commentId=" + commentId +
                ", blogId=" + blogId +
                ", userId=" + userId +
                ", userName='" + userName + '\'' +
                ", content='" + content + '\'' +
                ", parentCommentId=" + parentCommentId +
                ", isDeleted=" + isDeleted +
                ", createdAt=" + createdAt +
                ", replyCount=" + replyCount +
                '}';
    }
}
