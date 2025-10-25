<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quản lý Đánh giá</title>
  </head>
  <body>
    <jsp:include page="/views/component/sidebar.jsp" />
    <main class="main-wrapper">
      <jsp:include page="/views/component/headerAdmin.jsp" />

      <section class="section">
        <div class="container-fluid">
          <div class="title-wrapper pt-30 d-flex justify-content-between align-items-center">
            <h2 class="mb-0">Đánh giá sản phẩm</h2>
          </div>

          <div class="card-style mt-3">
            <form class="row g-2 mb-3" method="get" action="">
              <div class="col-md-3">
                <select name="status" class="form-select">
                  <option value="">Tất cả</option>
                  <option value="visible" ${param.status == 'visible' ? 'selected' : ''}>Hiển thị</option>
                  <option value="hidden" ${param.status == 'hidden' ? 'selected' : ''}>Ẩn</option>
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
                    <th><h6>Sản phẩm</h6></th>
                    <th><h6>Người mua</h6></th>
                    <th><h6>Điểm</h6></th>
                    <th><h6>Bình luận</h6></th>
                    <th><h6>Trạng thái</h6></th>
                    <th><h6>Hành động</h6></th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="r" items="${reviews}">
                    <tr>
                      <td><p>${r.reviewId}</p></td>
                      <td><p>${r.productId.product_id}</p></td>
                      <td><p><c:out value="${r.buyerId.full_name}"/></p></td>
                      <td><p>${r.rating}</p></td>
                      <td><p style="max-width:300px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">${r.comment}</p></td>
                      <td>
                        <span class="status-btn ${r.status == 'visible' ? 'success-btn' : 'warning-btn'}">${r.status}</span>
                      </td>
                      <td>
                        <form method="post" action="<%= request.getContextPath() %>/admin/cms/reviews" style="display:inline;">
                          <input type="hidden" name="id" value="${r.reviewId}" />
                          <input type="hidden" name="action" value="show" />
                          <button class="main-btn success-btn-outline btn-sm" ${r.status=='visible'?'disabled':''}>Hiện</button>
                        </form>
                        <form method="post" action="<%= request.getContextPath() %>/admin/cms/reviews" style="display:inline;">
                          <input type="hidden" name="id" value="${r.reviewId}" />
                          <input type="hidden" name="action" value="hide" />
                          <button class="main-btn danger-btn-outline btn-sm" ${r.status=='hidden'?'disabled':''}>Ẩn</button>
                        </form>
                      </td>
                    </tr>
                  </c:forEach>
                  <c:if test="${empty reviews}">
                    <tr><td colspan="7" class="text-center">Không có đánh giá</td></tr>
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
