<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Ví điện tử - Gicungco</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f6f7fb;
            font-family: 'Open Sans', sans-serif;
        }
        .wallet-header {
            background: linear-gradient(135deg, #6c63ff, #8c52ff);
            color: white;
            text-align: center;
            padding: 40px 0;
            border-radius: 0 0 30px 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .wallet-header h1 {
            font-size: 2.2rem;
            font-weight: 700;
        }
        .wallet-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.05);
            padding: 25px;
        }
        .wallet-balance {
            font-size: 2.5rem;
            font-weight: 700;
            color: #28a745;
        }
        .qr-section img {
            border: 3px solid #eaeaea;
            border-radius: 10px;
        }
        .table thead {
            background-color: #6c63ff;
            color: white;
        }
        .status-success {
            color: #28a745;
            font-weight: 600;
        }
        .status-failed {
            color: #dc3545;
            font-weight: 600;
        }
        .status-pending {
            color: #ffc107;
            font-weight: 600;
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

<!-- Wallet Header -->
<section class="wallet-header mb-5">
    <h1><i class="fas fa-wallet me-2"></i>Ví điện tử của bạn</h1>
    <p>Quản lý số dư và lịch sử giao dịch của bạn tại Gicungco</p>
</section>

<!-- Wallet Info -->
<div class="container mb-5">
    <div class="row g-4">
        <!-- Balance -->
        <div class="col-md-6">
            <div class="wallet-card text-center">
                <h5 class="text-secondary">Số dư hiện tại</h5>
                <div class="wallet-balance mt-2">${balance} ₫</div>
                <hr>
                <h6 class="text-muted mt-3">ID người dùng: ${sessionScope.user.user_id}</h6>
            </div>
        </div>

        <!-- QR + Hướng dẫn -->
        <div class="col-md-6">
            <div class="wallet-card qr-section text-center">
                <h5 class="text-secondary mb-3">Nạp tiền qua QR</h5>
                <img src="${pageContext.request.contextPath}/views/assets/electro/img/QR_Code.png" width="220" alt="QR Code">
                <p class="mt-3">💡 Khi chuyển khoản, vui lòng ghi chú:  
                    <span class="fw-bold text-primary">TOPUP-${sessionScope.user.user_id}</span>
                </p>
                <p class="text-muted mb-0" style="font-size: 0.9rem;">
                    ⚠️ Ghi chú phải đúng để hệ thống tự động cộng tiền.<br>
                    Ví dụ: <code>TOPUP-5</code> (với ID của bạn là 5)
                </p>
            </div>
        </div>
    </div>

    <!-- Lịch sử giao dịch -->
    <div class="wallet-card mt-5">
        <h5 class="text-secondary mb-3"><i class="fas fa-history me-2"></i>Lịch sử giao dịch</h5>

        <c:choose>
            <c:when test="${empty transactions}">
                <p class="text-center text-muted mb-0">Bạn chưa có giao dịch nào.</p>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table table-bordered align-middle">
                        <thead>
                            <tr class="text-center">
                                <th>Mã giao dịch</th>
                                <th>Số tiền</th>
                                <th>Trạng thái</th>
                                <th>Ghi chú</th>
                                <th>Thời gian</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="t" items="${transactions}">
                                <tr class="text-center">
                                    <td>${t.transaction_id}</td>
                                    <td class="fw-bold text-success">${t.amount} ₫</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${t.status eq 'SUCCESS'}">
                                                <span class="status-success">Thành công</span>
                                            </c:when>
                                            <c:when test="${t.status eq 'PENDING'}">
                                                <span class="status-pending">Đang xử lý</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-failed">Thất bại</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${t.note}</td>
                                    <td>${t.created_at}</td>
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
</body>
</html>
