<%@page contentType="text/html" pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>Electro - Electronics Website Template</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <meta content="" name="keywords" />
    <meta content="" name="description" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500;600;700&family=Roboto:wght@400;500;700&display=swap"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="https://use.fontawesome.com/releases/v5.15.4/css/all.css"
    />
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css"
      rel="stylesheet"
    />
    <link
      href="<%= request.getContextPath() %>/views/assets/electro/lib/animate/animate.min.css"
      rel="stylesheet"
    />
    <link
      href="<%= request.getContextPath() %>/views/assets/electro/lib/owlcarousel/assets/owl.carousel.min.css"
      rel="stylesheet"
    />
    <link
      href="<%= request.getContextPath() %>/views/assets/electro/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      href="<%= request.getContextPath() %>/views/assets/electro/css/style.css"
      rel="stylesheet"
    />
    <style>
      /* Orange Theme Override */
      .bg-primary {
        background: linear-gradient(135deg, #ff6b35, #f7931e) !important;
      }
      .btn-primary {
        background: linear-gradient(135deg, #ff6b35, #f7931e) !important;
        border-color: #ff6b35 !important;
      }
      .btn-primary:hover {
        background: linear-gradient(135deg, #e55a2b, #e0841a) !important;
        border-color: #e55a2b !important;
      }
      .text-primary {
        color: #ff6b35 !important;
      }
      .border-primary {
        border-color: #ff6b35 !important;
      }
      .btn-outline-primary {
        color: #ff6b35 !important;
        border-color: #ff6b35 !important;
      }
      .btn-outline-primary:hover {
        background-color: #ff6b35 !important;
        border-color: #ff6b35 !important;
      }
      .navbar-nav .nav-link:hover {
        color: #ff6b35 !important;
      }
      .category-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 25px rgba(255, 107, 53, 0.3);
      }
      .product-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 25px rgba(255, 107, 53, 0.3);
      }
    </style>

    <!-- Custom Styles for Digital Resources -->
    <style>
      .category-card {
        transition: all 0.3s ease;
        cursor: pointer;
      }
      .category-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1) !important;
      }
      .product-card {
        transition: all 0.3s ease;
        border: 1px solid #e9ecef;
      }
      .product-card:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1) !important;
      }
      .product-image {
        border-radius: 0.5rem 0.5rem 0 0;
      }
      .banner-content h1 {
        background: linear-gradient(45deg, #fff, #e3f2fd);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
      }
      .badge {
        font-size: 0.75rem;
        padding: 0.5rem 0.75rem;
      }
      .btn-success {
        background: linear-gradient(45deg, #28a745, #20c997);
        border: none;
      }
      .btn-success:hover {
        background: linear-gradient(45deg, #218838, #1ea085);
        transform: translateY(-1px);
      }
    </style>
  </head>
  <body>
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
    <div class="container-fluid px-5 py-4 d-none d-lg-block">
      <div class="row gx-0 align-items-center text-center">
        <div class="col-md-4 col-lg-3 text-center text-lg-start">
          <div class="d-inline-flex align-items-center">
            <a
              href="<%= request.getContextPath() %>/home"
              class="navbar-brand p-0"
            >
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
    <div class="container-fluid nav-bar p-0">
      <div
        class="row gx-0 px-5 align-items-center"
        style="background: linear-gradient(135deg, #ff6b35, #f7931e)"
      >
        <div class="col-lg-3 d-none d-lg-block">
          <nav
            class="navbar navbar-light position-relative"
            style="width: 250px"
          >
            <button
              class="navbar-toggler border-0 fs-4 w-100 px-0 text-start"
              type="button"
              data-bs-toggle="collapse"
              data-bs-target="#allCat"
            >
              <h4 class="m-0">
                <i class="fa fa-bars me-2"></i>Tất cả danh mục
              </h4>
            </button>
            <div class="collapse navbar-collapse rounded-bottom" id="allCat">
              <div class="navbar-nav ms-auto py-0">
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
                        ><i class="fas fa-gamepad me-2"></i>Tài khoản Game</a
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
                  class="nav-item nav-link active"
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
                      ><i class="fas fa-gamepad me-2"></i>Tài khoản Game</a
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
                            ><i class="fas fa-graduation-cap me-2"></i>Học
                            tập</a
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
                            ><i class="fas fa-gamepad me-2"></i>Tài khoản
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
    <!-- Main Banner Section -->
    <div class="container-fluid bg-primary text-white py-5">
      <div class="container">
        <div class="row align-items-center">
          <div class="col-lg-8">
            <div class="banner-content">
              <h1 class="display-4 fw-bold mb-4">Tài Nguyên Online</h1>
              <h2 class="h3 mb-4">
                Thẻ cào, Tài khoản, Phần mềm & Nhiều hơn nữa
              </h2>
              <p class="lead mb-4">
                Khám phá hàng nghìn tài nguyên digital chất lượng cao với giá
                tốt nhất thị trường
              </p>
              <div class="d-flex gap-3">
                <a
                  href="<%= request.getContextPath() %>/products"
                  class="btn btn-light btn-lg px-4"
                >
                  <i class="fas fa-shopping-bag me-2"></i>Mua ngay
                </a>
                <a href="#categories" class="btn btn-outline-light btn-lg px-4">
                  <i class="fas fa-th-large me-2"></i>Xem danh mục
                </a>
              </div>
            </div>
          </div>
          <div class="col-lg-4">
            <div class="banner-image text-center">
              <i class="fas fa-download display-1 text-white-50"></i>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Featured Categories Section -->
    <div class="container-fluid py-5 bg-light" id="categories">
      <div class="container">
        <div class="text-center mb-5">
          <h2 class="display-5 fw-bold text-dark">DANH MỤC NỔI BẬT</h2>
          <p class="lead text-muted">
            Khám phá các loại tài nguyên digital phổ biến nhất
          </p>
        </div>
        <div class="row g-4">
          <div class="col-lg-2 col-md-4 col-6">
            <a
              href="<%= request.getContextPath() %>/products?category=1"
              class="text-decoration-none"
            >
              <div
                class="category-card text-center p-4 bg-white rounded-3 shadow-sm h-100"
              >
                <div class="category-icon mb-3">
                  <i class="fas fa-graduation-cap fa-3x text-primary"></i>
                </div>
                <h5 class="fw-bold text-dark">Học tập</h5>
                <p class="text-muted small">Khóa học, tài liệu, ebook</p>
                <span class="badge bg-primary">1,250+ sản phẩm</span>
              </div>
            </a>
          </div>
          <div class="col-lg-2 col-md-4 col-6">
            <a
              href="<%= request.getContextPath() %>/products?category=2"
              class="text-decoration-none"
            >
              <div
                class="category-card text-center p-4 bg-white rounded-3 shadow-sm h-100"
              >
                <div class="category-icon mb-3">
                  <i class="fas fa-play-circle fa-3x text-danger"></i>
                </div>
                <h5 class="fw-bold text-dark">Xem phim</h5>
                <p class="text-muted small">Netflix, Disney+, HBO</p>
                <span class="badge bg-danger">850+ sản phẩm</span>
              </div>
            </a>
          </div>
          <div class="col-lg-2 col-md-4 col-6">
            <a
              href="<%= request.getContextPath() %>/products?category=3"
              class="text-decoration-none"
            >
              <div
                class="category-card text-center p-4 bg-white rounded-3 shadow-sm h-100"
              >
                <div class="category-icon mb-3">
                  <i class="fas fa-laptop-code fa-3x text-success"></i>
                </div>
                <h5 class="fw-bold text-dark">Phần mềm</h5>
                <p class="text-muted small">Adobe, Office, Antivirus</p>
                <span class="badge bg-success">2,100+ sản phẩm</span>
              </div>
            </a>
          </div>
          <div class="col-lg-2 col-md-4 col-6">
            <a
              href="<%= request.getContextPath() %>/products?category=4"
              class="text-decoration-none"
            >
              <div
                class="category-card text-center p-4 bg-white rounded-3 shadow-sm h-100"
              >
                <div class="category-icon mb-3">
                  <i class="fas fa-file-alt fa-3x text-warning"></i>
                </div>
                <h5 class="fw-bold text-dark">Tài liệu</h5>
                <p class="text-muted small">Template, báo cáo, CV</p>
                <span class="badge bg-warning">680+ sản phẩm</span>
              </div>
            </a>
          </div>
          <div class="col-lg-2 col-md-4 col-6">
            <a
              href="<%= request.getContextPath() %>/products?category=5"
              class="text-decoration-none"
            >
              <div
                class="category-card text-center p-4 bg-white rounded-3 shadow-sm h-100"
              >
                <div class="category-icon mb-3">
                  <i class="fas fa-gift fa-3x text-primary"></i>
                </div>
                <h5 class="fw-bold text-dark">Thẻ cào</h5>
                <p class="text-muted small">Viettel, Mobi, Vina</p>
                <span class="badge bg-primary">1,500+ sản phẩm</span>
              </div>
            </a>
          </div>
          <div class="col-lg-2 col-md-4 col-6">
            <a
              href="<%= request.getContextPath() %>/products?category=6"
              class="text-decoration-none"
            >
              <div
                class="category-card text-center p-4 bg-white rounded-3 shadow-sm h-100"
              >
                <div class="category-icon mb-3">
                  <i class="fas fa-gamepad fa-3x text-info"></i>
                </div>
                <h5 class="fw-bold text-dark">Tài khoản Game</h5>
                <p class="text-muted small">LOL, PUBG, Valorant</p>
                <span class="badge bg-info">2,300+ sản phẩm</span>
              </div>
            </a>
          </div>
        </div>
      </div>
    </div>

    <!-- Featured Products Section -->
    <div class="container-fluid py-5">
      <div class="container">
        <div class="text-center mb-5">
          <h2 class="display-5 fw-bold text-dark">SẢN PHẨM NỔI BẬT</h2>
          <p class="lead text-muted">
            Những tài nguyên digital được yêu thích nhất
          </p>
        </div>

        <!-- Search Bar -->
        <div class="row justify-content-center mb-5">
          <div class="col-lg-8">
            <div class="input-group input-group-lg">
              <input
                type="search"
                class="form-control"
                placeholder="Tìm kiếm tài nguyên digital..."
                id="searchInput"
              />
              <select class="form-select" style="max-width: 200px">
                <option value="">Tất cả danh mục</option>
                <option value="learning">Học tập</option>
                <option value="entertainment">Xem phim</option>
                <option value="software">Phần mềm</option>
                <option value="documents">Tài liệu</option>
                <option value="other">Khác</option>
              </select>
              <button class="btn btn-primary" type="button">
                <i class="fas fa-search"></i>
              </button>
            </div>
          </div>
        </div>

        <!-- Product Grid -->
        <div class="row g-4" id="productGrid">
          <!-- Digital Product 1 -->
          <div class="col-lg-3 col-md-6">
            <div class="product-card h-100 bg-white rounded-3 shadow-sm">
              <div class="position-relative">
                <div
                  class="product-image bg-primary text-white text-center py-5"
                >
                  <i class="fas fa-gift fa-4x"></i>
                </div>
                <div class="position-absolute top-0 end-0 p-2">
                  <button class="btn btn-sm btn-light rounded-circle">
                    <i class="fas fa-heart"></i>
                  </button>
                </div>
                <div class="position-absolute top-0 start-0 p-2">
                  <span class="badge bg-success">Digital</span>
                </div>
              </div>
              <div class="card-body d-flex flex-column">
                <h6 class="card-title fw-bold">Thẻ cào Viettel 100K</h6>
                <p class="text-muted small">Thẻ nạp điện thoại Viettel</p>
                <div class="d-flex align-items-center mb-2">
                  <div class="text-warning me-2">
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                  </div>
                  <small class="text-muted">(1,250)</small>
                </div>
                <div
                  class="d-flex align-items-center justify-content-between mb-3"
                >
                  <div>
                    <span class="h5 text-primary mb-0">95,000₫</span>
                    <small class="text-success d-block"
                      ><i class="fas fa-bolt"></i> Giao tức thì</small
                    >
                  </div>
                </div>
                <button
                  class="btn btn-success w-100 mt-auto"
                  onclick="viewProduct(1)"
                >
                  <i class="fas fa-download me-1"></i> Mua ngay
                </button>
              </div>
            </div>
          </div>

          <!-- Digital Product 2 -->
          <div class="col-lg-3 col-md-6">
            <div class="product-card h-100 bg-white rounded-3 shadow-sm">
              <div class="position-relative">
                <div
                  class="product-image bg-danger text-white text-center py-5"
                >
                  <i class="fas fa-play-circle fa-4x"></i>
                </div>
                <div class="position-absolute top-0 end-0 p-2">
                  <button class="btn btn-sm btn-light rounded-circle">
                    <i class="fas fa-heart"></i>
                  </button>
                </div>
                <div class="position-absolute top-0 start-0 p-2">
                  <span class="badge bg-warning">Hot</span>
                </div>
              </div>
              <div class="card-body d-flex flex-column">
                <h6 class="card-title fw-bold">Netflix Premium 1 tháng</h6>
                <p class="text-muted small">Tài khoản Netflix Premium</p>
                <div class="d-flex align-items-center mb-2">
                  <div class="text-warning me-2">
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="far fa-star"></i>
                  </div>
                  <small class="text-muted">(890)</small>
                </div>
                <div
                  class="d-flex align-items-center justify-content-between mb-3"
                >
                  <div>
                    <span class="h5 text-primary mb-0">150,000₫</span>
                    <small class="text-success d-block"
                      ><i class="fas fa-bolt"></i> Giao tức thì</small
                    >
                  </div>
                </div>
                <button
                  class="btn btn-success w-100 mt-auto"
                  onclick="viewProduct(2)"
                >
                  <i class="fas fa-download me-1"></i> Mua ngay
                </button>
              </div>
            </div>
          </div>

          <!-- Digital Product 3 -->
          <div class="col-lg-3 col-md-6">
            <div class="product-card h-100 bg-white rounded-3 shadow-sm">
              <div class="position-relative">
                <div
                  class="product-image bg-success text-white text-center py-5"
                >
                  <i class="fas fa-laptop-code fa-4x"></i>
                </div>
                <div class="position-absolute top-0 end-0 p-2">
                  <button class="btn btn-sm btn-light rounded-circle">
                    <i class="fas fa-heart"></i>
                  </button>
                </div>
                <div class="position-absolute top-0 start-0 p-2">
                  <span class="badge bg-info">Mới</span>
                </div>
              </div>
              <div class="card-body d-flex flex-column">
                <h6 class="card-title fw-bold">Adobe Creative Cloud</h6>
                <p class="text-muted small">Bộ công cụ Adobe đầy đủ</p>
                <div class="d-flex align-items-center mb-2">
                  <div class="text-warning me-2">
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                  </div>
                  <small class="text-muted">(2,100)</small>
                </div>
                <div
                  class="d-flex align-items-center justify-content-between mb-3"
                >
                  <div>
                    <span class="h5 text-primary mb-0">850,000₫</span>
                    <small class="text-success d-block"
                      ><i class="fas fa-bolt"></i> Giao tức thì</small
                    >
                  </div>
                </div>
                <button
                  class="btn btn-success w-100 mt-auto"
                  onclick="viewProduct(3)"
                >
                  <i class="fas fa-download me-1"></i> Mua ngay
                </button>
              </div>
            </div>
          </div>

          <!-- Digital Product 4 -->
          <div class="col-lg-3 col-md-6">
            <div class="product-card h-100 bg-white rounded-3 shadow-sm">
              <div class="position-relative">
                <div
                  class="product-image bg-warning text-white text-center py-5"
                >
                  <i class="fas fa-file-alt fa-4x"></i>
                </div>
                <div class="position-absolute top-0 end-0 p-2">
                  <button class="btn btn-sm btn-light rounded-circle">
                    <i class="fas fa-heart"></i>
                  </button>
                </div>
                <div class="position-absolute top-0 start-0 p-2">
                  <span class="badge bg-primary">Best</span>
                </div>
              </div>
              <div class="card-body d-flex flex-column">
                <h6 class="card-title fw-bold">Template PowerPoint Pro</h6>
                <p class="text-muted small">500+ template chuyên nghiệp</p>
                <div class="d-flex align-items-center mb-2">
                  <div class="text-warning me-2">
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="far fa-star"></i>
                  </div>
                  <small class="text-muted">(680)</small>
                </div>
                <div
                  class="d-flex align-items-center justify-content-between mb-3"
                >
                  <div>
                    <span class="h5 text-primary mb-0">250,000₫</span>
                    <small class="text-success d-block"
                      ><i class="fas fa-bolt"></i> Giao tức thì</small
                    >
                  </div>
                </div>
                <button
                  class="btn btn-success w-100 mt-auto"
                  onclick="viewProduct(4)"
                >
                  <i class="fas fa-download me-1"></i> Mua ngay
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- Load More Button -->
        <div class="text-center mt-5">
          <button
            class="btn btn-outline-primary px-5 py-3"
            onclick="loadMoreProducts()"
          >
            <i class="fas fa-plus me-2"></i> Xem thêm sản phẩm
          </button>
        </div>
      </div>
    </div>

    <!-- Enhanced Footer -->
    <div class="container-fluid bg-dark text-white-50 footer pt-5 mt-5">
      <div class="container py-5">
        <div class="row g-5">
          <div class="col-lg-3 col-md-6">
            <h5 class="text-white text-uppercase mb-4">Gicungco Marketplace</h5>
            <p class="mb-4">
              Nền tảng thương mại điện tử hàng đầu Việt Nam, kết nối người mua
              và người bán một cách an toàn và tiện lợi.
            </p>
            <div class="d-flex pt-2">
              <a class="btn btn-outline-light btn-social" href=""
                ><i class="fab fa-twitter"></i
              ></a>
              <a class="btn btn-outline-light btn-social" href=""
                ><i class="fab fa-facebook-f"></i
              ></a>
              <a class="btn btn-outline-light btn-social" href=""
                ><i class="fab fa-youtube"></i
              ></a>
              <a class="btn btn-outline-light btn-social" href=""
                ><i class="fab fa-linkedin-in"></i
              ></a>
            </div>
          </div>
          <div class="col-lg-3 col-md-6">
            <h5 class="text-white text-uppercase mb-4">Dịch vụ</h5>
            <div class="d-flex flex-column justify-content-start">
              <a
                class="text-white-50 mb-2"
                href="<%= request.getContextPath() %>/products"
                ><i class="fa fa-angle-right me-2"></i>Danh mục sản phẩm</a
              >
              <a class="text-white-50 mb-2" href="#"
                ><i class="fa fa-angle-right me-2"></i>Khuyến mãi</a
              >
              <a class="text-white-50 mb-2" href="#"
                ><i class="fa fa-angle-right me-2"></i>Hỗ trợ khách hàng</a
              >
              <a class="text-white-50 mb-2" href="#"
                ><i class="fa fa-angle-right me-2"></i>Chương trình thành
                viên</a
              >
            </div>
          </div>
          <div class="col-lg-3 col-md-6">
            <h5 class="text-white text-uppercase mb-4">Hỗ trợ & FAQ</h5>
            <div class="d-flex flex-column justify-content-start">
              <a class="text-white-50 mb-2" href="#"
                ><i class="fa fa-angle-right me-2"></i>Trung tâm trợ giúp</a
              >
              <a class="text-white-50 mb-2" href="#"
                ><i class="fa fa-angle-right me-2"></i>Câu hỏi thường gặp</a
              >
              <a class="text-white-50 mb-2" href="#"
                ><i class="fa fa-angle-right me-2"></i>Hướng dẫn mua hàng</a
              >
              <a class="text-white-50 mb-2" href="#"
                ><i class="fa fa-angle-right me-2"></i>Chính sách đổi trả</a
              >
            </div>
          </div>
          <div class="col-lg-3 col-md-6">
            <h5 class="text-white text-uppercase mb-4">Chính sách</h5>
            <div class="d-flex flex-column justify-content-start">
              <a class="text-white-50 mb-2" href="#"
                ><i class="fa fa-angle-right me-2"></i>Chính sách bảo mật</a
              >
              <a class="text-white-50 mb-2" href="#"
                ><i class="fa fa-angle-right me-2"></i>Điều khoản sử dụng</a
              >
              <a class="text-white-50 mb-2" href="#"
                ><i class="fa fa-angle-right me-2"></i>Chính sách vận chuyển</a
              >
              <a class="text-white-50 mb-2" href="#"
                ><i class="fa fa-angle-right me-2"></i>Chính sách thanh toán</a
              >
            </div>
          </div>
        </div>
      </div>
      <div class="container">
        <div class="copyright">
          <div class="row">
            <div class="col-md-6 text-center text-md-start mb-3 mb-md-0">
              &copy; <a class="border-bottom" href="#">Gicungco Marketplace</a>,
              Tất cả quyền được bảo lưu.
            </div>
            <div class="col-md-6 text-center text-md-end">
              <div class="footer-menu">
                <a href="<%= request.getContextPath() %>/home">Trang chủ</a>
                <a href="#">Chính sách Cookie</a>
                <a href="#">Trợ giúp</a>
                <a href="#">Liên hệ</a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Back to Top -->
    <a href="#" class="btn btn-primary btn-lg-square back-to-top"
      ><i class="bi bi-arrow-up"></i
    ></a>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<%= request.getContextPath() %>/views/assets/electro/lib/wow/wow.min.js"></script>
    <script src="<%= request.getContextPath() %>/views/assets/electro/lib/easing/easing.min.js"></script>
    <script src="<%= request.getContextPath() %>/views/assets/electro/lib/waypoints/waypoints.min.js"></script>
    <script src="<%= request.getContextPath() %>/views/assets/electro/lib/counterup/counterup.min.js"></script>
    <script src="<%= request.getContextPath() %>/views/assets/electro/lib/owlcarousel/owl.carousel.min.js"></script>
    <script src="<%= request.getContextPath() %>/views/assets/electro/js/main.js"></script>

    <!-- Logout Function -->
    <script>
      function logout() {
        if (confirm("Bạn có chắc chắn muốn đăng xuất?")) {
          // Direct redirect to logout endpoint
          window.location.href = "<%= request.getContextPath() %>/logout";
        }
      }

      function updateLogoutUI() {
        // Update top bar to show login/register buttons
        const topBarUserSection = document.querySelector(
          ".col-lg-4.text-center.text-lg-end .d-inline-flex"
        );
        if (topBarUserSection) {
          // Remove account and logout buttons
          const accountBtn = topBarUserSection.querySelector(
            'a[href*="/profile"]'
          );
          const logoutBtn = topBarUserSection.querySelector(
            'a[onclick="logout()"]'
          );
          if (accountBtn) accountBtn.remove();
          if (logoutBtn) logoutBtn.remove();

          // Add login/register buttons
          const loginBtn = document.createElement("a");
          loginBtn.href = "<%= request.getContextPath() %>/login";
          loginBtn.className = "btn btn-outline-primary btn-sm px-3 me-2";
          loginBtn.innerHTML = '<i class="bi bi-person me-1"></i>Đăng nhập';

          const registerBtn = document.createElement("a");
          registerBtn.href = "<%= request.getContextPath() %>/register";
          registerBtn.className = "btn btn-outline-success btn-sm px-3";
          registerBtn.innerHTML =
            '<i class="bi bi-person-plus me-1"></i>Đăng ký';

          topBarUserSection.appendChild(loginBtn);
          topBarUserSection.appendChild(registerBtn);
        }

        // Update navbar to show login/register buttons
        const navbarUserSection = document.querySelector(".navbar-nav.ms-auto");
        if (navbarUserSection) {
          // Remove account and logout links
          const accountLink = navbarUserSection.querySelector(
            'a[href*="/profile"]'
          );
          const logoutLink = navbarUserSection.querySelector(
            'a[onclick="logout()"]'
          );
          if (accountLink) accountLink.remove();
          if (logoutLink) logoutLink.remove();

          // Add login/register links
          const loginLink = document.createElement("a");
          loginLink.href = "<%= request.getContextPath() %>/login";
          loginLink.className = "nav-item nav-link me-2";
          loginLink.innerHTML = '<i class="bi bi-person me-1"></i>Đăng nhập';

          const registerLink = document.createElement("a");
          registerLink.href = "<%= request.getContextPath() %>/register";
          registerLink.className = "nav-item nav-link me-2";
          registerLink.innerHTML =
            '<i class="bi bi-person-plus me-1"></i>Đăng ký';

          // Insert before the mobile categories dropdown
          const mobileDropdown = navbarUserSection.querySelector(
            ".nav-item.dropdown.d-block.d-lg-none"
          );
          if (mobileDropdown) {
            navbarUserSection.insertBefore(loginLink, mobileDropdown);
            navbarUserSection.insertBefore(registerLink, mobileDropdown);
          } else {
            navbarUserSection.appendChild(loginLink);
            navbarUserSection.appendChild(registerLink);
          }
        }
      }

      function showToast(message, type) {
        // Create toast element
        const toastContainer = document.createElement("div");
        toastContainer.className = "position-fixed top-0 end-0 p-3";
        toastContainer.style.zIndex = "1080";
        document.body.appendChild(toastContainer);

        const toastId = "toast-" + Date.now();
        const bgClass = type === "success" ? "bg-success" : "bg-danger";

        const toastHtml =
          '<div id="' +
          toastId +
          '" class="toast align-items-center text-white ' +
          bgClass +
          ' border-0" role="alert" aria-live="assertive" aria-atomic="true">' +
          '<div class="d-flex">' +
          '<div class="toast-body">' +
          message +
          "</div>" +
          '<button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>' +
          "</div>" +
          "</div>";

        toastContainer.innerHTML = toastHtml;

        // Show toast
        const toastElement = document.getElementById(toastId);
        const toast = new bootstrap.Toast(toastElement, { delay: 3000 });
        toast.show();

        // Remove toast element after it's hidden
        toastElement.addEventListener("hidden.bs.toast", function () {
          toastContainer.remove();
        });
      }
    </script>

    <!-- Enhanced Buyer Homepage JavaScript -->
    <script>
      // Search with AI autocomplete
      let searchTimeout;
      document
        .getElementById("searchInput")
        .addEventListener("input", function () {
          clearTimeout(searchTimeout);
          const query = this.value;

          if (query.length >= 2) {
            searchTimeout = setTimeout(() => {
              showSearchSuggestions(query);
            }, 300);
          } else {
            hideSearchSuggestions();
          }
        });

      function showSearchSuggestions(query) {
        const suggestions = [
          "iPhone 15 Pro Max",
          "MacBook Pro M3",
          "Samsung Galaxy S24",
          "AirPods Pro",
          "iPad Air",
          "Apple Watch",
        ].filter((item) => item.toLowerCase().includes(query.toLowerCase()));

        const aiSuggestions = document.getElementById("aiSuggestions");
        if (suggestions.length > 0) {
          let suggestionsHtml =
            '<p class="small mb-2">Gợi ý cho "' + query + '":</p>';
          suggestionsHtml += '<div class="d-flex flex-wrap gap-1">';
          suggestions.forEach(function (suggestion) {
            suggestionsHtml +=
              '<span class="badge bg-light text-dark me-1 mb-1" onclick="searchProduct(\'' +
              suggestion +
              "')\">" +
              suggestion +
              "</span>";
          });
          suggestionsHtml += "</div>";
          aiSuggestions.innerHTML = suggestionsHtml;
        }
      }

      function hideSearchSuggestions() {
        const aiSuggestions = document.getElementById("aiSuggestions");
        aiSuggestions.innerHTML =
          '<p class="small mb-2">Dựa trên lịch sử tìm kiếm của bạn:</p>' +
          '<div class="d-flex flex-wrap gap-1">' +
          '<span class="badge bg-light text-dark me-1 mb-1">iPhone 15</span>' +
          '<span class="badge bg-light text-dark me-1 mb-1">Laptop Gaming</span>' +
          '<span class="badge bg-light text-dark me-1 mb-1">Tai nghe</span>' +
          "</div>";
      }

      function searchProduct(query) {
        document.getElementById("searchInput").value = query;
        applyFilters();
      }

      // Filter and Sort Functions
      function applyFilters() {
        const category = document.getElementById("categoryFilter").value;
        const price = document.getElementById("priceFilter").value;
        const rating = document.getElementById("ratingFilter").value;
        const sort = document.getElementById("sortFilter").value;
        const search = document.getElementById("searchInput").value;

        const productGrid = document.getElementById("productGrid");
        productGrid.innerHTML =
          '<div class="col-12 text-center"><div class="spinner-border text-primary" role="status"><span class="sr-only">Đang tải...</span></div></div>';

        setTimeout(() => {
          loadFilteredProducts(category, price, rating, sort, search);
        }, 1000);
      }

      function clearFilters() {
        document.getElementById("categoryFilter").value = "";
        document.getElementById("priceFilter").value = "";
        document.getElementById("ratingFilter").value = "";
        document.getElementById("sortFilter").value = "";
        document.getElementById("searchInput").value = "";
        applyFilters();
      }

      function loadFilteredProducts(category, price, rating, sort, search) {
        const productGrid = document.getElementById("productGrid");
        productGrid.innerHTML = `
                    <div class="col-md-6 col-lg-4 col-xl-3">
                        <div class="product-card h-100">
                            <div class="position-relative">
                                <img src="<%= request.getContextPath() %>/views/assets/electro/img/product-1.png" class="card-img-top" alt="iPhone 15 Pro">
                                <div class="position-absolute top-0 end-0 p-2">
                                    <button class="btn btn-sm btn-light rounded-circle">
                                        <i class="fas fa-heart"></i>
                                    </button>
                                </div>
                                <div class="position-absolute top-0 start-0 p-2">
                                    <span class="badge bg-danger">-15%</span>
                                </div>
                            </div>
                            <div class="card-body d-flex flex-column">
                                <h6 class="card-title">iPhone 15 Pro Max 256GB</h6>
                                <div class="d-flex align-items-center mb-2">
                                    <div class="text-warning me-2">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                    </div>
                                    <small class="text-muted">(128)</small>
                                </div>
                                <div class="d-flex align-items-center justify-content-between mb-3">
                                    <div>
                                        <span class="h5 text-primary mb-0">28,500,000₫</span>
                                        <small class="text-muted d-block"><del>33,500,000₫</del></small>
                                    </div>
                                </div>
                                <button class="btn btn-primary w-100 mt-auto" onclick="viewProduct(1)">
                                    <i class="fas fa-eye me-1"></i> Chi tiết
                                </button>
                            </div>
                        </div>
            </div>
                `;
      }

      function viewMode(mode) {
        const productGrid = document.getElementById("productGrid");
        if (mode === "list") {
          productGrid.className = "row g-4 list-view";
        } else {
          productGrid.className = "row g-4";
        }
      }

      function viewProduct(productId) {
        window.location.href =
          "<%= request.getContextPath() %>/product/" + productId;
      }

      function loadMoreProducts() {
        const loadMoreBtn = event.target;
        loadMoreBtn.innerHTML =
          '<i class="fas fa-spinner fa-spin me-2"></i> Đang tải...';

        setTimeout(() => {
          loadMoreBtn.innerHTML =
            '<i class="fas fa-plus me-2"></i> Xem thêm sản phẩm';
        }, 2000);
      }

      // Initialize page
      document.addEventListener("DOMContentLoaded", function () {
        console.log("Gicungco Marketplace - Buyer Homepage Loaded");
      });
    </script>
  </body>
</html>
