<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quản lý rút tiền - Admin</title>
</head>
<body>
    <jsp:include page="/views/component/sidebar.jsp" />

    <main class="main-wrapper">
        <jsp:include page="/views/component/headerAdmin.jsp" />

        <section class="section">
            <div class="container-fluid">
                <!-- Page Title -->
                <div class="title-wrapper pt-30">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <div class="title">
                                <h2>Quản lý yêu cầu rút tiền</h2>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="breadcrumb-wrapper">
                                <nav aria-label="breadcrumb">
                                    <ol class="breadcrumb">
                                        <li class="breadcrumb-item">
                                            <a href="<%= request.getContextPath() %>/admin/dashboard">Dashboard</a>
                                        </li>
                                        <li class="breadcrumb-item active" aria-current="page">
                                            Rút tiền
                                        </li>
                                    </ol>
                                </nav>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Alert Messages -->
                <c:if test="${param.success == 'approved'}">
                    <div class="alert alert-success alert-dismissible fade show mt-3" role="alert">
                        <strong>Thành công!</strong> Đã phê duyệt yêu cầu rút tiền.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${param.success == 'rejected'}">
                    <div class="alert alert-info alert-dismissible fade show mt-3" role="alert">
                        <strong>Đã xử lý!</strong> Đã từ chối yêu cầu rút tiền.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${param.success == 'completed'}">
                    <div class="alert alert-success alert-dismissible fade show mt-3" role="alert">
                        <strong>Hoàn thành!</strong> Đã hoàn thành chuyển tiền và cập nhật số dư.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${param.error == 'missing_reject_reason'}">
                    <div class="alert alert-danger alert-dismissible fade show mt-3" role="alert">
                        <strong>Lỗi!</strong> Vui lòng nhập lý do từ chối.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${param.error == 'missing_transaction_ref'}">
                    <div class="alert alert-danger alert-dismissible fade show mt-3" role="alert">
                        <strong>Lỗi!</strong> Vui lòng nhập mã giao dịch.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Filter Tabs -->
                <div class="row mt-4">
                    <div class="col-12">
                        <div class="card-style mb-30">
                            <ul class="nav nav-pills mb-3" role="tablist">
                                <li class="nav-item" role="presentation">
                                    <a class="nav-link ${currentFilter == 'all' ? 'active' : ''}" 
                                       href="<%= request.getContextPath() %>/admin/withdrawals">
                                        Tất cả
                                    </a>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <a class="nav-link ${currentFilter == 'pending' ? 'active' : ''}" 
                                       href="<%= request.getContextPath() %>/admin/withdrawals?status=pending">
                                        Chờ duyệt 
                                        <c:if test="${pendingCount > 0}">
                                            <span class="badge bg-warning">${pendingCount}</span>
                                        </c:if>
                                    </a>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <a class="nav-link ${currentFilter == 'approved' ? 'active' : ''}" 
                                       href="<%= request.getContextPath() %>/admin/withdrawals?status=approved">
                                        Đã duyệt
                                    </a>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <a class="nav-link ${currentFilter == 'processing' ? 'active' : ''}" 
                                       href="<%= request.getContextPath() %>/admin/withdrawals?status=processing">
                                        Đang xử lý
                                    </a>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <a class="nav-link ${currentFilter == 'completed' ? 'active' : ''}" 
                                       href="<%= request.getContextPath() %>/admin/withdrawals?status=completed">
                                        Hoàn thành
                                    </a>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <a class="nav-link ${currentFilter == 'rejected' ? 'active' : ''}" 
                                       href="<%= request.getContextPath() %>/admin/withdrawals?status=rejected">
                                        Từ chối
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Withdrawals Table -->
                <div class="row">
                    <div class="col-12">
                        <div class="card-style mb-30">
                            <div class="table-responsive">
                                <c:choose>
                                    <c:when test="${not empty withdrawalRequests}">
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Mã YC</th>
                                                    <th>Seller</th>
                                                    <th>Số tiền</th>
                                                    <th>Ngân hàng</th>
                                                    <th>Số TK</th>
                                                    <th>Tên TK</th>
                                                    <th>Trạng thái</th>
                                                    <th>Ngày YC</th>
                                                    <th>Hành động</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="request" items="${withdrawalRequests}">
                                                    <tr>
                                                        <td><strong>#${request.requestId}</strong></td>
                                                        <td>
                                                            <div><strong>${request.sellerName}</strong></div>
                                                            <div class="text-muted small">${request.sellerEmail}</div>
                                                        </td>
                                                        <td>
                                                            <strong style="color: #ff6b35;">
                                                                <fmt:formatNumber value="${request.amount}" pattern="#,###" /> ₫
                                                            </strong>
                                                        </td>
                                                        <td>${request.bankName}</td>
                                                        <td>${request.bankAccountNumber}</td>
                                                        <td>${request.bankAccountName}</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${request.statusValue == 'pending'}">
                                                                    <span class="badge bg-warning">${request.statusLabel}</span>
                                                                </c:when>
                                                                <c:when test="${request.statusValue == 'approved'}">
                                                                    <span class="badge bg-info">${request.statusLabel}</span>
                                                                </c:when>
                                                                <c:when test="${request.statusValue == 'processing'}">
                                                                    <span class="badge bg-primary">${request.statusLabel}</span>
                                                                </c:when>
                                                                <c:when test="${request.statusValue == 'completed'}">
                                                                    <span class="badge bg-success">${request.statusLabel}</span>
                                                                </c:when>
                                                                <c:when test="${request.statusValue == 'rejected'}">
                                                                    <span class="badge bg-danger">${request.statusLabel}</span>
                                                                </c:when>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <fmt:formatDate value="${request.requestedAt}" pattern="dd/MM/yyyy HH:mm" />
                                                        </td>
                                                        <td>
                                                            <button type="button" class="btn btn-sm btn-primary" 
                                                                    data-bs-toggle="modal" 
                                                                    data-bs-target="#detailModal${request.requestId}">
                                                                <i class="lni lni-eye"></i> Chi tiết
                                                            </button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-5">
                                            <i class="lni lni-inbox" style="font-size: 60px; color: #ccc;"></i>
                                            <p class="text-muted mt-3">Không có yêu cầu rút tiền nào</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <!-- Detail Modals -->
    <c:forEach var="request" items="${withdrawalRequests}">
        <div class="modal fade" id="detailModal${request.requestId}" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Chi tiết yêu cầu rút tiền #${request.requestId}</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <!-- Request Info -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <strong>Seller:</strong><br>
                                ${request.sellerName}<br>
                                <small class="text-muted">${request.sellerEmail}</small>
                            </div>
                            <div class="col-md-6">
                                <strong>Trạng thái:</strong><br>
                                <c:choose>
                                    <c:when test="${request.statusValue == 'pending'}">
                                        <span class="badge bg-warning">${request.statusLabel}</span>
                                    </c:when>
                                    <c:when test="${request.statusValue == 'approved'}">
                                        <span class="badge bg-info">${request.statusLabel}</span>
                                    </c:when>
                                    <c:when test="${request.statusValue == 'processing'}">
                                        <span class="badge bg-primary">${request.statusLabel}</span>
                                    </c:when>
                                    <c:when test="${request.statusValue == 'completed'}">
                                        <span class="badge bg-success">${request.statusLabel}</span>
                                    </c:when>
                                    <c:when test="${request.statusValue == 'rejected'}">
                                        <span class="badge bg-danger">${request.statusLabel}</span>
                                    </c:when>
                                </c:choose>
                            </div>
                        </div>

                        <hr>

                        <!-- Bank Info -->
                        <h6 class="mb-3">Thông tin ngân hàng</h6>
                        <div class="row mb-3">
                            <div class="col-md-4">
                                <strong>Số tiền:</strong><br>
                                <span style="font-size: 20px; color: #ff6b35; font-weight: bold;">
                                    <fmt:formatNumber value="${request.amount}" pattern="#,###" /> ₫
                                </span>
                            </div>
                            <div class="col-md-4">
                                <strong>Ngân hàng:</strong><br>
                                ${request.bankName}
                            </div>
                            <div class="col-md-4">
                                <strong>Số tài khoản:</strong><br>
                                ${request.bankAccountNumber}
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-12">
                                <strong>Tên chủ tài khoản:</strong><br>
                                ${request.bankAccountName}
                            </div>
                        </div>

                        <hr>

                        <!-- Notes -->
                        <c:if test="${not empty request.requestNote}">
                            <h6 class="mb-2">Ghi chú từ Seller:</h6>
                            <div class="alert alert-light">
                                ${request.requestNote}
                            </div>
                        </c:if>

                        <c:if test="${not empty request.adminNote}">
                            <h6 class="mb-2">Ghi chú từ Admin:</h6>
                            <div class="alert alert-info">
                                ${request.adminNote}
                                <c:if test="${not empty request.adminName}">
                                    <br><small>- ${request.adminName}</small>
                                </c:if>
                            </div>
                        </c:if>

                        <c:if test="${not empty request.transactionReference}">
                            <h6 class="mb-2">Mã giao dịch:</h6>
                            <div class="alert alert-success">
                                <strong>${request.transactionReference}</strong>
                            </div>
                        </c:if>

                        <!-- Timestamps -->
                        <div class="row mt-3">
                            <div class="col-md-6">
                                <small class="text-muted">
                                    <strong>Ngày yêu cầu:</strong><br>
                                    <fmt:formatDate value="${request.requestedAt}" pattern="dd/MM/yyyy HH:mm:ss" />
                                </small>
                            </div>
                            <c:if test="${not empty request.processedAt}">
                                <div class="col-md-6">
                                    <small class="text-muted">
                                        <strong>Ngày xử lý:</strong><br>
                                        <fmt:formatDate value="${request.processedAt}" pattern="dd/MM/yyyy HH:mm:ss" />
                                    </small>
                                </div>
                            </c:if>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <!-- Action buttons based on status -->
                        <c:if test="${request.statusValue == 'pending'}">
                            <!-- Approve Button -->
                            <button type="button" class="btn btn-success" 
                                    data-bs-toggle="modal" 
                                    data-bs-target="#approveModal${request.requestId}">
                                <i class="lni lni-checkmark"></i> Phê duyệt
                            </button>
                            <!-- Reject Button -->
                            <button type="button" class="btn btn-danger" 
                                    data-bs-toggle="modal" 
                                    data-bs-target="#rejectModal${request.requestId}">
                                <i class="lni lni-close"></i> Từ chối
                            </button>
                        </c:if>

                        <c:if test="${request.statusValue == 'approved' || request.statusValue == 'processing'}">
                            <!-- Complete Button -->
                            <button type="button" class="btn btn-success" 
                                    data-bs-toggle="modal" 
                                    data-bs-target="#completeModal${request.requestId}">
                                <i class="lni lni-checkmark-circle"></i> Hoàn thành chuyển tiền
                            </button>
                        </c:if>

                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Approve Modal -->
        <div class="modal fade" id="approveModal${request.requestId}" tabindex="-1">
            <div class="modal-dialog">
                <form method="post" action="<%= request.getContextPath() %>/admin/withdrawals">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Phê duyệt yêu cầu rút tiền</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" name="action" value="approve">
                            <input type="hidden" name="requestId" value="${request.requestId}">
                            
                            <p>Bạn có chắc muốn phê duyệt yêu cầu rút tiền này?</p>
                            <p><strong>Số tiền:</strong> <fmt:formatNumber value="${request.amount}" pattern="#,###" /> ₫</p>
                            <p><strong>Seller:</strong> ${request.sellerName}</p>

                            <div class="mb-3">
                                <label class="form-label">Ghi chú (tùy chọn):</label>
                                <textarea class="form-control" name="adminNote" rows="3" 
                                          placeholder="Nhập ghi chú..."></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-success">Phê duyệt</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Reject Modal -->
        <div class="modal fade" id="rejectModal${request.requestId}" tabindex="-1">
            <div class="modal-dialog">
                <form method="post" action="<%= request.getContextPath() %>/admin/withdrawals">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Từ chối yêu cầu rút tiền</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" name="action" value="reject">
                            <input type="hidden" name="requestId" value="${request.requestId}">
                            
                            <p>Bạn có chắc muốn từ chối yêu cầu rút tiền này?</p>

                            <div class="mb-3">
                                <label class="form-label">Lý do từ chối <span class="text-danger">*</span>:</label>
                                <textarea class="form-control" name="adminNote" rows="3" required
                                          placeholder="Nhập lý do từ chối..."></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-danger">Từ chối</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Complete Modal -->
        <div class="modal fade" id="completeModal${request.requestId}" tabindex="-1">
            <div class="modal-dialog">
                <form method="post" action="<%= request.getContextPath() %>/admin/withdrawals">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Hoàn thành chuyển tiền</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" name="action" value="complete">
                            <input type="hidden" name="requestId" value="${request.requestId}">
                            
                            <p>Xác nhận đã chuyển tiền thành công?</p>
                            <p><strong>Số tiền:</strong> <fmt:formatNumber value="${request.amount}" pattern="#,###" /> ₫</p>

                            <div class="mb-3">
                                <label class="form-label">Mã giao dịch <span class="text-danger">*</span>:</label>
                                <input type="text" class="form-control" name="transactionRef" required
                                       placeholder="Nhập mã giao dịch chuyển khoản...">
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Ghi chú:</label>
                                <textarea class="form-control" name="adminNote" rows="2" 
                                          placeholder="Nhập ghi chú..."></textarea>
                            </div>

                            <div class="alert alert-warning">
                                <strong>Lưu ý:</strong> Sau khi hoàn thành, số tiền sẽ được trừ khỏi ví của seller.
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-success">Hoàn thành</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </c:forEach>

    <!-- ========= All JS files ========= -->
    <script src="<%= request.getContextPath() %>/views/assets/admin/assets/js/bootstrap.bundle.min.js"></script>
    <script src="<%= request.getContextPath() %>/views/assets/admin/assets/js/main.js"></script>
</body>
</html>


