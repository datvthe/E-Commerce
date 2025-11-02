<%@ taglib prefix="c" uri="jakarta.tags.core" %> <%@ taglib prefix="fmt"
uri="jakarta.tags.fmt" %> <%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="utf-8" />
    <title>Lịch sử đơn hàng</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <!-- Bootstrap CSS -->
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />

    <!-- Font Awesome -->
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
    />

    <style>
      body {
        background: #f5f7fa;
        font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
        padding: 2rem 0;
      }

      .container {
        max-width: 1200px;
      }

      .page-title {
        margin-bottom: 2rem;
      }

      .back-btn {
        margin-bottom: 1rem;
      }

      .order-card {
        background: white;
        border-radius: 8px;
        margin-bottom: 1.5rem;
        overflow: hidden;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
      }

      .order-header {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 1rem 1.5rem;
        display: flex;
        justify-content: space-between;
        align-items: center;
      }

      .order-number {
        font-size: 1.1rem;
        font-weight: 600;
      }

      .order-status {
        padding: 0.25rem 0.75rem;
        border-radius: 20px;
        font-size: 0.85rem;
        font-weight: 500;
      }

      .status-completed {
        background: #10b981;
        color: white;
      }

      .status-processing {
        background: #3b82f6;
        color: white;
      }

      .status-pending {
        background: #f59e0b;
        color: white;
      }

      .status-cancelled {
        background: #ef4444;
        color: white;
      }

      .status-refunded {
        background: #6b7280;
        color: white;
      }

      .order-body {
        padding: 1.5rem;
      }

      .order-info {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1rem;
        margin-bottom: 1.5rem;
        padding-bottom: 1.5rem;
        border-bottom: 1px solid #e0e0e0;
      }

      .info-item {
        display: flex;
        flex-direction: column;
      }

      .info-label {
        font-size: 0.85rem;
        color: #666;
        margin-bottom: 0.25rem;
      }

      .info-value {
        font-size: 1rem;
        font-weight: 500;
        color: #333;
      }

      .total-amount {
        font-size: 1.5rem;
        font-weight: 700;
        color: #dc2626;
      }

      .digital-products {
        background: #f8f9fa;
        border-radius: 6px;
        padding: 1rem;
      }

      .digital-product-item {
        background: white;
        border: 1px solid #e0e0e0;
        border-radius: 6px;
        padding: 1rem;
        margin-bottom: 1rem;
      }

      .digital-product-item:last-child {
        margin-bottom: 0;
      }

      .product-code {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        margin-top: 0.5rem;
      }

      .code-box {
        background: #f1f5f9;
        padding: 0.5rem 1rem;
        border-radius: 4px;
        font-family: "Courier New", monospace;
        font-weight: 600;
        color: #1e293b;
        flex: 1;
      }

      .copy-btn {
        padding: 0.5rem 1rem;
        background: #667eea;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        transition: all 0.3s;
      }

      .copy-btn:hover {
        background: #5568d3;
      }

      .no-orders {
        text-align: center;
        padding: 3rem;
        background: white;
        border-radius: 8px;
      }

      .no-orders i {
        font-size: 4rem;
        color: #ccc;
        margin-bottom: 1rem;
      }

      .pagination {
        margin-top: 2rem;
      }

      /* Button xem chi tiết */
      .btn-view-detail {
        min-width: 150px;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <!-- Back Button -->
      <div class="back-btn">
        <a href="javascript:history.back()" class="btn btn-outline-secondary">
          <i class="fas fa-arrow-left"></i> Quay lại
        </a>
      </div>

      <!-- Page Title -->
      <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0">
          <i class="fas fa-shopping-bag text-primary"></i>
          Lịch sử đơn hàng
        </h2>
        <span
          class="badge bg-primary"
          style="font-size: 1rem; padding: 0.5rem 1rem"
        >
          Tổng: ${totalOrders} đơn
        </span>
      </div>

      <!-- Error Message -->
      <c:if test="${not empty error}">
        <div
          class="alert alert-danger alert-dismissible fade show"
          role="alert"
        >
          <i class="fas fa-exclamation-circle"></i> ${error}
          <button
            type="button"
            class="btn-close"
            data-bs-dismiss="alert"
          ></button>
        </div>
      </c:if>

      <!-- Orders List -->
      <c:choose>
        <c:when test="${empty orders}">
          <div class="no-orders">
            <i class="fas fa-shopping-cart"></i>
            <h4>Chưa có đơn hàng nào</h4>
            <p class="text-muted">Bạn chưa mua sản phẩm nào.</p>
          </div>
        </c:when>
        <c:otherwise>
          <c:forEach items="${orders}" var="order">
            <div class="order-card">
              <!-- Order Header -->
              <div class="order-header">
                <div>
                  <div class="order-number">
                    <i class="fas fa-receipt"></i>
                    ${order.orderNumber}
                  </div>
                  <div
                    style="font-size: 0.9rem; opacity: 0.9; margin-top: 0.25rem"
                  >
                    <i class="far fa-clock"></i>
                    <fmt:formatDate
                      value="${order.createdAt}"
                      pattern="dd/MM/yyyy HH:mm:ss"
                    />
                  </div>
                </div>
                <div>
                  <c:choose>
                    <%-- ✨ NEW FLOW: Status theo thứ tự ưu tiên --%> <%-- 1.
                    DELIVERED - Đã giao hàng --%>
                    <c:when
                      test="${not empty order.paymentStatus and order.paymentStatus.equalsIgnoreCase('DELIVERED')}"
                    >
                      <span class="order-status status-completed">
                        <i class="fas fa-check-circle"></i> Đã giao hàng
                      </span>
                    </c:when>

                    <%-- 2. REFUNDED - Đã hoàn tiền --%>
                    <c:when
                      test="${not empty order.paymentStatus and order.paymentStatus.equalsIgnoreCase('REFUNDED')}"
                    >
                      <span class="order-status status-refunded">
                        <i class="fas fa-undo"></i> Đã hoàn tiền
                      </span>
                    </c:when>

                    <%-- 3. CANCELLED - Đã hủy --%>
                    <c:when
                      test="${not empty order.paymentStatus and order.paymentStatus.equalsIgnoreCase('CANCELLED')}"
                    >
                      <span class="order-status status-cancelled">
                        <i class="fas fa-times-circle"></i> Đã hủy
                      </span>
                    </c:when>

                    <%-- 4. PAID - Đã thanh toán, đang xử lý --%>
                    <c:when
                      test="${not empty order.paymentStatus and order.paymentStatus.equalsIgnoreCase('PAID')}"
                    >
                      <span class="order-status status-processing">
                        <i class="fas fa-spinner fa-spin"></i> Đang xử lý
                      </span>
                    </c:when>

                    <%-- 5. PENDING hoặc khác --%>
                    <c:otherwise>
                      <span class="order-status status-pending">
                        <i class="fas fa-clock"></i> Chờ thanh toán
                      </span>
                    </c:otherwise>
                  </c:choose>
                </div>
              </div>

              <!-- Order Body -->
              <div class="order-body">
                <!-- Order Info -->
                <div class="order-info">
                  <div class="info-item">
                    <span class="info-label">Sản phẩm</span>
                    <span class="info-value">
                      <c:choose>
                        <c:when test="${not empty order.product}">
                          ${order.product.name}
                        </c:when>
                        <c:otherwise>
                          Sản phẩm #${order.productId}
                        </c:otherwise>
                      </c:choose>
                    </span>
                  </div>

                  <div class="info-item">
                    <span class="info-label">Người bán</span>
                    <span class="info-value">
                      <c:choose>
                        <c:when test="${not empty order.seller}">
                          ${order.seller.full_name}
                        </c:when>
                        <c:otherwise> Seller #${order.sellerId} </c:otherwise>
                      </c:choose>
                    </span>
                  </div>

                  <div class="info-item">
                    <span class="info-label">Số lượng</span>
                    <span class="info-value">${order.quantity}</span>
                  </div>

                  <div class="info-item">
                    <span class="info-label">Tổng tiền</span>
                    <span class="total-amount">
                      <fmt:formatNumber
                        value="${order.totalAmount}"
                        type="number"
                        maxFractionDigits="0"
                      />₫
                    </span>
                  </div>
                </div>

                <!-- Buttons -->
                <div class="text-center mt-3">
                  <button
                    class="btn btn-outline-primary btn-sm btn-view-detail"
                    data-bs-toggle="collapse"
                    data-bs-target="#detail-${order.orderId}"
                  >
                    <i class="fas fa-eye"></i> Xem chi tiết
                  </button>

                  <!-- Nút hoàn tiền - Hiện khi PAID hoặc CANCELLED -->
                  <c:if
                    test="${not empty order.paymentStatus and (order.paymentStatus.equalsIgnoreCase('PAID') or order.paymentStatus.equalsIgnoreCase('CANCELLED'))}"
                  >
                    <button
                      class="btn btn-outline-danger btn-sm ms-2"
                      onclick="requestRefund(${order.orderId}, '${order.orderNumber}')"
                    >
                      <i class="fas fa-undo"></i> Yêu cầu hoàn tiền
                    </button>
                  </c:if>
                </div>

                <!-- Collapsible Detail Section -->
                <div class="collapse mt-3" id="detail-${order.orderId}">
                  <c:choose>
                    <c:when
                      test="${not empty orderDigitalProducts[order.orderId]}"
                    >
                      <div class="digital-products">
                        <h5 class="mb-3">
                          <i class="fas fa-key text-primary"></i>
                          Thông tin sản phẩm số
                        </h5>

                        <c:forEach
                          items="${orderDigitalProducts[order.orderId]}"
                          var="dp"
                        >
                          <div class="digital-product-item">
                            <div class="row">
                              <div class="col-md-6">
                                <strong>Loại:</strong>
                                <span class="badge bg-info"
                                  >${dp.codeType}</span
                                >
                              </div>
                              <div class="col-md-6">
                                <strong>Mã Code:</strong>
                                <div class="product-code">
                                  <div class="code-box">${dp.codeValue}</div>
                                  <button
                                    class="copy-btn"
                                    onclick="copyToClipboard('${dp.codeValue}', this)"
                                  >
                                    <i class="fas fa-copy"></i> Copy
                                  </button>
                                </div>
                              </div>
                            </div>

                            <c:if test="${not empty dp.expiresAt}">
                              <div class="mt-3 text-danger">
                                <i class="fas fa-exclamation-triangle"></i>
                                <strong>Hạn sử dụng:</strong>
                                <fmt:formatDate
                                  value="${dp.expiresAt}"
                                  pattern="dd/MM/yyyy HH:mm"
                                />
                              </div>
                            </c:if>
                          </div>
                        </c:forEach>
                      </div>
                    </c:when>
                    <c:otherwise>
                      <div class="alert alert-info">
                        <i class="fas fa-info-circle"></i> Chưa có thông tin sản
                        phẩm số
                      </div>
                    </c:otherwise>
                  </c:choose>
                </div>
                <!-- End Collapse -->
              </div>
            </div>
          </c:forEach>

          <!-- Pagination -->
          <c:if test="${totalPages > 1}">
            <nav aria-label="Page navigation">
              <ul class="pagination justify-content-center">
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                  <a class="page-link" href="?page=${currentPage - 1}">
                    <i class="fas fa-chevron-left"></i> Trước
                  </a>
                </li>

                <c:forEach begin="1" end="${totalPages}" var="i">
                  <li class="page-item ${currentPage == i ? 'active' : ''}">
                    <a class="page-link" href="?page=${i}">${i}</a>
                  </li>
                </c:forEach>

                <li
                  class="page-item ${currentPage == totalPages ? 'disabled' : ''}"
                >
                  <a class="page-link" href="?page=${currentPage + 1}">
                    Sau <i class="fas fa-chevron-right"></i>
                  </a>
                </li>
              </ul>
            </nav>
          </c:if>
        </c:otherwise>
      </c:choose>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
      function copyToClipboard(text, button) {
        navigator.clipboard
          .writeText(text)
          .then(() => {
            const originalHTML = button.innerHTML;
            button.innerHTML = '<i class="fas fa-check"></i> Đã copy!';
            button.style.background = "#10b981";

            setTimeout(() => {
              button.innerHTML = originalHTML;
              button.style.background = "#667eea";
            }, 2000);
          })
          .catch((err) => {
            alert("Không thể sao chép: " + err);
          });
      }

      function requestRefund(orderId, orderNumber) {
        if (
          !confirm(
            "Bạn có chắc muốn yêu cầu hoàn tiền cho đơn hàng " +
              orderNumber +
              "?"
          )
        ) {
          return;
        }

        const btn = event.target;
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';

        fetch("<%= request.getContextPath() %>/user/refund", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            orderId: orderId,
            reason: "Đơn hàng không được giao hàng",
          }),
        })
          .then((response) => response.json())
          .then((data) => {
            if (data.status === "SUCCESS") {
              alert("✅ " + data.message);
              location.reload();
            } else {
              alert("❌ " + data.message);
              btn.disabled = false;
              btn.innerHTML = '<i class="fas fa-undo"></i> Yêu cầu hoàn tiền';
            }
          })
          .catch((error) => {
            console.error("Error:", error);
            alert("❌ Lỗi kết nối server!");
            btn.disabled = false;
            btn.innerHTML = '<i class="fas fa-undo"></i> Yêu cầu hoàn tiền';
          });
      }
    </script>
  </body>
</html>
