<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <title>${post.title}</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
  <jsp:include page="/views/component/header.jsp" />
  <div class="container py-5">
    <a href="<%= request.getContextPath() %>/blog" class="text-decoration-none">← Quay lại</a>
    <h1 class="mt-3">${post.title}</h1>
    <div class="text-muted mb-3">${post.type} • ${post.createdAt} • Tác giả: <c:out value="${post.author != null ? post.author.full_name : 'N/A'}"/></div>
    <div class="content">${post.content}</div>
  </div>
</body>
</html>