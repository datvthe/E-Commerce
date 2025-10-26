<%-- 
    Document   : admin-dashboard
    Created on : Sep 20, 2025, 11:52:17 AM
    Author     : trant
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <title>Quản lý danh mục| Quản trị</title>
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
                <div class="title">
                  <h2>Liên kết nhanh</h2>
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
                        Quản lý danh mục
                      </li>
                    </ol>
                  </nav>
                </div>
              </div>
            </div>
          </div>

          <div class="card-style p-4">
            <div class="d-flex gap-2 flex-wrap">
              <a class="main-btn primary-btn btn-hover" href="<%= request.getContextPath() %>/admin/users">
                Quản lý người dùng
              </a>
              <a class="main-btn primary-btn btn-hover" href="<%= request.getContextPath() %>/admin/categories">
                Quản lý danh mục
              </a>
            </div>
          </div>
        </div>
      </section>
    </main>
  </body>
</html>
