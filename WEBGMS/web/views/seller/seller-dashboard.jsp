<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Cửa hàng của bạn | Gicungco</title>

        <!-- Bootstrap & Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

        <style>
            body {
                font-family: 'Segoe UI', sans-serif;
                background-color: #fff8f0;
                margin: 0;
            }

            /* Sidebar styles are now in component/seller-sidebar.jsp */

            /* Main content */
            .main {
                margin-left: 260px;
                padding: 30px;
            }

            .card {
                border: none;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            }

            .section-title {
                font-weight: 700;
                color: #ff7b00;
                margin-bottom: 20px;
            }

            .wallet-box {
                background-color: #ffe3c2;
                border-radius: 10px;
                padding: 20px;
            }

            .wallet-box h5 {
                color: #d95f00;
            }

            .btn-orange {
                background-color: #ff7b00;
                color: white;
                border: none;
                border-radius: 6px;
                transition: all 0.3s ease;
            }
            .btn-orange:hover {
                background-color: #e36c00;
            }


            .stat-box {
                background: white;
                border-radius: 12px;
                text-align: center;
                padding: 20px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            }

            .stat-number {
                font-size: 1.8rem;
                font-weight: 700;
                color: #ff7b00;
            }

            .stat-label {
                font-weight: 500;
                color: #555;
            }
        </style>
    </head>
    <body>

        <!-- Include Sidebar Component -->
        <jsp:include page="../component/seller-sidebar.jsp">
            <jsp:param name="activePage" value="dashboard" />
        </jsp:include>

        <!-- Main content -->
        <div class="main">
            <h2 class="fw-bold mb-4 text-dark">👋 Xin chào, <c:out value="${seller.shopName}"/>!</h2>

            <!-- Info + Wallet -->
            <div class="row mb-4">
                <div class="col-lg-8">
                    <div class="card p-4">
                        <h5 class="section-title">🏪 Thông tin cửa hàng</h5>
                        <p><strong>Tên cửa hàng:</strong> <c:out value="${seller.shopName}"/></p>
                        <p><strong>Mô tả:</strong> <c:out value="${seller.shopDescription}"/></p>
                        <p><strong>Danh mục chính:</strong> <c:out value="${seller.mainCategory}"/></p>
                        <p><strong>Ngân hàng:</strong> <c:out value="${seller.bankName}"/></p>
                        <p><strong>Số tài khoản:</strong> <c:out value="${seller.bankAccount}"/></p>
                        <p><strong>Chủ tài khoản:</strong> <c:out value="${seller.accountOwner}"/></p>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="wallet-box">
                        <h5><i class="bi bi-wallet2 me-2"></i>Số dư ví</h5>
                        <h2 class="fw-bold text-dark mt-2">
                            <fmt:formatNumber value="${walletBalance}" type="number" groupingUsed="true" maxFractionDigits="0"/> ₫
                        </h2>
                        <p class="text-muted mb-3">Số tiền hiện có trong ví của bạn</p>
                        <div class="d-grid gap-2">
                            <button class="btn btn-orange" data-bs-toggle="modal" data-bs-target="#withdrawModal">
                                <i class="bi bi-cash-stack me-1"></i> Rút tiền
                            </button>
                            <button class="btn btn-outline-dark">
                                <i class="bi bi-arrow-repeat me-1"></i> Cập nhật số dư
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Stats -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="stat-box">
                        <div class="stat-number">${totalProducts}</div>
                        <div class="stat-label">Tổng sản phẩm</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-box">
                        <div class="stat-number">${activeProducts}</div>
                        <div class="stat-label">Sản phẩm hoạt động</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-box">
                        <div class="stat-number">${totalOrders}</div>
                        <div class="stat-label">Tổng đơn hàng</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-box">
                        <div class="stat-number">${pendingOrders}</div>
                        <div class="stat-label">Đơn chờ xử lý</div>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="card p-4">
                <h5 class="section-title">⚙️ Tác vụ nhanh</h5>
                <div class="d-flex flex-wrap gap-3">
                    <a href="${pageContext.request.contextPath}/seller/products" class="btn btn-orange">
                        <i class="bi bi-box-seam me-1"></i> Quản lý sản phẩm
                    </a>
                    <a href="${pageContext.request.contextPath}/seller/orders" class="btn btn-orange">
                        <i class="bi bi-receipt me-1"></i> Xem đơn hàng
                    </a>
                    <a href="${pageContext.request.contextPath}/seller/orders" class="btn btn-orange">
                        <i class="bi bi-graph-up-arrow me-1"></i> Xem doanh thu
                    </a>
                    <a href="${pageContext.request.contextPath}/seller/profile" class="btn btn-orange">
                        <i class="bi bi-person-gear me-1"></i> Chỉnh sửa thông tin shop
                    </a>
                </div>
            </div>
        </div>

        <!-- 🟧 Modal Rút tiền -->
        <div class="modal fade" id="withdrawModal" tabindex="-1" aria-labelledby="withdrawModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <form action="${pageContext.request.contextPath}/seller/withdraw" method="post" class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="withdrawModalLabel"><i class="bi bi-cash-stack me-2"></i>Yêu cầu rút tiền</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Số tiền muốn rút (₫)</label>
                            <input type="number" name="amount" class="form-control" min="10000" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Ngân hàng</label>
                            <input type="text" name="bankName" class="form-control" value="${seller.bankName}" readonly>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Số tài khoản</label>
                            <input type="text" name="bankAccount" class="form-control" value="${seller.bankAccount}" readonly>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Chủ tài khoản</label>
                            <input type="text" name="accountOwner" class="form-control" value="${seller.accountOwner}" readonly>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-orange"><i class="bi bi-send"></i> Gửi yêu cầu</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Script -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
