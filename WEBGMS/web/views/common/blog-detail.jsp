<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <title>${blog.title} - Gicungco Blog</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <meta content="${blog.metaKeywords}" name="keywords" />
    <meta content="${blog.metaDescription != null ? blog.metaDescription : blog.summary}" name="description" />
    
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500;600;700&family:Roboto:wght@400;500;700&display=swap" rel="stylesheet" />
    
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
        .text-primary {
            color: #ff6b35 !important;
        }
        
        /* Blog Detail Styles */
        .blog-detail-section {
            background: #f8f9fa;
            padding: 3rem 0;
            min-height: 100vh;
        }
        
        .blog-header-card {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        
        .blog-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 1rem;
        }
        
        .blog-summary {
            font-size: 1.2rem;
            color: #666;
            margin-bottom: 1.5rem;
        }
        
        .blog-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 2rem;
            padding: 1rem 0;
            border-top: 1px solid #e9ecef;
            border-bottom: 1px solid #e9ecef;
        }
        
        .meta-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: #666;
        }
        
        .meta-item i {
            color: #ff6b35;
        }
        
        .blog-content-card {
            background: white;
            border-radius: 15px;
            padding: 3rem;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        
        .featured-image {
            width: 100%;
            max-height: 500px;
            object-fit: cover;
            border-radius: 15px;
            margin-bottom: 2rem;
        }
        
        .author-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            border-left: 4px solid #ff6b35;
        }
        
        .author-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, #ff6b35, #f7931e);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            font-weight: bold;
        }
        
        .blog-content-body {
            line-height: 1.8;
            font-size: 1.1rem;
            color: #333;
        }
        
        .blog-content-body h1,
        .blog-content-body h2,
        .blog-content-body h3,
        .blog-content-body h4 {
            margin-top: 2rem;
            margin-bottom: 1rem;
            font-weight: 600;
        }
        
        .blog-content-body h1 {
            font-size: 2rem;
            color: #ff6b35;
        }
        
        .blog-content-body h2 {
            font-size: 1.75rem;
            color: #f7931e;
        }
        
        .blog-content-body h3 {
            font-size: 1.5rem;
            color: #333;
        }
        
        .blog-content-body p {
            margin-bottom: 1rem;
        }
        
        .blog-content-body img {
            max-width: 100%;
            height: auto;
            border-radius: 10px;
            margin: 1.5rem 0;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
        
        .blog-content-body ul,
        .blog-content-body ol {
            margin-bottom: 1rem;
            padding-left: 2rem;
        }
        
        .blog-content-body pre {
            background: #f4f4f4;
            padding: 1rem;
            border-radius: 5px;
            overflow-x: auto;
        }
        
        .blog-content-body code {
            background: #f4f4f4;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: monospace;
        }
        
        .blog-content-body blockquote {
            border-left: 4px solid #ff6b35;
            padding-left: 1rem;
            margin: 1rem 0;
            color: #666;
            font-style: italic;
        }
        
        .share-section {
            margin-top: 3rem;
            padding-top: 2rem;
            border-top: 2px solid #e9ecef;
            text-align: center;
        }
        
        .share-btn {
            margin: 0 0.5rem;
            padding: 0.75rem 1.5rem;
            border-radius: 25px;
            font-weight: 600;
        }
        
        .back-to-blogs {
            background: white;
            color: #ff6b35;
            border: 2px solid #ff6b35;
            padding: 0.75rem 2rem;
            border-radius: 25px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            margin-bottom: 2rem;
        }
        
        .back-to-blogs:hover {
            background: #ff6b35;
            color: white;
        }
        
        /* Comment Section Styles */
        .comment-form textarea {
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 1rem;
        }
        
        .comment-form textarea:focus {
            border-color: #ff6b35;
            box-shadow: 0 0 0 0.2rem rgba(255, 107, 53, 0.25);
        }
        
        .comment-item {
            padding: 1.5rem;
            background: #f8f9fa;
            border-radius: 10px;
            margin-bottom: 1rem;
            border-left: 3px solid #ff6b35;
        }
        
        .comment-item:hover {
            background: #f1f3f5;
        }
        
        .comment-author {
            font-weight: 600;
            color: #333;
        }
        
        .comment-time {
            font-size: 0.875rem;
            color: #6c757d;
        }
        
        .comment-content {
            margin-top: 0.75rem;
            color: #495057;
            line-height: 1.6;
        }
        
        .comment-actions {
            margin-top: 0.75rem;
            display: flex;
            gap: 1rem;
        }
        
        .comment-actions button {
            background: none;
            border: none;
            color: #6c757d;
            font-size: 0.875rem;
            cursor: pointer;
            padding: 0.25rem 0.5rem;
        }
        
        .comment-actions button:hover {
            color: #ff6b35;
        }
        
        .reply-form {
            margin-top: 1rem;
            padding-left: 3rem;
        }
        
        .comment-reply {
            margin-left: 3rem;
            margin-top: 1rem;
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

    <!-- Blog Detail Section -->
    <div class="blog-detail-section">
        <div class="container">
            <a href="${pageContext.request.contextPath}/blogs" class="back-to-blogs">
                <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách blog
            </a>
            
            <!-- Blog Header -->
            <div class="blog-header-card">
                <h1 class="blog-title">${blog.title}</h1>
                <p class="blog-summary">${blog.summary}</p>
                
                <div class="blog-meta">
                    <div class="meta-item">
                        <i class="far fa-calendar"></i>
                        <span><fmt:formatDate value="${blog.publishedAt != null ? blog.publishedAt : blog.createdAt}" pattern="dd/MM/yyyy"/></span>
                    </div>
                    <div class="meta-item">
                        <i class="far fa-eye"></i>
                        <span>${blog.viewCount} lượt xem</span>
                    </div>
                    <div class="meta-item">
                        <i class="far fa-heart"></i>
                        <span>${blog.likeCount} thích</span>
                    </div>
                    <div class="meta-item">
                        <i class="far fa-comment"></i>
                        <span>${blog.commentCount} bình luận</span>
                    </div>
                    <div class="meta-item">
                        <i class="far fa-clock"></i>
                        <span>${blog.readingTime} phút đọc</span>
                    </div>
                </div>
            </div>
            
            <!-- Blog Content -->
            <div class="row">
                <div class="col-lg-10 mx-auto">
                    <div class="blog-content-card">
                        <!-- Featured Image -->
                        <c:if test="${not empty blog.featuredImage}">
                            <img src="${pageContext.request.contextPath}${blog.featuredImage}" 
                                 alt="${blog.title}" 
                                 class="featured-image">
                        </c:if>

                        <!-- Author -->
                        <div class="author-card">
                            <div class="d-flex align-items-center">
                                <div class="author-avatar me-3">
                                    ${fn:substring(blog.author.full_name, 0, 1)}
                                </div>
                                <div>
                                    <h6 class="mb-0 fw-bold">${blog.author.full_name}</h6>
                                    <small class="text-muted">Tác giả</small>
                                </div>
                            </div>
                        </div>

                        <!-- Content -->
                        <div class="blog-content-body">
                            <c:out value="${blog.content}" escapeXml="false" />
                        </div>

                        <!-- Share Section -->
                        <div class="share-section">
                            <h5 class="mb-3"><i class="fas fa-share-alt me-2"></i>Chia sẻ bài viết:</h5>
                            <div class="d-flex flex-wrap justify-content-center gap-2">
                                <a href="https://www.facebook.com/sharer/sharer.php?u=${pageContext.request.requestURL}" 
                                   target="_blank" class="btn btn-primary share-btn">
                                    <i class="fab fa-facebook-f me-2"></i>Facebook
                                </a>
                                <a href="https://twitter.com/intent/tweet?url=${pageContext.request.requestURL}&text=${blog.title}" 
                                   target="_blank" class="btn btn-info share-btn text-white">
                                    <i class="fab fa-twitter me-2"></i>Twitter
                                </a>
                                <a href="https://pinterest.com/pin/create/button/?url=${pageContext.request.requestURL}&description=${blog.title}" 
                                   target="_blank" class="btn btn-danger share-btn">
                                    <i class="fab fa-pinterest me-2"></i>Pinterest
                                </a>
                                <button onclick="copyLink()" class="btn btn-secondary share-btn">
                                    <i class="fas fa-link me-2"></i>Copy Link
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Comments Section -->
                    <div class="blog-content-card mt-4">
                        <h4 class="mb-4"><i class="far fa-comments me-2"></i>Bình luận (${blog.commentCount})</h4>
                        
                        <!-- Comment Form -->
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <div class="comment-form mb-4">
                                    <div class="d-flex align-items-start">
                                        <div class="author-avatar me-3">
                                            ${fn:substring(sessionScope.user.full_name, 0, 1)}
                                        </div>
                                        <div class="flex-grow-1">
                                            <textarea class="form-control" id="commentContent" rows="3" 
                                                      placeholder="Viết bình luận của bạn..."></textarea>
                                            <button onclick="postComment()" class="btn btn-primary mt-2">
                                                <i class="fas fa-paper-plane me-2"></i>Gửi bình luận
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle me-2"></i>
                                    Vui lòng <a href="${pageContext.request.contextPath}/login">đăng nhập</a> để bình luận.
                                </div>
                            </c:otherwise>
                        </c:choose>
                        
                        <!-- Comments List -->
                        <div id="commentsList">
                            <div class="text-center text-muted py-3">
                                <i class="fas fa-spinner fa-spin me-2"></i>Đang tải bình luận...
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
        
        const blogId = ${blog.blogId};
        const contextPath = '<%= request.getContextPath() %>';

        function copyLink() {
            const url = window.location.href;
            navigator.clipboard.writeText(url).then(function() {
                alert('Đã copy link blog!');
            }, function() {
                alert('Không thể copy link. Vui lòng thử lại!');
            });
        }

        function logout() {
            if (confirm('Bạn có chắc chắn muốn đăng xuất?')) {
                window.location.href = '<%= request.getContextPath() %>/logout';
            }
        }
        
        // Load comments on page load
        $(document).ready(function() {
            const commentCount = ${blog.commentCount};
            
            if (commentCount === 0) {
                // No comments - show empty state immediately
                $('#commentsList').html('<div class="text-center text-muted py-3"><i class="far fa-comments me-2"></i>Chưa có bình luận nào. Hãy là người đầu tiên!</div>');
            } else {
                // Load comments
                loadComments();
            }
        });
        
        function loadComments() {
            console.log('Loading comments for blog ID:', blogId);
            console.log('API URL:', contextPath + '/api/blog/comments?blogId=' + blogId);
            
            $.ajax({
                url: contextPath + '/api/blog/comments?blogId=' + blogId,
                type: 'GET',
                timeout: 2000, // 2 seconds timeout - faster
                dataType: 'json',
                cache: false,
                success: function(response) {
                    console.log('Comments loaded successfully:', response);
                    if (response.success && response.comments) {
                        displayComments(response.comments);
                    } else {
                        displayComments([]);
                    }
                },
                error: function(xhr, status, error) {
                    console.error('Error loading comments:', status, error);
                    console.error('XHR:', xhr);
                    console.error('Response Text:', xhr.responseText);
                    
                    // Show empty state instead of error to not block UX
                    $('#commentsList').html(
                        '<div class="text-center text-muted py-3">' +
                        '<i class="far fa-comments me-2"></i>Không thể tải bình luận. ' +
                        '<a href="#" onclick="loadComments(); return false;" class="text-primary">Thử lại</a>' +
                        '</div>'
                    );
                }
            });
        }
        
        function displayComments(comments) {
            const commentsList = $('#commentsList');
            
            if (comments.length === 0) {
                commentsList.html('<div class="text-center text-muted py-3"><i class="far fa-comments me-2"></i>Chưa có bình luận nào. Hãy là người đầu tiên!</div>');
                return;
            }
            
            let html = '';
            comments.forEach(comment => {
                html += renderComment(comment);
            });
            
            commentsList.html(html);
        }
        
        function renderComment(comment) {
            const timeAgo = getTimeAgo(new Date(comment.createdAt));
            const avatar = comment.userName ? comment.userName.substring(0, 1).toUpperCase() : 'U';
            
            let html = `
                <div class="comment-item" id="comment-\${comment.commentId}">
                    <div class="d-flex align-items-start">
                        <div class="author-avatar me-3">\${avatar}</div>
                        <div class="flex-grow-1">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <span class="comment-author">\${comment.userName || 'Người dùng'}</span>
                                    <span class="comment-time ms-2">\${timeAgo}</span>
                                </div>
                            </div>
                            <div class="comment-content">\${escapeHtml(comment.content)}</div>
                            <div class="comment-actions">
                                <button onclick="showReplyForm(\${comment.commentId})">
                                    <i class="far fa-comment me-1"></i>Trả lời (\${comment.replyCount || 0})
                                </button>
                            </div>
                            <div id="reply-form-\${comment.commentId}" class="reply-form" style="display: none;">
                                <textarea class="form-control" id="reply-content-\${comment.commentId}" rows="2" placeholder="Viết câu trả lời..."></textarea>
                                <button onclick="postReply(\${comment.commentId})" class="btn btn-sm btn-primary mt-2">
                                    <i class="fas fa-paper-plane me-1"></i>Gửi
                                </button>
                                <button onclick="hideReplyForm(\${comment.commentId})" class="btn btn-sm btn-secondary mt-2">Hủy</button>
                            </div>
                            <div id="replies-\${comment.commentId}" class="comment-reply"></div>
                        </div>
                    </div>
                </div>
            `;
            
            return html;
        }
        
        function postComment() {
            const content = $('#commentContent').val().trim();
            
            if (!content) {
                alert('Vui lòng nhập nội dung bình luận!');
                return;
            }
            
            $.ajax({
                url: contextPath + '/api/blog/comments',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    blogId: blogId,
                    content: content
                }),
                success: function() {
                    $('#commentContent').val('');
                    loadComments();
                    alert('Đã gửi bình luận thành công!');
                },
                error: function() {
                    alert('Không thể gửi bình luận. Vui lòng thử lại!');
                }
            });
        }
        
        function showReplyForm(commentId) {
            // Load replies first
            loadReplies(commentId);
            $('#reply-form-' + commentId).slideDown();
        }
        
        function hideReplyForm(commentId) {
            $('#reply-form-' + commentId).slideUp();
        }
        
        function loadReplies(commentId) {
            $.ajax({
                url: contextPath + '/api/blog/comments/replies/' + commentId,
                type: 'GET',
                timeout: 5000,
                success: function(response) {
                    if (response.success && response.replies) {
                        displayReplies(commentId, response.replies);
                    } else {
                        displayReplies(commentId, []);
                    }
                },
                error: function(xhr, status, error) {
                    console.error('Error loading replies:', status, error);
                }
            });
        }
        
        function displayReplies(commentId, replies) {
            const repliesDiv = $('#replies-' + commentId);
            
            if (replies.length === 0) {
                return;
            }
            
            let html = '';
            replies.forEach(reply => {
                const timeAgo = getTimeAgo(new Date(reply.createdAt));
                const avatar = reply.userName ? reply.userName.substring(0, 1).toUpperCase() : 'U';
                
                html += `
                    <div class="comment-item mt-2">
                        <div class="d-flex align-items-start">
                            <div class="author-avatar me-3" style="width: 40px; height: 40px; font-size: 1rem;">\${avatar}</div>
                            <div class="flex-grow-1">
                                <div>
                                    <span class="comment-author">\${reply.userName || 'Người dùng'}</span>
                                    <span class="comment-time ms-2">\${timeAgo}</span>
                                </div>
                                <div class="comment-content">\${escapeHtml(reply.content)}</div>
                            </div>
                        </div>
                    </div>
                `;
            });
            
            repliesDiv.html(html);
        }
        
        function postReply(parentCommentId) {
            const content = $('#reply-content-' + parentCommentId).val().trim();
            
            if (!content) {
                alert('Vui lòng nhập nội dung trả lời!');
                return;
            }
            
            $.ajax({
                url: contextPath + '/api/blog/comments',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    blogId: blogId,
                    content: content,
                    parentCommentId: parentCommentId
                }),
                success: function() {
                    $('#reply-content-' + parentCommentId).val('');
                    hideReplyForm(parentCommentId);
                    loadReplies(parentCommentId);
                    loadComments(); // Reload to update counts
                    alert('Đã gửi câu trả lời thành công!');
                },
                error: function() {
                    alert('Không thể gửi câu trả lời. Vui lòng thử lại!');
                }
            });
        }
        
        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }
        
        function getTimeAgo(date) {
            const seconds = Math.floor((new Date() - date) / 1000);
            
            let interval = seconds / 31536000;
            if (interval > 1) return Math.floor(interval) + ' năm trước';
            
            interval = seconds / 2592000;
            if (interval > 1) return Math.floor(interval) + ' tháng trước';
            
            interval = seconds / 86400;
            if (interval > 1) return Math.floor(interval) + ' ngày trước';
            
            interval = seconds / 3600;
            if (interval > 1) return Math.floor(interval) + ' giờ trước';
            
            interval = seconds / 60;
            if (interval > 1) return Math.floor(interval) + ' phút trước';
            
            return 'Vừa xong';
        }
    </script>
</body>
</html>
