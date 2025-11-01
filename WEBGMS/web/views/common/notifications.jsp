<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="utf-8" />
    <title>Thông báo - Gicungco</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
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

      /* Notification Styles */
      .notification-card {
        transition: all 0.3s ease;
        border-left: 4px solid transparent;
        cursor: pointer;
      }
      .notification-card:hover {
        transform: translateX(5px);
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
      }
      .notification-card.unread {
        background-color: #fff8f3;
        border-left-color: #ff6b35;
      }
      .notification-card.read {
        background-color: #f8f9fa;
        border-left-color: #dee2e6;
      }
      .notification-card.broadcast {
        border-left-width: 4px;
        border-left-style: dashed;
      }
      .notification-icon {
        width: 50px;
        height: 50px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 50%;
        font-size: 1.5rem;
      }
      .notification-icon.order {
        background-color: #e3f2fd;
        color: #1976d2;
      }
      .notification-icon.promotion {
        background-color: #fff3e0;
        color: #f57c00;
      }
      .notification-icon.wallet {
        background-color: #e8f5e9;
        color: #388e3c;
      }
      .notification-icon.system {
        background-color: #f3e5f5;
        color: #7b1fa2;
      }
      .badge-new {
        font-size: 0.7rem;
        padding: 0.3rem 0.6rem;
      }
      .notification-time {
        font-size: 0.85rem;
        color: #6c757d;
      }
      .notification-filters .btn {
        border-radius: 20px;
        margin-right: 0.5rem;
        margin-bottom: 0.5rem;
      }
    </style>
  </head>
  <body>
    <!-- Include notification popup component -->
    <jsp:include page="../component/notification.jsp" />

    <!-- Header -->
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
            <!-- Notification Button - Active -->
            <a
              href="<%= request.getContextPath() %>/notifications"
              class="text-primary me-3 position-relative"
              title="Thông báo"
              style="text-decoration: none"
            >
              <i class="bi bi-bell-fill" style="font-size: 1.2rem"></i>
            </a>
            <c:choose>
              <c:when test="${not empty sessionScope.user}">
                <a
                  href="<%= request.getContextPath() %>/profile"
                  class="btn btn-outline-info btn-sm px-3 me-2"
                >
                  <i class="bi bi-person me-1"></i>Tài khoản
                </a>
                <a
                  href="<%= request.getContextPath() %>/logout"
                  class="btn btn-outline-danger btn-sm px-3"
                >
                  <i class="bi bi-box-arrow-right me-1"></i>Đăng xuất
                </a>
              </c:when>
              <c:otherwise>
                <a
                  href="<%= request.getContextPath() %>/login"
                  class="btn btn-outline-primary btn-sm px-3 me-2"
                >
                  <i class="bi bi-person me-1"></i>Đăng nhập
                </a>
                <a
                  href="<%= request.getContextPath() %>/register"
                  class="btn btn-outline-success btn-sm px-3"
                >
                  <i class="bi bi-person-plus me-1"></i>Đăng ký
                </a>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>
    </div>

    <!-- Logo and Search -->
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
        <div class="col-md-8 col-lg-9 text-center text-lg-end">
          <a
            href="<%= request.getContextPath() %>/home"
            class="btn btn-outline-primary"
          >
            <i class="bi bi-arrow-left me-2"></i>Quay lại trang chủ
          </a>
        </div>
      </div>
    </div>

    <!-- Main Content -->
    <div class="container py-5">
      <div class="row">
        <div class="col-12">
          <!-- Page Header -->
          <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
              <h2 class="display-6 fw-bold text-dark mb-2">
                <i class="bi bi-bell-fill text-primary me-2"></i>Thông báo
              </h2>
              <p class="text-muted">Quản lý tất cả thông báo của bạn</p>
            </div>
            <form method="POST" action="<%= request.getContextPath() %>/notifications/mark-all-read" style="display: inline;">
              <button type="submit" class="btn btn-outline-primary">
                <i class="bi bi-check-all me-1"></i>Đánh dấu tất cả đã đọc
              </button>
            </form>
          </div>

          <!-- Filters -->
          <div class="notification-filters mb-4">
            <button
              class="btn btn-primary active"
              onclick="filterNotifications('all')"
            >
              <i class="bi bi-list me-1"></i>Tất cả (${fn:length(notifications)})
            </button>
            <button
              class="btn btn-outline-primary"
              onclick="filterNotifications('unread')"
            >
              <i class="bi bi-envelope me-1"></i>Chưa đọc (${unreadCount})
            </button>
            <button
              class="btn btn-outline-primary"
              onclick="filterNotifications('order')"
            >
              <i class="bi bi-box me-1"></i>Đơn hàng
            </button>
            <button
              class="btn btn-outline-primary"
              onclick="filterNotifications('promotion')"
            >
              <i class="bi bi-tag me-1"></i>Khuyến mãi
            </button>
            <button
              class="btn btn-outline-primary"
              onclick="filterNotifications('wallet')"
            >
              <i class="bi bi-wallet2 me-1"></i>Ví tiền
            </button>
            <button
              class="btn btn-outline-primary"
              onclick="filterNotifications('system')"
            >
              <i class="bi bi-gear me-1"></i>Hệ thống
            </button>
          </div>

          <!-- Notifications List -->
          <div class="notifications-list">
            <c:choose>
              <c:when test="${not empty notifications}">
                <c:forEach var="notif" items="${notifications}">
                  <div
                    class="notification-card ${notif.status} ${notif.userId == null ? 'broadcast' : ''} bg-white rounded-3 shadow-sm p-4 mb-3"
                    data-type="${notif.type}"
                    data-status="${notif.status}"
                    data-id="${notif.notificationId}"
                  >
                    <div class="d-flex align-items-start">
                      <div class="notification-icon ${notif.type} flex-shrink-0">
                        <c:choose>
                          <c:when test="${notif.type == 'order'}">
                            <i class="bi bi-box-seam"></i>
                          </c:when>
                          <c:when test="${notif.type == 'promotion'}">
                            <i class="bi bi-gift"></i>
                          </c:when>
                          <c:when test="${notif.type == 'wallet'}">
                            <i class="bi bi-wallet2"></i>
                          </c:when>
                          <c:otherwise>
                            <i class="bi bi-info-circle"></i>
                          </c:otherwise>
                        </c:choose>
                      </div>
                      <div class="flex-grow-1 ms-3">
                        <div
                          class="d-flex justify-content-between align-items-start mb-2"
                        >
                          <h5 class="mb-1 fw-bold">${notif.title}</h5>
                          <div>
                            <c:if test="${notif.status == 'unread'}">
                              <span class="badge bg-danger badge-new">Mới</span>
                            </c:if>
                            <c:if test="${notif.userId == null}">
                              <span class="badge bg-secondary ms-1">Broadcast</span>
                            </c:if>
                          </div>
                        </div>
                        <p class="mb-2 text-muted">${notif.message}</p>
                        <div
                          class="d-flex justify-content-between align-items-center"
                        >
                          <span class="notification-time">
                            <i class="bi bi-clock me-1"></i>${notif.createdAt}
                          </span>
                          <c:if test="${notif.status == 'unread' && notif.userId != null}">
                            <form method="POST" action="<%= request.getContextPath() %>/notifications/mark-read" style="display: inline;">
                              <input type="hidden" name="notificationId" value="${notif.notificationId}">
                              <button type="submit" class="btn btn-sm btn-outline-secondary">
                                <i class="bi bi-check"></i> Đánh dấu đã đọc
                              </button>
                            </form>
                          </c:if>
                        </div>
                      </div>
                    </div>
                  </div>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <div class="text-center py-5">
                  <i class="bi bi-inbox display-1 text-muted"></i>
                  <h4 class="mt-3 text-muted">Chưa có thông báo nào</h4>
                  <p class="text-muted">Thông báo của bạn sẽ hiển thị ở đây</p>
                  <a href="<%= request.getContextPath() %>/home" class="btn btn-primary mt-3">
                    <i class="bi bi-house me-2"></i>Về trang chủ
                  </a>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>
    </div>

    <!-- Footer -->
    <div class="container-fluid bg-dark text-white-50 footer pt-5 mt-5">
      <div class="container py-5">
        <div class="row g-5">
          <div class="col-lg-3 col-md-6">
            <h5 class="text-white text-uppercase mb-4">Gicungco Marketplace</h5>
            <p class="mb-4">Nền tảng thương mại điện tử hàng đầu Việt Nam</p>
          </div>
          <div class="col-lg-3 col-md-6">
            <h5 class="text-white text-uppercase mb-4">Liên kết</h5>
            <a
              class="text-white-50 mb-2 d-block"
              href="<%= request.getContextPath() %>/home"
              >Trang chủ</a
            >
            <a
              class="text-white-50 mb-2 d-block"
              href="<%= request.getContextPath() %>/products"
              >Sản phẩm</a
            >
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
          </div>
        </div>
      </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
      // Filter notifications
      function filterNotifications(type) {
        const cards = document.querySelectorAll(".notification-card");
        const buttons = document.querySelectorAll(".notification-filters .btn");

        // Update active button
        buttons.forEach((btn) => {
          btn.classList.remove("btn-primary", "active");
          btn.classList.add("btn-outline-primary");
        });
        event.target.classList.remove("btn-outline-primary");
        event.target.classList.add("btn-primary", "active");

        // Filter cards
        cards.forEach((card) => {
          if (type === "all") {
            card.style.display = "block";
          } else if (type === "unread") {
            card.style.display = card.classList.contains("unread")
              ? "block"
              : "none";
          } else {
            card.style.display = card.dataset.type === type ? "block" : "none";
          }
        });
      }

      // Initialize
      document.addEventListener("DOMContentLoaded", function () {
        console.log("Notifications page loaded");
      });
    </script>
  </body>
</html>
