<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Quản lý Blog - Gicungco</title>
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
      
      /* Blog Management Styles */
      .page-header {
        background: white;
        border-radius: 15px;
        padding: 2rem;
        margin: 2rem 0;
        box-shadow: 0 5px 20px rgba(0,0,0,0.1);
      }
      .stats-card {
        background: white;
        border-radius: 10px;
        padding: 1.5rem;
        text-align: center;
        box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        transition: transform 0.3s;
        height: 100%;
      }
      .stats-card:hover {
        transform: translateY(-5px);
      }
      .stats-number {
        font-size: 2rem;
        font-weight: bold;
        margin: 0.5rem 0;
      }
      .blog-card {
        background: white;
        border-radius: 10px;
        padding: 1.5rem;
        margin-bottom: 1rem;
        box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        transition: all 0.3s;
      }
      .blog-card:hover {
        box-shadow: 0 5px 20px rgba(0,0,0,0.15);
      }
      .status-badge {
        padding: 0.4rem 1rem;
        border-radius: 20px;
        font-size: 0.875rem;
        font-weight: 600;
      }
      .status-DRAFT {
        background: #6c757d;
        color: white;
      }
      .status-PENDING {
        background: #ffc107;
        color: #000;
      }
      .status-APPROVED {
        background: #28a745;
        color: white;
      }
      .status-REJECTED {
        background: #dc3545;
        color: white;
      }
      .btn-create {
        background: linear-gradient(135deg, #ff6b35, #f7931e);
        border: none;
        color: white;
        padding: 0.75rem 2rem;
        border-radius: 25px;
        font-weight: 600;
      }
      .btn-create:hover {
        background: linear-gradient(135deg, #e55a2b, #e0841a);
        color: white;
      }
      .filter-btn {
        border: 2px solid #e0e0e0;
        background: white;
        color: #333;
        padding: 0.5rem 1.5rem;
        border-radius: 25px;
        margin: 0 0.25rem 0.5rem;
        transition: all 0.3s;
        display: inline-block;
      }
      .filter-btn.active {
        background: linear-gradient(135deg, #ff6b35, #f7931e);
        color: white;
        border-color: #ff6b35;
      }
      .filter-btn:hover {
        border-color: #ff6b35;
      }
      
      /* Blog Preview Modal Styles */
      .blog-preview-content {
        line-height: 1.8;
        font-size: 1.1rem;
        color: #333;
      }
      .blog-preview-content h1,
      .blog-preview-content h2,
      .blog-preview-content h3,
      .blog-preview-content h4 {
        margin-top: 1.5rem;
        margin-bottom: 1rem;
        font-weight: 600;
      }
      .blog-preview-content h1 {
        font-size: 2rem;
        color: #ff6b35;
      }
      .blog-preview-content h2 {
        font-size: 1.75rem;
        color: #f7931e;
      }
      .blog-preview-content h3 {
        font-size: 1.5rem;
        color: #333;
      }
      .blog-preview-content p {
        margin-bottom: 1rem;
      }
      .blog-preview-content img {
        max-width: 100%;
        height: auto;
        border-radius: 10px;
        margin: 1.5rem 0;
      }
      .blog-preview-content ul,
      .blog-preview-content ol {
        margin-bottom: 1rem;
        padding-left: 2rem;
      }
      .blog-preview-content pre {
        background: #f4f4f4;
        padding: 1rem;
        border-radius: 5px;
        overflow-x: auto;
      }
      .blog-preview-content code {
        background: #f4f4f4;
        padding: 2px 6px;
        border-radius: 3px;
        font-family: monospace;
      }
      .blog-preview-content blockquote {
        border-left: 4px solid #ff6b35;
        padding-left: 1rem;
        margin: 1rem 0;
        color: #666;
        font-style: italic;
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
            <c:choose>
              <c:when test="${not empty sessionScope.user}">
                <a
                  href="<%= request.getContextPath() %>/notifications"
                  class="text-muted me-3 position-relative"
                  title="Thông báo"
                  style="text-decoration: none"
                >
                  <i class="bi bi-bell" style="font-size: 1.2rem"></i>
                </a>
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
                placeholder="Tìm kiếm sản phẩm?"
              />
              <select
                class="form-select text-dark border-0 border-start rounded-0 p-3"
                style="width: 200px"
              >
                <option value="All Category">Tất cả danh mục</option>
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
              href="<%= request.getContextPath() %>/wishlist"
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
                      <a href="<%= request.getContextPath() %>/products?category=1">
                        <i class="fas fa-graduation-cap me-2"></i>Học tập
                      </a>
                    </div>
                  </li>
                  <li>
                    <div class="categories-bars-item">
                      <a href="<%= request.getContextPath() %>/products?category=2">
                        <i class="fas fa-play-circle me-2"></i>Xem phim
                      </a>
                    </div>
                  </li>
                  <li>
                    <div class="categories-bars-item">
                      <a href="<%= request.getContextPath() %>/products?category=3">
                        <i class="fas fa-laptop-code me-2"></i>Phần mềm
                      </a>
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
                <a
                  href="<%= request.getContextPath() %>/blog"
                  class="nav-item nav-link"
                  >Tin tức</a
                >
                <c:if test="${not empty sessionScope.user}">
                  <a
                    href="<%= request.getContextPath() %>/user/my-blogs"
                    class="nav-item nav-link active"
                  >
                    <i class="fas fa-blog me-1"></i>Blog của tôi
                  </a>
                </c:if>
                <a href="#" class="nav-item nav-link">Chia sẻ</a>
                <a
                  href="<%= request.getContextPath() %>/contact"
                  class="nav-item nav-link"
                  >Hỗ trợ</a
                >
                <c:if test="${not empty sessionScope.user}">
                <a
                  href="<%= request.getContextPath() %>/wishlist"
                  class="nav-item nav-link me-2 position-relative"
                  title="Danh sách yêu thích"
                  >
                  <i class="fas fa-heart me-1"></i>Yêu thích
                </a>
                </c:if>
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

    <!-- Blog Management Section -->
    <div class="container-fluid py-5" style="background: #f8f9fa;">
        <div class="container">
        <!-- Page Header -->
        <div class="page-header">
                <div class="d-flex justify-content-between align-items-center flex-wrap">
                <div>
                    <h1 class="mb-1"><i class="fas fa-blog me-2 text-primary"></i>Quản lý Blog</h1>
                    <p class="text-muted mb-0">Quản lý các bài viết blog của bạn</p>
                </div>
                    <a href="${pageContext.request.contextPath}/user/blog-editor" class="btn btn-create mt-2 mt-md-0">
                    <i class="fas fa-plus me-2"></i>Tạo Blog Mới
                </a>
            </div>
        </div>

        <!-- Statistics -->
        <div class="row mb-4">
                <div class="col-md-3 col-sm-6 mb-3">
                <div class="stats-card">
                    <i class="fas fa-file-alt fa-2x text-secondary"></i>
                    <div class="stats-number text-secondary">${draftCount}</div>
                    <div class="text-muted">Bản nháp</div>
                </div>
            </div>
                <div class="col-md-3 col-sm-6 mb-3">
                <div class="stats-card">
                    <i class="fas fa-clock fa-2x text-warning"></i>
                    <div class="stats-number text-warning">${pendingCount}</div>
                    <div class="text-muted">Chờ duyệt</div>
                </div>
            </div>
                <div class="col-md-3 col-sm-6 mb-3">
                <div class="stats-card">
                    <i class="fas fa-check-circle fa-2x text-success"></i>
                    <div class="stats-number text-success">${approvedCount}</div>
                    <div class="text-muted">Đã duyệt</div>
                </div>
            </div>
                <div class="col-md-3 col-sm-6 mb-3">
                <div class="stats-card">
                    <i class="fas fa-times-circle fa-2x text-danger"></i>
                    <div class="stats-number text-danger">${rejectedCount}</div>
                    <div class="text-muted">Bị từ chối</div>
                </div>
            </div>
        </div>

        <!-- Filters -->
        <div class="bg-white rounded-3 p-3 mb-3 shadow-sm text-center">
            <button class="filter-btn ${empty statusFilter or statusFilter eq 'ALL' ? 'active' : ''}" 
                    onclick="filterBlogs('ALL')">
                <i class="fas fa-list me-1"></i>Tất cả (${draftCount + pendingCount + approvedCount + rejectedCount})
            </button>
            <button class="filter-btn ${statusFilter eq 'DRAFT' ? 'active' : ''}" 
                    onclick="filterBlogs('DRAFT')">
                <i class="fas fa-file-alt me-1"></i>Nháp (${draftCount})
            </button>
            <button class="filter-btn ${statusFilter eq 'PENDING' ? 'active' : ''}" 
                    onclick="filterBlogs('PENDING')">
                <i class="fas fa-clock me-1"></i>Chờ duyệt (${pendingCount})
            </button>
            <button class="filter-btn ${statusFilter eq 'APPROVED' ? 'active' : ''}" 
                    onclick="filterBlogs('APPROVED')">
                <i class="fas fa-check-circle me-1"></i>Đã duyệt (${approvedCount})
            </button>
            <button class="filter-btn ${statusFilter eq 'REJECTED' ? 'active' : ''}" 
                    onclick="filterBlogs('REJECTED')">
                <i class="fas fa-times-circle me-1"></i>Bị từ chối (${rejectedCount})
            </button>
        </div>

        <!-- Messages -->
        <c:if test="${param.success eq 'created'}">
                <div class="alert alert-success alert-dismissible fade show">
                    <i class="fas fa-check-circle me-2"></i>Tạo blog thành công! 
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
        </c:if>
        <c:if test="${param.success eq 'updated'}">
                <div class="alert alert-success alert-dismissible fade show">
                    <i class="fas fa-check-circle me-2"></i>Cập nhật blog thành công! 
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
        </c:if>
        <c:if test="${param.success eq 'deleted'}">
                <div class="alert alert-success alert-dismissible fade show">
                    <i class="fas fa-check-circle me-2"></i>Xóa blog thành công! 
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
        </c:if>

        <!-- Blog List -->
        <c:choose>
            <c:when test="${empty blogs}">
                <div class="text-center py-5 bg-white rounded-3 shadow-sm">
                    <i class="fas fa-inbox fa-4x text-muted mb-3"></i>
                    <h4 class="text-muted">Chưa có blog nào</h4>
                    <p class="text-muted">Hãy tạo blog đầu tiên của bạn!</p>
                    <a href="${pageContext.request.contextPath}/user/blog-editor" class="btn btn-create mt-3">
                        <i class="fas fa-plus me-2"></i>Tạo Blog Ngay
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                    <c:forEach items="${blogs}" var="blog">
                        <div class="blog-card" id="blog-card-${blog.blogId}">
                            <!-- Hidden content for preview -->
                            <div class="blog-content-hidden" style="display: none;" data-blog-id="${blog.blogId}">
                                <c:out value="${blog.content}" escapeXml="false" />
                            </div>
                            <div class="row align-items-center">
                                <div class="col-md-8 mb-3 mb-md-0">
                                    <div class="d-flex align-items-start mb-2 flex-wrap">
                                    <h5 class="mb-0 me-3">${blog.title}</h5>
                                    <span class="status-badge status-${blog.status}">${blog.status}</span>
                                </div>
                                <p class="text-muted mb-2" style="font-size: 0.9rem;">
                                        ${blog.summary}
                                </p>
                                    <div class="d-flex gap-3 text-muted flex-wrap" style="font-size: 0.875rem;">
                                    <span><i class="far fa-calendar me-1"></i><fmt:formatDate value="${blog.createdAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                                    <span><i class="far fa-eye me-1"></i>${blog.viewCount} lượt xem</span>
                                    <span><i class="far fa-heart me-1"></i>${blog.likeCount} thích</span>
                                    <span><i class="far fa-comment me-1"></i>${blog.commentCount} bình luận</span>
                                </div>
                                <c:if test="${blog.status eq 'REJECTED'}">
                                    <div class="alert alert-danger mt-3 mb-0 py-3 border-start border-danger border-4">
                                        <div class="d-flex align-items-start">
                                            <i class="fas fa-exclamation-triangle me-2 mt-1" style="font-size: 1.2rem;"></i>
                                            <div>
                                                <strong class="d-block mb-1">
                                                    <i class="fas fa-ban me-1"></i>Blog đã bị từ chối
                                                </strong>
                                                <c:choose>
                                                    <c:when test="${not empty blog.moderationNote}">
                                                        <p class="mb-0"><strong>Lý do từ chối:</strong></p>
                                                        <p class="mb-0 text-muted">${blog.moderationNote}</p>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <p class="mb-0 text-muted">Không có lý do được cung cấp.</p>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                                <div class="col-md-4 text-md-end">
                                    <div class="d-flex flex-wrap gap-2 justify-content-md-end">
                                        <button class="btn btn-sm btn-outline-info preview-btn" 
                                                data-blog-id="${blog.blogId}" 
                                                data-blog-title="${blog.title}">
                                            <i class="fas fa-eye"></i> Xem trước
                                        </button>
                                <c:if test="${blog.status eq 'APPROVED'}">
                                            <a href="${pageContext.request.contextPath}/blog/${blog.slug}" 
                                               class="btn btn-sm btn-outline-primary" target="_blank">
                                                <i class="fas fa-external-link-alt"></i> Xem công khai
                                    </a>
                                </c:if>
                                <c:if test="${blog.editable}">
                                            <a href="${pageContext.request.contextPath}/user/blog-editor?id=${blog.blogId}" 
                                               class="btn btn-sm btn-outline-success">
                                        <i class="fas fa-edit"></i> Sửa
                                    </a>
                                </c:if>
                                <c:if test="${blog.deletable}">
                                            <button class="btn btn-sm btn-outline-danger" 
                                                    onclick="confirmDelete(${blog.blogId}, '${blog.title}')">
                                        <i class="fas fa-trash"></i> Xóa
                                    </button>
                                </c:if>
                                    </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <nav class="mt-4">
                        <ul class="pagination justify-content-center">
                            <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${currentPage - 1}&status=${statusFilter}">Trước</a>
                                    </li>
                            </c:if>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i eq currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}&status=${statusFilter}">${i}</a>
                                </li>
                            </c:forEach>
                            <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${currentPage + 1}&status=${statusFilter}">Sau</a>
                                    </li>
                            </c:if>
                        </ul>
                    </nav>
                </c:if>
            </c:otherwise>
        </c:choose>
        </div>
    </div>

    <!-- Preview Modal -->
    <div class="modal fade" id="previewModal" tabindex="-1" aria-labelledby="previewModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header" style="background: linear-gradient(135deg, #ff6b35, #f7931e); color: white;">
                    <h5 class="modal-title" id="previewModalLabel">
                        <i class="fas fa-eye me-2"></i>Xem trước Blog
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" style="background: #f8f9fa;">
                    <div class="container">
                        <div class="bg-white p-4 rounded shadow-sm">
                            <h2 id="previewTitle" class="mb-3"></h2>
                            <div id="previewContent" class="blog-preview-content"></div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-2"></i>Đóng
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer Start -->
    <div class="container-fluid bg-dark text-white-50 footer pt-5 mt-5">
      <div class="container py-5">
        <div class="row g-5">
          <div class="col-lg-3 col-md-6">
            <h5 class="text-white text-uppercase mb-4">Gicungco Marketplace</h5>
            <p class="mb-4">
              Nền tảng thương mại điện tử hàng đầu Việt Nam, kết nối người mua và
              người bán một cách an toàn và tiện lợi.
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
              <a
                class="text-white-50 mb-2"
                href="<%= request.getContextPath() %>/promotions"
                ><i class="fa fa-angle-right me-2"></i>Khuyến mãi</a
              >
              <a class="text-white-50 mb-2" href="#"
                ><i class="fa fa-angle-right me-2"></i>Hỗ trợ khách hàng</a
              >
            </div>
          </div>
          <div class="col-lg-3 col-md-6">
            <h5 class="text-white text-uppercase mb-4">Hỗ trợ</h5>
            <div class="d-flex flex-column justify-content-start">
              <a class="text-white-50 mb-2" href="#"
                ><i class="fa fa-angle-right me-2"></i>Trung tâm trợ giúp</a
              >
              <a class="text-white-50 mb-2" href="#"
                ><i class="fa fa-angle-right me-2"></i>Chính sách bảo mật</a
              >
              <a class="text-white-50 mb-2" href="#"
                ><i class="fa fa-angle-right me-2"></i>Điều khoản sử dụng</a
              >
              <a class="text-white-50 mb-2" href="#"
                ><i class="fa fa-angle-right me-2"></i>Chính sách vận chuyển</a
              >
            </div>
          </div>
          <div class="col-lg-3 col-md-6">
            <h5 class="text-white text-uppercase mb-4">Liên hệ</h5>
            <p class="mb-2">
              <i class="fa fa-map-marker-alt me-3"></i>123 Đường ABC, Quận 1, TP.HCM
            </p>
            <p class="mb-2"><i class="fa fa-phone-alt me-3"></i>+012 345 67890</p>
            <p class="mb-2"><i class="fa fa-envelope me-3"></i>info@example.com</p>
          </div>
        </div>
      </div>
      <div class="container">
        <div class="copyright">
          <div class="row">
            <div class="col-md-6 text-center text-md-start mb-3 mb-md-0">
              &copy; <a class="border-bottom" href="#">Gicungco Marketplace</a>, Tất
              cả quyền được bảo lưu.
            </div>
            <div class="col-md-6 text-center text-md-end">
              <div class="footer-menu">
                <a href="<%= request.getContextPath() %>/home">Trang chủ</a>
                <a href="#">Chính sách Cookie</a>
                <a href="#">Trợ giúp</a>
                <a href="#">Câu hỏi thường gặp</a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- Footer End -->

    <!-- Back to Top -->
    <a href="#" class="btn btn-primary btn-lg-square back-to-top"><i class="bi bi-arrow-up"></i></a>

    <!-- JavaScript Libraries -->
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<%= request.getContextPath() %>/views/assets/electro/lib/easing/easing.min.js"></script>
    <script src="<%= request.getContextPath() %>/views/assets/electro/lib/waypoints/waypoints.min.js"></script>
    <script src="<%= request.getContextPath() %>/views/assets/electro/lib/counterup/counterup.min.js"></script>
    <script src="<%= request.getContextPath() %>/views/assets/electro/lib/owlcarousel/owl.carousel.min.js"></script>

    <!-- Template Javascript -->
    <script src="<%= request.getContextPath() %>/views/assets/electro/js/main.js"></script>

    <script>
        // Spinner
        var spinner = function () {
            setTimeout(function () {
                if ($('#spinner').length > 0) {
                    $('#spinner').removeClass('show');
                }
            }, 1);
        };
        spinner();

        function filterBlogs(status) {
            window.location.href = '?status=' + status;
        }

        // Preview blog functionality
        document.addEventListener('DOMContentLoaded', function() {
            const previewButtons = document.querySelectorAll('.preview-btn');
            
            previewButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const blogId = this.getAttribute('data-blog-id');
                    const title = this.getAttribute('data-blog-title');
                    
                    // Find the hidden content div for this blog
                    const blogCard = document.getElementById('blog-card-' + blogId);
                    const contentDiv = blogCard.querySelector('.blog-content-hidden');
                    const content = contentDiv ? contentDiv.innerHTML : '<p>Không có nội dung</p>';
                    
                    // Set modal title
                    document.getElementById('previewTitle').textContent = title;
                    
                    // Set modal content
                    document.getElementById('previewContent').innerHTML = content;
                    
                    // Show modal
                    const modal = new bootstrap.Modal(document.getElementById('previewModal'));
                    modal.show();
                });
            });
        });

        function confirmDelete(blogId, title) {
            if (confirm('Bạn có chắc muốn xóa blog "' + title + '"?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/user/my-blogs';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                
                const blogIdInput = document.createElement('input');
                blogIdInput.type = 'hidden';
                blogIdInput.name = 'blogId';
                blogIdInput.value = blogId;
                
                form.appendChild(actionInput);
                form.appendChild(blogIdInput);
                document.body.appendChild(form);
                form.submit();
            }
        }

        function logout() {
            if (confirm('Bạn có chắc chắn muốn đăng xuất?')) {
                window.location.href = '<%= request.getContextPath() %>/logout';
            }
        }
    </script>
</body>
</html>
