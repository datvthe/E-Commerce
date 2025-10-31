<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Số dư không đủ - Gicungco</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        body {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            min-height: 100vh;
            padding: 30px 0;
            display: flex;
            align-items: center;
        }
        .deposit-container {
            max-width: 600px;
            margin: 0 auto;
        }
        .deposit-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            overflow: hidden;
        }
        .deposit-header {
            background: linear-gradient(135deg, #f093fb, #f5576c);
            color: white;
            padding: 40px;
            text-align: center;
        }
        .deposit-icon {
            width: 80px;
            height: 80px;
            background: rgba(255,255,255,0.2);
            backdrop-filter: blur(10px);
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
        }
        .deposit-icon i {
            font-size: 2.5rem;
        }
        .deposit-body {
            padding: 40px;
        }
        .balance-display {
            background: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
        }
        .balance-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px dashed #dee2e6;
        }
        .balance-row:last-child {
            border-bottom: none;
            padding-top: 15px;
            margin-top: 10px;
            border-top: 2px solid #ffc107;
        }
        .shortfall-amount {
            background: linear-gradient(135deg, #f093fb, #f5576c);
            color: white;
            padding: 20px;
            border-radius: 15px;
            text-align: center;
            margin: 25px 0;
        }
        .shortfall-amount h3 {
            font-size: 2.5rem;
            font-weight: 700;
            margin: 10px 0;
        }
        .btn-deposit {
            background: linear-gradient(135deg, #f093fb, #f5576c);
            border: none;
            color: white;
            padding: 15px;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 10px;
            width: 100%;
            transition: transform 0.2s;
        }
        .btn-deposit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(245,87,108,0.4);
        }
        .suggestion-box {
            background: #e3f2fd;
            border-radius: 10px;
            padding: 15px;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <div class="deposit-container">
        <div class="deposit-card">
            <!-- Header -->
            <div class="deposit-header">
                <div class="deposit-icon">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <h2 class="mb-2">Số dư không đủ</h2>
                <p class="mb-0">Vui lòng nạp thêm tiền để hoàn tất đơn hàng</p>
            </div>
            
            <!-- Body -->
            <div class="deposit-body">
                <!-- Product Info -->
                <c:if test="${not empty product}">
                    <div class="mb-4">
                        <h6 class="text-muted mb-2">Sản phẩm bạn đang mua:</h6>
                        <div class="d-flex align-items-center">
                            <c:choose>
                                <c:when test="${not empty product.productImages}">
                                    <img src="${product.productImages[0].url}" alt="${product.name}" 
                                         style="width: 60px; height: 60px; object-fit: cover; border-radius: 10px;">
                                </c:when>
                                <c:otherwise>
                                    <div style="width: 60px; height: 60px; background: #f0f0f0; border-radius: 10px; 
                                                display: flex; align-items: center; justify-content: center;">
                                        <i class="fas fa-image text-muted"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <div class="ms-3">
                                <strong>${product.name}</strong>
                                <div class="small text-muted">Số lượng: ${quantity}</div>
                            </div>
                        </div>
                    </div>
                </c:if>
                
                <!-- Balance Info -->
                <div class="balance-display">
                    <div class="balance-row">
                        <span>Tổng đơn hàng:</span>
                        <strong class="text-danger">
                            <fmt:formatNumber value="${requiredAmount}" type="number" groupingUsed="true"/>₫
                        </strong>
                    </div>
                    <div class="balance-row">
                        <span>Số dư hiện tại:</span>
                        <strong class="text-info">
                            <fmt:formatNumber value="${currentBalance}" type="number" groupingUsed="true"/>₫
                        </strong>
                    </div>
                    <div class="balance-row">
                        <span class="text-danger"><i class="fas fa-arrow-down me-1"></i>Còn thiếu:</span>
                        <strong class="text-danger">
                            <fmt:formatNumber value="${shortfall}" type="number" groupingUsed="true"/>₫
                        </strong>
                    </div>
                </div>
                
                <!-- Shortfall Amount (Big Display) -->
                <div class="shortfall-amount">
                    <div class="small opacity-75">CẦN NẠP THÊM:</div>
                    <h3>
                        <fmt:formatNumber value="${shortfall}" type="number" groupingUsed="true"/>₫
                    </h3>
                    <div class="small opacity-75">để hoàn tất đơn hàng</div>
                </div>
                
                <!-- Suggestion -->
                <div class="suggestion-box">
                    <i class="fas fa-lightbulb text-warning me-2"></i>
                    <strong>Gợi ý:</strong> Nạp 
                    <c:set var="suggestedAmount" value="${(shortfall + 50000) - (shortfall % 50000)}" />
                    <strong class="text-primary">
                        <fmt:formatNumber value="${suggestedAmount}" type="number" groupingUsed="true"/>₫
                    </strong>
                    để có thêm số dư cho các lần mua sau!
                </div>
                
                <!-- Action Buttons -->
                <div class="row g-2 mt-4">
                    <div class="col-md-5">
                        <button type="button" class="btn btn-outline-secondary w-100 py-3" 
                                onclick="window.history.back()">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại
                        </button>
                    </div>
                    <div class="col-md-7">
                        <button type="button" class="btn-deposit" onclick="goToDeposit()">
                            <i class="fas fa-plus-circle me-2"></i>Nạp tiền ngay
                        </button>
                    </div>
                </div>
                
                <!-- Info -->
                <div class="text-center mt-4">
                    <small class="text-muted">
                        <i class="fas fa-shield-alt me-1"></i>
                        Giao dịch an toàn và bảo mật
                    </small>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        const contextPath = '<%= request.getContextPath() %>';
        <c:if test="${not empty productId}">
        const productId = ${productId};
        const quantity = ${quantity};
        </c:if>
        
        function goToDeposit() {
            // Lưu thông tin để redirect về sau khi nạp tiền
            sessionStorage.setItem('pendingCheckout', JSON.stringify({
                productId: productId || 0,
                quantity: quantity || 1,
                requiredAmount: ${requiredAmount}
            }));
            
            // Chuyển đến trang nạp tiền
            window.location.href = contextPath + '/wallet?amount=${shortfall}';
        }
        
        // Auto-redirect sau khi nạp tiền (nếu có callback)
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('deposited') === 'true') {
            // User vừa nạp tiền xong
            const pending = JSON.parse(sessionStorage.getItem('pendingCheckout') || '{}');
            if (pending.productId) {
                setTimeout(() => {
                    window.location.href = contextPath + '/checkout/instant?productId=' + 
                                          pending.productId + '&quantity=' + pending.quantity;
                }, 1500);
            }
        }
    </script>
</body>
</html>

