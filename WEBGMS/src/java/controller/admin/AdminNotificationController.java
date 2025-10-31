package controller.admin;

import service.NotificationService;
import dao.UsersDAO;
import model.user.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Controller for Admin to manage notifications
 */
@WebServlet(name = "AdminNotificationController", urlPatterns = {"/admin/notifications", "/admin/notifications/send"})
public class AdminNotificationController extends HttpServlet {

    private final NotificationService notificationService;
    private final UsersDAO usersDAO;

    public AdminNotificationController() {
        this.notificationService = new NotificationService();
        this.usersDAO = new UsersDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is admin
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get all users for dropdown selection (get first 1000 users)
        List<Users> allUsers = usersDAO.getAllUsers(1, 1000);
        request.setAttribute("allUsers", allUsers);

        // Get recent notifications (for display)
        request.setAttribute("recentNotifications", notificationService.getAllNotifications(20));

        // Forward to admin notifications page
        request.getRequestDispatcher("/views/admin/admin-notifications.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is admin
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Get form parameters
            String title = request.getParameter("title");
            String message = request.getParameter("message");
            String type = request.getParameter("type");
            String recipientType = request.getParameter("recipientType"); // "all", "single", "multiple"
            
            boolean success = false;
            String resultMessage = "";

            if ("all".equals(recipientType)) {
                // Send to all users (broadcast)
                success = notificationService.sendBroadcastNotification(title, message, type);
                resultMessage = success 
                    ? "Đã gửi thông báo đến tất cả người dùng!" 
                    : "Gửi thông báo thất bại!";

            } else if ("single".equals(recipientType)) {
                // Send to single user
                String userIdStr = request.getParameter("userId");
                if (userIdStr != null && !userIdStr.isEmpty()) {
                    int userId = Integer.parseInt(userIdStr);
                    success = notificationService.sendNotificationToUser(userId, title, message, type);
                    resultMessage = success 
                        ? "Đã gửi thông báo đến người dùng #" + userId 
                        : "Gửi thông báo thất bại!";
                }

            } else if ("multiple".equals(recipientType)) {
                // Send to multiple users
                String[] userIdsArray = request.getParameterValues("userIds[]");
                if (userIdsArray != null && userIdsArray.length > 0) {
                    List<Integer> userIds = new ArrayList<>();
                    for (String userIdStr : userIdsArray) {
                        try {
                            userIds.add(Integer.parseInt(userIdStr));
                        } catch (NumberFormatException e) {
                            // Skip invalid IDs
                        }
                    }
                    
                    int successCount = notificationService.sendNotificationToMultipleUsers(userIds, title, message, type);
                    success = successCount > 0;
                    resultMessage = "Đã gửi thông báo đến " + successCount + "/" + userIds.size() + " người dùng";
                }
            }

            // Set success/error message
            if (success) {
                request.setAttribute("message", resultMessage);
            } else {
                request.setAttribute("error", resultMessage);
            }

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Lỗi: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }

        // Reload page with message
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Admin Notification Controller - Manage and send notifications";
    }
}

