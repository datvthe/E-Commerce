<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>${isEdit ? 'Chỉnh sửa' : 'Thêm'} danh mục - Admin</title>
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
                                    <h2>${isEdit ? 'Chỉnh sửa' : 'Thêm'} danh mục</h2>
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
                                                <a href="<%= request.getContextPath() %>/admin/categories">Danh mục</a>
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
                                <h6 class="mb-25">Thông tin danh mục</h6>
                                
                                <form method="post" action="<%= request.getContextPath() %>/admin/categories">
                                    <input type="hidden" name="action" value="${isEdit ? 'update' : 'create'}">
                                    <c:if test="${isEdit}">
                                        <input type="hidden" name="categoryId" value="${category.category_id}">
                                    </c:if>

                                    <div class="input-style-1 mb-20">
                                        <label>Tên danh mục <span class="text-danger">*</span></label>
                                        <input type="text" name="name" class="form-control" 
                                               value="${category.name}" required 
                                               id="categoryName" onkeyup="generateSlug()">
                                        <small class="text-muted">Tên hiển thị của danh mục</small>
                                    </div>

                                    <div class="input-style-1 mb-20">
                                        <label>Slug <span class="text-danger">*</span></label>
                                        <input type="text" name="slug" class="form-control" 
                                               value="${category.slug}" required id="categorySlug">
                                        <small class="text-muted">URL thân thiện (tự động tạo từ tên)</small>
                                    </div>

                                    <div class="input-style-1 mb-20">
                                        <label>Mô tả</label>
                                        <textarea name="description" class="form-control" rows="4">${category.description}</textarea>
                                        <small class="text-muted">Mô tả ngắn về danh mục</small>
                                    </div>

                                    <div class="select-style-1 mb-20">
                                        <label>Trạng thái <span class="text-danger">*</span></label>
                                        <select name="status" class="form-select" required>
                                            <option value="active" ${category.status == 'active' || empty category.status ? 'selected' : ''}>Hoạt động</option>
                                            <option value="inactive" ${category.status == 'inactive' ? 'selected' : ''}>Không hoạt động</option>
                                        </select>
                                    </div>

                                    <div class="d-flex gap-2">
                                        <button type="submit" class="main-btn primary-btn btn-hover">
                                            <i class="lni lni-save"></i> ${isEdit ? 'Cập nhật' : 'Tạo mới'}
                                        </button>
                                        <a href="<%= request.getContextPath() %>/admin/categories" 
                                           class="main-btn danger-btn-outline btn-hover">
                                            <i class="lni lni-close"></i> Hủy
                                        </a>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <div class="col-lg-4">
                            <div class="card-style mb-30">
                                <h6 class="mb-25">Hướng dẫn</h6>
                                
                                <div class="mb-20">
                                    <p class="text-sm mb-2"><strong>Tên danh mục:</strong></p>
                                    <p class="text-sm text-muted">Tên hiển thị của danh mục trên website. Ví dụ: "Điện thoại", "Laptop"</p>
                                </div>

                                <div class="mb-20">
                                    <p class="text-sm mb-2"><strong>Slug:</strong></p>
                                    <p class="text-sm text-muted">URL thân thiện SEO. Tự động tạo từ tên danh mục. Ví dụ: "dien-thoai", "laptop"</p>
                                </div>

                                <div class="mb-20">
                                    <p class="text-sm mb-2"><strong>Trạng thái:</strong></p>
                                    <p class="text-sm text-muted">
                                        <strong>Hoạt động:</strong> Danh mục hiển thị trên website<br>
                                        <strong>Không hoạt động:</strong> Danh mục bị ẩn
                                    </p>
                                </div>

                                <c:if test="${isEdit}">
                                    <hr>
                                    <div class="mb-20">
                                        <p class="text-sm mb-1"><strong>ID:</strong> ${category.category_id}</p>
                                        <p class="text-sm mb-1"><strong>Ngày tạo:</strong> ${category.created_at}</p>
                                        <p class="text-sm mb-1"><strong>Cập nhật:</strong> ${category.updated_at}</p>
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
            function generateSlug() {
                const name = document.getElementById('categoryName').value;
                const slug = name
                    .toLowerCase()
                    .normalize('NFD')
                    .replace(/[\u0300-\u036f]/g, '')
                    .replace(/đ/g, 'd')
                    .replace(/Đ/g, 'd')
                    .replace(/[^a-z0-9\s-]/g, '')
                    .replace(/\s+/g, '-')
                    .replace(/-+/g, '-')
                    .trim();
                
                document.getElementById('categorySlug').value = slug;
            }

            // Auto-generate slug on page load if creating new category
            <c:if test="${!isEdit}">
                window.addEventListener('DOMContentLoaded', function() {
                    document.getElementById('categoryName').addEventListener('input', generateSlug);
                });
            </c:if>
        </script>
    </body>
</html>
