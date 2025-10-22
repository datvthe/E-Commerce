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

        /* Explicit action buttons */
        .actions .btn-action {
            display: inline-block;
            padding: 6px 10px;
            border: 1px solid #e6e6e6;
            border-radius: 8px;
            font-size: 13px;
            text-decoration: none;
            color: #333;
            background: #fff;
            transition: background .15s, border-color .15s;
        }
        .actions .btn-action:hover { background: #fafafa; border-color: #dcdcdc; }
        .actions .btn-edit { color: #0d6efd; }
        .actions .btn-view { color: #198754; }
        .actions .btn-delete { color: #dc3545; }

        .header-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>

<!-- Include Sidebar Component -->
<jsp:include page="../component/seller-sidebar.jsp">
    <jsp:param name="activePage" value="products" />
</jsp:include>

<!-- Main -->
<div class="main">
    <div class="header-bar">
        <h1>📦 Danh sách sản phẩm</h1>
        <a href="${pageContext.request.contextPath}/seller/products/add" class="add-btn">➕ Thêm sản phẩm mới</a>
    </div>
    <p class="subtitle">Xem và quản lý các sản phẩm bạn đã đăng bán.</p>

    <div class="card">
        <!-- Thanh thông báo -->
        <c:if test="${not empty success}">
            <div style="background:#eaffea;border:1px solid #b7e1b7;color:#207520;padding:12px 14px;border-radius:8px;margin-bottom:15px;">
                ${success}
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div style="background:#ffefef;border:1px solid #f1c0c0;color:#b71c1c;padding:12px 14px;border-radius:8px;margin-bottom:15px;">
                ${error}
            </div>
        </c:if>

        <!-- Bộ lọc & tìm kiếm -->
        <form method="get" action="${pageContext.request.contextPath}/seller/products" style="display:flex;gap:10px;flex-wrap:wrap;margin-bottom:10px;align-items:flex-end;">
            <div style="flex:1;min-width:220px;">
                <label>Từ khóa</label>
                <input type="text" name="keyword" value="${keyword}" placeholder="Tên hoặc mô tả..."/>
            </div>
            <div style="width:180px;">
                <label>Trạng thái</label>
                <select name="status">
                    <option value="">-- Tất cả --</option>
                    <option value="active" <c:if test='${status == "active"}'>selected</c:if>>Active</option>
                    <option value="inactive" <c:if test='${status == "inactive"}'>selected</c:if>>Inactive</option>
                    <option value="draft" <c:if test='${status == "draft"}'>selected</c:if>>Draft</option>
                    <option value="pending" <c:if test='${status == "pending"}'>selected</c:if>>Pending</option>
                </select>
            </div>
            <div style="width:220px;">
                <label>Danh mục</label>
                <select name="category_id">
                    <option value="0">-- Tất cả --</option>
                    <c:forEach var="c" items="${categories}">
                        <option value="${c.category_id}" <c:if test='${categoryId == c.category_id}'>selected</c:if>>${c.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div>
                <button type="submit" class="add-btn" style="float:none;">🔎 Lọc</button>
            </div>
        </form>

        <!-- Nếu không có sản phẩm -->
        <c:if test="${empty products}">
            <div class="no-data">⚠️ Chưa có sản phẩm nào. Hãy bắt đầu bằng cách nhấn “Thêm sản phẩm mới”.</div>
        </c:if>

        <!-- Nếu có sản phẩm -->
        <c:if test="${not empty products}">
            <form method="post" action="${pageContext.request.contextPath}/seller/products/bulk-action">
                <div style="display:flex;gap:8px;align-items:center;margin:6px 0 10px 0;">
                    <select name="action" required style="padding:8px 10px;border:1px solid #ddd;border-radius:8px;">
                        <option value="">-- Thao tác hàng loạt --</option>
                        <option value="activate">Kích hoạt</option>
                        <option value="deactivate">Vô hiệu hóa</option>
                        <option value="draft">Chuyển Draft</option>
                        <option value="delete">Xóa</option>
                    </select>
                    <button type="submit" class="add-btn" style="float:none;">Thực hiện</button>
                </div>
                <table>
                    <thead>
                    <tr>
                        <th><input type="checkbox" onclick="toggleAll(this)"></th>
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
                            <td><input type="checkbox" name="product_ids" value="${p.product_id}"></td>
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
                            <td>
                                <span class="status ${p.status}">${p.status}</span>
                                <div style="margin-top:6px;display:flex;gap:6px;">
                                    <form method="post" action="${pageContext.request.contextPath}/seller/products/change-status" style="display:inline;">
                                        <input type="hidden" name="id" value="${p.product_id}">
                                        <input type="hidden" name="status" value="active">
                                        <button type="submit" style="font-size:12px;border:none;background:none;color:#007bff;cursor:pointer;">Active</button>
                                    </form>
                                    <form method="post" action="${pageContext.request.contextPath}/seller/products/change-status" style="display:inline;">
                                        <input type="hidden" name="id" value="${p.product_id}">
                                        <input type="hidden" name="status" value="inactive">
                                        <button type="submit" style="font-size:12px;border:none;background:none;color:#007bff;cursor:pointer;">Inactive</button>
                                    </form>
                                    <form method="post" action="${pageContext.request.contextPath}/seller/products/change-status" style="display:inline;">
                                        <input type="hidden" name="id" value="${p.product_id}">
                                        <input type="hidden" name="status" value="draft">
                                        <button type="submit" style="font-size:12px;border:none;background:none;color:#007bff;cursor:pointer;">Draft</button>
                                    </form>
                                </div>
                            </td>
                            <td><fmt:formatDate value="${p.created_at}" pattern="dd/MM/yyyy"/></td>
                            <td class="actions">
                                <a href="${pageContext.request.contextPath}/seller/products/view?id=${p.product_id}" class="btn-action btn-view" title="Xem">Xem</a>
                                <a href="${pageContext.request.contextPath}/seller/products/edit?id=${p.product_id}" class="btn-action btn-edit" title="Chỉnh sửa">Sửa</a>
                                <form action="${pageContext.request.contextPath}/seller/products/delete" method="post" style="display:inline;" onsubmit="return confirm('Bạn chắc chắn muốn xóa?');">
                                    <input type="hidden" name="id" value="${p.product_id}">
                                    <button type="submit" class="btn-action btn-delete" title="Xóa">Xóa</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </form>

            <!-- Phân trang -->
            <c:if test="${totalPages > 1}">
                <div style="display:flex;gap:8px;justify-content:flex-end;margin-top:12px;">
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <a href="${pageContext.request.contextPath}/seller/products?page=${i}&keyword=${fn:escapeXml(keyword)}&status=${status}&category_id=${categoryId}"
                           style="padding:8px 12px;border:1px solid #eee;border-radius:8px;text-decoration:none;${i == currentPage ? 'background:#ff6600;color:#fff;border-color:#ff6600;' : ''}">
                            ${i}
                        </a>
                    </c:forEach>
                </div>
            </c:if>
        </c:if>
    </div>
</div>

<script>
    function toggleAll(source) {
        const checkboxes = document.querySelectorAll('input[name="product_ids"]');
        checkboxes.forEach(cb => cb.checked = source.checked);
    }
}</script>

</body>
</html>
