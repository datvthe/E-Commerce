<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <title>Về Chúng Tôi - Gicungco Marketplace</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta content="Tìm hiểu về Gicungco - Nền tảng thương mại điện tử hàng đầu Việt Nam" name="description">
    
    <!-- Favicon -->
    <link href="<%= request.getContextPath() %>/views/assets/electro/img/favicon.ico" rel="icon">
    
    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500;600;700&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    
    <!-- Icon Font Stylesheet -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">
    
    <!-- Libraries Stylesheet -->
    <link href="<%= request.getContextPath() %>/views/assets/electro/lib/animate/animate.min.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/views/assets/electro/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
    
    <!-- Customized Bootstrap Stylesheet -->
    <link href="<%= request.getContextPath() %>/views/assets/electro/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Template Stylesheet -->
    <link href="<%= request.getContextPath() %>/views/assets/electro/css/style.css" rel="stylesheet">
    
    <style>
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 100px 0;
        }
        
        .about-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        
        .about-card:hover {
            transform: translateY(-10px);
        }
        
        .stat-number {
            font-size: 3rem;
            font-weight: bold;
            color: #667eea;
        }
        
        .team-member {
            text-align: center;
            padding: 20px;
        }
        
        .team-member img {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 20px;
        }
        
        .timeline-item {
            position: relative;
            padding-left: 50px;
            margin-bottom: 30px;
        }
        
        .timeline-item::before {
            content: '';
            position: absolute;
            left: 15px;
            top: 0;
            width: 2px;
            height: 100%;
            background: #667eea;
        }
        
        .timeline-item::after {
            content: '';
            position: absolute;
            left: 10px;
            top: 10px;
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: #667eea;
        }
    </style>
</head>

