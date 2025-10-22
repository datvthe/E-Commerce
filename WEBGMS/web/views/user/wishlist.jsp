<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Wishlist - Gicungco</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        .navbar {
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .navbar-brand {
            font-size: 1.3rem;
            font-weight: 700;
        }
        .nav-link.active {
            font-weight: 600;
            color: #f97316 !important;
        }
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
            background: #f8f9fa;
            color: #333;
            line-height: 1.6;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .header {
            background: linear-gradient(135deg, #f97316 0%, #ea580c 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
            text-align: center;
            position: relative;
        }
        
        .logo-container {
            position: absolute;
            top: 1rem;
            left: 2rem;
        }
        
        .logo-link {
            display: inline-flex;
            align-items: center;
            text-decoration: none;
            color: white;
            font-size: 1.5rem;
            font-weight: 700;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.1);
            padding: 0.5rem 1rem;
            border-radius: 10px;
            backdrop-filter: blur(10px);
        }
        
        .logo-link:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }
        
        .logo-icon {
            font-size: 2rem;
            margin-right: 0.5rem;
        }
        
        .header h1 {
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
        }
        
        .stats {
            background: rgba(255,255,255,0.2);
            display: inline-block;
            padding: 1rem 2rem;
            border-radius: 10px;
            margin-top: 1rem;
        }
        
        .wishlist-item {
            background: white;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: transform 0.2s ease;
        }
        
        .wishlist-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        
        .product-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
            margin-right: 1.5rem;
            border: 2px solid #f0f0f0;
        }
        
        .product-details {
            flex: 1;
        }
        
        .product-name {
            font-size: 1.25rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 0.5rem;
        }
        
        .product-price {
            font-size: 1.5rem;
            font-weight: 700;
            color: #059669;
            margin-bottom: 0.5rem;
        }
        
        .product-category {
            display: inline-block;
            background: linear-gradient(135deg, #f97316 0%, #ea580c 100%);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            margin-bottom: 0.5rem;
        }
        
        .product-rating {
            margin-bottom: 0.5rem;
        }
        
        .star {
            color: #fbbf24;
            font-size: 1.1rem;
        }
        
        .star-empty {
            color: #d1d5db;
            font-size: 1.1rem;
        }
        
        .added-date {
            color: #6b7280;
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
        }
        
        .product-description {
            color: #6b7280;
            font-size: 0.9rem;
        }
        
        .actions {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
            min-width: 140px;
        }
        
        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            transition: all 0.2s ease;
            font-size: 0.9rem;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #f97316 0%, #ea580c 100%);
            color: white;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #ea580c 0%, #c2410c 100%);
            transform: translateY(-1px);
        }
        
        .btn-danger {
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
            color: white;
            padding: 0.5rem 1rem;
        }
        
        .btn-danger:hover {
            background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
            transform: translateY(-1px);
        }
        
        .btn-outline {
            background: transparent;
            border: 2px solid #3b71ca;
            color: #3b71ca;
            padding: 0.5rem 1rem;
        }
        
        .btn-outline:hover {
            background: #3b71ca;
            color: white;
        }
        
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .empty-state h2 {
            font-size: 1.5rem;
            color: #6b7280;
            margin-bottom: 1rem;
        }
        
        .empty-state p {
            color: #9ca3af;
            margin-bottom: 2rem;
        }
        
        .btn-large {
            background: linear-gradient(135deg, #f97316 0%, #ea580c 100%);
            color: white;
            padding: 1rem 2rem;
            border: none;
            border-radius: 8px;
            font-size: 1.1rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            transition: all 0.2s ease;
        }
        
        .btn-large:hover {
            background: linear-gradient(135deg, #ea580c 0%, #c2410c 100%);
            transform: translateY(-1px);
            color: white;
        }
        
        .summary {
            background: white;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .btn-clear {
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
            color: white;
            padding: 0.5rem 1.5rem;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
        }
        
        .btn-clear:hover {
            background: linear-gradient(135deg, #d97706 0%, #b45309 100%);
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            margin: 2rem 0;
            gap: 0.5rem;
        }
        
        .page-link {
            padding: 0.5rem 1rem;
            border: 1px solid #e0e0e0;
            color: #6b7280;
            text-decoration: none;
            border-radius: 4px;
            transition: all 0.2s ease;
        }
        
        .page-link:hover {
            background: #fff7ed;
            color: #f97316;
        }
        
        .page-link.active {
            background: linear-gradient(135deg, #f97316 0%, #ea580c 100%);
            color: white;
            border-color: #f97316;
        }
        
        .actions-footer {
            text-align: center;
            margin-top: 2rem;
        }
        
        @media (max-width: 768px) {
            .wishlist-item {
                flex-direction: column;
                text-align: center;
            }
            
            .product-image {
                margin: 0 0 1rem 0;
            }
            
            .actions {
                flex-direction: row;
                justify-content: center;
                margin-top: 1rem;
            }
            
            .summary {
                flex-direction: column;
                gap: 1rem;
            }
        }
    </style>
</head>
<body>
    <!-- Simple Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-light bg-light border-bottom">
        <div class="container-fluid px-4">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
                <span style="font-size: 1.5rem;">🎮</span>
                <strong>Gicungco</strong>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/home">🏠 Trang chủ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/products">🛒 Sản phẩm</a>
                    </li>
                    <c:if test="${not empty sessionScope.user}">
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/wishlist">♥ Yêu thích</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/profile">👤 Hồ sơ</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-danger" href="${pageContext.request.contextPath}/logout">🚪 Đăng xuất</a>
                        </li>
                    </c:if>
                    <c:if test="${empty sessionScope.user}">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/login">🔑 Đăng nhập</a>
                        </li>
                    </c:if>
                </ul>
            </div>
        </div>
    </nav>
    
    <!-- Header -->
    <div class="header">
        <!-- Logo -->
        <div class="logo-container">
            <a href="${pageContext.request.contextPath}/home" class="logo-link" title="Back to Homepage">
                <span class="logo-icon">🎮</span>
                <span>Gicungco</span>
            </a>
        </div>
        
        <div class="container">
            <h1>♥ Danh Sách Yêu Thích</h1>
            <p>Quản lý các sản phẩm số yêu thích của bạn</p>
            <div class="stats">
                <strong>${not empty wishlistItems ? wishlistItems.size() : 0}</strong> Sản phẩm trong danh sách
            </div>
        </div>
    </div>
    
    <!-- Main Content -->
    <div class="container">
        <c:choose>
            <c:when test="${not empty wishlistItems}">
                <!-- Wishlist Summary -->
                <div class="summary">
                    <div>
                        <h3>📋 Tổng Quan</h3>
                        <p>Bạn có ${wishlistItems.size()} sản phẩm trong danh sách yêu thích</p>
                    </div>
                    <button class="btn-clear" onclick="clearAll()">🗑 Xóa Tất Cả</button>
                </div>
                
                <!-- Wishlist Items -->
                <c:forEach var="item" items="${wishlistItems}" varStatus="status">
                    <div class="wishlist-item" id="item-${item.productId.product_id}">
                        <!-- Product Image -->
                        <c:choose>
                            <c:when test="${not empty item.productId.imageUrl}">
                                <img src="${pageContext.request.contextPath}${item.productId.imageUrl}" alt="${item.productId.name}" class="product-image" loading="lazy">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/views/assets/electro/img/product-${(status.index % 8) + 1}.png" alt="${item.productId.name}" class="product-image" loading="lazy">
                            </c:otherwise>
                        </c:choose>
                        
                        <!-- Product Details -->
                        <div class="product-details">
                            <c:if test="${not empty item.productId.category_name}">
                                <div class="product-category">🏷 ${item.productId.category_name}</div>
                            </c:if>
                            <div class="product-name">${item.productId.name}</div>
                            <div class="product-price">
                                <fmt:formatNumber value="${item.productId.price}" type="currency" 
                                                 currencySymbol="${item.productId.currency == 'VND' ? 'đ' : '$'}" 
                                                 maxFractionDigits="0"/>
                            </div>
                            <div class="product-rating">
                                <c:forEach begin="1" end="5" var="i">
                                    <span class="${i <= item.productId.average_rating ? 'star' : 'star-empty'}">★</span>
                                </c:forEach>
                                <span style="color: #6b7280; margin-left: 0.5rem;">(${item.productId.total_reviews} reviews)</span>
                            </div>
                            <div class="added-date">
                                📅 Added <fmt:formatDate value="${item.addedAt}" pattern="MMM dd, yyyy"/>
                            </div>
                            <c:if test="${not empty item.productId.description}">
                                <div class="product-description">
                                    <c:choose>
                                        <c:when test="${item.productId.description.length() > 150}">
                                            ${item.productId.description.substring(0, 150)}...
                                        </c:when>
                                        <c:otherwise>
                                            ${item.productId.description}
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </c:if>
                        </div>
                        
                        <!-- Actions -->
                        <div class="actions">
                            <a href="${pageContext.request.contextPath}/product/${item.productId.slug}" class="btn btn-primary">
                                👁 Xem Chi Tiết
                            </a>
                            
                            <button class="btn btn-danger" onclick="removeItem(${item.productId.product_id})">
                                🗑 Xóa
                            </button>
                        </div>
                    </div>
                </c:forEach>
                
                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <div class="pagination">
                        <c:if test="${currentPage > 1}">
                            <a href="?page=${currentPage - 1}&size=${pageSize}" class="page-link">← Prev</a>
                        </c:if>
                        
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <a href="?page=${p}&size=${pageSize}" 
                               class="page-link ${p == currentPage ? 'active' : ''}">${p}</a>
                        </c:forEach>
                        
                        <c:if test="${currentPage < totalPages}">
                            <a href="?page=${currentPage + 1}&size=${pageSize}" class="page-link">Next →</a>
                        </c:if>
                    </div>
                </c:if>
                
                <!-- Footer Actions -->
                <div class="actions-footer">
                    <a href="${pageContext.request.contextPath}/home" class="btn-large">← Tiếp Tục Mua Sắm</a>
                    <a href="${pageContext.request.contextPath}/products" class="btn-large" style="margin-left: 1rem;">🛍 Duyệt Sản Phẩm</a>
                </div>
                
            </c:when>
            <c:otherwise>
                <!-- Empty Wishlist -->
                <div class="empty-state">
                    <div style="font-size: 4rem; margin-bottom: 1rem;">💔</div>
                    <h2>Danh sách yêu thích của bạn đang trống!</h2>
                    <p>Khám phá các sản phẩm số tuyệt vời và thêm vào danh sách yêu thích để lưu lại.</p>
                    <a href="${pageContext.request.contextPath}/home" class="btn-large">🛍️ Bắt Đầu Mua Sắm</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <script>
        // Simple remove function
        function removeItem(productId) {
            if (confirm('Xóa sản phẩm này khỏi danh sách yêu thích?')) {
                fetch('${pageContext.request.contextPath}/removeFromWishlist', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'productId=' + productId
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Reload page to update wishlist
                        location.reload();
                    } else {
                        alert(data.message || 'Đã xảy ra lỗi khi xóa!');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra. Vui lòng thử lại.');
                });
            }
        }
        
        // Clear all function
        function clearAll() {
            if (confirm('Xóa TẤT CẢ sản phẩm khỏi danh sách yêu thích? Thao tác này không thể hoàn tác.')) {
                fetch('${pageContext.request.contextPath}/clearWishlist', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Reload page to show empty state
                        location.reload();
                    } else {
                        alert(data.message || 'Đã xảy ra lỗi khi xóa!');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra. Vui lòng thử lại.');
                });
            }
        }
    </script>
    
    <!-- Simple Footer -->
    <footer class="bg-dark text-white mt-5 py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-4">
                    <h5>🎮 Gicungco Marketplace</h5>
                    <p>Nền tảng thương mại điện tử đáng tin cậy</p>
                </div>
                <div class="col-md-4">
                    <h5>Liên Kết Nhanh</h5>
                    <ul class="list-unstyled">
                        <li><a href="${pageContext.request.contextPath}/home" class="text-white-50">Trang chủ</a></li>
                        <li><a href="${pageContext.request.contextPath}/products" class="text-white-50">Sản phẩm</a></li>
                        <li><a href="${pageContext.request.contextPath}/about" class="text-white-50">Giới thiệu</a></li>
                    </ul>
                </div>
                <div class="col-md-4">
                    <h5>Liên Hệ</h5>
                    <p class="text-white-50">
                        <i class="fas fa-phone"></i> (+012) 1234 567890<br>
                        <i class="fas fa-envelope"></i> info@gicungco.com
                    </p>
                </div>
            </div>
            <hr class="bg-white">
            <div class="text-center">
                <p class="mb-0">&copy; 2025 Gicungco Marketplace. Bảo lưu mọi quyền.</p>
            </div>
        </div>
    </footer>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
