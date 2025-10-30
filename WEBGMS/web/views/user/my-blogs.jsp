<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Blog - GiCungCo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 2rem 0; }
        .container-main { max-width: 1400px; margin: 0 auto; }
        .page-header { background: white; border-radius: 15px; padding: 2rem; margin-bottom: 2rem; box-shadow: 0 5px 20px rgba(0,0,0,0.1); }
        .stats-card { background: white; border-radius: 10px; padding: 1.5rem; text-align: center; box-shadow: 0 3px 10px rgba(0,0,0,0.1); transition: transform 0.3s; }
        .stats-card:hover { transform: translateY(-5px); }
        .stats-number { font-size: 2rem; font-weight: bold; margin: 0.5rem 0; }
        .blog-card { background: white; border-radius: 10px; padding: 1.5rem; margin-bottom: 1rem; box-shadow: 0 3px 10px rgba(0,0,0,0.1); transition: all 0.3s; }
        .blog-card:hover { box-shadow: 0 5px 20px rgba(0,0,0,0.15); }
        .status-badge { padding: 0.4rem 1rem; border-radius: 20px; font-size: 0.875rem; font-weight: 600; }
        .status-DRAFT { background: #6c757d; color: white; }
        .status-PENDING { background: #ffc107; color: #000; }
        .status-APPROVED { background: #28a745; color: white; }
        .status-REJECTED { background: #dc3545; color: white; }
        .btn-create { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border: none; color: white; padding: 0.75rem 2rem; border-radius: 25px; font-weight: 600; }
        .filter-btn { border: 2px solid #e0e0e0; background: white; color: #333; padding: 0.5rem 1.5rem; border-radius: 25px; margin: 0 0.25rem; transition: all 0.3s; }
        .filter-btn.active { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border-color: #667eea; }
    </style>
</head>
<body>
    <div class="container-main px-3">
        <!-- Page Header -->
        <div class="page-header">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="mb-1"><i class="fas fa-blog me-2 text-primary"></i>Quản lý Blog</h1>
                    <p class="text-muted mb-0">Quản lý các bài viết blog của bạn</p>
                </div>
                <a href="${pageContext.request.contextPath}/user/blog-editor" class="btn btn-create">
                    <i class="fas fa-plus me-2"></i>Tạo Blog Mới
                </a>
            </div>
        </div>

        <!-- Statistics -->
        <div class="row mb-4">
            <div class="col-md-3 mb-3">
                <div class="stats-card">
                    <i class="fas fa-file-alt fa-2x text-secondary"></i>
                    <div class="stats-number text-secondary">${draftCount}</div>
                    <div class="text-muted">Bản nháp</div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="stats-card">
                    <i class="fas fa-clock fa-2x text-warning"></i>
                    <div class="stats-number text-warning">${pendingCount}</div>
                    <div class="text-muted">Chờ duyệt</div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="stats-card">
                    <i class="fas fa-check-circle fa-2x text-success"></i>
                    <div class="stats-number text-success">${approvedCount}</div>
                    <div class="text-muted">Đã duyệt</div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="stats-card">
                    <i class="fas fa-times-circle fa-2x text-danger"></i>
                    <div class="stats-number text-danger">${rejectedCount}</div>
                    <div class="text-muted">Bị từ chối</div>
                </div>
            </div>
        </div>

        <!-- Filters -->
        <div class="bg-white rounded-3 p-3 mb-3 shadow-sm text-center">
            <button class="filter-btn ${empty statusFilter or statusFilter eq 'ALL' ? 'active' : ''}" 
                    onclick="filterBlogs('ALL')">
                <i class="fas fa-list me-1"></i>Tất cả (${draftCount + pendingCount + approvedCount + rejectedCount})
            </button>
            <button class="filter-btn ${statusFilter eq 'DRAFT' ? 'active' : ''}" 
                    onclick="filterBlogs('DRAFT')">
                <i class="fas fa-file-alt me-1"></i>Nháp (${draftCount})
            </button>
            <button class="filter-btn ${statusFilter eq 'PENDING' ? 'active' : ''}" 
                    onclick="filterBlogs('PENDING')">
                <i class="fas fa-clock me-1"></i>Chờ duyệt (${pendingCount})
            </button>
            <button class="filter-btn ${statusFilter eq 'APPROVED' ? 'active' : ''}" 
                    onclick="filterBlogs('APPROVED')">
                <i class="fas fa-check-circle me-1"></i>Đã duyệt (${approvedCount})
            </button>
            <button class="filter-btn ${statusFilter eq 'REJECTED' ? 'active' : ''}" 
                    onclick="filterBlogs('REJECTED')">
                <i class="fas fa-times-circle me-1"></i>Bị từ chối (${rejectedCount})
            </button>
        </div>

        <!-- Messages -->
        <c:if test="${param.success eq 'created'}">
            <div class="alert alert-success alert-dismissible fade show"><i class="fas fa-check-circle me-2"></i>Tạo blog thành công! <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${param.success eq 'updated'}">
            <div class="alert alert-success alert-dismissible fade show"><i class="fas fa-check-circle me-2"></i>Cập nhật blog thành công! <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${param.success eq 'deleted'}">
            <div class="alert alert-success alert-dismissible fade show"><i class="fas fa-check-circle me-2"></i>Xóa blog thành công! <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>

        <!-- Blog List -->
        <c:choose>
            <c:when test="${empty blogs}">
                <div class="text-center py-5 bg-white rounded-3 shadow-sm">
                    <i class="fas fa-inbox fa-4x text-muted mb-3"></i>
                    <h4 class="text-muted">Chưa có blog nào</h4>
                    <p class="text-muted">Hãy tạo blog đầu tiên của bạn!</p>
                    <a href="${pageContext.request.contextPath}/user/blog-editor" class="btn btn-create mt-3">
                        <i class="fas fa-plus me-2"></i>Tạo Blog Ngay
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach items="${blogs}" var="blog">
                    <div class="blog-card">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <div class="d-flex align-items-start mb-2">
                                    <h5 class="mb-0 me-3">${blog.title}</h5>
                                    <span class="status-badge status-${blog.status}">${blog.status}</span>
                                </div>
                                <p class="text-muted mb-2" style="font-size: 0.9rem;">
                                    ${blog.shortSummary}
                                </p>
                                <div class="d-flex gap-3 text-muted" style="font-size: 0.875rem;">
                                    <span><i class="far fa-calendar me-1"></i><fmt:formatDate value="${blog.createdAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                                    <span><i class="far fa-eye me-1"></i>${blog.viewCount} lượt xem</span>
                                    <span><i class="far fa-heart me-1"></i>${blog.likeCount} thích</span>
                                    <span><i class="far fa-comment me-1"></i>${blog.commentCount} bình luận</span>
                                </div>
                                <c:if test="${blog.status eq 'REJECTED' and not empty blog.moderationNote}">
                                    <div class="alert alert-danger mt-2 mb-0 py-2">
                                        <small><strong>Lý do từ chối:</strong> ${blog.moderationNote}</small>
                                    </div>
                                </c:if>
                            </div>
                            <div class="col-md-4 text-end">
                                <c:if test="${blog.status eq 'APPROVED'}">
                                    <a href="${pageContext.request.contextPath}/blog/${blog.slug}" class="btn btn-sm btn-outline-primary me-1" target="_blank">
                                        <i class="fas fa-eye"></i> Xem
                                    </a>
                                </c:if>
                                <c:if test="${blog.editable}">
                                    <a href="${pageContext.request.contextPath}/user/blog-editor?id=${blog.blogId}" class="btn btn-sm btn-outline-success me-1">
                                        <i class="fas fa-edit"></i> Sửa
                                    </a>
                                </c:if>
                                <c:if test="${blog.deletable}">
                                    <button class="btn btn-sm btn-outline-danger" onclick="confirmDelete(${blog.blogId}, '${blog.title}')">
                                        <i class="fas fa-trash"></i> Xóa
                                    </button>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <nav class="mt-4">
                        <ul class="pagination justify-content-center">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item"><a class="page-link" href="?page=${currentPage - 1}&status=${statusFilter}">Trước</a></li>
                            </c:if>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i eq currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}&status=${statusFilter}">${i}</a>
                                </li>
                            </c:forEach>
                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item"><a class="page-link" href="?page=${currentPage + 1}&status=${statusFilter}">Sau</a></li>
                            </c:if>
                        </ul>
                    </nav>
                </c:if>
            </c:otherwise>
        </c:choose>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function filterBlogs(status) {
            window.location.href = '?status=' + status;
        }

        function confirmDelete(blogId, title) {
            if (confirm('Bạn có chắc muốn xóa blog "' + title + '"?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/user/my-blogs';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                
                const blogIdInput = document.createElement('input');
                blogIdInput.type = 'hidden';
                blogIdInput.name = 'blogId';
                blogIdInput.value = blogId;
                
                form.appendChild(actionInput);
                form.appendChild(blogIdInput);
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>

