<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Electro - Electronics Website Template</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="" name="keywords">
        <meta content="" name="description">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500;600;700&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">
        <link href="<%= request.getContextPath() %>/views/assets/electro/lib/animate/animate.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath() %>/views/assets/electro/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath() %>/views/assets/electro/css/bootstrap.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath() %>/views/assets/electro/css/style.css" rel="stylesheet">
        <style>
            /* Orange Theme Override */
            .bg-primary {
                background: linear-gradient(135deg, #ff6b35, #f7931e) !important;
            }
            .btn-primary {
                background: linear-gradient(135deg, #ff6b35, #f7931e) !important;
                border-color: #ff6b35 !important;
            }
            .btn-primary:hover {
                background: linear-gradient(135deg, #e55a2b, #e0841a) !important;
                border-color: #e55a2b !important;
            }
            .text-primary {
                color: #ff6b35 !important;
            }
            .border-primary {
                border-color: #ff6b35 !important;
            }
            .btn-outline-primary {
                color: #ff6b35 !important;
                border-color: #ff6b35 !important;
            }
            .btn-outline-primary:hover {
                background-color: #ff6b35 !important;
                border-color: #ff6b35 !important;
            }
            .navbar-nav .nav-link:hover {
                color: #ff6b35 !important;
            }
            .category-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 25px rgba(255, 107, 53, 0.3);
            }
            .product-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 25px rgba(255, 107, 53, 0.3);
            }
        </style>
        
        <!-- Custom Styles for Digital Resources -->
        <style>
            .category-card {
                transition: all 0.3s ease;
                cursor: pointer;
            }
            .category-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 25px rgba(0,0,0,0.1) !important;
            }
            .product-card {
                transition: all 0.3s ease;
                border: 1px solid #e9ecef;
            }
            .product-card:hover {
                transform: translateY(-3px);
                box-shadow: 0 8px 20px rgba(0,0,0,0.1) !important;
            }
            .product-image {
                border-radius: 0.5rem 0.5rem 0 0;
            }
            .banner-content h1 {
                background: linear-gradient(45deg, #fff, #e3f2fd);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
            }
            .badge {
                font-size: 0.75rem;
                padding: 0.5rem 0.75rem;
            }
            .btn-success {
                background: linear-gradient(45deg, #28a745, #20c997);
                border: none;
            }
            .btn-success:hover {
                background: linear-gradient(45deg, #218838, #1ea085);
                transform: translateY(-1px);
            }
            
            /* Wishlist button styling */
            .btn-outline-warning {
                color: #fd7e14 !important;
                border-color: #fd7e14 !important;
            }
            .btn-outline-warning:hover {
                background-color: #fd7e14 !important;
                border-color: #fd7e14 !important;
                color: white !important;
            }
            
            /* Badge styling for cart and wishlist counters */
            .badge {
                font-size: 0.6rem;
                min-width: 18px;
                height: 18px;
                line-height: 18px;
                padding: 0;
            }
        </style>
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
                        
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <a href="<%= request.getContextPath() %>/wishlist" class="btn btn-outline-warning btn-sm px-3 me-2" data-bs-toggle="tooltip" title="Danh sách yêu thích"><i class="fas fa-heart me-1"></i>Wishlist</a>
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
                    <form action="<%= request.getContextPath() %>/products" method="get" class="position-relative ps-4">
                        <div class="d-flex border rounded-pill">
                            <input class="form-control border-0 rounded-pill w-100 py-3" 
                                   type="text" 
                                   name="search" 
                                   placeholder="Tìm kiếm sản phẩm..." 
                                   value="${param.search}">
                            <select class="form-select text-dark border-0 border-start rounded-0 p-3" 
                                    name="category" 
                                    style="width: 200px;">
                                <option value="">Tất cả danh mục</option>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.categoryId}" ${param.category == cat.categoryId ? 'selected' : ''}>
                                        ${cat.name}
                                    </option>
                                </c:forEach>
                            </select>
                            <button type="submit" class="btn btn-primary rounded-pill py-3 px-5" style="border: 0;">
                                <i class="fas fa-search"></i>
                            </button>
                        </div>
                    </form>
                </div>
                <div class="col-md-4 col-lg-3 text-center text-lg-end">
                    <div class="d-inline-flex align-items-center">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <a href="<%= request.getContextPath() %>/wishlist" class="text-muted d-flex align-items-center justify-content-center me-3" data-bs-toggle="tooltip" title="Danh sách yêu thích">
                                    <span class="rounded-circle btn-md-square border position-relative">
                                        <i class="fas fa-heart"></i>
                                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-warning" id="wishlistCount">0</span>
                                    </span>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="<%= request.getContextPath() %>/login" class="text-muted d-flex align-items-center justify-content-center me-3" data-bs-toggle="tooltip" title="Đăng nhập để sử dụng wishlist">
                                    <span class="rounded-circle btn-md-square border"><i class="fas fa-heart"></i></span>
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
        <div class="container-fluid nav-bar p-0">
            <div class="row gx-0 px-5 align-items-center" style="background: linear-gradient(135deg, #ff6b35, #f7931e);">
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
                                <a href="<%= request.getContextPath() %>/home" class="nav-item nav-link active">Trang chủ</a>
                                <a href="<%= request.getContextPath() %>/products" class="nav-item nav-link">Cửa hàng</a>
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
                                <a href="<%= request.getContextPath() %>/contact" class="nav-item nav-link">Hỗ trợ</a>
                                <a href="<%= request.getContextPath() %>/views/chat/chat.jsp" class="nav-item nav-link me-2">
                                    <i class="fas fa-comments me-1"></i>Chat
                                </a>
                                <div class="nav-item dropdown d-block d-lg-none mb-3">
                                    <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">Tất cả danh mục</a>
                                    <div class="dropdown-menu m-0">
                                        <ul class="list-unstyled categories-bars">
                                            <li><div class="categories-bars-item"><a href="#"><i class="fas fa-graduation-cap me-2"></i>Học tập</a><span>(1,250)</span></div></li>
                                            <li><div class="categories-bars-item"><a href="#"><i class="fas fa-play-circle me-2"></i>Xem phim</a><span>(850)</span></div></li>
                                            <li><div class="categories-bars-item"><a href="#"><i class="fas fa-laptop-code me-2"></i>Phần mềm</a><span>(2,100)</span></div></li>
                                            <li><div class="categories-bars-item"><a href="#"><i class="fas fa-file-alt me-2"></i>Tài liệu</a><span>(680)</span></div></li>
                                            <li><div class="categories-bars-item"><a href="#"><i class="fas fa-gift me-2"></i>Thẻ cào</a><span>(1,500)</span></div></li>
                                        </ul>
                            </div>
                                </div>
                            </div>
                            <a href="" class="btn btn-secondary rounded-pill py-2 px-4 px-lg-3 mb-3 mb-md-3 mb-lg-0"><i class="fa fa-mobile-alt me-2"></i> +0123 456 7890</a>
                        </div>
                    </nav>
                        </div>
                    </div>
                                </div>
        <!-- Main Banner Section -->
        <div class="container-fluid bg-primary text-white py-5">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-lg-8">
                        <div class="banner-content">
                            <h1 class="display-4 fw-bold mb-4">Tài Nguyên Online</h1>
                            <h2 class="h3 mb-4">Thẻ cào, Tài khoản, Phần mềm & Nhiều hơn nữa</h2>
                            <p class="lead mb-4">Khám phá hàng nghìn tài nguyên digital chất lượng cao với giá tốt nhất thị trường</p>
                            <div class="d-flex gap-3">
                                <a href="<%= request.getContextPath() %>/products" class="btn btn-light btn-lg px-4">
                                    <i class="fas fa-shopping-bag me-2"></i>Mua ngay
                                </a>
                                <a href="<%= request.getContextPath() %>/categories" class="btn btn-outline-light btn-lg px-4">
                                    <i class="fas fa-th-large me-2"></i>Xem danh mục
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="banner-image text-center">
                            <i class="fas fa-download display-1 text-white-50"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Featured Categories Section -->
        <div class="container-fluid py-5 bg-light" id="categories">
            <div class="container">
                <div class="text-center mb-5">
                    <h2 class="display-5 fw-bold text-dark">DANH MỤC NỔI BẬT</h2>
                    <p class="lead text-muted">Khám phá các loại tài nguyên digital phổ biến nhất</p>
                </div>
                <div class="row g-4">
                    <div class="col-lg-2 col-md-4 col-6">
                        <div class="category-card text-center p-4 bg-white rounded-3 shadow-sm h-100">
                            <div class="category-icon mb-3">
                                <i class="fas fa-graduation-cap fa-3x text-primary"></i>
                            </div>
                            <h5 class="fw-bold">Học tập</h5>
                            <p class="text-muted small">Khóa học, tài liệu, ebook</p>
                            <span class="badge bg-primary">1,250+ sản phẩm</span>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-4 col-6">
                        <div class="category-card text-center p-4 bg-white rounded-3 shadow-sm h-100">
                            <div class="category-icon mb-3">
                                <i class="fas fa-play-circle fa-3x text-danger"></i>
                            </div>
                            <h5 class="fw-bold">Xem phim</h5>
                            <p class="text-muted small">Netflix, Disney+, HBO</p>
                            <span class="badge bg-danger">850+ sản phẩm</span>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-4 col-6">
                        <div class="category-card text-center p-4 bg-white rounded-3 shadow-sm h-100">
                            <div class="category-icon mb-3">
                                <i class="fas fa-laptop-code fa-3x text-success"></i>
                            </div>
                            <h5 class="fw-bold">Phần mềm</h5>
                            <p class="text-muted small">Adobe, Office, Antivirus</p>
                            <span class="badge bg-success">2,100+ sản phẩm</span>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-4 col-6">
                        <div class="category-card text-center p-4 bg-white rounded-3 shadow-sm h-100">
                            <div class="category-icon mb-3">
                                <i class="fas fa-file-alt fa-3x text-warning"></i>
                            </div>
                            <h5 class="fw-bold">Tài liệu</h5>
                            <p class="text-muted small">Template, báo cáo, CV</p>
                            <span class="badge bg-warning">680+ sản phẩm</span>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-4 col-6">
                        <div class="category-card text-center p-4 bg-white rounded-3 shadow-sm h-100">
                            <div class="category-icon mb-3">
                                <i class="fas fa-ellipsis-h fa-3x text-info"></i>
                            </div>
                            <h5 class="fw-bold">Khác</h5>
                            <p class="text-muted small">Thẻ cào, tài khoản game</p>
                            <span class="badge bg-info">3,200+ sản phẩm</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Featured Products Section -->
        <div class="container-fluid py-5">
            <div class="container">
                <div class="text-center mb-5">
                    <h2 class="display-5 fw-bold text-dark">SẢN PHẨM NỔI BẬT</h2>
                    <p class="lead text-muted">Những tài nguyên digital được yêu thích nhất</p>
                </div>
                
                <!-- Search Bar -->
                <div class="row justify-content-center mb-5">
                    <div class="col-lg-8">
                        <form id="searchForm" onsubmit="performSearch(event)">
                            <div class="input-group input-group-lg">
                                <input type="search" class="form-control" placeholder="Tìm kiếm tài nguyên digital..." id="searchInput" name="search">
                                <select class="form-select" style="max-width: 200px;" id="categorySelect" name="category">
                                    <option value="">Tất cả danh mục</option>
                                    <option value="learning">Học tập</option>
                                    <option value="entertainment">Xem phim</option>
                                    <option value="software">Phần mềm</option>
                                    <option value="documents">Tài liệu</option>
                                    <option value="other">Khác</option>
                                </select>
                                <button class="btn btn-primary" type="submit">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
                
                <!-- Product Grid -->
                <div class="row g-4" id="productGrid">
                    <!-- Product 1: Thẻ cào Viettel -->
                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <div class="product-card h-100 bg-white rounded-3 shadow-sm overflow-hidden">
                            <div class="position-relative">
                                <div class="product-image bg-gradient text-white text-center py-5" style="background: linear-gradient(135deg, #ff6b35, #f7931e);">
                                    <i class="fas fa-gift fa-4x"></i>
                                </div>
                                <div class="position-absolute top-0 end-0 p-2">
                                    <button class="btn btn-sm btn-light rounded-circle" onclick="toggleWishlist(1, this)" data-bs-toggle="tooltip" title="Thêm vào wishlist">
                                        <i class="fas fa-heart"></i>
                                    </button>
                                </div>
                                <div class="position-absolute top-0 start-0 p-2">
                                    <span class="badge bg-danger">Bán chạy</span>
                                </div>
                            </div>
                            <div class="card-body d-flex flex-column p-3">
                                <h6 class="card-title fw-bold mb-1">Thẻ cào Viettel 100K</h6>
                                <p class="text-muted small mb-2">Nạp trực tiếp tự động</p>
                                <div class="d-flex align-items-center mb-2">
                                    <div class="text-warning me-2" style="font-size: 0.85rem;">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                    </div>
                                    <small class="text-muted">5.0 (1,250)</small>
                                </div>
                                <div class="mb-2">
                                    <div class="d-flex align-items-baseline">
                                        <span class="h5 text-primary mb-0 fw-bold">95.000₫</span>
                                        <del class="ms-2 text-muted small">100.000₫</del>
                                    </div>
                                    <small class="text-success"><i class="fas fa-bolt"></i> Giao ngay lập tức</small>
                                </div>
                                <button class="btn btn-primary w-100 mt-auto" onclick="viewProduct(1)">
                                    <i class="fas fa-shopping-bag me-1"></i> Mua ngay
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Product 2: Netflix Premium -->
                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <div class="product-card h-100 bg-white rounded-3 shadow-sm overflow-hidden">
                            <div class="position-relative">
                                <div class="product-image bg-gradient text-white text-center py-5" style="background: linear-gradient(135deg, #e50914, #b20710);">
                                    <i class="fas fa-play-circle fa-4x"></i>
                                </div>
                                <div class="position-absolute top-0 end-0 p-2">
                                    <button class="btn btn-sm btn-light rounded-circle" onclick="toggleWishlist(2, this)" data-bs-toggle="tooltip" title="Thêm vào wishlist">
                                        <i class="fas fa-heart"></i>
                                    </button>
                                </div>
                                <div class="position-absolute top-0 start-0 p-2">
                                    <span class="badge bg-warning text-dark">Hot</span>
                                </div>
                            </div>
                            <div class="card-body d-flex flex-column p-3">
                                <h6 class="card-title fw-bold mb-1">Netflix Premium 1 tháng</h6>
                                <p class="text-muted small mb-2">4K UHD, 4 thiết bị</p>
                                <div class="d-flex align-items-center mb-2">
                                    <div class="text-warning me-2" style="font-size: 0.85rem;">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star-half-alt"></i>
                                    </div>
                                    <small class="text-muted">4.8 (890)</small>
                                </div>
                                <div class="mb-2">
                                    <div class="d-flex align-items-baseline">
                                        <span class="h5 text-primary mb-0 fw-bold">120.000₫</span>
                                        <del class="ms-2 text-muted small">180.000₫</del>
                                    </div>
                                    <small class="text-success"><i class="fas fa-bolt"></i> Giao trong 5 phút</small>
                                </div>
                                <button class="btn btn-primary w-100 mt-auto" onclick="viewProduct(2)">
                                    <i class="fas fa-shopping-bag me-1"></i> Mua ngay
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Product 3: Microsoft Office -->
                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <div class="product-card h-100 bg-white rounded-3 shadow-sm overflow-hidden">
                            <div class="position-relative">
                                <div class="product-image bg-gradient text-white text-center py-5" style="background: linear-gradient(135deg, #0078d4, #005a9e);">
                                    <i class="fas fa-file-word fa-4x"></i>
                                </div>
                                <div class="position-absolute top-0 end-0 p-2">
                                    <button class="btn btn-sm btn-light rounded-circle" onclick="toggleWishlist(3, this)" data-bs-toggle="tooltip" title="Thêm vào wishlist">
                                        <i class="fas fa-heart"></i>
                                    </button>
                                </div>
                                <div class="position-absolute top-0 start-0 p-2">
                                    <span class="badge bg-info">Mới</span>
                                </div>
                            </div>
                            <div class="card-body d-flex flex-column p-3">
                                <h6 class="card-title fw-bold mb-1">Microsoft Office 365</h6>
                                <p class="text-muted small mb-2">1 năm, 5 thiết bị</p>
                                <div class="d-flex align-items-center mb-2">
                                    <div class="text-warning me-2" style="font-size: 0.85rem;">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                    </div>
                                    <small class="text-muted">5.0 (2,100)</small>
                                </div>
                                <div class="mb-2">
                                    <div class="d-flex align-items-baseline">
                                        <span class="h5 text-primary mb-0 fw-bold">450.000₫</span>
                                        <del class="ms-2 text-muted small">599.000₫</del>
                                    </div>
                                    <small class="text-success"><i class="fas fa-bolt"></i> Key bản quyền vĩnh viễn</small>
                                </div>
                                <button class="btn btn-primary w-100 mt-auto" onclick="viewProduct(3)">
                                    <i class="fas fa-shopping-bag me-1"></i> Mua ngay
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Product 4: Spotify Premium -->
                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <div class="product-card h-100 bg-white rounded-3 shadow-sm overflow-hidden">
                            <div class="position-relative">
                                <div class="product-image bg-gradient text-white text-center py-5" style="background: linear-gradient(135deg, #1ed760, #1db954);">
                                    <i class="fas fa-music fa-4x"></i>
                                </div>
                                <div class="position-absolute top-0 end-0 p-2">
                                    <button class="btn btn-sm btn-light rounded-circle" onclick="toggleWishlist(4, this)" data-bs-toggle="tooltip" title="Thêm vào wishlist">
                                        <i class="fas fa-heart"></i>
                                    </button>
                                </div>
                                <div class="position-absolute top-0 start-0 p-2">
                                    <span class="badge bg-success">Giá tốt</span>
                                </div>
                            </div>
                            <div class="card-body d-flex flex-column p-3">
                                <h6 class="card-title fw-bold mb-1">Spotify Premium</h6>
                                <p class="text-muted small mb-2">3 tháng, không quảng cáo</p>
                                <div class="d-flex align-items-center mb-2">
                                    <div class="text-warning me-2" style="font-size: 0.85rem;">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                    </div>
                                    <small class="text-muted">4.9 (1,580)</small>
                                </div>
                                <div class="mb-2">
                                    <div class="d-flex align-items-baseline">
                                        <span class="h5 text-primary mb-0 fw-bold">85.000₫</span>
                                        <del class="ms-2 text-muted small">120.000₫</del>
                                    </div>
                                    <small class="text-success"><i class="fas fa-bolt"></i> Giao tự động 24/7</small>
                                </div>
                                <button class="btn btn-primary w-100 mt-auto" onclick="viewProduct(4)">
                                    <i class="fas fa-shopping-bag me-1"></i> Mua ngay
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Product 5: Canva Pro -->
                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <div class="product-card h-100 bg-white rounded-3 shadow-sm overflow-hidden">
                            <div class="position-relative">
                                <div class="product-image bg-gradient text-white text-center py-5" style="background: linear-gradient(135deg, #00c4cc, #7d2ae8);">
                                    <i class="fas fa-palette fa-4x"></i>
                                </div>
                                <div class="position-absolute top-0 end-0 p-2">
                                    <button class="btn btn-sm btn-light rounded-circle" onclick="toggleWishlist(5, this)" data-bs-toggle="tooltip" title="Thêm vào wishlist">
                                        <i class="fas fa-heart"></i>
                                    </button>
                                </div>
                                <div class="position-absolute top-0 start-0 p-2">
                                    <span class="badge bg-primary">Pro</span>
                                </div>
                            </div>
                            <div class="card-body d-flex flex-column p-3">
                                <h6 class="card-title fw-bold mb-1">Canva Pro 1 năm</h6>
                                <p class="text-muted small mb-2">Full tính năng thiết kế</p>
                                <div class="d-flex align-items-center mb-2">
                                    <div class="text-warning me-2" style="font-size: 0.85rem;">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star-half-alt"></i>
                                    </div>
                                    <small class="text-muted">4.7 (945)</small>
                                </div>
                                <div class="mb-2">
                                    <div class="d-flex align-items-baseline">
                                        <span class="h5 text-primary mb-0 fw-bold">199.000₫</span>
                                        <del class="ms-2 text-muted small">299.000₫</del>
                                    </div>
                                    <small class="text-success"><i class="fas fa-bolt"></i> Kích hoạt ngay</small>
                                </div>
                                <button class="btn btn-primary w-100 mt-auto" onclick="viewProduct(5)">
                                    <i class="fas fa-shopping-bag me-1"></i> Mua ngay
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Product 6: YouTube Premium -->
                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <div class="product-card h-100 bg-white rounded-3 shadow-sm overflow-hidden">
                            <div class="position-relative">
                                <div class="product-image bg-gradient text-white text-center py-5" style="background: linear-gradient(135deg, #ff0000, #cc0000);">
                                    <i class="fab fa-youtube fa-4x"></i>
                                </div>
                                <div class="position-absolute top-0 end-0 p-2">
                                    <button class="btn btn-sm btn-light rounded-circle" onclick="toggleWishlist(6, this)" data-bs-toggle="tooltip" title="Thêm vào wishlist">
                                        <i class="fas fa-heart"></i>
                                    </button>
                                </div>
                                <div class="position-absolute top-0 start-0 p-2">
                                    <span class="badge bg-danger">Trending</span>
                                </div>
                            </div>
                            <div class="card-body d-flex flex-column p-3">
                                <h6 class="card-title fw-bold mb-1">YouTube Premium</h6>
                                <p class="text-muted small mb-2">2 tháng, không QC</p>
                                <div class="d-flex align-items-center mb-2">
                                    <div class="text-warning me-2" style="font-size: 0.85rem;">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                    </div>
                                    <small class="text-muted">4.9 (1,340)</small>
                                </div>
                                <div class="mb-2">
                                    <div class="d-flex align-items-baseline">
                                        <span class="h5 text-primary mb-0 fw-bold">95.000₫</span>
                                        <del class="ms-2 text-muted small">140.000₫</del>
                                    </div>
                                    <small class="text-success"><i class="fas fa-bolt"></i> Giao ngay lập tức</small>
                                </div>
                                <button class="btn btn-primary w-100 mt-auto" onclick="viewProduct(6)">
                                    <i class="fas fa-shopping-bag me-1"></i> Mua ngay
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Product 7: Grammarly Premium -->
                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <div class="product-card h-100 bg-white rounded-3 shadow-sm overflow-hidden">
                            <div class="position-relative">
                                <div class="product-image bg-gradient text-white text-center py-5" style="background: linear-gradient(135deg, #15c39a, #00b386);">
                                    <i class="fas fa-spell-check fa-4x"></i>
                                </div>
                                <div class="position-absolute top-0 end-0 p-2">
                                    <button class="btn btn-sm btn-light rounded-circle" onclick="toggleWishlist(7, this)" data-bs-toggle="tooltip" title="Thêm vào wishlist">
                                        <i class="fas fa-heart"></i>
                                    </button>
                                </div>
                                <div class="position-absolute top-0 start-0 p-2">
                                    <span class="badge bg-info">Học tập</span>
                                </div>
                            </div>
                            <div class="card-body d-flex flex-column p-3">
                                <h6 class="card-title fw-bold mb-1">Grammarly Premium</h6>
                                <p class="text-muted small mb-2">1 năm, kiểm tra ngữ pháp AI</p>
                                <div class="d-flex align-items-center mb-2">
                                    <div class="text-warning me-2" style="font-size: 0.85rem;">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                    </div>
                                    <small class="text-muted">5.0 (680)</small>
                                </div>
                                <div class="mb-2">
                                    <div class="d-flex align-items-baseline">
                                        <span class="h5 text-primary mb-0 fw-bold">350.000₫</span>
                                        <del class="ms-2 text-muted small">499.000₫</del>
                                    </div>
                                    <small class="text-success"><i class="fas fa-bolt"></i> Giao tự động</small>
                                </div>
                                <button class="btn btn-primary w-100 mt-auto" onclick="viewProduct(7)">
                                    <i class="fas fa-shopping-bag me-1"></i> Mua ngay
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Product 8: Adobe Photoshop -->
                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <div class="product-card h-100 bg-white rounded-3 shadow-sm overflow-hidden">
                            <div class="position-relative">
                                <div class="product-image bg-gradient text-white text-center py-5" style="background: linear-gradient(135deg, #31a8ff, #0066cc);">
                                    <i class="fas fa-image fa-4x"></i>
                                </div>
                                <div class="position-absolute top-0 end-0 p-2">
                                    <button class="btn btn-sm btn-light rounded-circle" onclick="toggleWishlist(8, this)" data-bs-toggle="tooltip" title="Thêm vào wishlist">
                                        <i class="fas fa-heart"></i>
                                    </button>
                                </div>
                                <div class="position-absolute top-0 start-0 p-2">
                                    <span class="badge bg-warning text-dark">Best Seller</span>
                                </div>
                            </div>
                            <div class="card-body d-flex flex-column p-3">
                                <h6 class="card-title fw-bold mb-1">Adobe Photoshop CC</h6>
                                <p class="text-muted small mb-2">1 năm, bản quyền chính hãng</p>
                                <div class="d-flex align-items-center mb-2">
                                    <div class="text-warning me-2" style="font-size: 0.85rem;">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                    </div>
                                    <small class="text-muted">5.0 (3,200)</small>
                                </div>
                                <div class="mb-2">
                                    <div class="d-flex align-items-baseline">
                                        <span class="h5 text-primary mb-0 fw-bold">650.000₫</span>
                                        <del class="ms-2 text-muted small">899.000₫</del>
                                    </div>
                                    <small class="text-success"><i class="fas fa-bolt"></i> Kích hoạt trọn đời</small>
                                </div>
                                <button class="btn btn-primary w-100 mt-auto" onclick="viewProduct(8)">
                                    <i class="fas fa-shopping-bag me-1"></i> Mua ngay
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Load More Button -->
                <div class="text-center mt-5">
                    <button class="btn btn-outline-primary px-5 py-3" onclick="loadMoreProducts()">
                        <i class="fas fa-plus me-2"></i> Xem thêm sản phẩm
                    </button>
                </div>
            </div>
        </div>

        <!-- Enhanced Footer -->
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
                            <a class="text-white-50 mb-2" href="#"><i class="fa fa-angle-right me-2"></i>Khuyến mãi</a>
                            <a class="text-white-50 mb-2" href="#"><i class="fa fa-angle-right me-2"></i>Hỗ trợ khách hàng</a>
                            <a class="text-white-50 mb-2" href="#"><i class="fa fa-angle-right me-2"></i>Chương trình thành viên</a>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <h5 class="text-white text-uppercase mb-4">Hỗ trợ & FAQ</h5>
                        <div class="d-flex flex-column justify-content-start">
                            <a class="text-white-50 mb-2" href="#"><i class="fa fa-angle-right me-2"></i>Trung tâm trợ giúp</a>
                            <a class="text-white-50 mb-2" href="#"><i class="fa fa-angle-right me-2"></i>Câu hỏi thường gặp</a>
                            <a class="text-white-50 mb-2" href="#"><i class="fa fa-angle-right me-2"></i>Hướng dẫn mua hàng</a>
                            <a class="text-white-50 mb-2" href="#"><i class="fa fa-angle-right me-2"></i>Chính sách đổi trả</a>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <h5 class="text-white text-uppercase mb-4">Chính sách</h5>
                        <div class="d-flex flex-column justify-content-start">
                            <a class="text-white-50 mb-2" href="#"><i class="fa fa-angle-right me-2"></i>Chính sách bảo mật</a>
                            <a class="text-white-50 mb-2" href="#"><i class="fa fa-angle-right me-2"></i>Điều khoản sử dụng</a>
                            <a class="text-white-50 mb-2" href="#"><i class="fa fa-angle-right me-2"></i>Chính sách vận chuyển</a>
                            <a class="text-white-50 mb-2" href="#"><i class="fa fa-angle-right me-2"></i>Chính sách thanh toán</a>
                        </div>
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
                                <a href="#">Liên hệ</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        <%-- Include Notification Modal --%>
        <%@ include file="notification-modal.jsp" %>
        
        <!-- Back to Top -->
        <a href="#" class="btn btn-primary btn-lg-square back-to-top"><i class="bi bi-arrow-up"></i></a>

        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/lib/wow/wow.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/lib/easing/easing.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/lib/waypoints/waypoints.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/lib/counterup/counterup.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/lib/owlcarousel/owl.carousel.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/js/main.js"></script>
        
        <!-- Logout Function -->
        <script>
            function logout() {
                showWarningModal('Logout?', 'Are you sure you want to logout from your account?');
                
                // Update modal buttons for logout confirmation
                const modal = document.getElementById('notificationModal');
                const footerButton = modal.querySelector('.modal-footer .btn');
                
                // Replace the default button with confirm/cancel buttons
                footerButton.outerHTML = `
                    <button type="button" class="btn btn-secondary rounded-pill px-4 me-2" data-bs-dismiss="modal">
                        <i class="fas fa-times me-2"></i>Cancel
                    </button>
                    <button type="button" class="btn btn-danger rounded-pill px-4" onclick="confirmLogout()">
                        <i class="fas fa-sign-out-alt me-2"></i>Logout
                    </button>
                `;
            }
            
            function confirmLogout() {
                // Close modal first
                const modal = bootstrap.Modal.getInstance(document.getElementById('notificationModal'));
                modal.hide();
                
                // Show loading message
                showInfoModal('Processing...', 'Please wait, logging out!');
                
                // Redirect to logout after a short delay
                setTimeout(() => {
                    window.location.href = '<%= request.getContextPath() %>/logout';
                }, 1000);
            }
            
            function updateLogoutUI() {
                // Update top bar to show login/register buttons
                const topBarUserSection = document.querySelector('.col-lg-4.text-center.text-lg-end .d-inline-flex');
                if (topBarUserSection) {
                    // Remove account and logout buttons
                    const accountBtn = topBarUserSection.querySelector('a[href*="/profile"]');
                    const logoutBtn = topBarUserSection.querySelector('a[onclick="logout()"]');
                    if (accountBtn) accountBtn.remove();
                    if (logoutBtn) logoutBtn.remove();
                    
                    // Add login/register buttons
                    const loginBtn = document.createElement('a');
                    loginBtn.href = '<%= request.getContextPath() %>/login';
                    loginBtn.className = 'btn btn-outline-primary btn-sm px-3 me-2';
                    loginBtn.innerHTML = '<i class="bi bi-person me-1"></i>Đăng nhập';
                    
                    const registerBtn = document.createElement('a');
                    registerBtn.href = '<%= request.getContextPath() %>/register';
                    registerBtn.className = 'btn btn-outline-success btn-sm px-3';
                    registerBtn.innerHTML = '<i class="bi bi-person-plus me-1"></i>Đăng ký';
                    
                    topBarUserSection.appendChild(loginBtn);
                    topBarUserSection.appendChild(registerBtn);
                }
                
                // Update navbar to show login/register buttons
                const navbarUserSection = document.querySelector('.navbar-nav.ms-auto');
                if (navbarUserSection) {
                    // Remove account and logout links
                    const accountLink = navbarUserSection.querySelector('a[href*="/profile"]');
                    const logoutLink = navbarUserSection.querySelector('a[onclick="logout()"]');
                    if (accountLink) accountLink.remove();
                    if (logoutLink) logoutLink.remove();
                    
                    // Add login/register links
                    const loginLink = document.createElement('a');
                    loginLink.href = '<%= request.getContextPath() %>/login';
                    loginLink.className = 'nav-item nav-link me-2';
                    loginLink.innerHTML = '<i class="bi bi-person me-1"></i>Đăng nhập';
                    
                    const registerLink = document.createElement('a');
                    registerLink.href = '<%= request.getContextPath() %>/register';
                    registerLink.className = 'nav-item nav-link me-2';
                    registerLink.innerHTML = '<i class="bi bi-person-plus me-1"></i>Đăng ký';
                    
                    // Insert before the mobile categories dropdown
                    const mobileDropdown = navbarUserSection.querySelector('.nav-item.dropdown.d-block.d-lg-none');
                    if (mobileDropdown) {
                        navbarUserSection.insertBefore(loginLink, mobileDropdown);
                        navbarUserSection.insertBefore(registerLink, mobileDropdown);
                    } else {
                        navbarUserSection.appendChild(loginLink);
                        navbarUserSection.appendChild(registerLink);
                    }
                }
            }
            
            function showToast(message, type) {
                // Create toast element
                const toastContainer = document.createElement('div');
                toastContainer.className = 'position-fixed top-0 end-0 p-3';
                toastContainer.style.zIndex = '1080';
                document.body.appendChild(toastContainer);
                
                const toastId = 'toast-' + Date.now();
                const bgClass = type === 'success' ? 'bg-success' : 'bg-danger';
                
                const toastHtml = '<div id="' + toastId + '" class="toast align-items-center text-white ' + bgClass + ' border-0" role="alert" aria-live="assertive" aria-atomic="true">' +
                    '<div class="d-flex">' +
                        '<div class="toast-body">' + message + '</div>' +
                        '<button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>' +
                    '</div>' +
                '</div>';
                
                toastContainer.innerHTML = toastHtml;
                
                // Show toast
                const toastElement = document.getElementById(toastId);
                const toast = new bootstrap.Toast(toastElement, {delay: 3000});
                toast.show();
                
                // Remove toast element after it's hidden
                toastElement.addEventListener('hidden.bs.toast', function() {
                    toastContainer.remove();
                });
            }
        </script>

        <!-- Enhanced Buyer Homepage JavaScript -->
        <script>
            // Search with AI autocomplete
            let searchTimeout;
            document.getElementById('searchInput').addEventListener('input', function() {
                clearTimeout(searchTimeout);
                const query = this.value;
                
                if (query.length >= 2) {
                    searchTimeout = setTimeout(() => {
                        showSearchSuggestions(query);
                    }, 300);
                } else {
                    hideSearchSuggestions();
                }
            });
            
            function showSearchSuggestions(query) {
                const suggestions = [
                    'iPhone 15 Pro Max',
                    'MacBook Pro M3',
                    'Samsung Galaxy S24',
                    'AirPods Pro',
                    'iPad Air',
                    'Apple Watch'
                ].filter(item => item.toLowerCase().includes(query.toLowerCase()));
                
                const aiSuggestions = document.getElementById('aiSuggestions');
                if (suggestions.length > 0) {
                    let suggestionsHtml = '<p class="small mb-2">Gợi ý cho "' + query + '":</p>';
                    suggestionsHtml += '<div class="d-flex flex-wrap gap-1">';
                    suggestions.forEach(function(suggestion) {
                        suggestionsHtml += '<span class="badge bg-light text-dark me-1 mb-1" onclick="searchProduct(\'' + suggestion + '\')">' + suggestion + '</span>';
                    });
                    suggestionsHtml += '</div>';
                    aiSuggestions.innerHTML = suggestionsHtml;
                }
            }
            
            function hideSearchSuggestions() {
                const aiSuggestions = document.getElementById('aiSuggestions');
                aiSuggestions.innerHTML = '<p class="small mb-2">Dựa trên lịch sử tìm kiếm của bạn:</p>' +
                    '<div class="d-flex flex-wrap gap-1">' +
                        '<span class="badge bg-light text-dark me-1 mb-1">iPhone 15</span>' +
                        '<span class="badge bg-light text-dark me-1 mb-1">Laptop Gaming</span>' +
                        '<span class="badge bg-light text-dark me-1 mb-1">Tai nghe</span>' +
                    '</div>';
            }
            
            function searchProduct(query) {
                document.getElementById('searchInput').value = query;
                performSearch();
            }
            
            // Perform search - redirect to products page with search query
            function performSearch(event) {
                if (event) {
                    event.preventDefault();
                }
                
                const searchInput = document.getElementById('searchInput').value.trim();
                const categorySelect = document.getElementById('categorySelect').value;
                
                // Build URL parameters
                const params = new URLSearchParams();
                if (searchInput) {
                    params.append('search', searchInput);
                }
                if (categorySelect) {
                    params.append('category', categorySelect);
                }
                
                // Redirect to products page with search parameters
                const url = '<%= request.getContextPath() %>/products' + (params.toString() ? '?' + params.toString() : '');
                window.location.href = url;
            }
            
            // Filter and Sort Functions
            function applyFilters() {
                const category = document.getElementById('categoryFilter').value;
                const price = document.getElementById('priceFilter').value;
                const rating = document.getElementById('ratingFilter').value;
                const sort = document.getElementById('sortFilter').value;
                const search = document.getElementById('searchInput').value;
                
                const productGrid = document.getElementById('productGrid');
                productGrid.innerHTML = '<div class="col-12 text-center"><div class="spinner-border text-primary" role="status"><span class="sr-only">Đang tải...</span></div></div>';
                
                setTimeout(() => {
                    loadFilteredProducts(category, price, rating, sort, search);
                }, 1000);
            }
            
            function clearFilters() {
                document.getElementById('categoryFilter').value = '';
                document.getElementById('priceFilter').value = '';
                document.getElementById('ratingFilter').value = '';
                document.getElementById('sortFilter').value = '';
                document.getElementById('searchInput').value = '';
                applyFilters();
            }
            
            function loadFilteredProducts(category, price, rating, sort, search) {
                const productGrid = document.getElementById('productGrid');
                productGrid.innerHTML = `
                    <div class="col-md-6 col-lg-4 col-xl-3">
                        <div class="product-card h-100">
                            <div class="position-relative">
                                <img src="<%= request.getContextPath() %>/views/assets/electro/img/product-1.png" class="card-img-top" alt="iPhone 15 Pro">
                                <div class="position-absolute top-0 end-0 p-2">
                                    <button class="btn btn-sm btn-light rounded-circle">
                                        <i class="fas fa-heart"></i>
                                    </button>
                                </div>
                                <div class="position-absolute top-0 start-0 p-2">
                                    <span class="badge bg-danger">-15%</span>
                                </div>
                            </div>
                            <div class="card-body d-flex flex-column">
                                <h6 class="card-title">iPhone 15 Pro Max 256GB</h6>
                                <div class="d-flex align-items-center mb-2">
                                    <div class="text-warning me-2">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                    </div>
                                    <small class="text-muted">(128)</small>
                                </div>
                                <div class="d-flex align-items-center justify-content-between mb-3">
                                    <div>
                                        <span class="h5 text-primary mb-0">28,500,000₫</span>
                                        <small class="text-muted d-block"><del>33,500,000₫</del></small>
                                    </div>
                                </div>
                                <button class="btn btn-primary w-100 mt-auto" onclick="viewProduct(1)">
                                    <i class="fas fa-eye me-1"></i> Chi tiết
                                </button>
                            </div>
                        </div>
            </div>
                `;
            }
            
            function viewMode(mode) {
                const productGrid = document.getElementById('productGrid');
                if (mode === 'list') {
                    productGrid.className = 'row g-4 list-view';
                } else {
                    productGrid.className = 'row g-4';
                }
            }
            
            function viewProduct(productId) {
                window.location.href = '<%= request.getContextPath() %>/product/' + productId;
            }
            
            function loadMoreProducts() {
                const loadMoreBtn = event.target;
                loadMoreBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i> Đang tải...';
                
                setTimeout(() => {
                    loadMoreBtn.innerHTML = '<i class="fas fa-plus me-2"></i> Xem thêm sản phẩm';
                }, 2000);
            }
            
            // Initialize wishlist functionality
            function loadWishlistCount() {
                <c:if test="${not empty sessionScope.user}">
                    $.ajax({
                        url: '<%= request.getContextPath() %>/api/wishlist/count',
                        method: 'GET',
                        success: function(response) {
                            if (response.success) {
                                const wishlistCountElement = document.getElementById('wishlistCount');
                                if (wishlistCountElement) {
                                    wishlistCountElement.textContent = response.count;
                                    if (response.count > 0) {
                                        wishlistCountElement.style.display = 'inline-block';
                                    } else {
                                        wishlistCountElement.style.display = 'none';
                                    }
                                }
                            }
                        },
                        error: function() {
                            console.log('Could not load wishlist count');
                        }
                    });
                </c:if>
            }
            
            // Add to wishlist function for product cards
            function toggleWishlist(productId, element) {
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        $.ajax({
                            url: '<%= request.getContextPath() %>/wishlist',
                            method: 'POST',
                            data: {
                                action: 'toggle',
                                productId: productId
                            },
                            success: function(response) {
                                if (response.success) {
                                    // Update heart icon
                                    const heartIcon = element.querySelector('i');
                                    if (response.message.includes('added')) {
                                        heartIcon.className = 'fas fa-heart text-danger';
                                        element.setAttribute('title', 'Remove from wishlist');
                                        showToast('Added to wishlist!', 'success');
                                    } else {
                                        heartIcon.className = 'fas fa-heart';
                                        element.setAttribute('title', 'Add to wishlist');
                                        showToast('Removed from wishlist!', 'success');
                                    }
                                    // Update wishlist count
                                    loadWishlistCount();
                                } else {
                                    showToast('Error: ' + response.message, 'error');
                                }
                            },
                            error: function() {
                                showToast('Failed to update wishlist. Please try again.', 'error');
                            }
                        });
                    </c:when>
                    <c:otherwise>
                        showWarningModal('Login Required', 'Please login to use wishlist feature.');
                        // Update modal button to redirect to login
                        setTimeout(function() {
                            const modal = document.getElementById('notificationModal');
                            const footerButton = modal.querySelector('.modal-footer .btn');
                            footerButton.onclick = function() {
                                window.location.href = '<%= request.getContextPath() %>/login';
                            };
                            footerButton.innerHTML = '<i class="fas fa-sign-in-alt me-2"></i>Login Now';
                        }, 100);
                    </c:otherwise>
                </c:choose>
            }
            
            // Initialize page
            document.addEventListener('DOMContentLoaded', function() {
                console.log('Gicungco Marketplace - Buyer Homepage Loaded');
                
                // Initialize tooltips
                var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                    return new bootstrap.Tooltip(tooltipTriggerEl);
                });
                
                // Load wishlist count for logged-in users
                loadWishlistCount();
                
                // Handle server-side messages - with duplicate prevention
                const notificationShown = sessionStorage.getItem('notificationShown');
                
                <c:if test="${not empty sessionScope.message}">
                    if (!notificationShown || notificationShown !== 'message_${sessionScope.message}') {
                        showSuccessModal('Notice!', '${sessionScope.message}');
                        sessionStorage.setItem('notificationShown', 'message_${sessionScope.message}');
                    }
                    <c:remove var="message" scope="session" />
                </c:if>
                
                <c:if test="${not empty sessionScope.success}">
                    if (!notificationShown || notificationShown !== 'success_${sessionScope.success}') {
                        showSuccessModal('Success!', '${sessionScope.success}');
                        sessionStorage.setItem('notificationShown', 'success_${sessionScope.success}');
                    }
                    <c:remove var="success" scope="session" />
                </c:if>
                
                <c:if test="${not empty sessionScope.error}">
                    if (!notificationShown || notificationShown !== 'error_${sessionScope.error}') {
                        showErrorModal('Error!', '${sessionScope.error}');
                        sessionStorage.setItem('notificationShown', 'error_${sessionScope.error}');
                    }
                    <c:remove var="error" scope="session" />
                </c:if>
                
                // Clear the notification flag after modal is shown
                setTimeout(() => {
                    sessionStorage.removeItem('notificationShown');
                }, 5000);
                
                // Chat widget initialized below
            });
        </script>
        
        <!-- Chat Widget -->
        <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/chat-widget.css?v=<%= System.currentTimeMillis() %>" />
        <jsp:include page="../component/chat-widget.jsp" />
        <script src="<%= request.getContextPath() %>/assets/js/chat-widget.js?v=<%= System.currentTimeMillis() %>"></script>
        <script src="<%= request.getContextPath() %>/assets/js/aibot-widget.js?v=<%= System.currentTimeMillis() %>"></script>
        <script src="<%= request.getContextPath() %>/assets/js/message-actions.js?v=<%= System.currentTimeMillis() %>"></script>
        <script>
            // Initialize chat widget after DOM is ready
            document.addEventListener('DOMContentLoaded', function() {
                try {
                    const userId = ${sessionScope.user != null ? sessionScope.user.user_id : -1};
                    const userRole = '${sessionScope.user != null ? sessionScope.user.default_role : "guest"}';
                    if (typeof initChatWidget === 'function') {
                        initChatWidget('<%= request.getContextPath() %>', userId, userRole);
                        console.log('[Chat Widget] Initialized for home.jsp');
                    }
                } catch(e) {
                    console.error('[Chat Widget] Init error:', e);
                }
            });
        </script>
    </body>
</html>

