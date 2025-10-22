<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Gicungco - Hệ thống thương mại điện tử</title>
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
                        <a href="#" class="text-muted me-2"> Help</a><small> / </small>
                        <a href="#" class="text-muted mx-2"> Support</a><small> / </small>
                        <a href="#" class="text-muted ms-2"> Contact</a>
                    </div>
                </div>
                <div class="col-lg-4 text-center d-flex align-items-center justify-content-center">
                    <small class="text-dark">Call Us:</small>
                    <a href="#" class="text-muted">(+012) 1234 567890</a>
                </div>
                <div class="col-lg-4 text-center text-lg-end">
                    <div class="d-inline-flex align-items-center" style="height: 45px;">
                        <a href="<%= request.getContextPath() %>/login" class="btn btn-outline-primary btn-sm px-3">
                            <i class="bi bi-person me-1"></i>Đăng nhập
                        </a>
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
                            <input class="form-control border-0 rounded-pill w-100 py-3" type="text" data-bs-target="#dropdownToggle123" placeholder="Search Looking For?">
                            <select class="form-select text-dark border-0 border-start rounded-0 p-3" style="width: 200px;">
                                <option value="All Category">All Category</option>
                                <option value="Pest Control-2">Category 1</option>
                                <option value="Pest Control-3">Category 2</option>
                                <option value="Pest Control-4">Category 3</option>
                                <option value="Pest Control-5">Category 4</option>
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
                            <h4 class="m-0"><i class="fa fa-bars me-2"></i>All Categories</h4>
                        </button>
                        <div class="collapse navbar-collapse rounded-bottom" id="allCat">
                            <div class="navbar-nav ms-auto py-0">
                                <ul class="list-unstyled categories-bars">
                                    <li><div class="categories-bars-item"><a href="#">Accessories</a><span>(3)</span></div></li>
                                    <li><div class="categories-bars-item"><a href="#">Electronics & Computer</a><span>(5)</span></div></li>
                                    <li><div class="categories-bars-item"><a href="#">Laptops & Desktops</a><span>(2)</span></div></li>
                                    <li><div class="categories-bars-item"><a href="#">Mobiles & Tablets</a><span>(8)</span></div></li>
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
                                <a href="<%= request.getContextPath() %>/login" class="nav-item nav-link me-2">
                                    <i class="bi bi-person me-1"></i>Đăng nhập
                                </a>
                                <div class="nav-item dropdown d-block d-lg-none mb-3">
                                    <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">All Category</a>
                                    <div class="dropdown-menu m-0">
                                        <ul class="list-unstyled categories-bars">
                                            <li><div class="categories-bars-item"><a href="#">Accessories</a><span>(3)</span></div></li>
                                            <li><div class="categories-bars-item"><a href="#">Electronics & Computer</a><span>(5)</span></div></li>
                                            <li><div class="categories-bars-item"><a href="#">Laptops & Desktops</a><span>(2)</span></div></li>
                                            <li><div class="categories-bars-item"><a href="#">Mobiles & Tablets</a><span>(8)</span></div></li>
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
        <div class="container-fluid py-5">
            <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-6 col-md-8">
                    <form action="<%= request.getContextPath() %>/register" method="post" class="border p-4 rounded bg-white wow fadeInUp" data-wow-delay="0.1s">
                        <h3 class="mb-4 text-center">Tạo tài khoản</h3>

                        <div class="form-group mb-3">
                            <label for="full_name" class="mb-1">Họ và tên</label>
                            <input type="text" class="form-control rounded-pill py-2" id="full_name" name="full_name" required>
                        </div>

                        <div class="form-group mb-3">
                            <label for="email" class="mb-1">Email</label>
                            <input type="email" class="form-control rounded-pill py-2" id="email" name="email" required>
                        </div>

                        <div class="form-group mb-3">
                            <label for="phone_number" class="mb-1">
                                <i class="fas fa-phone me-1"></i>Số điện thoại
                            </label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0">
                                    <i class="fas fa-flag me-1"></i>+84
                                </span>
                                <input type="tel" 
                                       class="form-control rounded-pill rounded-start-0 border-start-0 py-2" 
                                       id="phone_number" 
                                       name="phone_number" 
                                       placeholder="Nhập số điện thoại"
                                       pattern="[0-9]{9,10}"
                                       maxlength="10"
                                       required>
                            </div>
                            <div class="form-text">
                                <i class="fas fa-info-circle me-1"></i>
                                Nhập 9-10 chữ số (VD: 123456789)
                            </div>
                        </div>

                        <div class="form-group mb-3">
                            <label for="password" class="mb-1">Mật khẩu</label>
                            <input type="password" class="form-control rounded-pill py-2" id="password" name="password" minlength="6" required>
                        </div>

                        <div class="form-group mb-4">
                            <label for="confirm_password" class="mb-1">Xác nhận mật khẩu</label>
                            <input type="password" class="form-control rounded-pill py-2" id="confirm_password" name="confirm_password" minlength="6" required>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 rounded-pill py-2"><i class="fas fa-user-plus me-2"></i>Đăng ký</button>

                        <p class="mt-3 text-center">
                            Đã có tài khoản? <a href="<%= request.getContextPath() %>/login">Đăng nhập</a>
                        </p>
                    </form>
                </div>
            </div>
        </div>
        </div>
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
        
        <%-- Include Notification Modal --%>
        <%@ include file="notification-modal.jsp" %>
        
        <a href="#" class="btn btn-primary btn-lg-square back-to-top"><i class="bi bi-arrow-up"></i></a>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/lib/wow/wow.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/lib/easing/easing.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/lib/waypoints/waypoints.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/lib/counterup/counterup.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/lib/owlcarousel/owl.carousel.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/js/main.js"></script>
        
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                const phoneInput = document.getElementById('phone_number');
                const form = document.querySelector('form');
                
                // Phone number validation
                phoneInput.addEventListener('input', function() {
                    let value = this.value.replace(/\D/g, ''); // Remove non-digits
                    this.value = value;
                    
                    // Visual feedback
                    if (value.length >= 9 && value.length <= 10) {
                        this.classList.remove('is-invalid');
                        this.classList.add('is-valid');
                    } else if (value.length > 0) {
                        this.classList.remove('is-valid');
                        this.classList.add('is-invalid');
                    } else {
                        this.classList.remove('is-valid', 'is-invalid');
                    }
                });
                
                // Form validation
                form.addEventListener('submit', function(e) {
                    const phone = phoneInput.value;
                    const password = document.getElementById('password').value;
                    const confirmPassword = document.getElementById('confirm_password').value;
                    
                    // Phone validation
                    if (phone.length < 9 || phone.length > 10) {
                        e.preventDefault();
                        showWarningModal('Input Error!', 'Phone number must have 9-10 digits!');
                        phoneInput.focus();
                        return;
                    }
                    
                    // Password validation
                    if (password.length < 6) {
                        e.preventDefault();
                        showWarningModal('Password Error!', 'Password must have at least 6 characters!');
                        document.getElementById('password').focus();
                        return;
                    }
                    
                    // Confirm password validation
                    if (password !== confirmPassword) {
                        e.preventDefault();
                        showWarningModal('Password Mismatch!', 'Confirm password does not match the entered password!');
                        document.getElementById('confirm_password').focus();
                        return;
                    }
                    
                    // Show loading state
                    const submitBtn = form.querySelector('button[type="submit"]');
                    submitBtn.disabled = true;
                    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Creating account...';
                });
                
                // Handle server-side errors
                <c:if test="${not empty sessionScope.error}">
                    showErrorModal('Registration Error!', '${sessionScope.error}');
                    <c:remove var="error" scope="session" />
                </c:if>
                
                <c:if test="${not empty sessionScope.success}">
                    showSuccessModal('Registration Success!', '${sessionScope.success}');
                    <c:remove var="success" scope="session" />
                </c:if>
            });
        </script>
    </body>
</html>
