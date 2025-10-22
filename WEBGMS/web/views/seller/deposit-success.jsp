<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Nộp tiền cọc thành công | Gicungco</title>

    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        body {
            background-color: #fff8f0;
            font-family: 'Segoe UI', sans-serif;
        }

        .success-card {
            max-width: 700px;
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 6px 25px rgba(0,0,0,0.1);
            padding: 50px 40px;
            margin: 100px auto;
            text-align: center;
            animation: fadeIn 0.6s ease-in-out;
        }

        @keyframes fadeIn {
            0% { opacity: 0; transform: translateY(20px); }
            100% { opacity: 1; transform: translateY(0); }
        }

        .success-icon {
            font-size: 85px;
            color: #ff7b00;
            margin-bottom: 25px;
            animation: pop 0.4s ease-out;
        }

        @keyframes pop {
            0% { transform: scale(0.5); opacity: 0; }
            100% { transform: scale(1); opacity: 1; }
        }

        h2 {
            font-weight: 700;
            color: #333;
        }

        p {
            color: #555;
            font-size: 1rem;
            margin-top: 10px;
            line-height: 1.6;
        }

        .btn-orange {
            background-color: #ff7b00;
            color: #fff;
            border: none;
            border-radius: 50px;
            padding: 10px 30px;
            font-weight: 600;
            transition: 0.3s;
        }

        .btn-orange:hover {
            background-color: #e36c00;
        }

        .btn-outline-secondary {
            border-radius: 50px;
        }

        footer {
            text-align: center;
            color: #aaa;
            font-size: 0.9rem;
            margin-top: 60px;
            padding-bottom: 20px;
        }
    </style>
</head>
<body>

    <div class="success-card">
        <i class="fa-solid fa-circle-check success-icon"></i>
        <h2>Nộp tiền cọc thành công!</h2>
        <p>Cảm ơn bạn đã hoàn tất bước nộp tiền cọc để mở gian hàng trên <strong>Gicungco</strong>.<br>
           Hệ thống sẽ kiểm tra và xác nhận trong vòng <b>24 giờ làm việc</b>.<br>
           Sau khi được duyệt, bạn sẽ nhận thông báo qua email.</p>

        <div class="mt-4">
            <a href="<%= request.getContextPath() %>/home" class="btn btn-orange me-2">
                <i class="fa-solid fa-house me-2"></i>Về trang chủ
            </a>
            <a href="<%= request.getContextPath() %>/seller/dashboard" class="btn btn-outline-secondary">
                <i class="fa-solid fa-chart-line me-2"></i>Trang quản lý
            </a>
        </div>
    </div>

    <footer>
        © 2025 GICUNGCO Marketplace. All rights reserved.
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
