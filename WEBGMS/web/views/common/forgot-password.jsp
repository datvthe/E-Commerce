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
                        <a href="<%= request.getContextPath() %>/login" class="btn btn-outline-primary btn-sm px-3 me-2">
                            <i class="bi bi-person me-1"></i>Đăng nhập
                        </a>
                        <a href="<%= request.getContextPath() %>/register" class="btn btn-outline-success btn-sm px-3">
                            <i class="bi bi-person-plus me-1"></i>Đăng ký
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
                            <h1 class="display-5 text-primary m-0"><i class="fas fa-shopping-bag text-secondary me-2"></i>Electro</h1>
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
                        <a href="" class="navbar-brand d-block d-lg-none">
                            <h1 class="display-5 text-secondary m-0"><i class="fas fa-shopping-bag text-white me-2"></i>Electro</h1>
                        </a>
                        <button class="navbar-toggler ms-auto" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
                            <span class="fa fa-bars fa-1x"></span>
                        </button>
                        <div class="collapse navbar-collapse" id="navbarCollapse">
                            <div class="navbar-nav ms-auto py-0">
                                <a href="<%= request.getContextPath() %>/home" class="nav-item nav-link">Home</a>
                                <a href="<%= request.getContextPath() %>/products" class="nav-item nav-link">Shop</a>
                                <a href="#" class="nav-item nav-link">Single Page</a>
                                <div class="nav-item dropdown">
                                    <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">Pages</a>
                                    <div class="dropdown-menu m-0">
                                        <a href="#" class="dropdown-item">Bestseller</a>
                                        <a href="#" class="dropdown-item">Cart Page</a>
                                        <a href="#" class="dropdown-item">Cheackout</a>
                                        <a href="#" class="dropdown-item">404 Page</a>
                                    </div>
                                </div>
                                <a href="#" class="nav-item nav-link me-2">Contact</a>
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
                <div class="col-lg-5">
                    
                    <!-- Step 1: Request Reset -->
                    <c:if test="${param.step == null || param.step == 'request'}">
                        <div class="border p-4 shadow rounded bg-light">
                            <h3 class="mb-4 text-center">
                                <i class="fas fa-key text-primary"></i> Đặt Lại Mật Khẩu
                            </h3>
                            <p class="text-muted text-center mb-4">
                                Nhập địa chỉ email của bạn và chúng tôi sẽ gửi mã xác thực để đặt lại mật khẩu.
                            </p>

                            <!-- Display Messages -->
                            <c:if test="${not empty sessionScope.message}">
                                <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    <i class="fas fa-check-circle"></i> ${sessionScope.message}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                                <c:remove var="message" scope="session"/>
                            </c:if>

                            <c:if test="${not empty sessionScope.error}">
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="fas fa-exclamation-circle"></i> ${sessionScope.error}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                                <c:remove var="error" scope="session"/>
                            </c:if>

                            <form action="<%= request.getContextPath() %>/forgot-password" method="post">
                                <input type="hidden" name="action" value="request-reset">
                                
                                <div class="form-group mb-3">
                                    <label for="email" class="form-label">
                                        <i class="fas fa-envelope"></i> Địa Chỉ Email
                                    </label>
                                    <input type="email" class="form-control" id="email" name="email"
                                           placeholder="Nhập địa chỉ email của bạn" required>
                                </div>

                                <button type="submit" class="btn btn-primary w-100 mb-3">
                                    <i class="fas fa-paper-plane"></i> Gửi Mã Xác Thực
                                </button>

                                <div class="text-center">
                                    <a href="<%= request.getContextPath() %>/login" class="text-decoration-none">
                                        <i class="fas fa-arrow-left"></i> Quay Lại Đăng Nhập
                                    </a>
                                </div>
                            </form>
                        </div>
                    </c:if>

                    <!-- Step 2: Verify Code -->
                    <c:if test="${param.step == 'verify'}">
                        <div class="border p-4 shadow rounded bg-light">
                            <h3 class="mb-4 text-center">
                                <i class="fas fa-shield-alt text-primary"></i> Xác Thực Mã
                            </h3>
                            <p class="text-muted text-center mb-4">
                                Chúng tôi đã gửi mã xác thực 6 chữ số đến địa chỉ email của bạn. Vui lòng nhập mã bên dưới.
                            </p>

                            <!-- Display Messages -->
                            <c:if test="${not empty sessionScope.message}">
                                <div class="alert alert-info alert-dismissible fade show" role="alert">
                                    <i class="fas fa-info-circle"></i> ${sessionScope.message}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                                <c:remove var="message" scope="session"/>
                            </c:if>

                            <c:if test="${not empty sessionScope.error}">
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="fas fa-exclamation-circle"></i> ${sessionScope.error}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                                <c:remove var="error" scope="session"/>
                            </c:if>

                            <form action="<%= request.getContextPath() %>/forgot-password" method="post">
                                <input type="hidden" name="action" value="verify-code">
                                
                                <div class="form-group mb-3">
                                    <label for="email" class="form-label">
                                        <i class="fas fa-envelope"></i> Địa Chỉ Email
                                    </label>
                                    <input type="email" class="form-control" id="email" name="email"
                                           value="${sessionScope.reset_email}" readonly>
                                </div>

                                <div class="form-group mb-3">
                                    <label for="verification_code" class="form-label">
                                        <i class="fas fa-key"></i> Mã Xác Thực
                                    </label>
                                    <input type="text" class="form-control text-center" id="verification_code" 
                                           name="verification_code" placeholder="Nhập mã 6 chữ số" 
                                           maxlength="6" pattern="[0-9]{6}" required>
                                    <div class="form-text">Nhập mã 6 chữ số đã được gửi đến email của bạn</div>
                                </div>

                                <button type="submit" class="btn btn-primary w-100 mb-3">
                                    <i class="fas fa-check"></i> Xác Thực Mã
                                </button>

                                <div class="text-center">
                                    <a href="<%= request.getContextPath() %>/forgot-password" class="text-decoration-none">
                                        <i class="fas fa-arrow-left"></i> Quay Lại Nhập Email
                                    </a>
                                </div>
                            </form>
                        </div>
                    </c:if>

                    <!-- Step 3: Reset Password -->
                    <c:if test="${param.step == 'reset'}">
                        <div class="border p-4 shadow rounded bg-light">
                            <h3 class="mb-4 text-center">
                                <i class="fas fa-lock text-primary"></i> Đặt Mật Khẩu Mới
                            </h3>
                            <p class="text-muted text-center mb-4">
                                Vui lòng nhập mật khẩu mới của bạn bên dưới.
                            </p>

                            <!-- Display Messages -->
                            <c:if test="${not empty sessionScope.message}">
                                <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    <i class="fas fa-check-circle"></i> ${sessionScope.message}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                                <c:remove var="message" scope="session"/>
                            </c:if>

                            <c:if test="${not empty sessionScope.error}">
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="fas fa-exclamation-circle"></i> ${sessionScope.error}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                                <c:remove var="error" scope="session"/>
                            </c:if>

                            <form action="<%= request.getContextPath() %>/forgot-password" method="post" id="resetForm">
                                <input type="hidden" name="action" value="reset-password">
                                <input type="hidden" name="email" value="${sessionScope.reset_email}">
                                <input type="hidden" name="reset_id" value="${sessionScope.reset_id}">
                                
                                <div class="form-group mb-3">
                                    <label for="new_password" class="form-label">
                                        <i class="fas fa-lock"></i> Mật Khẩu Mới
                                    </label>
                                    <input type="password" class="form-control" id="new_password" name="new_password"
                                           placeholder="Nhập mật khẩu mới" minlength="6" required>
                                    <div class="form-text">Mật khẩu phải có ít nhất 6 ký tự</div>
                                </div>

                                <div class="form-group mb-3">
                                    <label for="confirm_password" class="form-label">
                                        <i class="fas fa-lock"></i> Xác Nhận Mật Khẩu Mới
                                    </label>
                                    <input type="password" class="form-control" id="confirm_password" name="confirm_password"
                                           placeholder="Xác nhận mật khẩu mới" minlength="6" required>
                                </div>

                                <button type="submit" class="btn btn-success w-100 mb-3">
                                    <i class="fas fa-save"></i> Đặt Lại Mật Khẩu
                                </button>

                                <div class="text-center">
                                    <a href="<%= request.getContextPath() %>/login" class="text-decoration-none">
                                        <i class="fas fa-arrow-left"></i> Quay Lại Đăng Nhập
                                    </a>
                                </div>
                            </form>
                        </div>
                    </c:if>

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
        <a href="#" class="btn btn-primary btn-lg-square back-to-top"><i class="bi bi-arrow-up"></i></a>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/lib/wow/wow.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/lib/easing/easing.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/lib/waypoints/waypoints.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/lib/counterup/counterup.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/lib/owlcarousel/owl.carousel.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/js/main.js"></script>
        
        <!-- Custom JavaScript for password confirmation -->
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                const resetForm = document.getElementById('resetForm');
                if (resetForm) {
                    resetForm.addEventListener('submit', function(e) {
                        const newPassword = document.getElementById('new_password').value;
                        const confirmPassword = document.getElementById('confirm_password').value;
                        
                        if (newPassword !== confirmPassword) {
                            e.preventDefault();
                            alert('Mật khẩu không khớp!');
                            return false;
                        }
                    });
                }
                
                // Auto-focus on verification code input
                const verificationCodeInput = document.getElementById('verification_code');
                if (verificationCodeInput) {
                    verificationCodeInput.focus();
                }
            });
        </script>
    </body>
</html>
