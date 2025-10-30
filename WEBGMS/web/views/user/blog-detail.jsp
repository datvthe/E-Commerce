<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${blog.title} - Gicungco Blog</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    body {
      background: #f8f9fa;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }
    .blog-hero {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 3rem 0;
      margin-bottom: 2rem;
    }
    .back-button {
      color: white;
      text-decoration: none;
      font-weight: 600;
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
      padding: 0.5rem 1.5rem;
      background: rgba(255,255,255,0.2);
      border-radius: 50px;
      transition: all 0.3s ease;
    }
    .back-button:hover {
      background: rgba(255,255,255,0.3);
      color: white;
      transform: translateX(-5px);
    }
    .blog-title {
      font-size: 2.5rem;
      font-weight: 800;
      line-height: 1.3;
      margin: 1.5rem 0 1rem;
    }
    .blog-meta {
      display: flex;
      align-items: center;
      gap: 2rem;
      flex-wrap: wrap;
      opacity: 0.95;
    }
    .blog-meta-item {
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }
    .blog-content-wrapper {
      max-width: 900px;
      margin: 0 auto;
    }
    .blog-featured-image {
      width: 100%;
      max-height: 500px;
      object-fit: cover;
      border-radius: 20px;
      box-shadow: 0 10px 40px rgba(0,0,0,0.1);
      margin-bottom: 3rem;
    }
    .blog-content {
      background: white;
      padding: 3rem;
      border-radius: 20px;
      box-shadow: 0 4px 20px rgba(0,0,0,0.08);
      line-height: 1.8;
      font-size: 1.1rem;
      color: #2d3748;
    }
    .blog-content h1, .blog-content h2, .blog-content h3 {
      margin-top: 2rem;
      margin-bottom: 1rem;
      color: #1a202c;
      font-weight: 700;
    }
    .blog-content h1 { font-size: 2rem; }
    .blog-content h2 { font-size: 1.75rem; }
    .blog-content h3 { font-size: 1.5rem; }
    .blog-content img {
      max-width: 100%;
      height: auto;
      border-radius: 10px;
      margin: 1.5rem 0;
    }
    .blog-content p {
      margin-bottom: 1.5rem;
    }
    .blog-content ul, .blog-content ol {
      margin-bottom: 1.5rem;
      padding-left: 2rem;
    }
    .blog-content li {
      margin-bottom: 0.5rem;
    }
    .blog-content blockquote {
      border-left: 4px solid #667eea;
      padding-left: 1.5rem;
      margin: 2rem 0;
      font-style: italic;
      color: #4a5568;
    }
    .blog-content code {
      background: #f7fafc;
      padding: 0.2rem 0.5rem;
      border-radius: 4px;
      font-size: 0.9em;
      color: #e53e3e;
    }
    .blog-content pre {
      background: #2d3748;
      color: #fff;
      padding: 1.5rem;
      border-radius: 10px;
      overflow-x: auto;
      margin: 1.5rem 0;
    }
    .blog-stats {
      display: flex;
      gap: 2rem;
      padding: 1.5rem;
      background: #f7fafc;
      border-radius: 10px;
      margin-bottom: 2rem;
    }
    .blog-stat-item {
      display: flex;
      align-items: center;
      gap: 0.5rem;
      color: #4a5568;
    }
    .blog-author-card {
      background: white;
      padding: 2rem;
      border-radius: 15px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.08);
      margin-top: 3rem;
      display: flex;
      align-items: center;
      gap: 1.5rem;
    }
    .author-avatar {
      width: 80px;
      height: 80px;
      border-radius: 50%;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 2rem;
      font-weight: 700;
    }
    .author-info h4 {
      margin: 0 0 0.5rem;
      font-weight: 700;
      color: #2d3748;
    }
    .author-info p {
      margin: 0;
      color: #718096;
    }
    @media (max-width: 768px) {
      .blog-title { font-size: 1.75rem; }
      .blog-content { padding: 1.5rem; }
      .blog-meta { gap: 1rem; }
    }
  </style>
