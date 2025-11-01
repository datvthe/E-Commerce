<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <title>Blog - Gicungco</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <meta content="" name="keywords" />
    <meta content="" name="description" />
    
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500;600;700&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet" />
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" />
    
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet" />
    
    <!-- Animate CSS -->
    <link href="<%= request.getContextPath() %>/views/assets/electro/lib/animate/animate.min.css" rel="stylesheet" />
    
    <!-- Owl Carousel -->
    <link href="<%= request.getContextPath() %>/views/assets/electro/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet" />
    
    <!-- Bootstrap CSS -->
    <link href="<%= request.getContextPath() %>/views/assets/electro/css/bootstrap.min.css" rel="stylesheet" />
    
    <!-- Main CSS -->
    <link href="<%= request.getContextPath() %>/views/assets/electro/css/style.css" rel="stylesheet" />
    
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
        
        /* Blog List Styles */
        .blog-section {
            background: #f8f9fa;
            padding: 3rem 0;
            min-height: 100vh;
        }
        
        .page-header {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .search-box {
            max-width: 600px;
            margin: 1.5rem auto 0;
        }
        
        .blog-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }
        
        .blog-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            transition: all 0.3s;
            text-decoration: none;
            display: block;
        }
        
        .blog-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        
        .blog-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
            background: linear-gradient(135deg, #ff6b35, #f7931e);
        }
        
        .blog-body {
            padding: 1.5rem;
        }
        
        .blog-title {
            font-size: 1.25rem;
            font-weight: bold;
            color: #333;
            margin-bottom: 0.75rem;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .blog-summary {
            color: #666;
            font-size: 0.95rem;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
            margin-bottom: 1rem;
        }
        
        .blog-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.875rem;
            color: #999;
            flex-wrap: wrap;
            gap: 0.5rem;
        }
        
        .blog-meta span {
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }
        
        .pagination-wrapper {
            background: white;
            border-radius: 10px;
            padding: 1rem;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <div id="spinner" class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
        <div class="spinner-border text-primary" style="width: 3rem; height: 3rem" role="status">
            <span class="sr-only">Loading...</span>
        </div>
    </div>
    
    <!-- Topbar Start -->
    <div class="container-fluid px-5 d-none border-bottom d-lg-block">
        <div class="row gx-0 align-items-center">
            <div class="col-lg-4 text-center text-lg-start mb-lg-0">
                <div class="d-inline-flex align-items-center" style="height: 45px">
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
                <div class="d-inline-flex align-items-center" style="height: 45px">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <a href="<%= request.getContextPath() %>/notifications" class="text-muted me-3 position-relative" title="Thông báo" style="text-decoration: none">
                                <i class="bi bi-bell" style="font-size: 1.2rem"></i>
                            </a>
                            <a href="<%= request.getContextPath() %>/profile" class="btn btn-outline-info btn-sm px-3 me-2">
                                <i class="bi bi-person me-1"></i>Tài khoản
                            </a>
                            <a href="#" class="btn btn-outline-danger btn-sm px-3" onclick="logout()">
                                <i class="bi bi-box-arrow-right me-1"></i>Đăng xuất
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="<%= request.getContextPath() %>/login" class="btn btn-outline-primary btn-sm px-3 me-2">
                                <i class="bi bi-person me-1"></i>Đăng nhập
                            </a>
                            <a href="<%= request.getContextPath() %>/register" class="btn btn-outline-success btn-sm px-3">
                                <i class="bi bi-person-plus me-1"></i>Đăng ký
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
    <!-- Topbar End -->
    
    <!-- Logo & Search Bar Start -->
    <div class="container-fluid px-5 py-4 d-none d-lg-block">
        <div class="row gx-0 align-items-center text-center">
            <div class="col-md-4 col-lg-3 text-center text-lg-start">
                <div class="d-inline-flex align-items-center">
                    <a href="<%= request.getContextPath() %>/home" class="navbar-brand p-0">
                        <h1 class="display-5 text-primary m-0">
                            <i class="fas fa-shopping-bag text-secondary me-2"></i>Gicungco
                        </h1>
                    </a>
                </div>
            </div>
            <div class="col-md-4 col-lg-6 text-center">
                <div class="position-relative ps-4">
                    <div class="d-flex border rounded-pill">
                        <input class="form-control border-0 rounded-pill w-100 py-3" type="text" placeholder="Tìm kiếm sản phẩm?" />
                        <select class="form-select text-dark border-0 border-start rounded-0 p-3" style="width: 200px">
                            <option value="All Category">Tất cả danh mục</option>
                        </select>
                        <button type="button" class="btn btn-primary rounded-pill py-3 px-5" style="border: 0">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </div>
            </div>
            <div class="col-md-4 col-lg-3 text-center text-lg-end">
                <div class="d-inline-flex align-items-center">
                    <a href="#" class="text-muted d-flex align-items-center justify-content-center me-3">
                        <span class="rounded-circle btn-md-square border"><i class="fas fa-random"></i></span>
                    </a>
                    <a href="<%= request.getContextPath() %>/wishlist" class="text-muted d-flex align-items-center justify-content-center me-3">
                        <span class="rounded-circle btn-md-square border"><i class="fas fa-heart"></i></span>
                    </a>
                </div>
            </div>
        </div>
    </div>
    <!-- Logo & Search Bar End -->
    
    <!-- Navbar Start -->
    <div class="container-fluid nav-bar p-0">
        <div class="row gx-0 px-5 align-items-center" style="background: linear-gradient(135deg, #ff6b35, #f7931e)">
            <div class="col-lg-3 d-none d-lg-block">
                <nav class="navbar navbar-light position-relative" style="width: 250px">
                    <button class="navbar-toggler border-0 fs-4 w-100 px-0 text-start" type="button" data-bs-toggle="collapse" data-bs-target="#allCat">
                        <h4 class="m-0"><i class="fa fa-bars me-2"></i>Tất cả danh mục</h4>
                    </button>
                    <div class="collapse navbar-collapse rounded-bottom" id="allCat">
                        <div class="navbar-nav ms-auto py-0">
                            <ul class="list-unstyled categories-bars">
                                <li><div class="categories-bars-item">
                                    <a href="<%= request.getContextPath() %>/products?category=1"><i class="fas fa-graduation-cap me-2"></i>Học tập</a>
                                </div></li>
                                <li><div class="categories-bars-item">
                                    <a href="<%= request.getContextPath() %>/products?category=2"><i class="fas fa-play-circle me-2"></i>Xem phim</a>
                                </div></li>
                                <li><div class="categories-bars-item">
                                    <a href="<%= request.getContextPath() %>/products?category=3"><i class="fas fa-laptop-code me-2"></i>Phần mềm</a>
                                </div></li>
                            </ul>
                        </div>
                    </div>
                </nav>
            </div>
            <div class="col-12 col-lg-9">
                <nav class="navbar navbar-expand-lg navbar-light bg-primary">
                    <a href="<%= request.getContextPath() %>/home" class="navbar-brand d-block d-lg-none">
                        <h1 class="display-5 text-secondary m-0">
                            <i class="fas fa-shopping-bag text-white me-2"></i>Gicungco
                        </h1>
                    </a>
                    <button class="navbar-toggler ms-auto" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
                        <span class="fa fa-bars fa-1x"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarCollapse">
                        <div class="navbar-nav ms-auto py-0">
                            <a href="<%= request.getContextPath() %>/home" class="nav-item nav-link">Trang chủ</a>
                            <a href="<%= request.getContextPath() %>/products" class="nav-item nav-link">Cửa hàng</a>
                            <c:if test="${not empty sessionScope.user}">
                                <a href="<%= request.getContextPath() %>/user/my-blogs" class="nav-item nav-link">
                                    <i class="fas fa-blog me-1"></i>Blog của tôi
                                </a>
                            </c:if>
                            <a href="#" class="nav-item nav-link">Chia sẻ</a>
                            <a href="<%= request.getContextPath() %>/contact" class="nav-item nav-link">Hỗ trợ</a>
                            <c:if test="${not empty sessionScope.user}">
                                <a href="<%= request.getContextPath() %>/wishlist" class="nav-item nav-link me-2 position-relative" title="Danh sách yêu thích">
                                    <i class="fas fa-heart me-1"></i>Yêu thích
                                </a>
                            </c:if>
                        </div>
                        <a href="" class="btn btn-secondary rounded-pill py-2 px-4 px-lg-3 mb-3 mb-md-3 mb-lg-0">
                            <i class="fa fa-mobile-alt me-2"></i> +0123 456 7890
                        </a>
                    </div>
                </nav>
            </div>
        </div>
    </div>
    <!-- Navbar End -->

    <!-- Blog List Section -->
    <div class="blog-section">
        <div class="container">
            <!-- Page Header -->
            <div class="page-header">
                <h1 class="display-4 mb-3"><i class="fas fa-blog me-3 text-primary"></i>Blog</h1>
                <p class="lead text-muted mb-4">Khám phá các bài viết hữu ích về công nghệ và gaming</p>
                
                <!-- Search -->
                <form method="GET" class="search-box">
                    <div class="input-group input-group-lg">
                        <input type="text" class="form-control" name="q" 
                               value="${keyword}" placeholder="Tìm kiếm blog...">
                        <button class="btn btn-primary" type="submit">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </form>
                
                <c:if test="${not empty keyword}">
                    <div class="mt-3">
                        <small class="text-muted">
                            Tìm thấy ${totalBlogs} kết quả cho "<strong>${keyword}</strong>"
                            <a href="${pageContext.request.contextPath}/blogs" class="ms-2">Xóa tìm kiếm</a>
                        </small>
                    </div>
                </c:if>
            </div>

            <!-- Blog Grid -->
            <c:choose>
                <c:when test="${empty blogs}">
                    <div class="text-center py-5 bg-white rounded-3 shadow">
                        <i class="fas fa-inbox fa-4x text-muted mb-3"></i>
                        <h4 class="text-muted">Chưa có blog nào</h4>
                        <p class="text-muted">Hãy quay lại sau!</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="blog-grid">
                        <c:forEach items="${blogs}" var="blog">
                            <a href="${pageContext.request.contextPath}/blog/${blog.slug}" class="blog-card">
                                <c:choose>
                                    <c:when test="${not empty blog.featuredImage}">
                                        <img src="${pageContext.request.contextPath}${blog.featuredImage}" 
                                             alt="${blog.title}" class="blog-image">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="blog-image d-flex align-items-center justify-content-center text-white">
                                            <i class="fas fa-newspaper fa-3x"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                
                                <div class="blog-body">
                                    <h3 class="blog-title">${blog.title}</h3>
                                    <p class="blog-summary">${blog.summary}</p>
                                    
                                    <div class="blog-meta mb-2">
                                        <span>
                                            <i class="far fa-user me-1"></i>${blog.author.full_name}
                                        </span>
                                        <span>
                                            <i class="far fa-calendar me-1"></i>
                                            <fmt:formatDate value="${blog.publishedAt}" pattern="dd/MM/yyyy"/>
                                        </span>
                                    </div>
                                    
                                    <div class="blog-meta pt-2 border-top">
                                        <span><i class="far fa-eye me-1"></i>${blog.viewCount}</span>
                                        <span><i class="far fa-heart me-1"></i>${blog.likeCount}</span>
                                        <span><i class="far fa-comment me-1"></i>${blog.commentCount}</span>
                                        <span><i class="far fa-clock me-1"></i>${blog.readingTime} phút</span>
                                    </div>
                                </div>
                            </a>
                        </c:forEach>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <nav class="pagination-wrapper">
                            <ul class="pagination justify-content-center mb-0">
                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${currentPage - 1}${not empty keyword ? '&q='.concat(keyword) : ''}">
                                            <i class="fas fa-chevron-left"></i> Trước
                                        </a>
                                    </li>
                                </c:if>
                                
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <c:if test="${i >= currentPage - 2 and i <= currentPage + 2}">
                                        <li class="page-item ${i eq currentPage ? 'active' : ''}">
                                            <a class="page-link" href="?page=${i}${not empty keyword ? '&q='.concat(keyword) : ''}">
                                                ${i}
                                            </a>
                                        </li>
                                    </c:if>
                                </c:forEach>
                                
                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${currentPage + 1}${not empty keyword ? '&q='.concat(keyword) : ''}">
                                            Sau <i class="fas fa-chevron-right"></i>
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
                    </c:if>
                </c:otherwise>
            </c:choose>
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

    <!-- JavaScript Libraries -->
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<%= request.getContextPath() %>/views/assets/electro/lib/easing/easing.min.js"></script>
    <script src="<%= request.getContextPath() %>/views/assets/electro/lib/waypoints/waypoints.min.js"></script>
    <script src="<%= request.getContextPath() %>/views/assets/electro/lib/counterup/counterup.min.js"></script>
    <script src="<%= request.getContextPath() %>/views/assets/electro/lib/owlcarousel/owl.carousel.min.js"></script>

    <!-- Template Javascript -->
    <script src="<%= request.getContextPath() %>/views/assets/electro/js/main.js"></script>

    <script>
        // Spinner
        var spinner = function () {
            setTimeout(function () {
                if ($('#spinner').length > 0) {
                    $('#spinner').removeClass('show');
                }
            }, 1);
        };
        spinner();

        function logout() {
            if (confirm('Bạn có chắc chắn muốn đăng xuất?')) {
                window.location.href = '<%= request.getContextPath() %>/logout';
            }
        }
    </script>
</body>
</html>
