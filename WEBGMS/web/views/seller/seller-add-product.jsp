<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm sản phẩm mới - Giicungco Seller</title>
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: #fff8f2;
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
            padding: 35px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            max-width: 800px;
            margin: 0 auto;
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

        p.subtitle {
            color: #777;
            margin-bottom: 30px;
            font-size: 15px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
            font-size: 14px;
        }

        label i {
            color: #ff6600;
            margin-right: 5px;
        }

        label .required {
            color: #dc3545;
            margin-left: 3px;
        }

        input, textarea, select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            font-size: 14px;
            font-family: inherit;
            transition: all 0.3s ease;
        }

        textarea {
            resize: vertical;
            min-height: 100px;
        }

        input:focus, textarea:focus, select:focus {
            outline: none;
            border-color: #ff6600;
            box-shadow: 0 0 0 3px rgba(255,102,0,0.1);
        }

        input:hover, textarea:hover, select:hover {
            border-color: #ff8c3a;
        }

        .btn {
            background: linear-gradient(135deg, #ff6600 0%, #ff8c3a 100%);
            color: white;
            padding: 14px 30px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-weight: 600;
            font-size: 15px;
            margin-top: 25px;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 15px rgba(255,102,0,0.3);
        }

        .btn:hover {
            background: linear-gradient(135deg, #e65c00 0%, #ff7b00 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(255,102,0,0.4);
        }

        .btn:active {
            transform: translateY(0);
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            margin-bottom: 20px;
            color: #ff6600;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.2s ease;
            padding: 8px 12px;
            border-radius: 8px;
        }

        .back-link:hover {
            background: #fff7f0;
            transform: translateX(-3px);
        }

        .error {
            background: #ffe5e5;
            border: 2px solid #ff5252;
            color: #c62828;
            padding: 12px 15px;
            border-radius: 10px;
            margin-top: 15px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .success {
            background: #e8f5e9;
            border: 2px solid #4caf50;
            color: #2e7d32;
            padding: 12px 15px;
            border-radius: 10px;
            margin-bottom: 15px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .image-preview {
            margin-top: 15px;
            text-align: center;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 10px;
        }

        .image-preview img {
            max-width: 300px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border: 3px solid white;
        }

        .upload-box {
            border: 3px dashed #ff6600;
            padding: 30px;
            text-align: center;
            border-radius: 15px;
            background: linear-gradient(135deg, #fff7f0 0%, #ffe5d6 100%);
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }

        .upload-box:hover {
            background: linear-gradient(135deg, #fff0e0 0%, #ffd4b8 100%);
            transform: scale(1.02);
            border-color: #ff8c3a;
        }

        .upload-box i {
            font-size: 48px;
            color: #ff6600;
            margin-bottom: 10px;
            display: block;
        }

        .upload-box p {
            margin: 0;
            color: #666;
            font-weight: 500;
        }

        .upload-box .file-info {
            font-size: 12px;
            color: #999;
            margin-top: 8px;
        }
    </style>
</head>
<body>

<!-- Include Sidebar Component -->
<jsp:include page="../component/seller-sidebar.jsp">
    <jsp:param name="activePage" value="products" />
</jsp:include>

<!-- Main Content -->
<div class="main">
    <div class="card">
        <a href="${pageContext.request.contextPath}/seller/products" class="back-link">
            <i class="bi bi-arrow-left"></i> Quay lại danh sách sản phẩm
        </a>
        
        <h1>
            <i class="bi bi-bag-plus"></i> Thêm sản phẩm mới
        </h1>
        <p class="subtitle">Nhập đầy đủ thông tin sản phẩm để hiển thị trong gian hàng của bạn và tiếp cận hàng ngàn khách hàng.</p>

        <c:if test="${not empty error}">
            <div class="error">
                <i class="bi bi-exclamation-triangle-fill"></i>
                ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/seller/products/add" method="post" enctype="multipart/form-data" id="productForm">
            <div class="form-group">
                <label>
                    <i class="bi bi-tag"></i> Tên sản phẩm <span class="required">*</span>
                </label>
                <input type="text" name="name" id="productName" 
                       placeholder="Ví dụ: Tài khoản Netflix Premium 1 tháng" 
                       required minlength="5" maxlength="200">
                <small style="color:#666;font-size:12px;display:block;margin-top:5px;">
                    Tên sản phẩm nên rõ ràng và thu hút (5-200 ký tự)
                </small>
            </div>

            <div class="form-group">
                <label>
                    <i class="bi bi-file-text"></i> Mô tả <span class="required">*</span>
                </label>
                <textarea name="description" id="productDescription" rows="5" 
                          placeholder="Mô tả chi tiết về sản phẩm, tính năng, ưu điểm..." 
                          required minlength="20" maxlength="1000"></textarea>
                <small style="color:#666;font-size:12px;display:block;margin-top:5px;">
                    Mô tả chi tiết giúp sản phẩm bán tốt hơn (20-1000 ký tự)
                </small>
            </div>

            <div class="form-group">
                <label>
                    <i class="bi bi-cash-coin"></i> Giá bán (VNĐ) <span class="required">*</span>
                </label>
                <input type="number" name="price" id="productPrice" 
                       step="1000" min="1000" max="100000000"
                       placeholder="Ví dụ: 150000" required>
                <small style="color:#666;font-size:12px;display:block;margin-top:5px;">
                    Giá từ 1,000đ đến 100,000,000đ
                </small>
            </div>

            <div class="form-group">
                <label>
                    <i class="bi bi-box-seam"></i> Số lượng tồn kho <span class="required">*</span>
                </label>
                <input type="number" name="quantity" id="productQuantity" 
                       min="1" max="10000" value="1" required>
                <small style="color:#666;font-size:12px;display:block;margin-top:5px;">
                    Số lượng sản phẩm có sẵn để bán
                </small>
            </div>

            <div class="form-group">
                <label>
                    <i class="bi bi-folder"></i> Danh mục <span class="required">*</span>
                </label>
                <select name="category_id" id="productCategory" required>
                    <option value="">-- Chọn danh mục phù hợp --</option>
                    <c:forEach var="c" items="${categories}">
                        <option value="${c.category_id}">${c.name}</option>
                    </c:forEach>
                </select>
                <small style="color:#666;font-size:12px;display:block;margin-top:5px;">
                    Chọn danh mục phù hợp để khách hàng dễ tìm thấy
                </small>
            </div>

            <div class="form-group">
                <label>
                    <i class="bi bi-image"></i> Ảnh sản phẩm <span class="required">*</span>
                </label>
                <div class="upload-box" onclick="document.getElementById('image').click()">
                    <i class="bi bi-cloud-arrow-up"></i>
                    <p>Nhấn để chọn ảnh sản phẩm</p>
                    <p class="file-info">Hỗ trợ JPG, PNG, WEBP • Tối đa 10MB</p>
                </div>
                <input type="file" id="image" name="image" 
                       accept="image/png,image/jpeg,image/webp,image/jpg" 
                       style="display:none;" required 
                       onchange="previewImage(event)">
                <div class="image-preview" id="preview" style="display:none;"></div>
            </div>

            <button type="submit" class="btn" id="submitBtn">
                <i class="bi bi-check-circle"></i> Thêm sản phẩm
            </button>
        </form>
    </div>
</div>

<script>
    function previewImage(event) {
        const preview = document.getElementById('preview');
        const file = event.target.files[0];
        const uploadBox = document.querySelector('.upload-box');
        
        if (file) {
            // Validate file size (10MB)
            if (file.size > 10 * 1024 * 1024) {
                alert('⚠️ Kích thước file quá lớn! Vui lòng chọn ảnh nhỏ hơn 10MB.');
                event.target.value = '';
                return;
            }
            
            // Validate file type
            const validTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp'];
            if (!validTypes.includes(file.type)) {
                alert('⚠️ Định dạng file không hợp lệ! Chỉ hỗ trợ JPG, PNG, WEBP.');
                event.target.value = '';
                return;
            }
            
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.style.display = 'block';
                preview.innerHTML = `
                    <div style="position:relative;display:inline-block;">
                        <img src="${e.target.result}" alt="Ảnh xem trước">
                        <div style="margin-top:10px;color:#666;font-size:13px;">
                            <i class="bi bi-check-circle-fill" style="color:#4caf50;"></i>
                            ${file.name} (${(file.size / 1024).toFixed(1)} KB)
                        </div>
                    </div>
                `;
                uploadBox.style.borderColor = '#4caf50';
                uploadBox.style.background = 'linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%)';
            };
            reader.readAsDataURL(file);
        }
    }

    // Form validation
    document.getElementById('productForm')?.addEventListener('submit', function(e) {
        const name = document.getElementById('productName').value.trim();
        const description = document.getElementById('productDescription').value.trim();
        const price = parseInt(document.getElementById('productPrice').value);
        const quantity = parseInt(document.getElementById('productQuantity').value);
        const category = document.getElementById('productCategory').value;
        const image = document.getElementById('image').files[0];
        
        let errors = [];
        
        if (name.length < 5 || name.length > 200) {
            errors.push('Tên sản phẩm phải từ 5-200 ký tự');
        }
        
        if (description.length < 20 || description.length > 1000) {
            errors.push('Mô tả sản phẩm phải từ 20-1000 ký tự');
        }
        
        if (price < 1000 || price > 100000000) {
            errors.push('Giá sản phẩm phải từ 1,000đ đến 100,000,000đ');
        }
        
        if (quantity < 1 || quantity > 10000) {
            errors.push('Số lượng phải từ 1 đến 10,000');
        }
        
        if (!category) {
            errors.push('Vui lòng chọn danh mục sản phẩm');
        }
        
        if (!image) {
            errors.push('Vui lòng chọn ảnh sản phẩm');
        }
        
        if (errors.length > 0) {
            e.preventDefault();
            alert('⚠️ Vui lòng kiểm tra lại:\n\n' + errors.join('\n'));
            return false;
        }
        
        // Disable submit button to prevent double submission
        const submitBtn = document.getElementById('submitBtn');
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="bi bi-hourglass-split"></i> Đang xử lý...';
    });

    // Real-time character count for name and description
    document.getElementById('productName')?.addEventListener('input', function() {
        const length = this.value.length;
        const small = this.nextElementSibling;
        if (length > 0) {
            small.textContent = `Đã nhập ${length}/200 ký tự`;
            small.style.color = length < 5 ? '#dc3545' : length > 200 ? '#dc3545' : '#4caf50';
        }
    });
    
    document.getElementById('productDescription')?.addEventListener('input', function() {
        const length = this.value.length;
        const small = this.nextElementSibling;
        if (length > 0) {
            small.textContent = `Đã nhập ${length}/1000 ký tự`;
            small.style.color = length < 20 ? '#dc3545' : length > 1000 ? '#dc3545' : '#4caf50';
        }
    });
</script>

</body>
</html>
