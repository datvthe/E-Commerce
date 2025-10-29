<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <title>Lịch sử thanh toán - Gicungco Marketplace</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500;600;700&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    
    <!-- Icons -->
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">
    
    <!-- Libraries -->
    <link href="<%= request.getContextPath() %>/views/assets/electro/lib/animate/animate.min.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/views/assets/electro/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/views/assets/electro/css/style.css" rel="stylesheet">
    
    <style>
        .balance-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 12px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
        }
        
        .balance-amount {
            font-size: 2.5rem;
            font-weight: 700;
            margin-top: 0.5rem;
        }
        
        .balance-label {
            font-size: 1rem;
            opacity: 0.9;
        }
        
        .transaction-table {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        
        .transaction-table table {
            margin-bottom: 0;
        }
        
        .transaction-row {
            transition: background 0.2s;
        }
        
        .transaction-row:hover {
            background: #f8f9fa;
        }
        
        .transaction-type {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
            display: inline-block;
        }
        
        .type-deposit {
            background: #d1fae5;
            color: #065f46;
        }
        
        .type-withdraw {
            background: #fee2e2;
            color: #991b1b;
        }
        
        .type-transfer {
            background: #dbeafe;
            color: #1e40af;
        }
        
        .amount-positive {
            color: #10b981;
            font-weight: 600;
        }
        
        .amount-negative {
            color: #dc2626;
            font-weight: 600;
        }
        
        .transaction-id {
            font-family: 'Courier New', monospace;
            font-size: 0.9rem;
            color: #6b7280;
        }
        
        .no-transactions {
            text-align: center;
            padding: 3rem;
        }
        
        .no-transactions i {
            font-size: 4rem;
            color: #ccc;
            margin-bottom: 1rem;
        }
        
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }
        
        .status-success {
            background: #d1fae5;
            color: #065f46;
        }
        
        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }
        
        .status-failed {
            background: #fee2e2;
            color: #991b1b;
        }
        
        .table-header {
            background: #f8f9fa;
            font-weight: 600;
            color: #374151;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <jsp:include page="/views/component/header.jsp" />
    
    <div class="container-fluid py-5">
        <div class="container py-5">
            <div class="row">
                <div class="col-12">
                    <h2 class="mb-4">
                        <i class="fas fa-history text-primary"></i>
                        Lịch sử thanh toán
                    </h2>
                    
                    <!-- Error Message -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle"></i> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <!-- Balance Card -->
                    <div class="balance-card">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <div class="balance-label">
                                    <i class="fas fa-wallet"></i>
                                    Số dư ví hiện tại
                                </div>
                                <div class="balance-amount">
                                    <fmt:formatNumber value="${currentBalance}" type="number" maxFractionDigits="0" />₫
                                </div>
                            </div>
                            <div class="col-md-4 text-md-end">
                                <a href="<%= request.getContextPath() %>/wallet" class="btn btn-light btn-lg">
                                    <i class="fas fa-plus-circle"></i> Nạp tiền
                                </a>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Transactions Table -->
                    <c:choose>
                        <c:when test="${empty transactions}">
                            <div class="no-transactions">
                                <i class="fas fa-receipt"></i>
                                <h4>Chưa có giao dịch nào</h4>
                                <p class="text-muted">Bạn chưa có giao dịch nào trong ví.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="transaction-table">
                                <table class="table">
                                    <thead>
                                        <tr class="table-header">
                                            <th>Mã giao dịch</th>
                                            <th>Loại</th>
                                            <th>Số tiền</th>
                                            <th>Trạng thái</th>
                                            <th>Ghi chú</th>
                                            <th>Thời gian</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${transactions}" var="trans">
                                            <tr class="transaction-row">
                                                <!-- Transaction ID -->
                                                <td>
                                                    <div class="transaction-id">
                                                        ${trans.transaction_id}
                                                    </div>
                                                </td>
                                                
                                                <!-- Type -->
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${trans.type == 'DEPOSIT'}">
                                                            <span class="transaction-type type-deposit">
                                                                <i class="fas fa-arrow-down"></i> Nạp tiền
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${trans.type == 'WITHDRAW'}">
                                                            <span class="transaction-type type-withdraw">
                                                                <i class="fas fa-arrow-up"></i> Thanh toán
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${trans.type == 'TRANSFER'}">
                                                            <span class="transaction-type type-transfer">
                                                                <i class="fas fa-exchange-alt"></i> Chuyển khoản
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="transaction-type" style="background: #e5e7eb; color: #374151;">
                                                                ${trans.type}
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                
                                                <!-- Amount -->
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${trans.type == 'DEPOSIT'}">
                                                            <span class="amount-positive">
                                                                +<fmt:formatNumber value="${trans.amount}" type="number" maxFractionDigits="0" />₫
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="amount-negative">
                                                                -<fmt:formatNumber value="${trans.amount}" type="number" maxFractionDigits="0" />₫
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                
                                                <!-- Status -->
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${trans.status == 'success' || trans.status == 'completed'}">
                                                            <span class="status-badge status-success">
                                                                <i class="fas fa-check-circle"></i> Thành công
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${trans.status == 'pending'}">
                                                            <span class="status-badge status-pending">
                                                                <i class="fas fa-clock"></i> Đang xử lý
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${trans.status == 'failed'}">
                                                            <span class="status-badge status-failed">
                                                                <i class="fas fa-times-circle"></i> Thất bại
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge" style="background: #e5e7eb; color: #374151;">
                                                                ${trans.status}
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                
                                                <!-- Note -->
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty trans.note}">
                                                            ${trans.note}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">-</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                
                                                <!-- Created At -->
                                                <td>
                                                    <fmt:formatDate value="${trans.created_at}" pattern="dd/MM/yyyy HH:mm:ss" />
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            
                            <!-- Note -->
                            <div class="mt-3 text-muted">
                                <small>
                                    <i class="fas fa-info-circle"></i>
                                    Hiển thị 20 giao dịch gần nhất. Để xem đầy đủ lịch sử, vui lòng liên hệ hỗ trợ.
                                </small>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Footer -->
    <jsp:include page="/views/component/footer.jsp" />
</body>
</html>

