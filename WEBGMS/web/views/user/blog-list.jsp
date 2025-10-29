<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <%@ include file="/views/component/head.jspf" %>
  <title>Tin tức & Blog</title>
</head>
<body>
  <jsp:include page="/views/component/header.jsp" />
  <div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h2 class="mb-0">Tin tức & Blog</h2>
      <form class="d-flex" method="get" action="">
        <input type="text" class="form-control me-2" name="q" value="${q}" placeholder="Tìm bài viết..." />
        <select class="form-select me-2" name="type">
          <option value="">Tất cả</option>
          <option value="news" ${type=='news'?'selected':''}>Tin tức</option>
          <option value="tutorial" ${type=='tutorial'?'selected':''}>Hướng dẫn</option>
          <option value="blog" ${type=='blog'?'selected':''}>Blog</option>
        </select>
        <button class="btn btn-primary">Tìm</button>
      </form>
    </div>

    <div class="row g-3">
      <c:forEach var="p" items="${posts}">
        <div class="col-md-6">
          <div class="card h-100">
            <div class="card-body">
              <h5 class="card-title">${p.title}</h5>
              <small class="text-muted">${p.type} • ${p.createdAt}</small>
              <p class="card-text mt-2">${p.excerpt}</p>
              <a class="btn btn-outline-primary btn-sm" href="<%= request.getContextPath() %>/blog/detail?id=${p.id}">Đọc tiếp</a>
            </div>
          </div>
        </div>
      </c:forEach>
      <c:if test="${empty posts}">
        <div class="col-12 text-center text-muted">Chưa có bài viết.</div>
      </c:if>
    </div>
  </div>

  <!-- Scripts (match homepage so header components work) -->
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
  <script src="<%= request.getContextPath() %>/views/assets/electro/lib/wow/wow.min.js"></script>
  <script src="<%= request.getContextPath() %>/views/assets/electro/lib/easing/easing.min.js"></script>
  <script src="<%= request.getContextPath() %>/views/assets/electro/lib/waypoints/waypoints.min.js"></script>
  <script src="<%= request.getContextPath() %>/views/assets/electro/lib/counterup/counterup.min.js"></script>
  <script src="<%= request.getContextPath() %>/views/assets/electro/lib/owlcarousel/owl.carousel.min.js"></script>
  <script src="<%= request.getContextPath() %>/views/assets/electro/js/main.js"></script>
</body>
</html>
