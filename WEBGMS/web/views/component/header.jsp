<%@ taglib prefix="c" uri="jakarta.tags.core" %> <%@page contentType="text/html"
pageEncoding="UTF-8"%>
<!-- Toast Notifications -->
<div class="position-fixed top-0 end-0 p-3" style="z-index: 1080">
  <c:if test="${not empty sessionScope.message}">
    <div
      id="toast-success"
      class="toast align-items-center text-white bg-success border-0"
      role="alert"
      aria-live="assertive"
      aria-atomic="true"
    >
      <div class="d-flex">
        <div class="toast-body">${sessionScope.message}</div>
        <button
          type="button"
          class="btn-close btn-close-white me-2 m-auto"
          data-bs-dismiss="toast"
          aria-label="Close"
        ></button>
      </div>
    </div>
    <c:remove var="message" scope="session" />
  </c:if>
  <c:if test="${not empty sessionScope.error}">
    <div
      id="toast-error"
      class="toast align-items-center text-white bg-danger border-0"
      role="alert"
      aria-live="assertive"
      aria-atomic="true"
    >
      <div class="d-flex">
        <div class="toast-body">${sessionScope.error}</div>
        <button
          type="button"
          class="btn-close btn-close-white me-2 m-auto"
          data-bs-dismiss="toast"
          aria-label="Close"
        ></button>
      </div>
    </div>
    <c:remove var="error" scope="session" />
  </c:if>
</div>
<script>
  (function () {
    try {
      var toastSuccess = document.getElementById("toast-success");
      if (toastSuccess)
        new bootstrap.Toast(toastSuccess, { delay: 3000 }).show();
      var toastError = document.getElementById("toast-error");
      if (toastError) new bootstrap.Toast(toastError, { delay: 4000 }).show();
    } catch (e) {}
  })();
</script>

<!-- Spinner Start -->
<div
  id="spinner"
  class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center"
>
  <div
    class="spinner-border text-primary"
    style="width: 3rem; height: 3rem"
    role="status"
  >
    <span class="sr-only">Loading...</span>
  </div>
</div>
<!-- Spinner End -->

<!-- Topbar Start -->
<div class="container-fluid px-5 d-none border-bottom d-lg-block">
  <div class="row gx-0 align-items-center">
    <div class="col-lg-4 text-center text-lg-start mb-lg-0">
      <div class="d-inline-flex align-items-center" style="height: 45px">
        <a href="#" class="text-muted me-2"> Trợ giúp</a><small> / </small>
        <a href="#" class="text-muted mx-2"> Hỗ trợ</a><small> / </small>
        <a href="#" class="text-muted ms-2"> Liên hệ</a>
      </div>
    </div>
    <div
      class="col-lg-4 text-center d-flex align-items-center justify-content-center"
    >
      <small class="text-dark">Gọi chúng tôi:</small>
      <a href="#" class="text-muted">(+012) 1234 567890</a>
    </div>
    <div class="col-lg-4 text-center text-lg-end">
      <div class="d-inline-flex align-items-center" style="height: 45px">
        <div class="dropdown">
          <a
            href="#"
            class="dropdown-toggle text-muted me-2"
            data-bs-toggle="dropdown"
            ><small> VND</small></a
          >
          <div class="dropdown-menu rounded">
            <a href="#" class="dropdown-item"> USD</a>
            <a href="#" class="dropdown-item"> Euro</a>
          </div>
        </div>
        <div class="dropdown">
          <a
            href="#"
            class="dropdown-toggle text-muted mx-2"
            data-bs-toggle="dropdown"
            ><small> English</small></a
          >
          <div class="dropdown-menu rounded">
            <a href="#" class="dropdown-item"> English</a>
            <a href="#" class="dropdown-item"> Turkish</a>
            <a href="#" class="dropdown-item"> Spanol</a>
            <a href="#" class="dropdown-item"> Italiano</a>
          </div>
        </div>
        <c:choose>
          <c:when test="${not empty sessionScope.user}">
            <a
              href="<%= request.getContextPath() %>/profile"
              class="btn btn-outline-info btn-sm px-3 me-2"
              ><i class="bi bi-person me-1"></i>Tài khoản</a
            >
            <a
              href="#"
              class="btn btn-outline-danger btn-sm px-3"
              onclick="logout()"
              ><i class="bi bi-box-arrow-right me-1"></i>Đăng xuất</a
            >
          </c:when>
          <c:otherwise>
            <a
              href="<%= request.getContextPath() %>/login"
              class="btn btn-outline-primary btn-sm px-3 me-2"
              ><i class="bi bi-person me-1"></i>Đăng nhập</a
            >
            <a
              href="<%= request.getContextPath() %>/register"
              class="btn btn-outline-success btn-sm px-3"
              ><i class="bi bi-person-plus me-1"></i>Đăng ký</a
            >
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>
</div>
<!-- Topbar End -->

