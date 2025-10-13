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
                                <h4 class="fw-bold mb-3">${product.name}</h4>
                                <p class="mb-3">Danh mục: ${product.category_id != null ? product.category_id.name : 'Không xác định'}</p>
                                <h5 class="fw-bold mb-3">${product.price}₫</h5>
                                <div class="d-flex mb-4">
                                    <c:forEach begin="1" end="5" var="i">
                                        <i class="fa fa-star ${i <= product.average_rating ? 'text-secondary' : ''}"></i>
                                    </c:forEach>
                                </div>
                                <div class="mb-3">
                                    <div class="btn btn-primary d-inline-block rounded text-white py-1 px-4 me-2"><i class="fab fa-facebook-f me-1"></i> Chia sẻ</div>
                                    <div class="btn btn-secondary d-inline-block rounded text-white py-1 px-4 ms-2"><i class="fab fa-twitter ms-1"></i> Chia sẻ</div>
                                </div>
                                <div class="d-flex flex-column mb-3">
                                    <small>Mã sản phẩm: ${product.product_id}</small>
                                    <small>Còn hàng: <strong class="text-primary">${availableStock} sản phẩm trong kho</strong></small>
                                </div>
                                <p class="mb-4">${product.description}</p>
                                <div class="input-group quantity mb-5" style="width: 100px;">
                                    <div class="input-group-btn">
                                        <button class="btn btn-sm btn-minus rounded-circle bg-light border">
                                            <i class="fa fa-minus"></i>
                                        </button>
                                    </div>
                                    <input type="text" class="form-control form-control-sm text-center border-0" value="1" id="quantity">
                                    <div class="input-group-btn">
                                        <button class="btn btn-sm btn-plus rounded-circle bg-light border">
                                            <i class="fa fa-plus"></i>
                                        </button>
                                    </div>
                                </div>
                                <a href="#" class="btn btn-primary border border-secondary rounded-pill px-4 py-2 mb-4 text-primary" onclick="addToCart()">
                                    <i class="fa fa-shopping-bag me-2 text-white"></i> Thêm vào giỏ
                                </a>
                            </div>
                            <div class="col-lg-12">
                                <nav>
                                    <div class="nav nav-tabs mb-3">
                                        <button class="nav-link active border-white border-bottom-0" type="button" role="tab" id="nav-about-tab" data-bs-toggle="tab" data-bs-target="#nav-about" aria-controls="nav-about" aria-selected="true">Mô tả</button>
                                        <button class="nav-link border-white border-bottom-0" type="button" role="tab" id="nav-mission-tab" data-bs-toggle="tab" data-bs-target="#nav-mission" aria-controls="nav-mission" aria-selected="false">Đánh giá</button>
                                    </div>
                                </nav>
                                <div class="tab-content mb-5">
                                    <div class="tab-pane active" id="nav-about" role="tabpanel" aria-labelledby="nav-about-tab">
                                        <p>${product.description}</p>
                                        <c:if test="${not empty product.seller_id}">
                                            <p><strong>Thông tin người bán:</strong></p>
                                            <p>Tên: ${product.seller_id.full_name}</p>
                                            <p>Email: ${product.seller_id.email}</p>
                                        </c:if>
                                    </div>
                                    <div class="tab-pane" id="nav-mission" role="tabpanel" aria-labelledby="nav-mission-tab">
                                        <div class="d-flex align-items-center mb-4">
                                            <div class="text-center me-4">
                                                <h2>${product.average_rating}</h2>
                                                <div class="d-flex justify-content-center">
                                                    <c:forEach begin="1" end="5" var="i">
                                                        <i class="fa fa-star ${i <= product.average_rating ? 'text-secondary' : ''}"></i>
                                                    </c:forEach>
                                                </div>
                                                <p>Dựa trên ${product.total_reviews} đánh giá</p>
                                            </div>
                                        </div>
                                        <c:if test="${not empty reviews}">
                                            <c:forEach var="review" items="${reviews}">
                                                <div class="border-bottom pb-3 mb-3">
                                                    <div class="d-flex align-items-center mb-2">
                                                        <img src="${review.buyer_id.avatar_url != null ? review.buyer_id.avatar_url : '/views/assets/user/img/avatar.jpg'}" class="rounded-circle me-2" width="40" height="40" alt="Avatar">
                                                        <div>
                                                            <h6 class="mb-0">${review.buyer_id.full_name}</h6>
                                                            <div class="d-flex">
                                                                <c:forEach begin="1" end="5" var="i">
                                                                    <i class="fa fa-star ${i <= review.rating ? 'text-warning' : 'text-muted'}"></i>
                                                                </c:forEach>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <p class="mb-0">${review.comment}</p>
                                                </div>
                                            </c:forEach>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Single Products End -->

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

        <!-- Product Detail Scripts -->
        <script>
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
                quantityInput.value = value + 1;
            });

            // Add to cart function
            function addToCart() {
                const quantity = document.getElementById('quantity').value;
                // Add your cart logic here
                alert('Đã thêm ' + quantity + ' sản phẩm vào giỏ hàng!');
            }

            // Logout function
            function logout() {
                if (confirm('Bạn có chắc chắn muốn đăng xuất?')) {
                    window.location.href = '<%= request.getContextPath() %>/logout';
                }
            }
        </script>
    </body>
</html>