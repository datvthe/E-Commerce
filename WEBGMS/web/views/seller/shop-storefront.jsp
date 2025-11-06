<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tson - Cửa hàng | Gicungco Marketplace</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: #f8f9fa; }
        .shop-header { 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 3rem 0;
            margin-bottom: 2rem;
        }
        .shop-avatar {
            width: 100px;
            height: 100px;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            color: #667eea;
            font-weight: bold;
            border: 4px solid rgba(255,255,255,0.3);
        }
        .shop-stats { 
            display: flex; 
            gap: 2rem; 
            margin-top: 1rem;
        }
        .stat-item { 
            text-align: center;
        }
        .stat-item .number {
            font-size: 1.5rem;
            font-weight: bold;
        }
        .stat-item .label {
            font-size: 0.875rem;
            opacity: 0.9;
        }
        .seller-info-box {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            margin-bottom: 2rem;
        }
        .info-row {
            padding: 0.75rem 0;
            border-bottom: 1px solid #e9ecef;
        }
        .info-row:last-child {
            border-bottom: none;
        }
        .info-label {
            font-weight: 600;
            color: #6c757d;
            min-width: 150px;
            display: inline-block;
        }
        .product-card {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            transition: transform 0.2s, box-shadow 0.2s;
            height: 100%;
            display: flex;
            flex-direction: column;
        }
        .product-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        .product-img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            background: #f8f9fa;
        }
        .product-body {
            padding: 1rem;
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        .product-title {
            font-weight: 600;
            margin-bottom: 0.5rem;
            font-size: 0.95rem;
            line-height: 1.4;
            height: 2.8rem;
            overflow: hidden;
        }
        .product-price {
            color: #d63384;
            font-weight: bold;
            font-size: 1.1rem;
            margin-top: auto;
        }
        .badge-category {
            font-size: 0.75rem;
            padding: 0.35rem 0.65rem;
        }
        .product-img-wrapper {
            position: relative;
            width: 100%;
            height: 200px;
            overflow: hidden;
        }
        .wishlist-btn {
            position: absolute;
            top: 10px;
            left: 10px;
            background: white;
            border: none;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            cursor: pointer;
            font-size: 18px;
            transition: all 0.3s ease;
            z-index: 10;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .wishlist-btn:hover {
            transform: scale(1.1);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }
        .wishlist-btn.in-wishlist {
            color: #dc3545;
        }
        .wishlist-btn.in-wishlist i {
            color: #dc3545;
        }
    </style>
</head>
<body>
    <!-- Shop Header -->
    <div class="shop-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-auto">
                    <div class="shop-avatar">T</div>
                </div>
                <div class="col">
                    <h1 class="mb-1">${seller.shopName}</h1>
                    <p class="mb-0 opacity-75">${seller.shopDescription}</p>
                    <div class="shop-stats">
                        <div class="stat-item">
                            <div class="number">${totalProducts}</div>
                            <div class="label">Sản phẩm</div>
                        </div>
                        <div class="stat-item">
                            <div class="number">${totalSold}</div>
                            <div class="label">Đã bán</div>
                        </div>
                        <div class="stat-item">
                            <div class="number">${rating}</div>
                            <div class="label">Đánh giá</div>
                        </div>
                    </div>
                </div>
                <div class="col-auto">
                    <button class="btn btn-light btn-lg me-2">
                        <i class="fas fa-heart me-2"></i>Theo dõi
                    </button>
                    <button class="btn btn-outline-light btn-lg">
                        <i class="fas fa-comment-dots me-2"></i>Chat
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="container pb-5">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3">
                <!-- Seller Info -->
                <div class="seller-info-box">
                    <h5 class="mb-3"><i class="fas fa-store me-2 text-primary"></i>Thông tin người bán</h5>
                    
                    <div class="info-row">
                        <div class="info-label">🏪 Tên cửa hàng</div>
                        <div class="fw-bold">${seller.shopName}</div>
                    </div>
                    
                    <div class="info-row">
                        <div class="info-label">👤 Tên người bán</div>
                        <div>${seller.fullName}</div>
                    </div>
                    
                    <div class="info-row">
                        <div class="info-label">🏷️ Loại sản phẩm</div>
                        <div>
                            <c:forTokens var="category" items="${seller.mainCategory}" delims=",">
                                <span class="badge bg-primary badge-category">${category.trim()}</span>
                            </c:forTokens>
                        </div>
                    </div>
                    
                    <div class="info-row">
                        <div class="info-label">💬 Mô tả shop</div>
                        <div class="text-muted small">${seller.shopDescription}</div>
                    </div>
                </div>

                <!-- Categories Filter -->
                <div class="seller-info-box">
                    <h6 class="mb-3">Danh mục sản phẩm</h6>
                    <div class="list-group list-group-flush">
                        <a href="?sellerId=${seller.sellerId}" 
                           class="list-group-item list-group-item-action border-0 px-0 ${empty selectedCategory or selectedCategory == 0 ? 'active' : ''}">
                            Tất cả <span class="badge ${empty selectedCategory or selectedCategory == 0 ? 'bg-primary' : 'bg-secondary'} float-end">${totalProducts}</span>
                        </a>
                        <c:forEach var="cat" items="${allCategories}">
                            <c:if test="${categoryProductCount[cat.category_id] != null and categoryProductCount[cat.category_id] > 0}">
                                <a href="?sellerId=${seller.sellerId}&category=${cat.category_id}" 
                                   class="list-group-item list-group-item-action border-0 px-0 ${selectedCategory == cat.category_id ? 'active' : ''}">
                                    ${cat.name} <span class="badge ${selectedCategory == cat.category_id ? 'bg-primary' : 'bg-secondary'} float-end">${categoryProductCount[cat.category_id]}</span>
                                </a>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <!-- Products Grid -->
            <div class="col-md-9">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h4 class="mb-0">Sản phẩm của shop</h4>
                    <select class="form-select w-auto">
                        <option>Mới nhất</option>
                        <option>Bán chạy</option>
                        <option>Giá thấp</option>
                        <option>Giá cao</option>
                    </select>
                </div>

                <div class="row g-3">
                    <c:choose>
                        <c:when test="${not empty products}">
                            <c:forEach var="product" items="${products}">
                                <div class="col-md-4 col-sm-6">
                                    <div class="product-card">
                                        <!-- Get primary image or fallback -->
                                        <c:set var="primaryImage" value="" />
                                        <c:forEach var="img" items="${product.productImages}">
                                            <c:if test="${img.is_primary}">
                                                <c:set var="primaryImage" value="${img.url}" />
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${empty primaryImage}">
                                            <c:set var="primaryImage" value="https://via.placeholder.com/300x200/667eea/ffffff?text=Product" />
                                        </c:if>
                                        
                                        <div class="product-img-wrapper">
                                            <a href="<%= request.getContextPath() %>/product/${product.product_id}">
                                                <img src="${primaryImage}" class="product-img" alt="${product.name}">
                                            </a>
                                            
                                            <!-- Wishlist Button -->
                                            <c:if test="${not empty sessionScope.user}">
                                                <button class="wishlist-btn" 
                                                        data-product-id="${product.product_id}"
                                                        onclick="event.preventDefault(); toggleWishlist(${product.product_id}, this)"
                                                        title="Thêm vào yêu thích">
                                                    <i class="far fa-heart"></i>
                                                </button>
                                            </c:if>
                                        </div>
                                        
                                        <div class="product-body">
                                            <a href="<%= request.getContextPath() %>/product/${product.product_id}" class="product-title">
                                                ${product.name}
                                            </a>
                                            
                                            <div class="mb-2">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <i class="fas fa-star ${i <= product.average_rating ? 'text-warning' : 'far text-warning'}"></i>
                                                </c:forEach>
                                                <span class="text-muted small ms-1">(${product.total_reviews})</span>
                                            </div>
                                            
                                            <div class="product-price">
                                                <fmt:formatNumber value="${product.price}" pattern="#,###"/>₫
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        
                        <c:otherwise>
                            <div class="col-12 text-center py-5">
                                <i class="fas fa-box-open fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">Shop chưa có sản phẩm nào</h5>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <nav class="mt-4">
                        <ul class="pagination justify-content-center">
                            <!-- Previous -->
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="?sellerId=${seller.sellerId}&page=${currentPage - 1}${not empty selectedCategory and selectedCategory > 0 ? '&category='.concat(selectedCategory) : ''}">«</a>
                                </li>
                            </c:if>
                            
                            <!-- Page Numbers -->
                            <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?sellerId=${seller.sellerId}&page=${pageNum}${not empty selectedCategory and selectedCategory > 0 ? '&category='.concat(selectedCategory) : ''}">${pageNum}</a>
                                </li>
                            </c:forEach>
                            
                            <!-- Next -->
                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="?sellerId=${seller.sellerId}&page=${currentPage + 1}${not empty selectedCategory and selectedCategory > 0 ? '&category='.concat(selectedCategory) : ''}">»</a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Wishlist JavaScript -->
    <script>
        // Set context path and user ID for wishlist.js
        const contextPath = '<%= request.getContextPath() %>';
        <c:if test="${not empty sessionScope.user}">
        const currentUserId = ${sessionScope.user.user_id};
        // Store in sessionStorage for wishlist.js
        sessionStorage.setItem('userId', ${sessionScope.user.user_id});
        </c:if>
    </script>
    <script src="<%= request.getContextPath() %>/assets/js/wishlist.js"></script>
</body>
</html>

