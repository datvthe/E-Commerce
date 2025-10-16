<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ cá nhân - Gicungco</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="<%= request.getContextPath() %>/home">Gicungco</a>
            <div class="navbar-nav ms-auto">
                <c:choose>
                    <c:when test="${not empty user}">
                        <a class="nav-link" href="<%= request.getContextPath() %>/profile">Hồ sơ</a>
                        <a class="nav-link" href="<%= request.getContextPath() %>/logout">Đăng xuất</a>
                    </c:when>
                    <c:otherwise>
                        <a class="nav-link" href="<%= request.getContextPath() %>/login">Đăng nhập</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </nav>

    <!-- Profile Header -->
    <div class="profile-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-3 text-center">
                    <img src="<%= request.getContextPath() %>/views/assets/electro/img/avatar.jpg" alt="Avatar" class="profile-avatar">
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

    <!-- Profile Content -->
    <div class="container">
        <div class="row">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-user-edit me-2"></i>Thông tin cá nhân</h5>
                    </div>
                    <div class="card-body">
                        <form method="POST" action="<%= request.getContextPath() %>/update-profile">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="fullName" class="form-label">Họ và tên *</label>
                                    <input type="text" class="form-control" id="fullName" name="full_name" value="${user.full_name}" required>
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
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-chart-bar me-2"></i>Thống kê</h5>
                    </div>
                    <div class="card-body">
                        <div class="row text-center">
                            <div class="col-6 mb-3">
                                <div class="h4 text-primary">0</div>
                                <div class="small text-muted">Đơn hàng</div>
                            </div>
                            <div class="col-6 mb-3">
                                <div class="h4 text-success">0</div>
                                <div class="small text-muted">Yêu thích</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
