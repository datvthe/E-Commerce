package dao;

import model.Notifications;
import model.user.Users;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for Notification management
 */
public class NotificationDAO {

    public NotificationDAO() {
    }

    /**
     * Create a new notification
     * @param notification The notification to create
     * @return true if successful, false otherwise
     */
    public boolean createNotification(Notifications notification) {
        String sql = "INSERT INTO notifications (user_id, title, message, type, status, created_at) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            // If user_id is null, it means broadcast to all users
            if (notification.getUserId() == null) {
                ps.setNull(1, Types.BIGINT);
            } else {
                ps.setLong(1, notification.getUserId().getUser_id());
            }
            
            ps.setString(2, notification.getTitle());
            ps.setString(3, notification.getMessage());
            ps.setString(4, notification.getType());
            ps.setString(5, notification.getStatus());
            ps.setTimestamp(6, Timestamp.valueOf(notification.getCreatedAt()));
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Create broadcast notification (send to all users)
     * @param title Notification title
     * @param message Notification message
     * @param type Notification type
     * @return true if successful, false otherwise
     */
    public boolean createBroadcastNotification(String title, String message, String type) {
        Notifications notification = new Notifications();
        notification.setUserId(null);  // NULL means broadcast
        notification.setTitle(title);
        notification.setMessage(message);
        notification.setType(type);
        notification.setStatus("unread");
        notification.setCreatedAt(LocalDateTime.now());
        
        return createNotification(notification);
    }

    /**
     * Create notification for specific user
     * @param userId Target user ID
     * @param title Notification title
     * @param message Notification message
     * @param type Notification type
     * @return true if successful, false otherwise
     */
    public boolean createUserNotification(int userId, String title, String message, String type) {
        Users user = new Users();
        user.setUser_id(userId);
        
        Notifications notification = new Notifications();
        notification.setUserId(user);
        notification.setTitle(title);
        notification.setMessage(message);
        notification.setType(type);
        notification.setStatus("unread");
        notification.setCreatedAt(LocalDateTime.now());
        
        return createNotification(notification);
    }

    /**
     * Get all notifications for a specific user (personal + broadcast)
     * @param userId The user ID
     * @return List of notifications
     */
    public List<Notifications> getNotificationsByUserId(int userId) {
        List<Notifications> notifications = new ArrayList<>();
        String sql = "SELECT n.notification_id, n.user_id, n.title, n.message, n.type, n.status, n.created_at "
                   + "FROM notifications n "
                   + "WHERE n.user_id = ? OR n.user_id IS NULL "
                   + "ORDER BY n.created_at DESC "
                   + "LIMIT 50";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                notifications.add(mapResultSetToNotification(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return notifications;
    }

    /**
     * Get unread notifications count for a user
     * @param userId The user ID
     * @return Count of unread notifications
     */
    public int getUnreadCount(int userId) {
        String sql = "SELECT COUNT(*) as count FROM notifications "
                   + "WHERE (user_id = ? OR user_id IS NULL) AND status = 'unread'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }

    /**
     * Mark a notification as read
     * @param notificationId The notification ID
     * @return true if successful, false otherwise
     */
    public boolean markAsRead(int notificationId) {
        String sql = "UPDATE notifications SET status = 'read' WHERE notification_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, notificationId);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Mark all notifications as read for a user (only personal notifications)
     * Note: Cannot mark broadcast notifications as read (they are shared)
     * @param userId The user ID
     * @return true if successful, false otherwise
     */
    public boolean markAllAsRead(int userId) {
        String sql = "UPDATE notifications SET status = 'read' "
                   + "WHERE user_id = ? AND status = 'unread'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            return ps.executeUpdate() >= 0;  // >= 0 because there might be 0 unread notifications
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete a notification
     * @param notificationId The notification ID
     * @return true if successful, false otherwise
     */
    public boolean deleteNotification(int notificationId) {
        String sql = "DELETE FROM notifications WHERE notification_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, notificationId);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get all notifications (for admin)
     * @param limit Maximum number of records to return
     * @return List of all notifications
     */
    public List<Notifications> getAllNotifications(int limit) {
        List<Notifications> notifications = new ArrayList<>();
        String sql = "SELECT n.notification_id, n.user_id, n.title, n.message, n.type, n.status, n.created_at "
                   + "FROM notifications n "
                   + "ORDER BY n.created_at DESC "
                   + "LIMIT ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                notifications.add(mapResultSetToNotification(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return notifications;
    }

    /**
     * Get notification by ID
     * @param notificationId The notification ID
     * @return Notification object or null if not found
     */
    public Notifications getNotificationById(int notificationId) {
        String sql = "SELECT n.notification_id, n.user_id, n.title, n.message, n.type, n.status, n.created_at "
                   + "FROM notifications n "
                   + "WHERE n.notification_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, notificationId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToNotification(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }

    /**
     * Helper method to map ResultSet to Notification object
     */
    private Notifications mapResultSetToNotification(ResultSet rs) throws SQLException {
        Notifications notification = new Notifications();
        notification.setNotificationId(rs.getInt("notification_id"));
        
        // Handle user_id (might be NULL for broadcast)
        int userId = rs.getInt("user_id");
        if (!rs.wasNull()) {
            Users user = new Users();
            user.setUser_id(userId);
            notification.setUserId(user);
        } else {
            notification.setUserId(null);  // Broadcast notification
        }
        
        notification.setTitle(rs.getString("title"));
        notification.setMessage(rs.getString("message"));
        notification.setType(rs.getString("type"));
        notification.setStatus(rs.getString("status"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            notification.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        return notification;
    }
}

