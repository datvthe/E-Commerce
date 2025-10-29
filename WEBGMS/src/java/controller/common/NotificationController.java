package controller.common;

import service.NotificationService;
import model.Notifications;
import model.user.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Controller for handling notification page
 */
@WebServlet(name = "NotificationController", urlPatterns = {
    "/notifications", 
    "/notifications/mark-read",
    "/notifications/mark-all-read"
})
public class NotificationController extends HttpServlet {

    private final NotificationService notificationService;

    public NotificationController() {
        this.notificationService = new NotificationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        // If user not logged in, redirect to login
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = currentUser.getUser_id();
        
        // Get all notifications for this user
        List<Notifications> notifications = notificationService.getUserNotifications(userId);
        
        // Get unread count
        int unreadCount = notificationService.getUnreadCount(userId);
        
        // Set attributes
        request.setAttribute("notifications", notifications);
        request.setAttribute("unreadCount", unreadCount);
        
        // Forward to notifications page
        request.getRequestDispatcher("/views/common/notifications.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            if ("/notifications/mark-read".equals(path)) {
                // Mark single notification as read
                int notificationId = Integer.parseInt(request.getParameter("notificationId"));
                boolean success = notificationService.markAsRead(notificationId);
                
                if (success) {
                    request.setAttribute("message", "Đã đánh dấu là đã đọc");
                } else {
                    request.setAttribute("error", "Không thể đánh dấu đã đọc");
                }

            } else if ("/notifications/mark-all-read".equals(path)) {
                // Mark all notifications as read
                int userId = currentUser.getUser_id();
                boolean success = notificationService.markAllAsRead(userId);
                
                if (success) {
                    request.setAttribute("message", "Đã đánh dấu tất cả là đã đọc");
                } else {
                    request.setAttribute("error", "Không thể đánh dấu tất cả đã đọc");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }

        // Redirect back to notifications page
        response.sendRedirect(request.getContextPath() + "/notifications");
    }

    @Override
    public String getServletInfo() {
        return "Notification Controller - Displays user notifications";
    }
}

