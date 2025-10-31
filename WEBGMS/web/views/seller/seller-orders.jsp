<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý đơn hàng - Giicungco Seller</title>
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body {
            font-family: "Poppins", sans-serif;
            background-color: #fff8f2;
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }

        /* Sidebar styles are now in component/seller-sidebar.jsp */

        /* Main content */
        .main {
            margin-left: 260px;
            padding: 40px;
            background-color: #fff8f2;
            min-height: 100vh;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            margin-bottom: 20px;
        }

        h1 {
            color: #333;
            font-size: 28px;
            margin-bottom: 10px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .subtitle {
            color: #777;
            margin-bottom: 25px;
            font-size: 15px;
        }

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 20px;
            border-radius: 12px;
            color: white;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-card.orange {
            background: linear-gradient(135deg, #ff6600 0%, #ff8c3a 100%);
        }

        .stat-card.green {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
        }

        .stat-card.blue {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .stat-icon {
            font-size: 32px;
            margin-bottom: 10px;
            opacity: 0.9;
        }

        .stat-card h3 {
            margin: 0 0 8px 0;
            font-size: 13px;
            opacity: 0.9;
            font-weight: 500;
        }

        .stat-card .value {
            font-size: 28px;
            font-weight: 700;
            margin: 0;
        }

        .filters {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-bottom: 20px;
            align-items: flex-end;
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
            flex: 1;
            min-width: 200px;
        }

        .filter-group label {
            font-size: 13px;
            color: #333;
            margin-bottom: 8px;
            font-weight: 600;
        }

        .filter-group label i {
            color: #ff6600;
            margin-right: 5px;
        }

        .filter-group select {
            padding: 10px 12px;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .filter-group select:hover {
            border-color: #ff8c3a;
        }

        .filter-group select:focus {
            outline: none;
            border-color: #ff6600;
            box-shadow: 0 0 0 3px rgba(255,102,0,0.1);
        }

        .btn {
            background: linear-gradient(135deg, #ff6600 0%, #ff8c3a 100%);
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(255,102,0,0.3);
        }

        .btn:hover {
            background: linear-gradient(135deg, #e65c00 0%, #ff7b00 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(255,102,0,0.4);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
            overflow: hidden;
            border-radius: 10px;
        }

        th, td {
            padding: 14px 16px;
            border-bottom: 1px solid #f0f0f0;
            text-align: left;
            font-size: 14px;
        }

        th {
            background: linear-gradient(135deg, #ff6600 0%, #ff7b00 100%);
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 12px;
            letter-spacing: 0.5px;
        }

        tbody tr {
            transition: all 0.3s ease;
        }

        tbody tr:hover {
            background-color: #fff9f3;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            transform: scale(1.01);
        }

        td:first-child {
            border-left: 3px solid transparent;
        }

        tbody tr:hover td:first-child {
            border-left-color: #ff6600;
        }

        .status {
            padding: 5px 10px;
            border-radius: 6px;
            font-weight: 500;
            text-transform: capitalize;
            font-size: 13px;
            color: white;
        }

        .status.pending { background: #ffc107; color: #333; }
        .status.paid { background: #28a745; }
        .status.shipped { background: #17a2b8; }
        .status.delivered { background: #6f42c1; }
        .status.cancelled { background: #dc3545; }
        .status.refunded { background: #6c757d; }

        .price {
            color: #ff6600;
            font-weight: bold;
        }

        .no-data {
            text-align: center;
            padding: 40px;
            color: #888;
            font-size: 15px;
        }

        .actions {
            display: flex;
            gap: 6px;
            align-items: center;
        }

        .btn-action {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 8px 12px;
            border: 1px solid #e6e6e6;
            border-radius: 6px;
            font-size: 13px;
            text-decoration: none;
            color: #fff;
            background: #6c757d;
            transition: all 0.2s ease;
            font-weight: 500;
        }

        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }

        .btn-view {
            background: linear-gradient(135deg, #198754 0%, #146c43 100%);
            border-color: #198754;
        }

        .btn-update {
            background: linear-gradient(135deg, #0d6efd 0%, #0a58ca 100%);
            border-color: #0d6efd;
        }

        .pagination {
            display: flex;
            gap: 8px;
            justify-content: center;
            margin-top: 20px;
        }

        .pagination a {
            padding: 8px 12px;
            border: 1px solid #eee;
            border-radius: 8px;
            text-decoration: none;
            color: #333;
        }

        .pagination a.current {
            background: #ff6600;
            color: #fff;
            border-color: #ff6600;
        }

        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .alert-success {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
        }

        .alert-error {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }
    </style>
</head>
<body>

<!-- Include Sidebar Component -->
<jsp:include page="../component/seller-sidebar.jsp">
    <jsp:param name="activePage" value="orders" />
</jsp:include>

<!-- Main -->
<div class="main">
    <h1><i class="bi bi-receipt"></i> Quản lý đơn hàng</h1>
    <p class="subtitle">Theo dõi và quản lý các đơn hàng của bạn trên nền tảng Giicungco</p>

    <!-- Thống kê -->
    <div class="stats-grid">
        <div class="stat-card orange">
            <div class="stat-icon"><i class="bi bi-cart-check"></i></div>
            <h3>Tổng đơn hàng</h3>
            <p class="value">${totalOrders}</p>
        </div>
        <div class="stat-card green">
            <div class="stat-icon"><i class="bi bi-cash-coin"></i></div>
            <h3>Doanh thu hôm nay</h3>
            <p class="value"><fmt:formatNumber value="${revenueToday}" type="number" groupingUsed="true"/> ₫</p>
        </div>
        <div class="stat-card blue">
            <div class="stat-icon"><i class="bi bi-graph-up-arrow"></i></div>
            <h3>Tổng doanh thu</h3>
            <p class="value"><fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true"/> ₫</p>
        </div>
    </div>

    <div class="card">
        <!-- Thông báo -->
        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>

        <!-- Bộ lọc -->
        <form method="get" action="${pageContext.request.contextPath}/seller/orders" class="filters">
            <div class="filter-group">
                <label><i class="bi bi-toggle-on"></i> Trạng thái</label>
                <select name="status">
                    <option value="">-- Tất cả --</option>
                    <option value="pending" <c:if test='${status == "pending"}'>selected</c:if>>Chờ thanh toán</option>
                    <option value="paid" <c:if test='${status == "paid"}'>selected</c:if>>Đã thanh toán</option>
                    <option value="shipped" <c:if test='${status == "shipped"}'>selected</c:if>>Đã giao</option>
                    <option value="delivered" <c:if test='${status == "delivered"}'>selected</c:if>>Hoàn thành</option>
                    <option value="cancelled" <c:if test='${status == "cancelled"}'>selected</c:if>>Đã hủy</option>
                    <option value="refunded" <c:if test='${status == "refunded"}'>selected</c:if>>Đã hoàn tiền</option>
                </select>
            </div>
            <button type="submit" class="btn">
                <i class="bi bi-funnel"></i> Lọc
            </button>
        </form>

        <!-- Nếu không có đơn hàng -->
        <c:if test="${empty orders}">
            <div class="no-data">⚠️ Chưa có đơn hàng nào.</div>
        </c:if>

        <!-- Nếu có đơn hàng -->
        <c:if test="${not empty orders}">
            <table>
                <thead>
                <tr>
                    <th>Mã đơn</th>
                    <th>Khách hàng</th>
                    <th>Tổng tiền</th>
                    <th>Trạng thái</th>
                    <th>Ngày tạo</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="order" items="${orders}">
                    <tr>
                        <td>#${order.order_id}</td>
                        <td>
                            <div>${order.buyer_id.full_name}</div>
                            <div style="font-size: 12px; color: #666;">${order.buyer_id.email}</div>
                        </td>
                        <td class="price">
                            <fmt:formatNumber value="${order.total_amount}" type="number" groupingUsed="true"/> ₫
                        </td>
                        <td>
                            <span class="status ${order.status}">${order.status}</span>
                        </td>
                        <td><fmt:formatDate value="${order.created_at}" pattern="dd/MM/yyyy HH:mm"/></td>
                        <td class="actions">
                            <a href="${pageContext.request.contextPath}/seller/orders/view?id=${order.order_id}" 
                               class="btn-action btn-view" title="Xem chi tiết">
                                <i class="bi bi-eye"></i> Xem
                            </a>
                            <c:if test="${order.status == 'pending' || order.status == 'paid'}">
                                <a href="#" onclick="showStatusModal(${order.order_id}, '${order.status}')" 
                                   class="btn-action btn-update" title="Cập nhật trạng thái">
                                    <i class="bi bi-pencil-square"></i> Cập nhật
                                </a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

            <!-- Phân trang -->
            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <a href="${pageContext.request.contextPath}/seller/orders?page=${i}&status=${status}"
                           class="${i == currentPage ? 'current' : ''}">${i}</a>
                    </c:forEach>
                </div>
            </c:if>
        </c:if>
    </div>
</div>

<!-- Modal cập nhật trạng thái -->
<div id="statusModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000;">
    <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); background: white; padding: 30px; border-radius: 12px; min-width: 400px;">
        <h3 style="margin-top: 0;">Cập nhật trạng thái đơn hàng</h3>
        <form method="post" action="${pageContext.request.contextPath}/seller/orders/update-status">
            <input type="hidden" name="order_id" id="modalOrderId">
            <div style="margin-bottom: 20px;">
                <label>Trạng thái mới:</label>
                <select name="status" id="modalStatus" style="width: 100%; padding: 10px; margin-top: 5px; border: 1px solid #ddd; border-radius: 8px;">
                    <option value="paid">Đã thanh toán</option>
                    <option value="shipped">Đã giao</option>
                    <option value="delivered">Hoàn thành</option>
                    <option value="cancelled">Hủy đơn</option>
                </select>
            </div>
            <div style="display: flex; gap: 10px; justify-content: flex-end;">
                <button type="button" onclick="hideStatusModal()" style="padding: 10px 20px; border: 1px solid #ddd; background: white; border-radius: 8px; cursor: pointer;">Hủy</button>
                <button type="submit" style="padding: 10px 20px; background: #ff6600; color: white; border: none; border-radius: 8px; cursor: pointer;">Cập nhật</button>
            </div>
        </form>
    </div>
</div>

<script>
    function showStatusModal(orderId, currentStatus) {
        document.getElementById('modalOrderId').value = orderId;
        document.getElementById('modalStatus').value = currentStatus === 'pending' ? 'paid' : 'shipped';
        document.getElementById('statusModal').style.display = 'block';
    }

    function hideStatusModal() {
        document.getElementById('statusModal').style.display = 'none';
    }

    // Đóng modal khi click outside
    document.getElementById('statusModal').onclick = function(e) {
        if (e.target === this) {
            hideStatusModal();
        }
    };
</script>

</body>
</html>

