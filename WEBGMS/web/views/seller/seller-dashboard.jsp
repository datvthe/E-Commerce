<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Bảng điều khiển người bán</title>
    <style>
        .dashboard-container {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            padding: 30px;
        }
        .card {
            background: #fff;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-radius: 10px;
            text-align: center;
        }
        .card h3 { color: #555; margin-bottom: 10px; }
        .card span { font-size: 24px; font-weight: bold; color: #009879; }
    </style>
</head>
<body>
    <h1 style="text-align:center;">📊 Seller Dashboard</h1>
    <div class="dashboard-container">
        <div class="card">
            <h3>Sản phẩm đang bán</h3>
            <span>${totalProducts}</span>
        </div>
        <div class="card">
            <h3>Tổng đơn hàng</h3>
            <span>${totalOrders}</span>
        </div>
        <div class="card">
            <h3>Doanh thu hôm nay</h3>
            <span>${todayRevenue}₫</span>
        </div>
    </div>
</body>
</html> 