<body>
    <!-- Spinner Start -->
    <div id="spinner" class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
        <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
            <span class="sr-only">Loading...</span>
        </div>
    </div>
    <!-- Spinner End -->

    <!-- Topbar Start -->
    <div class="container-fluid px-5 d-none border-bottom d-lg-block">
        <div class="row gx-0 align-items-center">
            <div class="col-lg-4 text-center text-lg-start mb-lg-0">
                <div class="d-inline-flex align-items-center" style="height: 45px;">
                    <a href="#" class="text-muted me-2">Trợ giúp</a><small> / </small>
                    <a href="#" class="text-muted mx-2">Hỗ trợ</a><small> / </small>
                    <a href="<%= request.getContextPath() %>/contact" class="text-muted ms-2">Liên hệ</a>
                </div>
            </div>
            <div class="col-lg-4 text-center d-flex align-items-center justify-content-center">
                <small class="text-dark">Hotline:</small>
                <a href="tel:+84123456789" class="text-muted">(+84) 123 456 789</a>
            </div>
            <div class="col-lg-4 text-center text-lg-end">
                <div class="d-inline-flex align-items-center" style="height: 45px;">
                    <a href="<%= request.getContextPath() %>/login" class="btn btn-outline-success btn-sm px-3">
                        <i class="bi bi-person-plus me-1"></i>Đăng nhập
                    </a>
                </div>
            </div>
        </div>
    </div>
    <!-- Topbar End -->

    <!-- Navbar Start -->
    <div class="container-fluid px-5 py-4 d-none d-lg-block">
        <div class="row gx-0 align-items-center text-center">
            <div class="col-12 col-lg-3">
                <a href="<%= request.getContextPath() %>/home" class="navbar-brand d-block d-lg-none">
                    <h1 class="display-5 text-secondary m-0"><i class="fas fa-shopping-bag text-white me-2"></i>Gicungco</h1>
                </a>
                <a href="<%= request.getContextPath() %>/home" class="navbar-brand d-none d-lg-block">
                    <h1 class="display-5 text-secondary m-0"><i class="fas fa-shopping-bag text-white me-2"></i>Gicungco</h1>
                </a>
            </div>
            <div class="col-12 col-lg-9">
                <nav class="navbar navbar-expand-lg navbar-light bg-primary">
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
                            <a href="<%= request.getContextPath() %>/about" class="nav-item nav-link active">Về chúng tôi</a>
                            <a href="<%= request.getContextPath() %>/contact" class="nav-item nav-link">Liên hệ</a>
                            <a href="<%= request.getContextPath() %>/login" class="nav-item nav-link me-2">
                                <i class="bi bi-person-plus me-1"></i>Đăng nhập
                            </a>
                        </div>
                    </div>
                </nav>
            </div>
        </div>
    </div>
    <!-- Navbar End -->

    <!-- Hero Section Start -->
    <div class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <h1 class="display-4 fw-bold mb-4">Về Gicungco Marketplace</h1>
                    <p class="lead mb-4">Nền tảng thương mại điện tử hàng đầu Việt Nam, kết nối người mua và người bán một cách an toàn, tiện lợi và đáng tin cậy.</p>
                    <div class="d-flex gap-3">
                        <a href="<%= request.getContextPath() %>/products" class="btn btn-light btn-lg">Khám phá ngay</a>
                        <a href="<%= request.getContextPath() %>/contact" class="btn btn-outline-light btn-lg">Liên hệ chúng tôi</a>
                    </div>
                </div>
                <div class="col-lg-6">
                    <img src="<%= request.getContextPath() %>/views/assets/electro/img/about-hero.png" alt="About Gicungco" class="img-fluid rounded">
                </div>
            </div>
        </div>
    </div>
    <!-- Hero Section End -->

    <!-- Stats Section Start -->
    <div class="container py-5">
        <div class="row text-center">
            <div class="col-md-3 mb-4">
                <div class="about-card card h-100">
                    <div class="card-body text-center">
                        <div class="stat-number">10K+</div>
                        <h5 class="card-title">Người dùng</h5>
                        <p class="card-text">Hơn 10,000 người dùng tin tưởng</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-4">
                <div class="about-card card h-100">
                    <div class="card-body text-center">
                        <div class="stat-number">50K+</div>
                        <h5 class="card-title">Sản phẩm</h5>
                        <p class="card-text">Hơn 50,000 sản phẩm đa dạng</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-4">
                <div class="about-card card h-100">
                    <div class="card-body text-center">
                        <div class="stat-number">1K+</div>
                        <h5 class="card-title">Người bán</h5>
                        <p class="card-text">Hơn 1,000 shop uy tín</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-4">
                <div class="about-card card h-100">
                    <div class="card-body text-center">
                        <div class="stat-number">99%</div>
                        <h5 class="card-title">Hài lòng</h5>
                        <p class="card-text">Tỷ lệ hài lòng khách hàng</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Stats Section End -->

    <!-- Mission & Vision Section Start -->
    <div class="container py-5">
        <div class="row">
            <div class="col-lg-6 mb-5">
                <div class="about-card card h-100">
                    <div class="card-body p-5">
                        <h3 class="card-title text-primary mb-4">Sứ Mệnh</h3>
                        <p class="card-text lead">Chúng tôi cam kết mang đến trải nghiệm mua sắm trực tuyến tốt nhất cho người Việt Nam, với sự đa dạng về sản phẩm, giá cả cạnh tranh và dịch vụ khách hàng xuất sắc.</p>
                        <ul class="list-unstyled">
                            <li><i class="fas fa-check text-success me-2"></i>An toàn và bảo mật tuyệt đối</li>
                            <li><i class="fas fa-check text-success me-2"></i>Giao dịch minh bạch, công bằng</li>
                            <li><i class="fas fa-check text-success me-2"></i>Hỗ trợ khách hàng 24/7</li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="col-lg-6 mb-5">
                <div class="about-card card h-100">
                    <div class="card-body p-5">
                        <h3 class="card-title text-primary mb-4">Tầm Nhìn</h3>
                        <p class="card-text lead">Trở thành nền tảng thương mại điện tử số 1 Việt Nam, kết nối mọi người dân Việt Nam với thế giới số, tạo ra một cộng đồng mua sắm thông minh và bền vững.</p>
                        <ul class="list-unstyled">
                            <li><i class="fas fa-check text-success me-2"></i>Mở rộng ra toàn Đông Nam Á</li>
                            <li><i class="fas fa-check text-success me-2"></i>Ứng dụng công nghệ AI tiên tiến</li>
                            <li><i class="fas fa-check text-success me-2"></i>Phát triển bền vững và thân thiện môi trường</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Mission & Vision Section End -->

    <!-- Timeline Section Start -->
    <div class="container py-5">
        <h2 class="text-center mb-5">Hành Trình Phát Triển</h2>
        <div class="row">
            <div class="col-lg-8 mx-auto">
                <div class="timeline-item">
                    <h5>2020 - Khởi Đầu</h5>
                    <p>Gicungco được thành lập với tầm nhìn tạo ra một nền tảng thương mại điện tử dành riêng cho thị trường Việt Nam.</p>
                </div>
                <div class="timeline-item">
                    <h5>2021 - Phát Triển</h5>
                    <p>Ra mắt phiên bản beta với 100 người dùng đầu tiên và 1,000 sản phẩm từ 50 shop đối tác.</p>
                </div>
                <div class="timeline-item">
                    <h5>2022 - Mở Rộng</h5>
                    <p>Chính thức ra mắt với 10,000 người dùng và mở rộng sang thị trường digital goods.</p>
                </div>
                <div class="timeline-item">
                    <h5>2023 - Đổi Mới</h5>
                    <p>Tích hợp AI và machine learning để cải thiện trải nghiệm người dùng và tối ưu hóa tìm kiếm sản phẩm.</p>
                </div>
                <div class="timeline-item">
                    <h5>2024 - Hiện Tại</h5>
                    <p>Trở thành một trong những nền tảng thương mại điện tử hàng đầu Việt Nam với hơn 50,000 sản phẩm.</p>
                </div>
            </div>
        </div>
    </div>
    <!-- Timeline Section End -->

    <!-- Team Section Start -->
    <div class="container py-5">
        <h2 class="text-center mb-5">Đội Ngũ Của Chúng Tôi</h2>
        <div class="row">
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="team-member">
                    <img src="<%= request.getContextPath() %>/views/assets/electro/img/team-1.jpg" alt="CEO" class="img-fluid">
                    <h5>Nguyễn Văn A</h5>
                    <p class="text-muted">CEO & Founder</p>
                    <p>15 năm kinh nghiệm trong lĩnh vực thương mại điện tử và công nghệ.</p>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="team-member">
                    <img src="<%= request.getContextPath() %>/views/assets/electro/img/team-2.jpg" alt="CTO" class="img-fluid">
                    <h5>Trần Thị B</h5>
                    <p class="text-muted">CTO</p>
                    <p>Chuyên gia công nghệ với 12 năm kinh nghiệm phát triển hệ thống lớn.</p>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="team-member">
                    <img src="<%= request.getContextPath() %>/views/assets/electro/img/team-3.jpg" alt="CMO" class="img-fluid">
                    <h5>Lê Văn C</h5>
                    <p class="text-muted">CMO</p>
                    <p>Chuyên gia marketing với kinh nghiệm quốc tế trong lĩnh vực e-commerce.</p>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="team-member">
                    <img src="<%= request.getContextPath() %>/views/assets/electro/img/team-4.jpg" alt="CFO" class="img-fluid">
                    <h5>Phạm Thị D</h5>
                    <p class="text-muted">CFO</p>
                    <p>Chuyên gia tài chính với 10 năm kinh nghiệm trong lĩnh vực fintech.</p>
                </div>
            </div>
        </div>
    </div>
    <!-- Team Section End -->

    <!-- CTA Section Start -->
    <div class="container-fluid bg-primary py-5">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-8">
                    <h3 class="text-white mb-3">Sẵn sàng bắt đầu hành trình mua sắm?</h3>
                    <p class="text-white mb-0">Tham gia cùng hơn 10,000 người dùng đã tin tưởng Gicungco!</p>
                </div>
                <div class="col-lg-4 text-lg-end">
                    <a href="<%= request.getContextPath() %>/products" class="btn btn-light btn-lg">Khám phá ngay</a>
                </div>
            </div>
        </div>
    </div>
    <!-- CTA Section End -->

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
                        <a class="text-white-50 mb-2" href="<%= request.getContextPath() %>/about"><i class="fa fa-angle-right me-2"></i>Về chúng tôi</a>
                        <a class="text-white-50 mb-2" href="<%= request.getContextPath() %>/contact"><i class="fa fa-angle-right me-2"></i>Liên hệ</a>
                        <a class="text-white-50 mb-2" href="#"><i class="fa fa-angle-right me-2"></i>Hỗ trợ khách hàng</a>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <h5 class="text-white text-uppercase mb-4">Liên kết</h5>
                    <div class="d-flex flex-column justify-content-start">
                        <a class="text-white-50 mb-2" href="#"><i class="fa fa-angle-right me-2"></i>Chính sách bảo mật</a>
                        <a class="text-white-50 mb-2" href="#"><i class="fa fa-angle-right me-2"></i>Điều khoản sử dụng</a>
                        <a class="text-white-50 mb-2" href="#"><i class="fa fa-angle-right me-2"></i>Chính sách vận chuyển</a>
                        <a class="text-white-50 mb-2" href="#"><i class="fa fa-angle-right me-2"></i>Chính sách đổi trả</a>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <h5 class="text-white text-uppercase mb-4">Liên hệ</h5>
                    <p><i class="fa fa-map-marker-alt me-3"></i>123 Đường ABC, Quận 1, TP.HCM</p>
                    <p><i class="fa fa-phone-alt me-3"></i>+84 123 456 789</p>
                    <p><i class="fa fa-envelope me-3"></i>info@gicungco.com</p>
                </div>
            </div>
        </div>
        <div class="container">
            <div class="copyright">
                <div class="row">
                    <div class="col-md-6 text-center text-md-start mb-3 mb-md-0">
                        &copy; <a class="border-bottom" href="#">Gicungco Marketplace</a>, All Right Reserved.
                    </div>
                    <div class="col-md-6 text-center text-md-end">
                        <div class="footer-menu">
                            <a href="#">Home</a>
                            <a href="#">Cookies</a>
                            <a href="#">Help</a>
                            <a href="#">FQAs</a>
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
    <script src="<%= request.getContextPath() %>/views/assets/electro/lib/owlcarousel/owl.carousel.min.js"></script>
    <script src="<%= request.getContextPath() %>/views/assets/electro/lib/counterup/counterup.min.js"></script>

    <!-- Template Javascript -->
    <script src="<%= request.getContextPath() %>/views/assets/electro/js/main.js"></script>
    
    <script>
        // Hide spinner when page loads
        window.addEventListener('load', function() {
            document.getElementById('spinner').style.display = 'none';
        });
    </script>
</body>
</html>
