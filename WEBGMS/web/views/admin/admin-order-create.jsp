<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Tạo đơn hàng - Admin</title>
  <style>
    body { font-family:Poppins, sans-serif; background:#fff8f2; margin:0 }
    .main{ margin-left:260px; padding:40px }
    .card{ background:#fff; padding:24px; border-radius:12px; box-shadow:0 2px 10px rgba(0,0,0,.08) }
    .form-grid{ display:grid; grid-template-columns: repeat(auto-fit, minmax(260px,1fr)); gap:16px }
    .form-group{ display:flex; flex-direction:column }
    .form-group input, .form-group select, .form-group textarea{ padding:10px; border:1px solid #ddd; border-radius:8px }
    .btn{ background:#ff6600; color:#fff; border:none; padding:10px 16px; border-radius:8px; cursor:pointer; font-weight:600 }
    .btn-secondary{ background:#fff; color:#333; border:1px solid #eee }
  </style>
</head>
<body>
<jsp:include page="/views/component/sidebar.jsp" />
<jsp:include page="/views/component/headerAdmin.jsp" />
<div class="main">
  <div class="card">
    <h2>Tạo đơn hàng</h2>
    <form method="post" action="${pageContext.request.contextPath}/admin/orders/save">
      <div class="form-grid">
        <div class="form-group">
          <label>Buyer ID</label>
          <input name="buyer_id" type="number" required />
        </div>
        <div class="form-group">
          <label>Seller ID</label>
          <input name="seller_id" type="number" required />
        </div>
        <div class="form-group">
          <label>Tổng tiền</label>
          <input name="total_amount" type="number" step="0.01" required />
        </div>
        <div class="form-group">
          <label>Tiền tệ</label>
          <input name="currency" value="VND" />
        </div>
        <div class="form-group">
          <label>Trạng thái</label>
          <select name="status">
            <option value="pending">Chờ thanh toán</option>
            <option value="paid">Đã thanh toán</option>
          </select>
        </div>
        <div class="form-group">
          <label>Phương thức vận chuyển</label>
          <input name="shipping_method" />
        </div>
        <div class="form-group" style="grid-column: 1 / -1;">
          <label>Địa chỉ giao hàng</label>
          <textarea name="shipping_address" rows="3"></textarea>
        </div>
        <div class="form-group" style="grid-column: 1 / -1;">
          <label>Mã vận đơn</label>
          <input name="tracking_number" />
        </div>
      </div>
      <div style="margin-top:16px; display:flex; gap:8px;">
        <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-secondary">Hủy</a>
        <button type="submit" class="btn">Lưu</button>
      </div>
    </form>
  </div>
</div>
</body>
</html>