<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Blog - GiCungCo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; }
        .page-header { background: white; border-radius: 15px; padding: 2rem; margin: 2rem 0; box-shadow: 0 10px 40px rgba(0,0,0,0.1); }
        .search-box { max-width: 600px; margin: 0 auto; }
        .blog-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr)); gap: 2rem; margin-bottom: 3rem; }
        .blog-card { background: white; border-radius: 15px; overflow: hidden; box-shadow: 0 5px 20px rgba(0,0,0,0.1); transition: transform 0.3s, box-shadow 0.3s; }
        .blog-card:hover { transform: translateY(-10px); box-shadow: 0 10px 30px rgba(0,0,0,0.2); }
        .blog-image { width: 100%; height: 200px; object-fit: cover; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .blog-body { padding: 1.5rem; }
        .blog-title { font-size: 1.25rem; font-weight: bold; color: #333; margin-bottom: 0.75rem; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
        .blog-summary { color: #666; font-size: 0.95rem; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; margin-bottom: 1rem; }
        .blog-meta { display: flex; justify-content: space-between; align-items: center; font-size: 0.875rem; color: #999; }
        .pagination { background: white; border-radius: 10px; padding: 1rem; }
    </style>
</head>
<body>
    <div class="container py-4">
        <!-- Header -->
        <div class="page-header text-center">
            <h1 class="display-4 mb-3"><i class="fas fa-blog me-3"></i>Blog</h1>
            <p class="lead text-muted mb-4">Khám phá các bài viết hữu ích về công nghệ và gaming</p>
            
            <!-- Search -->
            <form method="GET" class="search-box">
                <div class="input-group input-group-lg">
                    <input type="text" class="form-control" name="q" 
                           value="${keyword}" placeholder="Tìm kiếm blog...">
                    <button class="btn btn-primary" type="submit">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
            </form>
            
            <c:if test="${not empty keyword}">
                <div class="mt-3">
                    <small class="text-muted">
                        Tìm thấy ${totalBlogs} kết quả cho "<strong>${keyword}</strong>"
                        <a href="${pageContext.request.contextPath}/blogs" class="ms-2">Xóa tìm kiếm</a>
                    </small>
                </div>
            </c:if>
        </div>

        <!-- Blog Grid -->
        <c:choose>
            <c:when test="${empty blogs}">
                <div class="text-center py-5 bg-white rounded-3 shadow">
                    <i class="fas fa-inbox fa-4x text-muted mb-3"></i>
                    <h4 class="text-muted">Chưa có blog nào</h4>
                    <p class="text-muted">Hãy quay lại sau!</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="blog-grid">
                    <c:forEach items="${blogs}" var="blog">
                        <a href="${pageContext.request.contextPath}/blog/${blog.slug}" 
                           class="blog-card text-decoration-none">
                            <c:choose>
                                <c:when test="${not empty blog.featuredImage}">
                                    <img src="${pageContext.request.contextPath}${blog.featuredImage}" 
                                         alt="${blog.title}" class="blog-image">
                                </c:when>
                                <c:otherwise>
                                    <div class="blog-image d-flex align-items-center justify-content-center text-white">
                                        <i class="fas fa-newspaper fa-3x"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            
                            <div class="blog-body">
                                <h3 class="blog-title">${blog.title}</h3>
                                <p class="blog-summary">${blog.summary}</p>
                                
                                <div class="blog-meta">
                                    <span>
                                        <i class="far fa-user me-1"></i>${blog.author.full_name}
                                    </span>
                                    <span>
                                        <i class="far fa-calendar me-1"></i>
                                        <fmt:formatDate value="${blog.publishedAt}" pattern="dd/MM/yyyy"/>
                                    </span>
                                </div>
                                
                                <div class="blog-meta mt-2 pt-2 border-top">
                                    <span><i class="far fa-eye me-1"></i>${blog.viewCount}</span>
                                    <span><i class="far fa-heart me-1"></i>${blog.likeCount}</span>
                                    <span><i class="far fa-comment me-1"></i>${blog.commentCount}</span>
                                    <span><i class="far fa-clock me-1"></i>${blog.readingTime} phút</span>
                                </div>
                            </div>
                        </a>
                    </c:forEach>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <nav class="pagination">
                        <ul class="pagination justify-content-center mb-0">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage - 1}${not empty keyword ? '&q='.concat(keyword) : ''}">
                                        <i class="fas fa-chevron-left"></i>
                                    </a>
                                </li>
                            </c:if>
                            
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <c:if test="${i >= currentPage - 2 and i <= currentPage + 2}">
                                    <li class="page-item ${i eq currentPage ? 'active' : ''}">
                                        <a class="page-link" href="?page=${i}${not empty keyword ? '&q='.concat(keyword) : ''}">
                                            ${i}
                                        </a>
                                    </li>
                                </c:if>
                            </c:forEach>
                            
                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage + 1}${not empty keyword ? '&q='.concat(keyword) : ''}">
                                        <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </c:if>
            </c:otherwise>
        </c:choose>

        <!-- Back to Home -->
        <div class="text-center mt-4">
            <a href="${pageContext.request.contextPath}/" class="btn btn-light btn-lg">
                <i class="fas fa-home me-2"></i>Về trang chủ
            </a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

