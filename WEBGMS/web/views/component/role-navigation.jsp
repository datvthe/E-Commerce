<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!-- Role-based navigation component -->
<c:set var="rbac" value="${sessionScope.rbac}" />

<!-- Safeguard: if RBAC is missing, show guest nav and skip role checks -->
<c:if test="${empty rbac}">
    <div class="guest-nav">
        <a href="<%= request.getContextPath() %>/login" class="nav-item nav-link">
            <i class="fas fa-sign-in-alt me-1"></i>Đăng nhập
        </a>
        <a href="<%= request.getContextPath() %>/register" class="nav-item nav-link">
            <i class="fas fa-user-plus me-1"></i>Đăng ký
        </a>
    </div>
</c:if>

<c:if test="${not empty rbac}">
    <!-- Admin Navigation -->
    <c:if test="${rbac.isAdmin(request)}">
        <div class="admin-nav">
            <a href="<%= request.getContextPath() %>/admin/dashboard" class="nav-item nav-link">
                <i class="fas fa-tachometer-alt me-1"></i>Dashboard
            </a>
            <a href="<%= request.getContextPath() %>/admin/users" class="nav-item nav-link">
                <i class="fas fa-users me-1"></i>Quản lý người dùng
            </a>
            <a href="<%= request.getContextPath() %>/admin/products" class="nav-item nav-link">
                <i class="fas fa-box me-1"></i>Quản lý sản phẩm
            </a>
            <a href="<%= request.getContextPath() %>/admin/orders" class="nav-item nav-link">
                <i class="fas fa-clipboard-list me-1"></i>Quản lý đơn hàng
            </a>
            <a href="<%= request.getContextPath() %>/admin/reports" class="nav-item nav-link">
                <i class="fas fa-chart-bar me-1"></i>Báo cáo
            </a>
            <a href="<%= request.getContextPath() %>/admin/settings" class="nav-item nav-link">
                <i class="fas fa-cog me-1"></i>Cài đặt
            </a>
        </div>
    </c:if>

    <!-- Seller Navigation -->
    <c:if test="${rbac.isSeller(request)}">
        <div class="seller-nav">
            <a href="<%= request.getContextPath() %>/seller/dashboard" class="nav-item nav-link">
                <i class="fas fa-tachometer-alt me-1"></i>Dashboard
            </a>
            <a href="<%= request.getContextPath() %>/seller/products" class="nav-item nav-link">
                <i class="fas fa-box me-1"></i>Sản phẩm của tôi
            </a>
            <a href="<%= request.getContextPath() %>/seller/orders" class="nav-item nav-link">
                <i class="fas fa-clipboard-list me-1"></i>Đơn hàng
            </a>
            <a href="<%= request.getContextPath() %>/seller/analytics" class="nav-item nav-link">
                <i class="fas fa-chart-line me-1"></i>Thống kê
            </a>
        </div>
    </c:if>

    <!-- Moderator Navigation -->
    <c:if test="${rbac.isModerator(request)}">
        <div class="moderator-nav">
            <a href="<%= request.getContextPath() %>/moderator/dashboard" class="nav-item nav-link">
                <i class="fas fa-tachometer-alt me-1"></i>Dashboard
            </a>
            <a href="<%= request.getContextPath() %>/moderator/users" class="nav-item nav-link">
                <i class="fas fa-users me-1"></i>Quản lý người dùng
            </a>
            <a href="<%= request.getContextPath() %>/moderator/orders" class="nav-item nav-link">
                <i class="fas fa-clipboard-list me-1"></i>Quản lý đơn hàng
            </a>
            <a href="<%= request.getContextPath() %>/moderator/reports" class="nav-item nav-link">
                <i class="fas fa-chart-bar me-1"></i>Báo cáo
            </a>
        </div>
    </c:if>

    <!-- Customer Navigation -->
    <c:if test="${rbac.isCustomer(request)}">
        <div class="customer-nav">
            <a href="<%= request.getContextPath() %>/customer/profile" class="nav-item nav-link">
                <i class="fas fa-user me-1"></i>Hồ sơ
            </a>
            <a href="<%= request.getContextPath() %>/customer/orders" class="nav-item nav-link">
                <i class="fas fa-clipboard-list me-1"></i>Đơn hàng của tôi
            </a>
            <a href="<%= request.getContextPath() %>/customer/wishlist" class="nav-item nav-link">
                <i class="fas fa-heart me-1"></i>Danh sách yêu thích
            </a>
            <a href="<%= request.getContextPath() %>/customer/support" class="nav-item nav-link">
                <i class="fas fa-headset me-1"></i>Hỗ trợ
            </a>
        </div>
    </c:if>
</c:if>

