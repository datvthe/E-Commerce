<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <title>Lịch sử đơn hàng - Gicungco Marketplace</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500;600;700&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    
    <!-- Icons -->
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">
    
    <!-- Libraries -->
    <link href="<%= request.getContextPath() %>/views/assets/electro/lib/animate/animate.min.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/views/assets/electro/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/views/assets/electro/css/style.css" rel="stylesheet">
    
    <style>
        .order-card {
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            overflow: hidden;
        }
        
        .order-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1rem 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .order-number {
            font-size: 1.1rem;
            font-weight: 600;
        }
        
        .order-status {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }
        
        .status-paid {
            background: #10b981;
            color: white;
        }
        
        .status-pending {
            background: #f59e0b;
            color: white;
        }
        
        .status-completed {
            background: #3b82f6;
            color: white;
        }
        
        .order-body {
            padding: 1.5rem;
        }
        
        .order-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 1.5rem;
            padding-bottom: 1.5rem;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .info-item {
            display: flex;
            flex-direction: column;
        }
        
        .info-label {
            font-size: 0.85rem;
            color: #666;
            margin-bottom: 0.25rem;
        }
        
        .info-value {
            font-size: 1rem;
            font-weight: 500;
            color: #333;
        }
        
        .digital-products {
            background: #f8f9fa;
            border-radius: 6px;
            padding: 1rem;
        }
        
        .digital-product-item {
            background: white;
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            padding: 1rem;
            margin-bottom: 1rem;
        }
        
        .digital-product-item:last-child {
            margin-bottom: 0;
        }
        
        .product-code {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-top: 0.5rem;
        }
        
        .code-box {
            background: #f1f5f9;
            padding: 0.5rem 1rem;
            border-radius: 4px;
            font-family: 'Courier New', monospace;
            font-weight: 600;
            color: #1e293b;
            flex: 1;
        }
        
        .copy-btn {
            padding: 0.5rem 1rem;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .copy-btn:hover {
            background: #5568d3;
        }
        
        .no-orders {
            text-align: center;
            padding: 3rem;
        }
        
        .no-orders i {
            font-size: 4rem;
            color: #ccc;
            margin-bottom: 1rem;
        }
        
        .pagination {
            margin-top: 2rem;
        }
        
        .total-amount {
            font-size: 1.5rem;
            font-weight: 700;
            color: #dc2626;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <jsp:include page="/views/component/header.jsp" />
    
    <div class="container-fluid py-5">
        <div class="container py-5">
            <div class="row">
                <div class="col-12">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="mb-0">
                            <i class="fas fa-shopping-bag text-primary"></i>
                            Lịch sử đơn hàng
                        </h2>
                        <span class="badge bg-primary" style="font-size: 1rem; padding: 0.5rem 1rem;">
                            Tổng: ${totalOrders} đơn
                        </span>
                    </div>
                    
                    <!-- Error Message -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle"></i> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <!-- Orders List -->
                    <c:choose>
                        <c:when test="${empty orders}">
                            <div class="no-orders">
                                <i class="fas fa-shopping-cart"></i>
                                <h4>Chưa có đơn hàng nào</h4>
                                <p class="text-muted">Bạn chưa mua sản phẩm nào. Hãy khám phá sản phẩm ngay!</p>
                                <a href="<%= request.getContextPath() %>/products" class="btn btn-primary mt-3">
                                    <i class="fas fa-shopping-bag"></i> Khám phá sản phẩm
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${orders}" var="order">
                                <div class="order-card">
                                    <!-- Order Header -->
                                    <div class="order-header">
                                        <div>
                                            <div class="order-number">
                                                <i class="fas fa-receipt"></i>
                                                ${order.orderNumber}
                                            </div>
                                            <div style="font-size: 0.9rem; opacity: 0.9; margin-top: 0.25rem;">
                                                <i class="far fa-clock"></i>
                                                <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm:ss" />
                                            </div>
                                        </div>
                                        <div>
                                            <c:choose>
                                                <c:when test="${order.queueStatus == 'COMPLETED'}">
                                                    <span class="order-status status-completed">
                                                        <i class="fas fa-check-circle"></i> Hoàn thành
                                                    </span>
                                                </c:when>
                                                <c:when test="${order.paymentStatus == 'PAID'}">
                                                    <span class="order-status status-paid">
                                                        <i class="fas fa-check"></i> Đã thanh toán
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="order-status status-pending">
                                                        <i class="fas fa-clock"></i> Đang xử lý
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    
                                    <!-- Order Body -->
                                    <div class="order-body">
                                        <!-- Order Info -->
                                        <div class="order-info">
                                            <div class="info-item">
                                                <span class="info-label">Sản phẩm</span>
                                                <span class="info-value">
                                                    <c:choose>
                                                        <c:when test="${not empty order.product}">
                                                            ${order.product.name}
                                                        </c:when>
                                                        <c:otherwise>
                                                            Sản phẩm #${order.productId}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            
                                            <div class="info-item">
                                                <span class="info-label">Người bán</span>
                                                <span class="info-value">
                                                    <c:choose>
                                                        <c:when test="${not empty order.seller}">
                                                            ${order.seller.full_name}
                                                        </c:when>
                                                        <c:otherwise>
                                                            Seller #${order.sellerId}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            
                                            <div class="info-item">
                                                <span class="info-label">Số lượng</span>
                                                <span class="info-value">${order.quantity}</span>
                                            </div>
                                            
                                            <div class="info-item">
                                                <span class="info-label">Tổng tiền</span>
                                                <span class="total-amount">
                                                    <fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="0" />₫
                                                </span>
                                            </div>
                                        </div>
                                        
                                        <!-- Digital Products -->
                                        <c:if test="${not empty orderDigitalProducts[order.orderId]}">
                                            <div class="digital-products">
                                                <h5 class="mb-3">
                                                    <i class="fas fa-key text-primary"></i>
                                                    Thông tin sản phẩm số
                                                </h5>
                                                
                                                <c:forEach items="${orderDigitalProducts[order.orderId]}" var="dp">
                                                    <div class="digital-product-item">
                                                        <div class="row">
                                                            <div class="col-md-6">
                                                                <strong>Mã thẻ / Code:</strong>
                                                                <div class="product-code">
                                                                    <div class="code-box">${dp.code}</div>
                                                                    <button class="copy-btn" onclick="copyToClipboard('${dp.code}', this)">
                                                                        <i class="fas fa-copy"></i> Sao chép
                                                                    </button>
                                                                </div>
                                                            </div>
                                                            
                                                            <c:if test="${not empty dp.serial}">
                                                                <div class="col-md-6">
                                                                    <strong>Serial:</strong>
                                                                    <div class="product-code">
                                                                        <div class="code-box">${dp.serial}</div>
                                                                        <button class="copy-btn" onclick="copyToClipboard('${dp.serial}', this)">
                                                                            <i class="fas fa-copy"></i> Sao chép
                                                                        </button>
                                                                    </div>
                                                                </div>
                                                            </c:if>
                                                        </div>
                                                        
                                                        <c:if test="${not empty dp.password}">
                                                            <div class="row mt-3">
                                                                <div class="col-md-6">
                                                                    <strong>Mật khẩu:</strong>
                                                                    <div class="product-code">
                                                                        <div class="code-box">${dp.password}</div>
                                                                        <button class="copy-btn" onclick="copyToClipboard('${dp.password}', this)">
                                                                            <i class="fas fa-copy"></i> Sao chép
                                                                        </button>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </c:if>
                                                        
                                                        <c:if test="${not empty dp.additionalInfo}">
                                                            <div class="mt-3">
                                                                <strong>Thông tin thêm:</strong>
                                                                <p class="mb-0 mt-2" style="white-space: pre-wrap;">${dp.additionalInfo}</p>
                                                            </div>
                                                        </c:if>
                                                        
                                                        <c:if test="${not empty dp.expiresAt}">
                                                            <div class="mt-3 text-danger">
                                                                <i class="fas fa-exclamation-triangle"></i>
                                                                <strong>Hạn sử dụng:</strong>
                                                                <fmt:formatDate value="${dp.expiresAt}" pattern="dd/MM/yyyy HH:mm" />
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                            
                            <!-- Pagination -->
                            <c:if test="${totalPages > 1}">
                                <nav aria-label="Page navigation">
                                    <ul class="pagination justify-content-center">
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="?page=${currentPage - 1}">
                                                <i class="fas fa-chevron-left"></i> Trước
                                            </a>
                                        </li>
                                        
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link" href="?page=${i}">${i}</a>
                                            </li>
                                        </c:forEach>
                                        
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link" href="?page=${currentPage + 1}">
                                                Sau <i class="fas fa-chevron-right"></i>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Footer -->
    <jsp:include page="/views/component/footer.jsp" />
    
    <script>
        function copyToClipboard(text, button) {
            navigator.clipboard.writeText(text).then(() => {
                const originalHTML = button.innerHTML;
                button.innerHTML = '<i class="fas fa-check"></i> Đã sao chép!';
                button.style.background = '#10b981';
                
                setTimeout(() => {
                    button.innerHTML = originalHTML;
                    button.style.background = '#667eea';
                }, 2000);
            }).catch(err => {
                alert('Không thể sao chép: ' + err);
            });
        }
    </script>
</body>
</html>

