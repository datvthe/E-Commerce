package dao;

import model.blog.Blog;
import model.blog.BlogNotification;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO cho Blog Notifications
 * - Tạo notification khi blog approved/rejected
 * - Lấy danh sách notification của user
 * - Mark as read
 */
public class BlogNotificationDAO {
    
    // ================================================
    // CREATE
    // ================================================
    
    /**
     * Tạo notification mới
     */
    public Long createNotification(BlogNotification notification) throws SQLException {
        String sql = "INSERT INTO blog_notifications " +
                    "(blog_id, user_id, type, title, message) " +
                    "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setLong(1, notification.getBlogId());
            ps.setInt(2, notification.getUserId());
            ps.setString(3, notification.getType());
            ps.setString(4, notification.getTitle());
            ps.setString(5, notification.getMessage());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getLong(1);
                    }
                }
            }
        }
        return null;
    }
    
    // ================================================
    // READ
    // ================================================
    
    /**
     * Lấy danh sách notification của user
     */
    public List<BlogNotification> getNotificationsByUserId(int userId, int limit) throws SQLException {
        String sql = "SELECT n.*, b.title AS blog_title, b.slug AS blog_slug " +
                    "FROM blog_notifications n " +
                    "LEFT JOIN blogs b ON n.blog_id = b.blog_id " +
                    "WHERE n.user_id = ? " +
                    "ORDER BY n.created_at DESC " +
                    "LIMIT ?";
        
        List<BlogNotification> notifications = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, limit);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    notifications.add(extractNotification(rs));
                }
            }
        }
        return notifications;
    }
    
    /**
     * Lấy số notification chưa đọc
     */
    public int countUnreadNotifications(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM blog_notifications " +
                    "WHERE user_id = ? AND is_read = FALSE";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    // ================================================
    // UPDATE
    // ================================================
    
    /**
     * Đánh dấu notification đã đọc
     */
    public boolean markAsRead(Long notificationId) throws SQLException {
        String sql = "UPDATE blog_notifications SET is_read = TRUE " +
                    "WHERE notification_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, notificationId);
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Đánh dấu tất cả notification đã đọc
     */
    public boolean markAllAsRead(int userId) throws SQLException {
        String sql = "UPDATE blog_notifications SET is_read = TRUE " +
                    "WHERE user_id = ? AND is_read = FALSE";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        }
    }
    
    // ================================================
    // DELETE
    // ================================================
    
    /**
     * Xóa notification
     */
    public boolean deleteNotification(Long notificationId) throws SQLException {
        String sql = "DELETE FROM blog_notifications WHERE notification_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, notificationId);
            return ps.executeUpdate() > 0;
        }
    }
    
    // ================================================
    // UTILITY
    // ================================================
    
    /**
     * Extract notification from ResultSet
     */
    private BlogNotification extractNotification(ResultSet rs) throws SQLException {
        BlogNotification notification = new BlogNotification();
        
        notification.setNotificationId(rs.getLong("notification_id"));
        notification.setBlogId(rs.getLong("blog_id"));
        notification.setUserId(rs.getInt("user_id"));
        notification.setType(rs.getString("type"));
        notification.setTitle(rs.getString("title"));
        notification.setMessage(rs.getString("message"));
        notification.setRead(rs.getBoolean("is_read"));
        notification.setCreatedAt(rs.getTimestamp("created_at"));
        
        // Blog info (if joined)
        try {
            Blog blog = new Blog();
            blog.setBlogId(rs.getLong("blog_id"));
            blog.setTitle(rs.getString("blog_title"));
            blog.setSlug(rs.getString("blog_slug"));
            notification.setBlog(blog);
        } catch (SQLException ignored) {
            // Columns might not exist
        }
        
        return notification;
    }
}

