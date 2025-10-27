<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý đơn hàng - Admin</title>
    <style>
        body { font-family: "Poppins", sans-serif; background: #fff8f2; margin: 0; }
        .main { margin-left: 260px; padding: 40px; }
        .card { background: #fff; padding: 24px; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,.08); }
        .title-bar { display:flex; align-items:center; justify-content:space-between; margin-bottom: 16px; }
        .btn { background:#ff6600; color:#fff; border:none; padding:8px 14px; border-radius:8px; cursor:pointer; font-weight:600; }
        .btn:hover { background:#e65c00; }
        table{ width:100%; border-collapse:collapse; margin-top:12px; }
        th,td{ padding:12px 14px; border-bottom:1px solid #f0f0f0; text-align:left; }
        th{ background:#fff3e6; color:#ff6600; }
        .status{ padding:5px 10px; border-radius:6px; color:#fff; text-transform:capitalize; font-size:13px; }
        .status.pending{ background:#ffc107; color:#333; }
        .status.paid{ background:#28a745; }
        .status.shipped{ background:#17a2b8; }
        .status.delivered{ background:#6f42c1; }
        .status.cancelled{ background:#dc3545; }
        .status.refunded{ background:#6c757d; }
        .actions{ display:flex; gap:8px; }
        .btn-secondary{ background:#fff; color:#333; border:1px solid #eee; }
        .btn-danger{ background:#dc3545; }
        .filters{ display:flex; gap:12px; align-items:flex-end; }
        .alert{ padding:10px 12px; border-radius:8px; margin-bottom:12px; }
        .alert-success{ background:#d4edda; border:1px solid #c3e6cb; color:#155724; }
        .alert-error{ background:#f8d7da; border:1px solid #f5c6cb; color:#721c24; }
        .pagination{ display:flex; gap:8px; justify-content:center; margin-top:16px; }
        .pagination a{ padding:8px 12px; border:1px solid #eee; border-radius:8px; text-decoration:none; color:#333; }
        .pagination a.current{ background:#ff6600; color:#fff; border-color:#ff6600; }
    </style>
</head>
<body>
<jsp:include page="/views/component/sidebar.jsp" />
<jsp:include page="/views/component/headerAdmin.jsp" />

<div class="main">
    <div class="title-bar">
        <div>
            <h1 style="margin:0">🧾 Quản lý đơn hàng</h1>
            <p class="subtitle" style="color:#777">Xem, tạo, cập nhật và xóa đơn hàng.</p>
        </div>
        <a class="btn" href="${pageContext.request.contextPath}/admin/orders/create">+ Tạo đơn mới</a>
    </div>

    <div class="card">
        <c:if test="${not empty success}"><div class="alert alert-success">${success}</div></c:if>
        <c:if test="${not empty error}"><div class="alert alert-error">${error}</div></c:if>

        <form method="get" action="${pageContext.request.contextPath}/admin/orders" class="filters">
            <div>
                <label>Trạng thái</label><br/>
                <select name="status" style="padding:8px 12px; border:1px solid #ddd; border-radius:8px;">
                    <option value="">-- Tất cả --</option>
                    <option value="pending" ${status == 'pending' ? 'selected' : ''}>Chờ thanh toán</option>
                    <option value="paid" ${status == 'paid' ? 'selected' : ''}>Đã thanh toán</option>
                    <option value="shipped" ${status == 'shipped' ? 'selected' : ''}>Đã giao</option>
                    <option value="delivered" ${status == 'delivered' ? 'selected' : ''}>Hoàn thành</option>
                    <option value="cancelled" ${status == 'cancelled' ? 'selected' : ''}>Đã hủy</option>
                    <option value="refunded" ${status == 'refunded' ? 'selected' : ''}>Đã hoàn tiền</option>
                </select>
            </div>
            <button type="submit" class="btn">Lọc</button>
        </form>

        <c:if test="${empty orders}">
            <div class="no-data" style="padding:40px; text-align:center; color:#888;">Chưa có đơn hàng nào.</div>
        </c:if>

        <c:if test="${not empty orders}">
            <table>
                <thead>
                    <tr>
                        <th>Mã đơn</th>
                        <th>Người mua</th>
                        <th>Người bán</th>
                        <th>Tổng tiền</th>
                        <th>Trạng thái</th>
                        <th>Ngày tạo</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="o" items="${orders}">
                        <tr>
                            <td>#${o.order_id}</td>
                            <td>
                                <div>${o.buyer_id.full_name}</div>
                                <div style="font-size:12px;color:#666">${o.buyer_id.email}</div>
                            </td>
                            <td>
                                <div>${o.seller_id.full_name}</div>
                                <div style="font-size:12px;color:#666">${o.seller_id.email}</div>
                            </td>
                            <td class="price"><fmt:formatNumber value="${o.total_amount}" type="number" groupingUsed="true"/> ${o.currency}</td>
                            <td><span class="status ${o.status}">${o.status}</span></td>
                            <td><fmt:formatDate value="${o.created_at}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td class="actions">
                                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/orders/view?id=${o.order_id}">Xem</a>
                                <a class="btn btn-secondary" href="#" onclick="showStatusModal(${o.order_id}, '${o.status}')">Cập nhật</a>
                                <form method="post" action="${pageContext.request.contextPath}/admin/orders/delete" style="display:inline" onsubmit="return confirm('Xóa đơn hàng #${o.order_id}?')">
                                    <input type="hidden" name="id" value="${o.order_id}" />
                                    <button class="btn btn-danger" type="submit">Xóa</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <a href="${pageContext.request.contextPath}/admin/orders?page=${i}&status=${status}" class="${i == currentPage ? 'current' : ''}">${i}</a>
                    </c:forEach>
                </div>
            </c:if>
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
function hideStatusModal() {
  document.getElementById('statusModal').style.display = 'none';
}
</script>
</body>
</html>