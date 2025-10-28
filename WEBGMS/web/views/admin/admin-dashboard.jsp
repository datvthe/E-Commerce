<%-- 
    Document   : admin-dashboard
    Created on : Sep 20, 2025, 11:52:17 AM
    Author     : trant
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Bảng điều khiển - Quản trị</title>
  </head>
  <body>
    <jsp:include page="/views/component/sidebar.jsp" />

    <main class="main-wrapper">
      <jsp:include page="/views/component/headerAdmin.jsp" />

      <section class="section">
        <div class="container-fluid">
          <div class="title-wrapper pt-30">
            <div class="row align-items-center">
              <div class="col-md-6">
                <div class="title" style="display:flex; align-items:center; gap:12px;">
                  <h2>Bảng điều khiển</h2>
                  <a href="<%= request.getContextPath() %>/admin/orders" class="main-btn primary-btn btn-hover" style="padding:6px 12px; text-decoration:none;">Quản lý Order</a>
                </div>
              </div>
              <div class="col-md-6">
                <div class="breadcrumb-wrapper">
                  <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                      <li class="breadcrumb-item">
                        <a href="<%= request.getContextPath() %>/admin/dashboard">Bảng điều khiển</a>
                      </li>
                      <li class="breadcrumb-item active" aria-current="page">
                        Tổng quan
                      </li>
                    </ol>
                  </nav>
                </div>
              </div>
            </div>
          </div>

          <!-- Alerts (tham khảo alerts.html) -->
          <div class="row mb-3">
            <div class="col-12">
              <div class="alert alert-primary" role="alert">
                Chào mừng bạn đến với trang quản trị. Dưới đây là số liệu tổng quan hôm nay.
              </div>
            </div>
          </div>

          <!-- Stat cards -->
          <div class="row g-3 mb-30">
            <div class="col-xl-3 col-md-6">
              <div class="card-style">
                <h6 class="text-muted mb-2">Tổng người dùng</h6>
                <h3 class="mb-0">${totalUsers}</h3>
              </div>
            </div>
            <div class="col-xl-3 col-md-6">
              <div class="card-style">
                <h6 class="text-muted mb-2">Tổng sản phẩm</h6>
                <h3 class="mb-0">${totalProducts}</h3>
              </div>
            </div>
            <div class="col-xl-3 col-md-6">
              <div class="card-style">
                <h6 class="text-muted mb-2">Tổng đơn hàng</h6>
                <h3 class="mb-0">${totalOrders}</h3>
              </div>
            </div>
            <div class="col-xl-3 col-md-6">
              <div class="card-style">
                <h6 class="text-muted mb-2">Doanh thu hôm nay</h6>
                <h3 class="mb-0">${revenueToday} VND</h3>
              </div>
            </div>
          </div>

          <!-- Recent lists -->
          <div class="row g-3">
            <div class="col-lg-6">
              <div class="card-style">
                <div class="d-flex justify-content-between align-items-center mb-2">
                  <h6 class="mb-0">Người dùng mới</h6>
                  <a href="<%= request.getContextPath() %>/admin/users" class="text-sm" style="text-decoration:none;">Xem tất cả</a>
                </div>
                <div class="table-wrapper table-responsive">
                  <table class="table">
                    <thead>
                      <tr>
                        <th><h6>ID</h6></th>
                        <th><h6>Họ tên</h6></th>
                        <th><h6>Email</h6></th>
                        <th><h6>Ngày tạo</h6></th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach var="u" items="${recentUsers}">
                        <tr>
                          <td><p>${u.user_id}</p></td>
                          <td><p>${u.full_name}</p></td>
                          <td><p>${u.email}</p></td>
                          <td><p>${u.created_at}</p></td>
                        </tr>
                      </c:forEach>
                      <c:if test="${empty recentUsers}">
                        <tr><td colspan="4" class="text-center">Không có dữ liệu</td></tr>
                      </c:if>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>

            <div class="col-lg-6">
              <div class="card-style">
                <div class="d-flex justify-content-between align-items-center mb-2">
                  <h6 class="mb-0">Đơn hàng gần đây</h6>
                  <span class="badge bg-secondary">Hôm nay: ${ordersToday}</span>
                </div>
                <div class="table-wrapper table-responsive">
                  <table class="table">
                    <thead>
                      <tr>
                        <th><h6>ID</h6></th>
                        <th><h6>Người mua</h6></th>
                        <th><h6>Trạng thái</h6></th>
                        <th><h6>Tổng tiền</h6></th>
                        <th><h6>Thời gian</h6></th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach var="o" items="${recentOrders}">
                        <tr>
                          <td><p>${o.order_id}</p></td>
                          <td><p><c:out value="${o.buyer_id != null ? o.buyer_id.full_name : 'N/A'}"/></p></td>
                          <td>
                            <span class="status-btn ${o.status == 'paid' ? 'success-btn' : (o.status == 'pending' ? 'warning-btn' : '')}">
                              ${o.status}
                            </span>
                          </td>
                          <td><p>${o.total_amount} ${o.currency}</p></td>
                          <td><p>${o.created_at}</p></td>
                        </tr>
                      </c:forEach>
                      <c:if test="${empty recentOrders}">
                        <tr><td colspan="5" class="text-center">Không có dữ liệu</td></tr>
                      </c:if>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>

          <!-- Categories snapshot -->
          <div class="row g-3 mt-2">
            <div class="col-lg-12">
              <div class="card-style">
                <div class="d-flex justify-content-between align-items-center mb-2">
                  <h6 class="mb-0">Danh mục hiện có (${totalCategories})</h6>
                  <div>
                    <a href="<%= request.getContextPath() %>/admin/categories" class="main-btn primary-btn btn-hover">Quản lý danh mục</a>
                    <a href="<%= request.getContextPath() %>/admin/categories?action=create" class="main-btn success-btn btn-hover">Thêm danh mục</a>
                  </div>
                </div>
                <div class="table-wrapper table-responsive">
                  <table class="table">
                    <thead>
                      <tr>
                        <th><h6>ID</h6></th>
                        <th><h6>Tên</h6></th>
                        <th><h6>Slug</h6></th>
                        <th><h6>Trạng thái</h6></th>
                        <th><h6>Ngày tạo</h6></th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach var="c" items="${adminCategories}">
                        <tr>
                          <td><p>${c.category_id}</p></td>
                          <td><p>${c.name}</p></td>
                          <td><p>${c.slug}</p></td>
                          <td>
                            <span class="status-btn ${c.status == 'active' ? 'success-btn' : 'warning-btn'}">${c.status}</span>
                          </td>
                          <td><p>${c.created_at}</p></td>
                        </tr>
                      </c:forEach>
                      <c:if test="${empty adminCategories}">
                        <tr><td colspan="5" class="text-center">Không có dữ liệu</td></tr>
                      </c:if>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>
  </body>
</html>
