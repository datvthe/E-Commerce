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
                                <a href="<%= request.getContextPath() %>/home" class="nav-item nav-link active">Trang chủ</a>
                                <a href="<%= request.getContextPath() %>/products" class="nav-item nav-link">Cửa hàng</a>
                                <a href="#" class="nav-item nav-link">Sản phẩm</a>
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
                            <a href="" class="btn btn-secondary rounded-pill py-2 px-4 px-lg-3 mb-3 mb-md-3 mb-lg-0"><i class="fa fa-mobile-alt me-2"></i> +0123 456 7890</a>
                        </div>
                    </nav>
                        </div>
                    </div>
                                </div>
        <div class="container-fluid carousel bg-light px-0">
            <div class="row g-0 justify-content-end">
                <div class="col-12 col-lg-7 col-xl-9">
                    <div class="header-carousel owl-carousel bg-light py-5">
                        <div class="row g-0 header-carousel-item align-items-center">
                            <div class="col-xl-6 carousel-img wow fadeInLeft" data-wow-delay="0.1s">
                                <img src="<%= request.getContextPath() %>/views/assets/electro/img/carousel-1.png" class="img-fluid w-100" alt="Image">
                            </div>
                            <div class="col-xl-6 carousel-content p-4">
                                <h4 class="text-uppercase fw-bold mb-4 wow fadeInRight" data-wow-delay="0.1s" style="letter-spacing: 3px;">Save Up To A $400</h4>
                                <h1 class="display-3 text-capitalize mb-4 wow fadeInRight" data-wow-delay="0.3s">On Selected Laptops & Desktop Or Smartphone</h1>
                                <p class="text-dark wow fadeInRight" data-wow-delay="0.5s">Terms and Condition Apply</p>
                                <a class="btn btn-primary rounded-pill py-3 px-5 wow fadeInRight" data-wow-delay="0.7s" href="#">Shop Now</a>
                            </div>
                        </div>
                        <div class="row g-0 header-carousel-item align-items-center">
                            <div class="col-xl-6 carousel-img wow fadeInLeft" data-wow-delay="0.1s">
                                <img src="<%= request.getContextPath() %>/views/assets/electro/img/carousel-2.png" class="img-fluid w-100" alt="Image">
                            </div>
                            <div class="col-xl-6 carousel-content p-4">
                                <h4 class="text-uppercase fw-bold mb-4 wow fadeInRight" data-wow-delay="0.1s" style="letter-spacing: 3px;">Save Up To A $200</h4>
                                <h1 class="display-3 text-capitalize mb-4 wow fadeInRight" data-wow-delay="0.3s">On Selected Laptops & Desktop Or Smartphone</h1>
                                <p class="text-dark wow fadeInRight" data-wow-delay="0.5s">Terms and Condition Apply</p>
                                <a class="btn btn-primary rounded-pill py-3 px-5 wow fadeInRight" data-wow-delay="0.7s" href="#">Shop Now</a>
                            </div>
                        </div>
                    </div>
                                </div>
                <div class="col-12 col-lg-5 col-xl-3 wow fadeInRight" data-wow-delay="0.1s">
                    <div class="carousel-header-banner h-100">
                        <img src="<%= request.getContextPath() %>/views/assets/electro/img/header-img.jpg" class="img-fluid w-100 h-100" style="object-fit: cover;" alt="Image">
                        <div class="carousel-banner-offer">
                            <p class="bg-primary text-white rounded fs-5 py-2 px-4 mb-0 me-3">Save $48.00</p>
                            <p class="text-primary fs-5 fw-bold mb-0">Special Offer</p>
                            </div>
                        <div class="carousel-banner">
                            <div class="carousel-banner-content text-center p-4">
                                <a href="#" class="d-block mb-2">SmartPhone</a>
                                <a href="#" class="d-block text-white fs-3">Apple iPad Mini <br> G2356</a>
                                <del class="me-2 text-white fs-5">$1,250.00</del>
                                <span class="text-primary fs-5">$1,050.00</span>
                            </div>
                            <a href="#" class="btn btn-primary rounded-pill py-2 px-4"><i class="fas fa-shopping-cart me-2"></i> Add To Cart</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Services Strip -->
        <div class="container-fluid px-0">
            <div class="row g-0">
                <div class="col-6 col-md-4 col-lg-2 border-start border-end wow fadeInUp" data-wow-delay="0.1s">
                    <div class="p-4"><div class="d-inline-flex align-items-center"><i class="fa fa-sync-alt fa-2x text-primary"></i><div class="ms-4"><h6 class="text-uppercase mb-2">Đổi trả miễn phí</h6><p class="mb-0">Bảo đảm hoàn tiền 30 ngày!</p></div></div></div>
                </div>
                <div class="col-6 col-md-4 col-lg-2 border-end wow fadeInUp" data-wow-delay="0.2s">
                    <div class="p-4"><div class="d-flex align-items-center"><i class="fab fa-telegram-plane fa-2x text-primary"></i><div class="ms-4"><h6 class="text-uppercase mb-2">Miễn phí vận chuyển</h6><p class="mb-0">Miễn phí ship cho mọi đơn hàng</p></div></div></div>
                </div>
                <div class="col-6 col-md-4 col-lg-2 border-end wow fadeInUp" data-wow-delay="0.3s">
                    <div class="p-4"><div class="d-flex align-items-center"><i class="fas fa-life-ring fa-2x text-primary"></i><div class="ms-4"><h6 class="text-uppercase mb-2">Hỗ trợ 24/7</h6><p class="mb-0">Hỗ trợ trực tuyến 24 giờ mỗi ngày</p></div></div></div>
                </div>
                <div class="col-6 col-md-4 col-lg-2 border-end wow fadeInUp" data-wow-delay="0.4s">
                    <div class="p-4"><div class="d-flex align-items-center"><i class="fas fa-credit-card fa-2x text-primary"></i><div class="ms-4"><h6 class="text-uppercase mb-2">Thẻ quà tặng</h6><p class="mb-0">Nhận quà cho đơn hàng trên 1,250,000₫</p></div></div></div>
                </div>
                <div class="col-6 col-md-4 col-lg-2 border-end wow fadeInUp" data-wow-delay="0.5s">
                    <div class="p-4"><div class="d-flex align-items-center"><i class="fas fa-lock fa-2x text-primary"></i><div class="ms-4"><h6 class="text-uppercase mb-2">Thanh toán an toàn</h6><p class="mb-0">Chúng tôi coi trọng bảo mật của bạn</p></div></div></div>
                </div>
                <div class="col-6 col-md-4 col-lg-2 border-end wow fadeInUp" data-wow-delay="0.6s">
                    <div class="p-4"><div class="d-flex align-items-center"><i class="fas fa-blog fa-2x text-primary"></i><div class="ms-4"><h6 class="text-uppercase mb-2">Dịch vụ trực tuyến</h6><p class="mb-0">Đổi trả sản phẩm miễn phí trong 30 ngày</p></div></div></div>
                </div>
            </div>
        </div>

        <!-- Featured Products Section -->
        <div class="container-fluid py-5">
            <div class="container">
                <div class="row g-4">
                    <div class="col-lg-3">
                        <div class="row g-4">
                            <div class="col-12">
                                <div class="input-group">
                                    <input type="search" class="form-control" placeholder="Tìm kiếm sản phẩm..." id="searchInput">
                                    <button class="btn btn-primary" type="button">
                                        <i class="fa fa-search"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="bg-light p-4 rounded">
                                    <h5 class="mb-3">Bộ lọc & Sắp xếp</h5>
                                    
                                    <!-- Category Filter -->
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Danh mục:</label>
                                        <select class="form-select" id="categoryFilter">
                                            <option value="">Tất cả danh mục</option>
                                            <option value="electronics">Điện tử</option>
                                            <option value="fashion">Thời trang</option>
                                            <option value="home">Gia dụng</option>
                                            <option value="sports">Thể thao</option>
                                        </select>
                                    </div>
                                    
                                    <!-- Price Filter -->
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Giá:</label>
                                        <select class="form-select" id="priceFilter">
                                            <option value="">Tất cả mức giá</option>
                                            <option value="0-500000">Dưới 500,000₫</option>
                                            <option value="500000-1000000">500,000₫ - 1,000,000₫</option>
                                            <option value="1000000-5000000">1,000,000₫ - 5,000,000₫</option>
                                            <option value="5000000-">Trên 5,000,000₫</option>
                                        </select>
                                    </div>
                                    
                                    <!-- Rating Filter -->
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Đánh giá:</label>
                                        <select class="form-select" id="ratingFilter">
                                            <option value="">Tất cả đánh giá</option>
                                            <option value="5">5 sao</option>
                                            <option value="4">4 sao trở lên</option>
                                            <option value="3">3 sao trở lên</option>
                                        </select>
                                    </div>
                                    
                                    <!-- Sort -->
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Sắp xếp:</label>
                                        <select class="form-select" id="sortFilter">
                                            <option value="">Mặc định</option>
                                            <option value="price-asc">Giá tăng dần</option>
                                            <option value="price-desc">Giá giảm dần</option>
                                            <option value="rating">Đánh giá cao</option>
                                            <option value="newest">Mới nhất</option>
                                        </select>
                                    </div>
                                    
                                    <button class="btn btn-primary w-100 mb-2" onclick="applyFilters()">
                                        <i class="fas fa-filter me-1"></i> Áp dụng bộ lọc
                                    </button>
                                    <button class="btn btn-outline-secondary w-100" onclick="clearFilters()">
                                        <i class="fas fa-times me-1"></i> Xóa bộ lọc
                                    </button>
                                </div>
                            </div>
                            
                            <!-- AI Suggestions -->
                            <div class="col-12">
                                <div class="bg-primary text-white p-4 rounded">
                                    <h6 class="mb-3"><i class="fas fa-robot me-2"></i>AI Gợi ý</h6>
                                    <div id="aiSuggestions">
                                        <p class="small mb-2">Dựa trên lịch sử tìm kiếm của bạn:</p>
                                        <div class="d-flex flex-wrap gap-1">
                                            <span class="badge bg-light text-dark me-1 mb-1">iPhone 15</span>
                                            <span class="badge bg-light text-dark me-1 mb-1">Laptop Gaming</span>
                                            <span class="badge bg-light text-dark me-1 mb-1">Tai nghe</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-lg-9">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h4 class="mb-0">Sản phẩm nổi bật</h4>
                            <div class="d-flex gap-2">
                                <button class="btn btn-outline-primary btn-sm" onclick="viewMode('grid')">
                                    <i class="fas fa-th"></i>
                                </button>
                                <button class="btn btn-outline-primary btn-sm" onclick="viewMode('list')">
                                    <i class="fas fa-list"></i>
                                </button>
                            </div>
                        </div>
                        
                        <!-- Product Grid -->
                        <div class="row g-4" id="productGrid">
                            <!-- Sample Products -->
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
                            
                            <div class="col-md-6 col-lg-4 col-xl-3">
                                <div class="product-card h-100">
                                    <div class="position-relative">
                                        <img src="<%= request.getContextPath() %>/views/assets/electro/img/product-2.png" class="card-img-top" alt="MacBook Pro">
                                        <div class="position-absolute top-0 end-0 p-2">
                                            <button class="btn btn-sm btn-light rounded-circle">
                                                <i class="fas fa-heart"></i>
                                            </button>
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
                            
                            <div class="col-md-6 col-lg-4 col-xl-3">
                                <div class="product-card h-100">
                                    <div class="position-relative">
                                        <img src="<%= request.getContextPath() %>/views/assets/electro/img/product-3.png" class="card-img-top" alt="Samsung Galaxy">
                                        <div class="position-absolute top-0 end-0 p-2">
                                            <button class="btn btn-sm btn-light rounded-circle">
                                                <i class="fas fa-heart"></i>
                                            </button>
                                        </div>
                                        <div class="position-absolute top-0 start-0 p-2">
                                            <span class="badge bg-success">Mới</span>
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
                                            </div>
                                        </div>
                                        <button class="btn btn-primary w-100 mt-auto" onclick="viewProduct(3)">
                                            <i class="fas fa-eye me-1"></i> Chi tiết
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-6 col-lg-4 col-xl-3">
                                <div class="product-card h-100">
                                    <div class="position-relative">
                                        <img src="<%= request.getContextPath() %>/views/assets/electro/img/product-4.png" class="card-img-top" alt="AirPods Pro">
                                        <div class="position-absolute top-0 end-0 p-2">
                                            <button class="btn btn-sm btn-light rounded-circle">
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
                        </div>
                        
                        <!-- Load More Button -->
                        <div class="text-center mt-5">
                            <button class="btn btn-outline-primary px-5 py-3" onclick="loadMoreProducts()">
                                <i class="fas fa-plus me-2"></i> Xem thêm sản phẩm
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
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
                if (confirm('Bạn có chắc chắn muốn đăng xuất?')) {
                    // Direct redirect to logout endpoint
                    window.location.href = '<%= request.getContextPath() %>/logout';
                }
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
                
                const toastHtml = `
                    <div id="${toastId}" class="toast align-items-center text-white ${bgClass} border-0" role="alert" aria-live="assertive" aria-atomic="true">
                        <div class="d-flex">
                            <div class="toast-body">${message}</div>
                            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                        </div>
                    </div>
                `;
                
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
    </body>
</html>

