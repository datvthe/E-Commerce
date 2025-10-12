<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>${product.name} - Gicungco Marketplace</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="${product.description}" name="description">

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
        
        <!-- Product Detail Styles -->
        <style>
            .product-image-carousel {
                position: relative;
                overflow: hidden;
                border-radius: 10px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }
            
            .product-image-carousel img {
                width: 100%;
                height: 400px;
                object-fit: cover;
                cursor: zoom-in;
                transition: transform 0.3s ease;
            }
            
            .product-image-carousel img:hover {
                transform: scale(1.05);
            }
            
            .thumbnail-container {
                display: flex;
                gap: 10px;
                margin-top: 15px;
                overflow-x: auto;
                padding: 10px 0;
            }
            
            .thumbnail {
                width: 80px;
                height: 80px;
                object-fit: cover;
                border-radius: 8px;
                cursor: pointer;
                border: 2px solid transparent;
                transition: all 0.3s ease;
            }
            
            .thumbnail.active {
                border-color: #007bff;
            }
            
            .product-info {
                padding: 20px;
            }
            
            .product-title {
                font-size: 2rem;
                font-weight: 700;
                color: #333;
                margin-bottom: 15px;
            }
            
            .product-price {
                font-size: 1.8rem;
                font-weight: 600;
                color: #e74c3c;
                margin-bottom: 20px;
            }
            
            .product-rating {
                display: flex;
                align-items: center;
                margin-bottom: 20px;
            }
            
            .stars {
                color: #ffc107;
                font-size: 1.2rem;
                margin-right: 10px;
            }
            
            .rating-text {
                color: #666;
                font-size: 0.9rem;
            }
            
            .quantity-selector {
                display: flex;
                align-items: center;
                margin-bottom: 20px;
            }
            
            .quantity-input {
                width: 80px;
                text-align: center;
                border: 1px solid #ddd;
                border-radius: 5px;
                padding: 8px;
                margin: 0 10px;
            }
            
            .btn-quantity {
                width: 35px;
                height: 35px;
                border: 1px solid #ddd;
                background: #f8f9fa;
                border-radius: 5px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: all 0.3s ease;
            }
            
            .btn-quantity:hover {
                background: #e9ecef;
            }
            
            .action-buttons {
                display: flex;
                gap: 15px;
                margin-bottom: 30px;
            }
            
            .btn-action {
                flex: 1;
                padding: 12px 20px;
                border-radius: 8px;
                font-weight: 600;
                text-decoration: none;
                text-align: center;
                transition: all 0.3s ease;
                border: none;
                cursor: pointer;
            }
            
            .btn-add-cart {
                background: #007bff;
                color: white;
            }
            
            .btn-add-cart:hover {
                background: #0056b3;
                color: white;
            }
            
            .btn-buy-now {
                background: #28a745;
                color: white;
            }
            
            .btn-buy-now:hover {
                background: #1e7e34;
                color: white;
            }
            
            .btn-wishlist {
                background: #6c757d;
                color: white;
                width: 50px;
                flex: none;
            }
            
            .btn-wishlist:hover {
                background: #545b62;
                color: white;
            }
            
            .btn-wishlist.in-wishlist {
                background: #dc3545;
            }
            
            .btn-wishlist.in-wishlist:hover {
                background: #c82333;
            }
            
            .product-tabs {
                margin-top: 40px;
            }
            
            .tab-content {
                padding: 20px 0;
            }
            
            .review-item {
                border-bottom: 1px solid #eee;
                padding: 20px 0;
            }
            
            .review-header {
                display: flex;
                align-items: center;
                margin-bottom: 10px;
            }
            
            .reviewer-avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                margin-right: 15px;
            }
            
            .reviewer-name {
                font-weight: 600;
                margin-right: 15px;
            }
            
            .review-rating {
                color: #ffc107;
            }
            
            .review-date {
                color: #666;
                font-size: 0.9rem;
                margin-left: auto;
            }
            
            .similar-products {
                margin-top: 50px;
            }
            
            .product-card {
                border: 1px solid #eee;
                border-radius: 10px;
                overflow: hidden;
                transition: all 0.3s ease;
                height: 100%;
            }
            
            .product-card:hover {
                box-shadow: 0 5px 20px rgba(0,0,0,0.1);
                transform: translateY(-5px);
            }
            
            .product-card img {
                width: 100%;
                height: 200px;
                object-fit: cover;
            }
            
            .product-card-body {
                padding: 15px;
            }
            
            .product-card-title {
                font-size: 1rem;
                font-weight: 600;
                margin-bottom: 10px;
                color: #333;
                text-decoration: none;
            }
            
            .product-card-price {
                font-size: 1.1rem;
                font-weight: 600;
                color: #e74c3c;
            }
            
            .stock-info {
                margin-bottom: 20px;
            }
            
            .stock-available {
                color: #28a745;
                font-weight: 600;
            }
            
            .stock-low {
                color: #ffc107;
                font-weight: 600;
            }
            
            .stock-out {
                color: #dc3545;
                font-weight: 600;
            }
        </style>
    </head>

    <body>
        <!-- Header -->
        <jsp:include page="/views/component/header.jsp" />

        <!-- Product Detail Start -->
        <div class="container-fluid py-5">
            <div class="container">
                <div class="row">
                    <!-- Product Images -->
                    <div class="col-lg-6">
                        <div class="product-image-carousel">
                            <c:choose>
                                <c:when test="${not empty images}">
                                    <img id="mainImage" src="${images[0].url}" alt="${images[0].alt_text}" class="img-fluid">
                                </c:when>
                                <c:otherwise>
                                    <img id="mainImage" src="<%= request.getContextPath() %>/views/assets/user/img/product-1.png" alt="No image available" class="img-fluid">
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <!-- Thumbnails -->
                        <c:if test="${not empty images}">
                            <div class="thumbnail-container">
                                <c:forEach var="image" items="${images}" varStatus="status">
                                    <img src="${image.url}" alt="${image.alt_text}" 
                                         class="thumbnail ${status.index == 0 ? 'active' : ''}" 
                                         onclick="changeMainImage('${image.url}', '${image.alt_text}', this)">
                                </c:forEach>
                            </div>
                        </c:if>
                    </div>

                    <!-- Product Information -->
                    <div class="col-lg-6">
                        <div class="product-info">
                            <h1 class="product-title">${product.name}</h1>
                            
                            <div class="product-price">
                                ${product.price} ${product.currency}
                            </div>
                            
                            <div class="product-rating">
                                <div class="stars">
                                    <c:forEach begin="1" end="5" var="i">
                                        <i class="fas fa-star ${i <= product.average_rating ? '' : 'far'}"></i>
                                    </c:forEach>
                                </div>
                                <span class="rating-text">
                                    ${product.average_rating} (${product.total_reviews} đánh giá)
                                </span>
                            </div>
                            
                            <!-- Stock Information -->
                            <div class="stock-info">
                                <c:choose>
                                    <c:when test="${availableStock > 10}">
                                        <span class="stock-available">
                                            <i class="fas fa-check-circle"></i> Còn hàng (${availableStock} sản phẩm)
                                        </span>
                                    </c:when>
                                    <c:when test="${availableStock > 0}">
                                        <span class="stock-low">
                                            <i class="fas fa-exclamation-triangle"></i> Sắp hết hàng (${availableStock} sản phẩm)
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="stock-out">
                                            <i class="fas fa-times-circle"></i> Hết hàng
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            
                            <!-- Quantity Selector -->
                            <div class="quantity-selector">
                                <label>Số lượng:</label>
                                <button class="btn-quantity" onclick="decreaseQuantity()">-</button>
                                <input type="number" id="quantity" class="quantity-input" value="1" min="1" max="${availableStock}">
                                <button class="btn-quantity" onclick="increaseQuantity()">+</button>
                            </div>
                            
                            <!-- Action Buttons -->
                            <div class="action-buttons">
                                <!-- Cart and Buy Now removed -->
                                <button class="btn-action btn-wishlist ${isInWishlist ? 'in-wishlist' : ''}" 
                                        onclick="toggleWishlist()" id="wishlistBtn">
                                    <i class="fas fa-heart"></i>
                                </button>
                            </div>
                            
                            <!-- Seller Information -->
                            <c:if test="${not empty product.seller_id}">
                                <div class="seller-info mt-4 p-3" style="background: #f8f9fa; border-radius: 8px;">
                                    <h6><i class="fas fa-store"></i> Thông tin người bán</h6>
                                    <p class="mb-1"><strong>Tên:</strong> ${product.seller_id.full_name}</p>
                                    <p class="mb-0"><strong>Email:</strong> ${product.seller_id.email}</p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- Product Tabs -->
                <div class="product-tabs">
                    <ul class="nav nav-tabs" id="productTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="description-tab" data-bs-toggle="tab" 
                                    data-bs-target="#description" type="button" role="tab">
                                Mô tả sản phẩm
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="reviews-tab" data-bs-toggle="tab" 
                                    data-bs-target="#reviews" type="button" role="tab">
                                Đánh giá (${product.total_reviews})
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="policies-tab" data-bs-toggle="tab" 
                                    data-bs-target="#policies" type="button" role="tab">
                                Chính sách
                            </button>
                        </li>
                    </ul>
                    
                    <div class="tab-content" id="productTabsContent">
                        <!-- Description Tab -->
                        <div class="tab-pane fade show active" id="description" role="tabpanel">
                            <div class="p-4">
                                <h5>Mô tả chi tiết</h5>
                                <div class="product-description">
                                    ${product.description}
                                </div>
                            </div>
                        </div>
                        
                        <!-- Reviews Tab -->
                        <div class="tab-pane fade" id="reviews" role="tabpanel">
                            <div class="p-4">
                                <h5>Đánh giá sản phẩm</h5>
                                
                                <!-- Rating Summary -->
                                <div class="row mb-4">
                                    <div class="col-md-4">
                                        <div class="text-center">
                                            <h2>${product.average_rating}</h2>
                                            <div class="stars mb-2">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <i class="fas fa-star ${i <= product.average_rating ? '' : 'far'}"></i>
                                                </c:forEach>
                                            </div>
                                            <p>Dựa trên ${product.total_reviews} đánh giá</p>
                                        </div>
                                    </div>
                                    <div class="col-md-8">
                                        <c:forEach begin="5" end="1" step="-1" var="rating">
                                            <div class="d-flex align-items-center mb-2">
                                                <span class="me-2">${rating} <i class="fas fa-star text-warning"></i></span>
                                                <div class="progress flex-grow-1 me-2" style="height: 8px;">
                                                    <div class="progress-bar" style="width: ${ratingDistribution[rating-1] * 100 / product.total_reviews}%"></div>
                                                </div>
                                                <span class="text-muted">${ratingDistribution[rating-1]}</span>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                                
                                <!-- Reviews List -->
                                <div class="reviews-list">
                                    <c:choose>
                                        <c:when test="${not empty reviews}">
                                            <c:forEach var="review" items="${reviews}">
                                                <div class="review-item">
                                                    <div class="review-header">
                                                        <img src="${review.buyer_id.avatar_url != null ? review.buyer_id.avatar_url : '/views/assets/user/img/avatar.jpg'}" 
                                                             alt="Avatar" class="reviewer-avatar">
                                                        <span class="reviewer-name">${review.buyer_id.full_name}</span>
                                                        <div class="review-rating">
                                                            <c:forEach begin="1" end="5" var="i">
                                                                <i class="fas fa-star ${i <= review.rating ? '' : 'far'}"></i>
                                                            </c:forEach>
                                                        </div>
                                                        <span class="review-date">${review.createdAt}</span>
                                                    </div>
                                                    <p class="mb-0">${review.comment}</p>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-muted">Chưa có đánh giá nào cho sản phẩm này.</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <!-- Add Review Form -->
                                <c:if test="${not empty sessionScope.user}">
                                    <div class="mt-4 p-3" style="background: #f8f9fa; border-radius: 8px;">
                                        <h6>Viết đánh giá</h6>
                                        <form id="reviewForm">
                                            <div class="mb-3">
                                                <label class="form-label">Đánh giá</label>
                                                <div class="rating-input">
                                                    <c:forEach begin="1" end="5" var="i">
                                                        <i class="fas fa-star rating-star" data-rating="${i}" style="cursor: pointer; color: #ddd;"></i>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label">Nhận xét</label>
                                                <textarea class="form-control" id="reviewComment" rows="3" required></textarea>
                                            </div>
                                            <button type="submit" class="btn btn-primary">Gửi đánh giá</button>
                                        </form>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                        
                        <!-- Policies Tab -->
                        <div class="tab-pane fade" id="policies" role="tabpanel">
                            <div class="p-4">
                                <h5>Chính sách</h5>
                                <div class="row">
                                    <div class="col-md-4">
                                        <h6><i class="fas fa-truck"></i> Vận chuyển</h6>
                                        <ul>
                                            <li>Miễn phí vận chuyển cho đơn hàng từ 500.000đ</li>
                                            <li>Giao hàng trong 1-3 ngày làm việc</li>
                                            <li>Hỗ trợ giao hàng tận nơi</li>
                                        </ul>
                                    </div>
                                    <div class="col-md-4">
                                        <h6><i class="fas fa-undo"></i> Đổi trả</h6>
                                        <ul>
                                            <li>Đổi trả trong 7 ngày</li>
                                            <li>Sản phẩm phải còn nguyên vẹn</li>
                                            <li>Miễn phí đổi trả</li>
                                        </ul>
                                    </div>
                                    <div class="col-md-4">
                                        <h6><i class="fas fa-shield-alt"></i> Bảo hành</h6>
                                        <ul>
                                            <li>Bảo hành 12 tháng</li>
                                            <li>Hỗ trợ kỹ thuật 24/7</li>
                                            <li>Đổi mới nếu lỗi từ nhà sản xuất</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Similar Products -->
                <c:if test="${not empty similarProducts}">
                    <div class="similar-products">
                        <h4 class="mb-4">Sản phẩm tương tự</h4>
                        <div class="row">
                            <c:forEach var="similarProduct" items="${similarProducts}">
                                <div class="col-lg-2 col-md-4 col-sm-6 mb-4">
                                    <div class="product-card">
                                        <a href="<%= request.getContextPath() %>/product/${similarProduct.slug}">
                                            <img src="<%= request.getContextPath() %>/views/assets/user/img/product-1.png" alt="${similarProduct.name}">
                                        </a>
                                        <div class="product-card-body">
                                            <a href="<%= request.getContextPath() %>/product/${similarProduct.slug}" class="product-card-title">
                                                ${similarProduct.name}
                                            </a>
                                            <div class="product-card-price">
                                                ${similarProduct.price} ${similarProduct.currency}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
        <!-- Product Detail End -->

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

        <!-- Product Detail JavaScript -->
        <script>
            let selectedRating = 0;
            const productId = ${product.product_id};
            const maxQuantity = ${availableStock};

            // Image carousel functionality
            function changeMainImage(src, alt, element) {
                document.getElementById('mainImage').src = src;
                document.getElementById('mainImage').alt = alt;
                
                // Update active thumbnail
                document.querySelectorAll('.thumbnail').forEach(thumb => thumb.classList.remove('active'));
                element.classList.add('active');
            }

            // Quantity selector
            function increaseQuantity() {
                const quantityInput = document.getElementById('quantity');
                let currentQuantity = parseInt(quantityInput.value);
                if (currentQuantity < maxQuantity) {
                    quantityInput.value = currentQuantity + 1;
                }
            }

            function decreaseQuantity() {
                const quantityInput = document.getElementById('quantity');
                let currentQuantity = parseInt(quantityInput.value);
                if (currentQuantity > 1) {
                    quantityInput.value = currentQuantity - 1;
                }
            }

            // Cart / Buy Now removed

            // Toggle wishlist
            function toggleWishlist() {
                const wishlistBtn = document.getElementById('wishlistBtn');
                const isInWishlist = wishlistBtn.classList.contains('in-wishlist');
                
                fetch('<%= request.getContextPath() %>/wishlist/toggle', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: `action=toggle&productId=${productId}`
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        if (isInWishlist) {
                            wishlistBtn.classList.remove('in-wishlist');
                        } else {
                            wishlistBtn.classList.add('in-wishlist');
                        }
                        alert(data.message);
                    } else {
                        alert(data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi cập nhật wishlist');
                });
            }

            // Rating stars for review
            document.querySelectorAll('.rating-star').forEach(star => {
                star.addEventListener('click', function() {
                    selectedRating = parseInt(this.dataset.rating);
                    document.querySelectorAll('.rating-star').forEach((s, index) => {
                        if (index < selectedRating) {
                            s.style.color = '#ffc107';
                        } else {
                            s.style.color = '#ddd';
                        }
                    });
                });
            });

            // Review form submission
            document.getElementById('reviewForm').addEventListener('submit', function(e) {
                e.preventDefault();
                
                if (selectedRating === 0) {
                    alert('Vui lòng chọn đánh giá');
                    return;
                }
                
                const comment = document.getElementById('reviewComment').value;
                
                fetch('<%= request.getContextPath() %>/review/add', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: `action=add&productId=${productId}&rating=${selectedRating}&comment=${encodeURIComponent(comment)}`
                })
                .then(response => response.json())
                .then(data => {
                    alert(data.message);
                    if (data.success) {
                        document.getElementById('reviewForm').reset();
                        selectedRating = 0;
                        document.querySelectorAll('.rating-star').forEach(star => {
                            star.style.color = '#ddd';
                        });
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi gửi đánh giá');
                });
            });
        </script>
    </body>
</html>
