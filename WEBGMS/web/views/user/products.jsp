<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>Danh mục sản phẩm - Gicungco Marketplace</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="Khám phá hàng ngàn sản phẩm chất lượng cao" name="description">

        <!-- Google Web Fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500;600;700&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">

        <!-- Icon Font Stylesheet -->
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Libraries Stylesheet -->
        <link href="<%= request.getContextPath() %>/views/assets/user/lib/animate/animate.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath() %>/views/assets/user/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

        <!-- Customized Bootstrap Stylesheet -->
        <link href="<%= request.getContextPath() %>/views/assets/user/css/bootstrap.min.css" rel="stylesheet">

        <!-- Template Stylesheet -->
        <link href="<%= request.getContextPath() %>/views/assets/user/css/style.css" rel="stylesheet">
        
        <!-- Products Page Styles -->
        <style>
            .product-card {
                border: 1px solid #eee;
                border-radius: 10px;
                overflow: hidden;
                transition: all 0.3s ease;
                height: 100%;
                background: white;
            }
            
            .product-card:hover {
                box-shadow: 0 5px 20px rgba(0,0,0,0.1);
                transform: translateY(-5px);
            }
            
            .product-image {
                width: 100%;
                height: 200px;
                object-fit: cover;
                background: #f8f9fa;
            }
            
            .product-card-body {
                padding: 15px;
            }
            
            .product-title {
                font-size: 1rem;
                font-weight: 600;
                margin-bottom: 10px;
                color: #333;
                text-decoration: none;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
            }
            
            .product-title:hover {
                color: #007bff;
            }
            
            .product-price {
                font-size: 1.1rem;
                font-weight: 600;
                color: #e74c3c;
                margin-bottom: 10px;
            }
            
            .product-rating {
                display: flex;
                align-items: center;
                margin-bottom: 15px;
            }
            
            .stars {
                color: #ffc107;
                font-size: 0.9rem;
                margin-right: 5px;
            }
            
            .rating-text {
                color: #666;
                font-size: 0.8rem;
            }
            
            .product-actions {
                display: flex;
                gap: 10px;
            }
            
            .btn-product {
                flex: 1;
                padding: 8px 12px;
                border-radius: 6px;
                font-size: 0.9rem;
                text-decoration: none;
                text-align: center;
                transition: all 0.3s ease;
                border: none;
                cursor: pointer;
            }
            
            .btn-detail {
                background: #007bff;
                color: white;
            }
            
            .btn-detail:hover {
                background: #0056b3;
                color: white;
            }
            
            .btn-cart {
                background: #28a745;
                color: white;
            }
            
            .btn-cart:hover {
                background: #1e7e34;
                color: white;
            }
            
            .filters-section {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 10px;
                margin-bottom: 30px;
            }
            
            .pagination {
                justify-content: center;
                margin-top: 40px;
            }
            
            .page-link {
                color: #007bff;
                border: 1px solid #dee2e6;
                padding: 0.5rem 0.75rem;
            }
            
            .page-link:hover {
                color: #0056b3;
                background-color: #e9ecef;
                border-color: #dee2e6;
            }
            
            .page-item.active .page-link {
                background-color: #007bff;
                border-color: #007bff;
            }
            
            .breadcrumb {
                background: transparent;
                padding: 0;
                margin-bottom: 20px;
            }
            
            .breadcrumb-item + .breadcrumb-item::before {
                content: ">";
                color: #6c757d;
            }
        </style>
    </head>

    <body>
        <!-- Header -->
        <jsp:include page="/views/component/header.jsp" />

        <!-- Breadcrumb -->
        <div class="container-fluid py-3 bg-light">
            <div class="container">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="<%= request.getContextPath() %>/home">Trang chủ</a></li>
                        <li class="breadcrumb-item active">Danh mục sản phẩm</li>
                    </ol>
                </nav>
            </div>
        </div>

        <!-- Products Section -->
        <div class="container-fluid py-5">
            <div class="container">
                <!-- Page Header -->
                <div class="row mb-4">
                    <div class="col-12">
                        <h1 class="h2 mb-3">Danh mục sản phẩm</h1>
                        <p class="text-muted">Khám phá hàng ngàn sản phẩm chất lượng cao từ các nhà bán uy tín</p>
                    </div>
                </div>

                <!-- Filters Section -->
                <div class="filters-section">
                    <div class="row align-items-center">
                        <div class="col-md-3">
                            <label class="form-label fw-bold">Tìm kiếm:</label>
                            <input type="text" class="form-control" id="searchInput" placeholder="Nhập tên sản phẩm..." value="${search}">
                        </div>
                        <div class="col-md-2">
                            <label class="form-label fw-bold">Danh mục:</label>
                            <select class="form-select" id="categorySelect">
                                <option value="">Tất cả danh mục</option>
                                <option value="electronics" ${category == 'electronics' ? 'selected' : ''}>Điện tử</option>
                                <option value="fashion" ${category == 'fashion' ? 'selected' : ''}>Thời trang</option>
                                <option value="home" ${category == 'home' ? 'selected' : ''}>Gia dụng</option>
                                <option value="sports" ${category == 'sports' ? 'selected' : ''}>Thể thao</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label fw-bold">Sắp xếp:</label>
                            <select class="form-select" id="sortSelect">
                                <option value="">Mặc định</option>
                                <option value="priceAsc" ${sort == 'priceAsc' ? 'selected' : ''}>Giá tăng dần</option>
                                <option value="priceDesc" ${sort == 'priceDesc' ? 'selected' : ''}>Giá giảm dần</option>
                                <option value="rating" ${sort == 'rating' ? 'selected' : ''}>Đánh giá cao</option>
                                <option value="newest" ${sort == 'newest' ? 'selected' : ''}>Mới nhất</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label fw-bold">Hiển thị:</label>
                            <select class="form-select" id="pageSizeSelect">
                                <option value="12" ${pageSize == 12 ? 'selected' : ''}>12 sản phẩm</option>
                                <option value="24" ${pageSize == 24 ? 'selected' : ''}>24 sản phẩm</option>
                                <option value="48" ${pageSize == 48 ? 'selected' : ''}>48 sản phẩm</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-bold">&nbsp;</label>
                            <div class="d-flex gap-2">
                                <button class="btn btn-primary" onclick="applyFilters()">
                                    <i class="fas fa-search"></i> Tìm kiếm
                                </button>
                                <button class="btn btn-outline-secondary" onclick="clearFilters()">
                                    <i class="fas fa-times"></i> Xóa bộ lọc
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Products Grid -->
                <div class="row g-4">
                    <c:choose>
                        <c:when test="${not empty products}">
                            <c:forEach var="product" items="${products}">
                                <div class="col-sm-6 col-md-4 col-lg-3">
                                    <div class="product-card">
                                        <a href="<%= request.getContextPath() %>/product/${product.slug}">
                                            <img src="<%= request.getContextPath() %>/views/assets/user/img/product-1.png" 
                                                 alt="${product.name}" class="product-image">
                                        </a>
                                        <div class="product-card-body">
                                            <a href="<%= request.getContextPath() %>/product/${product.slug}" class="product-title">
                                                ${product.name}
                                            </a>
                                            <div class="product-price">
                                                ${product.price} ${product.currency}
                                            </div>
                                            <div class="product-rating">
                                                <div class="stars">
                                                    <c:forEach begin="1" end="5" var="i">
                                                        <i class="fas fa-star ${i <= product.average_rating ? '' : 'far'}"></i>
                                                    </c:forEach>
                                                </div>
                                                <span class="rating-text">(${product.total_reviews})</span>
                                            </div>
                                            <div class="product-actions">
                                                <a href="<%= request.getContextPath() %>/product/${product.slug}" 
                                                   class="btn-product btn-detail">
                                                    <i class="fas fa-eye"></i> Chi tiết
                                                </a>
                                                <button class="btn-product btn-cart" onclick="addToCart(${product.product_id})">
                                                    <i class="fas fa-shopping-cart"></i> Giỏ hàng
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col-12 text-center py-5">
                                <i class="fas fa-search fa-3x text-muted mb-3"></i>
                                <h4 class="text-muted">Không tìm thấy sản phẩm nào</h4>
                                <p class="text-muted">Hãy thử thay đổi bộ lọc hoặc từ khóa tìm kiếm</p>
                                <button class="btn btn-primary" onclick="clearFilters()">Xóa bộ lọc</button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Products pagination">
                        <ul class="pagination">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage - 1}&category=${category}&sort=${sort}&search=${search}">
                                        <i class="fas fa-chevron-left"></i> Trước
                                    </a>
                                </li>
                            </c:if>
                            
                            <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                <c:choose>
                                    <c:when test="${pageNum == currentPage}">
                                        <li class="page-item active">
                                            <span class="page-link">${pageNum}</span>
                                        </li>
                                    </c:when>
                                    <c:otherwise>
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${pageNum}&category=${category}&sort=${sort}&search=${search}">
                                                ${pageNum}
                                            </a>
                                        </li>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                            
                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage + 1}&category=${category}&sort=${sort}&search=${search}">
                                        Sau <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>

        <!-- Footer -->
        <jsp:include page="/views/component/footer.jsp" />

        <!-- JavaScript Libraries -->
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/user/lib/easing/easing.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/user/lib/waypoints/waypoints.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/user/lib/owlcarousel/owl.carousel.min.js"></script>

        <!-- Template Javascript -->
        <script src="<%= request.getContextPath() %>/views/assets/user/js/main.js"></script>

        <!-- Products Page JavaScript -->
        <script>
            // Apply filters
            function applyFilters() {
                const search = document.getElementById('searchInput').value;
                const category = document.getElementById('categorySelect').value;
                const sort = document.getElementById('sortSelect').value;
                const pageSize = document.getElementById('pageSizeSelect').value;
                
                const params = new URLSearchParams();
                if (search) params.append('search', search);
                if (category) params.append('category', category);
                if (sort) params.append('sort', sort);
                if (pageSize) params.append('pageSize', pageSize);
                
                window.location.href = '?' + params.toString();
            }
            
            // Clear filters
            function clearFilters() {
                window.location.href = '<%= request.getContextPath() %>/products';
            }
            
            // Add to cart
            function addToCart(productId) {
                fetch('<%= request.getContextPath() %>/cart/add', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: `action=add&productId=${productId}&quantity=1`
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Show success message
                        showNotification(data.message, 'success');
                    } else {
                        showNotification(data.message, 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showNotification('Có lỗi xảy ra khi thêm vào giỏ hàng', 'error');
                });
            }
            
            // Show notification
            function showNotification(message, type) {
                const alertClass = type === 'success' ? 'alert-success' : 'alert-danger';
                const notification = `
                    <div class="alert ${alertClass} alert-dismissible fade show position-fixed" 
                         style="top: 20px; right: 20px; z-index: 9999;">
                        ${message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                `;
                document.body.insertAdjacentHTML('beforeend', notification);
                
                // Auto remove after 3 seconds
                setTimeout(() => {
                    const alert = document.querySelector('.alert');
                    if (alert) {
                        alert.remove();
                    }
                }, 3000);
            }
            
            // Enter key search
            document.getElementById('searchInput').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    applyFilters();
                }
            });
        </script>
    </body>
</html>
