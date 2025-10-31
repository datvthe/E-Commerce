<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Hồ sơ cá nhân - Gicungco</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                font-family: 'Open Sans', sans-serif;
                background-color: #f8f9fa;
            }
            .profile-header {
                background: linear-gradient(135deg, #5b46f1, #8c52ff);
                color: white;
                padding: 30px 20px;
                border-radius: 10px 10px 0 0;
                text-align: center;
            }
            .profile-avatar {
                width: 110px;
                height: 110px;
                border-radius: 50%;
                border: 4px solid white;
                object-fit: cover;
                margin-bottom: 10px;
            }
            .profile-stat {
                background: white;
                border-radius: 15px;
                padding: 25px 10px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.05);
                text-align: center;
                color: #444;
            }
            .profile-stat h4 {
                color: #6c63ff;
                font-weight: 600;
            }
            .nav-tabs .nav-link.active {
                background-color: #6c63ff !important;
                color: white !important;
            }
            .nav-tabs .nav-link {
                color: #6c63ff;
                border-radius: 10px 10px 0 0;
            }
            .form-control, .form-select {
                border-radius: 10px;
                box-shadow: none;
            }
            .btn-primary {
                background: linear-gradient(135deg, #6c63ff, #8c52ff);
                border: none;
                border-radius: 8px;
                padding: 10px 20px;
            }
            .btn-primary:hover {
                background: linear-gradient(135deg, #5b46f1, #7645f2);
            }
            .main-container {
                margin-top: 30px;
                margin-bottom: 60px;
            }
        </style>
    </head>

    <body>
        <!-- 🟪 Thông báo Toast hiện góc phải dưới -->
        <div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999">
            <!-- ✅ Thành công -->
            <div id="successToast" class="toast align-items-center text-white border-0" role="alert" aria-live="assertive" aria-atomic="true"
                 style="background-color: #6c63ff;" data-bs-delay="3000">
                <div class="d-flex">
                    <div class="toast-body">
                        <i class="fa fa-check-circle me-2"></i> Đổi mật khẩu thành công!
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                </div>
            </div>

            <!-- ❌ Lỗi -->
            <div id="errorToast" class="toast align-items-center text-white border-0" role="alert" aria-live="assertive" aria-atomic="true"
                 style="background-color: #e74c3c;" data-bs-delay="4000">
                <div class="d-flex">
                    <div class="toast-body">
                        <i class="fa fa-exclamation-circle me-2"></i> Có lỗi xảy ra khi đổi mật khẩu!
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                </div>
            </div>
        </div>

        <!-- 🧩 Script xử lý hiển thị thông báo -->
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const urlParams = new URLSearchParams(window.location.search);
                const successToast = new bootstrap.Toast(document.getElementById('successToast'));
                const errorToast = new bootstrap.Toast(document.getElementById('errorToast'));
                
                // Password form validation
                const passwordForm = document.querySelector('form[action*="change_password"]');
                if (passwordForm) {
                    passwordForm.addEventListener('submit', function(e) {
                        const newPassword = document.querySelector('input[name="new_password"]').value;
                        const confirmPassword = document.querySelector('input[name="confirm_password"]').value;
                        
                        if (newPassword.length < 8) {
                            e.preventDefault();
                            alert('Mật khẩu mới phải có ít nhất 8 ký tự!');
                            return false;
                        }
                        
                        if (newPassword !== confirmPassword) {
                            e.preventDefault();
                            alert('Mật khẩu xác nhận không khớp!');
                            return false;
                        }
                    });
                }
                const errorBody = document.querySelector('#errorToast .toast-body');

                if (urlParams.get('success') === 'password_changed') {
                    successToast.show();
                }

                const error = urlParams.get('error');
                if (error) {
                    if (error === 'wrong_current_password') {
                        errorBody.innerHTML = '<i class="fa fa-exclamation-circle me-2"></i>Mật khẩu hiện tại không đúng!';
                    } else if (error === 'password_mismatch') {
                        errorBody.innerHTML = '<i class="fa fa-exclamation-circle me-2"></i>Mật khẩu mới và xác nhận không khớp!';
                    } else if (error === 'password_too_short') {
                        errorBody.innerHTML = '<i class="fa fa-exclamation-circle me-2"></i>Mật khẩu mới phải có ít nhất 8 ký tự!';
                    } else if (error === 'update_failed') {
                        errorBody.innerHTML = '<i class="fa fa-exclamation-circle me-2"></i>Không thể cập nhật mật khẩu. Vui lòng thử lại!';
                    } else {
                        errorBody.innerHTML = '<i class="fa fa-exclamation-circle me-2"></i>Có lỗi xảy ra khi đổi mật khẩu!';
                    }
                    errorToast.show();
                }
            });
        </script>

        <!-- Header -->
        <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
            <div class="container">
                <a href="<%= request.getContextPath() %>/home" class="navbar-brand p-0">
                    <h1 class="display-5 fw-bold m-0" style="color: #6c63ff;">
                        <i class="fas fa-shopping-bag me-2" style="color: #6c63ff;"></i>Gicungco
                    </h1>
                </a>
                <div class="collapse navbar-collapse">
                    <ul class="navbar-nav ms-auto align-items-center">
                        <li class="nav-item mx-2">
                            <a class="nav-link" href="${pageContext.request.contextPath}/home">Trang chủ</a>
                        </li>
                        <li class="nav-item mx-2"><a class="nav-link" href="${pageContext.request.contextPath}/products">Sản phẩm</a></li>
                        <li class="nav-item mx-2"><a class="nav-link" href="${pageContext.request.contextPath}/contact">Liên hệ</a></li>
                        <li class="nav-item mx-2"><a class="nav-link" href="${pageContext.request.contextPath}/wallet">Nạp tiền</a></li>
                        <li class="nav-item mx-2">
                            <a class="nav-link position-relative" href="${pageContext.request.contextPath}/wishlist">
                                <i class="fa fa-heart text-danger me-1"></i> Yêu thích
                                <span class="badge bg-danger rounded-pill position-absolute top-0 start-100 translate-middle" 
                                      id="wishlistCount" style="display: none; font-size: 0.7rem;">0</span>
                            </a>
                        </li>
                        <li class="nav-item mx-2"><a class="nav-link" href="#"><i class="fa fa-search"></i> Tìm kiếm</a></li>
                        <li class="nav-item dropdown mx-2">
                            <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" id="profileDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fa fa-user-circle me-1"></i> 
                                <span>${user.full_name}</span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 rounded-3" aria-labelledby="profileDropdown" style="min-width: 230px;">
                                <li>
                                    <a class="dropdown-item py-2" href="${pageContext.request.contextPath}/user/order-history">
                                        <i class="fa fa-box-open text-primary me-2"></i> Đơn hàng đã mua
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item py-2" href="${pageContext.request.contextPath}/user/payment-history">
                                        <i class="fa fa-receipt text-success me-2"></i> Lịch sử thanh toán
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item py-2" href="${pageContext.request.contextPath}/wishlist">
                                        <i class="fa fa-heart text-danger me-2"></i> Yêu thích
                                    </a>
                                </li>

                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item py-2 text-danger fw-semibold" href="${pageContext.request.contextPath}/logout">
                                        <i class="fa fa-sign-out-alt me-2"></i> Đăng xuất
                                    </a>
                                </li>
                            </ul>
                        </li>

                        <li><c:choose>
                                <c:when test="${sessionScope.isSeller}">
                                    <a href="${pageContext.request.contextPath}/seller/dashboard" class="btn btn-outline-primary">
                                        <i class="bi bi-shop me-1"></i> Cửa hàng của bạn
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/seller/register" class="btn btn-warning">
                                        <i class="bi bi-bag-plus me-1"></i> Đăng ký bán hàng
                                    </a>
                                </c:otherwise>
                            </c:choose>

                        </li>
                        <li><a class="btn btn-outline-warning mx-2" href="#"><i class="fa fa-heart"></i> Yêu thích</a></li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Profile Header -->
        <!-- Profile Header (đã thêm form upload ảnh) -->
        <section class="profile-header container mt-4 text-center">
            <form action="${pageContext.request.contextPath}/profile" method="post" enctype="multipart/form-data" class="d-inline-block">
                <input type="hidden" name="action" value="update_avatar">

                <!-- Nhãn bao quanh ảnh để click chọn -->
                <label for="avatar" style="cursor:pointer;">
                    <c:choose>
                        <c:when test="${not empty user.avatar_url}">
                            <img src="${user.avatar_url}" alt="Avatar" class="profile-avatar" title="Nhấn để đổi ảnh">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/views/assets/electro/img/avatar.svg" alt="Avatar" class="profile-avatar" title="Nhấn để thêm ảnh">
                        </c:otherwise>
                    </c:choose>
                </label>

                <!-- Input file ẩn -->
                <input type="file" name="avatar" id="avatar" accept="image/*" hidden onchange="this.form.submit()">
            </form>

            <!-- Thông tin cơ bản -->
            <h3 class="mt-2">${user.full_name}</h3>
            <p><i class="fa fa-envelope me-1"></i>${user.email}</p>
            <p><i class="fa fa-phone me-1"></i>${user.phone_number}</p>
            <p><i class="fas fa-map-marker-alt"></i>
                ${empty user.address ? "Chưa cập nhật" : user.address}
            </p>
        </section>



        <!-- Thống kê + Thông tin -->
        <div class="container main-container">
            <div class="row g-4">
                <!-- Thống kê -->
                <div class="col-md-4">
                    <div class="profile-stat mb-3">
                        <h5 class="fw-bold mb-3"><i class="fa fa-chart-line me-2"></i>Thống kê</h5>
                        <div class="row text-center">
                            <div class="col-6">
                                <h4>0</h4><p>Đã mua</p>
                            </div>
                            <div class="col-6">
                                <h4>0</h4><p>Đã bán</p>
                            </div>
                            <div class="col-6">
                                <h4>0</h4><p>Số bài viết</p>
                            </div>
                            <div class="col-6">
                                <h4>${activeProducts != null ? activeProducts : 0}</h4><p>Số gian hàng</p>
                            </div>
                            <div class="col-6">
                                <h4 style="color:#6c63ff;">
                                    <fmt:formatNumber value="${walletBalance}" type="number"/>đ
                                </h4>
                                <p>Số dư</p>
                            </div>


                            <div class="col-6">
                                <h4>0đ</h4><p>Đã chi</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tab thông tin -->
                <div class="col-md-8">
                    <div class="card border-0 shadow-sm rounded-3">
                        <div class="card-header bg-white border-0">
                            <ul class="nav nav-tabs">
                                <li class="nav-item">
                                    <a class="nav-link active" data-bs-toggle="tab" href="#tab-info"><i class="fa fa-user me-2"></i>Thông tin</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" data-bs-toggle="tab" href="#tab-security"><i class="fa fa-lock me-2"></i>Bảo mật</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" data-bs-toggle="tab" href="#tab-orders"><i class="fa fa-box me-2"></i>Đơn hàng</a>
                                </li>
                            </ul>
                        </div>

                        <div class="card-body tab-content">
                            <!-- Thông tin -->
                            <div class="tab-pane fade show active" id="tab-info">
                                <form method="POST" action="<%= request.getContextPath() %>/profile" enctype="multipart/form-data">
                                    <input type="hidden" name="action" value="update_profile">
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label>Họ và tên *</label>
                                            <input type="text" class="form-control" name="full_name" value="${user.full_name}" required>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label>Tên đăng nhập *</label>
                                            <input type="text" class="form-control" value="${user.email}" readonly>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label>Email *</label>
                                            <input type="email" class="form-control" name="email" value="${user.email}" required>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label>Số điện thoại</label>
                                            <input type="text" class="form-control" name="phone" value="${user.phone_number}">
                                        </div>
                                        <div class="col-12 mb-3">
                                            <label>Địa chỉ</label>
                                            <textarea class="form-control" rows="3" name="address">${user.address}</textarea>
                                        </div>
                                    </div>
                                    <div class="text-center">
                                        <button type="submit" class="btn btn-primary"><i class="fa fa-save me-2"></i>Lưu thay đổi</button>
                                    </div>
                                </form>
                            </div>

                            <!-- Bảo mật -->
                            <!-- Bảo mật -->
                            <div class="tab-pane fade" id="tab-security">
                                <h6 class="text-secondary">Đổi mật khẩu</h6>
                                <form method="POST" action="<%= request.getContextPath() %>/profile">
                                    <!-- BẮT BUỘC: thêm dòng này để servlet biết đang đổi mật khẩu -->
                                    <input type="hidden" name="action" value="change_password">

                                    <div class="mb-3">
                                        <label>Mật khẩu hiện tại</label>
                                        <input type="password" class="form-control" name="current_password" required>
                                    </div>

                                    <div class="mb-3">
                                        <label>Mật khẩu mới</label>
                                        <input type="password" class="form-control" name="new_password" minlength="8" required>
                                    </div>

                                    <div class="mb-3">
                                        <label>Xác nhận mật khẩu mới</label>
                                        <input type="password" class="form-control" name="confirm_password" minlength="8" required>
                                    </div>

                                    <button class="btn btn-primary" type="submit">
                                        Cập nhật mật khẩu
                                    </button>
                                </form>
                            </div>


                            <!-- Đơn hàng -->
                            <div class="tab-pane fade" id="tab-orders">
                                <p class="text-muted">Bạn chưa có đơn hàng nào.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        
        <!-- Wishlist JavaScript -->
        <script>
            // Set context path and user ID for wishlist.js
            const contextPath = '${pageContext.request.contextPath}';
            <c:if test="${not empty sessionScope.user}">
            const currentUserId = ${sessionScope.user.user_id};
            // Store in sessionStorage for wishlist.js
            sessionStorage.setItem('userId', ${sessionScope.user.user_id});
            </c:if>
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/wishlist.js?v=<%= System.currentTimeMillis() %>"></script>
    </body>
</html>
