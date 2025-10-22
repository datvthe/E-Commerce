<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm sản phẩm mới - Giicungco Seller</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            display: flex;
            min-height: 100vh;
            background-color: #fff8f2;
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
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            max-width: 750px;
            margin: 0 auto;
        }

        h1 {
            color: #ff6600;
            font-size: 24px;
            margin-bottom: 10px;
        }

        p.subtitle {
            color: #777;
            margin-bottom: 25px;
        }

        label {
            display: block;
            margin: 12px 0 5px;
            font-weight: 500;
            color: #444;
        }

        input, textarea, select {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            box-sizing: border-box;
            font-family: inherit;
        }

        textarea {
            resize: vertical;
        }

        input:focus, textarea:focus, select:focus {
            outline: none;
            border-color: #ff6600;
            box-shadow: 0 0 0 2px rgba(255,102,0,0.15);
        }

        .btn {
            background: #ff6600;
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            font-size: 15px;
            margin-top: 20px;
            transition: 0.2s;
        }

        .btn:hover {
            background: #e65c00;
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

        .error {
            color: red;
            margin-top: 10px;
            font-weight: 500;
        }

        .image-preview {
            margin-top: 10px;
            text-align: center;
        }

        .image-preview img {
            max-width: 220px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .upload-box {
            border: 2px dashed #ff6600;
            padding: 20px;
            text-align: center;
            border-radius: 10px;
            background: #fff7f0;
            cursor: pointer;
            transition: 0.3s;
        }

        .upload-box:hover {
            background: #fff0e0;
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
    <a href="${pageContext.request.contextPath}/seller/profile">⚙️ Hồ sơ</a>
</div>

<!-- Main Content -->
<div class="main">
    <div class="card">
        <a href="${pageContext.request.contextPath}/seller/products" class="back-link">← Quay lại danh sách sản phẩm</a>
        <h1>🛍️ Thêm sản phẩm mới</h1>
        <p class="subtitle">Nhập đầy đủ thông tin sản phẩm để hiển thị trong gian hàng của bạn.</p>

        <form action="${pageContext.request.contextPath}/seller/products/add" method="post" enctype="multipart/form-data">
            <label>Tên sản phẩm:</label>
            <input type="text" name="name" placeholder="Ví dụ: Tài khoản VIP Free Fire" required>

            <label>Mô tả:</label>
            <textarea name="description" rows="3" placeholder="Mô tả ngắn gọn về sản phẩm..." required></textarea>

            <label>Giá (VNĐ):</label>
            <input type="number" name="price" step="1000" min="0" placeholder="Nhập giá bán" required>

            <label>Số lượng (tồn kho):</label>
            <input type="number" name="quantity" min="1" value="1" required>

            <label>Danh mục:</label>
            <select name="category_id" required>
                <option value="">-- Chọn danh mục --</option>
                <c:forEach var="c" items="${categories}">
                    <option value="${c.category_id}">${c.name}</option>
                </c:forEach>
            </select>

            <label>Ảnh sản phẩm:</label>
            <div class="upload-box" onclick="document.getElementById('image').click()">
                📸 Nhấn để chọn ảnh sản phẩm
            </div>
            <input type="file" id="image" name="image" accept="image/*" style="display:none;" required onchange="previewImage(event)">

            <div class="image-preview" id="preview"></div>

            <button type="submit" class="btn">➕ Thêm sản phẩm</button>
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
