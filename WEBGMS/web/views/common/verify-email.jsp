<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Xác Thực Email - Gicungco Marketplace</title>
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
        <!-- Spinner -->
        <div id="spinner" class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
            <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
                <span class="sr-only">Loading...</span>
            </div>
        </div>

        <!-- Top Bar -->
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

        <!-- Header -->
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
                            <input class="form-control border-0 rounded-pill w-100 py-3" type="text" placeholder="Search Looking For?">
                            <select class="form-select text-dark border-0 border-start rounded-0 p-3" style="width: 200px;">
                                <option value="All Category">All Category</option>
                                <option value="Category 1">Category 1</option>
                                <option value="Category 2">Category 2</option>
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

        <!-- Navigation Bar -->
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
                                <a href="#" class="nav-item nav-link">Contact</a>
                            </div>
                            <a href="#" class="btn btn-secondary rounded-pill py-2 px-4 px-lg-3 mb-3 mb-md-3 mb-lg-0"><i class="fa fa-mobile-alt me-2"></i> +0123 456 7890</a>
                        </div>
                    </nav>
                </div>
            </div>
        </div>

        <!-- Verify Email Form -->
        <div class="container-fluid py-5">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-lg-5">
                        <div class="border p-4 shadow rounded bg-light">
                            <h3 class="mb-4 text-center">
                                <i class="fas fa-envelope-circle-check text-primary"></i> Xác Thực Email
                            </h3>
                            <p class="text-muted text-center mb-4">
                                Chúng tôi đã gửi mã xác thực 6 chữ số đến địa chỉ email của bạn. Vui lòng nhập mã bên dưới.
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

                            <!-- Email Display -->
                            <div class="alert alert-info">
                                <small><i class="fas fa-envelope"></i> Email đăng ký:</small><br>
                                <strong>${sessionScope.verification_email}</strong>
                            </div>

                            <!-- Verification Form -->
                            <form action="<%= request.getContextPath() %>/verify-email" method="post">
                                <input type="hidden" name="action" value="verify">
                                <input type="hidden" name="email" value="${sessionScope.verification_email}">
                                
                                <div class="form-group mb-3">
                                    <label for="verification_code" class="form-label">
                                        <i class="fas fa-key"></i> Mã Xác Thực
                                    </label>
                                    <input type="text" class="form-control text-center" id="verification_code" 
                                           name="code" placeholder="Nhập mã 6 chữ số" 
                                           maxlength="6" pattern="[0-9]{6}" required
                                           style="font-size: 24px; letter-spacing: 8px; font-weight: bold;"
                                           oninput="this.value = this.value.replace(/[^0-9]/g, '')">
                                    <div class="form-text text-center">
                                        <i class="fas fa-clock"></i> Mã này sẽ hết hạn sau 15 phút
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-primary w-100 mb-3">
                                    <i class="fas fa-check"></i> Xác Thực Email
                                </button>
                            </form>

                            <!-- Resend Code Form -->
                            <form action="<%= request.getContextPath() %>/verify-email" method="post">
                                <input type="hidden" name="action" value="resend">
                                <input type="hidden" name="email" value="${sessionScope.verification_email}">
                                <button type="submit" class="btn btn-outline-secondary w-100 mb-3">
                                    <i class="fas fa-rotate"></i> Gửi Lại Mã Xác Thực
                                </button>
                            </form>

                            <!-- Help Text -->
                            <div class="text-center text-muted" style="font-size: 14px;">
                                <p class="mb-2">
                                    <i class="fas fa-info-circle"></i> Không nhận được email?
                                </p>
                                <ul class="list-unstyled small">
                                    <li>• Kiểm tra thư mục spam/junk</li>
                                    <li>• Đợi vài phút rồi nhấn "Gửi Lại Mã"</li>
                                    <li>• Đảm bảo email đăng ký đúng</li>
                                </ul>
                            </div>

                            <hr>

                            <div class="text-center">
                                <a href="<%= request.getContextPath() %>/register" class="text-decoration-none">
                                    <i class="fas fa-arrow-left"></i> Quay Lại Đăng Ký
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
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
                            <a class="text-white-50 mb-2" href="#"><i class="fa fa-angle-right me-2"></i>Khuyến mãi</a>
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

        <!-- Back to Top -->
        <a href="#" class="btn btn-primary btn-lg-square back-to-top"><i class="bi bi-arrow-up"></i></a>

        <!-- JavaScript Libraries -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/lib/wow/wow.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/lib/easing/easing.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/lib/waypoints/waypoints.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/lib/counterup/counterup.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/lib/owlcarousel/owl.carousel.min.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/electro/js/main.js"></script>
        <script src="<%= request.getContextPath() %>/views/assets/js/auth-enhancement.js"></script>
        
        <!-- Custom JavaScript -->
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                // Auto-focus on verification code input
                const verificationCodeInput = document.getElementById('verification_code');
                if (verificationCodeInput) {
                    verificationCodeInput.focus();
                }
                
                // Auto-hide alerts after 5 seconds
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(alert => {
                    setTimeout(() => {
                        const bsAlert = new bootstrap.Alert(alert);
                        bsAlert.close();
                    }, 5000);
                });
            });
        </script>
    </body>
</html>