<!-- Logo & Search Bar Start -->
<div class="container-fluid px-5 py-4 d-none d-lg-block">
  <div class="row gx-0 align-items-center text-center">
    <div class="col-md-4 col-lg-3 text-center text-lg-start">
      <div class="d-inline-flex align-items-center">
        <a href="<%= request.getContextPath() %>/home" class="navbar-brand p-0">
          <h1 class="display-5 text-primary m-0">
            <i class="fas fa-shopping-bag text-secondary me-2"></i>Gicungco
          </h1>
        </a>
      </div>
    </div>
    <div class="col-md-4 col-lg-6 text-center">
      <div class="position-relative ps-4">
        <div class="d-flex border rounded-pill">
          <input
            class="form-control border-0 rounded-pill w-100 py-3"
            type="text"
            data-bs-target="#dropdownToggle123"
            placeholder="Tìm kiếm sản phẩm?"
          />
          <select
            class="form-select text-dark border-0 border-start rounded-0 p-3"
            style="width: 200px"
          >
            <option value="All Category">Tất cả danh mục</option>
            <option value="Pest Control-2">Danh mục 1</option>
            <option value="Pest Control-3">Danh mục 2</option>
            <option value="Pest Control-4">Danh mục 3</option>
            <option value="Pest Control-5">Danh mục 4</option>
          </select>
          <button
            type="button"
            class="btn btn-primary rounded-pill py-3 px-5"
            style="border: 0"
          >
            <i class="fas fa-search"></i>
          </button>
        </div>
      </div>
    </div>
    <div class="col-md-4 col-lg-3 text-center text-lg-end">
      <div class="d-inline-flex align-items-center">
        <a
          href="#"
          class="text-muted d-flex align-items-center justify-content-center me-3"
          ><span class="rounded-circle btn-md-square border"
            ><i class="fas fa-random"></i></span
        ></a>
        <a
          href="#"
          class="text-muted d-flex align-items-center justify-content-center me-3"
          ><span class="rounded-circle btn-md-square border"
            ><i class="fas fa-heart"></i></span
        ></a>
      </div>
    </div>
  </div>
</div>
<!-- Logo & Search Bar End -->

