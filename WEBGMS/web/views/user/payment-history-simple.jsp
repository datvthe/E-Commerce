<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <title>Lịch sử thanh toán</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        body {
            background: #f5f7fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 2rem 0;
        }
        
        .container {
            max-width: 1200px;
        }
        
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
        
        .transaction-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin-bottom: 2rem;
        }
        
        .card-header {
            background: #f8f9fa;
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .transaction-row {
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #f0f0f0;
            transition: background 0.2s;
        }
        
        .transaction-row:hover {
            background: #f8f9fa;
        }
        
        .transaction-row:last-child {
            border-bottom: none;
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
            font-size: 1.1rem;
        }
        
        .amount-negative {
            color: #dc2626;
            font-weight: 600;
            font-size: 1.1rem;
        }
        
        .transaction-id {
            font-family: 'Courier New', monospace;
            font-size: 0.85rem;
            color: #6b7280;
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
        
        .no-transactions {
            text-align: center;
            padding: 3rem;
            color: #6b7280;
        }
        
        .no-transactions i {
            font-size: 4rem;
            color: #ccc;
            margin-bottom: 1rem;
        }
        
        .page-title {
            margin-bottom: 2rem;
        }
        
        .back-btn {
            margin-bottom: 1rem;
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
        <h2 class="page-title">
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
        
        <!-- Transactions -->
        <c:choose>
            <c:when test="${empty transactions}">
                <div class="transaction-card">
                    <div class="no-transactions">
                        <i class="fas fa-receipt"></i>
                        <h4>Chưa có giao dịch nào</h4>
                        <p class="text-muted">Bạn chưa có giao dịch nào trong ví.</p>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="transaction-card">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-list"></i>
                            Danh sách giao dịch (20 giao dịch gần nhất)
                        </h5>
                    </div>
                    
                    <c:forEach items="${transactions}" var="trans">
                        <div class="transaction-row">
                            <div class="row align-items-center">
                                <!-- Type & Note -->
                                <div class="col-md-4">
                                    <div class="mb-2">
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
                                    </div>
                                    <div class="text-muted small">
                                        <c:choose>
                                            <c:when test="${not empty trans.note}">
                                                ${trans.note}
                                            </c:when>
                                            <c:otherwise>
                                                -
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                
                                <!-- Amount -->
                                <div class="col-md-3 text-center">
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
                                </div>
                                
                                <!-- Status -->
                                <div class="col-md-2 text-center">
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
                                </div>
                                
                                <!-- Time -->
                                <div class="col-md-3 text-end">
                                    <div class="text-muted small">
                                        <i class="far fa-clock"></i>
                                        <fmt:formatDate value="${trans.created_at}" pattern="dd/MM/yyyy HH:mm" />
                                    </div>
                                    <div class="transaction-id mt-1">
                                        ID: ${trans.transaction_id}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                
                <!-- Note -->
                <div class="text-muted text-center mt-3">
                    <small>
                        <i class="fas fa-info-circle"></i>
                        Hiển thị 20 giao dịch gần nhất
                    </small>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

