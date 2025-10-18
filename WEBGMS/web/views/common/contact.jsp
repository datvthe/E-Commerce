<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <title>Liên Hệ - Gicungco Marketplace</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta content="Liên hệ với Gicungco - Hỗ trợ khách hàng 24/7" name="description">
    
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
        .contact-hero {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 80px 0;
        }
        
        .contact-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        
        .contact-card:hover {
            transform: translateY(-5px);
        }
        
        .contact-info {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 30px;
            margin-bottom: 30px;
        }
        
        .contact-info i {
            font-size: 2rem;
            color: #667eea;
            margin-bottom: 15px;
        }
        
        .form-control {
            border-radius: 10px;
            border: 2px solid #e9ecef;
            padding: 15px;
            font-size: 16px;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 10px;
            padding: 15px 30px;
            font-weight: 600;
        }
        
        .map-container {
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
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
                            <a href="<%= request.getContextPath() %>/about" class="nav-item nav-link">Về chúng tôi</a>
                            <a href="<%= request.getContextPath() %>/contact" class="nav-item nav-link active">Liên hệ</a>
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

    <!-- Contact Hero Start -->
    <div class="contact-hero">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <h1 class="display-4 fw-bold mb-4">Liên Hệ Với Chúng Tôi</h1>
                    <p class="lead mb-4">Chúng tôi luôn sẵn sàng lắng nghe và hỗ trợ bạn. Hãy liên hệ với chúng tôi qua bất kỳ kênh nào thuận tiện nhất.</p>
                </div>
                <div class="col-lg-6">
                    <img src="<%= request.getContextPath() %>/views/assets/electro/img/contact-hero.png" alt="Contact Us" class="img-fluid rounded">
                </div>
            </div>
        </div>
    </div>
    <!-- Contact Hero End -->

    <!-- Contact Info Start -->
    <div class="container py-5">
        <div class="row">
            <div class="col-lg-4 mb-4">
                <div class="contact-info text-center">
                    <i class="fas fa-map-marker-alt"></i>
                    <h5>Địa Chỉ</h5>
                    <p>123 Đường ABC, Quận 1<br>Thành phố Hồ Chí Minh, Việt Nam</p>
                </div>
            </div>
            <div class="col-lg-4 mb-4">
                <div class="contact-info text-center">
                    <i class="fas fa-phone"></i>
                    <h5>Điện Thoại</h5>
                    <p>Hotline: <a href="tel:+84123456789">(+84) 123 456 789</a><br>Hỗ trợ: <a href="tel:+84123456788">(+84) 123 456 788</a></p>
                </div>
            </div>
            <div class="col-lg-4 mb-4">
                <div class="contact-info text-center">
                    <i class="fas fa-envelope"></i>
                    <h5>Email</h5>
                    <p>Chung: <a href="mailto:info@gicungco.com">info@gicungco.com</a><br>Hỗ trợ: <a href="mailto:support@gicungco.com">support@gicungco.com</a></p>
                </div>
            </div>
        </div>
    </div>
    <!-- Contact Info End -->

    <!-- Contact Form & Map Start -->
    <div class="container py-5">
        <div class="row">
            <div class="col-lg-8 mb-5">
                <div class="contact-card card">
                    <div class="card-body p-5">
                        <h3 class="card-title text-primary mb-4">Gửi Tin Nhắn Cho Chúng Tôi</h3>
                        <form action="<%= request.getContextPath() %>/contact" method="post">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="name" class="form-label">Họ và tên *</label>
                                    <input type="text" class="form-control" id="name" name="name" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="email" class="form-label">Email *</label>
                                    <input type="email" class="form-control" id="email" name="email" required>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="phone" class="form-label">Số điện thoại</label>
                                    <input type="tel" class="form-control" id="phone" name="phone">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="subject" class="form-label">Chủ đề *</label>
                                    <select class="form-control" id="subject" name="subject" required>
                                        <option value="">Chọn chủ đề</option>
                                        <option value="general">Câu hỏi chung</option>
                                        <option value="support">Hỗ trợ kỹ thuật</option>
                                        <option value="business">Hợp tác kinh doanh</option>
                                        <option value="complaint">Khiếu nại</option>
                                        <option value="suggestion">Góp ý</option>
                                    </select>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="message" class="form-label">Nội dung tin nhắn *</label>
                                <textarea class="form-control" id="message" name="message" rows="5" required placeholder="Hãy mô tả chi tiết vấn đề hoặc câu hỏi của bạn..."></textarea>
                            </div>
                            <div class="mb-3 form-check">
                                <input type="checkbox" class="form-check-input" id="agree" name="agree" required>
                                <label class="form-check-label" for="agree">
                                    Tôi đồng ý với <a href="#" class="text-primary">Chính sách bảo mật</a> và <a href="#" class="text-primary">Điều khoản sử dụng</a>
                                </label>
                            </div>
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-paper-plane me-2"></i>Gửi Tin Nhắn
                            </button>
                        </form>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="contact-card card">
                    <div class="card-body p-5">
                        <h3 class="card-title text-primary mb-4">Thông Tin Liên Hệ</h3>
                        <div class="mb-4">
                            <h6><i class="fas fa-clock text-primary me-2"></i>Giờ Làm Việc</h6>
                            <p class="mb-0">Thứ 2 - Thứ 6: 8:00 - 18:00<br>Thứ 7: 8:00 - 12:00<br>Chủ nhật: Nghỉ</p>
                        </div>
                        <div class="mb-4">
                            <h6><i class="fas fa-headset text-primary me-2"></i>Hỗ Trợ 24/7</h6>
                            <p class="mb-0">Hotline: <a href="tel:+84123456789" class="text-primary">(+84) 123 456 789</a><br>Email: <a href="mailto:support@gicungco.com" class="text-primary">support@gicungco.com</a></p>
                        </div>
                        <div class="mb-4">
                            <h6><i class="fas fa-share-alt text-primary me-2"></i>Mạng Xã Hội</h6>
                            <div class="d-flex gap-2">
                                <a href="#" class="btn btn-outline-primary btn-sm"><i class="fab fa-facebook-f"></i></a>
                                <a href="#" class="btn btn-outline-primary btn-sm"><i class="fab fa-twitter"></i></a>
                                <a href="#" class="btn btn-outline-primary btn-sm"><i class="fab fa-instagram"></i></a>
                                <a href="#" class="btn btn-outline-primary btn-sm"><i class="fab fa-linkedin-in"></i></a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Contact Form & Map End -->

    <!-- Map Start -->
    <div class="container py-5">
        <div class="row">
            <div class="col-12">
                <h3 class="text-center mb-4">Vị Trí Văn Phòng</h3>
                <div class="map-container">
                    <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3919.325311359028!2d106.664087315332!3d10.776201392315!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31752ed2392c44df%3A0xd2ecb62e0d050fe9!2sLandmark%2081!5e0!3m2!1svi!2s!4v1634567890123!5m2!1svi!2s" 
                            width="100%" height="400" style="border:0;" allowfullscreen="" loading="lazy"></iframe>
                </div>
            </div>
        </div>
    </div>
    <!-- Map End -->

    <!-- FAQ Section Start -->
    <div class="container py-5">
        <h3 class="text-center mb-5">Câu Hỏi Thường Gặp</h3>
        <div class="row">
            <div class="col-lg-8 mx-auto">
                <div class="accordion" id="faqAccordion">
                    <div class="accordion-item">
                        <h2 class="accordion-header" id="faq1">
                            <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapse1">
                                Làm thế nào để đăng ký tài khoản?
                            </button>
                        </h2>
                        <div id="collapse1" class="accordion-collapse collapse show" data-bs-parent="#faqAccordion">
                            <div class="accordion-body">
                                Bạn có thể đăng ký tài khoản bằng cách click vào nút "Đăng ký" ở góc trên bên phải, hoặc sử dụng tài khoản Google để đăng nhập nhanh.
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item">
                        <h2 class="accordion-header" id="faq2">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse2">
                                Phương thức thanh toán nào được hỗ trợ?
                            </button>
                        </h2>
                        <div id="collapse2" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                            <div class="accordion-body">
                                Chúng tôi hỗ trợ nhiều phương thức thanh toán: VNPay, MoMo, ZaloPay, thẻ tín dụng/ghi nợ, và thanh toán khi nhận hàng (COD).
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item">
                        <h2 class="accordion-header" id="faq3">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse3">
                                Thời gian giao hàng là bao lâu?
                            </button>
                        </h2>
                        <div id="collapse3" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                            <div class="accordion-body">
                                Đối với sản phẩm số (digital goods), bạn sẽ nhận được ngay sau khi thanh toán. Đối với sản phẩm vật lý, thời gian giao hàng từ 1-3 ngày làm việc.
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item">
                        <h2 class="accordion-header" id="faq4">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse4">
                                Làm thế nào để liên hệ hỗ trợ?
                            </button>
                        </h2>
                        <div id="collapse4" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                            <div class="accordion-body">
                                Bạn có thể liên hệ chúng tôi qua hotline (+84) 123 456 789, email support@gicungco.com, hoặc sử dụng form liên hệ trên trang này.
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- FAQ Section End -->

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
        
        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const name = document.getElementById('name').value.trim();
            const email = document.getElementById('email').value.trim();
            const subject = document.getElementById('subject').value;
            const message = document.getElementById('message').value.trim();
            const agree = document.getElementById('agree').checked;
            
            if (!name || !email || !subject || !message || !agree) {
                e.preventDefault();
                alert('Vui lòng điền đầy đủ thông tin và đồng ý với điều khoản sử dụng.');
                return;
            }
            
            // Email validation
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                e.preventDefault();
                alert('Vui lòng nhập địa chỉ email hợp lệ.');
                return;
            }
        });
    </script>
</body>
</html>
