<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đóng shop - Gicungco Seller</title>
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: #fff8f2;
            min-height: 100vh;
        }

        .main {
            margin-left: 260px;
            padding: 40px;
            background-color: #fff8f2;
            min-height: 100vh;
        }

        .page-header {
            margin-bottom: 30px;
        }

        .page-header h1 {
            color: #333;
            font-size: 28px;
            margin-bottom: 10px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .breadcrumb {
            color: #666;
            font-size: 14px;
        }

        /* Alert Messages */
        .alert {
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .alert-warning {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeeba;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        /* Statistics Cards */
        .stats-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
        }

        .stat-card h3 {
            font-size: 14px;
            color: #666;
            margin-bottom: 10px;
            font-weight: 500;
        }

        .stat-card .value {
            font-size: 28px;
            font-weight: 700;
            color: #333;
        }

        .stat-card.info .value {
            color: #17a2b8;
        }

        .stat-card.warning .value {
            color: #ffc107;
        }

        .stat-card.danger .value {
            color: #dc3545;
        }

        /* Card */
        .card {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }

        .card h2 {
            color: #333;
            font-size: 20px;
            margin-bottom: 20px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Warning Box */
        .warning-box {
            background: #fff3cd;
            border: 2px solid #ffc107;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
        }

        .warning-box h3 {
            color: #856404;
            font-size: 18px;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .warning-box ul {
            margin-left: 30px;
            color: #856404;
            line-height: 1.8;
        }

        .warning-box li {
            margin-bottom: 8px;
        }

        /* Form */
        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
            font-size: 14px;
        }

        .form-group label .required {
            color: #dc3545;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 14px;
            transition: all 0.3s;
            font-family: 'Poppins', sans-serif;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #ff6600;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 120px;
        }

        .form-help {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }

        /* Buttons */
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #ff6600 0%, #ff7b00 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 102, 0, 0.3);
        }

        .btn-primary:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
        }

        .btn-danger {
            background: #dc3545;
            color: white;
        }

        .btn-danger:hover {
            background: #c82333;
        }

        /* Current Request Display */
        .request-info {
            background: #f8f9fa;
            border: 2px solid #dee2e6;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
        }

        .request-info h3 {
            color: #333;
            font-size: 16px;
            margin-bottom: 15px;
        }

        .request-info p {
            color: #666;
            margin-bottom: 10px;
            line-height: 1.6;
        }

        /* Confirmation Modal */
        .modal {
            display: none;
            position: fixed;
            z-index: 2000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }

        .modal-content {
            background-color: white;
            margin: 10% auto;
            padding: 30px;
            border-radius: 15px;
            width: 500px;
            max-width: 90%;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }

        .modal-header {
            margin-bottom: 20px;
        }

        .modal-header h3 {
            color: #dc3545;
            font-size: 22px;
        }

        .modal-body {
            margin-bottom: 20px;
        }

        .modal-footer {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }

        @media (max-width: 768px) {
            .main {
                margin-left: 0;
                padding: 20px;
            }
        }
    </style>
</head>
<body>

    <!-- Include Sidebar -->
    <jsp:include page="../component/seller-sidebar.jsp">
        <jsp:param name="activePage" value="close-shop" />
    </jsp:include>

    <div class="main">
        <!-- Page Header -->
        <div class="page-header">
            <h1><i class="bi bi-x-circle"></i> Đóng shop</h1>
            <div class="breadcrumb">
                <a href="${pageContext.request.contextPath}/seller/dashboard" style="color: #666; text-decoration: none;">Trang chủ</a> 
                <span> / </span>
                <span>Đóng shop</span>
            </div>
        </div>

        <!-- Success/Error Messages -->
        <c:if test="${not empty param.success}">
            <div class="alert alert-success">
                <i class="bi bi-check-circle"></i>
                <span>Yêu cầu đóng shop của bạn đã được gửi thành công! Vui lòng chờ admin xét duyệt.</span>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <i class="bi bi-exclamation-triangle"></i>
                <span>${error}</span>
            </div>
        </c:if>

        <!-- Warning Box -->
        <div class="warning-box">
            <h3><i class="bi bi-exclamation-triangle-fill"></i> Cảnh báo quan trọng</h3>
            <ul>
                <li>Hành động này sẽ <strong>đóng shop của bạn vĩnh viễn</strong></li>
                <li>Shop sẽ không thể hoạt động trở lại sau khi được đóng</li>
                <li>Tất cả sản phẩm của bạn sẽ bị vô hiệu hóa</li>
                <li>Bạn vẫn có thể xem lịch sử đơn hàng và thống kê cũ</li>
                <li>Tiền cọc sẽ được hoàn lại sau khi admin phê duyệt</li>
            </ul>
        </div>

        <!-- Statistics -->
        <div class="stats-cards">
            <div class="stat-card info">
                <h3><i class="bi bi-cart"></i> Tổng đơn hàng</h3>
                <div class="value">${totalOrders}</div>
            </div>
            <div class="stat-card warning">
                <h3><i class="bi bi-clock-history"></i> Đơn đang chờ xử lý</h3>
                <div class="value">${pendingOrders}</div>
            </div>
            <c:if test="${not empty seller}">
            <div class="stat-card">
                <h3><i class="bi bi-wallet2"></i> Tiền cọc</h3>
                <div class="value"><fmt:formatNumber value="${seller.depositAmount}" type="number" maxFractionDigits="0"/>đ</div>
            </div>
            </c:if>
        </div>

        <!-- Check if there are pending orders -->
        <c:if test="${pendingOrders > 0}">
            <div class="alert alert-warning">
                <i class="bi bi-exclamation-triangle"></i>
                <strong>Lưu ý:</strong> Bạn có <strong>${pendingOrders}</strong> đơn hàng đang chờ xử lý. 
                Vui lòng hoàn thành tất cả đơn hàng trước khi yêu cầu đóng shop.
            </div>
        </c:if>

        <!-- Form Card -->
        <div class="card">
            <h2><i class="bi bi-file-text"></i> Thông tin yêu cầu đóng shop</h2>

            <form method="post" action="${pageContext.request.contextPath}/seller/close-shop" id="closeShopForm">
                
                <!-- Reason -->
                <div class="form-group">
                    <label for="reason">Lý do đóng shop <span class="required">*</span></label>
                    <textarea id="reason" name="reason" 
                              placeholder="Vui lòng nêu rõ lý do bạn muốn đóng shop (tối thiểu 20 ký tự)..."
                              required
                              minlength="20"
                              <c:if test="${pendingOrders > 0}">disabled</c:if>></textarea>
                    <div class="form-help">Vui lòng mô tả chi tiết lý do đóng shop của bạn</div>
                </div>

                <!-- Bank Information -->
                <h3 style="color: #333; font-size: 18px; margin: 25px 0 15px 0; font-weight: 600;">
                    <i class="bi bi-bank"></i> Thông tin nhận hoàn tiền cọc
                </h3>

                <div class="form-group">
                    <label for="bankName">Tên ngân hàng <span class="required">*</span></label>
                    <select id="bankName" name="bankName" required
                            <c:if test="${pendingOrders > 0}">disabled</c:if>>
                        <option value="">-- Chọn ngân hàng --</option>
                        <option value="Vietcombank" ${seller.bankName == 'Vietcombank' ? 'selected' : ''}>Vietcombank - Ngân hàng Ngoại thương Việt Nam</option>
                        <option value="BIDV" ${seller.bankName == 'BIDV' ? 'selected' : ''}>BIDV - Ngân hàng Đầu tư và Phát triển Việt Nam</option>
                        <option value="Vietinbank" ${seller.bankName == 'Vietinbank' ? 'selected' : ''}>Vietinbank - Ngân hàng Công thương Việt Nam</option>
                        <option value="Agribank" ${seller.bankName == 'Agribank' ? 'selected' : ''}>Agribank - Ngân hàng Nông nghiệp và Phát triển Nông thôn</option>
                        <option value="Techcombank" ${seller.bankName == 'Techcombank' ? 'selected' : ''}>Techcombank - Ngân hàng Kỹ thương Việt Nam</option>
                        <option value="ACB" ${seller.bankName == 'ACB' ? 'selected' : ''}>ACB - Ngân hàng Á Châu</option>
                        <option value="MBBank" ${seller.bankName == 'MBBank' ? 'selected' : ''}>MBBank - Ngân hàng Quân đội</option>
                        <option value="VPBank" ${seller.bankName == 'VPBank' ? 'selected' : ''}>VPBank - Ngân hàng Việt Nam Thịnh Vượng</option>
                        <option value="TPBank" ${seller.bankName == 'TPBank' ? 'selected' : ''}>TPBank - Ngân hàng Tiên Phong</option>
                        <option value="Sacombank" ${seller.bankName == 'Sacombank' ? 'selected' : ''}>Sacombank - Ngân hàng TMCP Sài Gòn Thương Tín</option>
                        <option value="VIB" ${seller.bankName == 'VIB' ? 'selected' : ''}>VIB - Ngân hàng Quốc tế</option>
                        <option value="SHB" ${seller.bankName == 'SHB' ? 'selected' : ''}>SHB - Ngân hàng Sài Gòn - Hà Nội</option>
                        <option value="HDBank" ${seller.bankName == 'HDBank' ? 'selected' : ''}>HDBank - Ngân hàng Phát triển Thành phố Hồ Chí Minh</option>
                        <option value="Eximbank" ${seller.bankName == 'Eximbank' ? 'selected' : ''}>Eximbank - Ngân hàng Xuất Nhập khẩu Việt Nam</option>
                        <option value="MSB" ${seller.bankName == 'MSB' ? 'selected' : ''}>MSB - Ngân hàng Hàng Hải</option>
                        <option value="SeABank" ${seller.bankName == 'SeABank' ? 'selected' : ''}>SeABank - Ngân hàng Đông Nam Á</option>
                        <option value="PVcomBank" ${seller.bankName == 'PVcomBank' ? 'selected' : ''}>PVcomBank - Ngân hàng Đại Chúng</option>
                        <option value="OCB" ${seller.bankName == 'OCB' ? 'selected' : ''}>OCB - Ngân hàng Phương Đông</option>
                        <option value="NCB" ${seller.bankName == 'NCB' ? 'selected' : ''}>NCB - Ngân hàng Quốc Dân</option>
                        <option value="NamABank" ${seller.bankName == 'NamABank' ? 'selected' : ''}>NamABank - Ngân hàng Nam Á</option>
                        <option value="ABBank" ${seller.bankName == 'ABBank' ? 'selected' : ''}>ABBank - Ngân hàng An Bình</option>
                        <option value="VietABank" ${seller.bankName == 'VietABank' ? 'selected' : ''}>VietABank - Ngân hàng Việt Á</option>
                        <option value="BacABank" ${seller.bankName == 'BacABank' ? 'selected' : ''}>BacABank - Ngân hàng Bắc Á</option>
                        <option value="PGBank" ${seller.bankName == 'PGBank' ? 'selected' : ''}>PGBank - Ngân hàng Xăng dầu Petrolimex</option>
                        <option value="PublicBank" ${seller.bankName == 'PublicBank' ? 'selected' : ''}>PublicBank - Ngân hàng Đại chúng</option>
                        <option value="KienLongBank" ${seller.bankName == 'KienLongBank' ? 'selected' : ''}>KienLongBank - Ngân hàng Kiên Long</option>
                        <option value="LPBank" ${seller.bankName == 'LPBank' ? 'selected' : ''}>LPBank - Ngân hàng Lào - Việt</option>
                        <option value="HSBC" ${seller.bankName == 'HSBC' ? 'selected' : ''}>HSBC - Ngân hàng TNHH MTV HSBC</option>
                        <option value="Standard Chartered" ${seller.bankName == 'Standard Chartered' ? 'selected' : ''}>Standard Chartered - Ngân hàng TNHH Standard Chartered</option>
                        <option value="HongLeong" ${seller.bankName == 'HongLeong' ? 'selected' : ''}>HongLeong Bank - Ngân hàng TNHH MTV Hong Leong Việt Nam</option>
                        <option value="Woori" ${seller.bankName == 'Woori' ? 'selected' : ''}>Woori Bank - Ngân hàng TNHH MTV Woori Việt Nam</option>
                        <option value="Shinhan" ${seller.bankName == 'Shinhan' ? 'selected' : ''}>Shinhan Bank - Ngân hàng TNHH MTV Shinhan Việt Nam</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="bankAccount">Số tài khoản <span class="required">*</span></label>
                    <input type="text" id="bankAccount" name="bankAccount" 
                           value="${seller.bankAccount}"
                           placeholder="Nhập số tài khoản ngân hàng"
                           required
                           <c:if test="${pendingOrders > 0}">disabled</c:if>>
                </div>

                <div class="form-group">
                    <label for="accountOwner">Tên chủ tài khoản <span class="required">*</span></label>
                    <input type="text" id="accountOwner" name="accountOwner" 
                           value="${seller.accountOwner}"
                           placeholder="Nhập tên chủ tài khoản (IN HOA)"
                           required
                           <c:if test="${pendingOrders > 0}">disabled</c:if>>
                    <div class="form-help">Vui lòng nhập tên chủ tài khoản đúng như trên tài khoản ngân hàng</div>
                </div>

                <!-- Buttons -->
                <div style="margin-top: 30px; display: flex; gap: 10px; justify-content: flex-end;">
                    <a href="${pageContext.request.contextPath}/seller/dashboard" class="btn btn-secondary">
                        <i class="bi bi-x-lg"></i> Hủy
                    </a>
                    <button type="button" class="btn btn-danger" 
                            onclick="showConfirmModal()"
                            <c:if test="${pendingOrders > 0}">disabled</c:if>>
                        <i class="bi bi-exclamation-triangle"></i> Gửi yêu cầu đóng shop
                    </button>
                </div>

            </form>
        </div>

    </div>

    <!-- Confirmation Modal -->
    <div id="confirmModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="bi bi-exclamation-triangle"></i> Xác nhận đóng shop</h3>
            </div>
            <div class="modal-body">
                <p><strong>Bạn có chắc chắn muốn đóng shop không?</strong></p>
                <p style="color: #666; margin-top: 10px;">
                    Hành động này không thể hoàn tác. Shop của bạn sẽ bị đóng vĩnh viễn sau khi admin phê duyệt.
                </p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeConfirmModal()">
                    <i class="bi bi-x-lg"></i> Hủy
                </button>
                <button type="submit" form="closeShopForm" class="btn btn-danger">
                    <i class="bi bi-check-lg"></i> Xác nhận đóng shop
                </button>
            </div>
        </div>
    </div>

    <script>
        function showConfirmModal() {
            document.getElementById('confirmModal').style.display = 'block';
        }

        function closeConfirmModal() {
            document.getElementById('confirmModal').style.display = 'none';
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('confirmModal');
            if (event.target == modal) {
                closeConfirmModal();
            }
        }

        // Form validation
        document.getElementById('closeShopForm').addEventListener('submit', function(e) {
            const reason = document.getElementById('reason').value.trim();
            if (reason.length < 20) {
                e.preventDefault();
                alert('Lý do đóng shop phải có ít nhất 20 ký tự!');
                return false;
            }
        });
    </script>
</body>
</html>


