<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Quản lý danh mục - Admin</title>
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
                                    <h2>Quản lý danh mục</h2>
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
                                                Danh mục
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
                                    <h6 class="mb-0">Danh sách danh mục (${totalCategories})</h6>
                                    <a href="<%= request.getContextPath() %>/admin/categories?action=create" class="main-btn primary-btn btn-hover">
                                        <i class="lni lni-plus"></i> Thêm danh mục
                                    </a>
                                </div>

                                <!-- Filter Form -->
                                <form method="get" action="<%= request.getContextPath() %>/admin/categories" class="mb-20">
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <input type="text" name="keyword" class="form-control" 
                                                   placeholder="Tìm kiếm theo tên, mô tả..." 
                                                   value="${keyword}">
                                        </div>
                                        <div class="col-md-4">
                                            <select name="status" class="form-select">
                                                <option value="all" ${status == 'all' || empty status ? 'selected' : ''}>Tất cả trạng thái</option>
                                                <option value="active" ${status == 'active' ? 'selected' : ''}>Hoạt động</option>
                                                <option value="inactive" ${status == 'inactive' ? 'selected' : ''}>Không hoạt động</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <button type="submit" class="main-btn primary-btn btn-hover w-100">
                                                <i class="lni lni-search-alt"></i> Tìm kiếm
                                            </button>
                                        </div>
                                    </div>
                                </form>

                                <!-- Categories Table -->
                                <div class="table-wrapper table-responsive">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th><h6>ID</h6></th>
                                                <th><h6>Tên danh mục</h6></th>
                                                <th><h6>Slug</h6></th>
                                                <th><h6>Mô tả</h6></th>
                                                <th><h6>Trạng thái</h6></th>
                                                <th><h6>Ngày tạo</h6></th>
                                                <th><h6>Thao tác</h6></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="category" items="${categories}">
                                                <tr>
                                                    <td><p>${category.category_id}</p></td>
                                                    <td>
                                                        <p><strong>${category.name}</strong></p>
                                                    </td>
                                                    <td><p class="text-muted">${category.slug}</p></td>
                                                    <td>
                                                        <p class="text-sm">
                                                            <c:choose>
                                                                <c:when test="${not empty category.description && category.description.length() > 50}">
                                                                    ${category.description.substring(0, 50)}...
                                                                </c:when>
                                                                <c:otherwise>
                                                                    ${category.description}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </p>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${category.status == 'active'}">
                                                                <span class="status-btn success-btn">Hoạt động</span>
                                                            </c:when>
                                                            <c:when test="${category.status == 'inactive'}">
                                                                <span class="status-btn warning-btn">Không hoạt động</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="status-btn">${category.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td><p>${category.created_at}</p></td>
                                                    <td>
                                                        <div class="action">
                                                            <a href="<%= request.getContextPath() %>/admin/categories?action=edit&id=${category.category_id}" 
                                                               class="text-primary me-2" title="Chỉnh sửa">
                                                                <i class="lni lni-pencil"></i>
                                                            </a>
                                                            <a href="javascript:void(0)" 
                                                               onclick="confirmDelete(${category.category_id})" 
                                                               class="text-danger" title="Xóa">
                                                                <i class="lni lni-trash-can"></i>
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty categories}">
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
                                                        <a class="page-link" href="?page=${currentPage - 1}&keyword=${keyword}&status=${status}">
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
                                                                <a class="page-link" href="?page=${i}&keyword=${keyword}&status=${status}">${i}</a>
                                                            </li>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                                
                                                <c:if test="${currentPage < totalPages}">
                                                    <li class="page-item">
                                                        <a class="page-link" href="?page=${currentPage + 1}&keyword=${keyword}&status=${status}">
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
            function confirmDelete(categoryId) {
                if (confirm('Bạn có chắc chắn muốn xóa danh mục này?')) {
                    window.location.href = '<%= request.getContextPath() %>/admin/categories?action=delete&id=' + categoryId;
                }
            }
        </script>
    </body>
</html>
