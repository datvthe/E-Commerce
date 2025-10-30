package dao;

import model.blog.BlogComment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for Blog Comments
 */
public class BlogCommentDAO {
    
    /**
     * Add a new comment
     */
    public BlogComment addComment(BlogComment comment) throws SQLException {
        String sql = "INSERT INTO blog_comments (blog_id, user_id, content, parent_comment_id) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setLong(1, comment.getBlogId());
            ps.setLong(2, comment.getUserId());  // Changed from setInt to setLong
            ps.setString(3, comment.getContent());
            
            if (comment.getParentCommentId() != null) {
                ps.setLong(4, comment.getParentCommentId());
            } else {
                ps.setNull(4, Types.BIGINT);
            }
            
            ps.executeUpdate();
            
            // Get generated ID
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    comment.setCommentId(rs.getLong(1));
                }
            }
            
            // Update comment count in blogs table
            updateBlogCommentCount(comment.getBlogId());
            
            return comment;
        }
    }
    
    /**
     * Get comments for a blog (with user info)
     */
    public List<BlogComment> getCommentsByBlogId(Long blogId) throws SQLException {
        List<BlogComment> comments = new ArrayList<>();
        String sql = "SELECT bc.*, u.full_name as user_name, u.avatar_url as user_avatar, " +
                    "(SELECT COUNT(*) FROM blog_comments WHERE parent_comment_id = bc.comment_id AND is_deleted = FALSE) as reply_count " +
                    "FROM blog_comments bc " +
                    "JOIN users u ON bc.user_id = u.user_id " +
                    "WHERE bc.blog_id = ? AND bc.is_deleted = FALSE " +
                    "ORDER BY bc.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, blogId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    comments.add(extractCommentFromResultSet(rs));
                }
            }
        }
        
        return comments;
    }
    
    /**
     * Get parent comments only (top-level comments)
     */
    public List<BlogComment> getParentComments(Long blogId) throws SQLException {
        List<BlogComment> comments = new ArrayList<>();
        String sql = "SELECT bc.*, u.full_name as user_name, u.avatar_url as user_avatar, " +
                    "(SELECT COUNT(*) FROM blog_comments WHERE parent_comment_id = bc.comment_id AND is_deleted = FALSE) as reply_count " +
                    "FROM blog_comments bc " +
                    "JOIN users u ON bc.user_id = u.user_id " +
                    "WHERE bc.blog_id = ? AND bc.parent_comment_id IS NULL AND bc.is_deleted = FALSE " +
                    "ORDER BY bc.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, blogId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    comments.add(extractCommentFromResultSet(rs));
                }
            }
        }
        
        return comments;
    }
    
    /**
     * Get replies for a comment
     */
    public List<BlogComment> getReplies(Long parentCommentId) throws SQLException {
        List<BlogComment> replies = new ArrayList<>();
        String sql = "SELECT bc.*, u.full_name as user_name, u.avatar_url as user_avatar, " +
                    "0 as reply_count " +
                    "FROM blog_comments bc " +
                    "JOIN users u ON bc.user_id = u.user_id " +
                    "WHERE bc.parent_comment_id = ? AND bc.is_deleted = FALSE " +
                    "ORDER BY bc.created_at ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, parentCommentId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    replies.add(extractCommentFromResultSet(rs));
                }
            }
        }
        
        return replies;
    }
    
    /**
     * Update a comment
     */
    public boolean updateComment(Long commentId, String content) throws SQLException {
        String sql = "UPDATE blog_comments SET content = ?, updated_at = CURRENT_TIMESTAMP WHERE comment_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, content);
            ps.setLong(2, commentId);
            
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Delete a comment (soft delete)
     */
    public boolean deleteComment(Long commentId) throws SQLException {
        String sql = "UPDATE blog_comments SET is_deleted = TRUE, updated_at = CURRENT_TIMESTAMP WHERE comment_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, commentId);
            
            boolean result = ps.executeUpdate() > 0;
            
            if (result) {
                // Get blog_id to update count
                BlogComment comment = getCommentById(commentId);
                if (comment != null) {
                    updateBlogCommentCount(comment.getBlogId());
                }
            }
            
            return result;
        }
    }
    
    /**
     * Get comment by ID
     */
    public BlogComment getCommentById(Long commentId) throws SQLException {
        String sql = "SELECT bc.*, u.full_name as user_name, u.avatar_url as user_avatar, " +
                    "(SELECT COUNT(*) FROM blog_comments WHERE parent_comment_id = bc.comment_id AND is_deleted = FALSE) as reply_count " +
                    "FROM blog_comments bc " +
                    "JOIN users u ON bc.user_id = u.user_id " +
                    "WHERE bc.comment_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, commentId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractCommentFromResultSet(rs);
                }
            }
        }
        
        return null;
    }
    
    /**
     * Update blog comment count
     */
    private void updateBlogCommentCount(Long blogId) throws SQLException {
        String sql = "UPDATE blogs SET comment_count = " +
                    "(SELECT COUNT(*) FROM blog_comments WHERE blog_id = ? AND is_deleted = FALSE) " +
                    "WHERE blog_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, blogId);
            ps.setLong(2, blogId);
            ps.executeUpdate();
        }
    }
    
    /**
     * Extract comment from ResultSet
     */
    private BlogComment extractCommentFromResultSet(ResultSet rs) throws SQLException {
        BlogComment comment = new BlogComment();
        comment.setCommentId(rs.getLong("comment_id"));
        comment.setBlogId(rs.getLong("blog_id"));
        comment.setUserId(rs.getLong("user_id"));  // Changed from getInt to getLong
        comment.setUserName(rs.getString("user_name"));
        comment.setUserAvatar(rs.getString("user_avatar"));
        comment.setContent(rs.getString("content"));
        
        Long parentId = rs.getLong("parent_comment_id");
        comment.setParentCommentId(rs.wasNull() ? null : parentId);
        
        comment.setIsDeleted(rs.getBoolean("is_deleted"));
        comment.setCreatedAt(rs.getTimestamp("created_at"));
        comment.setUpdatedAt(rs.getTimestamp("updated_at"));
        comment.setReplyCount(rs.getInt("reply_count"));
        
        return comment;
    }
}

