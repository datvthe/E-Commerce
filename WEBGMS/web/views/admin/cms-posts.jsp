<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quản lý Bài viết</title>
  </head>
  <body>
    <jsp:include page="/views/component/sidebar.jsp" />
    <main class="main-wrapper">
      <jsp:include page="/views/component/headerAdmin.jsp" />

      <section class="section">
        <div class="container-fluid">
          <div class="title-wrapper pt-30 d-flex justify-content-between align-items-center">
            <h2 class="mb-0">Bài viết</h2>
            <a href="<%= request.getContextPath() %>/admin/cms/posts?action=create" class="main-btn primary-btn btn-hover">Thêm bài viết</a>
          </div>

          <div class="card-style mt-3">
            <form class="row g-2 mb-3" method="get" action="">
              <input type="hidden" name="action" value="list" />
              <div class="col-md-3">
                <input class="form-control" type="text" name="q" placeholder="Tìm kiếm tiêu đề..." value="<%= request.getParameter("q")!=null?request.getParameter("q"):"" %>" />
              </div>
              <div class="col-md-2">
                <select name="type" class="form-select">
                  <option value="">Tất cả loại</option>
                  <option value="news">Tin tức</option>
                  <option value="tutorial">Hướng dẫn</option>
                  <option value="blog">Blog</option>
                </select>
              </div>
              <div class="col-md-2">
                <select name="status" class="form-select">
                  <option value="">Tất cả trạng thái</option>
                  <option value="draft">Nháp</option>
                  <option value="published">Đã xuất bản</option>
                </select>
              </div>
              <div class="col-md-2">
                <button class="main-btn primary-btn btn-hover" type="submit">Lọc</button>
              </div>
            </form>

            <div class="table-wrapper table-responsive">
              <table class="table">
                <thead>
                  <tr>
                    <th><h6>ID</h6></th>
                    <th><h6>Tiêu đề</h6></th>
                    <th><h6>Loại</h6></th>
                    <th><h6>Trạng thái</h6></th>
                    <th><h6>Tác giả</h6></th>
                    <th><h6>Cập nhật</h6></th>
                    <th><h6>Hành động</h6></th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="p" items="${posts}">
                    <tr>
                      <td><p>${p.id}</p></td>
                      <td><p>${p.title}</p></td>
                      <td><p>${p.type}</p></td>
                      <td>
                        <span class="status-btn ${p.status == 'published' ? 'success-btn' : 'warning-btn'}">${p.status}</span>
                      </td>
                      <td><p><c:out value="${p.author != null ? p.author.full_name : 'N/A'}"/></p></td>
                      <td><p>${p.updatedAt}</p></td>
                      <td>
                        <a class="main-btn primary-btn-outline btn-sm" href="<%= request.getContextPath() %>/admin/cms/posts?action=edit&id=${p.id}">Sửa</a>
                        <a class="main-btn danger-btn-outline btn-sm" href="<%= request.getContextPath() %>/admin/cms/posts?action=delete&id=${p.id}" onclick="return confirm('Xóa bài viết này?')">Xóa</a>
                      </td>
                    </tr>
                  </c:forEach>
                  <c:if test="${empty posts}">
                    <tr><td colspan="7" class="text-center">Chưa có bài viết</td></tr>
                  </c:if>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </section>
    </main>
  </body>
</html>
