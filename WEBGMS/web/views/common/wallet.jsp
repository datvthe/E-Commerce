<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Ví điện tử - Giicungco</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            background: linear-gradient(135deg, #fff8f2 0%, #ffe5d6 100%);
            font-family: 'Poppins', sans-serif;
            min-height: 100vh;
        }
        
        .wallet-header {
            background: linear-gradient(135deg, #ff6600 0%, #ff8c3a 100%);
            color: white;
            text-align: center;
            padding: 50px 0;
            border-radius: 0 0 30px 30px;
            box-shadow: 0 10px 40px rgba(255,102,0,0.3);
            position: relative;
            overflow: hidden;
        }
        
        .wallet-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            animation: pulse 15s ease-in-out infinite;
        }
        
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.1); }
        }
        
        .wallet-header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            position: relative;
            z-index: 1;
        }
        
        .wallet-header p {
            font-size: 1.1rem;
            opacity: 0.95;
            position: relative;
            z-index: 1;
        }
        
        .wallet-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            padding: 30px;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }
        
        .wallet-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.12);
            border-color: #ff6600;
        }
        
        .balance-card {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
        }
        
        .wallet-balance {
            font-size: 3rem;
            font-weight: 700;
            color: white;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
            margin: 20px 0;
        }
        
        .qr-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .qr-section img {
            border: 5px solid white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            transition: transform 0.3s ease;
        }
        
        .qr-section img:hover {
            transform: scale(1.05);
        }
        
        .copy-box {
            background: rgba(255,255,255,0.2);
            border: 2px dashed white;
            border-radius: 12px;
            padding: 15px;
            margin-top: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .copy-box:hover {
            background: rgba(255,255,255,0.3);
            transform: scale(1.02);
        }
        
        .copy-text {
            font-size: 1.5rem;
            font-weight: 700;
            letter-spacing: 2px;
        }
        
        .table {
            border-radius: 15px;
            overflow: hidden;
        }
        
        .table thead {
            background: linear-gradient(135deg, #ff6600 0%, #ff8c3a 100%);
            color: white;
        }
        
        .table tbody tr {
            transition: all 0.3s ease;
        }
        
        .table tbody tr:hover {
            background: #fff9f3;
            transform: scale(1.01);
        }
        
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.85rem;
            display: inline-block;
        }
        
        .status-success {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
        }
        
        .status-failed {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
            color: white;
        }
        
        .status-pending {
            background: linear-gradient(135deg, #ffd93d 0%, #ffc107 100%);
            color: #333;
        }
        
        .icon-circle {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: rgba(255,255,255,0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            font-size: 24px;
        }
        
        .refresh-btn {
            background: linear-gradient(135deg, #ff6600 0%, #ff8c3a 100%);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(255,102,0,0.3);
        }
        
        .refresh-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(255,102,0,0.4);
        }
        
        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            background: white;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            display: none;
            z-index: 9999;
            animation: slideIn 0.5s ease;
        }
        
        @keyframes slideIn {
            from { transform: translateX(400px); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        
        .amount-positive {
            color: #38ef7d;
            font-weight: 700;
        }
        
        .amount-negative {
            color: #ee5a6f;
            font-weight: 700;
        }
    </style>
</head>

<body>

<!-- Header -->
<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
    <div class="container">
        <a href="<%= request.getContextPath() %>/home" class="navbar-brand fw-bold text-primary">
            <i class="fas fa-wallet me-2"></i> Gicungco
        </a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item mx-2"><a class="nav-link" href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                <li class="nav-item mx-2"><a class="nav-link" href="${pageContext.request.contextPath}/products">Sản phẩm</a></li>
                <li class="nav-item mx-2"><a class="nav-link active text-primary" href="#">Ví của tôi</a></li>
                <li class="nav-item mx-2"><a class="nav-link" href="${pageContext.request.contextPath}/contact">Liên hệ</a></li>
            </ul>
        </div>
    </div>
</nav>

<!-- Notification -->
<div class="notification" id="notification">
    <div class="d-flex align-items-center">
        <i class="bi bi-check-circle-fill text-success fs-3 me-3"></i>
        <div>
            <div class="fw-bold">Nạp tiền thành công!</div>
            <div class="text-muted small">Số dư của bạn đã được cập nhật</div>
        </div>
    </div>
</div>

<!-- Wallet Header -->
<section class="wallet-header mb-5">
    <h1><i class="bi bi-wallet2 me-2"></i>Ví Điện Tử Giicungco</h1>
    <p>Quản lý số dư và lịch sử giao dịch của bạn một cách dễ dàng</p>
</section>

<!-- Wallet Info -->
<div class="container mb-5">
    <div class="row g-4">
        <!-- Balance Card -->
        <div class="col-md-6">
            <div class="wallet-card balance-card text-center">
                <div class="icon-circle">
                    <i class="bi bi-cash-stack"></i>
                </div>
                <h5>Số dư hiện tại</h5>
                <div class="wallet-balance">
                    <fmt:formatNumber value="${balance}" type="number" groupingUsed="true" maxFractionDigits="0"/> ₫
                </div>
                <button class="refresh-btn mt-3" onclick="location.reload()">
                    <i class="bi bi-arrow-clockwise me-2"></i>Làm mới
                </button>
                <hr style="border-color: rgba(255,255,255,0.3); margin: 20px 0;">
                <div class="text-white-50 small">
                    <i class="bi bi-person-badge me-2"></i>User ID: <strong>${sessionScope.user.user_id}</strong>
                </div>
            </div>
        </div>

        <!-- QR + Instructions -->
        <div class="col-md-6">
            <div class="wallet-card qr-section text-center">
                <div class="icon-circle">
                    <i class="bi bi-qr-code"></i>
                </div>
                <h5 class="mb-3">Nạp Tiền Qua QR Code</h5>
                <img src="${pageContext.request.contextPath}/views/assets/electro/img/QR_Code.png" 
                     width="250" alt="QR Code" class="mb-3">
                
                <div class="copy-box" onclick="copyToClipboard('TOPUP-${sessionScope.user.user_id}')" 
                     title="Click để sao chép">
                    <div class="small mb-2">
                        <i class="bi bi-clipboard me-2"></i>Nội dung chuyển khoản:
                    </div>
                    <div class="copy-text" id="copyText">
                        TOPUP-${sessionScope.user.user_id}
                    </div>
                </div>
                
                <div class="mt-4 p-3" style="background: rgba(255,255,255,0.15); border-radius: 12px;">
                    <div class="small text-white-50 mb-2">
                        <i class="bi bi-info-circle me-2"></i>Hướng dẫn:
                    </div>
                    <ol class="text-start small" style="padding-left: 20px;">
                        <li class="mb-2">Quét mã QR hoặc chuyển khoản đến tài khoản</li>
                        <li class="mb-2">Nhập <strong>chính xác</strong> nội dung: <code>TOPUP-${sessionScope.user.user_id}</code></li>
                        <li>Số dư sẽ tự động cập nhật sau 1-2 phút</li>
                    </ol>
                </div>
            </div>
        </div>
    </div>

    <!-- Lịch sử giao dịch -->
    <div class="wallet-card mt-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h5 class="mb-0">
                <i class="bi bi-clock-history me-2 text-primary"></i>Lịch Sử Giao Dịch
            </h5>
            <button class="refresh-btn btn-sm" onclick="location.reload()">
                <i class="bi bi-arrow-clockwise"></i>
            </button>
        </div>

        <c:choose>
            <c:when test="${empty transactions}">
                <div class="text-center py-5">
                    <i class="bi bi-inbox fs-1 text-muted mb-3"></i>
                    <p class="text-muted mb-0">Bạn chưa có giao dịch nào.</p>
                    <small class="text-muted">Lịch sử nạp tiền sẽ hiển thị tại đây</small>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table align-middle mb-0">
                        <thead>
                            <tr>
                                <th><i class="bi bi-hash"></i> Mã GD</th>
                                <th><i class="bi bi-cash"></i> Số tiền</th>
                                <th><i class="bi bi-toggles"></i> Trạng thái</th>
                                <th><i class="bi bi-file-text"></i> Ghi chú</th>
                                <th><i class="bi bi-calendar"></i> Thời gian</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="t" items="${transactions}">
                                <tr>
                                    <td class="font-monospace small">${t.transaction_id}</td>
                                    <td>
                                        <span class="amount-positive">
                                            +<fmt:formatNumber value="${t.amount}" type="number" groupingUsed="true" maxFractionDigits="0"/> ₫
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${t.status eq 'success'}">
                                                <span class="status-badge status-success">
                                                    <i class="bi bi-check-circle me-1"></i>Thành công
                                                </span>
                                            </c:when>
                                            <c:when test="${t.status eq 'pending'}">
                                                <span class="status-badge status-pending">
                                                    <i class="bi bi-hourglass-split me-1"></i>Đang xử lý
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-failed">
                                                    <i class="bi bi-x-circle me-1"></i>Thất bại
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-muted small">${t.note}</td>
                                    <td class="text-muted small">
                                        <fmt:formatDate value="${t.created_at}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Copy to clipboard function
    function copyToClipboard(text) {
        navigator.clipboard.writeText(text).then(() => {
            // Show notification
            const notification = document.getElementById('notification');
            notification.innerHTML = `
                <div class="d-flex align-items-center">
                    <i class="bi bi-clipboard-check-fill text-success fs-3 me-3"></i>
                    <div>
                        <div class="fw-bold">Đã sao chép!</div>
                        <div class="text-muted small">${text}</div>
                    </div>
                </div>
            `;
            notification.style.display = 'block';
            
            // Add animation effect to copy box
            const copyBox = event.currentTarget;
            copyBox.style.transform = 'scale(0.95)';
            setTimeout(() => {
                copyBox.style.transform = 'scale(1.02)';
            }, 100);
            setTimeout(() => {
                copyBox.style.transform = 'scale(1)';
            }, 200);
            
            // Hide notification after 3 seconds
            setTimeout(() => {
                notification.style.display = 'none';
            }, 3000);
        }).catch(err => {
            alert('Không thể sao chép. Vui lòng thử lại!');
        });
    }
    
    // Auto refresh every 30 seconds
    let autoRefreshEnabled = false;
    let refreshInterval;
    
    function toggleAutoRefresh() {
        autoRefreshEnabled = !autoRefreshEnabled;
        if (autoRefreshEnabled) {
            refreshInterval = setInterval(() => {
                location.reload();
            }, 30000); // 30 seconds
            console.log('Auto refresh enabled');
        } else {
            clearInterval(refreshInterval);
            console.log('Auto refresh disabled');
        }
    }
    
    // Check if there's a new transaction from URL parameter
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('success') === 'true') {
        const notification = document.getElementById('notification');
        notification.innerHTML = `
            <div class="d-flex align-items-center">
                <i class="bi bi-check-circle-fill text-success fs-3 me-3"></i>
                <div>
                    <div class="fw-bold">Nạp tiền thành công!</div>
                    <div class="text-muted small">Số dư của bạn đã được cập nhật</div>
                </div>
            </div>
        `;
        notification.style.display = 'block';
        setTimeout(() => {
            notification.style.display = 'none';
            // Clean URL
            window.history.replaceState({}, document.title, window.location.pathname);
        }, 5000);
    }
</script>
</body>
</html>