<!-- Navbar Start -->
<div class="container-fluid nav-bar p-0">
  <div class="row gx-0 bg-primary px-5 align-items-center">
    <div class="col-lg-3 d-none d-lg-block">
      <nav class="navbar navbar-light position-relative" style="width: 250px">
        <button
          class="navbar-toggler border-0 fs-4 w-100 px-0 text-start"
          type="button"
          data-bs-toggle="collapse"
          data-bs-target="#allCat"
        >
          <h4 class="m-0"><i class="fa fa-bars me-2"></i>Tất cả danh mục</h4>
        </button>
        <div class="collapse navbar-collapse rounded-bottom" id="allCat">
          <div class="navbar-nav ms-auto py-0">
            <ul class="list-unstyled categories-bars">
              <li>
                <div class="categories-bars-item">
                  <a href="<%= request.getContextPath() %>/products?category=1"
                    ><i class="fas fa-graduation-cap me-2"></i>Học tập</a
                  ><span>(1,250)</span>
                </div>
              </li>
              <li>
                <div class="categories-bars-item">
                  <a href="<%= request.getContextPath() %>/products?category=2"
                    ><i class="fas fa-play-circle me-2"></i>Xem phim</a
                  ><span>(850)</span>
                </div>
              </li>
              <li>
                <div class="categories-bars-item">
                  <a href="<%= request.getContextPath() %>/products?category=3"
                    ><i class="fas fa-laptop-code me-2"></i>Phần mềm</a
                  ><span>(2,100)</span>
                </div>
              </li>
              <li>
                <div class="categories-bars-item">
                  <a href="<%= request.getContextPath() %>/products?category=4"
                    ><i class="fas fa-file-alt me-2"></i>Tài liệu</a
                  ><span>(680)</span>
                </div>
              </li>
              <li>
                <div class="categories-bars-item">
                  <a href="<%= request.getContextPath() %>/products?category=5"
                    ><i class="fas fa-gift me-2"></i>Thẻ cào</a
                  ><span>(1,500)</span>
                </div>
              </li>
              <li>
                <div class="categories-bars-item">
                  <a href="<%= request.getContextPath() %>/products?category=6"
                    ><i class="fas fa-user-circle me-2"></i>Tài khoản Game</a
                  ><span>(2,300)</span>
                </div>
              </li>
            </ul>
          </div>
        </div>
      </nav>
    </div>
    <div class="col-12 col-lg-9">
      <nav class="navbar navbar-expand-lg navbar-light bg-primary">
        <a
          href="<%= request.getContextPath() %>/home"
          class="navbar-brand d-block d-lg-none"
        >
          <h1 class="display-5 text-secondary m-0">
            <i class="fas fa-shopping-bag text-white me-2"></i>Gicungco
          </h1>
        </a>
        <button
          class="navbar-toggler ms-auto"
          type="button"
          data-bs-toggle="collapse"
          data-bs-target="#navbarCollapse"
        >
          <span class="fa fa-bars fa-1x"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarCollapse">
          <div class="navbar-nav ms-auto py-0">
            <a
              href="<%= request.getContextPath() %>/home"
              class="nav-item nav-link"
              >Trang chủ</a
            >
            <a
              href="<%= request.getContextPath() %>/products"
              class="nav-item nav-link"
              >Cửa hàng</a
            >
            <div class="nav-item dropdown">
              <a
                href="#"
                class="nav-link dropdown-toggle"
                data-bs-toggle="dropdown"
                >Danh mục</a
              >
              <div class="dropdown-menu m-0">
                <a
                  href="<%= request.getContextPath() %>/products?category=1"
                  class="dropdown-item"
                  ><i class="fas fa-graduation-cap me-2"></i>Học tập</a
                >
                <a
                  href="<%= request.getContextPath() %>/products?category=2"
                  class="dropdown-item"
                  ><i class="fas fa-play-circle me-2"></i>Xem phim</a
                >
                <a
                  href="<%= request.getContextPath() %>/products?category=3"
                  class="dropdown-item"
                  ><i class="fas fa-laptop-code me-2"></i>Phần mềm</a
                >
                <a
                  href="<%= request.getContextPath() %>/products?category=4"
                  class="dropdown-item"
                  ><i class="fas fa-file-alt me-2"></i>Tài liệu</a
                >
                <a
                  href="<%= request.getContextPath() %>/products?category=5"
                  class="dropdown-item"
                  ><i class="fas fa-gift me-2"></i>Thẻ cào</a
                >
                <a
                  href="<%= request.getContextPath() %>/products?category=6"
                  class="dropdown-item"
                  ><i class="fas fa-user-circle me-2"></i>Tài khoản Game</a
                >
              </div>
            </div>
            <a href="#" class="nav-item nav-link">Tin tức</a>
            <a href="#" class="nav-item nav-link">Chia sẻ</a>
            <a
              href="<%= request.getContextPath() %>/contact"
              class="nav-item nav-link me-2"
              >Hỗ trợ</a
            >
            <div class="nav-item dropdown d-block d-lg-none mb-3">
              <a
                href="#"
                class="nav-link dropdown-toggle"
                data-bs-toggle="dropdown"
                >Tất cả danh mục</a
              >
              <div class="dropdown-menu m-0">
                <ul class="list-unstyled categories-bars">
                  <li>
                    <div class="categories-bars-item">
                      <a
                        href="<%= request.getContextPath() %>/products?category=1"
                        ><i class="fas fa-graduation-cap me-2"></i>Học tập</a
                      ><span>(1,250)</span>
                    </div>
                  </li>
                  <li>
                    <div class="categories-bars-item">
                      <a
                        href="<%= request.getContextPath() %>/products?category=2"
                        ><i class="fas fa-play-circle me-2"></i>Xem phim</a
                      ><span>(850)</span>
                    </div>
                  </li>
                  <li>
                    <div class="categories-bars-item">
                      <a
                        href="<%= request.getContextPath() %>/products?category=3"
                        ><i class="fas fa-laptop-code me-2"></i>Phần mềm</a
                      ><span>(2,100)</span>
                    </div>
                  </li>
                  <li>
                    <div class="categories-bars-item">
                      <a
                        href="<%= request.getContextPath() %>/products?category=4"
                        ><i class="fas fa-file-alt me-2"></i>Tài liệu</a
                      ><span>(680)</span>
                    </div>
                  </li>
                  <li>
                    <div class="categories-bars-item">
                      <a
                        href="<%= request.getContextPath() %>/products?category=5"
                        ><i class="fas fa-gift me-2"></i>Thẻ cào</a
                      ><span>(1,500)</span>
                    </div>
                  </li>
                  <li>
                    <div class="categories-bars-item">
                      <a
                        href="<%= request.getContextPath() %>/products?category=6"
                        ><i class="fas fa-user-circle me-2"></i>Tài khoản
                        Game</a
                      ><span>(2,300)</span>
                    </div>
                  </li>
                </ul>
              </div>
            </div>
          </div>
          <a
            href=""
            class="btn btn-secondary rounded-pill py-2 px-4 px-lg-3 mb-3 mb-md-3 mb-lg-0"
            ><i class="fa fa-mobile-alt me-2"></i> +0123 456 7890</a
          >
        </div>
      </nav>
    </div>
  </div>
</div>
<!-- Navbar End -->

<script>
  function logout() {
    if (confirm("Bạn có chắc chắn muốn đăng xuất?")) {
      // Direct redirect to logout endpoint
      window.location.href = "<%= request.getContextPath() %>/logout";
    }
  }
</script>
