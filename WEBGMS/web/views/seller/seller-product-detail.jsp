<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết sản phẩm - Giicungco Seller</title>
    <style>
        body { font-family: 'Poppins', sans-serif; margin: 0; min-height: 100vh; background-color: #fff8f2; }
        /* Sidebar styles are now in component/seller-sidebar.jsp */
        .main { margin-left: 260px; padding: 40px; background-color: #fff8f2; min-height: 100vh; }
        .card { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.08); max-width: 900px; margin: 0 auto; }
        h1 { color: #333; font-size: 24px; margin-bottom: 10px; }
        .grid { display: grid; grid-template-columns: 320px 1fr; gap: 24px; }
        .images { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
        .images img { width: 100%; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .label { color: #666; font-size: 13px; }
        .value { color: #222; font-weight: 600; }
        .row { margin: 8px 0; }
        .price { color: #ff6600; font-weight: 700; }
        .status { padding: 5px 10px; border-radius: 6px; font-weight: 500; text-transform: capitalize; font-size: 13px; color: white; }
        .status.active { background: #28a745; } .status.inactive { background: #dc3545; } .status.pending { background: #ffc107; color: #333; }
        
        .main {
            margin-left: 260px;
            padding: 40px;
            background-color: #fff8f2;
            min-height: 100vh;
        }
    </style>
</head>
<body>

<!-- Include Sidebar Component -->
<jsp:include page="../component/seller-sidebar.jsp">
    <jsp:param name="activePage" value="products" />
</jsp:include>

<div class="main">
    <div class="card">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
            <a href="${pageContext.request.contextPath}/seller/products" style="color:#ff6600;text-decoration:none;">
                <i class="bi bi-arrow-left"></i> Quay lại danh sách
            </a>
        </div>
        <h1>👁️ Chi tiết sản phẩm</h1>

        <div class="grid">
            <div>
                <div class="images">
                    <c:forEach var="img" items="${images}">
                        <img src="${img.url}" alt="${img.alt_text}">
                    </c:forEach>
                    <c:if test="${empty images}">
                        <div style="grid-column: 1 / -1; color:#888;">Chưa có ảnh cho sản phẩm này.</div>
                    </c:if>
                </div>
            </div>
            <div>
                <div class="row"><span class="label">Tên sản phẩm:</span> <span class="value">${product.name}</span></div>
                <div class="row"><span class="label">Mô tả:</span> <div>${product.description}</div></div>
                <div class="row"><span class="label">Giá:</span> <span class="price"><fmt:formatNumber value="${product.price}" type="number" groupingUsed="true"/> ₫</span></div>
                <div class="row"><span class="label">Danh mục:</span> <span class="value">${product.category_id != null ? product.category_id.name : '—'}</span></div>
                <div class="row"><span class="label">Trạng thái:</span> <span class="status ${product.status}">${product.status}</span></div>
                <div class="row"><span class="label">Ngày tạo:</span> <span class="value"><fmt:formatDate value="${product.created_at}" pattern="dd/MM/yyyy HH:mm"/></span></div>
            </div>
        </div>
    </div>
</div>

</body>
</html>




