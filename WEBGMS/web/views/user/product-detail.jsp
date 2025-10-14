<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>${product.name} - Gicungco Marketplace</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="" name="keywords">
        <meta content="${product.description}" name="description">
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
    </head>
    <body>
        <div id="spinner" class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
            <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
                <span class="sr-only">Loading...</span>
                        </div>
                            </div>
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
                        <div class="dropdown">
                            <a href="#" class="dropdown-toggle text-muted me-2" data-bs-toggle="dropdown"><small> VND</small></a>
                            <div class="dropdown-menu rounded">
                                <a href="#" class="dropdown-item"> USD</a>
                                <a href="#" class="dropdown-item"> Euro</a>
                            </div>
                                </div>
                        <div class="dropdown">
                            <a href="#" class="dropdown-toggle text-muted mx-2" data-bs-toggle="dropdown"><small> English</small></a>
                            <div class="dropdown-menu rounded">
                                <a href="#" class="dropdown-item"> English</a>
                                <a href="#" class="dropdown-item"> Turkish</a>
                                <a href="#" class="dropdown-item"> Spanol</a>
                                <a href="#" class="dropdown-item"> Italiano</a>
                            </div>
                        </div>
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
                        <a href="#" class="text-muted d-flex align-items-center justify-content-center me-3"><span class="rounded-circle btn-md-square border"><i class="fas fa-random"></i></span></a>
                        <a href="#" class="text-muted d-flex align-items-center justify-content-center me-3"><span class="rounded-circle btn-md-square border"><i class="fas fa-heart"></i></span></a>
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
                                    <li><div class="categories-bars-item"><a href="#">Phụ kiện</a><span>(3)</span></div></li>
                                    <li><div class="categories-bars-item"><a href="#">Điện tử & Máy tính</a><span>(5)</span></div></li>
                                    <li><div class="categories-bars-item"><a href="#">Laptop & Desktop</a><span>(2)</span></div></li>
                                    <li><div class="categories-bars-item"><a href="#">Điện thoại & Máy tính bảng</a><span>(8)</span></div></li>
                                    <li><div class="categories-bars-item"><a href="#">SmartPhone & Smart TV</a><span>(5)</span></div></li>
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
                                    <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">Trang</a>
                                    <div class="dropdown-menu m-0">
                                        <a href="#" class="dropdown-item">Bán chạy</a>
                                        <a href="#" class="dropdown-item">Giỏ hàng</a>
                                        <a href="#" class="dropdown-item">Thanh toán</a>
                                        <a href="#" class="dropdown-item">404 Trang</a>
                                    </div>
                                </div>
                                <a href="#" class="nav-item nav-link me-2">Liên hệ</a>
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
                <li class="breadcrumb-item active text-white">${product.name}</li>
            </ol>
        </div>
        <!-- Single Page Header End -->

        <!-- Single Products Start -->
        <div class="container-fluid shop py-5">
            <div class="container py-5">
                <div class="row g-4">
                    <div class="col-lg-5 col-xl-3 wow fadeInUp" data-wow-delay="0.1s">
                        <div class="input-group w-100 mx-auto d-flex mb-4">
                            <input type="search" class="form-control p-3" placeholder="Từ khóa" aria-describedby="search-icon-1">
                            <span id="search-icon-1" class="input-group-text p-3"><i class="fa fa-search"></i></span>
                        </div>
                        <div class="product-categories mb-4">
                            <h4>Danh mục sản phẩm</h4>
                            <ul class="list-unstyled">
                                <li>
                                    <div class="categories-item">
                                        <a href="#" class="text-dark"><i class="fas fa-apple-alt text-secondary me-2"></i>Phụ kiện</a>
                                        <span>(3)</span>
                                    </div>
                                </li>
                                <li>
                                    <div class="categories-item">
                                        <a href="#" class="text-dark"><i class="fas fa-apple-alt text-secondary me-2"></i>Điện tử & Máy tính</a>
                                        <span>(5)</span>
                                    </div>
                                </li>
                                <li>
                                    <div class="categories-item">
                                        <a href="#" class="text-dark"><i class="fas fa-apple-alt text-secondary me-2"></i>Laptop & Desktop</a>
                                        <span>(2)</span>
                                    </div>
                                </li>
                                <li>
                                    <div class="categories-item">
                                        <a href="#" class="text-dark"><i class="fas fa-apple-alt text-secondary me-2"></i>Điện thoại & Máy tính bảng</a>
                                        <span>(8)</span>
                                    </div>
                                </li>
                                <li>
                                    <div class="categories-item">
                                        <a href="#" class="text-dark"><i class="fas fa-apple-alt text-secondary me-2"></i>SmartPhone & Smart TV</a>
                                        <span>(5)</span>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div class="featured-products mb-4">
                            <h4 class="mb-3">Sản phẩm nổi bật</h4>
                            <c:if test="${not empty similarProducts}">
                                <c:forEach var="similarProduct" items="${similarProducts}" begin="0" end="5">
                                    <div class="featured-product-item">
                                        <div class="rounded me-4" style="width: 100px; height: 100px;">
                                            <img src="<%= request.getContextPath() %>/views/assets/electro/img/product-1.png" class="img-fluid rounded" alt="Image">
                                        </div>
                                        <div>
                                            <h6 class="mb-2">${similarProduct.name}</h6>
                                            <div class="d-flex mb-2">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <i class="fa fa-star text-secondary"></i>
                                </c:forEach>
                            </div>
                                            <div class="d-flex mb-2">
                                                <h5 class="fw-bold me-2">${similarProduct.price}₫</h5>
                                            </div>
                                        </div>
                                            </div>
                                        </c:forEach>
                        </c:if>
                    </div>
                                </div>
                    <div class="col-lg-7 col-xl-9 wow fadeInUp" data-wow-delay="0.1s">
                        <div class="row g-4 single-product">
                            <div class="col-xl-6">
                                <div class="single-carousel owl-carousel">
                                    <c:choose>
                                        <c:when test="${not empty images}">
                                            <c:forEach var="image" items="${images}" varStatus="status">
                                                <div class="single-item" data-dot="<img class='img-fluid' src='${image.url}' alt='${image.alt_text}'>">
                                                    <div class="single-inner bg-light rounded">
                                                        <img src="${image.url}" class="img-fluid rounded" alt="${image.alt_text}">
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="single-item" data-dot="<img class='img-fluid' src='<%= request.getContextPath() %>/views/assets/electro/img/product-1.png' alt='${product.name}'>">
                                                <div class="single-inner bg-light rounded">
                                                    <img src="<%= request.getContextPath() %>/views/assets/electro/img/product-1.png" class="img-fluid rounded" alt="${product.name}">
                                                </div>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-xl-6">
                        <div class="product-info">
                                    <h1 class="product-title mb-3">${product.name}</h1>
                                    
                                    <!-- Product Rating & Reviews -->
                                    <div class="d-flex align-items-center mb-3">
                                        <div class="rating me-3">
                                    <c:forEach begin="1" end="5" var="i">
                                                <i class="fa fa-star ${i <= product.average_rating ? 'text-warning' : 'text-muted'}"></i>
                                    </c:forEach>
                                </div>
                                        <span class="text-muted">(${product.total_reviews} đánh giá)</span>
                                        <span class="badge bg-success ms-3">${product.average_rating}/5</span>
                            </div>
                            
                                    <!-- Price Section -->
                                    <div class="price-section mb-4">
                                        <div class="d-flex align-items-center">
                                            <h2 class="text-primary mb-0 me-3">${product.price}₫</h2>
                                            <c:if test="${product.original_price != null && product.original_price > product.price}">
                                                <span class="text-muted text-decoration-line-through me-2">${product.original_price}₫</span>
                                                <span class="badge bg-danger">-${Math.round((1 - product.price/product.original_price) * 100)}%</span>
                                            </c:if>
                                        </div>
                                    </div>
                                    
                                    <!-- Product Details -->
                                    <div class="product-details mb-4">
                                        <div class="row">
                                            <div class="col-6">
                                                <p class="mb-2"><strong>Danh mục:</strong> ${product.category_id != null ? product.category_id.name : 'Không xác định'}</p>
                                                <p class="mb-2"><strong>Mã sản phẩm:</strong> ${product.product_id}</p>
                                                <c:if test="${isDigitalGoods}">
                                                    <p class="mb-2"><strong>Loại:</strong> <span class="badge bg-info">Tài nguyên số</span></p>
                                                </c:if>
                                            </div>
                                            <div class="col-6">
                                                <p class="mb-2"><strong>Tình trạng:</strong> 
                                <c:choose>
                                    <c:when test="${availableStock > 10}">
                                                            <span class="text-success"><i class="fas fa-check-circle"></i> Còn hàng</span>
                                    </c:when>
                                    <c:when test="${availableStock > 0}">
                                                            <span class="text-warning"><i class="fas fa-exclamation-triangle"></i> Sắp hết hàng</span>
                                    </c:when>
                                    <c:otherwise>
                                                            <span class="text-danger"><i class="fas fa-times-circle"></i> Hết hàng</span>
                                    </c:otherwise>
                                </c:choose>
                                                </p>
                                                <p class="mb-2"><strong>Số lượng:</strong> <span class="text-primary">${availableStock} sản phẩm</span></p>
                                                <c:if test="${isDigitalGoods}">
                                                    <p class="mb-2"><strong>Giao hàng:</strong> <span class="text-success"><i class="fas fa-bolt"></i> Tức thì</span></p>
                                                </c:if>
                            </div>
                            </div>
                            </div>
                            
                            <!-- Seller Information -->
                            <c:if test="${not empty product.seller_id}">
                                        <div class="seller-info mb-4 p-3 bg-light rounded">
                                            <h6 class="mb-2"><i class="fas fa-store me-2"></i>Thông tin người bán</h6>
                                            <div class="d-flex align-items-center">
                                                <div class="seller-avatar me-3">
                                                    <img src="${product.seller_id.avatar_url != null ? product.seller_id.avatar_url : '/views/assets/user/img/avatar.jpg'}" 
                                                         class="rounded-circle" width="40" height="40" alt="Seller Avatar">
                                                </div>
                                                <div>
                                                    <p class="mb-1"><strong>${product.seller_id.full_name}</strong></p>
                                                    <p class="mb-0 text-muted small">${product.seller_id.email}</p>
                                                </div>
                                            </div>
                                </div>
                            </c:if>
                                    
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
                                                   value="1" min="1" max="${availableStock}" id="quantity">
                                            <div class="input-group-btn">
                                                <button class="btn btn-sm btn-plus rounded-circle bg-light border" type="button">
                                                    <i class="fa fa-plus"></i>
                                                </button>
                        </div>
                    </div>
                </div>

                                    <!-- Action Buttons -->
                                    <div class="action-buttons mb-4">
                                        <c:choose>
                                            <c:when test="${isDigitalGoods}">
                                                <!-- Digital Goods Buttons -->
                                                <div class="row g-2">
                                                    <div class="col-md-8">
                                                        <button class="btn btn-success w-100 py-3" onclick="buyDigitalGoods()" 
                                                                ${availableStock == 0 ? 'disabled' : ''}>
                                                            <i class="fas fa-download me-2"></i>Mua và tải ngay
                            </button>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <button class="btn btn-outline-primary w-100 py-3" onclick="addToCart()"
                                                                ${availableStock == 0 ? 'disabled' : ''}>
                                                            <i class="fas fa-shopping-cart me-2"></i>Thêm vào giỏ
                            </button>
                                                    </div>
                                                </div>
                                                <div class="alert alert-info mt-3">
                                                    <i class="fas fa-info-circle me-2"></i>
                                                    <strong>Tài nguyên số:</strong> Sau khi thanh toán, bạn sẽ nhận được mã kích hoạt, tài khoản hoặc file tải xuống ngay lập tức.
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- Physical Goods Buttons -->
                                                <div class="row g-2">
                                                    <div class="col-md-6">
                                                        <button class="btn btn-primary w-100 py-3" onclick="buyNow()" 
                                                                ${availableStock == 0 ? 'disabled' : ''}>
                                                            <i class="fas fa-bolt me-2"></i>Mua ngay
                            </button>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <button class="btn btn-outline-primary w-100 py-3" onclick="addToCart()"
                                                                ${availableStock == 0 ? 'disabled' : ''}>
                                                            <i class="fas fa-shopping-cart me-2"></i>Thêm vào giỏ
                                                        </button>
                                                    </div>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        <div class="row g-2 mt-2">
                                            <div class="col-md-6">
                                                <button class="btn btn-outline-danger w-100 py-2" onclick="toggleWishlist()" id="wishlistBtn">
                                                    <i class="fas fa-heart me-2"></i><span id="wishlistText">Thêm vào yêu thích</span>
                                                </button>
                                            </div>
                                            <div class="col-md-6">
                                                <button class="btn btn-outline-info w-100 py-2" onclick="shareProduct()">
                                                    <i class="fas fa-share-alt me-2"></i>Chia sẻ
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                        
                                    <!-- Social Sharing -->
                                    <div class="social-sharing mb-4">
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
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-12">
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
                                                    <p class="lead">${product.description}</p>
                                                    
                                                    <!-- Product Specifications -->
                                                    <div class="specifications mt-4">
                                                        <h6 class="mb-3">Thông tin chi tiết</h6>
                                                        <div class="table-responsive">
                                                            <table class="table table-striped">
                                                                <tbody>
                                                                    <c:choose>
                                                                        <c:when test="${isDigitalGoods}">
                                                                            <tr>
                                                                                <td><strong>Loại tài nguyên</strong></td>
                                                                                <td>${product.category_id != null ? product.category_id.name : 'Tài nguyên số'}</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td><strong>Định dạng</strong></td>
                                                                                <td>Digital / Số hóa</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td><strong>Giao hàng</strong></td>
                                                                                <td><span class="text-success"><i class="fas fa-bolt"></i> Tức thì</span></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td><strong>Hỗ trợ</strong></td>
                                                                                <td>24/7 qua chat và email</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td><strong>Bảo hành</strong></td>
                                                                                <td>7 ngày đổi trả nếu lỗi</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td><strong>Hướng dẫn</strong></td>
                                                                                <td>Có kèm theo khi mua</td>
                                                                            </tr>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <tr>
                                                                                <td><strong>Thương hiệu</strong></td>
                                                                                <td>${product.brand != null ? product.brand : 'Không xác định'}</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td><strong>Model</strong></td>
                                                                                <td>${product.model != null ? product.model : 'Không xác định'}</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td><strong>Màu sắc</strong></td>
                                                                                <td>${product.color != null ? product.color : 'Không xác định'}</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td><strong>Kích thước</strong></td>
                                                                                <td>${product.dimensions != null ? product.dimensions : 'Không xác định'}</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td><strong>Trọng lượng</strong></td>
                                                                                <td>${product.weight != null ? product.weight : 'Không xác định'}</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td><strong>Bảo hành</strong></td>
                                                                                <td>${product.warranty != null ? product.warranty : '12 tháng'}</td>
                                                                            </tr>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-lg-4">
                                                <div class="bg-light p-4 rounded">
                                                    <h6 class="mb-3">Thông tin bổ sung</h6>
                                                    <ul class="list-unstyled">
                                                        <c:choose>
                                                            <c:when test="${isDigitalGoods}">
                                                                <li class="mb-2"><i class="fas fa-bolt text-success me-2"></i>Giao hàng tức thì</li>
                                                                <li class="mb-2"><i class="fas fa-download text-success me-2"></i>Tải xuống ngay sau khi mua</li>
                                                                <li class="mb-2"><i class="fas fa-shield-alt text-success me-2"></i>Bảo hành 7 ngày</li>
                                                                <li class="mb-2"><i class="fas fa-headset text-success me-2"></i>Hỗ trợ 24/7</li>
                                                                <li class="mb-2"><i class="fas fa-file-alt text-success me-2"></i>Hướng dẫn sử dụng</li>
                                                                <li class="mb-2"><i class="fas fa-redo text-success me-2"></i>Đổi trả nếu lỗi</li>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <li class="mb-2"><i class="fas fa-truck text-success me-2"></i>Miễn phí vận chuyển</li>
                                                                <li class="mb-2"><i class="fas fa-undo text-success me-2"></i>Đổi trả trong 30 ngày</li>
                                                                <li class="mb-2"><i class="fas fa-shield-alt text-success me-2"></i>Bảo hành chính hãng</li>
                                                                <li class="mb-2"><i class="fas fa-headset text-success me-2"></i>Hỗ trợ 24/7</li>
                                                            </c:otherwise>
                                                        </c:choose>
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
                                                    <h2 class="text-primary mb-2">${product.average_rating}</h2>
                                                    <div class="stars mb-3">
                                                <c:forEach begin="1" end="5" var="i">
                                                            <i class="fa fa-star ${i <= product.average_rating ? 'text-warning' : 'text-muted'}"></i>
                                                </c:forEach>
                                            </div>
                                                    <p class="text-muted">Dựa trên ${product.total_reviews} đánh giá</p>
                                                    
                                                    <!-- Rating Distribution -->
                                                    <div class="rating-breakdown mt-4">
                                        <c:forEach begin="5" end="1" step="-1" var="rating">
                                            <div class="d-flex align-items-center mb-2">
                                                <span class="me-2">${rating} <i class="fas fa-star text-warning"></i></span>
                                                <div class="progress flex-grow-1 me-2" style="height: 8px;">
                                                                    <c:choose>
                                                                        <c:when test="${rating == 5}"><div class="progress-bar" style="width: 80%"></div></c:when>
                                                                        <c:when test="${rating == 4}"><div class="progress-bar" style="width: 60%"></div></c:when>
                                                                        <c:when test="${rating == 3}"><div class="progress-bar" style="width: 30%"></div></c:when>
                                                                        <c:when test="${rating == 2}"><div class="progress-bar" style="width: 10%"></div></c:when>
                                                                        <c:otherwise><div class="progress-bar" style="width: 5%"></div></c:otherwise>
                                                                    </c:choose>
                                                </div>
                                                                <span class="text-muted small">
                                                                    <c:choose>
                                                                        <c:when test="${rating == 5}">80</c:when>
                                                                        <c:when test="${rating == 4}">60</c:when>
                                                                        <c:when test="${rating == 3}">30</c:when>
                                                                        <c:when test="${rating == 2}">10</c:when>
                                                                        <c:otherwise>5</c:otherwise>
                                                                    </c:choose>
                                                                </span>
                                            </div>
                                        </c:forEach>
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
                                    <c:choose>
                                        <c:when test="${not empty reviews}">
                                            <c:forEach var="review" items="${reviews}">
                                                                <div class="review-item border-bottom pb-3 mb-3">
                                                                    <div class="d-flex align-items-start">
                                                        <img src="${review.buyer_id.avatar_url != null ? review.buyer_id.avatar_url : '/views/assets/user/img/avatar.jpg'}" 
                                                                             class="rounded-circle me-3" width="50" height="50" alt="Avatar">
                                                                        <div class="flex-grow-1">
                                                                            <div class="d-flex justify-content-between align-items-start mb-2">
                                                                                <div>
                                                                                    <h6 class="mb-1">${review.buyer_id.full_name}</h6>
                                                                                    <div class="stars">
                                                            <c:forEach begin="1" end="5" var="i">
                                                                                            <i class="fa fa-star ${i <= review.rating ? 'text-warning' : 'text-muted'}"></i>
                                                            </c:forEach>
                                                        </div>
                                                                                </div>
                                                                                <small class="text-muted">${review.createdAt}</small>
                                                    </div>
                                                    <p class="mb-0">${review.comment}</p>
                                                                        </div>
                                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                                            <div class="text-center py-5">
                                                                <i class="fas fa-comments fa-3x text-muted mb-3"></i>
                                                                <p class="text-muted">Chưa có đánh giá nào. Hãy là người đầu tiên đánh giá sản phẩm này!</p>
                                                            </div>
                                        </c:otherwise>
                                    </c:choose>
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
                        <p class="text-muted mb-4">Dựa trên sở thích và lịch sử mua hàng của bạn, chúng tôi gợi ý những sản phẩm phù hợp</p>
                        
                        <div class="row g-4">
                            <!-- Similar Product 1 -->
                            <div class="col-md-6 col-lg-3">
                                <div class="product-card h-100">
                                    <div class="position-relative">
                                        <img src="<%= request.getContextPath() %>/views/assets/electro/img/product-2.png" class="card-img-top" alt="MacBook Pro">
                                        <div class="position-absolute top-0 end-0 p-2">
                                            <button class="btn btn-sm btn-light rounded-circle" onclick="toggleWishlist(2)">
                                                <i class="fas fa-heart"></i>
                                            </button>
                                        </div>
                                        <div class="position-absolute top-0 start-0 p-2">
                                            <span class="badge bg-success">Mới</span>
                                    </div>
                                </div>
                                    <div class="card-body d-flex flex-column">
                                        <h6 class="card-title">MacBook Pro M3 14 inch</h6>
                                        <div class="d-flex align-items-center mb-2">
                                            <div class="text-warning me-2">
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="far fa-star"></i>
                        </div>
                                            <small class="text-muted">(89)</small>
                    </div>
                                        <div class="d-flex align-items-center justify-content-between mb-3">
                                            <div>
                                                <span class="h5 text-primary mb-0">45,000,000₫</span>
            </div>
        </div>
                                        <button class="btn btn-primary w-100 mt-auto" onclick="viewProduct(2)">
                                            <i class="fas fa-eye me-1"></i> Chi tiết
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Similar Product 2 -->
                            <div class="col-md-6 col-lg-3">
                                <div class="product-card h-100">
                                    <div class="position-relative">
                                        <img src="<%= request.getContextPath() %>/views/assets/electro/img/product-3.png" class="card-img-top" alt="Samsung Galaxy">
                                        <div class="position-absolute top-0 end-0 p-2">
                                            <button class="btn btn-sm btn-light rounded-circle" onclick="toggleWishlist(3)">
                                                <i class="fas fa-heart"></i>
                                            </button>
                                        </div>
                                        <div class="position-absolute top-0 start-0 p-2">
                                            <span class="badge bg-danger">-20%</span>
                                        </div>
                                    </div>
                                    <div class="card-body d-flex flex-column">
                                        <h6 class="card-title">Samsung Galaxy S24 Ultra</h6>
                                        <div class="d-flex align-items-center mb-2">
                                            <div class="text-warning me-2">
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                            </div>
                                            <small class="text-muted">(156)</small>
                                        </div>
                                        <div class="d-flex align-items-center justify-content-between mb-3">
                                            <div>
                                                <span class="h5 text-primary mb-0">32,000,000₫</span>
                                                <small class="text-muted d-block"><del>40,000,000₫</del></small>
                                            </div>
                                        </div>
                                        <button class="btn btn-primary w-100 mt-auto" onclick="viewProduct(3)">
                                            <i class="fas fa-eye me-1"></i> Chi tiết
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Similar Product 3 -->
                            <div class="col-md-6 col-lg-3">
                                <div class="product-card h-100">
                                    <div class="position-relative">
                                        <img src="<%= request.getContextPath() %>/views/assets/electro/img/product-4.png" class="card-img-top" alt="AirPods Pro">
                                        <div class="position-absolute top-0 end-0 p-2">
                                            <button class="btn btn-sm btn-light rounded-circle" onclick="toggleWishlist(4)">
                                                <i class="fas fa-heart"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="card-body d-flex flex-column">
                                        <h6 class="card-title">AirPods Pro 2nd Gen</h6>
                                        <div class="d-flex align-items-center mb-2">
                                            <div class="text-warning me-2">
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="far fa-star"></i>
                                            </div>
                                            <small class="text-muted">(203)</small>
                                        </div>
                                        <div class="d-flex align-items-center justify-content-between mb-3">
                                            <div>
                                                <span class="h5 text-primary mb-0">6,500,000₫</span>
                                            </div>
                                        </div>
                                        <button class="btn btn-primary w-100 mt-auto" onclick="viewProduct(4)">
                                            <i class="fas fa-eye me-1"></i> Chi tiết
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Similar Product 4 -->
                            <div class="col-md-6 col-lg-3">
                                <div class="product-card h-100">
                                    <div class="position-relative">
                                        <img src="<%= request.getContextPath() %>/views/assets/electro/img/product-5.png" class="card-img-top" alt="iPad Air">
                                        <div class="position-absolute top-0 end-0 p-2">
                                            <button class="btn btn-sm btn-light rounded-circle" onclick="toggleWishlist(5)">
                                                <i class="fas fa-heart"></i>
                                            </button>
                                        </div>
                                        <div class="position-absolute top-0 start-0 p-2">
                                            <span class="badge bg-info">Hot</span>
                                        </div>
                                    </div>
                                    <div class="card-body d-flex flex-column">
                                        <h6 class="card-title">iPad Air 5th Gen</h6>
                                        <div class="d-flex align-items-center mb-2">
                                            <div class="text-warning me-2">
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                            </div>
                                            <small class="text-muted">(127)</small>
                                        </div>
                                        <div class="d-flex align-items-center justify-content-between mb-3">
                                            <div>
                                                <span class="h5 text-primary mb-0">18,500,000₫</span>
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
            const productId = <%= product.product_id != null ? product.product_id : 0 %>;
            const maxQuantity = <%= availableStock != null ? availableStock : 0 %>;
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

            // Buy Now function
            function buyNow() {
                const quantity = document.getElementById('quantity').value;
                if (quantity > maxQuantity) {
                    alert('Số lượng vượt quá tồn kho!');
                    return;
                }
                
                // Redirect to checkout with product and quantity
                window.location.href = '<%= request.getContextPath() %>/checkout?product=' + productId + '&quantity=' + quantity;
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
                const title = '<%= product.name %>';
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
    </body>
</html>
