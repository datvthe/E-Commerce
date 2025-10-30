<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${blog.title} - GiCungCo Blog</title>
    <meta name="description" content="${blog.metaDescription != null ? blog.metaDescription : blog.summary}">
    <meta name="keywords" content="${blog.metaKeywords}">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: #f8f9fa; }
        .blog-header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 4rem 0 2rem; }
        .blog-content { background: white; border-radius: 15px; padding: 3rem; margin-top: -50px; box-shadow: 0 10px 40px rgba(0,0,0,0.1); }
        .featured-image { width: 100%; height: 400px; object-fit: cover; border-radius: 15px; margin-bottom: 2rem; }
        .author-card { background: #f8f9fa; border-radius: 10px; padding: 1.5rem; margin-bottom: 2rem; }
        .author-avatar { width: 60px; height: 60px; border-radius: 50%; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; color: white; font-size: 1.5rem; font-weight: bold; }
        .stats-item { display: inline-flex; align-items: center; margin-right: 1.5rem; color: #6c757d; }
        .stats-item i { margin-right: 0.5rem; }
        .content-body { line-height: 1.8; font-size: 1.1rem; color: #333; }
        .content-body h2 { margin-top: 2rem; margin-bottom: 1rem; color: #667eea; }
        .content-body h3 { margin-top: 1.5rem; margin-bottom: 0.75rem; color: #764ba2; }
        .content-body p { margin-bottom: 1rem; }
        .content-body img { max-width: 100%; height: auto; border-radius: 10px; margin: 1.5rem 0; }
        .back-btn { background: white; color: #667eea; border: 2px solid #667eea; }
        .share-btns a { margin: 0 0.5rem; }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="blog-header">
        <div class="container">
            <a href="${pageContext.request.contextPath}/blogs" class="btn back-btn mb-3">
                <i class="fas fa-arrow-left me-2"></i>Quay lại
            </a>
            <h1 class="display-4 fw-bold mb-3">${blog.title}</h1>
            <p class="lead mb-4">${blog.summary}</p>
            <div class="d-flex flex-wrap gap-3 align-items-center">
                <div class="stats-item text-white-50">
                    <i class="far fa-calendar"></i>
                    <fmt:formatDate value="${blog.publishedAt != null ? blog.publishedAt : blog.createdAt}" pattern="dd/MM/yyyy"/>
                </div>
                <div class="stats-item text-white-50">
                    <i class="far fa-eye"></i>${blog.viewCount} lượt xem
                </div>
                <div class="stats-item text-white-50">
                    <i class="far fa-heart"></i>${blog.likeCount} thích
                </div>
                <div class="stats-item text-white-50">
                    <i class="far fa-comment"></i>${blog.commentCount} bình luận
                </div>
                <div class="stats-item text-white-50">
                    <i class="far fa-clock"></i>${blog.readingTime} phút đọc
                </div>
            </div>
        </div>
    </div>

    <!-- Content -->
    <div class="container mb-5">
        <div class="row">
            <div class="col-lg-8 mx-auto">
                <div class="blog-content">
                    <!-- Featured Image -->
                    <c:if test="${not empty blog.featuredImage}">
                        <img src="${pageContext.request.contextPath}${blog.featuredImage}" 
                             alt="${blog.title}" 
                             class="featured-image">
                    </c:if>

                    <!-- Author -->
                    <div class="author-card">
                        <div class="d-flex align-items-center">
                            <div class="author-avatar me-3">
                                ${blog.author.full_name.substring(0,1).toUpperCase()}
                            </div>
                            <div>
                                <h6 class="mb-0">${blog.author.full_name}</h6>
                                <small class="text-muted">Tác giả</small>
                            </div>
                        </div>
                    </div>

                    <!-- Content -->
                    <div class="content-body">
                        ${blog.content}
                    </div>

                    <!-- Share -->
                    <hr class="my-4">
                    <div class="text-center share-btns">
                        <p class="text-muted mb-3">Chia sẻ bài viết:</p>
                        <a href="#" class="btn btn-outline-primary btn-sm">
                            <i class="fab fa-facebook-f me-1"></i>Facebook
                        </a>
                        <a href="#" class="btn btn-outline-info btn-sm">
                            <i class="fab fa-twitter me-1"></i>Twitter
                        </a>
                        <a href="#" class="btn btn-outline-danger btn-sm">
                            <i class="fab fa-pinterest me-1"></i>Pinterest
                        </a>
                        <button class="btn btn-outline-secondary btn-sm" onclick="copyLink()">
                            <i class="fas fa-link me-1"></i>Copy Link
                        </button>
                    </div>

                    <!-- Comments Section -->
                    <hr class="my-5">
                    <div class="comments-section">
                        <h4 class="mb-4">
                            <i class="far fa-comments me-2"></i>Bình luận 
                            <span class="badge bg-secondary" id="commentCount">${blog.commentCount}</span>
                        </h4>
                        
                        <!-- Comment Form -->
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <div class="comment-form-wrapper mb-4">
                                    <div class="d-flex gap-3">
                                        <div class="comment-avatar">
                                            ${sessionScope.user.full_name.substring(0, 1).toUpperCase()}
                                        </div>
                                        <div class="flex-grow-1">
                                            <textarea 
                                                class="form-control comment-input" 
                                                id="commentInput" 
                                                rows="3" 
                                                placeholder="Viết bình luận của bạn..."></textarea>
                                            <div class="text-end mt-2">
                                                <button class="btn btn-primary btn-sm rounded-pill px-4" onclick="postComment()">
                                                    <i class="fas fa-paper-plane me-1"></i>Gửi bình luận
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle me-2"></i>
                                    Vui lòng <a href="${pageContext.request.contextPath}/login">đăng nhập</a> để bình luận.
                                </div>
                            </c:otherwise>
                        </c:choose>
                        
                        <!-- Comments List -->
                        <div id="commentsList" class="comments-list">
                            <div class="text-center text-muted py-4">
                                <i class="fas fa-spinner fa-spin me-2"></i>Đang tải bình luận...
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
        /* Comment Styles */
        .comments-section { margin-top: 3rem; padding-top: 3rem; border-top: 2px solid #e2e8f0; }
        .comment-avatar { width: 50px; height: 50px; border-radius: 50%; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; color: white; font-weight: 700; font-size: 1.25rem; flex-shrink: 0; }
        .comment-input { border: 2px solid #e2e8f0; border-radius: 10px; resize: none; transition: all 0.3s; }
        .comment-input:focus { border-color: #667eea; box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25); }
        .comment-item { background: white; padding: 1.5rem; border-radius: 15px; margin-bottom: 1rem; box-shadow: 0 2px 8px rgba(0,0,0,0.05); transition: all 0.3s; }
        .comment-item:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .comment-header { display: flex; align-items: center; gap: 1rem; margin-bottom: 0.75rem; }
        .comment-author { font-weight: 700; color: #2d3748; margin: 0; }
        .comment-time { color: #718096; font-size: 0.875rem; }
        .comment-content { color: #4a5568; line-height: 1.6; margin-bottom: 0.75rem; }
        .comment-actions { display: flex; gap: 1rem; }
        .comment-action-btn { background: none; border: none; color: #667eea; font-size: 0.875rem; cursor: pointer; transition: all 0.2s; padding: 0.25rem 0.5rem; }
        .comment-action-btn:hover { color: #764ba2; transform: translateY(-1px); }
        .reply-form { margin-top: 1rem; padding-left: 3rem; }
        .replies-list { margin-top: 1rem; padding-left: 3rem; border-left: 3px solid #e2e8f0; }
        .reply-item { background: #f7fafc; padding: 1rem; border-radius: 10px; margin-bottom: 0.75rem; }
    </style>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function copyLink() {
            const url = window.location.href;
            navigator.clipboard.writeText(url).then(() => {
                alert('Đã copy link!');
            });
        }
        
        // Comment System
        const contextPath = '${pageContext.request.contextPath}';
        const blogId = ${blog.blogId};
        const currentUserId = ${not empty sessionScope.user ? sessionScope.user.user_id : 'null'};
        
        document.addEventListener('DOMContentLoaded', function() {
            loadComments();
        });
        
        function loadComments() {
            fetch(contextPath + '/api/blog/comments?blogId=' + blogId)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        displayComments(data.comments);
                    } else {
                        document.getElementById('commentsList').innerHTML = 
                            '<div class="alert alert-warning">Không thể tải bình luận</div>';
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById('commentsList').innerHTML = 
                        '<div class="alert alert-danger">Lỗi khi tải bình luận</div>';
                });
        }
        
        function displayComments(comments) {
            const container = document.getElementById('commentsList');
            if (!comments || comments.length === 0) {
                container.innerHTML = '<div class="text-center text-muted py-4">Chưa có bình luận nào. Hãy là người đầu tiên!</div>';
                return;
            }
            let html = '';
            comments.forEach(comment => { html += renderComment(comment); });
            container.innerHTML = html;
        }
        
        function renderComment(comment) {
            const isOwner = currentUserId && currentUserId == comment.userId;
            const initials = comment.userName ? comment.userName.charAt(0).toUpperCase() : 'U';
            const timeAgo = formatTimeAgo(new Date(comment.createdAt));
            return '<div class="comment-item" id="comment-' + comment.commentId + '">' +
                '<div class="comment-header">' +
                '<div class="comment-avatar">' + initials + '</div>' +
                '<div class="flex-grow-1"><h6 class="comment-author">' + comment.userName + '</h6>' +
                '<span class="comment-time">' + timeAgo + '</span></div></div>' +
                '<div class="comment-content" id="content-' + comment.commentId + '">' + escapeHtml(comment.content) + '</div>' +
                '<div class="comment-actions">' +
                (currentUserId ? '<button class="comment-action-btn" onclick="showReplyForm(' + comment.commentId + ')">' +
                '<i class="far fa-reply me-1"></i>Trả lời (' + comment.replyCount + ')</button>' : '') +
                (isOwner ? '<button class="comment-action-btn" onclick="editComment(' + comment.commentId + ')">' +
                '<i class="far fa-edit me-1"></i>Sửa</button>' : '') +
                (isOwner ? '<button class="comment-action-btn text-danger" onclick="deleteComment(' + comment.commentId + ')">' +
                '<i class="far fa-trash me-1"></i>Xóa</button>' : '') +
                '</div>' +
                '<div id="replies-' + comment.commentId + '" class="replies-list" style="display: none;"></div>' +
                '<div id="replyForm-' + comment.commentId + '" class="reply-form" style="display: none;"></div></div>';
        }
        
        function postComment() {
            const input = document.getElementById('commentInput');
            const content = input.value.trim();
            if (!content) { alert('Vui lòng nhập nội dung bình luận'); return; }
            fetch(contextPath + '/api/blog/comments/', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ blogId: blogId, content: content, parentCommentId: null })
            }).then(response => response.json())
              .then(data => {
                  if (data.success) { input.value = ''; loadComments(); updateCommentCount(1); }
                  else { alert('Lỗi: ' + data.message); }
              });
        }
        
        function showReplyForm(commentId) {
            loadReplies(commentId);
            const formDiv = document.getElementById('replyForm-' + commentId);
            if (formDiv.style.display === 'none') {
                const initials = '${sessionScope.user.full_name}'.charAt(0).toUpperCase();
                formDiv.innerHTML = '<div class="d-flex gap-2 mt-2">' +
                    '<div class="comment-avatar" style="width: 40px; height: 40px; font-size: 1rem;">' + initials + '</div>' +
                    '<div class="flex-grow-1">' +
                    '<textarea class="form-control comment-input" id="replyInput-' + commentId + '" rows="2" placeholder="Viết trả lời..."></textarea>' +
                    '<div class="text-end mt-2">' +
                    '<button class="btn btn-sm btn-secondary rounded-pill me-2" onclick="hideReplyForm(' + commentId + ')">Hủy</button>' +
                    '<button class="btn btn-sm btn-primary rounded-pill" onclick="postReply(' + commentId + ')">Gửi</button>' +
                    '</div></div></div>';
                formDiv.style.display = 'block';
            } else { formDiv.style.display = 'none'; }
        }
        
        function hideReplyForm(commentId) { document.getElementById('replyForm-' + commentId).style.display = 'none'; }
        
        function postReply(parentId) {
            const input = document.getElementById('replyInput-' + parentId);
            const content = input.value.trim();
            if (!content) { alert('Vui lòng nhập nội dung'); return; }
            fetch(contextPath + '/api/blog/comments/', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ blogId: blogId, content: content, parentCommentId: parentId })
            }).then(response => response.json())
              .then(data => {
                  if (data.success) { hideReplyForm(parentId); loadReplies(parentId); updateCommentCount(1); }
                  else { alert('Lỗi: ' + data.message); }
              });
        }
        
        function loadReplies(commentId) {
            fetch(contextPath + '/api/blog/comments/replies/' + commentId)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        const repliesDiv = document.getElementById('replies-' + commentId);
                        if (data.replies.length > 0) {
                            let html = '';
                            data.replies.forEach(reply => {
                                const isOwner = currentUserId && currentUserId == reply.userId;
                                const initials = reply.userName.charAt(0).toUpperCase();
                                const timeAgo = formatTimeAgo(new Date(reply.createdAt));
                                html += '<div class="reply-item">' +
                                    '<div class="d-flex gap-2 mb-2">' +
                                    '<div class="comment-avatar" style="width: 40px; height: 40px; font-size: 1rem;">' + initials + '</div>' +
                                    '<div><strong>' + reply.userName + '</strong><br><small class="text-muted">' + timeAgo + '</small></div>' +
                                    '</div><div class="comment-content">' + escapeHtml(reply.content) + '</div>' +
                                    (isOwner ? '<div class="mt-2"><button class="btn btn-sm btn-link text-danger" onclick="deleteComment(' + reply.commentId + ')">Xóa</button></div>' : '') +
                                    '</div>';
                            });
                            repliesDiv.innerHTML = html;
                            repliesDiv.style.display = 'block';
                        }
                    }
                });
        }
        
        function editComment(commentId) {
            const contentDiv = document.getElementById('content-' + commentId);
            const currentContent = contentDiv.textContent;
            contentDiv.innerHTML = '<textarea class="form-control comment-input" id="editInput-' + commentId + '" rows="2">' + currentContent + '</textarea>' +
                '<div class="text-end mt-2">' +
                '<button class="btn btn-sm btn-secondary rounded-pill me-2" onclick="cancelEdit(' + commentId + ', \'' + currentContent.replace(/'/g, "\\'") + '\')">Hủy</button>' +
                '<button class="btn btn-sm btn-primary rounded-pill" onclick="saveEdit(' + commentId + ')">Lưu</button></div>';
        }
        
        function cancelEdit(commentId, originalContent) { document.getElementById('content-' + commentId).textContent = originalContent; }
        
        function saveEdit(commentId) {
            const content = document.getElementById('editInput-' + commentId).value.trim();
            if (!content) { alert('Nội dung không được để trống'); return; }
            fetch(contextPath + '/api/blog/comments/', {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ commentId: commentId, content: content })
            }).then(response => response.json())
              .then(data => {
                  if (data.success) { document.getElementById('content-' + commentId).textContent = content; }
                  else { alert('Lỗi: ' + data.message); }
              });
        }
        
        function deleteComment(commentId) {
            if (!confirm('Bạn có chắc muốn xóa bình luận này?')) return;
            fetch(contextPath + '/api/blog/comments/' + commentId, { method: 'DELETE' })
                .then(response => response.json())
                .then(data => {
                    if (data.success) { loadComments(); updateCommentCount(-1); }
                    else { alert('Lỗi: ' + data.message); }
                });
        }
        
        function updateCommentCount(delta) {
            const badge = document.getElementById('commentCount');
            const current = parseInt(badge.textContent);
            badge.textContent = current + delta;
        }
        
        function formatTimeAgo(date) {
            const seconds = Math.floor((new Date() - date) / 1000);
            const intervals = [
                { label: 'năm', seconds: 31536000 },
                { label: 'tháng', seconds: 2592000 },
                { label: 'ngày', seconds: 86400 },
                { label: 'giờ', seconds: 3600 },
                { label: 'phút', seconds: 60 }
            ];
            for (let interval of intervals) {
                const count = Math.floor(seconds / interval.seconds);
                if (count >= 1) return count + ' ' + interval.label + ' trước';
            }
            return 'Vừa xong';
        }
        
        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }
    </script>
</body>
</html>

