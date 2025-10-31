<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <title>Hồ sơ quản trị</title>
  </head>
  <body>
    <jsp:include page="/views/component/sidebar.jsp" />
    <main class="main-wrapper">
      <jsp:include page="/views/component/headerAdmin.jsp" />

      <section class="section">
        <div class="container-fluid">
          <div class="title-wrapper pt-30">
            <div class="row align-items-center">
              <div class="col-md-6"><h2>Hồ sơ quản trị</h2></div>
            </div>
          </div>

          <div class="row g-3">
            <div class="col-xl-4 col-lg-5">
              <div class="card-style text-center">
                <form action="<%= request.getContextPath() %>/admin/profile" method="post" enctype="multipart/form-data">
                  <input type="hidden" name="action" value="update_avatar" />
                  <label for="avatar" style="cursor:pointer;display:block;">
                    <c:choose>
                      <c:when test="${not empty user.avatar_url}">
                        <img src="${user.avatar_url}" alt="Avatar" style="width:110px;height:110px;border-radius:50%;object-fit:cover;" />
                      </c:when>
                      <c:otherwise>
                        <img src="<%= request.getContextPath() %>/views/assets/electro/img/avatar.svg" alt="Avatar" style="width:110px;height:110px;border-radius:50%;object-fit:cover;" />
                      </c:otherwise>
                    </c:choose>
                  </label>
                  <input type="file" name="avatar" id="avatar" accept="image/*" hidden onchange="this.form.submit()"/>
                </form>
                <h5 class="mt-2">${user.full_name}</h5>
                <p class="text-sm text-muted">${user.email}</p>
              </div>
            </div>

            <div class="col-xl-8 col-lg-7">
              <div class="card-style">
                <h6 class="mb-3">Thông tin cá nhân</h6>
                <form method="post" action="<%= request.getContextPath() %>/admin/profile">
                  <input type="hidden" name="action" value="update_profile" />
                  <div class="row">
                    <div class="col-md-6 mb-3">
                      <label>Họ và tên</label>
                      <input class="form-control" type="text" name="full_name" value="${user.full_name}" required />
                    </div>
                    <div class="col-md-6 mb-3">
                      <label>Email</label>
                      <input class="form-control" type="email" name="email" value="${user.email}" required />
                    </div>
                    <div class="col-md-6 mb-3">
                      <label>Số điện thoại</label>
                      <input class="form-control" type="text" name="phone" value="${user.phone_number}" />
                    </div>
                    <div class="col-12 mb-3">
                      <label>Địa chỉ</label>
                      <input class="form-control" type="text" name="address" value="${user.address}" />
                    </div>
                  </div>
                  <button class="main-btn primary-btn btn-hover" type="submit">Lưu</button>
                </form>
              </div>

              <div class="card-style mt-3">
                <h6 class="mb-3">Đổi mật khẩu</h6>
                <form method="post" action="<%= request.getContextPath() %>/admin/profile">
                  <input type="hidden" name="action" value="change_password" />
                  <div class="row">
                    <div class="col-md-4 mb-3">
                      <label>Mật khẩu hiện tại</label>
                      <input class="form-control" type="password" name="current_password" required />
                    </div>
                    <div class="col-md-4 mb-3">
                      <label>Mật khẩu mới</label>
                      <input class="form-control" type="password" name="new_password" minlength="8" required />
                    </div>
                    <div class="col-md-4 mb-3">
                      <label>Xác nhận mật khẩu</label>
                      <input class="form-control" type="password" name="confirm_password" minlength="8" required />
                    </div>
                  </div>
                  <button class="main-btn primary-btn btn-hover" type="submit">Cập nhật</button>
                </form>
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>
  </body>
</html>