<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <title>Hệ Thống Gicungco Marketplace - Quên Mật Khẩu</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>

    <body>
        <jsp:include page="/views/component/header.jsp" />

        <!-- Page Header -->
        <div class="container-fluid page-header py-5">
            <h1 class="text-center text-white display-6">Quên Mật Khẩu</h1>
            <ol class="breadcrumb justify-content-center mb-0">
                <li class="breadcrumb-item"><a href="<%= request.getContextPath() %>/home">Trang Chủ</a></li>
                <li class="breadcrumb-item active text-white">Quên Mật Khẩu</li>
            </ol>
        </div>

        <!-- Forgot Password Form -->
        <div class="container py-5">
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

        <jsp:include page="/views/component/footer.jsp" />

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        
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
