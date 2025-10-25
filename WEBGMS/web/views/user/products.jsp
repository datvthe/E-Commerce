<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/views/component/head.jspf" />
        <meta charset="utf-8">
        <title>Danh mục sản phẩm</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="Khám phá hàng ngàn sản phẩm chất lượng cao" name="description">

        <!-- Favicon -->
        <link href="<%= request.getContextPath() %>/views/assets/electro/img/favicon.ico" rel="icon">

        <!-- Google Web Fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500;600;700&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">

        <!-- Icon Font Stylesheet -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Libraries Stylesheet -->
        <link href="<%= request.getContextPath() %>/views/assets/electro/lib/animate/animate.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath() %>/views/assets/electro/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

        <!-- Customized Bootstrap Stylesheet -->
        <link href="<%= request.getContextPath() %>/views/assets/electro/css/bootstrap.min.css" rel="stylesheet">

        <!-- Template Stylesheet -->
        <link href="<%= request.getContextPath() %>/views/assets/electro/css/style.css" rel="stylesheet">

        <style>
            .pagination {
                display: flex;
                justify-content: center;
                flex-wrap: wrap;
                list-style: none;
                padding-left: 0;
                gap: 5px;
            }
            .pagination .page-item {
                display: inline-block;
            }
            .pagination .page-link {
                padding: 0.5rem 0.75rem;
                border-radius: 5px;
                text-decoration: none;
            }
            .pagination .page-item .active .page-link {
                color: #fff;
                border-color: #007bff;
                background-color: #007bff;
            }

            .product-card {
                border: 1px solid #eee;
                border-radius: 10px;
                overflow: hidden;
                transition: all 0.3s ease;
                height: 100%;
                background: white;
            }

            .product-card:hover {
                box-shadow: 0 5px 20px rgba(0,0,0,0.1);
                transform: translateY(-5px);
            }

            .product-image {
                width: 100%;
                height: 200px;
                object-fit: cover;
                background: #f8f9fa;
            }

            .product-card-body {
                padding: 15px;
            }

            .product-title {
                font-size: 1rem;
                font-weight: 600;
                margin-bottom: 10px;
                color: #333;
                text-decoration: none;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
            }

            .product-title:hover {
                color: #007bff;
            }

            .product-price {
                font-size: 1.1rem;
                font-weight: 600;
                color: #e74c3c;
                margin-bottom: 10px;
            }

            .product-rating {
                display: flex;
                align-items: center;
                margin-bottom: 15px;
            }

            .stars {
                color: #ffc107;
                font-size: 0.9rem;
                margin-right: 5px;
            }

            .rating-text {
                color: #666;
                font-size: 0.8rem;
            }

            .product-actions {
                display: flex;
                gap: 10px;
            }

            .btn-product {
                flex: 1;
                padding: 8px 12px;
                border-radius: 6px;
                font-size: 0.9rem;
                text-decoration: none;
                text-align: center;
                transition: all 0.3s ease;
                border: none;
                cursor: pointer;
            }

            .btn-detail {
                background: #007bff;
                color: white;
            }

            .btn-detail:hover {
                background: #0056b3;
                color: white;
            }


            .filters-section {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 10px;
                margin-bottom: 30px;
            }

            .pagination {
                justify-content: center;
                margin-top: 40px;
            }

            .page-link {
                color: #007bff;
                border: 1px solid #dee2e6;
                padding: 0.5rem 0.75rem;
            }

            .page-link:hover {
                color: #0056b3;
                background-color: #e9ecef;
                border-color: #dee2e6;
            }

            .page-item.active .page-link {
                background-color: #007bff;
                border-color: #007bff;
            }

            .breadcrumb {
                background: transparent;
                padding: 0;
                margin-bottom: 20px;
            }

            .breadcrumb-item + .breadcrumb-item::before {
                content: ">";
                color: #6c757d;
            }
        </style>
    </head>

    <body>
        <!-- Breadcrumb -->
        <div class="container-fluid py-3 bg-light">
            <div class="container">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="<%= request.getContextPath() %>/home">Trang chủ</a></li>
                        <li class="breadcrumb-item active">Danh mục sản phẩm</li>
                    </ol>
                </nav>
            </div>
        </div>

        <!-- Products Section -->
        <div class="container-fluid py-5">
            <div class="container">
                <!-- Page Header -->
                <div class="row mb-4">
                    <div class="col-12">
                        <h1 class="h2 mb-3">Danh mục sản phẩm</h1>
                        <p class="text-muted">Khám phá hàng ngàn sản phẩm chất lượng cao từ các nhà bán uy tín</p>
                    </div>
                </div>

                <!-- Filters Section -->
                <form action="products" method="get" class="filters-section mb-4">
                    <div class="row align-items-end g-3">
                        <div class="col-md-3">
                            <label class="form-label fw-bold">Tìm kiếm:</label>
                            <input type="text" class="form-control" name="search"
                                   placeholder="Nhập tên sản phẩm..." value="${search}">
                        </div>
                        <div class="col-md-2">
                            <label class="form-label fw-bold">Danh mục:</label>
                            <select name="category" class="form-select">
                                <option value="">Tất cả danh mục</option>
                                <c:forEach var="categoryItem" items="${categories}">
                                    <option value="${categoryItem.category_id}"
                                            ${category == categoryItem.category_id ? 'selected' : ''}>
                                        ${categoryItem.name}
                                    </option>
                                </c:forEach>
                            </select>

                        </div>
                        <div class="col-md-2">
                            <label class="form-label fw-bold">Sắp xếp:</label>
                            <select class="form-select" name="sort">
                                <option value="">Mặc định</option>
                                <option value="priceAsc" ${sort == 'priceAsc' ? 'selected' : ''}>Giá tăng dần</option>
                                <option value="priceDesc" ${sort == 'priceDesc' ? 'selected' : ''}>Giá giảm dần</option>
                                <option value="rating" ${sort == 'rating' ? 'selected' : ''}>Đánh giá cao</option>
                                <option value="newest" ${sort == 'newest' ? 'selected' : ''}>Mới nhất</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label fw-bold">Hiển thị:</label>
                            <select class="form-select" name="pageSize">
                                <option value="12" ${pageSize == 12 ? 'selected' : ''}>12 sản phẩm</option>
                                <option value="24" ${pageSize == 24 ? 'selected' : ''}>24 sản phẩm</option>
                                <option value="48" ${pageSize == 48 ? 'selected' : ''}>48 sản phẩm</option>
                            </select>
                        </div>
                        <div class="col-md-3 d-flex gap-2">
                            <button type="submit" class="btn btn-primary flex-grow-1">
                                <i class="fas fa-search"></i> Tìm kiếm
                            </button>
                            <a href="products" class="btn btn-outline-secondary flex-grow-1">
                                <i class="fas fa-times"></i> Xóa bộ lọc
                            </a>
                        </div>
                    </div>
                </form>


                <!-- Products Grid -->
                <div class="row g-4" id="productsContainer">
                    <c:choose>
                        <c:when test="${not empty products}">
                            <c:forEach var="product" items="${products}">
                                <div class="col-sm-6 col-md-4 col-lg-3">
                                    <div class="product-card">
                                        <a href="<%= request.getContextPath() %>/product/${product.slug}">
                                            <c:choose>
                                                <c:when test="${not empty product.productImages}">
                                                    <img src="${product.productImages[0].url}" alt="${product.name}" class="product-image">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/views/assets/user/img/product-1.png" alt="${product.name}" class="product-image">
                                                </c:otherwise>
                                            </c:choose>
                                        </a>

                                        <div class="product-card-body">
                                            <a href="<%= request.getContextPath() %>/product/${product.slug}" class="product-title">
                                                ${product.name}
                                            </a>
                                            <div class="product-price">
                                                <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true" maxFractionDigits="0" />₫
                                            </div>

                                            <div class="product-rating">
                                                <div class="stars">
                                                    <c:forEach begin="1" end="5" var="i">
                                                        <i class="fas fa-star ${i <= product.average_rating ? '' : 'far'}"></i>
                                                    </c:forEach>
                                                </div>
                                                <span class="rating-text">(${product.total_reviews})</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>

                        <c:otherwise>
                            <div class="col-12 text-center py-5">
                                <i class="fas fa-search fa-3x text-muted mb-3"></i>
                                <h4 class="text-muted">Không tìm thấy sản phẩm nào</h4>
                                <button class="btn btn-primary" onclick="clearFilters()">Xóa bộ lọc</button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Products pagination">
                        <ul class="pagination mt-4">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage - 1}&category=${category}&sort=${sort}&search=${search}&pageSize=${pageSize}">
                                        <i class="fas fa-chevron-left"></i> Trước
                                    </a>
                                </li>
                            </c:if>

                            <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?page=${pageNum}&category=${category}&sort=${sort}&search=${search}&pageSize=${pageSize}">
                                        ${pageNum}
                                    </a>
                                </li>
                            </c:forEach>

                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage + 1}&category=${category}&sort=${sort}&search=${search}&pageSize=${pageSize}">
                                        Sau <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>

        <script>
            function clearFilters() {
                window.location.href = '<%= request.getContextPath() %>/products';
            }
        </script>
    </body>
</html>
