<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Soạn bài viết</title>
  </head>
  <body>
    <jsp:include page="/views/component/sidebar.jsp" />
    <main class="main-wrapper">
      <jsp:include page="/views/component/headerAdmin.jsp" />

      <section class="section">
        <div class="container-fluid">
          <div class="title-wrapper pt-30 d-flex justify-content-between align-items-center">
            <h2 class="mb-0"><c:out value="${mode == 'edit' ? 'Chỉnh sửa bài viết' : 'Thêm bài viết'}"/></h2>
            <a href="<%= request.getContextPath() %>/admin/cms/posts" class="main-btn btn-sm">Quay lại</a>
          </div>

          <div class="card-style mt-3">
            <c:if test="${not empty error}">
              <div class="alert alert-danger">${error}</div>
            </c:if>
            <form method="post" action="<%= request.getContextPath() %>/admin/cms/posts">
              <input type="hidden" name="action" value="save" />
              <input type="hidden" name="id" value="${post != null ? post.id : 0}" />

              <div class="row g-3">
                <div class="col-md-8">
                  <label class="form-label">Tiêu đề</label>
                  <input class="form-control" type="text" name="title" value="${post != null ? post.title : ''}" required />
                </div>
                <div class="col-md-4">
                  <label class="form-label">Slug</label>
                  <input class="form-control" type="text" name="slug" value="${post != null ? post.slug : ''}" />
                </div>
                <div class="col-md-3">
                  <label class="form-label">Loại</label>
                  <select class="form-select" name="type">
                    <option value="news" ${post != null && post.type=='news' ? 'selected' : ''}>Tin tức</option>
                    <option value="tutorial" ${post != null && post.type=='tutorial' ? 'selected' : ''}>Hướng dẫn</option>
                    <option value="blog" ${post != null && post.type=='blog' ? 'selected' : ''}>Blog</option>
                  </select>
                </div>
                <div class="col-md-3">
                  <label class="form-label">Trạng thái</label>
                  <select class="form-select" name="status">
                    <option value="draft" ${post != null && post.status=='draft' ? 'selected' : ''}>Nháp</option>
                    <option value="published" ${post != null && post.status=='published' ? 'selected' : ''}>Đã xuất bản</option>
                  </select>
                </div>
                <div class="col-md-12">
                  <label class="form-label">Mô tả ngắn</label>
                  <textarea class="form-control" rows="3" name="excerpt">${post != null ? post.excerpt : ''}</textarea>
                </div>
                <div class="col-md-12">
                  <label class="form-label">Nội dung</label>
                  <textarea class="form-control" rows="12" name="content">${post != null ? post.content : ''}</textarea>
                </div>
                <div class="col-12">
                  <button class="main-btn primary-btn btn-hover" type="submit">Lưu</button>
                </div>
              </div>
            </form>
          </div>
        </div>
      </section>
    </main>
  </body>
</html>
