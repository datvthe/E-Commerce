<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Sidebar Component cho Gicungco Seller -->
<div class="sidebar">
    <!-- Logo & Brand -->
    <div class="sidebar-brand">
        <div class="brand-icon">
            <i class="bi bi-building"></i>
        </div>
        <h4>Gicungco Seller</h4>
    </div>

    <!-- Navigation Menu -->
    <nav class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/seller/dashboard" 
           class="nav-item ${param.activePage == 'dashboard' ? 'active' : ''}">
            <i class="bi bi-house-door"></i>
            <span>Trang chủ</span>
        </a>

        <a href="${pageContext.request.contextPath}/seller/products" 
           class="nav-item ${param.activePage == 'products' ? 'active' : ''}">
            <i class="bi bi-box"></i>
            <span>Quản lý sản phẩm</span>
        </a>

        <a href="${pageContext.request.contextPath}/seller/orders" 
           class="nav-item ${param.activePage == 'orders' ? 'active' : ''}">
            <i class="bi bi-file-text"></i>
            <span>Đơn hàng</span>
        </a>

        <a href="${pageContext.request.contextPath}/seller/notifications" 
           class="nav-item ${param.activePage == 'notifications' ? 'active' : ''}">
            <i class="bi bi-bell"></i>
            <span>Thông báo</span>
            <c:if test="${not empty unreadCount && unreadCount > 0}">
                <span class="notification-badge">${unreadCount > 99 ? '99+' : unreadCount}</span>
            </c:if>
        </a>

        <a href="${pageContext.request.contextPath}/seller/profile" 
           class="nav-item ${param.activePage == 'profile' ? 'active' : ''}">
            <i class="bi bi-person-gear"></i>
            <span>Chỉnh sửa thông tin</span>
        </a>

        <a href="${pageContext.request.contextPath}/seller/close-shop" 
           class="nav-item ${param.activePage == 'close-shop' ? 'active' : ''}">
            <i class="bi bi-x-circle"></i>
            <span>Hủy shop</span>
        </a>

        <a href="${pageContext.request.contextPath}/profile" 
           class="nav-item ${param.activePage == 'user-profile' ? 'active' : ''}">
            <i class="bi bi-person-circle"></i>
            <span>Hồ sơ cá nhân</span>
        </a>
    </nav>

    <!-- User Info -->
    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
            <i class="bi bi-box-arrow-right"></i>
            <span>Đăng xuất</span>
        </a>
    </div>
</div>

<style>
    /* Sidebar Styles - Đồng bộ cho tất cả trang */
    .sidebar {
        width: 260px;
        height: 100vh;
        background: linear-gradient(135deg, #ff6600 0%, #ff7b00 100%);
        color: white;
        position: fixed;
        left: 0;
        top: 0;
        padding: 0;
        z-index: 1000;
        box-shadow: 2px 0 10px rgba(0,0,0,0.1);
    }

    .sidebar-brand {
        padding: 25px 20px;
        text-align: center;
        border-bottom: 1px solid rgba(255,255,255,0.1);
        margin-bottom: 20px;
    }

    .brand-icon {
        font-size: 32px;
        margin-bottom: 10px;
    }

    .sidebar-brand h4 {
        font-weight: 700;
        font-size: 18px;
        margin: 0;
        letter-spacing: 0.5px;
    }

    .sidebar-nav {
        padding: 0 15px;
        flex: 1;
    }

    .nav-item {
        display: flex;
        align-items: center;
        color: white;
        text-decoration: none;
        padding: 12px 15px;
        border-radius: 8px;
        margin-bottom: 6px;
        transition: all 0.3s ease;
        font-weight: 500;
        font-size: 14px;
    }

    .nav-item i {
        font-size: 18px;
        margin-right: 12px;
        width: 20px;
        text-align: center;
    }

    .nav-item:hover {
        background-color: rgba(255,255,255,0.1);
        transform: translateX(3px);
    }

    .nav-item.active {
        background-color: rgba(255,255,255,0.2);
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        font-weight: 600;
    }

    .nav-item {
        position: relative;
    }

    .notification-badge {
        position: absolute;
        top: 10px;
        right: 15px;
        background-color: #dc3545;
        color: white;
        font-size: 10px;
        font-weight: 700;
        padding: 2px 6px;
        border-radius: 10px;
        min-width: 18px;
        text-align: center;
    }

    .sidebar-footer {
        position: absolute;
        bottom: 0;
        left: 0;
        right: 0;
        padding: 15px;
        border-top: 1px solid rgba(255,255,255,0.1);
    }

    .logout-btn {
        display: flex;
        align-items: center;
        color: white;
        text-decoration: none;
        padding: 10px 12px;
        border-radius: 6px;
        transition: background 0.3s;
        font-size: 14px;
        font-weight: 500;
        width: 100%;
        justify-content: center;
    }

    .logout-btn:hover {
        background-color: rgba(255,255,255,0.1);
    }

    .logout-btn i {
        font-size: 16px;
        margin-right: 8px;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .sidebar {
            transform: translateX(-100%);
            transition: transform 0.3s ease;
        }
        
        .sidebar.open {
            transform: translateX(0);
        }
    }
</style>
