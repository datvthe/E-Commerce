<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <title>Gicungco Marketplace System - Register</title>
    </head>

    <body>
        <jsp:include page="/views/component/header.jsp" />

        <div class="container-fluid page-header py-5">
            <h1 class="text-center text-white display-6">Register</h1>
            <ol class="breadcrumb justify-content-center mb-0">
                <li class="breadcrumb-item"><a href="<%= request.getContextPath() %>/home">Home</a></li>
                <li class="breadcrumb-item active text-white">Register</li>
            </ol>
        </div>

        <div class="container py-5">
            <div class="row justify-content-center">
                <div class="col-lg-6 col-md-8">
                    <form action="<%= request.getContextPath() %>/register" method="post" class="border p-4 rounded bg-white wow fadeInUp" data-wow-delay="0.1s">
                        <h3 class="mb-4 text-center">Tạo tài khoản</h3>

                        <c:if test="${not empty sessionScope.error}">
                            <div class="alert alert-danger">${sessionScope.error}</div>
                            <c:remove var="error" scope="session" />
                        </c:if>

                        <div class="form-group mb-3">
                            <label for="full_name" class="mb-1">Họ và tên</label>
                            <input type="text" class="form-control rounded-pill py-2" id="full_name" name="full_name" required>
                        </div>

                        <div class="form-group mb-3">
                            <label for="email" class="mb-1">Email</label>
                            <input type="email" class="form-control rounded-pill py-2" id="email" name="email" required>
                        </div>

                        <div class="form-group mb-3">
                            <label for="phone_number" class="mb-1">Số điện thoại</label>
                            <input type="text" class="form-control rounded-pill py-2" id="phone_number" name="phone_number" required>
                        </div>

                        <div class="form-group mb-3">
                            <label for="password_hash" class="mb-1">Mật khẩu</label>
                            <input type="password" class="form-control rounded-pill py-2" id="password_hash" name="password_hash" minlength="6" required>
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

        <jsp:include page="/views/component/footer.jsp" />
    </body>

</html>


