<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt hàng thành công - Gicungco</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        body {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            min-height: 100vh;
            padding: 30px 0;
        }
        .success-container {
            max-width: 800px;
            margin: 0 auto;
        }
        .success-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            overflow: hidden;
            animation: slideUp 0.5s ease-out;
        }
        @keyframes slideUp {
            from { transform: translateY(30px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        .success-header {
            background: linear-gradient(135deg, #11998e, #38ef7d);
            color: white;
            padding: 40px;
            text-align: center;
        }
        .success-icon {
            width: 80px;
            height: 80px;
            background: white;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            animation: scaleIn 0.5s ease-out 0.2s both;
        }
        @keyframes scaleIn {
            from { transform: scale(0); }
            to { transform: scale(1); }
        }
        .success-icon i {
            color: #11998e;
            font-size: 2.5rem;
        }
        .success-body {
            padding: 30px;
        }
        .order-info {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 25px;
        }
        .digital-item-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 5px 20px rgba(102,126,234,0.3);
        }
        .code-display {
            background: rgba(255,255,255,0.2);
            backdrop-filter: blur(10px);
            border-radius: 10px;
            padding: 15px;
            margin: 10px 0;
            font-family: 'Courier New', monospace;
            font-size: 1.1rem;
            font-weight: 600;
            text-align: center;
            letter-spacing: 2px;
        }
        .copy-btn {
            background: rgba(255,255,255,0.2);
            border: 1px solid rgba(255,255,255,0.3);
            color: white;
            padding: 8px 20px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
        }
        .copy-btn:hover {
            background: rgba(255,255,255,0.3);
            transform: translateY(-2px);
        }
        .wallet-summary {
            background: #e3f2fd;
            border-left: 4px solid #2196f3;
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
        }
        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 30px;
        }
        .action-buttons .btn {
            flex: 1;
            padding: 12px;
            border-radius: 10px;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="success-container">
        <div class="success-card">
            <!-- Success Header -->
            <div class="success-header">
                <div class="success-icon">
                    <i class="fas fa-check"></i>
                </div>
                <h2 class="mb-2">Đặt hàng thành công!</h2>
                <p class="mb-0">Sản phẩm đã được giao tức thì cho bạn</p>
            </div>
            
            <!-- Success Body -->
            <div class="success-body">
                <!-- Order Info -->
                <div class="order-info">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <div class="small text-muted">Mã đơn hàng:</div>
                            <strong class="text-primary">#${order.orderNumber}</strong>
                        </div>
                        <div class="col-md-6 mb-3">
                            <div class="small text-muted">Thời gian:</div>
                            <strong><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/></strong>
                        </div>
                        <div class="col-md-6">
                            <div class="small text-muted">Trạng thái:</div>
                            <span class="badge bg-success">
                                <i class="fas fa-check-circle me-1"></i>${order.orderStatus}
                            </span>
                        </div>
                        <div class="col-md-6">
                            <div class="small text-muted">Thanh toán:</div>
                            <span class="badge bg-info">
                                <i class="fas fa-wallet me-1"></i>${order.paymentStatus}
                            </span>
                        </div>
                    </div>
                </div>
                
                <!-- Digital Items -->
                <h5 class="mb-3"><i class="fas fa-gift me-2"></i>Sản phẩm của bạn</h5>
                
                <c:choose>
                    <c:when test="${not empty digitalItems}">
                        <c:forEach var="item" items="${digitalItems}" varStatus="status">
                            <div class="digital-item-card">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h6 class="mb-0">
                                        <i class="fas fa-tag me-2"></i>${item.productName}
                                    </h6>
                                    <span class="badge bg-light text-dark">#${status.index + 1}</span>
                                </div>
                                
                                <!-- Mã thẻ -->
                                <div class="mb-2">
                                    <div class="small opacity-75">MÃ THẺ:</div>
                                    <div class="code-display" id="code-${item.digitalId}">
                                        ${item.code}
                                    </div>
                                    <button class="copy-btn btn-sm" onclick="copyToClipboard('code-${item.digitalId}', 'Mã thẻ')">
                                        <i class="fas fa-copy me-1"></i>Copy mã
                                    </button>
                                </div>
                                
                                <!-- Serial (nếu có) -->
                                <c:if test="${not empty item.serial}">
                                    <div class="mb-2">
                                        <div class="small opacity-75">SERIAL:</div>
                                        <div class="code-display" id="serial-${item.digitalId}">
                                            ${item.serial}
                                        </div>
                                        <button class="copy-btn btn-sm" onclick="copyToClipboard('serial-${item.digitalId}', 'Serial')">
                                            <i class="fas fa-copy me-1"></i>Copy serial
                                        </button>
                                    </div>
                                </c:if>
                                
                                <!-- Mật khẩu (nếu có) -->
                                <c:if test="${not empty item.password}">
                                    <div class="mb-2">
                                        <div class="small opacity-75">MẬT KHẨU:</div>
                                        <div class="code-display" id="password-${item.digitalId}">
                                            ${item.password}
                                        </div>
                                        <button class="copy-btn btn-sm" onclick="copyToClipboard('password-${item.digitalId}', 'Mật khẩu')">
                                            <i class="fas fa-copy me-1"></i>Copy mật khẩu
                                        </button>
                                    </div>
                                </c:if>
                                
                                <!-- Hạn sử dụng -->
                                <c:if test="${not empty item.expiresAt}">
                                    <div class="small opacity-75 mt-3">
                                        <i class="fas fa-clock me-1"></i>
                                        Hạn sử dụng: <strong><fmt:formatDate value="${item.expiresAt}" pattern="dd/MM/yyyy"/></strong>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                        
                        <!-- Download All Button -->
                        <div class="text-center mb-3">
                            <button class="btn btn-outline-primary" onclick="downloadAll()">
                                <i class="fas fa-download me-2"></i>Tải tất cả về file TXT
                            </button>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            Đơn hàng đang được xử lý. Vui lòng chờ giây lát...
                        </div>
                    </c:otherwise>
                </c:choose>
                
                <!-- Wallet Summary -->
                <div class="wallet-summary">
                    <h6><i class="fas fa-wallet me-2"></i>Thông tin thanh toán</h6>
                    <div class="row mt-3">
                        <div class="col-6">
                            <div class="small text-muted">Tổng tiền:</div>
                            <strong class="text-danger">
                                -<fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true"/>₫
                            </strong>
                        </div>
                        <div class="col-6">
                            <div class="small text-muted">Số dư còn lại:</div>
                            <strong class="text-success">
                                <fmt:formatNumber value="${currentBalance}" type="number" groupingUsed="true"/>₫
                            </strong>
                        </div>
                    </div>
                </div>
                
                <!-- Action Buttons -->
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/orders" class="btn btn-outline-primary">
                        <i class="fas fa-list me-2"></i>Đơn hàng của tôi
                    </a>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">
                        <i class="fas fa-shopping-bag me-2"></i>Tiếp tục mua
                    </a>
                </div>
                
                <!-- Important Note -->
                <div class="alert alert-warning mt-4">
                    <i class="fas fa-info-circle me-2"></i>
                    <strong>Lưu ý quan trọng:</strong>
                    <ul class="mb-0 mt-2">
                        <li>Vui lòng lưu lại thông tin sản phẩm (chụp ảnh màn hình hoặc tải file)</li>
                        <li>Không chia sẻ mã thẻ/tài khoản với người khác</li>
                        <li>Liên hệ hỗ trợ nếu gặp vấn đề với sản phẩm</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        const contextPath = '<%= request.getContextPath() %>';
        const orderId = ${order.orderId};
        
        // Copy to clipboard
        function copyToClipboard(elementId, label) {
            const element = document.getElementById(elementId);
            const text = element.textContent.trim();
            
            navigator.clipboard.writeText(text).then(() => {
                // Show success toast
                showToast('✅ Đã copy ' + label + '!', 'success');
                
                // Animate button
                const btn = event.target.closest('button');
                btn.innerHTML = '<i class="fas fa-check me-1"></i>Đã copy!';
                setTimeout(() => {
                    btn.innerHTML = '<i class="fas fa-copy me-1"></i>Copy ' + label.toLowerCase();
                }, 2000);
            }).catch(err => {
                console.error('Copy failed:', err);
                alert('Không thể copy. Vui lòng copy thủ công!');
            });
        }
        
        // Download all items as TXT file
        function downloadAll() {
            window.location.href = contextPath + '/order/download?orderId=' + orderId;
        }
        
        // Show toast notification
        function showToast(message, type = 'info') {
            let toastContainer = document.getElementById('toast-container');
            if (!toastContainer) {
                toastContainer = document.createElement('div');
                toastContainer.id = 'toast-container';
                toastContainer.style.cssText = 'position: fixed; top: 20px; right: 20px; z-index: 9999;';
                document.body.appendChild(toastContainer);
            }
            
            const toast = document.createElement('div');
            const bgColor = type === 'success' ? '#28a745' : type === 'error' ? '#dc3545' : '#17a2b8';
            toast.className = 'alert fade show';
            toast.style.cssText = `background: ${bgColor}; color: white; min-width: 250px; margin-bottom: 10px; 
                                   animation: slideInRight 0.3s ease-out; border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);`;
            toast.innerHTML = `<strong>${message}</strong>`;
            
            toastContainer.appendChild(toast);
            
            setTimeout(() => {
                toast.style.animation = 'slideOutRight 0.3s ease-out';
                setTimeout(() => toast.remove(), 300);
            }, 3000);
        }
        
        // Print this page
        function printOrder() {
            window.print();
        }
        
        // Add print styles
        const printStyles = document.createElement('style');
        printStyles.textContent = `
            @media print {
                body { background: white !important; }
                .action-buttons, .alert { display: none !important; }
            }
            @keyframes slideInRight {
                from { transform: translateX(100%); }
                to { transform: translateX(0); }
            }
            @keyframes slideOutRight {
                from { transform: translateX(0); }
                to { transform: translateX(100%); }
            }
        `;
        document.head.appendChild(printStyles);
    </script>
</body>
</html>

