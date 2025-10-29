<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán - Gicungco</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 30px 0;
        }
        .checkout-container {
            max-width: 700px;
            margin: 0 auto;
        }
        .checkout-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            overflow: hidden;
        }
        .checkout-header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 30px;
            text-align: center;
        }
        .checkout-header h2 {
            font-size: 2rem;
            font-weight: 700;
            margin: 0;
        }
        .checkout-body {
            padding: 30px;
        }
        .product-summary {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 25px;
        }
        .product-summary img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 10px;
        }
        .price-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px dashed #dee2e6;
        }
        .price-row:last-child {
            border-bottom: none;
        }
        .total-row {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
        }
        .wallet-info {
            background: #e3f2fd;
            border-left: 4px solid #2196f3;
            padding: 15px;
            border-radius: 8px;
            margin: 20px 0;
        }
        .btn-confirm {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border: none;
            color: white;
            padding: 15px;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 10px;
            width: 100%;
            transition: transform 0.2s;
        }
        .btn-confirm:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102,126,234,0.4);
        }
        .security-badge {
            text-align: center;
            color: #6c757d;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="checkout-container">
        <div class="checkout-card">
            <!-- Header -->
            <div class="checkout-header">
                <i class="fas fa-shopping-cart fa-2x mb-3"></i>
                <h2>Xác nhận thanh toán</h2>
                <p class="mb-0">Vui lòng kiểm tra thông tin trước khi thanh toán</p>
            </div>
            
            <!-- Body -->
            <div class="checkout-body">
                <!-- Product Summary -->
                <div class="product-summary">
                    <h5 class="mb-3"><i class="fas fa-box me-2"></i>Sản phẩm</h5>
                    <div class="d-flex align-items-center">
                        <c:choose>
                            <c:when test="${not empty product.productImages}">
                                <img src="${product.productImages[0].url}" alt="${product.name}">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/views/assets/user/img/product-1.png" alt="${product.name}">
                            </c:otherwise>
                        </c:choose>
                        <div class="ms-3 flex-grow-1">
                            <h6 class="mb-1">${product.name}</h6>
                            <div class="text-muted small">
                                <fmt:formatNumber value="${unitPrice}" type="number" groupingUsed="true"/>₫ × ${quantity}
                            </div>
                            <div class="badge bg-success mt-2">
                                <i class="fas fa-bolt me-1"></i>Giao hàng tức thì
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Price Breakdown -->
                <div class="price-breakdown">
                    <div class="price-row">
                        <span>Đơn giá:</span>
                        <strong><fmt:formatNumber value="${unitPrice}" type="number" groupingUsed="true"/>₫</strong>
                    </div>
                    <div class="price-row">
                        <span>Số lượng:</span>
                        <strong>×${quantity}</strong>
                    </div>
                    <div class="price-row">
                        <span>Giảm giá:</span>
                        <strong class="text-danger">0₫</strong>
                    </div>
                </div>
                
                <!-- Total -->
                <div class="total-row">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="small opacity-75">Tổng cộng:</div>
                            <h3 class="mb-0">
                                <fmt:formatNumber value="${totalAmount}" type="number" groupingUsed="true"/>₫
                            </h3>
                        </div>
                        <i class="fas fa-wallet fa-2x opacity-75"></i>
                    </div>
                </div>
                
                <!-- Wallet Info -->
                <div class="wallet-info">
                    <h6><i class="fas fa-wallet me-2"></i>Thanh toán qua Ví ảo</h6>
                    <div class="row mt-3">
                        <div class="col-6">
                            <div class="small text-muted">Số dư hiện tại:</div>
                            <strong class="text-primary">
                                <fmt:formatNumber value="${currentBalance}" type="number" groupingUsed="true"/>₫
                            </strong>
                        </div>
                        <div class="col-6">
                            <div class="small text-muted">Còn lại sau TT:</div>
                            <strong class="text-success">
                                <fmt:formatNumber value="${balanceAfter}" type="number" groupingUsed="true"/>₫
                            </strong>
                        </div>
                    </div>
                    <div class="alert alert-info mt-3 mb-0 small">
                        <i class="fas fa-info-circle me-1"></i>
                        Sản phẩm sẽ được giao <strong>TỨC THÌ</strong> sau khi thanh toán thành công!
                    </div>
                </div>
                
                <!-- Terms -->
                <div class="form-check mb-3">
                    <input class="form-check-input" type="checkbox" id="agreeTerms" checked required>
                    <label class="form-check-label small" for="agreeTerms">
                        Tôi đồng ý với <a href="#" class="text-decoration-none">điều khoản sử dụng</a> và 
                        <a href="#" class="text-decoration-none">chính sách hoàn tiền</a>
                    </label>
                </div>
                
                <!-- Action Buttons -->
                <div class="row g-2">
                    <div class="col-md-5">
                        <button type="button" class="btn btn-outline-secondary w-100 py-3" onclick="window.history.back()">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại
                        </button>
                    </div>
                    <div class="col-md-7">
                        <button type="button" class="btn-confirm" id="btnConfirm" onclick="confirmPayment()">
                            <i class="fas fa-check-circle me-2"></i>Xác nhận thanh toán
                        </button>
                    </div>
                </div>
                
                <!-- Security -->
                <div class="security-badge">
                    <i class="fas fa-shield-alt me-1"></i>
                    <small>Giao dịch được mã hóa và bảo mật</small>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Loading Modal -->
    <div class="modal fade" id="loadingModal" data-bs-backdrop="static" data-bs-keyboard="false">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-body text-center py-5">
                    <div class="spinner-border text-primary mb-3" role="status" style="width: 3rem; height: 3rem;">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <h5>Đang xử lý thanh toán...</h5>
                    <p class="text-muted mb-0">Vui lòng không tắt trang này</p>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        const contextPath = '<%= request.getContextPath() %>';
        const productId = ${product.product_id};
        const quantity = ${quantity};
        
        function confirmPayment() {
            // Check terms
            if (!document.getElementById('agreeTerms').checked) {
                alert('Vui lòng đồng ý với điều khoản sử dụng!');
                return;
            }
            
            // Disable button
            const btn = document.getElementById('btnConfirm');
            btn.disabled = true;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
            
            // Show loading modal
            const loadingModal = new bootstrap.Modal(document.getElementById('loadingModal'));
            loadingModal.show();
            
            // Send payment request
            fetch(contextPath + '/checkout/process', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    productId: productId,
                    quantity: quantity,
                    paymentMethod: 'WALLET'
                })
            })
            .then(response => response.json())
            .then(data => {
                loadingModal.hide();
                
                if (data.status === 'SUCCESS') {
                    // Success → Redirect to success page
                    window.location.href = contextPath + '/order/success?orderId=' + data.orderId;
                } else if (data.status === 'INSUFFICIENT_BALANCE') {
                    // Thiếu tiền → Redirect to wallet
                    alert('❌ ' + data.message);
                    window.location.href = contextPath + '/wallet';
                } else if (data.status === 'OUT_OF_STOCK') {
                    // Hết hàng
                    alert('❌ ' + data.message);
                    window.location.href = contextPath + '/products';
                } else {
                    // Error
                    alert('❌ ' + (data.message || 'Có lỗi xảy ra'));
                    btn.disabled = false;
                    btn.innerHTML = '<i class="fas fa-check-circle me-2"></i>Xác nhận thanh toán';
                }
            })
            .catch(error => {
                loadingModal.hide();
                console.error('Error:', error);
                alert('❌ Không thể kết nối đến server!');
                btn.disabled = false;
                btn.innerHTML = '<i class="fas fa-check-circle me-2"></i>Xác nhận thanh toán';
            });
        }
    </script>
</body>
</html>

