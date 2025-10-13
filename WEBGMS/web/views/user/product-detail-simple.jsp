<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>${product.name} - Gicungco Marketplace</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="${product.description}" name="description">

        <!-- Google Web Fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500;600;700&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">

        <!-- Icon Font Stylesheet -->
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Customized Bootstrap Stylesheet -->
        <link href="<%= request.getContextPath() %>/views/assets/user/css/bootstrap.min.css" rel="stylesheet">

        <!-- Simple Product Detail Styles -->
        <style>
            body {
                font-family: 'Open Sans', sans-serif;
                background-color: #f8f9fa;
                margin: 0;
                padding: 20px;
            }

            .product-card {
                background: white;
                border-radius: 12px;
                border: 1px solid #e9ecef;
                box-shadow: 0 2px 10px rgba(0,0,0,0.08);
                max-width: 800px;
                margin: 0 auto;
                overflow: hidden;
            }

            .product-content {
                display: flex;
                min-height: 400px;
            }

            .product-image-section {
                flex: 1;
                background: #f8f9fa;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 40px;
                border-right: 1px solid #e9ecef;
            }

            .product-image {
                width: 100%;
                max-width: 300px;
                height: 300px;
                object-fit: cover;
                border-radius: 8px;
                background: white;
                border: 1px solid #e9ecef;
            }

            .product-image-placeholder {
                width: 100%;
                max-width: 300px;
                height: 300px;
                background: white;
                border: 2px dashed #dee2e6;
                border-radius: 8px;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                color: #6c757d;
                font-size: 16px;
            }

            .product-image-placeholder i {
                font-size: 48px;
                margin-bottom: 10px;
                color: #adb5bd;
            }

            .product-details-section {
                flex: 1;
                padding: 40px;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
            }

            .product-name {
                font-size: 28px;
                font-weight: 700;
                color: #212529;
                margin: 0 0 15px 0;
                line-height: 1.2;
            }

            .product-price {
                font-size: 24px;
                font-weight: 600;
                color: #dc3545;
                margin: 0 0 20px 0;
            }

            .product-info {
                margin-bottom: 20px;
            }

            .info-row {
                margin-bottom: 12px;
                display: flex;
                align-items: center;
            }

            .info-label {
                font-weight: 600;
                color: #495057;
                margin-right: 8px;
                min-width: 80px;
            }

            .info-value {
                color: #6c757d;
                flex: 1;
            }

            .action-buttons {
                display: flex;
                justify-content: center;
                margin-top: 30px;
            }


            .btn-wishlist {
                background: white;
                color: #007bff;
                border: 2px solid #007bff;
                padding: 12px 32px;
                border-radius: 8px;
                font-weight: 600;
                font-size: 16px;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                text-align: center;
                min-width: 180px;
            }

            .btn-wishlist:hover {
                background: #007bff;
                color: white;
                text-decoration: none;
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(0, 123, 255, 0.3);
            }

            .btn-wishlist.in-wishlist {
                background: #dc3545;
                border-color: #dc3545;
                color: white;
            }

            .btn-wishlist.in-wishlist:hover {
                background: #c82333;
                border-color: #c82333;
            }


            .rating {
                display: flex;
                align-items: center;
                margin-bottom: 15px;
            }

            .stars {
                color: #ffc107;
                margin-right: 8px;
            }

            .rating-text {
                color: #6c757d;
                font-size: 14px;
            }

            @media (max-width: 768px) {
                .product-content {
                    flex-direction: column;
                }

                .product-image-section {
                    border-right: none;
                    border-bottom: 1px solid #e9ecef;
                }

                .product-details-section {
                    padding: 30px 20px;
                }

                .action-buttons {
                    flex-direction: column;
                }

                .btn-wishlist {
                    min-width: auto;
                }
            }
        </style>
    </head>

    <body>
        <!-- Header -->
        <jsp:include page="/views/component/header.jsp" />

        <!-- Product Detail Card -->
        <div class="container-fluid py-5">
            <div class="container">
                <div class="product-card">
                    <div class="product-content">
                        <!-- Product Image Section -->
                        <div class="product-image-section">
                            <c:choose>
                                <c:when test="${not empty images}">
                                    <img src="${images[0].url}" alt="${images[0].alt_text}" class="product-image">
                                </c:when>
                                <c:otherwise>
                                    <div class="product-image-placeholder">
                                        <i class="fas fa-image"></i>
                                        <span>Product Image</span>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Product Details Section -->
                        <div class="product-details-section">
                            <div>
                                <h1 class="product-name">${product.name}</h1>
                                
                                <div class="product-price">
                                    ${product.price}₫
                                </div>

                                <!-- Rating -->
                                <c:if test="${product.average_rating > 0}">
                                    <div class="rating">
                                        <div class="stars">
                                            <c:forEach begin="1" end="5" var="i">
                                                <i class="fas fa-star ${i <= product.average_rating ? '' : 'far'}"></i>
                                            </c:forEach>
                                        </div>
                                        <span class="rating-text">
                                            ${product.average_rating} (${product.total_reviews} reviews)
                                        </span>
                                    </div>
                                </c:if>


                                <!-- Product Information -->
                                <div class="product-info">
                                    <div class="info-row">
                                        <span class="info-label">Category:</span>
                                        <span class="info-value">
                                            <c:choose>
                                                <c:when test="${not empty product.category_id}">
                                                    ${product.category_id.name}
                                                </c:when>
                                                <c:otherwise>
                                                    ???
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Description:</span>
                                        <span class="info-value">
                                            <c:choose>
                                                <c:when test="${not empty product.description}">
                                                    ${product.description}
                                                </c:when>
                                                <c:otherwise>
                                                    ???
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <c:if test="${not empty product.seller_id}">
                                        <div class="info-row">
                                            <span class="info-label">Seller:</span>
                                            <span class="info-value">${product.seller_id.full_name}</span>
                                        </div>
                                    </c:if>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <div class="action-buttons">
                                <button class="btn-wishlist ${isInWishlist ? 'in-wishlist' : ''}" 
                                        onclick="toggleWishlist()" id="wishlistBtn">
                                    <i class="fas fa-heart"></i> 
                                    <span id="wishlistText">${isInWishlist ? 'In Wishlist' : 'Add to Wishlist'}</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <jsp:include page="/views/component/footer.jsp" />

        <!-- JavaScript Libraries -->
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Product Detail JavaScript -->
        <script>
            const productId = ${product.product_id};


            // Toggle wishlist
            function toggleWishlist() {
                const wishlistBtn = document.getElementById('wishlistBtn');
                const wishlistText = document.getElementById('wishlistText');
                const isInWishlist = wishlistBtn.classList.contains('in-wishlist');
                
                fetch('<%= request.getContextPath() %>/wishlist/toggle', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: `action=toggle&productId=${productId}`
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        if (isInWishlist) {
                            wishlistBtn.classList.remove('in-wishlist');
                            wishlistText.textContent = 'Add to Wishlist';
                        } else {
                            wishlistBtn.classList.add('in-wishlist');
                            wishlistText.textContent = 'In Wishlist';
                        }
                        // Show success message
                        showNotification(data.message, 'success');
                    } else {
                        showNotification(data.message, 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showNotification('An error occurred while updating wishlist', 'error');
                });
            }

            // Show notification
            function showNotification(message, type) {
                // Create notification element
                const notification = document.createElement('div');
                notification.style.cssText = `
                    position: fixed;
                    top: 20px;
                    right: 20px;
                    padding: 15px 20px;
                    border-radius: 8px;
                    color: white;
                    font-weight: 600;
                    z-index: 9999;
                    animation: slideIn 0.3s ease;
                    background: ${type === 'success' ? '#28a745' : '#dc3545'};
                `;
                notification.textContent = message;
                
                // Add animation styles
                const style = document.createElement('style');
                style.textContent = `
                    @keyframes slideIn {
                        from { transform: translateX(100%); opacity: 0; }
                        to { transform: translateX(0); opacity: 1; }
                    }
                `;
                document.head.appendChild(style);
                
                document.body.appendChild(notification);
                
                // Remove after 3 seconds
                setTimeout(() => {
                    notification.remove();
                }, 3000);
            }
        </script>
    </body>
</html>
