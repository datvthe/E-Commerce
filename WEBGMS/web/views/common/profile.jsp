<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ cá nhân - Gicungco</title>
    
    <!-- Favicon -->
    <link href="<%= request.getContextPath() %>/views/assets/electro/img/favicon.ico" rel="icon">
    
    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600&family=Raleway:wght@600&display=swap" rel="stylesheet">
    
    <!-- Icon Font Stylesheet -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">
    
    <!-- Libraries Stylesheet -->
    <link href="<%= request.getContextPath() %>/views/assets/electro/lib/animate/animate.min.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/views/assets/electro/lib/lightbox/css/lightbox.min.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/views/assets/electro/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
    
    <!-- Customized Bootstrap Stylesheet -->
    <link href="<%= request.getContextPath() %>/views/assets/electro/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Template Stylesheet -->
    <link href="<%= request.getContextPath() %>/views/assets/electro/css/style.css" rel="stylesheet">
    
    <style>
        .profile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 4px solid white;
            object-fit: cover;
        }
        .profile-card {
            border: none;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            border-radius: 15px;
            overflow: hidden;
        }
        .profile-card .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 1.5rem;
        }
        .profile-stats {
            background: #f8f9fa;
            padding: 1rem;
            border-radius: 10px;
        }
        .stat-item {
            text-align: center;
            padding: 1rem;
        }
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: #667eea;
        }
        .stat-label {
            color: #6c757d;
            font-size: 0.9rem;
        }
        .profile-tabs .nav-link {
            border: none;
            color: #6c757d;
            font-weight: 500;
        }
        .profile-tabs .nav-link.active {
            background: #667eea;
            color: white;
            border-radius: 25px;
        }
        .profile-tabs .nav-link:hover {
            color: #667eea;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 25px;
            padding: 0.5rem 2rem;
        }
        .btn-primary:hover {
            background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%);
        }
        .profile-card {
            transition: all 0.3s ease;
        }
        .profile-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }
        .stat-item {
            transition: all 0.3s ease;
        }
        .stat-item:hover {
            transform: scale(1.05);
        }
        .nav-link {
            transition: all 0.3s ease;
        }
        .nav-link:hover {
            color: #667eea !important;
        }
        .btn {
            transition: all 0.3s ease;
        }
        .btn:hover {
            transform: translateY(-2px);
        }
        .fade-in {
            animation: fadeIn 0.6s ease-in;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .pulse {
            animation: pulse 2s infinite;
        }
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
    </style>
</head>
<body>
    <!-- Spinner Start -->
    <div id="spinner" class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
        <div class="spinner-border text-primary" role="status" style="width: 3rem; height: 3rem;"></div>
    </div>
    <!-- Spinner End -->

    <!-- Toast Notifications -->
    <div class="position-fixed top-0 end-0 p-3" style="z-index: 1080;">
        <c:if test="${not empty sessionScope.message}">
            <div id="toast-success" class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body">${sessionScope.message}</div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
            </div>
            <c:remove var="message" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.error}">
            <div id="toast-error" class="toast align-items-center text-white bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body">${sessionScope.error}</div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>
    </div>
    <script>
        (function () {
            try {
                var toastSuccess = document.getElementById('toast-success');
                if (toastSuccess) new bootstrap.Toast(toastSuccess, {delay: 3000}).show();
                var toastError = document.getElementById('toast-error');
                if (toastError) new bootstrap.Toast(toastError, {delay: 4000}).show();
            } catch (e) {}
        })();
    </script>

    <!-- Topbar Start -->
    <div class="container-fluid top-bar bg-dark px-0 d-none d-lg-block">
        <div class="row gx-0">
            <div class="col-lg-8 text-center text-lg-start mb-2 mb-lg-0">
                <div class="d-inline-flex align-items-center">
                    <small class="me-3 text-light"><i class="fas fa-map-marker-alt text-primary me-2"></i>123 Đường ABC, Quận 1, TP.HCM</small>
                    <small class="me-3 text-light"><i class="fas fa-phone text-primary me-2"></i>+84 123 456 789</small>
                    <small class="text-light"><i class="fas fa-envelope text-primary me-2"></i>info@gicungco.com</small>
                </div>
            </div>
            <div class="col-lg-4 text-center text-lg-end">
                <div class="d-inline-flex align-items-center">
                    <a class="text-light py-2 pe-3" href="#"><i class="fab fa-facebook-f"></i></a>
                    <a class="text-light py-2 pe-3" href="#"><i class="fab fa-twitter"></i></a>
                    <a class="text-light py-2 pe-3" href="#"><i class="fab fa-linkedin-in"></i></a>
                    <a class="text-light py-2 pe-3" href="#"><i class="fab fa-instagram"></i></a>
                    <a class="text-light py-2 pe-3" href="#"><i class="fab fa-youtube"></i></a>
                </div>
            </div>
        </div>
    </div>
    <!-- Topbar End -->

    <!-- Navbar Start -->
    <nav class="navbar navbar-expand-lg bg-white navbar-light sticky-top py-0">
        <div class="container-fluid">
            <a href="<%= request.getContextPath() %>/home" class="navbar-brand d-flex align-items-center px-4 px-lg-5">
                <h1 class="m-0 text-primary">Gicungco</h1>
            </a>
            <button type="button" class="navbar-toggler me-4" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarCollapse">
                <div class="navbar-nav ms-auto p-4 p-lg-0">
                    <a href="<%= request.getContextPath() %>/home" class="nav-item nav-link">Trang chủ</a>
                    <a href="<%= request.getContextPath() %>/products" class="nav-item nav-link">Sản phẩm</a>
                    <a href="<%= request.getContextPath() %>/contact" class="nav-item nav-link">Liên hệ</a>
                    
                    <!-- Search Bar -->
                    <div class="nav-item dropdown">
                        <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">
                            <i class="fas fa-search me-1"></i>Tìm kiếm
                        </a>
                        <div class="dropdown-menu m-0">
                            <div class="p-3">
                                <div class="position-relative">
                                    <input class="form-control" type="text" placeholder="Tìm sản phẩm..." id="searchInput" onkeyup="showSearchSuggestions(this.value)">
                                    <div id="aiSuggestions" class="mt-2"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <c:choose>
                        <c:when test="${sessionScope.user != null}">
                            <div class="nav-item dropdown">
                                <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">
                                    <i class="fas fa-user me-1"></i>${sessionScope.user.full_name}
                                </a>
                                <div class="dropdown-menu fade-down m-0">
                                    <a href="<%= request.getContextPath() %>/profile" class="dropdown-item">
                                        <i class="fas fa-user me-2"></i>Hồ sơ cá nhân
                                    </a>
                                    <a href="<%= request.getContextPath() %>/orders" class="dropdown-item">
                                        <i class="fas fa-shopping-bag me-2"></i>Đơn hàng
                                    </a>
                                    <a href="<%= request.getContextPath() %>/wishlist" class="dropdown-item">
                                        <i class="fas fa-heart me-2"></i>Yêu thích
                                    </a>
                                    <div class="dropdown-divider"></div>
                                    <a href="<%= request.getContextPath() %>/logout" class="dropdown-item">
                                        <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                                    </a>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a href="<%= request.getContextPath() %>/login" class="nav-item nav-link">Đăng nhập</a>
                            <a href="<%= request.getContextPath() %>/register" class="nav-item nav-link">Đăng ký</a>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="d-none d-lg-flex ms-2">
                    <a class="btn btn-primary position-relative" href="<%= request.getContextPath() %>/cart">
                        <i class="fas fa-shopping-cart me-1"></i>Giỏ hàng
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" id="cartCount">0</span>
                    </a>
                    <a class="btn btn-outline-primary ms-2 position-relative" href="<%= request.getContextPath() %>/wishlist">
                        <i class="fas fa-heart me-1"></i>Yêu thích
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" id="wishlistCount">0</span>
                    </a>
                </div>
            </div>
        </div>
    </nav>
    <!-- Navbar End -->

    <!-- Profile Header Start -->
    <div class="profile-header fade-in">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-3 text-center">
                    <img src="<%= request.getContextPath() %>/views/assets/electro/img/avatar.jpg" alt="Avatar" class="profile-avatar pulse">
                </div>
                <div class="col-md-9">
                    <h2 class="mb-2">${user.full_name}</h2>
                    <p class="mb-1"><i class="fas fa-envelope me-2"></i>${user.email}</p>
                    <p class="mb-1"><i class="fas fa-phone me-2"></i>${user.phone_number != null ? user.phone_number : 'Chưa cập nhật'}</p>
                    <p class="mb-0"><i class="fas fa-map-marker-alt me-2"></i>${user.address != null ? user.address : 'Chưa cập nhật'}</p>
                </div>
            </div>
        </div>
    </div>
    <!-- Profile Header End -->

    <!-- Profile Content Start -->
    <div class="container">
        <div class="row">
            <!-- Profile Stats -->
            <div class="col-lg-4 mb-4">
                <div class="profile-card fade-in">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-chart-bar me-2"></i>Thống kê</h5>
                    </div>
                    <div class="card-body p-0">
                        <div class="profile-stats">
                            <div class="row">
                                <div class="col-6">
                                    <div class="stat-item">
                                        <div class="stat-number" data-count="0">0</div>
                                        <div class="stat-label">Đơn hàng</div>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div class="stat-item">
                                        <div class="stat-number" data-count="0">0</div>
                                        <div class="stat-label">Yêu thích</div>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div class="stat-item">
                                        <div class="stat-number" data-count="0">0</div>
                                        <div class="stat-label">Đánh giá</div>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div class="stat-item">
                                        <div class="stat-number" data-count="0">0₫</div>
                                        <div class="stat-label">Đã chi</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Profile Details -->
            <div class="col-lg-8">
                <div class="profile-card fade-in">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-user-edit me-2"></i>Thông tin cá nhân</h5>
                    </div>
                    <div class="card-body">
                        <!-- Profile Tabs -->
                        <ul class="nav nav-pills profile-tabs mb-4" id="profileTabs" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" id="info-tab" data-bs-toggle="pill" data-bs-target="#info" type="button" role="tab">
                                    <i class="fas fa-info-circle me-2"></i>Thông tin
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="security-tab" data-bs-toggle="pill" data-bs-target="#security" type="button" role="tab">
                                    <i class="fas fa-shield-alt me-2"></i>Bảo mật
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="orders-tab" data-bs-toggle="pill" data-bs-target="#orders" type="button" role="tab">
                                    <i class="fas fa-shopping-bag me-2"></i>Đơn hàng
                                </button>
                            </li>
                        </ul>

                        <!-- Tab Content -->
                        <div class="tab-content" id="profileTabsContent">
                            <!-- Personal Info Tab -->
                            <div class="tab-pane fade show active" id="info" role="tabpanel">
                                <form id="profileForm" method="POST" action="<%= request.getContextPath() %>/update-profile">
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="fullName" class="form-label">Họ và tên *</label>
                                            <input type="text" class="form-control" id="fullName" name="full_name" value="${user.full_name}" required>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="username" class="form-label">Tên đăng nhập *</label>
                                            <input type="text" class="form-control" id="username" name="username" value="${user.email}" readonly>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="email" class="form-label">Email *</label>
                                            <input type="email" class="form-control" id="email" name="email" value="${user.email}" required>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="phone" class="form-label">Số điện thoại</label>
                                            <input type="tel" class="form-control" id="phone" name="phone" value="${user.phone_number}">
                                        </div>
                                        <div class="col-12 mb-3">
                                            <label for="address" class="form-label">Địa chỉ</label>
                                            <textarea class="form-control" id="address" name="address" rows="3">${user.address}</textarea>
                                        </div>
                                        <div class="col-12">
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-save me-2"></i>Cập nhật thông tin
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>

                            <!-- Security Tab -->
                            <div class="tab-pane fade" id="security" role="tabpanel">
                                <form id="passwordForm" method="POST" action="<%= request.getContextPath() %>/change-password">
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="currentPassword" class="form-label">Mật khẩu hiện tại *</label>
                                            <input type="password" class="form-control" id="currentPassword" name="current_password" required>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="newPassword" class="form-label">Mật khẩu mới *</label>
                                            <input type="password" class="form-control" id="newPassword" name="new_password" required>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="confirmPassword" class="form-label">Xác nhận mật khẩu mới *</label>
                                            <input type="password" class="form-control" id="confirmPassword" name="confirm_password" required>
                                        </div>
                                        <div class="col-12">
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-key me-2"></i>Đổi mật khẩu
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>

                            <!-- Orders Tab -->
                            <div class="tab-pane fade" id="orders" role="tabpanel">
                                <div class="text-center py-5">
                                    <i class="fas fa-shopping-bag fa-3x text-muted mb-3"></i>
                                    <h5>Chưa có đơn hàng nào</h5>
                                    <p class="text-muted">Bạn chưa có đơn hàng nào. Hãy mua sắm ngay!</p>
                                    <a href="<%= request.getContextPath() %>/products" class="btn btn-primary">
                                        <i class="fas fa-shopping-cart me-2"></i>Mua sắm ngay
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Profile Content End -->

    <!-- Newsletter Start -->
    <div class="container-fluid newsletter py-5">
        <div class="container">
            <div class="row g-5 align-items-center">
                <div class="col-lg-6">
                    <h4 class="text-uppercase text-white mb-0">Đăng ký nhận tin</h4>
                    <h1 class="text-uppercase text-white mb-0">Nhận ưu đãi đặc biệt</h1>
                </div>
                <div class="col-lg-6">
                    <div class="position-relative mx-auto" style="max-width: 400px;">
                        <input class="form-control border-0 w-100 py-3 ps-4 pe-5" type="text" placeholder="Nhập email của bạn">
                        <button type="button" class="btn btn-primary py-2 position-absolute top-0 end-0 mt-2 me-2">Đăng ký</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Newsletter End -->

    <!-- Footer Start -->
    <div class="container-fluid bg-dark text-white-50 footer pt-5 mt-5">
        <div class="container">
            <div class="row">
                <div class="col-lg-3 col-md-6 mb-5">
                    <h5 class="text-white text-uppercase mb-4">Gicungco</h5>
                    <p class="mb-4">Chuyên cung cấp tài nguyên số chất lượng cao với giá cả hợp lý. Giao hàng tức thì, bảo hành uy tín.</p>
                    <div class="d-flex pt-2">
                        <a class="btn btn-outline-light btn-social" href="#"><i class="fab fa-twitter"></i></a>
                        <a class="btn btn-outline-light btn-social" href="#"><i class="fab fa-facebook-f"></i></a>
                        <a class="btn btn-outline-light btn-social" href="#"><i class="fab fa-youtube"></i></a>
                        <a class="btn btn-outline-light btn-social" href="#"><i class="fab fa-linkedin-in"></i></a>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 mb-5">
                    <h5 class="text-white text-uppercase mb-4">Danh mục</h5>
                    <div class="d-flex flex-column justify-content-start">
                        <a class="text-white-50 mb-2" href="#"><i class="fa fa-angle-right me-2"></i>Thẻ cào</a>
                        <a class="text-white-50 mb-2" href="#"><i class="fa fa-angle-right me-2"></i>Tài khoản Game</a>
                        <a class="text-white-50 mb-2" href="#"><i class="fa fa-angle-right me-2"></i>Phần mềm</a>
                        <a class="text-white-50 mb-2" href="#"><i class="fa fa-angle-right me-2"></i>App & Tools</a>
                        <a class="text-white-50 mb-2" href="#"><i class="fa fa-angle-right me-2"></i>Code & Script</a>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 mb-5">
                    <h5 class="text-white text-uppercase mb-4">Liên kết</h5>
                    <div class="d-flex flex-column justify-content-start">
                        <a class="text-white-50 mb-2" href="<%= request.getContextPath() %>/home"><i class="fa fa-angle-right me-2"></i>Trang chủ</a>
                        <a class="text-white-50 mb-2" href="<%= request.getContextPath() %>/products"><i class="fa fa-angle-right me-2"></i>Sản phẩm</a>
                        <a class="text-white-50 mb-2" href="<%= request.getContextPath() %>/contact"><i class="fa fa-angle-right me-2"></i>Liên hệ</a>
                        <a class="text-white-50 mb-2" href="<%= request.getContextPath() %>/profile"><i class="fa fa-angle-right me-2"></i>Tài khoản</a>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 mb-5">
                    <h5 class="text-white text-uppercase mb-4">Liên hệ</h5>
                    <p><i class="fa fa-map-marker-alt me-3"></i>123 Đường ABC, Quận 1, TP.HCM</p>
                    <p><i class="fa fa-phone me-3"></i>+84 123 456 789</p>
                    <p><i class="fa fa-envelope me-3"></i>info@gicungco.com</p>
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
    <script src="<%= request.getContextPath() %>/views/assets/electro/lib/lightbox/js/lightbox.min.js"></script>
    <script src="<%= request.getContextPath() %>/views/assets/electro/lib/owlcarousel/owl.carousel.min.js"></script>

    <!-- Template Javascript -->
    <script src="<%= request.getContextPath() %>/views/assets/electro/js/main.js"></script>

    <script>
        // Search suggestions function
        function showSearchSuggestions(query) {
            if (query.length < 2) {
                document.getElementById('aiSuggestions').innerHTML = '';
                return;
            }
            
            const suggestions = [
                'iPhone 15 Pro Max',
                'MacBook Pro M3',
                'Samsung Galaxy S24',
                'AirPods Pro',
                'iPad Air',
                'Apple Watch',
                'Thẻ cào Viettel',
                'Tài khoản PUBG',
                'Adobe Photoshop',
                'Microsoft Office'
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
            } else {
                aiSuggestions.innerHTML = '<p class="small text-muted">Không tìm thấy gợi ý nào</p>';
            }
        }
        
        function searchProduct(query) {
            window.location.href = '<%= request.getContextPath() %>/products?search=' + encodeURIComponent(query);
        }
        
        // Logout function
        function logout() {
            if (confirm('Bạn có chắc chắn muốn đăng xuất?')) {
                window.location.href = '<%= request.getContextPath() %>/logout';
            }
        }
        
        // Profile form validation
        document.getElementById('profileForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Basic validation
            const fullName = document.getElementById('fullName').value.trim();
            const email = document.getElementById('email').value.trim();
            
            if (!fullName || !email) {
                showToast('Vui lòng điền đầy đủ thông tin bắt buộc!', 'error');
                return;
            }
            
            // Email validation
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                showToast('Email không hợp lệ!', 'error');
                return;
            }
            
            // Submit form
            this.submit();
        });
        
        // Password form validation
        document.getElementById('passwordForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const currentPassword = document.getElementById('currentPassword').value;
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (!currentPassword || !newPassword || !confirmPassword) {
                showToast('Vui lòng điền đầy đủ thông tin!', 'error');
                return;
            }
            
            if (newPassword.length < 6) {
                showToast('Mật khẩu mới phải có ít nhất 6 ký tự!', 'error');
                return;
            }
            
            if (newPassword !== confirmPassword) {
                showToast('Mật khẩu xác nhận không khớp!', 'error');
                return;
            }
            
            // Submit form
            this.submit();
        });
        
        // Toast notification function
        function showToast(message, type) {
            const toastContainer = document.querySelector('.position-fixed.top-0.end-0.p-3');
            const toastId = 'toast-' + Date.now();
            const toastClass = type === 'error' ? 'bg-danger' : 'bg-success';
            
            const toastHtml = '<div id="' + toastId + '" class="toast align-items-center text-white ' + toastClass + ' border-0" role="alert">' +
                '<div class="d-flex">' +
                '<div class="toast-body">' + message + '</div>' +
                '<button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>' +
                '</div>' +
                '</div>';
            
            toastContainer.insertAdjacentHTML('beforeend', toastHtml);
            const toastElement = document.getElementById(toastId);
            const toast = new bootstrap.Toast(toastElement, {delay: 3000});
            toast.show();
        }
        
        // Show success message if profile updated
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('updated') === 'true') {
            showToast('Cập nhật thông tin thành công!', 'success');
        }
        
        if (urlParams.get('password_changed') === 'true') {
            showToast('Đổi mật khẩu thành công!', 'success');
        }
        
        // Hide spinner when page loads
        window.addEventListener('load', function() {
            const spinner = document.getElementById('spinner');
            if (spinner) {
                spinner.classList.remove('show');
            }
            
            // Initialize counter animations
            initCounterAnimations();
        });
        
        // Counter animation function
        function initCounterAnimations() {
            const counters = document.querySelectorAll('.stat-number[data-count]');
            counters.forEach(counter => {
                const target = parseInt(counter.getAttribute('data-count'));
                const duration = 2000; // 2 seconds
                const increment = target / (duration / 16); // 60fps
                let current = 0;
                
                const timer = setInterval(() => {
                    current += increment;
                    if (current >= target) {
                        current = target;
                        clearInterval(timer);
                    }
                    
                    if (counter.textContent.includes('₫')) {
                        counter.textContent = Math.floor(current) + '₫';
                    } else {
                        counter.textContent = Math.floor(current);
                    }
                }, 16);
            });
        }
        
        // Add to wishlist function
        function addToWishlist(productId) {
            // Simulate adding to wishlist
            const wishlistCount = document.getElementById('wishlistCount');
            let count = parseInt(wishlistCount.textContent) || 0;
            count++;
            wishlistCount.textContent = count;
            wishlistCount.style.display = count > 0 ? 'block' : 'none';
            
            showToast('Đã thêm vào danh sách yêu thích!', 'success');
        }
        
        // Add to cart function
        function addToCart(productId) {
            // Simulate adding to cart
            const cartCount = document.getElementById('cartCount');
            let count = parseInt(cartCount.textContent) || 0;
            count++;
            cartCount.textContent = count;
            cartCount.style.display = count > 0 ? 'block' : 'none';
            
            showToast('Đã thêm vào giỏ hàng!', 'success');
        }
        
        // Newsletter subscription
        function subscribeNewsletter() {
            const email = document.querySelector('.newsletter input[type="text"]').value;
            if (email && email.includes('@')) {
                showToast('Đăng ký nhận tin thành công!', 'success');
                document.querySelector('.newsletter input[type="text"]').value = '';
            } else {
                showToast('Vui lòng nhập email hợp lệ!', 'error');
            }
        }
        
        // Add newsletter button event
        document.addEventListener('DOMContentLoaded', function() {
            const newsletterBtn = document.querySelector('.newsletter button');
            if (newsletterBtn) {
                newsletterBtn.addEventListener('click', subscribeNewsletter);
            }
        });
    </script>
</body>
</html>
