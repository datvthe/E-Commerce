<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý sản phẩm - Giicungco Seller</title>

    <style>
        body {
            font-family: "Poppins", sans-serif;
            background-color: #fff8f2;
            margin: 0;
            padding: 0;
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 250px;
            background-color: #ff6600;
            color: white;
            display: flex;
            flex-direction: column;
            padding: 20px;
        }

        .sidebar h2 {
            font-size: 20px;
            margin-bottom: 25px;
            font-weight: 700;
            letter-spacing: 0.5px;
        }

        .sidebar a {
            color: white;
            text-decoration: none;
            padding: 10px 12px;
            border-radius: 8px;
            transition: background 0.2s;
            display: block;
            margin-bottom: 6px;
            font-weight: 500;
        }

        .sidebar a:hover, .sidebar a.active {
            background-color: rgba(255, 255, 255, 0.15);
        }

        /* Main content */
        .main {
            flex: 1;
            padding: 40px;
            background-color: #fff8f2;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }

        h1 {
            color: #333;
            font-size: 24px;
            margin-bottom: 10px;
        }

        .subtitle {
            color: #777;
            margin-bottom: 25px;
        }

        .add-btn {
            background: #ff6600;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            font-weight: 600;
            float: right;
        }

        .add-btn:hover {
            background: #e65c00;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        th, td {
            padding: 12px 14px;
            border-bottom: 1px solid #f0f0f0;
            text-align: left;
            font-size: 14px;
        }

        th {
            background-color: #fff3e6;
            color: #ff6600;
            font-weight: 600;
        }

        tr:hover {
            background-color: #fff9f3;
        }

        .status {
            padding: 5px 10px;
            border-radius: 6px;
            font-weight: 500;
            text-transform: capitalize;
            font-size: 13px;
            color: white;
        }

        .status.active { background: #28a745; }
        .status.inactive { background: #dc3545; }
        .status.pending { background: #ffc107; color: #333; }

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

        .actions button {
            border: none;
            background: none;
            cursor: pointer;
            margin: 0 5px;
            font-size: 16px;
        }

        .actions button.edit { color: #007bff; }
        .actions button.delete { color: #dc3545; }

        .header-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <h2>Giicungco Seller</h2>
    <a href="${pageContext.request.contextPath}/seller/dashboard">🏠 Trang chủ</a>
    <a href="${pageContext.request.contextPath}/seller/products" class="active">📦 Quản lý sản phẩm</a>
    <a href="${pageContext.request.contextPath}/seller/orders">🧾 Đơn hàng</a>
    <a href="${pageContext.request.contextPath}/seller/withdraw">💸 Lịch sử rút tiền</a>
    <a href="${pageContext.request.contextPath}/seller/profile">⚙️ Chỉnh sửa thông tin</a>
</div>

<!-- Main -->
<div class="main">
    <div class="header-bar">
        <h1>📦 Danh sách sản phẩm</h1>
        <a href="${pageContext.request.contextPath}/seller/products/add" class="add-btn">➕ Thêm sản phẩm mới</a>
    </div>
    <p class="subtitle">Xem và quản lý các sản phẩm bạn đã đăng bán.</p>

    <div class="card">
        <!-- Nếu không có sản phẩm -->
        <c:if test="${empty products}">
            <div class="no-data">⚠️ Chưa có sản phẩm nào. Hãy bắt đầu bằng cách nhấn “Thêm sản phẩm mới”.</div>
        </c:if>

        <!-- Nếu có sản phẩm -->
        <c:if test="${not empty products}">
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên sản phẩm</th>
                    <th>Mô tả</th>
                    <th>Giá</th>
                    <th>Danh mục</th>
                    <th>Trạng thái</th>
                    <th>Ngày tạo</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="p" items="${products}">
                    <tr>
                        <td>${p.product_id}</td>
                        <td>${p.name}</td>
                        <td>
                            <c:choose>
                                <c:when test="${fn:length(p.description) > 50}">
                                    ${fn:substring(p.description, 0, 50)}...
                                </c:when>
                                <c:otherwise>${p.description}</c:otherwise>
                            </c:choose>
                        </td>
                        <td class="price">
                            <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/> ₫
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${p.category_id != null}">
                                    ${p.category_id.name}
                                </c:when>
                                <c:otherwise>—</c:otherwise>
                            </c:choose>
                        </td>
                        <td><span class="status ${p.status}">${p.status}</span></td>
                        <td><fmt:formatDate value="${p.created_at}" pattern="dd/MM/yyyy"/></td>
                        <td class="actions">
                            <button class="edit" title="Chỉnh sửa">✏️</button>
                            <button class="delete" title="Xóa">🗑️</button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>
</div>

</body>
</html>
