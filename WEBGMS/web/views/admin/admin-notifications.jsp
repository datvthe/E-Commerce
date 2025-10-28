<%@page contentType="text/html" pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="utf-8" />
    <title>Quản lý Thông báo - Admin</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="https://use.fontawesome.com/releases/v5.15.4/css/all.css"
    />

    <style>
      :root {
        --primary-color: #ff6b35;
        --primary-dark: #e55a2b;
        --secondary-color: #f7931e;
      }

      body {
        background-color: #f8f9fa;
      }

      .navbar {
        background: linear-gradient(
          135deg,
          var(--primary-color),
          var(--secondary-color)
        );
      }

      .btn-primary {
        background: linear-gradient(
          135deg,
          var(--primary-color),
          var(--secondary-color)
        );
        border: none;
      }

      .btn-primary:hover {
        background: linear-gradient(135deg, var(--primary-dark), #e0841a);
      }

      .card {
        border: none;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      }

      .card-header {
        background: linear-gradient(
          135deg,
          var(--primary-color),
          var(--secondary-color)
        );
        color: white;
        border-radius: 10px 10px 0 0 !important;
      }

      .form-label {
        font-weight: 600;
        color: #495057;
      }

      .notification-preview {
        background-color: #fff;
        border: 2px dashed #dee2e6;
        border-radius: 8px;
        padding: 20px;
        margin-top: 20px;
      }

      .notification-icon {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.5rem;
      }

      .icon-order {
        background-color: #e3f2fd;
        color: #1976d2;
      }
      .icon-promotion {
        background-color: #fff3e0;
        color: #f57c00;
      }
      .icon-wallet {
        background-color: #e8f5e9;
        color: #388e3c;
      }
      .icon-system {
        background-color: #f3e5f5;
        color: #7b1fa2;
      }

      .recipient-pill {
        display: inline-block;
        padding: 5px 15px;
        border-radius: 20px;
        margin: 5px;
        background-color: #e9ecef;
        cursor: pointer;
        transition: all 0.3s;
      }

      .recipient-pill:hover {
        background-color: #dee2e6;
      }

      .recipient-pill.selected {
        background-color: var(--primary-color);
        color: white;
      }

      .recent-notification {
        border-left: 4px solid;
        padding: 15px;
        margin-bottom: 10px;
        background-color: white;
        border-radius: 5px;
      }

      .recent-notification.broadcast {
        border-left-color: #6c757d;
      }

      .recent-notification.personal {
        border-left-color: var(--primary-color);
      }
    </style>
  </head>
  <body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
      <div class="container-fluid">
        <a class="navbar-brand" href="<%= request.getContextPath() %>/admin">
          <i class="fas fa-bell me-2"></i>Quản lý Thông báo
        </a>
        <div class="navbar-nav ms-auto">
          <a class="nav-link" href="<%= request.getContextPath() %>/admin">
            <i class="bi bi-house me-1"></i>Dashboard
          </a>
          <a class="nav-link" href="<%= request.getContextPath() %>/home">
            <i class="bi bi-box-arrow-left me-1"></i>Về trang chủ
          </a>
        </div>
      </div>
    </nav>

    <!-- Include notification component -->
    <jsp:include page="../component/notification.jsp" />

    <div class="container py-5">
      <div class="row">
        <!-- Send Notification Form -->
        <div class="col-lg-8">
          <div class="card">
            <div class="card-header">
              <h5 class="mb-0">
                <i class="bi bi-send me-2"></i>Gửi Thông Báo Mới
              </h5>
            </div>
            <div class="card-body">
              <form
                id="notificationForm"
                method="POST"
                action="<%= request.getContextPath() %>/admin/notifications/send"
              >
                <!-- Title -->
                <div class="mb-3">
                  <label for="title" class="form-label">
                    <i class="bi bi-text-left me-1"></i>Tiêu đề *
                  </label>
                  <input
                    type="text"
                    class="form-control"
                    id="title"
                    name="title"
                    placeholder="Nhập tiêu đề thông báo"
                    required
                    maxlength="150"
                  />
                </div>

                <!-- Message -->
                <div class="mb-3">
                  <label for="message" class="form-label">
                    <i class="bi bi-chat-text me-1"></i>Nội dung *
                  </label>
                  <textarea
                    class="form-control"
                    id="message"
                    name="message"
                    rows="4"
                    placeholder="Nhập nội dung thông báo"
                    required
                  ></textarea>
                </div>

                <!-- Type -->
                <div class="mb-3">
                  <label for="type" class="form-label">
                    <i class="bi bi-tag me-1"></i>Loại thông báo *
                  </label>
                  <select class="form-select" id="type" name="type" required>
                    <option value="">-- Chọn loại --</option>
                    <option value="order">📦 Đơn hàng</option>
                    <option value="promotion">🎁 Khuyến mãi</option>
                    <option value="wallet">💰 Ví tiền</option>
                    <option value="system">⚙️ Hệ thống</option>
                  </select>
                </div>

                <!-- Recipient Type -->
                <div class="mb-3">
                  <label class="form-label">
                    <i class="bi bi-people me-1"></i>Người nhận *
                  </label>
                  <div class="btn-group w-100" role="group">
                    <input
                      type="radio"
                      class="btn-check"
                      name="recipientType"
                      id="recipientAll"
                      value="all"
                      checked
                    />
                    <label class="btn btn-outline-primary" for="recipientAll">
                      <i class="bi bi-broadcast me-1"></i>Tất cả người dùng
                    </label>

                    <input
                      type="radio"
                      class="btn-check"
                      name="recipientType"
                      id="recipientSingle"
                      value="single"
                    />
                    <label
                      class="btn btn-outline-primary"
                      for="recipientSingle"
                    >
                      <i class="bi bi-person me-1"></i>Một người dùng
                    </label>

                    <input
                      type="radio"
                      class="btn-check"
                      name="recipientType"
                      id="recipientMultiple"
                      value="multiple"
                    />
                    <label
                      class="btn btn-outline-primary"
                      for="recipientMultiple"
                    >
                      <i class="bi bi-people-fill me-1"></i>Nhiều người dùng
                    </label>
                  </div>
                </div>

                <!-- Single User Selection -->
                <div class="mb-3" id="singleUserSection" style="display: none">
                  <label for="userId" class="form-label">Chọn người dùng</label>
                  <select class="form-select" id="userId" name="userId">
                    <option value="">-- Chọn người dùng --</option>
                    <c:forEach var="user" items="${allUsers}">
                      <option value="${user.user_id}">
                        #${user.user_id} - ${user.full_name} (${user.email})
                      </option>
                    </c:forEach>
                  </select>
                </div>

                <!-- Multiple Users Selection -->
                <div
                  class="mb-3"
                  id="multipleUsersSection"
                  style="display: none"
                >
                  <label class="form-label"
                    >Chọn người dùng (click để chọn)</label
                  >
                  <div
                    class="border rounded p-3"
                    style="max-height: 300px; overflow-y: auto"
                  >
                    <c:forEach var="user" items="${allUsers}">
                      <div
                        class="recipient-pill"
                        data-user-id="${user.user_id}"
                      >
                        <i class="bi bi-person"></i>
                        ${user.full_name} (#${user.user_id})
                      </div>
                    </c:forEach>
                  </div>
                  <div id="selectedUsersContainer"></div>
                </div>

                <!-- Preview Section -->
                <div
                  class="notification-preview"
                  id="previewSection"
                  style="display: none"
                >
                  <h6 class="mb-3"><i class="bi bi-eye me-2"></i>Xem trước:</h6>
                  <div class="d-flex align-items-start">
                    <div class="notification-icon me-3" id="previewIcon">
                      <i class="bi bi-bell"></i>
                    </div>
                    <div class="flex-grow-1">
                      <h6 class="fw-bold mb-1" id="previewTitle">
                        Tiêu đề thông báo
                      </h6>
                      <p class="mb-2 text-muted" id="previewMessage">
                        Nội dung thông báo sẽ hiển thị ở đây...
                      </p>
                      <small class="text-muted">
                        <i class="bi bi-clock me-1"></i>Vừa xong
                      </small>
                      <span
                        class="badge bg-secondary ms-2"
                        id="previewRecipient"
                        >Tất cả</span
                      >
                    </div>
                  </div>
                </div>

                <!-- Submit Buttons -->
                <div class="mt-4 d-flex gap-2">
                  <button type="submit" class="btn btn-primary px-4">
                    <i class="bi bi-send me-2"></i>Gửi thông báo
                  </button>
                  <button
                    type="button"
                    class="btn btn-outline-secondary"
                    onclick="resetForm()"
                  >
                    <i class="bi bi-arrow-clockwise me-2"></i>Làm mới
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>

        <!-- Recent Notifications -->
        <div class="col-lg-4">
          <div class="card">
            <div class="card-header">
              <h5 class="mb-0">
                <i class="bi bi-clock-history me-2"></i>Thông báo gần đây
              </h5>
            </div>
            <div class="card-body" style="max-height: 600px; overflow-y: auto">
              <c:choose>
                <c:when test="${not empty recentNotifications}">
                  <c:forEach var="notif" items="${recentNotifications}">
                    <div
                      class="recent-notification ${notif.userId == null ? 'broadcast' : 'personal'}"
                    >
                      <div
                        class="d-flex justify-content-between align-items-start mb-1"
                      >
                        <strong class="text-truncate" style="max-width: 200px"
                          >${notif.title}</strong
                        >
                        <c:choose>
                          <c:when test="${notif.userId == null}">
                            <span class="badge bg-secondary">Tất cả</span>
                          </c:when>
                          <c:otherwise>
                            <span class="badge bg-primary"
                              >#${notif.userId.user_id}</span
                            >
                          </c:otherwise>
                        </c:choose>
                      </div>
                      <small class="text-muted d-block text-truncate"
                        >${notif.message}</small
                      >
                      <small class="text-muted">
                        <i class="bi bi-clock me-1"></i>${notif.createdAt}
                      </small>
                    </div>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <div class="text-center text-muted py-4">
                    <i class="bi bi-inbox display-4"></i>
                    <p class="mt-2">Chưa có thông báo nào</p>
                  </div>
                </c:otherwise>
              </c:choose>
            </div>
          </div>

          <!-- Quick Stats -->
          <div class="card mt-3">
            <div class="card-body">
              <h6 class="card-title">
                <i class="bi bi-graph-up me-2"></i>Thống kê
              </h6>
              <div
                class="d-flex justify-content-between align-items-center mb-2"
              >
                <span>Tổng thông báo:</span>
                <strong
                  >${recentNotifications != null ? recentNotifications.size() :
                  0}</strong
                >
              </div>
              <div class="d-flex justify-content-between align-items-center">
                <span>Người dùng:</span>
                <strong>${allUsers != null ? allUsers.size() : 0}</strong>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
      // Toggle recipient sections
      document
        .querySelectorAll('input[name="recipientType"]')
        .forEach((radio) => {
          radio.addEventListener("change", function () {
            document.getElementById("singleUserSection").style.display = "none";
            document.getElementById("multipleUsersSection").style.display =
              "none";

            if (this.value === "single") {
              document.getElementById("singleUserSection").style.display =
                "block";
            } else if (this.value === "multiple") {
              document.getElementById("multipleUsersSection").style.display =
                "block";
            }

            updatePreview();
          });
        });

      // Multiple users selection
      const selectedUserIds = new Set();

      document.querySelectorAll(".recipient-pill").forEach((pill) => {
        pill.addEventListener("click", function () {
          const userId = this.dataset.userId;

          if (selectedUserIds.has(userId)) {
            selectedUserIds.delete(userId);
            this.classList.remove("selected");
          } else {
            selectedUserIds.add(userId);
            this.classList.add("selected");
          }

          updateSelectedUsers();
          updatePreview();
        });
      });

      function updateSelectedUsers() {
        const container = document.getElementById("selectedUsersContainer");
        container.innerHTML = "";

        selectedUserIds.forEach((userId) => {
          const input = document.createElement("input");
          input.type = "hidden";
          input.name = "userIds[]";
          input.value = userId;
          container.appendChild(input);
        });
      }

      // Live preview
      function updatePreview() {
        const title = document.getElementById("title").value;
        const message = document.getElementById("message").value;
        const type = document.getElementById("type").value;
        const recipientType = document.querySelector(
          'input[name="recipientType"]:checked'
        ).value;

        if (title || message || type) {
          document.getElementById("previewSection").style.display = "block";

          // Update preview content
          document.getElementById("previewTitle").textContent =
            title || "Tiêu đề thông báo";
          document.getElementById("previewMessage").textContent =
            message || "Nội dung thông báo sẽ hiển thị ở đây...";

          // Update icon based on type
          const iconMap = {
            order: { icon: "bi-box-seam", class: "icon-order" },
            promotion: { icon: "bi-gift", class: "icon-promotion" },
            wallet: { icon: "bi-wallet2", class: "icon-wallet" },
            system: { icon: "bi-info-circle", class: "icon-system" },
          };

          const iconElement = document.getElementById("previewIcon");
          iconElement.className = "notification-icon me-3";
          iconElement.innerHTML = '<i class="bi bi-bell"></i>';

          if (type && iconMap[type]) {
            iconElement.classList.add(iconMap[type].class);
            iconElement.innerHTML =
              '<i class="bi ' + iconMap[type].icon + '"></i>';
          }

          // Update recipient badge
          let recipientText = "Tất cả";
          if (recipientType === "single") {
            const select = document.getElementById("userId");
            recipientText =
              select.selectedIndex > 0
                ? select.options[select.selectedIndex].text
                : "Chưa chọn";
          } else if (recipientType === "multiple") {
            recipientText = selectedUserIds.size + " người dùng";
          }
          document.getElementById("previewRecipient").textContent =
            recipientText;
        } else {
          document.getElementById("previewSection").style.display = "none";
        }
      }

      // Attach event listeners
      document.getElementById("title").addEventListener("input", updatePreview);
      document
        .getElementById("message")
        .addEventListener("input", updatePreview);
      document.getElementById("type").addEventListener("change", updatePreview);
      document
        .getElementById("userId")
        .addEventListener("change", updatePreview);

      // Reset form
      function resetForm() {
        document.getElementById("notificationForm").reset();
        selectedUserIds.clear();
        document.querySelectorAll(".recipient-pill").forEach((pill) => {
          pill.classList.remove("selected");
        });
        updatePreview();
        document.getElementById("singleUserSection").style.display = "none";
        document.getElementById("multipleUsersSection").style.display = "none";
      }

      // Form validation
      document
        .getElementById("notificationForm")
        .addEventListener("submit", function (e) {
          const recipientType = document.querySelector(
            'input[name="recipientType"]:checked'
          ).value;

          if (recipientType === "single") {
            const userId = document.getElementById("userId").value;
            if (!userId) {
              e.preventDefault();
              alert("Vui lòng chọn người dùng!");
              return;
            }
          } else if (recipientType === "multiple") {
            if (selectedUserIds.size === 0) {
              e.preventDefault();
              alert("Vui lòng chọn ít nhất một người dùng!");
              return;
            }
          }
        });
    </script>
  </body>
</html>
