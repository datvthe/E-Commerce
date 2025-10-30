<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Tin tức & Blog - Gicungco</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    body {
      background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
      min-height: 100vh;
    }
    .blog-header {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 4rem 0 3rem;
      margin-bottom: 3rem;
      box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    }
    .search-box {
      background: white;
      border-radius: 50px;
      box-shadow: 0 8px 20px rgba(0,0,0,0.1);
      padding: 0.5rem;
    }
    .search-box input {
      border: none;
      outline: none;
    }
    .search-box select {
      border: none;
      max-width: 150px;
    }
    .blog-card {
      border: none;
      border-radius: 20px;
      overflow: hidden;
      transition: all 0.3s ease;
      box-shadow: 0 4px 15px rgba(0,0,0,0.1);
      height: 100%;
      background: white;
    }
    .blog-card:hover {
      transform: translateY(-10px);
      box-shadow: 0 12px 30px rgba(0,0,0,0.15);
    }
    .blog-card-img {
      height: 200px;
      object-fit: cover;
      width: 100%;
    }
    .blog-card-body {
      padding: 1.5rem;
    }
    .blog-badge {
      display: inline-block;
      padding: 0.4rem 1rem;
      border-radius: 50px;
      font-size: 0.75rem;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
    .badge-news { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
    .badge-tutorial { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: white; }
    .badge-blog { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); color: white; }
    .blog-title {
      font-weight: 700;
      color: #2d3748;
      margin: 1rem 0 0.5rem;
      font-size: 1.25rem;
      line-height: 1.4;
    }
    .blog-meta {
      color: #718096;
      font-size: 0.875rem;
      margin-bottom: 1rem;
    }
    .blog-excerpt {
      color: #4a5568;
      line-height: 1.6;
      margin-bottom: 1.5rem;
    }
    .btn-read-more {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      border: none;
      color: white;
      padding: 0.6rem 1.5rem;
      border-radius: 50px;
      font-weight: 600;
      transition: all 0.3s ease;
    }
    .btn-read-more:hover {
      transform: scale(1.05);
      box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
      color: white;
    }
    .empty-state {
      text-align: center;
      padding: 4rem 2rem;
    }
    .empty-state i {
      font-size: 4rem;
      color: #cbd5e0;
      margin-bottom: 1rem;
    }
  </style>
</head>
<body>
  <jsp:include page="/views/component/header.jsp" />
  
  <!-- Header Section -->
  <div class="blog-header">
    <div class="container">
      <div class="row align-items-center">
        <div class="col-lg-6 mb-4 mb-lg-0">
          <h1 class="display-4 fw-bold mb-3">
            <i class="fas fa-newspaper me-3"></i>Tin tức & Blog
          </h1>
          <p class="lead mb-0">Khám phá những bài viết mới nhất và thú vị nhất</p>
        </div>
        <div class="col-lg-6">
          <form method="get" action="">
            <div class="search-box d-flex align-items-center">
              <i class="fas fa-search text-muted ms-3 me-2"></i>
              <input type="text" class="form-control border-0" name="q" value="${q}" 
                     placeholder="Tìm kiếm bài viết..." style="flex: 1;">
              <select class="form-select border-0 me-2" name="type">
                <option value="">Tất cả</option>
                <option value="news" ${type=='news'?'selected':''}>Tin tức</option>
                <option value="tutorial" ${type=='tutorial'?'selected':''}>Hướng dẫn</option>
                <option value="blog" ${type=='blog'?'selected':''}>Blog</option>
              </select>
              <button class="btn btn-primary rounded-pill px-4" type="submit">
                <i class="fas fa-search me-2"></i>Tìm
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>

  <!-- Blog Posts Grid -->
  <div class="container pb-5">
    <div class="row g-4">
      <c:forEach var="p" items="${posts}">
        <div class="col-lg-4 col-md-6">
          <div class="blog-card">
            <c:choose>
              <c:when test="${not empty p.featuredImage}">
                <img src="<%= request.getContextPath() %>${p.featuredImage}" class="blog-card-img" alt="${p.title}">
              </c:when>
              <c:otherwise>
                <div class="blog-card-img bg-gradient d-flex align-items-center justify-content-center"
                     style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                  <i class="fas fa-newspaper fa-4x text-white opacity-50"></i>
                </div>
              </c:otherwise>
            </c:choose>
            <div class="blog-card-body">
              <span class="blog-badge badge-${p.type}">${p.type}</span>
              <h5 class="blog-title">${p.title}</h5>
              <div class="blog-meta">
                <i class="far fa-calendar me-1"></i> ${p.createdAt}
                <span class="mx-2">•</span>
                <i class="far fa-user me-1"></i> ${p.authorName}
              </div>
              <p class="blog-excerpt">${p.summary}</p>
              <a class="btn btn-read-more" href="<%= request.getContextPath() %>/blog/${p.slug}">
                <i class="fas fa-book-reader me-2"></i>Đọc tiếp
              </a>
            </div>
          </div>
        </div>
      </c:forEach>
      
      <c:if test="${empty posts}">
        <div class="col-12">
          <div class="empty-state">
            <i class="fas fa-newspaper"></i>
            <h3 class="text-muted mb-3">Chưa có bài viết nào</h3>
            <p class="text-muted">Hãy quay lại sau để xem những bài viết mới nhất!</p>
            <a href="<%= request.getContextPath() %>/home" class="btn btn-primary rounded-pill px-4 mt-3">
              <i class="fas fa-home me-2"></i>Về trang chủ
            </a>
          </div>
        </div>
      </c:if>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>