</head>
<body>
  <jsp:include page="/views/component/header.jsp" />
  
  <!-- Hero Section -->
  <div class="blog-hero">
    <div class="container">
      <a href="<%= request.getContextPath() %>/blogs" class="back-button">
        <i class="fas fa-arrow-left"></i> Quay lại danh sách
      </a>
      <h1 class="blog-title">${blog.title}</h1>
      <div class="blog-meta">
        <div class="blog-meta-item">
          <i class="far fa-calendar"></i>
          <span>${blog.publishedAt != null ? blog.publishedAt : blog.createdAt}</span>
        </div>
        <div class="blog-meta-item">
          <i class="far fa-user"></i>
          <span>${blog.authorName}</span>
        </div>
        <div class="blog-meta-item">
          <i class="far fa-eye"></i>
          <span>${blog.viewCount} lượt xem</span>
        </div>
        <div class="blog-meta-item">
          <i class="far fa-heart"></i>
          <span>${blog.likeCount} thích</span>
        </div>
        <div class="blog-meta-item">
          <i class="far fa-comment"></i>
          <span>${blog.commentCount} bình luận</span>
        </div>
      </div>
    </div>
  </div>

  <!-- Blog Content -->
  <div class="container pb-5">
    <div class="blog-content-wrapper">
      
      <!-- Featured Image -->
      <c:if test="${not empty blog.featuredImage}">
        <img src="<%= request.getContextPath() %>${blog.featuredImage}" 
             alt="${blog.title}" 
             class="blog-featured-image">
      </c:if>

      <!-- Summary -->
      <c:if test="${not empty blog.summary}">
        <div class="blog-stats">
          <div style="flex: 1;">
            <strong style="color: #2d3748;">Tóm tắt:</strong>
            <p class="mb-0 mt-2" style="color: #4a5568;">${blog.summary}</p>
          </div>
        </div>
      </c:if>

      <!-- Main Content -->
      <div class="blog-content">
        ${blog.content}
      </div>

      <!-- Author Card -->
      <div class="blog-author-card">
        <div class="author-avatar">
          ${blog.authorName.substring(0, 1).toUpperCase()}
        </div>
        <div class="author-info">
          <h4>Tác giả: ${blog.authorName}</h4>
          <p>Cảm ơn bạn đã đọc bài viết này!</p>
        </div>
      </div>

      <!-- Comments Section -->
      <div class="comments-section mt-5">
        <h3 class="mb-4">
          <i class="far fa-comments me-2"></i>Bình luận 
          <span class="badge bg-secondary" id="commentCount">${blog.commentCount}</span>
        </h3>
        
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
              Vui lòng <a href="<%= request.getContextPath() %>/login">đăng nhập</a> để bình luận.
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

      <!-- Action Buttons -->
      <div class="text-center mt-5">
        <a href="<%= request.getContextPath() %>/blogs" 
           class="btn btn-lg btn-outline-primary rounded-pill px-5">
          <i class="fas fa-arrow-left me-2"></i>Xem thêm bài viết
        </a>
      </div>
    </div>
  </div>

  <style>
    /* Comment Styles */
    .comments-section {
      margin-top: 3rem;
      padding-top: 3rem;
      border-top: 2px solid #e2e8f0;
    }
    .comment-avatar {
      width: 50px;
      height: 50px;
      border-radius: 50%;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-weight: 700;
      font-size: 1.25rem;
      flex-shrink: 0;
    }
    .comment-input {
      border: 2px solid #e2e8f0;
      border-radius: 10px;
      resize: none;
      transition: all 0.3s;
    }
    .comment-input:focus {
      border-color: #667eea;
      box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
    }
    .comment-item {
      background: white;
      padding: 1.5rem;
      border-radius: 15px;
      margin-bottom: 1rem;
      box-shadow: 0 2px 8px rgba(0,0,0,0.05);
      transition: all 0.3s;
    }
    .comment-item:hover {
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }
    .comment-header {
      display: flex;
      align-items: center;
      gap: 1rem;
      margin-bottom: 0.75rem;
    }
    .comment-author {
      font-weight: 700;
      color: #2d3748;
      margin: 0;
    }
    .comment-time {
      color: #718096;
      font-size: 0.875rem;
    }
    .comment-content {
      color: #4a5568;
      line-height: 1.6;
      margin-bottom: 0.75rem;
    }
    .comment-actions {
      display: flex;
      gap: 1rem;
    }
    .comment-action-btn {
      background: none;
      border: none;
      color: #667eea;
      font-size: 0.875rem;
      cursor: pointer;
      transition: all 0.2s;
      padding: 0.25rem 0.5rem;
    }
    .comment-action-btn:hover {
      color: #764ba2;
      transform: translateY(-1px);
    }
    .reply-form {
      margin-top: 1rem;
      padding-left: 3rem;
    }
    .replies-list {
      margin-top: 1rem;
      padding-left: 3rem;
      border-left: 3px solid #e2e8f0;
    }
    .reply-item {
      background: #f7fafc;
      padding: 1rem;
      border-radius: 10px;
      margin-bottom: 0.75rem;
    }
  </style>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
  
  <script>
    const contextPath = '<%= request.getContextPath() %>';
    const blogId = ${blog.blogId};
    const currentUserId = ${not empty sessionScope.user ? sessionScope.user.user_id : 'null'};
    
    // Load comments on page load
    document.addEventListener('DOMContentLoaded', function() {
      loadComments();
    });
    
    // Load all comments
    function loadComments() {
      fetch(contextPath + '/api/blog/comments?blogId=' + blogId)
        .then(response => response.json())
        .then(data => {
          if (data.success) {
            displayComments(data.comments);
          } else {
            document.getElementById('commentsList').innerHTML = 
              '<div class="alert alert-warning">Không thể tải bình luận: ' + data.message + '</div>';
          }
        })
        .catch(error => {
          console.error('Error:', error);
          document.getElementById('commentsList').innerHTML = 
            '<div class="alert alert-danger">Lỗi khi tải bình luận</div>';
        });
    }
    
    // Display comments
    function displayComments(comments) {
      const container = document.getElementById('commentsList');
      
      if (!comments || comments.length === 0) {
        container.innerHTML = '<div class="text-center text-muted py-4">Chưa có bình luận nào. Hãy là người đầu tiên!</div>';
        return;
      }
      
      let html = '';
      comments.forEach(comment => {
        html += renderComment(comment);
      });
      
      container.innerHTML = html;
    }
    
    // Render a comment
    function renderComment(comment) {
      const isOwner = currentUserId && currentUserId == comment.userId;
      const initials = comment.userName ? comment.userName.charAt(0).toUpperCase() : 'U';
      const timeAgo = formatTimeAgo(new Date(comment.createdAt));
      
      return '<div class="comment-item" id="comment-' + comment.commentId + '">' +
        '<div class="comment-header">' +
        '<div class="comment-avatar">' + initials + '</div>' +
        '<div class="flex-grow-1">' +
        '<h6 class="comment-author">' + comment.userName + '</h6>' +
        '<span class="comment-time">' + timeAgo + '</span>' +
        '</div>' +
        '</div>' +
        '<div class="comment-content" id="content-' + comment.commentId + '">' + escapeHtml(comment.content) + '</div>' +
        '<div class="comment-actions">' +
        (currentUserId ? '<button class="comment-action-btn" onclick="showReplyForm(' + comment.commentId + ')">' +
        '<i class="far fa-reply me-1"></i>Trả lời (' + comment.replyCount + ')' +
        '</button>' : '') +
        (isOwner ? '<button class="comment-action-btn" onclick="editComment(' + comment.commentId + ')">' +
        '<i class="far fa-edit me-1"></i>Sửa' +
        '</button>' : '') +
        (isOwner ? '<button class="comment-action-btn text-danger" onclick="deleteComment(' + comment.commentId + ')">' +
        '<i class="far fa-trash me-1"></i>Xóa' +
        '</button>' : '') +
        '</div>' +
        '<div id="replies-' + comment.commentId + '" class="replies-list" style="display: none;"></div>' +
        '<div id="replyForm-' + comment.commentId + '" class="reply-form" style="display: none;"></div>' +
        '</div>';
    }
    
    // Post new comment
    function postComment() {
      const input = document.getElementById('commentInput');
      const content = input.value.trim();
      
      if (!content) {
        alert('Vui lòng nhập nội dung bình luận');
        return;
      }
      
      fetch(contextPath + '/api/blog/comments/', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          blogId: blogId,
          content: content,
          parentCommentId: null
        })
      })
        .then(response => response.json())
        .then(data => {
          if (data.success) {
            input.value = '';
            loadComments();
            updateCommentCount(1);
          } else {
            alert('Lỗi: ' + data.message);
          }
        })
        .catch(error => {
          console.error('Error:', error);
          alert('Không thể gửi bình luận');
        });
    }
    
    // Show reply form
    function showReplyForm(commentId) {
      // Load replies first
      loadReplies(commentId);
      
      // Toggle reply form
      const formDiv = document.getElementById('replyForm-' + commentId);
      if (formDiv.style.display === 'none') {
        const initials = '${sessionScope.user.full_name}'.charAt(0).toUpperCase();
        formDiv.innerHTML = 
          '<div class="d-flex gap-2 mt-2">' +
          '<div class="comment-avatar" style="width: 40px; height: 40px; font-size: 1rem;">' + initials + '</div>' +
          '<div class="flex-grow-1">' +
          '<textarea class="form-control comment-input" id="replyInput-' + commentId + '" rows="2" placeholder="Viết trả lời..."></textarea>' +
          '<div class="text-end mt-2">' +
          '<button class="btn btn-sm btn-secondary rounded-pill me-2" onclick="hideReplyForm(' + commentId + ')">Hủy</button>' +
          '<button class="btn btn-sm btn-primary rounded-pill" onclick="postReply(' + commentId + ')">Gửi</button>' +
          '</div></div></div>';
        formDiv.style.display = 'block';
      } else {
        formDiv.style.display = 'none';
      }
    }
    
    // Hide reply form
    function hideReplyForm(commentId) {
      document.getElementById('replyForm-' + commentId).style.display = 'none';
    }
    
    // Post reply
    function postReply(parentId) {
      const input = document.getElementById('replyInput-' + parentId);
      const content = input.value.trim();
      
      if (!content) {
        alert('Vui lòng nhập nội dung');
        return;
      }
      
      fetch(contextPath + '/api/blog/comments/', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          blogId: blogId,
          content: content,
          parentCommentId: parentId
        })
      })
        .then(response => response.json())
        .then(data => {
          if (data.success) {
            hideReplyForm(parentId);
            loadReplies(parentId);
            updateCommentCount(1);
          } else {
            alert('Lỗi: ' + data.message);
          }
        });
    }
    
    // Load replies
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
                  '</div>' +
                  '<div class="comment-content">' + escapeHtml(reply.content) + '</div>' +
                  (isOwner ? '<div class="mt-2">' +
                  '<button class="btn btn-sm btn-link text-danger" onclick="deleteComment(' + reply.commentId + ')">Xóa</button>' +
                  '</div>' : '') +
                  '</div>';
              });
              repliesDiv.innerHTML = html;
              repliesDiv.style.display = 'block';
            }
          }
        });
    }
    
    // Edit comment
    function editComment(commentId) {
      const contentDiv = document.getElementById('content-' + commentId);
      const currentContent = contentDiv.textContent;
      
      contentDiv.innerHTML = 
        '<textarea class="form-control comment-input" id="editInput-' + commentId + '" rows="2">' + currentContent + '</textarea>' +
        '<div class="text-end mt-2">' +
        '<button class="btn btn-sm btn-secondary rounded-pill me-2" onclick="cancelEdit(' + commentId + ', \'' + currentContent.replace(/'/g, "\\'") + '\')">Hủy</button>' +
        '<button class="btn btn-sm btn-primary rounded-pill" onclick="saveEdit(' + commentId + ')">Lưu</button>' +
        '</div>';
    }
    
    // Cancel edit
    function cancelEdit(commentId, originalContent) {
      document.getElementById('content-' + commentId).textContent = originalContent;
    }
    
    // Save edit
    function saveEdit(commentId) {
      const content = document.getElementById('editInput-' + commentId).value.trim();
      
      if (!content) {
        alert('Nội dung không được để trống');
        return;
      }
      
      fetch(contextPath + '/api/blog/comments/', {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ commentId: commentId, content: content })
      })
        .then(response => response.json())
        .then(data => {
          if (data.success) {
            document.getElementById('content-' + commentId).textContent = content;
          } else {
            alert('Lỗi: ' + data.message);
          }
        });
    }
    
    // Delete comment
    function deleteComment(commentId) {
      if (!confirm('Bạn có chắc muốn xóa bình luận này?')) return;
      
      fetch(contextPath + '/api/blog/comments/' + commentId, {
        method: 'DELETE'
      })
        .then(response => response.json())
        .then(data => {
          if (data.success) {
            loadComments();
            updateCommentCount(-1);
          } else {
            alert('Lỗi: ' + data.message);
          }
        });
    }
    
    // Update comment count
    function updateCommentCount(delta) {
      const badge = document.getElementById('commentCount');
      const current = parseInt(badge.textContent);
      badge.textContent = current + delta;
    }
    
    // Format time ago
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
        if (count >= 1) {
          return count + ' ' + interval.label + ' trước';
        }
      }
      return 'Vừa xong';
    }
    
    // Escape HTML
    function escapeHtml(text) {
      const div = document.createElement('div');
      div.textContent = text;
      return div.innerHTML;
    }
  </script>
</body>
</html>