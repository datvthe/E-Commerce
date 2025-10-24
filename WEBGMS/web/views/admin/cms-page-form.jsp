<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quản lý Trang tĩnh</title>
  </head>
  <body>
    <jsp:include page="/views/component/sidebar.jsp" />
    <main class="main-wrapper">
      <jsp:include page="/views/component/headerAdmin.jsp" />

      <section class="section">
        <div class="container-fluid">
          <div class="title-wrapper pt-30 d-flex justify-content-between align-items-center">
            <h2 class="mb-0">Trang tĩnh</h2>
            <div></div>
          </div>

          <div class="card-style mt-3">
            <c:if test="${param.saved == '1'}">
              <div class="alert alert-success">Đã lưu trang.</div>
            </c:if>
            <c:if test="${not empty error}">
              <div class="alert alert-danger">${error}</div>
            </c:if>
            <form method="post" action="<%= request.getContextPath() %>/admin/cms/pages">
              <div class="row g-3">
                <div class="col-md-4">
                  <label class="form-label">Chọn trang</label>
                  <select class="form-select" name="slug" onchange="location.href='\
<%= request.getContextPath() %>/admin/cms/pages?slug='+this.value">
                    <option value="about" ${pageData != null && pageData.slug=='about' ? 'selected' : ''}>About</option>
                    <option value="contact" ${pageData != null && pageData.slug=='contact' ? 'selected' : ''}>Contact</option>
                    <option value="return-policy" ${pageData != null && pageData.slug=='return-policy' ? 'selected' : ''}>Return Policy</option>
                  </select>
                </div>
                <div class="col-md-4">
                  <label class="form-label">Tiêu đề</label>
                  <input class="form-control" type="text" name="title" value="${pageData != null ? pageData.title : ''}" />
                </div>
                <div class="col-md-4">
                  <label class="form-label">Trạng thái</label>
                  <select class="form-select" name="status">
                    <option value="draft" ${pageData != null && pageData.status=='draft' ? 'selected' : ''}>Nháp</option>
                    <option value="published" ${pageData != null && pageData.status=='published' ? 'selected' : ''}>Đã xuất bản</option>
                  </select>
                </div>
                <div class="col-12">
                  <label class="form-label">Nội dung</label>
                  <textarea class="form-control" rows="12" name="content">${pageData != null ? pageData.content : ''}</textarea>
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
