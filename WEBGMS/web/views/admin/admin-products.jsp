<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <title>Quản lý sản phẩm - Admin</title>
</head>
<body>
  <jsp:include page="/views/component/sidebar.jsp" />
  <main class="main-wrapper">
    <jsp:include page="/views/component/headerAdmin.jsp" />
    <section class="section">
      <div class="container-fluid">
        <div class="title-wrapper pt-30">
          <div class="row align-items-center">
            <div class="col-md-6"><div class="title"><h2>Quản lý sản phẩm</h2></div></div>
            <div class="col-md-6">
              <div class="breadcrumb-wrapper">
                <nav aria-label="breadcrumb">
                  <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="<%= request.getContextPath() %>/admin/dashboard">Bảng điều khiển</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Sản phẩm</li>
                  </ol>
                </nav>
              </div>
            </div>
          </div>
        </div>

        <div class="card-style mb-30">
          <form method="get" action="<%= request.getContextPath() %>/admin/products" class="mb-20">
            <div class="row g-3">
              <div class="col-md-4"><input type="text" name="keyword" value="${keyword}" class="form-control" placeholder="Tìm theo tên..."/></div>
              <div class="col-md-3">
                <select name="category_id" class="form-select">
                  <option value="">Tất cả danh mục</option>
                  <c:forEach var="c" items="${categories}">
                    <option value="${c.category_id}" ${categoryId==c.category_id? 'selected' : ''}>${c.name}</option>
                  </c:forEach>
                </select>
              </div>
              <div class="col-md-3">
                <select name="status" class="form-select">
                  <option value="all" ${empty status || status=='all' ? 'selected' : ''}>Tất cả trạng thái</option>
                  <option value="active" ${status=='active' ? 'selected' : ''}>active</option>
                  <option value="inactive" ${status=='inactive' ? 'selected' : ''}>inactive</option>
                  <option value="draft" ${status=='draft' ? 'selected' : ''}>draft</option>
                </select>
              </div>
              <div class="col-md-2"><button class="main-btn primary-btn btn-hover w-100" type="submit">Tìm kiếm</button></div>
            </div>
          </form>

          <div class="table-wrapper table-responsive">
            <table class="table">
              <thead>
                <tr>
                  <th><h6>ID</h6></th>
                  <th><h6>Tên</h6></th>
                  <th><h6>Giá</h6></th>
                  <th><h6>Số lượng</h6></th>
                  <th><h6>Trạng thái</h6></th>
                  <th><h6>Ngày tạo</h6></th>
                  <th><h6>Thao tác</h6></th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="p" items="${products}">
                  <tr>
                    <td><p>${p.product_id}</p></td>
                    <td><p>${p.name}</p></td>
                    <td><p>${p.price} ${p.currency}</p></td>
                    <td><p>${p.quantity}</p></td>
                    <td><span class="status-btn ${p.status=='active' ? 'success-btn' : (p.status=='inactive' ? 'warning-btn' : '')}">${p.status}</span></td>
                    <td><p>${p.created_at}</p></td>
                    <td>
                      <div class="action">
                        <a class="text-primary me-2" href="<%= request.getContextPath() %>/admin/products/edit?id=${p.product_id}"><i class="lni lni-pencil"></i></a>
                        <form method="post" action="<%= request.getContextPath() %>/admin/products/delete" style="display:inline" onsubmit="return confirm('Xóa sản phẩm này?')">
                          <input type="hidden" name="id" value="${p.product_id}"/>
                          <button class="text-danger" style="border:none;background:none"><i class="lni lni-trash-can"></i></button>
                        </form>
                      </div>
                    </td>
                  </tr>
                </c:forEach>
                <c:if test="${empty products}"><tr><td colspan="7" class="text-center">Không có dữ liệu</td></tr></c:if>
              </tbody>
            </table>
          </div>

          <c:if test="${totalPages>1}">
            <div class="pagination-wrapper mt-20">
              <nav>
                <ul class="pagination">
                  <c:if test="${currentPage>1}"><li class="page-item"><a class="page-link" href="?page=${currentPage-1}&keyword=${keyword}&status=${status}&category_id=${categoryId}">Trước</a></li></c:if>
                  <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${currentPage==i? 'active':''}"><a class="page-link" href="?page=${i}&keyword=${keyword}&status=${status}&category_id=${categoryId}">${i}</a></li>
                  </c:forEach>
                  <c:if test="${currentPage<totalPages}"><li class="page-item"><a class="page-link" href="?page=${currentPage+1}&keyword=${keyword}&status=${status}&category_id=${categoryId}">Sau</a></li></c:if>
                </ul>
              </nav>
            </div>
          </c:if>
        </div>
      </div>
    </section>
  </main>
</body>
</html>