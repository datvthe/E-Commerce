package service;

import dao.NotificationDAO;
import dao.UsersDAO;
import model.Notifications;
import model.user.Users;
import java.util.List;

/**
 * Service layer for Notification business logic
 */
public class NotificationService {

    private final NotificationDAO notificationDAO;
    private final UsersDAO usersDAO;

    public NotificationService() {
        this.notificationDAO = new NotificationDAO();
        this.usersDAO = new UsersDAO();
    }

    /**
     * Send notification to all users (broadcast)
     * @param title Notification title
     * @param message Notification message
     * @param type Notification type (order, promotion, wallet, system)
     * @return true if successful, false otherwise
     */
    public boolean sendBroadcastNotification(String title, String message, String type) {
        // Validate input
        if (title == null || title.trim().isEmpty()) {
            throw new IllegalArgumentException("Title cannot be empty");
        }
        if (message == null || message.trim().isEmpty()) {
            throw new IllegalArgumentException("Message cannot be empty");
        }
        if (!isValidNotificationType(type)) {
            throw new IllegalArgumentException("Invalid notification type: " + type);
        }

        return notificationDAO.createBroadcastNotification(title, message, type);
    }

    /**
     * Send notification to a specific user
     * @param userId Target user ID
     * @param title Notification title
     * @param message Notification message
     * @param type Notification type
     * @return true if successful, false otherwise
     */
    public boolean sendNotificationToUser(int userId, String title, String message, String type) {
        // Validate input
        if (title == null || title.trim().isEmpty()) {
            throw new IllegalArgumentException("Title cannot be empty");
        }
        if (message == null || message.trim().isEmpty()) {
            throw new IllegalArgumentException("Message cannot be empty");
        }
        if (!isValidNotificationType(type)) {
            throw new IllegalArgumentException("Invalid notification type: " + type);
        }

        // Check if user exists
        Users user = usersDAO.getUserById(userId);
        if (user == null) {
            throw new IllegalArgumentException("User not found with ID: " + userId);
        }

        return notificationDAO.createUserNotification(userId, title, message, type);
    }

    /**
     * Send notification to multiple users
     * @param userIds List of user IDs
     * @param title Notification title
     * @param message Notification message
     * @param type Notification type
     * @return Number of successful sends
     */
    public int sendNotificationToMultipleUsers(List<Integer> userIds, String title, String message, String type) {
        if (userIds == null || userIds.isEmpty()) {
            throw new IllegalArgumentException("User list cannot be empty");
        }

        int successCount = 0;
        for (Integer userId : userIds) {
            try {
                if (sendNotificationToUser(userId, title, message, type)) {
                    successCount++;
                }
            } catch (Exception e) {
                System.err.println("Failed to send notification to user " + userId + ": " + e.getMessage());
            }
        }

        return successCount;
    }

    /**
     * Get all notifications for a user
     * @param userId User ID
     * @return List of notifications
     */
    public List<Notifications> getUserNotifications(int userId) {
        return notificationDAO.getNotificationsByUserId(userId);
    }

    /**
     * Get unread notification count for a user
     * @param userId User ID
     * @return Count of unread notifications
     */
    public int getUnreadCount(int userId) {
        return notificationDAO.getUnreadCount(userId);
    }

    /**
     * Mark notification as read
     * @param notificationId Notification ID
     * @return true if successful
     */
    public boolean markAsRead(int notificationId) {
        return notificationDAO.markAsRead(notificationId);
    }

    /**
     * Mark all personal notifications as read for a user
     * @param userId User ID
     * @return true if successful
     */
    public boolean markAllAsRead(int userId) {
        return notificationDAO.markAllAsRead(userId);
    }

    /**
     * Delete a notification
     * @param notificationId Notification ID
     * @return true if successful
     */
    public boolean deleteNotification(int notificationId) {
        return notificationDAO.deleteNotification(notificationId);
    }

    /**
     * Get all notifications (for admin)
     * @param limit Maximum number of records
     * @return List of notifications
     */
    public List<Notifications> getAllNotifications(int limit) {
        return notificationDAO.getAllNotifications(limit);
    }

    /**
     * Get notification by ID
     * @param notificationId Notification ID
     * @return Notification object or null
     */
    public Notifications getNotificationById(int notificationId) {
        return notificationDAO.getNotificationById(notificationId);
    }

    /**
     * Validate notification type
     * @param type The type to validate
     * @return true if valid
     */
    private boolean isValidNotificationType(String type) {
        if (type == null) return false;
        
        String normalizedType = type.toLowerCase().trim();
        return normalizedType.equals("order") 
            || normalizedType.equals("promotion") 
            || normalizedType.equals("wallet") 
            || normalizedType.equals("system");
    }

    /**
     * Format notification message with dynamic data
     * @param template Message template with placeholders
     * @param data Data to replace placeholders
     * @return Formatted message
     */
    public String formatMessage(String template, Object... data) {
        return String.format(template, data);
    }

    /**
     * Check if notification is broadcast (sent to all users)
     * @param notification Notification object
     * @return true if broadcast
     */
    public boolean isBroadcast(Notifications notification) {
        return notification.getUserId() == null;
    }
}

