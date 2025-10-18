<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký bán hàng | Gicungco</title>

    <!-- Bootstrap + Icon -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            background-color: #fff8f0;
            font-family: 'Segoe UI', sans-serif;
        }
        .register-card {
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            padding: 40px;
            margin-top: 50px;
        }
        .title {
            color: #ff7b00;
            font-weight: 700;
            text-align: center;
            margin-bottom: 25px;
        }
        .btn-orange {
            background-color: #ff7b00;
            color: white;
            border: none;
            transition: all 0.3s ease;
        }
        .btn-orange:hover {
            background-color: #e36c00;
        }
        label {
            font-weight: 500;
            color: #444;
        }
        .form-control:focus {
            border-color: #ff7b00;
            box-shadow: 0 0 0 0.2rem rgba(255, 123, 0, 0.25);
        }
    </style>
</head>
<body>

<div class="container col-lg-8 col-md-10">
    <div class="register-card">
        <h2 class="title"><i class="bi bi-shop me-2"></i>Đăng ký bán hàng</h2>
        <form action="${pageContext.request.contextPath}/seller/register" method="post">

            <!-- Thông tin cơ bản -->
            <h5 class="text-orange mb-3 mt-4">Thông tin cá nhân</h5>
            <div class="row g-3">
                <div class="col-md-6">
                    <label>Họ và tên</label>
                    <input type="text" name="fullName" class="form-control" required>
                </div>
                <div class="col-md-6">
                    <label>Email</label>
                    <input type="email" name="email" class="form-control" required>
                </div>
                <div class="col-md-6">
                    <label>Số điện thoại</label>
                    <input type="text" name="phone" class="form-control">
                </div>
            </div>

            <!-- Thông tin shop -->
            <h5 class="text-orange mb-3 mt-4">Thông tin cửa hàng</h5>
            <div class="row g-3">
                <div class="col-md-6">
                    <label>Tên cửa hàng</label>
                    <input type="text" name="shopName" class="form-control" required>
                </div>
                <div class="col-md-6">
                    <label>Danh mục chính</label>
                    <select name="mainCategory" class="form-control">
                        <option value="">-- Chọn danh mục --</option>
                        <option value="Tài khoản game">Tài khoản game</option>
                        <option value="Mã phim, phần mềm">Mã phim, phần mềm</option>
                        <option value="Thẻ cào, giftcode">Thẻ cào / giftcode</option>
                        <option value="Khác">Khác</option>
                    </select>
                </div>
                <div class="col-12">
                    <label>Mô tả cửa hàng</label>
                    <textarea name="shopDescription" rows="3" class="form-control" placeholder="Giới thiệu ngắn gọn về sản phẩm, dịch vụ bạn cung cấp..."></textarea>
                </div>
            </div>

            <!-- Thông tin thanh toán -->
            <h5 class="text-orange mb-3 mt-4">Thông tin thanh toán</h5>
            <div class="row g-3">
                <div class="col-md-4">
                    <label>Ngân hàng</label>
                    <input type="text" name="bankName" class="form-control">
                </div>
                <div class="col-md-4">
                    <label>Số tài khoản</label>
                    <input type="text" name="bankAccount" class="form-control">
                </div>
                <div class="col-md-4">
                    <label>Chủ tài khoản</label>
                    <input type="text" name="accountOwner" class="form-control">
                </div>
            </div>

            <!-- Tiền cọc -->
            <h5 class="text-orange mb-3 mt-4">Tiền cọc đăng ký</h5>
            <div class="row g-3">
                <div class="col-md-6">
                    <label>Số tiền cọc (VNĐ)</label>
                    <input type="number" name="depositAmount" class="form-control" placeholder="Ví dụ: 100000" required>
                </div>
                <div class="col-md-6 d-flex align-items-end">
                    <p class="text-muted small mb-0">
                        * Tiền cọc sẽ được hoàn lại khi ngừng kinh doanh hoặc bị từ chối đăng ký.
                    </p>
                </div>
            </div>

            <div class="text-center mt-5">
                <button type="submit" class="btn btn-orange px-5 py-2">
                    <i class="bi bi-send-fill me-2"></i>Gửi đăng ký
                </button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
