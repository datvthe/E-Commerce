<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Quản lý người dùng - Admin</title>
    </head>
    <body>
        <jsp:include page="/views/component/sidebar.jsp" />

        <!-- ======== main-wrapper start =========== -->
        <main class="main-wrapper">
            <jsp:include page="/views/component/headerAdmin.jsp" />

            <!-- ========== section start ========== -->
            <section class="section">
                <div class="container-fluid">
                    <!-- ========== title-wrapper start ========== -->
                    <div class="title-wrapper pt-30">
                        <div class="row align-items-center">
                            <div class="col-md-6">
                                <div class="title">
                                    <h2>Quản lý người dùng</h2>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="breadcrumb-wrapper">
                                    <nav aria-label="breadcrumb">
                                        <ol class="breadcrumb">
                                            <li class="breadcrumb-item">
                                                <a href="<%= request.getContextPath() %>/admin/dashboard">Dashboard</a>
                                            </li>
                                            <li class="breadcrumb-item active" aria-current="page">
                                                Người dùng
                                            </li>
                                        </ol>
                                    </nav>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- ========== title-wrapper end ========== -->

                    <!-- ========== Alert Messages ========== -->
                    <c:if test="${not empty sessionScope.success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            ${sessionScope.success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="success" scope="session" />
                    </c:if>
                    
                    <c:if test="${not empty sessionScope.error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            ${sessionScope.error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="error" scope="session" />
                    </c:if>

                    <!-- ========== Filter and Search ========== -->
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="card-style mb-30">
                                <div class="d-flex justify-content-between align-items-center mb-20">
                                    <h6 class="mb-0">Danh sách người dùng (${totalUsers})</h6>
                                    <a href="<%= request.getContextPath() %>/admin/users?action=create" class="main-btn primary-btn btn-hover">
                                        <i class="lni lni-plus"></i> Thêm người dùng
                                    </a>
                                </div>

                                <!-- Filter Form -->
                                <form method="get" action="<%= request.getContextPath() %>/admin/users" class="mb-20">
                                    <div class="row g-3">
                                        <div class="col-md-4">
                                            <input type="text" name="keyword" class="form-control" 
                                                   placeholder="Tìm kiếm theo tên, email, SĐT..." 
                                                   value="${keyword}">
                                        </div>
                                        <div class="col-md-3">
                                            <select name="status" class="form-select">
                                                <option value="all" ${status == 'all' || empty status ? 'selected' : ''}>Tất cả trạng thái</option>
                                                <option value="active" ${status == 'active' ? 'selected' : ''}>Hoạt động</option>
                                                <option value="inactive" ${status == 'inactive' ? 'selected' : ''}>Không hoạt động</option>
                                                <option value="banned" ${status == 'banned' ? 'selected' : ''}>Bị cấm</option>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <select name="role" class="form-select">
                                                <option value="all" ${role == 'all' || empty role ? 'selected' : ''}>Tất cả vai trò</option>
                                                <option value="Admin" ${role == 'Admin' ? 'selected' : ''}>Admin</option>
                                                <option value="Manager" ${role == 'Manager' ? 'selected' : ''}>Manager</option>
                                                <option value="Seller" ${role == 'Seller' ? 'selected' : ''}>Seller</option>
                                                <option value="Customer" ${role == 'Customer' ? 'selected' : ''}>Customer</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <button type="submit" class="main-btn primary-btn btn-hover w-100">
                                                <i class="lni lni-search-alt"></i> Tìm kiếm
                                            </button>
                                        </div>
                                    </div>
                                </form>

                                <!-- Users Table -->
                                <div class="table-wrapper table-responsive">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th><h6>ID</h6></th>
                                                <th><h6>Họ tên</h6></th>
                                                <th><h6>Email</h6></th>
                                                <th><h6>Số điện thoại</h6></th>
                                                <th><h6>Trạng thái</h6></th>
                                                <th><h6>Ngày tạo</h6></th>
                                                <th><h6>Thao tác</h6></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="user" items="${users}">
                                                <tr>
                                                    <td><p>${user.user_id}</p></td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <c:choose>
                                                                <c:when test="${not empty user.avatar_url}">
                                                                    <img src="${user.avatar_url}" alt="" style="width: 40px; height: 40px; border-radius: 50%; margin-right: 10px;">
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div style="width: 40px; height: 40px; border-radius: 50%; background: #4A6CF7; color: white; display: flex; align-items: center; justify-content: center; margin-right: 10px;">
                                                                        ${user.full_name.substring(0, 1).toUpperCase()}
                                                                    </div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                            <p>${user.full_name}</p>
                                                        </div>
                                                    </td>
                                                    <td><p>${user.email}</p></td>
                                                    <td><p>${user.phone_number}</p></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${user.status == 'active'}">
                                                                <span class="status-btn success-btn">Hoạt động</span>
                                                            </c:when>
                                                            <c:when test="${user.status == 'inactive'}">
                                                                <span class="status-btn warning-btn">Không hoạt động</span>
                                                            </c:when>
                                                            <c:when test="${user.status == 'banned'}">
                                                                <span class="status-btn danger-btn">Bị cấm</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="status-btn">${user.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td><p>${user.created_at}</p></td>
                                                    <td>
                                                        <div class="action">
                                                            <a href="<%= request.getContextPath() %>/admin/users?action=edit&id=${user.user_id}" 
                                                               class="text-primary me-2" title="Chỉnh sửa">
                                                                <i class="lni lni-pencil"></i>
                                                            </a>
                                                            <a href="javascript:void(0)" 
                                                               onclick="confirmDelete(${user.user_id})" 
                                                               class="text-danger" title="Xóa">
                                                                <i class="lni lni-trash-can"></i>
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty users}">
                                                <tr>
                                                    <td colspan="7" class="text-center">
                                                        <p>Không có dữ liệu</p>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Pagination -->
                                <c:if test="${totalPages > 1}">
                                    <div class="pagination-wrapper mt-20">
                                        <nav>
                                            <ul class="pagination">
                                                <c:if test="${currentPage > 1}">
                                                    <li class="page-item">
                                                        <a class="page-link" href="?page=${currentPage - 1}&keyword=${keyword}&status=${status}&role=${role}">
                                                            Trước
                                                        </a>
                                                    </li>
                                                </c:if>
                                                
                                                <c:forEach begin="1" end="${totalPages}" var="i">
                                                    <c:choose>
                                                        <c:when test="${currentPage == i}">
                                                            <li class="page-item active">
                                                                <span class="page-link">${i}</span>
                                                            </li>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <li class="page-item">
                                                                <a class="page-link" href="?page=${i}&keyword=${keyword}&status=${status}&role=${role}">${i}</a>
                                                            </li>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                                
                                                <c:if test="${currentPage < totalPages}">
                                                    <li class="page-item">
                                                        <a class="page-link" href="?page=${currentPage + 1}&keyword=${keyword}&status=${status}&role=${role}">
                                                            Sau
                                                        </a>
                                                    </li>
                                                </c:if>
                                            </ul>
                                        </nav>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <!-- ========== section end ========== -->
        </main>
        <!-- ======== main-wrapper end =========== -->

        <script>
            function confirmDelete(userId) {
                if (confirm('Bạn có chắc chắn muốn xóa người dùng này?')) {
                    window.location.href = '<%= request.getContextPath() %>/admin/users?action=delete&id=' + userId;
                }
            }
        </script>
    </body>
</html>
