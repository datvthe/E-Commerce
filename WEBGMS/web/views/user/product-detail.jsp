<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>${empty product.name ? 'Sản phẩm' : product.name} - Gicungco Marketplace</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="iPhone, smartphone, Apple, mobile" name="keywords">
        <meta content="${empty product.description ? 'Chi tiết sản phẩm trên Gicungco' : product.description}" name="description">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500;600;700&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">
        <link href="<%= request.getContextPath() %>/views/assets/electro/lib/animate/animate.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath() %>/views/assets/electro/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath() %>/views/assets/electro/lib/lightbox/css/lightbox.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath() %>/views/assets/electro/css/bootstrap.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath() %>/views/assets/electro/css/style.css" rel="stylesheet">
        <style>
            /* Align seller action buttons on one line */
            .seller-actions { display: flex; gap: 0.5rem; align-items: center; flex-wrap: nowrap; }
            .seller-actions .btn { white-space: nowrap; }

            /* Ensure all similar product cards align their CTA at the bottom */
            .product-card { display: flex; flex-direction: column; height: 100%; }
            .product-card .card-img-top { height: 220px; width: 100%; object-fit: contain; }
            .product-card .card-body { display: flex; flex-direction: column; }
            .product-card .btn { margin-top: auto; }
            
            /* Product Detail Layout Improvements */
            .single-product {
                background: #fff;
                border-radius: 12px;
                padding: 2rem;
                box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            }
            
            .single-carousel {
                border-radius: 8px;
                overflow: hidden;
                background: #f8f9fa;
            }
            
            .single-carousel .single-inner {
                padding: 1.5rem;
                display: flex;
                align-items: center;
                justify-content: center;
                min-height: 400px;
            }
            
            .single-carousel .single-inner img {
                max-height: 400px;
                object-fit: contain;
            }
            
            .product-info {
                padding-left: 1.5rem;
            }
            
            @media (max-width: 768px) {
                .product-info {
                    padding-left: 0;
                    margin-top: 1.5rem;
                }
                
                .single-product {
                    padding: 1rem;
                }
            }
            
            /* Product title styling */
            .product-title {
                font-size: 1.75rem;
                font-weight: 700;
                color: #2c3e50;
                line-height: 1.3;
            }
            
            /* Price section enhancement */
            .price-section h2 {
                font-size: 2rem;
                font-weight: 700;
            }
            
            /* Seller info box styling */
            .seller-info {
                transition: all 0.3s ease;
            }
            
            .seller-info:hover {
                box-shadow: 0 4px 16px rgba(0,0,0,0.1);
                transform: translateY(-2px);
            }
        </style>
    </head>
    <body>
        <div id="spinner" class="bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center" style="display:none;">
            <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
                <span class="sr-only">Loading...</span>
            </div>
        </div>
        <script>
            // Ensure spinner is hidden (prevents blank screen overlay)
            (function(){
                var sp = document.getElementById('spinner');
                if (sp) { sp.classList.remove('show'); sp.style.display = 'none'; }
            })();
        </script>
        <div class="container-fluid px-5 d-none border-bottom d-lg-block">
            <div class="row gx-0 align-items-center">
                <div class="col-lg-4 text-center text-lg-start mb-lg-0">
                    <div class="d-inline-flex align-items-center" style="height: 45px;">
                        <a href="#" class="text-muted me-2"> Trợ giúp</a><small> / </small>
                        <a href="#" class="text-muted mx-2"> Hỗ trợ</a><small> / </small>
                        <a href="#" class="text-muted ms-2"> Liên hệ</a>
                    </div>
                </div>
                <div class="col-lg-4 text-center d-flex align-items-center justify-content-center">
                    <small class="text-dark">Gọi chúng tôi:</small>
                    <a href="#" class="text-muted">(+012) 1234 567890</a>
                </div>
                <div class="col-lg-4 text-center text-lg-end">
                    <div class="d-inline-flex align-items-center" style="height: 45px;">
                            <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <a href="<%= request.getContextPath() %>/profile" class="btn btn-outline-info btn-sm px-3 me-2"><i class="bi bi-person me-1"></i>Tài khoản</a>
                                <a href="#" class="btn btn-outline-danger btn-sm px-3" onclick="logout()"><i class="bi bi-box-arrow-right me-1"></i>Đăng xuất</a>
                                </c:when>
                                <c:otherwise>
                                <a href="<%= request.getContextPath() %>/login" class="btn btn-outline-primary btn-sm px-3 me-2"><i class="bi bi-person me-1"></i>Đăng nhập</a>
                                <a href="<%= request.getContextPath() %>/register" class="btn btn-outline-success btn-sm px-3"><i class="bi bi-person-plus me-1"></i>Đăng ký</a>
                                </c:otherwise>
                            </c:choose>
                            </div>
                </div>
            </div>
                            </div>
        <div class="container-fluid px-5 py-4 d-none d-lg-block">
            <div class="row gx-0 align-items-center text-center">
                <div class="col-md-4 col-lg-3 text-center text-lg-start">
                    <div class="d-inline-flex align-items-center">
                        <a href="<%= request.getContextPath() %>/home" class="navbar-brand p-0">
                            <h1 class="display-5 text-primary m-0"><i class="fas fa-shopping-bag text-secondary me-2"></i>Gicungco</h1>
                        </a>
                            </div>
                                </div>
                <div class="col-md-4 col-lg-6 text-center">
                    <div class="position-relative ps-4">
                        <div class="d-flex border rounded-pill">
                            <input class="form-control border-0 rounded-pill w-100 py-3" type="text" data-bs-target="#dropdownToggle123" placeholder="Tìm kiếm sản phẩm?">
                            <select class="form-select text-dark border-0 border-start rounded-0 p-3" style="width: 200px;">
                                <option value="All Category">Tất cả danh mục</option>
                                <option value="Pest Control-2">Danh mục 1</option>
                                <option value="Pest Control-3">Danh mục 2</option>
                                <option value="Pest Control-4">Danh mục 3</option>
                                <option value="Pest Control-5">Danh mục 4</option>
                            </select>
                            <button type="button" class="btn btn-primary rounded-pill py-3 px-5" style="border: 0;"><i class="fas fa-search"></i></button>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 col-lg-3 text-center text-lg-end">
                    <div class="d-inline-flex align-items-center">
                        <a href="#" class="text-muted d-flex align-items-center justify-content-center"><span class="rounded-circle btn-md-square border"><i class="fas fa-shopping-cart"></i></span>
                            <span class="text-dark ms-2">0₫</span></a>
                    </div>
                </div>
            </div>
        </div>
        <div class="container-fluid nav-bar p-0">
            <div class="row gx-0 bg-primary px-5 align-items-center">
                <div class="col-lg-3 d-none d-lg-block">
                    <nav class="navbar navbar-light position-relative" style="width: 250px;">
                        <button class="navbar-toggler border-0 fs-4 w-100 px-0 text-start" type="button" data-bs-toggle="collapse" data-bs-target="#allCat">
                            <h4 class="m-0"><i class="fa fa-bars me-2"></i>Tất cả danh mục</h4>
                            </button>
                        <div class="collapse navbar-collapse rounded-bottom" id="allCat">
                            <div class="navbar-nav ms-auto py-0">
                                <ul class="list-unstyled categories-bars">
                                    <li><div class="categories-bars-item"><a href="#"><i class="fas fa-graduation-cap me-2"></i>Học tập</a><span>(1,250)</span></div></li>
                                    <li><div class="categories-bars-item"><a href="#"><i class="fas fa-play-circle me-2"></i>Xem phim</a><span>(850)</span></div></li>
                                    <li><div class="categories-bars-item"><a href="#"><i class="fas fa-laptop-code me-2"></i>Phần mềm</a><span>(2,100)</span></div></li>
                                    <li><div class="categories-bars-item"><a href="#"><i class="fas fa-file-alt me-2"></i>Tài liệu</a><span>(680)</span></div></li>
                                    <li><div class="categories-bars-item"><a href="#"><i class="fas fa-gift me-2"></i>Thẻ cào</a><span>(1,500)</span></div></li>
                                    <li><div class="categories-bars-item"><a href="#"><i class="fas fa-user-circle me-2"></i>Tài khoản Game</a><span>(2,300)</span></div></li>
                                </ul>
                            </div>
                        </div>
                    </nav>
                </div>
                <div class="col-12 col-lg-9">
                    <nav class="navbar navbar-expand-lg navbar-light bg-primary ">
                        <a href="<%= request.getContextPath() %>/home" class="navbar-brand d-block d-lg-none">
                            <h1 class="display-5 text-secondary m-0"><i class="fas fa-shopping-bag text-white me-2"></i>Gicungco</h1>
                        </a>
                        <button class="navbar-toggler ms-auto" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
                            <span class="fa fa-bars fa-1x"></span>
                            </button>
                        <div class="collapse navbar-collapse" id="navbarCollapse">
                            <div class="navbar-nav ms-auto py-0">
                                <a href="<%= request.getContextPath() %>/home" class="nav-item nav-link">Trang chủ</a>
                                <a href="<%= request.getContextPath() %>/products" class="nav-item nav-link">Cửa hàng</a>
                                <a href="#" class="nav-item nav-link active">Sản phẩm</a>
                                <div class="nav-item dropdown">
                                    <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">Danh mục</a>
                                    <div class="dropdown-menu m-0">
                                        <a href="#" class="dropdown-item"><i class="fas fa-graduation-cap me-2"></i>Học tập</a>
                                        <a href="#" class="dropdown-item"><i class="fas fa-play-circle me-2"></i>Xem phim</a>
                                        <a href="#" class="dropdown-item"><i class="fas fa-laptop-code me-2"></i>Phần mềm</a>
                                        <a href="#" class="dropdown-item"><i class="fas fa-file-alt me-2"></i>Tài liệu</a>
                                        <a href="#" class="dropdown-item"><i class="fas fa-ellipsis-h me-2"></i>Khác</a>
                                    </div>
                                </div>
                                <a href="#" class="nav-item nav-link">Tin tức</a>
                                <a href="#" class="nav-item nav-link">Chia sẻ</a>
                                <a href="<%= request.getContextPath() %>/contact" class="nav-item nav-link me-2">Hỗ trợ</a>
                                <div class="nav-item dropdown d-block d-lg-none mb-3">
                                    <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">Tất cả danh mục</a>
                                    <div class="dropdown-menu m-0">
                                        <ul class="list-unstyled categories-bars">
                                            <li><div class="categories-bars-item"><a href="#">Phụ kiện</a><span>(3)</span></div></li>
                                            <li><div class="categories-bars-item"><a href="#">Điện tử & Máy tính</a><span>(5)</span></div></li>
                                            <li><div class="categories-bars-item"><a href="#">Laptop & Desktop</a><span>(2)</span></div></li>
                                            <li><div class="categories-bars-item"><a href="#">Điện thoại & Máy tính bảng</a><span>(8)</span></div></li>
                                            <li><div class="categories-bars-item"><a href="#">SmartPhone & Smart TV</a><span>(5)</span></div></li>
                    </ul>
                                    </div>
                                </div>
                            </div>
                            <a href="#" class="btn btn-secondary rounded-pill py-2 px-4 px-lg-3 mb-3 mb-md-3 mb-lg-0"><i class="fa fa-mobile-alt me-2"></i> +0123 456 7890</a>
                        </div>
                    </nav>
                                </div>
                            </div>
                        </div>
                        
        <!-- Single Page Header start -->
        <div class="container-fluid page-header py-5">
            <h1 class="text-center text-white display-6 wow fadeInUp" data-wow-delay="0.1s">Chi tiết sản phẩm</h1>
            <ol class="breadcrumb justify-content-center mb-0 wow fadeInUp" data-wow-delay="0.3s">
                <li class="breadcrumb-item"><a href="<%= request.getContextPath() %>/home">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="<%= request.getContextPath() %>/products">Sản phẩm</a></li>
                <li class="breadcrumb-item active text-white">${empty product.name ? 'Sản phẩm' : product.name}</li>
            </ol>
        </div>
        <!-- Single Page Header End -->

        <!-- Single Products Start -->
        <div class="container-fluid shop py-5">
            <div class="container py-5">
                <c:choose>
                    <c:when test="false">
                        <div class="row justify-content-center">
                            <div class="col-md-8 text-center">
                                <div class="alert alert-danger">
                                    <h4><i class="fas fa-exclamation-triangle me-2"></i>Sản phẩm không tồn tại</h4>
                                    <p class="mb-3">Xin lỗi, sản phẩm bạn đang tìm kiếm không tồn tại hoặc đã bị xóa.</p>
                                    <a href="<%= request.getContextPath() %>/products" class="btn btn-primary">
                                        <i class="fas fa-arrow-left me-2"></i>Quay lại cửa hàng
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                <!-- Center container with max width for better readability -->
                <div class="row justify-content-center">
                    <div class="col-12 col-xxl-10">
                        <div class="row g-4 single-product">
                            <!-- Product Images - Left Side (40%) -->
                            <div class="col-12 col-md-5 col-lg-5 wow fadeInUp" data-wow-delay="0.1s">
                                <div class="single-carousel owl-carousel">
                                    <c:choose>
                                        <c:when test="${not empty images}">
                                            <c:forEach var="image" items="${images}">
                                                <div class="single-item" data-dot="<img class='img-fluid' src='${image.url}' alt='${image.alt_text != null ? image.alt_text : "Hình ảnh sản phẩm"}'>">
                                                    <div class="single-inner bg-light rounded">
                                                        <img src="${image.url}" class="img-fluid rounded" alt="${image.alt_text != null ? image.alt_text : "Hình ảnh sản phẩm"}">
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                    <div class="single-item" data-dot="<img class='img-fluid' src='<%= request.getContextPath() %>/views/assets/electro/img/product-1.png' alt='${empty product.name ? "Hình ảnh sản phẩm" : product.name}'>">
                                                <div class="single-inner bg-light rounded">
                                            <img src="<%= request.getContextPath() %>/views/assets/electro/img/product-1.png" class="img-fluid rounded" alt="${empty product.name ? "Hình ảnh sản phẩm" : product.name}">
                                                </div>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            
                            <!-- Product Information - Right Side (60%) -->
                            <div class="col-12 col-md-7 col-lg-7 wow fadeInUp" data-wow-delay="0.2s">
                                <div class="product-info">
                                    <h1 class="product-title mb-3">${empty product.name ? 'Sản phẩm' : product.name}</h1>
                                    
                                    <!-- Product Rating & Reviews -->
                                    <div class="d-flex align-items-center mb-3">
                                        <div class="rating me-3">
                                            <i class="fa fa-star text-warning"></i>
                                            <i class="fa fa-star text-warning"></i>
                                            <i class="fa fa-star text-warning"></i>
                                            <i class="fa fa-star text-warning"></i>
                                            <i class="fa fa-star text-warning"></i>
                                        </div>
                                        <span class="text-muted">(${product.total_reviews} đánh giá)</span>
                                        <span class="badge bg-success ms-3"><fmt:formatNumber value="${product.average_rating}" maxFractionDigits="1"/>/5</span>
                                    </div>
                                    
                                    <!-- Price Section -->
                                    <div class="price-section mb-4">
                                        <div class="d-flex align-items-center">
                                            <h2 class="text-primary mb-0 me-3"><fmt:formatNumber value="${product.price}" pattern="#,###"/>₫</h2>
                                        </div>
                                    </div>
                                    
                                    <!-- Product Details -->
                                    <div class="product-details mb-4">
                                        <div class="row">
                                            <div class="col-6">
                                                <p class="mb-2"><strong>Danh mục:</strong> ${not empty product.category_id ? product.category_id.name : 'Chưa phân loại'}</p>
                                                <p class="mb-2"><strong>Mã sản phẩm:</strong> IP15PM256</p>
                                                <p class="mb-2"><strong>Loại:</strong> <span class="badge bg-info">Sản phẩm số</span></p>
                                            </div>
                                            <div class="col-6">
                                                <p class="mb-2"><strong>Tình trạng:</strong> 
                                                    <c:choose>
                                                        <c:when test="${not empty availableStock and availableStock > 0}">
                                                            <span class="text-success"><i class="fas fa-check-circle"></i> Còn hàng</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-danger"><i class="fas fa-times-circle"></i> Hết hàng</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </p>
                                                <p class="mb-2"><strong>Số lượng:</strong> 
                                                    <c:choose>
                                                        <c:when test="${not empty availableStock}">
                                                            <span class="text-primary">${availableStock} sản phẩm</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-danger">0 sản phẩm</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </p>
                                                <p class="mb-2"><strong>Giao hàng:</strong> <span class="text-success"><i class="fas fa-truck"></i> Tức thì</span></p>
                                            </div>
                                        </div>
                                    </div>
                            
                            <!-- Seller Information -->
                            <div class="seller-info mb-4 p-4 bg-light rounded-3 border">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <h6 class="mb-0"><i class="fas fa-store me-2 text-primary"></i>Thông tin người bán</h6>
                                    <span class="badge bg-success">Đã xác thực</span>
                                </div>
                                
                                <div class="row align-items-center">
                                    <div class="col-auto">
                                        <div class="seller-avatar">
                                            <img src="<%= request.getContextPath() %>/views/assets/user/img/avatar.jpg" 
                                                 class="rounded-circle border border-3 border-primary" width="60" height="60" alt="Seller Avatar">
                                        </div>
                                    </div>
                                    <div class="col">
                                        <div class="seller-details">
                                            <h6 class="mb-1 fw-bold">Nguyễn Văn Minh</h6>
                                            <p class="mb-1 text-muted small">
                                                <i class="fas fa-envelope me-1"></i>minh.nguyen@example.com
                                            </p>
                                            <div class="seller-stats d-flex gap-3">
                                                <div class="stat-item">
                                                    <span class="text-primary fw-bold">4.8</span>
                                                    <div class="stars">
                                                        <i class="fas fa-star text-warning"></i>
                                                        <i class="fas fa-star text-warning"></i>
                                                        <i class="fas fa-star text-warning"></i>
                                                        <i class="fas fa-star text-warning"></i>
                                                        <i class="fas fa-star text-warning"></i>
                                                    </div>
                                                    <small class="text-muted">(1,250 đánh giá)</small>
                                                </div>
                                                <div class="stat-item">
                                                    <span class="text-success fw-bold">98%</span>
                                                    <small class="text-muted d-block">Tỷ lệ hài lòng</small>
                                                </div>
                                                <div class="stat-item">
                                                    <span class="text-info fw-bold">2,500+</span>
                                                    <small class="text-muted d-block">Sản phẩm đã bán</small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-auto">
                                        <div class="seller-actions">
                                            <button class="btn btn-outline-primary btn-sm" onclick="viewSellerProfile('seller001')">
                                                <i class="fas fa-user me-1"></i>Xem shop
                                            </button>
                                            <button class="btn btn-outline-success btn-sm" onclick="contactSeller('seller001')">
                                                <i class="fas fa-comments me-1"></i>Liên hệ
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Seller Description -->
                                <div class="seller-description mt-3 pt-3 border-top">
                                    <p class="mb-2 text-muted small">
                                        <i class="fas fa-quote-left me-1"></i>
                                        "Chuyên cung cấp điện thoại và phụ kiện chính hãng với giá cả hợp lý. 
                                        Cam kết giao hàng nhanh chóng và hỗ trợ khách hàng 24/7."
                                    </p>
                                    <div class="d-flex gap-2">
                                        <span class="badge bg-light text-dark">
                                            <i class="fas fa-clock me-1"></i>Phản hồi trong 1h
                                        </span>
                                        <span class="badge bg-light text-dark">
                                            <i class="fas fa-shipping-fast me-1"></i>Giao hàng nhanh
                                        </span>
                                        <span class="badge bg-light text-dark">
                                            <i class="fas fa-shield-alt me-1"></i>Bảo hành 12 tháng
                                        </span>
                                    </div>
                                </div>
                            </div>
                                    
                                    <!-- Quantity Selector -->
                                    <div class="quantity-section mb-4">
                                        <label class="form-label fw-bold">Số lượng:</label>
                                        <div class="input-group quantity" style="width: 150px;">
                                            <div class="input-group-btn">
                                                <button class="btn btn-sm btn-minus rounded-circle bg-light border" type="button">
                                                    <i class="fa fa-minus"></i>
                                                </button>
                                            </div>
                                            <input type="number" class="form-control form-control-sm text-center border-0" 
                                                   value="1" min="1" max="${not empty availableStock ? availableStock : 1}" id="quantity">
                                            <div class="input-group-btn">
                                                <button class="btn btn-sm btn-plus rounded-circle bg-light border" type="button">
                                                    <i class="fa fa-plus"></i>
                                                </button>
                        </div>
                    </div>
                </div>

                                    <!-- Action Buttons -->
                                    <div class="action-buttons mb-4">
                                        <!-- Physical Goods Buttons -->
                                        <div class="row g-2">
                                            <div class="col-md-9">
                                                <c:choose>
                                                    <c:when test="${not empty availableStock and availableStock > 0}">
                                                        <button class="btn btn-primary w-100 py-3" onclick="buyNow()">
                                                            <i class="fas fa-bolt me-2"></i>Mua ngay
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button class="btn btn-secondary w-100 py-3" disabled>
                                                            <i class="fas fa-times me-2"></i>Hết hàng
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="col-md-3">
                                                <c:if test="${not empty sessionScope.user}">
                                                    <button class="btn btn-outline-danger w-100 py-3 wishlist-btn" 
                                                            data-product-id="${product.product_id}"
                                                            onclick="toggleWishlist(${product.product_id}, this)"
                                                            title="Thêm vào yêu thích">
                                                        <i class="far fa-heart fa-lg"></i>
                                                    </button>
                                                </c:if>
                                            </div>
                                        </div>
                                        <div class="row g-2 mt-2">
                                            <div class="col-md-6">
                                                <button class="btn btn-outline-info w-100 py-2" onclick="shareProduct()">
                                                    <i class="fas fa-share-alt me-2"></i>Chia sẻ
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                        
                                    <!-- Social Sharing -->
                                    <!-- <div class="social-sharing mb-4">
                                        <p class="mb-2"><strong>Chia sẻ sản phẩm:</strong></p>
                                        <div class="d-flex gap-2">
                                            <button class="btn btn-primary btn-sm" onclick="shareOnFacebook()">
                                                <i class="fab fa-facebook-f me-1"></i>Facebook
                                            </button>
                                            <button class="btn btn-info btn-sm" onclick="shareOnTwitter()">
                                                <i class="fab fa-twitter me-1"></i>Twitter
                                            </button>
                                            <button class="btn btn-success btn-sm" onclick="shareOnWhatsApp()">
                                                <i class="fab fa-whatsapp me-1"></i>WhatsApp
                                            </button>
                                        </div>
                                    </div> -->
                                </div>
                            </div>
                            
                            <!-- Product Tabs - Full Width -->
                            <div class="col-12">
                                <nav>
                                    <div class="nav nav-tabs mb-3" id="productTabs">
                                        <button class="nav-link active" type="button" role="tab" id="description-tab" data-bs-toggle="tab" data-bs-target="#description" aria-controls="description" aria-selected="true">
                                            <i class="fas fa-info-circle me-2"></i>Mô tả sản phẩm
                                        </button>
                                        <button class="nav-link" type="button" role="tab" id="reviews-tab" data-bs-toggle="tab" data-bs-target="#reviews" aria-controls="reviews" aria-selected="false">
                                            <i class="fas fa-star me-2"></i>Đánh giá (${product.total_reviews})
                                        </button>
                                        <button class="nav-link" type="button" role="tab" id="policies-tab" data-bs-toggle="tab" data-bs-target="#policies" aria-controls="policies" aria-selected="false">
                                            <i class="fas fa-shield-alt me-2"></i>Chính sách
                                        </button>
                                    </div>
                                </nav>
                                <div class="tab-content mb-5">
                        <!-- Description Tab -->
                                    <div class="tab-pane fade show active" id="description" role="tabpanel" aria-labelledby="description-tab">
                                        <div class="row">
                                            <div class="col-lg-8">
                                                <h5 class="mb-3">Mô tả chi tiết</h5>
                                                <div class="product-description">
                                                    <c:choose>
                                                        <c:when test="${not empty product.description}">
                                                            <p class="lead">${product.description}</p>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <p class="text-muted">Chưa có mô tả cho sản phẩm này.</p>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                            <div class="col-lg-4">
                                                <div class="bg-light p-4 rounded">
                                                    <h6 class="mb-3">Thông tin bổ sung</h6>
                                                    <ul class="list-unstyled">
                                                        <li class="mb-2"><i class="fas fa-truck text-success me-2"></i>Miễn phí vận chuyển</li>
                                                        <li class="mb-2"><i class="fas fa-undo text-success me-2"></i>Đổi trả trong 30 ngày</li>
                                                        <li class="mb-2"><i class="fas fa-shield-alt text-success me-2"></i>Bảo hành chính hãng</li>
                                                        <li class="mb-2"><i class="fas fa-headset text-success me-2"></i>Hỗ trợ 24/7</li>
                                                    </ul>
                                                </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Reviews Tab -->
                                    <div class="tab-pane fade" id="reviews" role="tabpanel" aria-labelledby="reviews-tab">
                                        <div class="row">
                                            <div class="col-lg-4">
                                                <div class="rating-summary text-center p-4 bg-light rounded">
                                                    <h2 class="text-primary mb-2"><fmt:formatNumber value="${product.average_rating}" maxFractionDigits="1"/></h2>
                                                    <div class="stars mb-3">
                                                        <i class="fa fa-star text-warning"></i>
                                                        <i class="fa fa-star text-warning"></i>
                                                        <i class="fa fa-star text-warning"></i>
                                                        <i class="fa fa-star text-warning"></i>
                                                        <i class="fa fa-star text-warning"></i>
                                                    </div>
                                                    <p class="text-muted">Dựa trên ${product.total_reviews} đánh giá</p>
                                                    
                                                    <!-- Rating Distribution -->
                                                    <div class="rating-breakdown mt-4">
                                                        <div class="d-flex align-items-center mb-2">
                                                            <span class="me-2">5 <i class="fas fa-star text-warning"></i></span>
                                                            <div class="progress flex-grow-1 me-2" style="height: 8px;">
                                                                <div class="progress-bar" style="width: 80%"></div>
                                                            </div>
                                                            <span class="text-muted small">80</span>
                                                        </div>
                                                        <div class="d-flex align-items-center mb-2">
                                                            <span class="me-2">4 <i class="fas fa-star text-warning"></i></span>
                                                            <div class="progress flex-grow-1 me-2" style="height: 8px;">
                                                                <div class="progress-bar" style="width: 60%"></div>
                                                            </div>
                                                            <span class="text-muted small">60</span>
                                                        </div>
                                                        <div class="d-flex align-items-center mb-2">
                                                            <span class="me-2">3 <i class="fas fa-star text-warning"></i></span>
                                                            <div class="progress flex-grow-1 me-2" style="height: 8px;">
                                                                <div class="progress-bar" style="width: 30%"></div>
                                                            </div>
                                                            <span class="text-muted small">30</span>
                                                        </div>
                                                        <div class="d-flex align-items-center mb-2">
                                                            <span class="me-2">2 <i class="fas fa-star text-warning"></i></span>
                                                            <div class="progress flex-grow-1 me-2" style="height: 8px;">
                                                                <div class="progress-bar" style="width: 10%"></div>
                                                            </div>
                                                            <span class="text-muted small">10</span>
                                                        </div>
                                                        <div class="d-flex align-items-center mb-2">
                                                            <span class="me-2">1 <i class="fas fa-star text-warning"></i></span>
                                                            <div class="progress flex-grow-1 me-2" style="height: 8px;">
                                                                <div class="progress-bar" style="width: 5%"></div>
                                                            </div>
                                                            <span class="text-muted small">5</span>
                                                        </div>
                                                    </div>
                                </div>
                                            </div>
                                            <div class="col-lg-8">
                                                <h5 class="mb-4">Đánh giá của khách hàng</h5>
                                                
                                                <!-- Add Review Form (for logged-in users) -->
                                                <c:if test="${not empty sessionScope.user}">
                                                    <div class="add-review mb-4 p-4 border rounded">
                                                        <h6 class="mb-3">Viết đánh giá của bạn</h6>
                                                        <form id="reviewForm">
                                                            <div class="mb-3">
                                                                <label class="form-label">Đánh giá của bạn</label>
                                                                <div class="rating-input">
                                                                    <c:forEach begin="1" end="5" var="i">
                                                                        <i class="fas fa-star rating-star" data-rating="${i}" style="cursor: pointer; color: #ddd; font-size: 1.5rem;"></i>
                                                                    </c:forEach>
                                                                </div>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label class="form-label">Nhận xét</label>
                                                                <textarea class="form-control" rows="3" id="reviewComment" placeholder="Chia sẻ trải nghiệm của bạn về sản phẩm này..."></textarea>
                                                            </div>
                                                            <button type="button" class="btn btn-primary" onclick="submitReview()">
                                                                <i class="fas fa-paper-plane me-2"></i>Gửi đánh giá
                                                            </button>
                                                        </form>
                                                    </div>
                                                </c:if>
                                
                                <!-- Reviews List -->
                                <div class="reviews-list">
                                    <div class="review-item border-bottom pb-3 mb-3">
                                        <div class="d-flex align-items-start">
                                            <img src="<%= request.getContextPath() %>/views/assets/user/img/avatar.jpg" 
                                                 class="rounded-circle me-3" width="50" height="50" alt="Avatar">
                                            <div class="flex-grow-1">
                                                <div class="d-flex justify-content-between align-items-start mb-2">
                                                    <div>
                                                        <h6 class="mb-1">Trần Thị Hương</h6>
                                                        <div class="stars">
                                                            <i class="fa fa-star text-warning"></i>
                                                            <i class="fa fa-star text-warning"></i>
                                                            <i class="fa fa-star text-warning"></i>
                                                            <i class="fa fa-star text-warning"></i>
                                                            <i class="fa fa-star text-warning"></i>
                                                        </div>
                                                    </div>
                                                    <small class="text-muted">2 ngày trước</small>
                                                </div>
                                                <p class="mb-0">Sản phẩm rất tốt, camera chụp ảnh đẹp, pin trâu. Giao hàng nhanh, đóng gói cẩn thận. Rất hài lòng!</p>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="review-item border-bottom pb-3 mb-3">
                                        <div class="d-flex align-items-start">
                                            <img src="<%= request.getContextPath() %>/views/assets/user/img/avatar.jpg" 
                                                 class="rounded-circle me-3" width="50" height="50" alt="Avatar">
                                            <div class="flex-grow-1">
                                                <div class="d-flex justify-content-between align-items-start mb-2">
                                                    <div>
                                                        <h6 class="mb-1">Lê Văn Nam</h6>
                                                        <div class="stars">
                                                            <i class="fa fa-star text-warning"></i>
                                                            <i class="fa fa-star text-warning"></i>
                                                            <i class="fa fa-star text-warning"></i>
                                                            <i class="fa fa-star text-warning"></i>
                                                            <i class="fa fa-star text-muted"></i>
                                                        </div>
                                                    </div>
                                                    <small class="text-muted">1 tuần trước</small>
                                                </div>
                                                <p class="mb-0">iPhone 15 Pro Max rất mượt mà, thiết kế đẹp. Chỉ có điều giá hơi cao nhưng chất lượng xứng đáng.</p>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="review-item border-bottom pb-3 mb-3">
                                        <div class="d-flex align-items-start">
                                            <img src="<%= request.getContextPath() %>/views/assets/user/img/avatar.jpg" 
                                                 class="rounded-circle me-3" width="50" height="50" alt="Avatar">
                                            <div class="flex-grow-1">
                                                <div class="d-flex justify-content-between align-items-start mb-2">
                                                    <div>
                                                        <h6 class="mb-1">Phạm Thị Mai</h6>
                                                        <div class="stars">
                                                            <i class="fa fa-star text-warning"></i>
                                                            <i class="fa fa-star text-warning"></i>
                                                            <i class="fa fa-star text-warning"></i>
                                                            <i class="fa fa-star text-warning"></i>
                                                            <i class="fa fa-star text-warning"></i>
                                                        </div>
                                                    </div>
                                                    <small class="text-muted">2 tuần trước</small>
                                                </div>
                                                <p class="mb-0">Tuyệt vời! Camera chụp ảnh cực đẹp, màn hình sắc nét. Pin dùng được cả ngày. Shop phục vụ tốt!</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                                </div>
                            </div>
                        </div>
                        
                        <!-- Policies Tab -->
                                    <div class="tab-pane fade" id="policies" role="tabpanel" aria-labelledby="policies-tab">
                                <div class="row">
                                            <div class="col-lg-6">
                                                <h5 class="mb-4">Chính sách vận chuyển</h5>
                                                <div class="policy-item mb-4">
                                                    <h6><i class="fas fa-truck me-2 text-primary"></i>Vận chuyển</h6>
                                                    <ul class="list-unstyled">
                                                        <li><i class="fas fa-check text-success me-2"></i>Miễn phí vận chuyển cho đơn hàng từ 500,000₫</li>
                                                        <li><i class="fas fa-check text-success me-2"></i>Giao hàng trong 1-3 ngày làm việc</li>
                                                        <li><i class="fas fa-check text-success me-2"></i>Hỗ trợ giao hàng tận nơi</li>
                                                        <li><i class="fas fa-check text-success me-2"></i>Theo dõi đơn hàng trực tuyến</li>
                                        </ul>
                                    </div>
                                                
                                                <div class="policy-item mb-4">
                                                    <h6><i class="fas fa-undo me-2 text-primary"></i>Đổi trả</h6>
                                                    <ul class="list-unstyled">
                                                        <li><i class="fas fa-check text-success me-2"></i>Đổi trả miễn phí trong 30 ngày</li>
                                                        <li><i class="fas fa-check text-success me-2"></i>Sản phẩm phải còn nguyên vẹn, có hóa đơn</li>
                                                        <li><i class="fas fa-check text-success me-2"></i>Hoàn tiền 100% nếu sản phẩm lỗi</li>
                                        </ul>
                                    </div>
                                            </div>
                                            <div class="col-lg-6">
                                                <h5 class="mb-4">Chính sách bảo hành</h5>
                                                <div class="policy-item mb-4">
                                                    <h6><i class="fas fa-shield-alt me-2 text-primary"></i>Bảo hành</h6>
                                                    <ul class="list-unstyled">
                                                        <li><i class="fas fa-check text-success me-2"></i>Bảo hành chính hãng 12 tháng</li>
                                                        <li><i class="fas fa-check text-success me-2"></i>Hỗ trợ sửa chữa tại trung tâm ủy quyền</li>
                                                        <li><i class="fas fa-check text-success me-2"></i>Đổi mới nếu không sửa được</li>
                                        </ul>
                                    </div>
                                                
                                                <div class="policy-item mb-4">
                                                    <h6><i class="fas fa-credit-card me-2 text-primary"></i>Thanh toán</h6>
                                                    <ul class="list-unstyled">
                                                        <li><i class="fas fa-check text-success me-2"></i>Thanh toán khi nhận hàng (COD)</li>
                                                        <li><i class="fas fa-check text-success me-2"></i>Chuyển khoản ngân hàng</li>
                                                        <li><i class="fas fa-check text-success me-2"></i>Ví điện tử (MoMo, ZaloPay)</li>
                                                        <li><i class="fas fa-check text-success me-2"></i>Thẻ tín dụng/ghi nợ</li>
                                                    </ul>
                                </div>
                            </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                    </c:otherwise>
                </c:choose>
        <!-- Single Products End -->

        <!-- Similar Products Section -->
        <div class="container-fluid py-5 bg-light">
            <div class="container">
                        <div class="row">
                    <div class="col-12">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h3 class="mb-0">
                                <i class="fas fa-robot me-2 text-primary"></i>Sản phẩm tương tự (AI Gợi ý)
                            </h3>
                            <a href="<%= request.getContextPath() %>/products" class="btn btn-outline-primary">
                                Xem tất cả <i class="fas fa-arrow-right ms-1"></i>
                            </a>
                                            </div>
                        <p class="text-muted mb-4">Khám phá các sản phẩm số chất lượng cao với giá cả hợp lý</p>
                        
                        <div class="row g-4">
                            <!-- Digital Product 1 -->
                            <div class="col-md-6 col-lg-3">
                                <div class="product-card h-100">
                                    <div class="position-relative">
                                        <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/ChatGPT_logo.svg/512px-ChatGPT_logo.svg.png" 
                                             class="card-img-top" alt="ChatGPT Plus" style="object-fit: contain; padding: 2rem; background: #fff;">
                                        <div class="position-absolute top-0 end-0 p-2">
                                            <button class="btn btn-sm btn-light rounded-circle" onclick="toggleWishlist(2)">
                                                <i class="fas fa-heart"></i>
                                            </button>
                                        </div>
                                        <div class="position-absolute top-0 start-0 p-2">
                                            <span class="badge bg-success">Hot</span>
                                    </div>
                                </div>
                                    <div class="card-body d-flex flex-column">
                                        <h6 class="card-title">Tài khoản ChatGPT Plus 1 tháng</h6>
                                        <div class="d-flex align-items-center mb-2">
                                            <div class="text-warning me-2">
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                        </div>
                                            <small class="text-muted">(523)</small>
                    </div>
                                        <div class="d-flex align-items-center justify-content-between mb-3">
                                            <div>
                                                <span class="h5 text-primary mb-0">450,000₫</span>
                                            </div>
                                        </div>
                                        <button class="btn btn-primary w-100 mt-auto" onclick="viewProduct(2)">
                                            <i class="fas fa-eye me-1"></i> Chi tiết
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Digital Product 2 -->
                            <div class="col-md-6 col-lg-3">
                                <div class="product-card h-100">
                                    <div class="position-relative">
                                        <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/08/Netflix_2015_logo.svg/512px-Netflix_2015_logo.svg.png" 
                                             class="card-img-top" alt="Netflix Premium" style="object-fit: contain; padding: 2rem; background: #000;">
                                        <div class="position-absolute top-0 end-0 p-2">
                                            <button class="btn btn-sm btn-light rounded-circle" onclick="toggleWishlist(3)">
                                                <i class="fas fa-heart"></i>
                                            </button>
                                        </div>
                                        <div class="position-absolute top-0 start-0 p-2">
                                            <span class="badge bg-danger">Giảm giá</span>
                                        </div>
                                    </div>
                                    <div class="card-body d-flex flex-column">
                                        <h6 class="card-title">Tài khoản Netflix Premium 1 tháng</h6>
                                        <div class="d-flex align-items-center mb-2">
                                            <div class="text-warning me-2">
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                            </div>
                                            <small class="text-muted">(892)</small>
                                        </div>
                                        <div class="d-flex align-items-center justify-content-between mb-3">
                                            <div>
                                                <span class="h5 text-primary mb-0">180,000₫</span>
                                                <small class="text-muted d-block"><del>260,000₫</del></small>
                                            </div>
                                        </div>
                                        <button class="btn btn-primary w-100 mt-auto" onclick="viewProduct(3)">
                                            <i class="fas fa-eye me-1"></i> Chi tiết
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Digital Product 3 -->
                            <div class="col-md-6 col-lg-3">
                                <div class="product-card h-100">
                                    <div class="position-relative">
                                        <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/19/Spotify_logo_without_text.svg/512px-Spotify_logo_without_text.svg.png" 
                                             class="card-img-top" alt="Spotify Premium" style="object-fit: contain; padding: 2rem; background: #1DB954;">
                                        <div class="position-absolute top-0 end-0 p-2">
                                            <button class="btn btn-sm btn-light rounded-circle" onclick="toggleWishlist(4)">
                                                <i class="fas fa-heart"></i>
                                            </button>
                                        </div>
                                        <div class="position-absolute top-0 start-0 p-2">
                                            <span class="badge bg-success">Bán chạy</span>
                                        </div>
                                    </div>
                                    <div class="card-body d-flex flex-column">
                                        <h6 class="card-title">Tài khoản Spotify Premium 1 tháng</h6>
                                        <div class="d-flex align-items-center mb-2">
                                            <div class="text-warning me-2">
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                            </div>
                                            <small class="text-muted">(1,245)</small>
                                        </div>
                                        <div class="d-flex align-items-center justify-content-between mb-3">
                                            <div>
                                                <span class="h5 text-primary mb-0">120,000₫</span>
                                            </div>
                                        </div>
                                        <button class="btn btn-primary w-100 mt-auto" onclick="viewProduct(4)">
                                            <i class="fas fa-eye me-1"></i> Chi tiết
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Digital Product 4 -->
                            <div class="col-md-6 col-lg-3">
                                <div class="product-card h-100">
                                    <div class="position-relative">
                                        <img src="https://www.quancongnghe.com.vn/wp-content/uploads/2023/07/tai-canva-0.jpg" 
                                             class="card-img-top" alt="Canva Pro" style="object-fit: contain; padding: 2rem; background: linear-gradient(135deg, #00C4CC 0%, #7C5CFF 100%);"
                                             onerror="this.src='<%= request.getContextPath() %>/views/assets/electro/img/product-10.png'; this.onerror=null;">
                                        <div class="position-absolute top-0 end-0 p-2">
                                            <button class="btn btn-sm btn-light rounded-circle" onclick="toggleWishlist(5)">
                                                <i class="fas fa-heart"></i>
                                            </button>
                                        </div>
                                        <div class="position-absolute top-0 start-0 p-2">
                                            <span class="badge bg-info">Mới</span>
                                        </div>
                                    </div>
                                    <div class="card-body d-flex flex-column">
                                        <h6 class="card-title">Tài khoản Canva Pro 1 tháng</h6>
                                        <div class="d-flex align-items-center mb-2">
                                            <div class="text-warning me-2">
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                            </div>
                                            <small class="text-muted">(687)</small>
                                        </div>
                                        <div class="d-flex align-items-center justify-content-between mb-3">
                                            <div>
                                                <span class="h5 text-primary mb-0">280,000₫</span>
                                            </div>
                                        </div>
                                        <button class="btn btn-primary w-100 mt-auto" onclick="viewProduct(5)">
                                            <i class="fas fa-eye me-1"></i> Chi tiết
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer Start -->
        <div class="container-fluid bg-dark text-white-50 footer pt-5 mt-5">
            <div class="container py-5">
                <div class="row g-5">
                    <div class="col-lg-3 col-md-6">
                        <h5 class="text-white text-uppercase mb-4">Gicungco Marketplace</h5>
                        <p class="mb-4">Nền tảng thương mại điện tử hàng đầu Việt Nam, kết nối người mua và người bán một cách an toàn và tiện lợi.</p>
                        <div class="d-flex pt-2">
                            <a class="btn btn-outline-light btn-social" href=""><i class="fab fa-twitter"></i></a>
                            <a class="btn btn-outline-light btn-social" href=""><i class="fab fa-facebook-f"></i></a>
                            <a class="btn btn-outline-light btn-social" href=""><i class="fab fa-youtube"></i></a>
                            <a class="btn btn-outline-light btn-social" href=""><i class="fab fa-linkedin-in"></i></a>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <h5 class="text-white text-uppercase mb-4">Dịch vụ</h5>
                        <div class="d-flex flex-column justify-content-start">
                            <a class="text-white-50 mb-2" href="<%= request.getContextPath() %>/products"><i class="fa fa-angle-right me-2"></i>Danh mục sản phẩm</a>
                            <a class="text-white-50 mb-2" href="<%= request.getContextPath() %>/promotions"><i class="fa fa-angle-right me-2"></i>Khuyến mãi</a>
                            <a class="text-white-50 mb-2" href="#"><i class="fa fa-angle-right me-2"></i>Hỗ trợ khách hàng</a>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <h5 class="text-white text-uppercase mb-4">Hỗ trợ</h5>
                        <div class="d-flex flex-column justify-content-start">
                            <a class="text-white-50 mb-2" href="#"><i class="fa fa-angle-right me-2"></i>Trung tâm trợ giúp</a>
                            <a class="text-white-50 mb-2" href="#"><i class="fa fa-angle-right me-2"></i>Chính sách bảo mật</a>
                            <a class="text-white-50 mb-2" href="#"><i class="fa fa-angle-right me-2"></i>Điều khoản sử dụng</a>
                            <a class="text-white-50 mb-2" href="#"><i class="fa fa-angle-right me-2"></i>Chính sách vận chuyển</a>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <h5 class="text-white text-uppercase mb-4">Liên hệ</h5>
                        <p class="mb-2"><i class="fa fa-map-marker-alt me-3"></i>123 Đường ABC, Quận 1, TP.HCM</p>
                        <p class="mb-2"><i class="fa fa-phone-alt me-3"></i>+012 345 67890</p>
                        <p class="mb-2"><i class="fa fa-envelope me-3"></i>info@example.com</p>
                                            </div>
                                        </div>
                                    </div>
            <div class="container">
                <div class="copyright">
                    <div class="row">
                        <div class="col-md-6 text-center text-md-start mb-3 mb-md-0">
                            &copy; <a class="border-bottom" href="#">Gicungco Marketplace</a>, Tất cả quyền được bảo lưu.
                        </div>
                        <div class="col-md-6 text-center text-md-end">
                            <div class="footer-menu">
                                <a href="<%= request.getContextPath() %>/home">Trang chủ</a>
                                <a href="#">Chính sách Cookie</a>
                                <a href="#">Trợ giúp</a>
                                <a href="#">Câu hỏi thường gặp</a>
                                </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Footer End -->

        <!-- Back to Top -->
        <a href="#" class="btn btn-primary btn-lg-square back-to-top"><i class="bi bi-arrow-up"></i></a>

        <!-- Electro Bootstrap Scripts -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/lib/wow/wow.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/lib/easing/easing.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/lib/waypoints/waypoints.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/lib/counterup/counterup.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/lib/owlcarousel/owl.carousel.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/lib/lightbox/js/lightbox.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/js/main.js"></script>

        <!-- Global Variables -->
        <script>
            var productId = parseInt("${empty product.product_id ? 1 : product.product_id}");
            var maxQuantity = parseInt("${not empty availableStock ? availableStock : 0}");
            
            // Check if product data is available
            if (productId === 0) {
                console.error('Product data not found');
                document.body.innerHTML = '<div class="container mt-5"><div class="alert alert-danger text-center"><h4>Sản phẩm không tồn tại</h4><p>Xin lỗi, sản phẩm bạn đang tìm kiếm không tồn tại hoặc đã bị xóa.</p><a href="<%= request.getContextPath() %>/products" class="btn btn-primary">Quay lại cửa hàng</a></div></div>';
            }
            
            // Check if product is out of stock
            if (maxQuantity <= 0) {
                console.warn('Product is out of stock');
            }
        </script>


        <!-- Enhanced Product Detail Scripts -->
        <script>
            // Global variables
            let selectedRating = 0;
            let isInWishlist = false;

            // Quantity controls
            document.querySelector('.btn-minus').addEventListener('click', function() {
                const quantityInput = document.getElementById('quantity');
                let value = parseInt(quantityInput.value);
                if (value > 1) {
                    quantityInput.value = value - 1;
                }
            });

            document.querySelector('.btn-plus').addEventListener('click', function() {
                const quantityInput = document.getElementById('quantity');
                let value = parseInt(quantityInput.value);
                if (value < maxQuantity) {
                    quantityInput.value = value + 1;
                }
            });

            // Quantity input validation
            document.getElementById('quantity').addEventListener('change', function() {
                let value = parseInt(this.value);
                if (value < 1) this.value = 1;
                if (value > maxQuantity) this.value = maxQuantity;
            });

            // Buy Now function - Instant checkout for digital goods
            function buyNow() {
                // Check if product is in stock
                if (maxQuantity <= 0) {
                    alert('Sản phẩm đã hết hàng!');
                    return;
                }
                
                const quantity = document.getElementById('quantity').value || 1;
                if (quantity > maxQuantity) {
                    alert('Số lượng vượt quá tồn kho! Còn lại: ' + maxQuantity + ' sản phẩm');
                    return;
                }
                
                if (quantity <= 0) {
                    alert('Vui lòng chọn số lượng!');
                    return;
                }
                
                // Redirect to instant checkout (digital goods)
                window.location.href = '<%= request.getContextPath() %>/checkout/instant?productId=' + productId + '&quantity=' + quantity;
            }

            // Buy Digital Goods function
            function buyDigitalGoods() {
                const quantity = document.getElementById('quantity').value;
                if (quantity > maxQuantity) {
                    alert('Số lượng vượt quá tồn kho!');
                    return;
                }
                
                // Show confirmation for digital goods
                if (confirm('Bạn có chắc chắn muốn mua tài nguyên số này? Sau khi thanh toán, bạn sẽ nhận được mã kích hoạt/tài khoản ngay lập tức.')) {
                    // Redirect to digital goods checkout
                    window.location.href = '<%= request.getContextPath() %>/checkout-digital?product=' + productId + '&quantity=' + quantity;
                }
            }

            // Add to cart function
            function addToCart() {
                const quantity = document.getElementById('quantity').value;
                if (quantity > maxQuantity) {
                    alert('Số lượng vượt quá tồn kho!');
                    return;
                }

                // Show loading state
                const btn = event.target;
                const originalText = btn.innerHTML;
                btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang thêm...';
                btn.disabled = true;

                // Simulate API call
                setTimeout(() => {
                    // Reset button
                    btn.innerHTML = originalText;
                    btn.disabled = false;
                    
                    // Show success message
                    showToast('success', 'Đã thêm ' + quantity + ' sản phẩm vào giỏ hàng!');
                }, 1000);
            }

            // Wishlist functions
            function toggleWishlist(productIdParam = null) {
                const targetProductId = productIdParam || productId;
                const btn = document.getElementById('wishlistBtn');
                const text = document.getElementById('wishlistText');
                
                // Toggle wishlist state
                isInWishlist = !isInWishlist;
                
                        if (isInWishlist) {
                    btn.classList.add('btn-danger');
                    btn.classList.remove('btn-outline-danger');
                    text.textContent = 'Đã yêu thích';
                    showToast('success', 'Đã thêm vào danh sách yêu thích!');
                        } else {
                    btn.classList.remove('btn-danger');
                    btn.classList.add('btn-outline-danger');
                    text.textContent = 'Thêm vào yêu thích';
                    showToast('info', 'Đã xóa khỏi danh sách yêu thích!');
                }
            }

            // Social sharing functions
            function shareProduct() {
                const url = window.location.href;
                const title = "${empty product.name ? 'Sản phẩm' : product.name}";
                const text = 'Xem sản phẩm này trên Gicungco Marketplace';
                
                if (navigator.share) {
                    navigator.share({
                        title: title,
                        text: text,
                        url: url
                    });
                } else {
                    // Fallback: copy to clipboard
                    navigator.clipboard.writeText(url).then(() => {
                        showToast('success', 'Đã sao chép link sản phẩm!');
                    });
                }
            }

            function shareOnFacebook() {
                const url = encodeURIComponent(window.location.href);
                window.open('https://www.facebook.com/sharer/sharer.php?u=' + url, '_blank');
            }

            function shareOnTwitter() {
                const url = encodeURIComponent(window.location.href);
                const text = encodeURIComponent('Xem sản phẩm này trên Gicungco Marketplace');
                window.open('https://twitter.com/intent/tweet?url=' + url + '&text=' + text, '_blank');
            }

            function shareOnWhatsApp() {
                const url = encodeURIComponent(window.location.href);
                const text = encodeURIComponent('Xem sản phẩm này trên Gicungco Marketplace');
                window.open('https://wa.me/?text=' + text + '%20' + url, '_blank');
            }

            // Review functions
            function submitReview() {
                if (selectedRating === 0) {
                    alert('Vui lòng chọn đánh giá!');
                    return;
                }
                
                const comment = document.getElementById('reviewComment').value.trim();
                if (!comment) {
                    alert('Vui lòng nhập nhận xét!');
                    return;
                }

                // Show loading
                const btn = event.target;
                const originalText = btn.innerHTML;
                btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang gửi...';
                btn.disabled = true;

                // Simulate API call
                setTimeout(() => {
                    btn.innerHTML = originalText;
                    btn.disabled = false;
                    
                    // Clear form
                        selectedRating = 0;
                    updateRatingStars();
                    document.getElementById('reviewComment').value = '';
                    
                    showToast('success', 'Cảm ơn bạn đã đánh giá sản phẩm!');
                }, 1500);
            }

            // Rating star interaction
                        document.querySelectorAll('.rating-star').forEach(star => {
                star.addEventListener('click', function() {
                    selectedRating = parseInt(this.dataset.rating);
                    updateRatingStars();
                });
                
                star.addEventListener('mouseover', function() {
                    const rating = parseInt(this.dataset.rating);
                    highlightStars(rating);
                });
            });

            document.querySelector('.rating-input').addEventListener('mouseleave', function() {
                updateRatingStars();
            });

            function updateRatingStars() {
                document.querySelectorAll('.rating-star').forEach((star, index) => {
                    if (index < selectedRating) {
                        star.style.color = '#ffc107';
                    } else {
                            star.style.color = '#ddd';
                    }
                });
            }

            function highlightStars(rating) {
                document.querySelectorAll('.rating-star').forEach((star, index) => {
                    if (index < rating) {
                        star.style.color = '#ffc107';
                    } else {
                        star.style.color = '#ddd';
                    }
                });
            }

            // Product navigation
            function viewProduct(productId) {
                window.location.href = '<%= request.getContextPath() %>/product/' + productId;
            }

            // Seller interaction functions
            function viewSellerProfile(sellerId) {
                window.location.href = '<%= request.getContextPath() %>/seller/' + sellerId;
            }

            function contactSeller(sellerId) {
                // Show contact modal or redirect to chat
                if (confirm('Bạn có muốn liên hệ với người bán này không?')) {
                    window.location.href = '<%= request.getContextPath() %>/chat?seller=' + sellerId;
                }
            }

            // Toast notification function
            function showToast(type, message) {
                const toastContainer = document.createElement('div');
                toastContainer.className = 'toast-container position-fixed top-0 end-0 p-3';
                toastContainer.style.zIndex = '9999';
                
                const toastId = 'toast-' + Date.now();
                const bgClass = type === 'success' ? 'bg-success' : type === 'error' ? 'bg-danger' : 'bg-info';
                
                const iconClass = type === 'success' ? 'check-circle' : type === 'error' ? 'exclamation-circle' : 'info-circle';
                toastContainer.innerHTML = '<div id="' + toastId + '" class="toast ' + bgClass + ' text-white" role="alert">' +
                    '<div class="toast-header ' + bgClass + ' text-white border-0">' +
                        '<i class="fas fa-' + iconClass + ' me-2"></i>' +
                        '<strong class="me-auto">Thông báo</strong>' +
                        '<button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"></button>' +
                    '</div>' +
                    '<div class="toast-body">' + message + '</div>' +
                '</div>';
                
                document.body.appendChild(toastContainer);
                
                const toastElement = document.getElementById(toastId);
                const toast = new bootstrap.Toast(toastElement);
                toast.show();
                
                // Remove toast element after it's hidden
                toastElement.addEventListener('hidden.bs.toast', function() {
                    toastContainer.remove();
                });
            }

            // Logout function
            function logout() {
                if (confirm('Bạn có chắc chắn muốn đăng xuất?')) {
                    window.location.href = '<%= request.getContextPath() %>/logout';
                }
            }

            // Initialize page
            document.addEventListener('DOMContentLoaded', function() {
                console.log('Product Detail Page Loaded');
                
                // Initialize wishlist state
                // This would normally check with the server
                isInWishlist = false;
            });
        </script>
        
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
        <script src="<%= request.getContextPath() %>/assets/js/wishlist.js?v=<%= System.currentTimeMillis() %>"></script>
    </body>
</html>
