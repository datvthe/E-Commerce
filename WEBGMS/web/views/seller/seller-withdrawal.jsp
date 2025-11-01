<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Rút tiền - Giicungco Seller</title>
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

        /* Balance Cards */
        .balance-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .balance-card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
        }

        .balance-card h3 {
            font-size: 14px;
            color: #666;
            margin-bottom: 10px;
            font-weight: 500;
        }

        .balance-card .amount {
            font-size: 28px;
            font-weight: 700;
            color: #333;
        }

        .balance-card.primary .amount {
            color: #ff6b35;
        }

        .balance-card.success .amount {
            color: #28a745;
        }

        .balance-card.warning .amount {
            color: #ffc107;
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
            border-color: #ff6b35;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
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
            background: linear-gradient(135deg, #ff6b35 0%, #ff8c42 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 107, 53, 0.3);
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

        /* Table */
        .table-responsive {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        table th,
        table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }

        table th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #333;
            font-size: 14px;
        }

        table td {
            font-size: 14px;
            color: #666;
        }

        table tr:hover {
            background-color: #f8f9fa;
        }

        /* Status Badge */
        .badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .badge-warning {
            background-color: #fff3cd;
            color: #856404;
        }

        .badge-info {
            background-color: #d1ecf1;
            color: #0c5460;
        }

        .badge-primary {
            background-color: #cfe2ff;
            color: #084298;
        }

        .badge-success {
            background-color: #d1e7dd;
            color: #0f5132;
        }

        .badge-danger {
            background-color: #f8d7da;
            color: #842029;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }

        .empty-state i {
            font-size: 80px;
            margin-bottom: 20px;
            opacity: 0.3;
        }

        .empty-state p {
            font-size: 16px;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .main {
                margin-left: 0;
                padding: 20px;
            }

            .balance-cards {
                grid-template-columns: 1fr;
            }

            table {
                font-size: 12px;
            }

            table th,
            table td {
                padding: 10px;
            }
        }

        /* Info Box */
        .info-box {
            background-color: #e7f3ff;
            border-left: 4px solid #2196F3;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
        }

        .info-box h4 {
            color: #1976D2;
            margin-bottom: 10px;
            font-size: 16px;
        }

        .info-box ul {
            margin-left: 20px;
            color: #666;
        }

        .info-box ul li {
            margin-bottom: 5px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <jsp:include page="/views/component/seller-sidebar.jsp" />

    <div class="main">
        <div class="page-header">
            <h1>
                <i class="bi bi-wallet2"></i>
                Rút tiền
            </h1>
            <div class="breadcrumb">
                <a href="${pageContext.request.contextPath}/seller/dashboard">Dashboard</a> / Rút tiền
            </div>
        </div>

        <!-- Alert Messages -->
        <c:if test="${param.success == 'request_created'}">
            <div class="alert alert-success">
                <i class="bi bi-check-circle-fill"></i>
                Yêu cầu rút tiền đã được gửi thành công! Admin sẽ xem xét và xử lý trong thời gian sớm nhất.
            </div>
        </c:if>

        <c:if test="${param.success == 'request_cancelled'}">
            <div class="alert alert-success">
                <i class="bi bi-check-circle-fill"></i>
                Đã hủy yêu cầu rút tiền thành công.
            </div>
        </c:if>

        <c:if test="${param.error == 'already_has_pending'}">
            <div class="alert alert-error">
                <i class="bi bi-exclamation-triangle-fill"></i>
                Bạn đã có yêu cầu rút tiền đang chờ xử lý. Vui lòng đợi admin xử lý hoặc hủy yêu cầu cũ trước.
            </div>
        </c:if>

        <c:if test="${param.error == 'insufficient_balance'}">
            <div class="alert alert-error">
                <i class="bi bi-exclamation-triangle-fill"></i>
                Số dư không đủ để thực hiện yêu cầu rút tiền này.
            </div>
        </c:if>

        <c:if test="${param.error == 'amount_too_low'}">
            <div class="alert alert-error">
                <i class="bi bi-exclamation-triangle-fill"></i>
                Số tiền rút tối thiểu là 100,000 VNĐ.
            </div>
        </c:if>

        <c:if test="${param.error == 'missing_fields'}">
            <div class="alert alert-error">
                <i class="bi bi-exclamation-triangle-fill"></i>
                Vui lòng điền đầy đủ thông tin.
            </div>
        </c:if>

        <!-- Balance Cards -->
        <div class="balance-cards">
            <div class="balance-card primary">
                <h3>Số dư khả dụng</h3>
                <div class="amount">
                    <fmt:formatNumber value="${withdrawableAmount}" pattern="#,###" /> ₫
                </div>
            </div>
            <div class="balance-card warning">
                <h3>Đang chờ xử lý</h3>
                <div class="amount">
                    <fmt:formatNumber value="${pendingAmount}" pattern="#,###" /> ₫
                </div>
            </div>
            <div class="balance-card success">
                <h3>Tổng đã rút</h3>
                <div class="amount">
                    <fmt:formatNumber value="${totalWithdrawn}" pattern="#,###" /> ₫
                </div>
            </div>
        </div>

        <!-- Withdrawal Request Form -->
        <div class="card">
            <h2>Tạo yêu cầu rút tiền</h2>

            <c:if test="${hasActivePending}">
                <div class="alert alert-warning">
                    <i class="bi bi-info-circle-fill"></i>
                    Bạn đã có yêu cầu rút tiền đang chờ xử lý. Vui lòng đợi admin xử lý trước khi tạo yêu cầu mới.
                </div>
            </c:if>

            <div class="info-box">
                <h4><i class="bi bi-info-circle"></i> Lưu ý quan trọng:</h4>
                <ul>
                    <li>Số tiền rút tối thiểu: <strong>100,000 VNĐ</strong></li>
                    <li>Thời gian xử lý: <strong>1-3 ngày làm việc</strong></li>
                    <li>Admin sẽ xem xét và chuyển tiền vào tài khoản ngân hàng của bạn</li>
                    <li>Vui lòng kiểm tra kỹ thông tin ngân hàng trước khi gửi</li>
                </ul>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/seller/withdrawal">
                <input type="hidden" name="action" value="create">

                <div class="form-group">
                    <label>Số tiền rút <span class="required">*</span></label>
                    <input type="number" name="amount" required min="100000" step="1000" 
                           placeholder="Nhập số tiền (tối thiểu 100,000 VNĐ)"
                           max="${withdrawableAmount}">
                    <div class="form-help">
                        Số dư khả dụng: <fmt:formatNumber value="${withdrawableAmount}" pattern="#,###" /> ₫
                    </div>
                </div>

                <div class="form-group">
                    <label>Ngân hàng <span class="required">*</span></label>
                    <select name="bankName" required>
                        <option value="">-- Chọn ngân hàng --</option>
                        <option value="Vietcombank">Vietcombank - Ngân hàng Ngoại thương Việt Nam</option>
                        <option value="BIDV">BIDV - Ngân hàng Đầu tư và Phát triển Việt Nam</option>
                        <option value="Vietinbank">Vietinbank - Ngân hàng Công thương Việt Nam</option>
                        <option value="Agribank">Agribank - Ngân hàng Nông nghiệp và Phát triển Nông thôn</option>
                        <option value="Techcombank">Techcombank - Ngân hàng Kỹ thương Việt Nam</option>
                        <option value="ACB">ACB - Ngân hàng Á Châu</option>
                        <option value="MBBank">MBBank - Ngân hàng Quân đội</option>
                        <option value="VPBank">VPBank - Ngân hàng Việt Nam Thịnh Vượng</option>
                        <option value="TPBank">TPBank - Ngân hàng Tiên Phong</option>
                        <option value="Sacombank">Sacombank - Ngân hàng TMCP Sài Gòn Thương Tín</option>
                        <option value="VIB">VIB - Ngân hàng Quốc tế</option>
                        <option value="SHB">SHB - Ngân hàng Sài Gòn - Hà Nội</option>
                        <option value="HDBank">HDBank - Ngân hàng Phát triển Thành phố Hồ Chí Minh</option>
                        <option value="Eximbank">Eximbank - Ngân hàng Xuất Nhập khẩu Việt Nam</option>
                        <option value="MSB">MSB - Ngân hàng Hàng Hải</option>
                        <option value="SeABank">SeABank - Ngân hàng Đông Nam Á</option>
                        <option value="PVcomBank">PVcomBank - Ngân hàng Đại Chúng</option>
                        <option value="OCB">OCB - Ngân hàng Phương Đông</option>
                        <option value="NCB">NCB - Ngân hàng Quốc Dân</option>
                        <option value="NamABank">NamABank - Ngân hàng Nam Á</option>
                        <option value="ABBank">ABBank - Ngân hàng An Bình</option>
                        <option value="VietABank">VietABank - Ngân hàng Việt Á</option>
                        <option value="BacABank">BacABank - Ngân hàng Bắc Á</option>
                        <option value="PGBank">PGBank - Ngân hàng Xăng dầu Petrolimex</option>
                        <option value="PublicBank">PublicBank - Ngân hàng Đại chúng</option>
                        <option value="KienLongBank">KienLongBank - Ngân hàng Kiên Long</option>
                        <option value="LPBank">LPBank - Ngân hàng Lào - Việt</option>
                        <option value="HSBC">HSBC - Ngân hàng TNHH MTV HSBC</option>
                        <option value="Standard Chartered">Standard Chartered - Ngân hàng TNHH Standard Chartered</option>
                        <option value="HongLeong">HongLeong Bank - Ngân hàng TNHH MTV Hong Leong Việt Nam</option>
                        <option value="Woori">Woori Bank - Ngân hàng TNHH MTV Woori Việt Nam</option>
                        <option value="Shinhan">Shinhan Bank - Ngân hàng TNHH MTV Shinhan Việt Nam</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Số tài khoản <span class="required">*</span></label>
                    <input type="text" name="bankAccountNumber" required 
                           placeholder="Nhập số tài khoản ngân hàng">
                </div>

                <div class="form-group">
                    <label>Tên chủ tài khoản <span class="required">*</span></label>
                    <input type="text" name="bankAccountName" required 
                           placeholder="Nhập tên chủ tài khoản (theo CMND/CCCD)">
                    <div class="form-help">
                        Tên chủ tài khoản phải trùng với tên đăng ký kinh doanh
                    </div>
                </div>

                <div class="form-group">
                    <label>Ghi chú</label>
                    <textarea name="requestNote" 
                              placeholder="Ghi chú thêm (nếu có)..."></textarea>
                </div>

                <button type="submit" class="btn btn-primary" ${hasActivePending ? 'disabled' : ''}>
                    <i class="bi bi-send"></i>
                    Gửi yêu cầu rút tiền
                </button>
            </form>
        </div>

        <!-- Withdrawal History -->
        <div class="card">
            <h2>Lịch sử rút tiền</h2>

            <c:choose>
                <c:when test="${not empty withdrawalHistory}">
                    <div class="table-responsive">
                        <table>
                            <thead>
                                <tr>
                                    <th>Mã YC</th>
                                    <th>Số tiền</th>
                                    <th>Ngân hàng</th>
                                    <th>Số TK</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày yêu cầu</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="request" items="${withdrawalHistory}">
                                    <tr>
                                        <td>#${request.requestId}</td>
                                        <td><strong><fmt:formatNumber value="${request.amount}" pattern="#,###" /> ₫</strong></td>
                                        <td>${request.bankName}</td>
                                        <td>${request.bankAccountNumber}</td>
                                        <td>
                                            <span class="badge ${request.statusBadgeClass}">
                                                ${request.statusLabel}
                                            </span>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${request.requestedAt}" 
                                                          pattern="dd/MM/yyyy HH:mm" />
                                        </td>
                                        <td>
                                            <c:if test="${request.pending}">
                                                <form method="post" style="display:inline;" 
                                                      onsubmit="return confirm('Bạn có chắc muốn hủy yêu cầu này?');">
                                                    <input type="hidden" name="action" value="cancel">
                                                    <input type="hidden" name="requestId" value="${request.requestId}">
                                                    <button type="submit" class="btn btn-danger" style="padding: 6px 12px; font-size: 12px;">
                                                        <i class="bi bi-x-circle"></i> Hủy
                                                    </button>
                                                </form>
                                            </c:if>
                                            <c:if test="${not request.pending}">
                                                <span style="color: #999; font-size: 12px;">Không thể hủy</span>
                                            </c:if>
                                        </td>
                                    </tr>
                                    <c:if test="${not empty request.adminNote}">
                                        <tr>
                                            <td colspan="7" style="background-color: #f8f9fa; padding: 10px 15px;">
                                                <strong>Ghi chú từ Admin:</strong> ${request.adminNote}
                                                <c:if test="${not empty request.transactionReference}">
                                                    <br><strong>Mã giao dịch:</strong> ${request.transactionReference}
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="bi bi-inbox"></i>
                        <p>Chưa có lịch sử rút tiền</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>


