<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đơn hàng - Giicungco Seller</title>
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
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            margin-bottom: 20px;
        }

        h1 {
            color: #333;
            font-size: 24px;
            margin-bottom: 10px;
        }

        .back-link {
            display: inline-block;
            margin-bottom: 25px;
            color: #ff6600;
            text-decoration: none;
            font-weight: 500;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        .order-header {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }

        .order-info h3, .customer-info h3 {
            color: #ff6600;
            margin-bottom: 15px;
            font-size: 18px;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            padding: 8px 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .info-row:last-child {
            border-bottom: none;
        }

        .info-label {
            color: #666;
            font-weight: 500;
        }

        .info-value {
            color: #333;
            font-weight: 600;
        }

        .status {
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 600;
            text-transform: capitalize;
            font-size: 14px;
            color: white;
            display: inline-block;
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
            font-size: 18px;
        }

        .items-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .items-table th, .items-table td {
            padding: 15px;
            border-bottom: 1px solid #f0f0f0;
            text-align: left;
        }

        .items-table th {
            background-color: #fff3e6;
            color: #ff6600;
            font-weight: 600;
        }

        .items-table tr:hover {
            background-color: #fff9f3;
        }

        .product-name {
            font-weight: 600;
            color: #333;
        }

        .product-price {
            color: #ff6600;
            font-weight: bold;
        }

        .subtotal {
            color: #ff6600;
            font-weight: bold;
            font-size: 16px;
        }

        .total-section {
            background: #fff3e6;
            padding: 20px;
            border-radius: 8px;
            margin-top: 20px;
            text-align: right;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            font-size: 16px;
        }

        .total-row.final {
            font-size: 20px;
            font-weight: bold;
            color: #ff6600;
            border-top: 2px solid #ff6600;
            padding-top: 10px;
            margin-top: 10px;
        }

        .actions {
            margin-top: 30px;
            text-align: center;
        }

        .btn {
            background: #ff6600;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            font-size: 15px;
            margin: 0 10px;
            text-decoration: none;
            display: inline-block;
        }

        .btn:hover {
            background: #e65c00;
        }

        .btn-secondary {
            background: #6c757d;
        }

        .btn-secondary:hover {
            background: #5a6268;
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
    <a href="${pageContext.request.contextPath}/seller/orders" class="back-link">← Quay lại danh sách đơn hàng</a>
    <h1>🧾 Chi tiết đơn hàng #${order.order_id}</h1>

    <div class="card">
        <div class="order-header">
            <div class="order-info">
                <h3>Thông tin đơn hàng</h3>
                <div class="info-row">
                    <span class="info-label">Mã đơn hàng:</span>
                    <span class="info-value">#${order.order_id}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Trạng thái:</span>
                    <span class="status ${order.status}">${order.status}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Ngày tạo:</span>
                    <span class="info-value"><fmt:formatDate value="${order.created_at}" pattern="dd/MM/yyyy HH:mm"/></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Cập nhật cuối:</span>
                    <span class="info-value"><fmt:formatDate value="${order.updated_at}" pattern="dd/MM/yyyy HH:mm"/></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Phương thức giao hàng:</span>
                    <span class="info-value">${order.shipping_method != null ? order.shipping_method : 'Giao hàng số'}</span>
                </div>
                <c:if test="${order.tracking_number != null}">
                <div class="info-row">
                    <span class="info-label">Mã vận đơn:</span>
                    <span class="info-value">${order.tracking_number}</span>
                </div>
                </c:if>
            </div>

            <div class="customer-info">
                <h3>Thông tin khách hàng</h3>
                <div class="info-row">
                    <span class="info-label">Tên:</span>
                    <span class="info-value">${order.buyer_id.full_name}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Email:</span>
                    <span class="info-value">${order.buyer_id.email}</span>
                </div>
                <c:if test="${order.shipping_address != null}">
                <div class="info-row">
                    <span class="info-label">Địa chỉ giao hàng:</span>
                    <span class="info-value">${order.shipping_address}</span>
                </div>
                </c:if>
            </div>
        </div>

        <!-- Danh sách sản phẩm -->
        <h3 style="color: #ff6600; margin-bottom: 15px;">Sản phẩm trong đơn hàng</h3>
        <table class="items-table">
            <thead>
            <tr>
                <th>Sản phẩm</th>
                <th>Số lượng</th>
                <th>Giá</th>
                <th>Giảm giá</th>
                <th>Thành tiền</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="item" items="${orderItems}">
                <tr>
                    <td>
                        <div class="product-name">${item.productId.name}</div>
                    </td>
                    <td>${item.quantity}</td>
                    <td class="product-price">
                        <fmt:formatNumber value="${item.priceAtPurchase}" type="number" groupingUsed="true"/> ₫
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${item.discountApplied != null && item.discountApplied > 0}">
                                <fmt:formatNumber value="${item.discountApplied}" type="number" groupingUsed="true"/> ₫
                            </c:when>
                            <c:otherwise>0 ₫</c:otherwise>
                        </c:choose>
                    </td>
                    <td class="subtotal">
                        <fmt:formatNumber value="${item.subtotal}" type="number" groupingUsed="true"/> ₫
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

        <!-- Tổng tiền -->
        <div class="total-section">
            <div class="total-row final">
                <span>Tổng cộng:</span>
                <span class="price">
                    <fmt:formatNumber value="${order.total_amount}" type="number" groupingUsed="true"/> ₫
                </span>
            </div>
        </div>

        <!-- Hành động -->
        <div class="actions">
            <c:if test="${order.status == 'pending'}">
                <a href="#" onclick="updateStatus(${order.order_id}, 'paid')" class="btn">Xác nhận thanh toán</a>
                <a href="#" onclick="updateStatus(${order.order_id}, 'cancelled')" class="btn btn-secondary">Hủy đơn</a>
            </c:if>
            <c:if test="${order.status == 'paid'}">
                <a href="#" onclick="updateStatus(${order.order_id}, 'shipped')" class="btn">Đánh dấu đã giao</a>
                <a href="#" onclick="updateStatus(${order.order_id}, 'cancelled')" class="btn btn-secondary">Hủy đơn</a>
            </c:if>
            <c:if test="${order.status == 'shipped'}">
                <a href="#" onclick="updateStatus(${order.order_id}, 'delivered')" class="btn">Hoàn thành</a>
            </c:if>
            <c:if test="${order.status == 'delivered'}">
                <a href="#" onclick="updateStatus(${order.order_id}, 'refunded')" class="btn btn-secondary">Hoàn tiền</a>
            </c:if>
        </div>
    </div>
</div>

<script>
    function updateStatus(orderId, newStatus) {
        if (confirm('Bạn chắc chắn muốn cập nhật trạng thái đơn hàng?')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/seller/orders/update-status';
            
            const orderIdInput = document.createElement('input');
            orderIdInput.type = 'hidden';
            orderIdInput.name = 'order_id';
            orderIdInput.value = orderId;
            
            const statusInput = document.createElement('input');
            statusInput.type = 'hidden';
            statusInput.name = 'status';
            statusInput.value = newStatus;
            
            form.appendChild(orderIdInput);
            form.appendChild(statusInput);
            document.body.appendChild(form);
            form.submit();
        }
    }
</script>

</body>
</html>

