<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chỉnh sửa thông tin shop - Gicungco Seller</title>
    
    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            font-family: "Poppins", sans-serif;
            background-color: #fff8f2;
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }

        /* Sidebar styles are now in component/seller-sidebar.jsp */

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
            max-width: 800px;
            margin: 0 auto;
        }

        h1 {
            color: #ff6600;
            font-size: 24px;
            margin-bottom: 10px;
        }

        .subtitle {
            color: #777;
            margin-bottom: 25px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }

        .required {
            color: #ff6600;
        }

        input, textarea, select {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            box-sizing: border-box;
            font-family: inherit;
            transition: border-color 0.3s;
        }

        input:focus, textarea:focus, select:focus {
            outline: none;
            border-color: #ff6600;
            box-shadow: 0 0 0 2px rgba(255,102,0,0.15);
        }

        textarea {
            resize: vertical;
            min-height: 100px;
        }

        .btn {
            background: #ff6600;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            font-size: 15px;
            transition: background 0.3s;
        }

        .btn:hover {
            background: #e65c00;
        }

        .btn-secondary {
            background: #6c757d;
            margin-right: 10px;
            color: white;
            text-decoration: none;
            display: inline-block;
        }

        .btn-secondary:hover {
            background: #5a6268;
            color: white;
        }

        .alert {
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .form-row {
            display: flex;
            gap: 20px;
        }

        .form-row .form-group {
            flex: 1;
        }

        .section-title {
            color: #ff6600;
            font-size: 18px;
            font-weight: 600;
            margin: 30px 0 15px 0;
            padding-bottom: 8px;
            border-bottom: 2px solid #ff6600;
        }

        .back-link {
            display: inline-block;
            padding: 8px 12px;
            color: #ff6600;
            text-decoration: none;
            font-weight: 500;
            border: 1px solid #ff6600;
            border-radius: 6px;
            transition: all 0.3s;
        }

        .back-link:hover {
            background-color: #ff6600;
            color: white;
            text-decoration: none;
        }
    </style>
</head>
<body>

    <!-- Include Sidebar Component -->
    <jsp:include page="../component/seller-sidebar.jsp">
        <jsp:param name="activePage" value="profile" />
    </jsp:include>

    <div class="main">
        <div class="card">
            <div style="display: flex; gap: 10px; margin-bottom: 20px;">
                <a href="${pageContext.request.contextPath}/seller/dashboard" class="back-link">
                    <i class="bi bi-house"></i> Trang chủ
                </a>
                <a href="${pageContext.request.contextPath}/seller/profile" class="back-link">
                    <i class="bi bi-arrow-clockwise"></i> Làm mới trang
                </a>
            </div>
            
            <h1><i class="bi bi-person-gear"></i> Chỉnh sửa thông tin shop</h1>
            <p class="subtitle">Cập nhật thông tin cá nhân và cửa hàng của bạn.</p>

            <!-- Success/Error Messages -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success">
                    <i class="bi bi-check-circle"></i> ✅ Cập nhật thông tin thành công!
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="bi bi-exclamation-triangle"></i> ${error}
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/seller/profile">
                
                <!-- Thông tin cá nhân -->
                <div class="section-title">
                    <i class="bi bi-person"></i> Thông tin cá nhân
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="fullName">Họ và tên <span class="required">*</span></label>
                        <input type="text" id="fullName" name="fullName" 
                               value="${seller.fullName}" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Email <span class="required">*</span></label>
                        <input type="email" id="email" name="email" 
                               value="${seller.email}" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="phone">Số điện thoại <span class="required">*</span></label>
                    <input type="tel" id="phone" name="phone" 
                           value="${seller.phone}" required>
                </div>

                <!-- Thông tin cửa hàng -->
                <div class="section-title">
                    <i class="bi bi-shop"></i> Thông tin cửa hàng
                </div>

                <div class="form-group">
                    <label for="shopName">Tên cửa hàng <span class="required">*</span></label>
                    <input type="text" id="shopName" name="shopName" 
                           value="${seller.shopName}" required>
                </div>

                <div class="form-group">
                    <label for="shopDescription">Mô tả cửa hàng</label>
                    <textarea id="shopDescription" name="shopDescription" 
                              placeholder="Mô tả ngắn gọn về cửa hàng của bạn...">${seller.shopDescription}</textarea>
                </div>

                <div class="form-group">
                    <label for="mainCategory">Danh mục chính</label>
                    <select id="mainCategory" name="mainCategory">
                        <option value="">-- Chọn danh mục --</option>
                        <option value="Tài khoản game" ${seller.mainCategory == 'Tài khoản game' ? 'selected' : ''}>Tài khoản game</option>
                        <option value="Tài khoản Netflix" ${seller.mainCategory == 'Tài khoản Netflix' ? 'selected' : ''}>Tài khoản Netflix</option>
                        <option value="Tài khoản ChatGPT" ${seller.mainCategory == 'Tài khoản ChatGPT' ? 'selected' : ''}>Tài khoản ChatGPT</option>
                        <option value="Thẻ cào điện thoại" ${seller.mainCategory == 'Thẻ cào điện thoại' ? 'selected' : ''}>Thẻ cào điện thoại</option>
                        <option value="Thẻ game" ${seller.mainCategory == 'Thẻ game' ? 'selected' : ''}>Thẻ game</option>
                        <option value="Tài khoản Spotify" ${seller.mainCategory == 'Tài khoản Spotify' ? 'selected' : ''}>Tài khoản Spotify</option>
                        <option value="Tài khoản YouTube Premium" ${seller.mainCategory == 'Tài khoản YouTube Premium' ? 'selected' : ''}>Tài khoản YouTube Premium</option>
                        <option value="Khác" ${seller.mainCategory == 'Khác' ? 'selected' : ''}>Khác</option>
                    </select>
                </div>

                <!-- Thông tin ngân hàng -->
                <div class="section-title">
                    <i class="bi bi-bank"></i> Thông tin ngân hàng
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="bankName">Tên ngân hàng</label>
                        <input type="text" id="bankName" name="bankName" 
                               value="${seller.bankName}" placeholder="VD: Vietcombank, Techcombank...">
                    </div>
                    <div class="form-group">
                        <label for="bankAccount">Số tài khoản</label>
                        <input type="text" id="bankAccount" name="bankAccount" 
                               value="${seller.bankAccount}" placeholder="Số tài khoản ngân hàng">
                    </div>
                </div>

                <div class="form-group">
                    <label for="accountOwner">Chủ tài khoản</label>
                    <input type="text" id="accountOwner" name="accountOwner" 
                           value="${seller.accountOwner}" placeholder="Tên chủ tài khoản">
                </div>

                <!-- Buttons -->
                <div style="margin-top: 30px; text-align: center;">
                    <a href="${pageContext.request.contextPath}/seller/dashboard" class="btn btn-secondary">
                        <i class="bi bi-house"></i> Trang chủ
                    </a>
                    <button type="button" class="btn btn-secondary" onclick="history.back()">
                        <i class="bi bi-arrow-left"></i> Quay lại
                    </button>
                    <button type="submit" class="btn">
                        <i class="bi bi-check-circle"></i> Lưu thay đổi
                    </button>
                </div>

            </form>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
