<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thông Báo - Seller</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: "Poppins", sans-serif;
            background-color: #fff8f2;
            min-height: 100vh;
        }

        .main {
            margin-left: 260px;
            padding: 40px;
            background-color: #fff8f2;
            min-height: 100vh;
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
        }

        h1 {
            color: #ff6600;
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .stats {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
        }

        .stat-item {
            flex: 1;
            text-align: center;
        }

        .stat-number {
            font-size: 32px;
            font-weight: bold;
            color: #ff6600;
        }

        .stat-label {
            color: #666;
            font-size: 14px;
        }

        .actions {
            margin-bottom: 20px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
            margin-right: 10px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #ff6600 0%, #ff7b00 100%);
            color: white;
            border: none;
            transition: all 0.3s;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 102, 0, 0.3);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .notification-item {
            padding: 15px;
            border-bottom: 1px solid #eee;
            display: flex;
            gap: 15px;
            align-items: start;
            transition: background 0.2s;
        }

        .notification-item:hover {
            background: #f8f9fa;
        }

        .notification-item.unread {
            background: #fff8f2;
            border-left: 4px solid #ff6600;
        }

        .notification-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #e3f2fd;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            color: #2196F3;
            flex-shrink: 0;
        }

        .notification-content {
            flex: 1;
        }

        .notification-title {
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }

        .notification-message {
            color: #666;
            font-size: 14px;
            margin-bottom: 5px;
        }

        .notification-time {
            color: #999;
            font-size: 12px;
        }

        .notification-actions {
            display: flex;
            gap: 5px;
        }

        .btn-sm {
            padding: 5px 10px;
            font-size: 12px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            background: #f0f0f0;
        }

        .btn-sm:hover {
            background: #e0e0e0;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }

        .empty-state i {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.3;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 20px;
            padding: 10px 15px;
            color: #ff6600;
            text-decoration: none;
            font-weight: 600;
            border: 2px solid #ff6600;
            border-radius: 8px;
            transition: all 0.3s;
            font-size: 14px;
        }

        .back-link:hover {
            background-color: #ff6600;
            color: white;
            text-decoration: none;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255, 102, 0, 0.3);
        }

        @media (max-width: 768px) {
            .main {
                margin-left: 0;
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <!-- Include Sidebar Component -->
    <jsp:include page="../component/seller-sidebar.jsp">
        <jsp:param name="activePage" value="notifications" />
    </jsp:include>

    <div class="main">
        <div class="container">
            <h1>
            <i class="bi bi-bell"></i>
            Thông Báo
        </h1>

        <!-- Stats -->
        <div class="stats">
            <div class="stat-item">
                <div class="stat-number">${fn:length(allNotifications)}</div>
                <div class="stat-label">Tổng thông báo</div>
            </div>
            <div class="stat-item">
                <div class="stat-number">${unreadCount}</div>
                <div class="stat-label">Chưa đọc</div>
            </div>
        </div>

        <!-- Actions -->
        <c:if test="${unreadCount > 0}">
            <div class="actions">
                <form method="post" style="display: inline;">
                    <input type="hidden" name="action" value="markAllAsRead">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-all"></i> Đánh dấu tất cả đã đọc
                    </button>
                </form>
            </div>
        </c:if>

        <!-- Notifications List -->
        <c:choose>
            <c:when test="${not empty allNotifications}">
                <c:forEach var="notification" items="${allNotifications}">
                    <div class="notification-item ${!notification.read ? 'unread' : ''}">
                        <div class="notification-icon">
                            <i class="bi ${notification.typeIcon}"></i>
                        </div>
                        <div class="notification-content">
                            <div class="notification-title">${notification.title}</div>
                            <div class="notification-message">${notification.message}</div>
                            <div class="notification-time">
                                <i class="bi bi-clock"></i> ${notification.timeAgo}
                            </div>
                        </div>
                        <div class="notification-actions">
                            <c:if test="${!notification.read}">
                                <form method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="markAsRead">
                                    <input type="hidden" name="notificationId" value="${notification.notificationId}">
                                    <button type="submit" class="btn-sm" title="Đánh dấu đã đọc">
                                        <i class="bi bi-check"></i>
                                    </button>
                                </form>
                            </c:if>
                            <form method="post" style="display: inline;" 
                                  onsubmit="return confirm('Xóa thông báo này?');">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="notificationId" value="${notification.notificationId}">
                                <button type="submit" class="btn-sm" title="Xóa">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="bi bi-bell-slash"></i>
                    <p>Chưa có thông báo nào</p>
                </div>
            </c:otherwise>
        </c:choose>
        </div>
    </div>
</body>
</html>



