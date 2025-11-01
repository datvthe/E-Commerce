<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý sản phẩm - Giicungco Seller</title>
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
        }

        .subtitle {
            color: #777;
            margin-bottom: 25px;
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

        .stat-card.red {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }

        .stat-icon {
            font-size: 32px;
            margin-bottom: 10px;
            opacity: 0.9;
        }

        .stat-value {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .stat-label {
            font-size: 13px;
            opacity: 0.9;
            font-weight: 500;
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

        .actions {
            display: flex;
            gap: 6px;
            align-items: center;
        }

        .actions button {
            border: none;
            background: none;
            cursor: pointer;
            font-size: 16px;
            padding: 0;
        }

        .actions button.edit { color: #007bff; }
        .actions button.delete { color: #dc3545; }

        /* Explicit action buttons */
        .actions .btn-action {
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
        .actions .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        .actions .btn-edit {
            background: linear-gradient(135deg, #0d6efd 0%, #0a58ca 100%);
            border-color: #0d6efd;
        }
        .actions .btn-view {
            background: linear-gradient(135deg, #198754 0%, #146c43 100%);
            border-color: #198754;
        }
        .actions .btn-delete {
            background: linear-gradient(135deg, #dc3545 0%, #bb2d3b 100%);
            border-color: #dc3545;
        }

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
        <h1><i class="bi bi-box-seam"></i> Quản lý sản phẩm</h1>
        <a href="${pageContext.request.contextPath}/seller/products/add" class="add-btn">
            <i class="bi bi-plus-circle"></i> Thêm sản phẩm mới
        </a>
    </div>
    <p class="subtitle">Xem và quản lý các sản phẩm bạn đã đăng bán trên nền tảng Giicungco</p>

    <!-- Stats Cards -->
    <div class="stats-grid">
        <div class="stat-card orange">
            <div class="stat-icon"><i class="bi bi-boxes"></i></div>
            <div class="stat-value">${totalProducts}</div>
            <div class="stat-label">Tổng sản phẩm</div>
        </div>
        <div class="stat-card green">
            <div class="stat-icon"><i class="bi bi-check-circle"></i></div>
            <div class="stat-value">
                <c:set var="activeCount" value="0"/>
                <c:forEach var="p" items="${products}">
                    <c:if test="${p.status == 'active'}">
                        <c:set var="activeCount" value="${activeCount + 1}"/>
                    </c:if>
                </c:forEach>
                ${activeCount}
            </div>
            <div class="stat-label">Đang hoạt động</div>
        </div>
        <div class="stat-card blue">
            <div class="stat-icon"><i class="bi bi-eye"></i></div>
            <div class="stat-value">
                <c:set var="inactiveCount" value="0"/>
                <c:forEach var="p" items="${products}">
                    <c:if test="${p.status == 'inactive'}">
                        <c:set var="inactiveCount" value="${inactiveCount + 1}"/>
                    </c:if>
                </c:forEach>
                ${inactiveCount}
            </div>
            <div class="stat-label">Tạm dừng</div>
        </div>
        <div class="stat-card red">
            <div class="stat-icon"><i class="bi bi-file-earmark-text"></i></div>
            <div class="stat-value">
                <c:set var="draftCount" value="0"/>
                <c:forEach var="p" items="${products}">
                    <c:if test="${p.status == 'draft'}">
                        <c:set var="draftCount" value="${draftCount + 1}"/>
                    </c:if>
                </c:forEach>
                ${draftCount}
            </div>
            <div class="stat-label">Nháp</div>
        </div>
    </div>

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
        <c:if test="${not empty param.error}">
            <div style="background:#ffefef;border:1px solid #f1c0c0;color:#b71c1c;padding:12px 14px;border-radius:8px;margin-bottom:15px;">
                <i class="bi bi-exclamation-triangle"></i>
                <c:choose>
                    <c:when test="${param.error == 'missing_product_id'}">❌ Thiếu ID sản phẩm. Vui lòng thử lại.</c:when>
                    <c:when test="${param.error == 'invalid_product_id'}">❌ ID sản phẩm không hợp lệ.</c:when>
                    <c:when test="${param.error == 'server_error'}">❌ Có lỗi xảy ra từ server.</c:when>
                    <c:otherwise>❌ Lỗi: ${param.error}</c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <!-- Bộ lọc & tìm kiếm -->
        <form method="get" action="${pageContext.request.contextPath}/seller/products" 
              style="display:flex;gap:10px;flex-wrap:wrap;margin-bottom:20px;align-items:flex-end;background:#f8f9fa;padding:20px;border-radius:10px;">
            <div style="flex:1;min-width:220px;">
                <label style="display:block;margin-bottom:8px;font-weight:600;color:#333;font-size:13px;">
                    <i class="bi bi-search"></i> Từ khóa
                </label>
                <input type="text" name="keyword" value="${keyword}" 
                       placeholder="Tìm kiếm sản phẩm..."
                       style="width:100%;padding:10px 12px;border:1px solid #ddd;border-radius:8px;font-size:14px;"/>
            </div>
            <div style="width:180px;">
                <label style="display:block;margin-bottom:8px;font-weight:600;color:#333;font-size:13px;">
                    <i class="bi bi-toggle-on"></i> Trạng thái
                </label>
                <select name="status" style="width:100%;padding:10px 12px;border:1px solid #ddd;border-radius:8px;font-size:14px;">
                    <option value="">-- Tất cả --</option>
                    <option value="active" <c:if test='${status == "active"}'>selected</c:if>>Đang bán</option>
                    <option value="inactive" <c:if test='${status == "inactive"}'>selected</c:if>>Tạm dừng</option>
                    <option value="draft" <c:if test='${status == "draft"}'>selected</c:if>>Nháp</option>
                    <option value="pending" <c:if test='${status == "pending"}'>selected</c:if>>Chờ duyệt</option>
                </select>
            </div>
            <div style="width:220px;">
                <label style="display:block;margin-bottom:8px;font-weight:600;color:#333;font-size:13px;">
                    <i class="bi bi-tag"></i> Danh mục
                </label>
                <select name="category_id" style="width:100%;padding:10px 12px;border:1px solid #ddd;border-radius:8px;font-size:14px;">
                    <option value="0">-- Tất cả --</option>
                    <c:forEach var="c" items="${categories}">
                        <option value="${c.category_id}" <c:if test='${categoryId == c.category_id}'>selected</c:if>>${c.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div>
                <button type="submit" class="add-btn" style="float:none;display:flex;align-items:center;gap:6px;">
                    <i class="bi bi-funnel"></i> Lọc
                </button>
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
                                <a href="${pageContext.request.contextPath}/seller/products/view?id=${p.product_id}" 
                                   class="btn-action btn-view" title="Xem chi tiết">
                                    <i class="bi bi-eye"></i> Xem
                                </a>
                                <a href="${pageContext.request.contextPath}/seller/products/edit?id=${p.product_id}" 
                                   class="btn-action btn-edit" title="Chỉnh sửa">
                                    <i class="bi bi-pencil"></i> Sửa
                                </a>
                                <form action="${pageContext.request.contextPath}/seller/products/delete" 
                                      method="post" style="display:inline;margin:0;" 
                                      onsubmit="return confirm('Bạn chắc chắn muốn xóa sản phẩm này?');">
                                    <input type="hidden" name="id" value="${p.product_id}">
                                    <button type="submit" class="btn-action btn-delete" title="Xóa">
                                        <i class="bi bi-trash"></i> Xóa
                                    </button>
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
