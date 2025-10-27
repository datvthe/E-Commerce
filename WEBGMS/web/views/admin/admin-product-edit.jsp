<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <title>Chỉnh sửa sản phẩm</title>
</head>
<body>
  <jsp:include page="/views/component/sidebar.jsp" />
  <main class="main-wrapper">
    <jsp:include page="/views/component/headerAdmin.jsp" />
    <section class="section">
      <div class="container-fluid">
        <div class="title-wrapper pt-30">
          <div class="row align-items-center">
            <div class="col-md-6"><div class="title"><h2>Chỉnh sửa sản phẩm</h2></div></div>
            <div class="col-md-6">
              <div class="breadcrumb-wrapper">
                <nav aria-label="breadcrumb">
                  <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="<%= request.getContextPath() %>/admin/products">Sản phẩm</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Chỉnh sửa</li>
                  </ol>
                </nav>
              </div>
            </div>
          </div>
        </div>

        <div class="row">
          <div class="col-lg-8">
            <div class="card-style mb-30">
              <form method="post" action="<%= request.getContextPath() %>/admin/products/update" enctype="multipart/form-data">
                <input type="hidden" name="product_id" value="${product.product_id}" />
                <div class="input-style-1 mb-20">
                  <label>Tên sản phẩm</label>
                  <input type="text" name="name" class="form-control" value="${product.name}" required />
                </div>
                <div class="input-style-1 mb-20">
                  <label>Mô tả</label>
                  <textarea name="description" class="form-control" rows="5">${product.description}</textarea>
                </div>
                <div class="row g-3 mb-20">
                  <div class="col-md-4"><label>Giá</label><input type="number" step="0.01" name="price" class="form-control" value="${product.price}" required /></div>
                  <div class="col-md-4"><label>Số lượng</label><input type="number" name="quantity" class="form-control" value="${product.quantity}" required /></div>
                  <div class="col-md-4">
                    <label>Trạng thái</label>
                    <select name="status" class="form-select">
                      <option value="active" ${product.status=='active'?'selected':''}>active</option>
                      <option value="inactive" ${product.status=='inactive'?'selected':''}>inactive</option>
                      <option value="draft" ${product.status=='draft'?'selected':''}>draft</option>
                    </select>
                  </div>
                </div>
                <div class="input-style-1 mb-20">
                  <label>Danh mục</label>
                  <select name="category_id" class="form-select" required>
                    <c:forEach var="c" items="${categories}">
                      <option value="${c.category_id}" ${product.category_id!=null && product.category_id.category_id==c.category_id? 'selected' : ''}>${c.name}</option>
                    </c:forEach>
                  </select>
                </div>
                <div class="input-style-1 mb-20">
                  <label>Ảnh đại diện (tùy chọn)</label>
                  <input type="file" name="image" class="form-control" accept="image/*" />
                </div>
                <div class="d-flex gap-2">
                  <button class="main-btn primary-btn btn-hover" type="submit"><i class="lni lni-save"></i> Lưu</button>
                  <a href="<%= request.getContextPath() %>/admin/products" class="main-btn danger-btn-outline btn-hover">Hủy</a>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </section>
  </main>
</body>
</html>