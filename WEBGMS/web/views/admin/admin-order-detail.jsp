<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đơn hàng - Admin</title>
    <style>
        body { font-family: Poppins, sans-serif; background:#fff8f2; margin:0 }
        .main { margin-left:260px; padding:40px }
        .card { background:#fff; padding:24px; border-radius:12px; box-shadow:0 2px 10px rgba(0,0,0,.08); margin-bottom:16px }
        .btn { background:#ff6600; color:#fff; border:none; padding:8px 14px; border-radius:8px; cursor:pointer; font-weight:600 }
        .btn-secondary{ background:#fff; color:#333; border:1px solid #eee }
        .btn-danger{ background:#dc3545 }
        .status{ padding:5px 10px; border-radius:6px; color:#fff; text-transform:capitalize }
        .status.pending{ background:#ffc107; color:#333 }
        .status.paid{ background:#28a745 }
        .status.shipped{ background:#17a2b8 }
        .status.delivered{ background:#6f42c1 }
        .status.cancelled{ background:#dc3545 }
        .status.refunded{ background:#6c757d }
        table{ width:100%; border-collapse:collapse }
        th,td{ padding:10px 12px; border-bottom:1px solid #f0f0f0; text-align:left }
        th{ background:#fff3e6; color:#ff6600 }
    </style>
</head>
<body>
<jsp:include page="/views/component/sidebar.jsp" />
<jsp:include page="/views/component/headerAdmin.jsp" />
<div class="main">
    <div class="card">
        <div style="display:flex; justify-content:space-between; align-items:center;">
            <h2 style="margin:0">Đơn hàng #${order.order_id}</h2>
            <div style="display:flex; gap:8px;">
                <a class="btn-secondary btn" href="${pageContext.request.contextPath}/admin/orders">Quay lại</a>
                <a class="btn-secondary btn" href="#" onclick="showStatusModal(${order.order_id}, '${order.status}')">Cập nhật trạng thái</a>
                <form method="post" action="${pageContext.request.contextPath}/admin/orders/delete" onsubmit="return confirm('Xóa đơn hàng #${order.order_id}?')">
                    <input type="hidden" name="id" value="${order.order_id}"/>
                    <button class="btn btn-danger" type="submit">Xóa</button>
                </form>
            </div>
        </div>
        <p>Trạng thái đơn: <span class="status ${order.status}">${order.status}</span></p>
        <p>Trạng thái thanh toán: <span class="status ${order.payment_status}">${order.payment_status}</span></p>
        <p>Tổng tiền: <strong><fmt:formatNumber value="${order.total_amount}" type="number" groupingUsed="true"/> ${order.currency}</strong></p>
        <p>Ngày tạo: <fmt:formatDate value="${order.created_at}" pattern="dd/MM/yyyy HH:mm"/></p>
        <div style="display:grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap:16px;">
            <div class="card">
                <h3>Khách hàng</h3>
                <p>${order.buyer_id.full_name}</p>
                <p>${order.buyer_id.email}</p>
            </div>
            <div class="card">
                <h3>Người bán</h3>
                <p>${order.seller_id.full_name}</p>
                <p>${order.seller_id.email}</p>
            </div>
            <div class="card">
                <h3>Giao hàng</h3>
                <c:choose>
                    <c:when test="${not empty order.shipping_method}">
                        <p>Địa chỉ: ${order.shipping_address}</p>
                        <p>Phương thức: ${order.shipping_method}</p>
                        <p>Mã vận đơn: ${order.tracking_number}</p>
                    </c:when>
                    <c:otherwise>
                        <p>Hình thức: <strong>Giao tức thì (Digital)</strong></p>
                        <p>Không có vận chuyển vật lý.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <div class="card">
        <h3>Sản phẩm trong đơn</h3>

        <!-- Bảng sản phẩm vật lý (nếu có) -->
        <c:if test="${not empty orderItems}">
            <table>
                <thead>
                    <tr>
                        <th>Mã SP</th>
                        <th>Tên sản phẩm</th>
                        <th>Số lượng</th>
                        <th>Đơn giá</th>
                        <th>Tạm tính</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="it" items="${orderItems}">
                        <tr>
                            <td>${it.productId.product_id}</td>
                            <td>${it.productId.name}</td>
                            <td>${it.quantity}</td>
                            <td><fmt:formatNumber value="${it.priceAtPurchase}" type="number" groupingUsed="true"/></td>
                            <td><fmt:formatNumber value="${it.subtotal}" type="number" groupingUsed="true"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>

        <!-- Bảng sản phẩm số (Digital) hiển thị chung trong cùng thẻ -->
        <c:if test="${not empty digitalItems}">
            <div style="margin-top:16px"></div>
            <h3 style="margin:12px 0 6px 0; font-size:18px;">Sản phẩm số (Digital)</h3>
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Tên sản phẩm</th>
                        <th>Mã/Code</th>
                        <th>Serial</th>
                        <th>Mật khẩu</th>
                        <th>Hết hạn</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="di" items="${digitalItems}" varStatus="s">
                        <tr>
                            <td>${s.index+1}</td>
                            <td>${di.productName}</td>
                            <td>${di.code}</td>
                            <td>${empty di.serial ? '-' : di.serial}</td>
                            <td>${empty di.password ? '-' : di.password}</td>
                            <td><c:out value="${di.expiresAt}"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>

        <!-- Nếu hoàn toàn không có sản phẩm -->
        <c:if test="${empty orderItems and empty digitalItems}">
            <div style="padding:12px; text-align:center; color:#888;">Không có sản phẩm trong đơn.</div>
        </c:if>
    </div>
</div>

<!-- Modal cập nhật trạng thái -->
<div id="statusModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.5); z-index:1000;">
  <div style="position:absolute; top:50%; left:50%; transform:translate(-50%,-50%); background:#fff; padding:24px; border-radius:12px; min-width:380px;">
    <h3 style="margin-top:0">Cập nhật trạng thái</h3>
    <form method="post" action="${pageContext.request.contextPath}/admin/orders/update-status">
      <input type="hidden" name="order_id" id="modalOrderId" />
      <div style="margin-bottom:12px;">
        <label>Trạng thái mới</label>
        <select name="status" id="modalStatus" style="width:100%; padding:10px; border:1px solid #ddd; border-radius:8px;">
          <option value="paid">Đã thanh toán</option>
          <option value="shipped">Đã giao</option>
          <option value="delivered">Hoàn thành</option>
          <option value="cancelled">Hủy đơn</option>
          <option value="refunded">Hoàn tiền</option>
        </select>
      </div>
      <div style="display:flex; gap:8px; justify-content:flex-end;">
        <button type="button" class="btn btn-secondary" onclick="hideStatusModal()">Đóng</button>
        <button type="submit" class="btn">Cập nhật</button>
      </div>
    </form>
  </div>
</div>
<script>
function showStatusModal(id, current) {
  document.getElementById('modalOrderId').value = id;
  document.getElementById('modalStatus').value = current === 'pending' ? 'paid' : current;
  document.getElementById('statusModal').style.display = 'block';
}
function hideStatusModal() { document.getElementById('statusModal').style.display = 'none'; }
</script>
</body>
</html>