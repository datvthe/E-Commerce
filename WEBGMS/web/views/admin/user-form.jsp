<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>${isEdit ? 'Chỉnh sửa' : 'Thêm'} người dùng - Admin</title>
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
                                    <h2>${isEdit ? 'Chỉnh sửa' : 'Thêm'} người dùng</h2>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="breadcrumb-wrapper">
                                    <nav aria-label="breadcrumb">
                                        <ol class="breadcrumb">
                                            <li class="breadcrumb-item">
                                                <a href="<%= request.getContextPath() %>/admin/dashboard">Dashboard</a>
                                            </li>
                                            <li class="breadcrumb-item">
                                                <a href="<%= request.getContextPath() %>/admin/users">Người dùng</a>
                                            </li>
                                            <li class="breadcrumb-item active" aria-current="page">
                                                ${isEdit ? 'Chỉnh sửa' : 'Thêm mới'}
                                            </li>
                                        </ol>
                                    </nav>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- ========== title-wrapper end ========== -->

                    <!-- ========== Alert Messages ========== -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- ========== Form ========== -->
                    <div class="row">
                        <div class="col-lg-8">
                            <div class="card-style mb-30">
                                <h6 class="mb-25">Thông tin người dùng</h6>
                                
                                <form method="post" action="<%= request.getContextPath() %>/admin/users">
                                    <input type="hidden" name="action" value="${isEdit ? 'update' : 'create'}">
                                    <c:if test="${isEdit}">
                                        <input type="hidden" name="userId" value="${user.user_id}">
                                    </c:if>

                                    <div class="input-style-1 mb-20">
                                        <label>Họ và tên <span class="text-danger">*</span></label>
                                        <input type="text" name="fullName" class="form-control" 
                                               value="${user.full_name}" required>
                                    </div>

                                    <div class="input-style-1 mb-20">
                                        <label>Email <span class="text-danger">*</span></label>
                                        <input type="email" name="email" class="form-control" 
                                               value="${user.email}" required>
                                    </div>

                                    <c:if test="${!isEdit}">
                                        <div class="input-style-1 mb-20">
                                            <label>Mật khẩu <span class="text-danger">*</span></label>
                                            <input type="password" name="password" class="form-control" 
                                                   required minlength="6">
                                            <small class="text-muted">Mật khẩu tối thiểu 6 ký tự</small>
                                        </div>
                                    </c:if>

                                    <div class="input-style-1 mb-20">
                                        <label>Số điện thoại <span class="text-danger">*</span></label>
                                        <input type="text" name="phoneNumber" class="form-control" 
                                               value="${user.phone_number}" required>
                                    </div>

                                    <c:if test="${isEdit}">
                                        <div class="input-style-1 mb-20">
                                            <label>Địa chỉ</label>
                                            <textarea name="address" class="form-control" rows="3">${user.address}</textarea>
                                        </div>

                                        <div class="select-style-1 mb-20">
                                            <label>Giới tính</label>
                                            <select name="gender" class="form-select">
                                                <option value="">Chọn giới tính</option>
                                                <option value="male" ${user.gender == 'male' ? 'selected' : ''}>Nam</option>
                                                <option value="female" ${user.gender == 'female' ? 'selected' : ''}>Nữ</option>
                                                <option value="other" ${user.gender == 'other' ? 'selected' : ''}>Khác</option>
                                            </select>
                                        </div>

                                        <div class="select-style-1 mb-20">
                                            <label>Trạng thái <span class="text-danger">*</span></label>
                                            <select name="status" class="form-select" required>
                                                <option value="active" ${user.status == 'active' ? 'selected' : ''}>Hoạt động</option>
                                                <option value="inactive" ${user.status == 'inactive' ? 'selected' : ''}>Không hoạt động</option>
                                                <option value="banned" ${user.status == 'banned' ? 'selected' : ''}>Bị cấm</option>
                                            </select>
                                        </div>
                                    </c:if>

                                    <div class="d-flex gap-2">
                                        <button type="submit" class="main-btn primary-btn btn-hover">
                                            <i class="lni lni-save"></i> ${isEdit ? 'Cập nhật' : 'Tạo mới'}
                                        </button>
                                        <a href="<%= request.getContextPath() %>/admin/users" 
                                           class="main-btn danger-btn-outline btn-hover">
                                            <i class="lni lni-close"></i> Hủy
                                        </a>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <c:if test="${isEdit}">
                            <div class="col-lg-4">
                                <div class="card-style mb-30">
                                    <h6 class="mb-25">Thông tin bổ sung</h6>
                                    
                                    <div class="mb-20">
                                        <p class="text-sm mb-1"><strong>ID:</strong> ${user.user_id}</p>
                                        <p class="text-sm mb-1"><strong>Ngày tạo:</strong> ${user.created_at}</p>
                                        <p class="text-sm mb-1"><strong>Cập nhật:</strong> ${user.updated_at}</p>
                                        <p class="text-sm mb-1"><strong>Đăng nhập cuối:</strong> ${user.last_login_at}</p>
                                        <p class="text-sm mb-1">
                                            <strong>Email xác thực:</strong> 
                                            <c:choose>
                                                <c:when test="${user.email_verified}">
                                                    <span class="status-btn success-btn">Đã xác thực</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-btn warning-btn">Chưa xác thực</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>

                                    <c:if test="${not empty user.avatar_url}">
                                        <div class="mb-20">
                                            <label class="text-sm mb-2"><strong>Avatar:</strong></label>
                                            <img src="${user.avatar_url}" alt="Avatar" 
                                                 style="width: 100%; max-width: 200px; border-radius: 8px;">
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </section>
            <!-- ========== section end ========== -->
        </main>
        <!-- ======== main-wrapper end =========== -->
    </body>
</html>
