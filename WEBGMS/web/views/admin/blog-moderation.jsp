<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phê duyệt Blog - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); min-height: 100vh; padding: 2rem 0; }
        .admin-header { background: white; border-radius: 15px; padding: 2rem; margin-bottom: 2rem; box-shadow: 0 5px 20px rgba(0,0,0,0.1); }
        .tab-btn { border: none; background: white; color: #666; padding: 1rem 2rem; border-radius: 10px 10px 0 0; margin-right: 0.5rem; font-weight: 600; transition: all 0.3s; }
        .tab-btn.active { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: white; }
        .blog-item { background: white; border-radius: 10px; padding: 1.5rem; margin-bottom: 1rem; box-shadow: 0 3px 10px rgba(0,0,0,0.1); }
        .status-badge { padding: 0.4rem 1rem; border-radius: 20px; font-size: 0.875rem; font-weight: 600; }
        .badge-pending { background: #ffc107; color: #000; }
        .badge-approved { background: #28a745; color: white; }
        .badge-rejected { background: #dc3545; color: white; }
        .btn-approve { background: #28a745; color: white; border: none; }
        .btn-reject { background: #dc3545; color: white; border: none; }
        .modal-content { border-radius: 15px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="admin-header">
            <h1 class="mb-0"><i class="fas fa-shield-alt me-2 text-danger"></i>Phê duyệt Blog</h1>
            <p class="text-muted mb-0 mt-2">Quản lý và kiểm duyệt blog của người dùng</p>
        </div>

        <!-- Tabs -->
        <div class="mb-3">
            <button class="tab-btn ${empty statusFilter or statusFilter eq 'PENDING' ? 'active' : ''}" onclick="switchTab('PENDING')">
                <i class="fas fa-clock me-2"></i>Chờ duyệt <span class="badge bg-warning text-dark ms-2">${pendingCount}</span>
            </button>
            <button class="tab-btn ${statusFilter eq 'APPROVED' ? 'active' : ''}" onclick="switchTab('APPROVED')">
                <i class="fas fa-check-circle me-2"></i>Đã duyệt <span class="badge bg-success ms-2">${approvedCount}</span>
            </button>
            <button class="tab-btn ${statusFilter eq 'REJECTED' ? 'active' : ''}" onclick="switchTab('REJECTED')">
                <i class="fas fa-times-circle me-2"></i>Đã từ chối <span class="badge bg-danger ms-2">${rejectedCount}</span>
            </button>
        </div>

        <!-- Messages -->
        <c:if test="${param.success eq 'approved'}">
            <div class="alert alert-success alert-dismissible fade show"><i class="fas fa-check-circle me-2"></i>Đã phê duyệt blog! <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${param.success eq 'rejected'}">
            <div class="alert alert-success alert-dismissible fade show"><i class="fas fa-times-circle me-2"></i>Đã từ chối blog! <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>

        <!-- Blog List -->
        <c:choose>
            <c:when test="${empty blogs}">
                <div class="text-center py-5 bg-white rounded-3 shadow-sm">
                    <i class="fas fa-inbox fa-4x text-muted mb-3"></i>
                    <h4 class="text-muted">Không có blog nào</h4>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach items="${blogs}" var="blog">
                    <div class="blog-item">
                        <div class="row">
                            <div class="col-md-9">
                                <div class="d-flex align-items-center mb-2">
                                    <h5 class="mb-0 me-3">${blog.title}</h5>
                                    <span class="status-badge badge-${blog.status == 'PENDING' ? 'pending' : blog.status == 'APPROVED' ? 'approved' : 'rejected'}">
                                        ${blog.status}
                                    </span>
                                </div>
                                <p class="text-muted mb-2">${blog.shortSummary}</p>
                                <div class="d-flex gap-3 text-muted" style="font-size: 0.875rem;">
                                    <span><i class="fas fa-user me-1"></i>${blog.author.full_name}</span>
                                    <span><i class="fas fa-envelope me-1"></i>${blog.author.email}</span>
                                    <span><i class="far fa-calendar me-1"></i><fmt:formatDate value="${blog.createdAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                                </div>
                                <c:if test="${not empty blog.moderationNote}">
                                    <div class="alert alert-info mt-2 mb-0 py-2">
                                        <small><strong>Ghi chú:</strong> ${blog.moderationNote}</small>
                                    </div>
                                </c:if>
                            </div>
                            <div class="col-md-3 text-end">
                                <button class="btn btn-sm btn-outline-primary mb-2 w-100" onclick="viewBlogDetails(${blog.blogId})">
                                    <i class="fas fa-eye me-1"></i>Xem chi tiết
                                </button>
                                <c:if test="${blog.status eq 'PENDING'}">
                                    <button class="btn btn-sm btn-approve mb-2 w-100" onclick="approveBlog(${blog.blogId}, '${blog.title}')">
                                        <i class="fas fa-check me-1"></i>Phê duyệt
                                    </button>
                                    <button class="btn btn-sm btn-reject w-100" onclick="showRejectModal(${blog.blogId}, '${blog.title}')">
                                        <i class="fas fa-times me-1"></i>Từ chối
                                    </button>
                                </c:if>
                                <c:if test="${blog.status eq 'APPROVED' or blog.status eq 'REJECTED'}">
                                    <button class="btn btn-sm btn-outline-danger w-100" onclick="deleteBlog(${blog.blogId}, '${blog.title}')">
                                        <i class="fas fa-trash me-1"></i>Xóa
                                    </button>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <nav><ul class="pagination justify-content-center">
                        <c:if test="${currentPage > 1}"><li class="page-item"><a class="page-link" href="?page=${currentPage - 1}&status=${statusFilter}">Trước</a></li></c:if>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${i eq currentPage ? 'active' : ''}"><a class="page-link" href="?page=${i}&status=${statusFilter}">${i}</a></li>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages}"><li class="page-item"><a class="page-link" href="?page=${currentPage + 1}&status=${statusFilter}">Sau</a></li></c:if>
                    </ul></nav>
                </c:if>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Reject Modal -->
    <div class="modal fade" id="rejectModal" tabindex="-1">
        <div class="modal-dialog"><div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title"><i class="fas fa-times-circle me-2"></i>Từ chối Blog</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form method="POST" action="${pageContext.request.contextPath}/admin/blog-moderation">
                <div class="modal-body">
                    <input type="hidden" name="action" value="reject">
                    <input type="hidden" name="blogId" id="rejectBlogId">
                    <p><strong>Blog:</strong> <span id="rejectBlogTitle"></span></p>
                    <div class="mb-3">
                        <label for="reason" class="form-label">Lý do từ chối <span class="text-danger">*</span></label>
                        <textarea class="form-control" id="reason" name="reason" rows="4" required placeholder="Nhập lý do từ chối blog này..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-danger"><i class="fas fa-times me-2"></i>Từ chối Blog</button>
                </div>
            </form>
        </div></div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function switchTab(status) { window.location.href = '?status=' + status; }

        function approveBlog(blogId, title) {
            if (confirm('Phê duyệt blog "' + title + '"?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.innerHTML = '<input type="hidden" name="action" value="approve"><input type="hidden" name="blogId" value="' + blogId + '">';
                document.body.appendChild(form);
                form.submit();
            }
        }

        function showRejectModal(blogId, title) {
            document.getElementById('rejectBlogId').value = blogId;
            document.getElementById('rejectBlogTitle').textContent = title;
            new bootstrap.Modal(document.getElementById('rejectModal')).show();
        }

        function deleteBlog(blogId, title) {
            if (confirm('XÓA VĨNH VIỄN blog "' + title + '"?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.innerHTML = '<input type="hidden" name="action" value="delete"><input type="hidden" name="blogId" value="' + blogId + '">';
                document.body.appendChild(form);
                form.submit();
            }
        }

        function viewBlogDetails(blogId) {
            window.open('${pageContext.request.contextPath}/admin/blog-preview?id=' + blogId, '_blank');
        }
    </script>
</body>
</html>

