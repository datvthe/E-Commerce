<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chỉnh sửa sản phẩm - Giicungco Seller</title>
    <style>
        body { font-family: 'Poppins', sans-serif; margin: 0; min-height: 100vh; background-color: #fff8f2; }
        /* Sidebar styles are now in component/seller-sidebar.jsp */
        .main { margin-left: 260px; padding: 40px; background-color: #fff8f2; min-height: 100vh; }
        .card { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.08); max-width: 750px; margin: 0 auto; }
        h1 { color: #ff6600; font-size: 24px; margin-bottom: 10px; }
        p.subtitle { color: #777; margin-bottom: 25px; }
        label { display: block; margin: 12px 0 5px; font-weight: 500; color: #444; }
        input, textarea, select { width: 100%; padding: 10px 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 14px; box-sizing: border-box; font-family: inherit; }
        textarea { resize: vertical; }
        input:focus, textarea:focus, select:focus { outline: none; border-color: #ff6600; box-shadow: 0 0 0 2px rgba(255,102,0,0.15); }
        .btn { background: #ff6600; color: white; padding: 12px 25px; border: none; border-radius: 8px; cursor: pointer; font-weight: 600; font-size: 15px; margin-top: 20px; transition: 0.2s; }
        .btn:hover { background: #e65c00; }
        .back-link { display: inline-block; margin-bottom: 25px; color: #ff6600; text-decoration: none; font-weight: 500; }
        .back-link:hover { text-decoration: underline; }
        .error { color: red; margin-top: 10px; font-weight: 500; }
        .image-preview { margin-top: 10px; display:flex; gap:12px; flex-wrap:wrap; }
        .image-preview img { max-width: 160px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .upload-box { border: 2px dashed #ff6600; padding: 20px; text-align: center; border-radius: 10px; background: #fff7f0; cursor: pointer; transition: 0.3s; }
        .upload-box:hover { background: #fff0e0; }
        
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
        <a href="${pageContext.request.contextPath}/seller/products" class="back-link">← Quay lại danh sách sản phẩm</a>
        <h1>✏️ Chỉnh sửa sản phẩm</h1>
        <p class="subtitle">Cập nhật thông tin sản phẩm của bạn.</p>

        <form action="${pageContext.request.contextPath}/seller/products/update" method="post" enctype="multipart/form-data">
            <input type="hidden" name="product_id" value="${product.product_id}">

            <label>Tên sản phẩm:</label>
            <input type="text" name="name" value="${product.name}" required>

            <label>Mô tả:</label>
            <textarea name="description" rows="3" required>${product.description}</textarea>

            <label>Giá (VNĐ):</label>
            <input type="number" name="price" step="1000" min="0" value="${product.price}" required>

            <label>Số lượng (tồn kho):</label>
            <input type="number" name="quantity" min="0" value="${product.quantity}">

            <label>Danh mục (ưu tiên sản phẩm số: Netflix, ChatGPT, thẻ cào...):</label>
            <select name="category_id" required>
                <c:forEach var="c" items="${categories}">
                    <option value="${c.category_id}" <c:if test='${product.category_id != null && product.category_id.category_id == c.category_id}'>selected</c:if>>${c.name}</option>
                </c:forEach>
            </select>

            <label>Trạng thái:</label>
            <select name="status" required>
                <option value="active" <c:if test='${product.status == "active"}'>selected</c:if>>Active</option>
                <option value="inactive" <c:if test='${product.status == "inactive"}'>selected</c:if>>Inactive</option>
                <option value="draft" <c:if test='${product.status == "draft"}'>selected</c:if>>Draft</option>
                <option value="pending" <c:if test='${product.status == "pending"}'>selected</c:if>>Pending</option>
            </select>

            <label>Ảnh sản phẩm (JPG/PNG/WEBP, ≤ 10MB) - tùy chọn:</label>
            <div class="upload-box" onclick="document.getElementById('image').click()">📸 Nhấn để chọn ảnh mới</div>
            <input type="file" id="image" name="image" accept="image/png,image/jpeg,image/webp" style="display:none;" onchange="previewImage(event)">

            <div class="image-preview" id="preview"></div>

            <button type="submit" class="btn">💾 Lưu thay đổi</button>
        </form>

        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>
    </div>
</div>

<script>
    function previewImage(event) {
        const preview = document.getElementById('preview');
        const file = event.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.innerHTML = `<img src="${e.target.result}" alt="Ảnh xem trước">`;
            };
            reader.readAsDataURL(file);
        }
    }
</script>

</body>
</html>



