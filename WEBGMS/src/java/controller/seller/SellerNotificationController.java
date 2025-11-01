package controller.seller;

import dao.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.notification.Notification;
import model.user.Users;

import java.io.IOException;
import java.util.List;

/**
 * Controller đơn giản cho Notifications
 * Copy logic từ SellerDashboardController - CHỈ check user login
 */
@WebServlet(name = "SellerNotificationController", urlPatterns = {"/seller/notifications"})
public class SellerNotificationController extends HttpServlet {

    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // COPY Y HỆT LOGIC TỪ SellerDashboardController
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            long userId = user.getUser_id();
            
            // Lấy notifications
            List<Notification> allNotifications = notificationDAO.getNotificationsByUserId(userId, 50);
            List<Notification> unreadNotifications = notificationDAO.getUnreadNotifications(userId);
            int unreadCount = notificationDAO.countUnreadNotifications(userId);
            
            // Set attributes
            request.setAttribute("allNotifications", allNotifications);
            request.setAttribute("unreadNotifications", unreadNotifications);
            request.setAttribute("unreadCount", unreadCount);
            request.setAttribute("user", user);
            
            // Forward to JSP
            request.getRequestDispatcher("/views/seller/seller-notifications.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "❌ Có lỗi khi tải thông báo: " + e.getMessage());
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // COPY Y HỆT LOGIC TỪ SellerDashboardController
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        long userId = user.getUser_id();
        String action = request.getParameter("action");
        
        try {
            if ("markAsRead".equals(action)) {
                handleMarkAsRead(request, response, userId);
            } else if ("markAllAsRead".equals(action)) {
                handleMarkAllAsRead(request, response, userId);
            } else if ("delete".equals(action)) {
                handleDelete(request, response, userId);
            } else if ("deleteAllRead".equals(action)) {
                handleDeleteAllRead(request, response, userId);
            } else {
                response.sendRedirect(request.getContextPath() + "/seller/notifications?error=invalid_action");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/seller/notifications?error=system_error");
        }
    }
    
    private void handleMarkAsRead(HttpServletRequest request, HttpServletResponse response, long userId)
            throws IOException {
        String notificationIdStr = request.getParameter("notificationId");
        if (notificationIdStr != null && !notificationIdStr.trim().isEmpty()) {
            long notificationId = Long.parseLong(notificationIdStr);
            notificationDAO.markAsRead(notificationId);
        }
        response.sendRedirect(request.getContextPath() + "/seller/notifications");
    }
    
    private void handleMarkAllAsRead(HttpServletRequest request, HttpServletResponse response, long userId)
            throws IOException {
        notificationDAO.markAllAsRead(userId);
        response.sendRedirect(request.getContextPath() + "/seller/notifications");
    }
    
    private void handleDelete(HttpServletRequest request, HttpServletResponse response, long userId)
            throws IOException {
        String notificationIdStr = request.getParameter("notificationId");
        if (notificationIdStr != null && !notificationIdStr.trim().isEmpty()) {
            long notificationId = Long.parseLong(notificationIdStr);
            notificationDAO.deleteNotification(notificationId, userId);
        }
        response.sendRedirect(request.getContextPath() + "/seller/notifications");
    }
    
    private void handleDeleteAllRead(HttpServletRequest request, HttpServletResponse response, long userId)
            throws IOException {
        notificationDAO.deleteAllReadNotifications(userId);
        response.sendRedirect(request.getContextPath() + "/seller/notifications");
    }
}




