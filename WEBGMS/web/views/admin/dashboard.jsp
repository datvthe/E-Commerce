<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>Admin Dashboard - Gicungco Marketplace</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" />
        
        <style>
            .sidebar {
                min-height: 100vh;
                background-color: #343a40;
            }
            .sidebar .nav-link {
                color: #adb5bd;
            }
            .sidebar .nav-link:hover {
                color: #fff;
            }
            .sidebar .nav-link.active {
                color: #fff;
                background-color: #495057;
            }
            .main-content {
                margin-left: 0;
            }
            @media (min-width: 768px) {
                .main-content {
                    margin-left: 250px;
                }
            }
        </style>
    </head>
    <body>
        <!-- Navigation -->
        <jsp:include page="../component/header.jsp" />
        
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <nav class="col-md-3 col-lg-2 d-md-block sidebar collapse">
                    <div class="position-sticky pt-3">
                        <div class="text-center mb-4">
                            <h4 class="text-white">Admin Panel</h4>
                        </div>
                        <ul class="nav flex-column">
                            <li class="nav-item">
                                <a class="nav-link active" href="<%= request.getContextPath() %>/admin/dashboard">
                                    <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="<%= request.getContextPath() %>/admin/users">
                                    <i class="fas fa-users me-2"></i>Quản lý người dùng
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="<%= request.getContextPath() %>/admin/products">
                                    <i class="fas fa-box me-2"></i>Quản lý sản phẩm
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="<%= request.getContextPath() %>/admin/orders">
                                    <i class="fas fa-shopping-cart me-2"></i>Quản lý đơn hàng
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="<%= request.getContextPath() %>/admin/reports">
                                    <i class="fas fa-chart-bar me-2"></i>Báo cáo
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="<%= request.getContextPath() %>/admin/settings">
                                    <i class="fas fa-cog me-2"></i>Cài đặt
                                </a>
                            </li>
                        </ul>
                    </div>
                </nav>
                
                <!-- Main content -->
                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Dashboard</h1>
                        <div class="btn-toolbar mb-2 mb-md-0">
                            <div class="btn-group me-2">
                                <button type="button" class="btn btn-sm btn-outline-secondary">Export</button>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Role Information -->
                    <c:if test="${not empty sessionScope.userRole}">
                        <div class="alert alert-info">
                            <h5><i class="fas fa-user-shield me-2"></i>Thông tin quyền hạn</h5>
                            <p><strong>Vai trò:</strong> ${sessionScope.userRole.role_id.role_name}</p>
                            <p><strong>Mô tả:</strong> ${sessionScope.userRole.role_id.description}</p>
                            <p><strong>Được gán vào:</strong> ${sessionScope.userRole.assigned_at}</p>
                        </div>
                    </c:if>
                    
                    <!-- Statistics Cards -->
                    <div class="row mb-4">
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card border-left-primary shadow h-100 py-2">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                                Tổng người dùng</div>
                                            <div class="h5 mb-0 font-weight-bold text-gray-800">1,234</div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="fas fa-users fa-2x text-gray-300"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card border-left-success shadow h-100 py-2">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                                Tổng sản phẩm</div>
                                            <div class="h5 mb-0 font-weight-bold text-gray-800">567</div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="fas fa-box fa-2x text-gray-300"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card border-left-info shadow h-100 py-2">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                                                Đơn hàng hôm nay</div>
                                            <div class="h5 mb-0 font-weight-bold text-gray-800">89</div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="fas fa-shopping-cart fa-2x text-gray-300"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card border-left-warning shadow h-100 py-2">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                                Doanh thu tháng</div>
                                            <div class="h5 mb-0 font-weight-bold text-gray-800">2.5B VND</div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="fas fa-dollar-sign fa-2x text-gray-300"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Recent Activity -->
                    <div class="row">
                        <div class="col-lg-8">
                            <div class="card shadow mb-4">
                                <div class="card-header py-3">
                                    <h6 class="m-0 font-weight-bold text-primary">Hoạt động gần đây</h6>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-bordered" width="100%" cellspacing="0">
                                            <thead>
                                                <tr>
                                                    <th>Thời gian</th>
                                                    <th>Người dùng</th>
                                                    <th>Hành động</th>
                                                    <th>Trạng thái</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td>2024-01-15 10:30</td>
                                                    <td>Nguyễn Văn A</td>
                                                    <td>Đăng ký tài khoản</td>
                                                    <td><span class="badge badge-success">Thành công</span></td>
                                                </tr>
                                                <tr>
                                                    <td>2024-01-15 09:15</td>
                                                    <td>Trần Thị B</td>
                                                    <td>Đặt hàng #12345</td>
                                                    <td><span class="badge badge-warning">Chờ xử lý</span></td>
                                                </tr>
                                                <tr>
                                                    <td>2024-01-15 08:45</td>
                                                    <td>Lê Văn C</td>
                                                    <td>Thêm sản phẩm mới</td>
                                                    <td><span class="badge badge-success">Thành công</span></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-lg-4">
                            <div class="card shadow mb-4">
                                <div class="card-header py-3">
                                    <h6 class="m-0 font-weight-bold text-primary">Thống kê vai trò</h6>
                                </div>
                                <div class="card-body">
                                    <div class="mb-3">
                                        <div class="d-flex justify-content-between">
                                            <span>Admin</span>
                                            <span>5</span>
                                        </div>
                                        <div class="progress">
                                            <div class="progress-bar bg-danger" style="width: 5%"></div>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <div class="d-flex justify-content-between">
                                            <span>Seller</span>
                                            <span>45</span>
                                        </div>
                                        <div class="progress">
                                            <div class="progress-bar bg-warning" style="width: 45%"></div>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <div class="d-flex justify-content-between">
                                            <span>Manager</span>
                                            <span>12</span>
                                        </div>
                                        <div class="progress">
                                            <div class="progress-bar bg-info" style="width: 12%"></div>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <div class="d-flex justify-content-between">
                                            <span>Customer</span>
                                            <span>1,172</span>
                                        </div>
                                        <div class="progress">
                                            <div class="progress-bar bg-success" style="width: 95%"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>
        
        <!-- Footer -->
        <jsp:include page="../component/footer.jsp" />
        
        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
