<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <title>Gicungco Marketplace System</title>
    </head>

    <body>

        <jsp:include page="/views/component/header.jsp" />
        
        <!-- Welcome Message for Logged-in Users -->
        <c:if test="${not empty sessionScope.user}">
            <div class="container-fluid py-3 bg-primary text-white">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <h4 class="mb-1">Chào mừng trở lại, ${sessionScope.user.full_name}!</h4>
                            <p class="mb-0">Khám phá những sản phẩm mới nhất và ưu đãi hấp dẫn</p>
                        </div>
                        <div class="col-md-4 text-md-end">
                            <a href="<%= request.getContextPath() %>/login" class="btn btn-light btn-lg">
                                <i class="fas fa-shopping-bag me-2"></i>Mua sắm ngay
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
        
        <!-- Banner / Hero Start -->
        <div class="container-fluid p-0">
            <div class="header-carousel owl-carousel">
                <div class="carousel-item">
                    <div class="carousel-header-banner">
                        <img class="img-fluid w-100" src="<%= request.getContextPath() %>/views/assets/user/img/carousel-1.jpg" alt="Promotion 1">
                        <div class="carousel-banner">
                            <h1 class="text-white display-4 mb-3">Khuyến mãi lớn</h1>
                            <p class="text-white-50 mb-4">Giảm đến 50% cho sản phẩm nổi bật</p>
                            <a href="<%= request.getContextPath() %>/login" class="btn btn-secondary rounded-pill px-4 py-2">Xem khuyến mãi</a>
                        </div>
                    </div>
                </div>
                <div class="carousel-item">
                    <div class="carousel-header-banner">
                        <img class="img-fluid w-100" src="<%= request.getContextPath() %>/views/assets/user/img/carousel-2.jpg" alt="Promotion 2">
                        <div class="carousel-banner">
                            <h1 class="text-white display-4 mb-3">Sản phẩm mới</h1>
                            <p class="text-white-50 mb-4">Khám phá bộ sưu tập mới nhất</p>
                            <a href="<%= request.getContextPath() %>/products" class="btn btn-secondary rounded-pill px-4 py-2">Mua ngay</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Banner / Hero End -->

        <!-- Promotions strip Start -->
        <div class="container-fluid py-5">
            <div class="container">
                <div class="row g-4">
                    <div class="col-md-6 col-lg-4">
                        <div class="bg-primary rounded p-4 h-100 text-white">
                            <h4 class="mb-2">Miễn phí vận chuyển</h4>
                            <p class="mb-0">Cho đơn hàng từ 500k</p>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-4">
                        <div class="bg-secondary rounded p-4 h-100 text-white">
                            <h4 class="mb-2">Giảm 20%</h4>
                            <p class="mb-0">Khi đăng ký tài khoản mới</p>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-4">
                        <div class="bg-dark rounded p-4 h-100 text-white">
                            <h4 class="mb-2">Flash Sale</h4>
                            <p class="mb-0">Từ 8h - 12h hằng ngày</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Promotions strip End -->

        <!-- Product Grid Start -->
        <div class="container-fluid product py-5">
            <div class="container py-5">
                <h3 class="text-center mb-5">DANH MỤC NỔI BẬT</h3>
                <div class="row g-4 mb-5 justify-content-center text-center">
                    <div class="col-6 col-sm-4 col-md-3 col-lg-2 d-flex">
                        <a href="#" class="btn btn-primary btn-category flex-fill">Học tập</a>
                    </div>
                    <div class="col-6 col-sm-4 col-md-3 col-lg-2 d-flex">
                        <a href="#" class="btn btn-primary btn-category flex-fill">Xem phim</a>
                    </div>
                    <div class="col-6 col-sm-4 col-md-3 col-lg-2 d-flex">
                        <a href="#" class="btn btn-primary btn-category flex-fill">Phần mềm</a>
                    </div>
                    <div class="col-6 col-sm-4 col-md-3 col-lg-2 d-flex">
                        <a href="#" class="btn btn-primary btn-category flex-fill">Tài liệu</a>
                    </div>
                    <div class="col-6 col-sm-4 col-md-3 col-lg-2 d-flex">
                        <a href="#" class="btn btn-primary btn-category flex-fill">Khác</a>
                    </div>
                </div>
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="mb-0">Sản phẩm</h2>
                    <div class="d-flex gap-2">
                        <select class="form-select" id="sortSelect" style="width: 180px;">
                            <option value="">Sắp xếp: Mặc định</option>
                            <option value="priceAsc">Giá tăng dần</option>
                            <option value="priceDesc">Giá giảm dần</option>
                            <option value="ratingDesc">Đánh giá cao</option>
                        </select>
                        <select class="form-select" id="categorySelect" style="width: 180px;">
                            <option value="">Danh mục</option>
                            <option>Điện thoại</option>
                            <option>Laptop</option>
                            <option>Phụ kiện</option>
                        </select>
                    </div>
                </div>

                <div class="row g-4">
                    <div class="col-sm-6 col-md-4 col-lg-3">
                        <div class="product-item border rounded">
                            <div class="product-item-inner border-bottom p-3">
                                <div class="product-item-inner-item">
                                    <img src="<%= request.getContextPath() %>/views/assets/user/img/product-1.png" class="img-fluid w-100" alt="">
                                    <div class="product-details">
                                        <a href="<%= request.getContextPath() %>/login-a"><i class="fa fa-eye"></i></a>
                                    </div>
                                </div>
                            </div>
                            <div class="p-3">
                                <a href="<%= request.getContextPath() %>/login-a" class="d-block h6">Sản phẩm A</a>
                                <div class="mb-2">
                                    <span class="text-primary fw-bold me-2">350.000đ</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between">
                                    <div class="text-warning">
                                        <i class="fa fa-star"></i>
                                        <i class="fa fa-star"></i>
                                        <i class="fa fa-star"></i>
                                        <i class="fa fa-star-half-alt"></i>
                                        <i class="far fa-star"></i>
                                    </div>
                                    <a href="<%= request.getContextPath() %>/login" class="btn btn-primary btn-sm rounded-pill">Chi tiết</a>
                                </div>
                            </div>
                            <div class="product-item-add p-3 border-top">
                                <a href="<%= request.getContextPath() %>/login" class="btn btn-secondary w-100 rounded-pill">Add to Cart</a>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-6 col-md-4 col-lg-3">
                        <div class="product-item border rounded">
                            <div class="product-item-inner border-bottom p-3">
                                <div class="product-item-inner-item">
                                    <img src="<%= request.getContextPath() %>/views/assets/user/img/product-2.png" class="img-fluid w-100" alt="">
                                    <div class="product-details">
                                        <a href="<%= request.getContextPath() %>/login"><i class="fa fa-eye"></i></a>
                                    </div>
                                </div>
                            </div>
                            <div class="p-3">
                                <a href="<%= request.getContextPath() %>/login" class="d-block h6">Sản phẩm B</a>
                                <div class="mb-2">
                                    <span class="text-primary fw-bold me-2">590.000đ</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between">
                                    <div class="text-warning">
                                        <i class="fa fa-star"></i>
                                        <i class="fa fa-star"></i>
                                        <i class="fa fa-star"></i>
                                        <i class="fa fa-star"></i>
                                        <i class="far fa-star"></i>
                                    </div>
                                    <a href="<%= request.getContextPath() %>/login" class="btn btn-primary btn-sm rounded-pill">Chi tiết</a>
                                </div>
                            </div>
                            <div class="product-item-add p-3 border-top">
                                <a href="<%= request.getContextPath() %>/login" class="btn btn-secondary w-100 rounded-pill">Add to Cart</a>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-6 col-md-4 col-lg-3">
                        <div class="product-item border rounded">
                            <div class="product-item-inner border-bottom p-3">
                                <div class="product-item-inner-item">
                                    <img src="<%= request.getContextPath() %>/views/assets/user/img/product-3.png" class="img-fluid w-100" alt="">
                                    <div class="product-details">
                                        <a href="<%= request.getContextPath() %>/login"><i class="fa fa-eye"></i></a>
                                    </div>
                                </div>
                            </div>
                            <div class="p-3">
                                <a href="<%= request.getContextPath() %>/login" class="d-block h6">Sản phẩm C</a>
                                <div class="mb-2">
                                    <span class="text-primary fw-bold me-2">1.290.000đ</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between">
                                    <div class="text-warning">
                                        <i class="fa fa-star"></i>
                                        <i class="fa fa-star"></i>
                                        <i class="fa fa-star"></i>
                                        <i class="far fa-star"></i>
                                        <i class="far fa-star"></i>
                                    </div>
                                    <a href="<%= request.getContextPath() %>/login" class="btn btn-primary btn-sm rounded-pill">Chi tiết</a>
                                </div>
                            </div>
                            <div class="product-item-add p-3 border-top">
                                <a href="<%= request.getContextPath() %>/login" class="btn btn-secondary w-100 rounded-pill">Add to Cart</a>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-6 col-md-4 col-lg-3">
                        <div class="product-item border rounded">
                            <div class="product-item-inner border-bottom p-3">
                                <div class="product-item-inner-item">
                                    <img src="<%= request.getContextPath() %>/views/assets/user/img/product-4.png" class="img-fluid w-100" alt="">
                                    <div class="product-details">
                                        <a href="<%= request.getContextPath() %>/login"><i class="fa fa-eye"></i></a>
                                    </div>
                                </div>
                            </div>
                            <div class="p-3">
                                <a href="<%= request.getContextPath() %>/login" class="d-block h6">Sản phẩm D</a>
                                <div class="mb-2">
                                    <span class="text-primary fw-bold me-2">2.490.000đ</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between">
                                    <div class="text-warning">
                                        <i class="fa fa-star"></i>
                                        <i class="fa fa-star"></i>
                                        <i class="fa fa-star"></i>
                                        <i class="fa fa-star"></i>
                                        <i class="fa fa-star"></i>
                                    </div>
                                    <a href="<%= request.getContextPath() %>/login" class="btn btn-primary btn-sm rounded-pill">Chi tiết</a>
                                </div>
                            </div>
                            <div class="product-item-add p-3 border-top">
                                <a href="<%= request.getContextPath() %>/login" class="btn btn-secondary w-100 rounded-pill">Add to Cart</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Product Grid End -->

        <script>
            (function(){
                const sort = document.getElementById('sortSelect');
                const category = document.getElementById('categorySelect');
                if (sort) sort.addEventListener('change', function(){
                    // TODO: hook to backend; for now just log
                    console.log('sort by', this.value);
                });
                if (category) category.addEventListener('change', function(){
                    console.log('filter category', this.value);
                });
            })();
        </script>

        <jsp:include page="/views/component/footer.jsp" />

    </body>

</html>