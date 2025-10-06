<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <title>Gicungco Marketplace System - Login</title>
    </head>

    <body>
        <jsp:include page="/views/component/header.jsp" />

        <!-- Page Header -->
        <div class="container-fluid page-header py-5">
            <h1 class="text-center text-white display-6">Login Page</h1>
            <ol class="breadcrumb justify-content-center mb-0">
                <li class="breadcrumb-item"><a href="<%= request.getContextPath() %>/home">Home</a></li>
                <li class="breadcrumb-item active text-white">Login</li>
            </ol>
        </div>

        <!-- Login Form -->
        <div class="container py-5">
            <div class="row justify-content-center">
                <div class="col-lg-5">
                    <form action="<%= request.getContextPath() %>/login" method="post" class="border p-4 shadow rounded bg-light">
                        <h3 class="mb-4 text-center">Đăng nhập</h3>

                        <!-- Email hoặc Số điện thoại -->
                        <div class="form-group mb-3">
                            <label for="account">Email hoặc Số điện thoại</label>
                            <input type="text" class="form-control" id="account" name="account"
                                   placeholder="Nhập email hoặc số điện thoại" required>
                        </div>

                        <!-- Password -->
                        <div class="form-group mb-3">
                            <label for="password">Mật khẩu</label>
                            <input type="password" class="form-control" id="password" name="password"
                                   placeholder="Nhập mật khẩu" required>
                        </div>

                        <!-- Remember + Forgot -->
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="remember" name="remember">
                                <label class="form-check-label" for="remember">
                                    Ghi nhớ đăng nhập
                                </label>
                            </div>
                            <div>
                                <a href="<%= request.getContextPath() %>/forgot-password">Quên mật khẩu?</a>
                            </div>
                        </div>

                        <!-- Submit -->
                        <button type="submit" class="btn btn-primary w-100">Đăng nhập</button>

                        <!-- Extra -->
                        <p class="mt-3 text-center">
                            Chưa có tài khoản? <a href="<%= request.getContextPath() %>/register">Đăng ký</a>
                        </p>
                    </form>
                </div>
            </div>
        </div>

        <jsp:include page="/views/component/footer.jsp" />
    </body>

</html>
