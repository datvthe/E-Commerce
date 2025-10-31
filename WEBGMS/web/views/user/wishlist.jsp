<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách yêu thích - Gicungco</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    
    <style>
        body {
            background: linear-gradient(135deg, #ff6b35 0%, #f7931e 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        /* Navbar */
        .navbar-custom {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            padding: 1rem 0;
        }
        .navbar-custom .navbar-brand {
            font-size: 1.8rem;
            font-weight: 800;
            background: linear-gradient(135deg, #ff6b35, #f7931e);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .navbar-custom .nav-link {
            color: #333;
            font-weight: 600;
            margin: 0 10px;
            transition: all 0.3s;
        }
        .navbar-custom .nav-link:hover {
            color: #ff6b35;
            transform: translateY(-2px);
        }
        
        /* Header */
        .wishlist-hero {
            background: linear-gradient(135deg, rgba(255,255,255,0.1), rgba(255,255,255,0.05));
            backdrop-filter: blur(20px);
            padding: 50px 0;
            margin: 30px 0;
            border-radius: 20px;
            text-align: center;
            color: white;
            box-shadow: 0 8px 32px rgba(0,0,0,0.2);
        }
        .wishlist-hero h1 {
            font-size: 3rem;
            font-weight: 800;
            margin-bottom: 15px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }
        .wishlist-hero .stats-badge {
            background: rgba(255,255,255,0.2);
            backdrop-filter: blur(10px);
            padding: 15px 40px;
            border-radius: 50px;
            display: inline-block;
            font-size: 1.2rem;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        
        /* Wishlist Cards */
        .wishlist-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        .wishlist-item {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            position: relative;
        }
        .wishlist-item:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 40px rgba(0,0,0,0.2);
        }
        .wishlist-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #ff6b35, #f7931e);
        }
        .product-image-wrapper {
            position: relative;
            overflow: hidden;
            background: #f8f9fa;
            height: 250px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .product-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s;
        }
        .wishlist-item:hover .product-img {
            transform: scale(1.1);
        }
        .remove-btn {
            position: absolute;
            top: 15px;
            right: 15px;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: rgba(220, 53, 69, 0.9);
            border: none;
            color: white;
            font-size: 18px;
            cursor: pointer;
            transition: all 0.3s;
            z-index: 10;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        }
        .remove-btn:hover {
            background: #dc3545;
            transform: scale(1.1) rotate(90deg);
        }
        .product-info {
            padding: 25px;
        }
        .product-category {
            display: inline-block;
            background: linear-gradient(135deg, #ff6b35, #f7931e);
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            margin-bottom: 10px;
        }
        .product-name {
            font-size: 1.3rem;
            font-weight: 700;
            color: #333;
            margin: 10px 0;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .product-price {
            font-size: 1.8rem;
            font-weight: 800;
            background: linear-gradient(135deg, #ff6b35, #f7931e);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin: 15px 0;
        }
        .product-rating {
            color: #ffc107;
            margin-bottom: 15px;
        }
        .added-date {
            color: #6c757d;
            font-size: 0.85rem;
            margin-bottom: 15px;
        }
        .btn-view {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #ff6b35, #f7931e);
            border: none;
            color: white;
            font-weight: 600;
            border-radius: 10px;
            transition: all 0.3s;
        }
        .btn-view:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(255, 107, 53, 0.4);
            color: white;
        }
        
        /* Action Bar */
        .action-bar {
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(10px);
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .btn-clear-all {
            background: linear-gradient(135deg, #ff6b6b, #ee5a6f);
            border: none;
            padding: 10px 25px;
            border-radius: 25px;
            color: white;
            font-weight: 600;
            transition: all 0.3s;
        }
        .btn-clear-all:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(255, 107, 107, 0.4);
        }
        
        /* Empty State */
        .empty-state {
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(10px);
            padding: 80px 40px;
            border-radius: 20px;
            text-align: center;
            box-shadow: 0 8px 32px rgba(0,0,0,0.15);
        }
        .empty-icon {
            font-size: 120px;
            background: linear-gradient(135deg, #ff6b35, #f7931e);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 30px;
            animation: pulse 2s infinite;
        }
        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.5; }
        }
        .btn-explore {
            background: linear-gradient(135deg, #ff6b35, #f7931e);
            border: none;
            padding: 15px 40px;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 50px;
            color: white;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
            box-shadow: 0 6px 20px rgba(255, 107, 53, 0.3);
        }
        .btn-explore:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(255, 107, 53, 0.5);
            color: white;
        }
        
        /* Footer */
        .footer-simple {
            background: rgba(0,0,0,0.3);
            backdrop-filter: blur(10px);
            padding: 20px 0;
            margin-top: 60px;
            text-align: center;
            color: white;
        }
        
        /* Loading animation */
        .fade-in {
            animation: fadeIn 0.5s ease-in;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-custom navbar-expand-lg sticky-top">
        <div class="container">
            <a class="navbar-brand" href="<%= request.getContextPath() %>/home">
                <i class="fas fa-shopping-bag me-2"></i>Gicungco
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/home">
                            <i class="fas fa-home me-1"></i>Trang chủ
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/products">
                            <i class="fas fa-store me-1"></i>Sản phẩm
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="<%= request.getContextPath() %>/wishlist">
                            <i class="fas fa-heart me-1"></i>Yêu thích
                        </a>
                    </li>
                    <c:if test="${not empty sessionScope.user}">
                        <li class="nav-item">
                            <a class="nav-link" href="<%= request.getContextPath() %>/profile">
                                <i class="fas fa-user me-1"></i>${sessionScope.user.full_name}
                            </a>
                        </li>
                    </c:if>
                </ul>
            </div>
        </div>
    </nav>
    
    <!-- Main Content -->
    <div class="container py-4">
        <!-- Hero Header -->
        <div class="wishlist-hero fade-in">
            <h1>
                <i class="fas fa-heart me-3"></i>Danh Sách Yêu Thích
            </h1>
            <div class="stats-badge mt-3">
                <i class="fas fa-boxes me-2"></i>
                <strong>${not empty wishlistItems ? wishlistItems.size() : 0}</strong> sản phẩm
            </div>
        </div>
        
        <c:choose>
            <c:when test="${not empty wishlistItems}">
                <!-- Action Bar -->
                <div class="action-bar fade-in">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h5 class="mb-0">
                                <i class="fas fa-list me-2"></i>
                                ${wishlistItems.size()} sản phẩm đang chờ bạn
                            </h5>
                        </div>
                        <button class="btn btn-clear-all" onclick="clearAll()">
                            <i class="fas fa-trash-alt me-2"></i>Xóa tất cả
                        </button>
                    </div>
                </div>
                
                <!-- Wishlist Grid -->
                <div class="wishlist-grid">
                    <c:forEach var="item" items="${wishlistItems}" varStatus="status">
                        <div class="wishlist-item fade-in" id="item-${item.productId.product_id}" 
                             data-product-id="${item.productId.product_id}"
                             style="animation-delay: ${status.index * 0.1}s">
                            <!-- Remove Button -->
                            <button class="remove-btn" onclick="removeItem(${item.productId.product_id})" 
                                    title="Xóa khỏi yêu thích">
                                <i class="fas fa-times"></i>
                            </button>
                            
                            <!-- Product Image -->
                            <div class="product-image-wrapper">
                                <c:choose>
                                    <c:when test="${not empty item.productId.imageUrl}">
                                        <%-- Kiểm tra nếu là absolute URL (http/https) --%>
                                        <c:choose>
                                            <c:when test="${fn:startsWith(item.productId.imageUrl, 'http://') || fn:startsWith(item.productId.imageUrl, 'https://')}">
                                                <img src="${item.productId.imageUrl}" 
                                                     alt="${item.productId.name}" class="product-img">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}${item.productId.imageUrl}" 
                                                     alt="${item.productId.name}" class="product-img">
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/views/assets/electro/img/product-1.png" 
                                             alt="${item.productId.name}" class="product-img">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            
                            <!-- Product Info -->
                            <div class="product-info">
                                <c:if test="${not empty item.productId.category_name}">
                                    <span class="product-category">
                                        <i class="fas fa-tag me-1"></i>${item.productId.category_name}
                                    </span>
                                </c:if>
                                
                                <h5 class="product-name">${item.productId.name}</h5>
                                
                                <div class="product-rating">
                                    <c:forEach begin="1" end="5" var="i">
                                        <i class="fas fa-star ${i <= item.productId.average_rating ? '' : 'text-muted'}"></i>
                                    </c:forEach>
                                    <span class="text-muted ms-2">(${item.productId.total_reviews})</span>
                                </div>
                                
                                <div class="added-date">
                                    <i class="far fa-calendar-alt me-1"></i>
                                    Đã thêm: <fmt:formatDate value="${item.addedAt}" pattern="dd/MM/yyyy"/>
                                </div>
                                
                                <div class="product-price">
                                    <fmt:formatNumber value="${item.productId.price}" type="currency" 
                                                     currencyCode="VND" pattern="#,##0₫"/>
                                </div>
                                
                                <a href="${pageContext.request.contextPath}/product/${item.productId.slug}" 
                                   class="btn btn-view">
                                    <i class="fas fa-eye me-2"></i>Xem chi tiết
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                
                <!-- Continue Shopping -->
                <div class="text-center mt-5">
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-explore">
                        <i class="fas fa-shopping-cart me-2"></i>Tiếp tục mua sắm
                    </a>
                </div>
                
            </c:when>
            <c:otherwise>
                <!-- Empty State -->
                <div class="empty-state fade-in">
                    <div class="empty-icon">
                        <i class="fas fa-heart-broken"></i>
                    </div>
                    <h2 class="mb-3">Danh sách yêu thích trống</h2>
                    <p class="text-muted mb-4" style="font-size: 1.1rem;">
                        Hãy khám phá và thêm những sản phẩm yêu thích của bạn!
                    </p>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-explore">
                        <i class="fas fa-shopping-bag me-2"></i>Khám phá ngay
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <!-- Footer -->
    <footer class="footer-simple">
        <div class="container">
            <p class="mb-0">
                <i class="fas fa-heart me-2"></i>
                Made with love by Gicungco &copy; 2025
            </p>
        </div>
    </footer>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Remove item with animation
        function removeItem(productId) {
            if (confirm('Bạn có chắc muốn xóa sản phẩm này khỏi danh sách yêu thích?')) {
                const itemElement = document.getElementById('item-' + productId);
                
                // Fade out animation
                itemElement.style.transition = 'all 0.3s ease';
                itemElement.style.opacity = '0';
                itemElement.style.transform = 'scale(0.8)';
                
                setTimeout(() => {
                    fetch('${pageContext.request.contextPath}/removeFromWishlist', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        body: 'productId=' + productId
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            location.reload();
                        } else {
                            alert(data.message || 'Lỗi khi xóa!');
                            itemElement.style.opacity = '1';
                            itemElement.style.transform = 'scale(1)';
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Có lỗi xảy ra!');
                        itemElement.style.opacity = '1';
                        itemElement.style.transform = 'scale(1)';
                    });
                }, 300);
            }
        }
        
        // Clear all with confirmation
        function clearAll() {
            if (confirm('⚠️ Bạn có chắc muốn XÓA TẤT CẢ sản phẩm khỏi danh sách yêu thích?\n\nThao tác này không thể hoàn tác!')) {
                const items = document.querySelectorAll('.wishlist-item');
                
                // Animate all items
                items.forEach((item, index) => {
                    setTimeout(() => {
                        item.style.transition = 'all 0.3s ease';
                        item.style.opacity = '0';
                        item.style.transform = 'scale(0.8)';
                    }, index * 50);
                });
                
                setTimeout(() => {
                    fetch('${pageContext.request.contextPath}/clearWishlist', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'}
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            location.reload();
                        } else {
                            alert(data.message || 'Lỗi khi xóa!');
                            location.reload();
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Có lỗi xảy ra!');
                        location.reload();
                    });
                }, items.length * 50 + 300);
            }
        }
        
        // Add entrance animations
        document.addEventListener('DOMContentLoaded', function() {
            const items = document.querySelectorAll('.wishlist-item');
            items.forEach((item, index) => {
                item.style.animationDelay = (index * 0.1) + 's';
            });
        });
    </script>
    
    <!-- Wishlist Management JavaScript -->
    <script>
        // Set context path and user ID for wishlist.js
        const contextPath = '<%= request.getContextPath() %>';
        <c:if test="${not empty sessionScope.user}">
        const currentUserId = ${sessionScope.user.user_id};
        </c:if>
    </script>
    <script src="<%= request.getContextPath() %>/assets/js/wishlist.js?v=<%= System.currentTimeMillis() %>"></script>
</body>
</html>
