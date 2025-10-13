<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>Product Detail Demo - Gicungco Marketplace</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">

        <!-- Google Web Fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500;600;700&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">

        <!-- Icon Font Stylesheet -->
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" />

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

            .demo-header {
                text-align: center;
                margin-bottom: 30px;
                padding: 20px;
                background: white;
                border-radius: 12px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            }

            .demo-title {
                font-size: 32px;
                font-weight: 700;
                color: #212529;
                margin-bottom: 10px;
            }

            .demo-subtitle {
                color: #6c757d;
                font-size: 16px;
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
        <!-- Demo Header -->
        <div class="container-fluid py-3">
            <div class="container">
                <div class="demo-header">
                    <h1 class="demo-title">Product Detail Page Demo</h1>
                    <p class="demo-subtitle">Clean, modern card-based design similar to your reference</p>
                </div>
            </div>
        </div>

        <!-- Product Detail Card -->
        <div class="container-fluid py-5">
            <div class="container">
                <div class="product-card">
                    <div class="product-content">
                        <!-- Product Image Section -->
                        <div class="product-image-section">
                            <div class="product-image-placeholder">
                                <i class="fas fa-image"></i>
                                <span>Product Image</span>
                            </div>
                        </div>

                        <!-- Product Details Section -->
                        <div class="product-details-section">
                            <div>
                                <h1 class="product-name">Premium Wireless Headphones</h1>
                                
                                <div class="product-price">
                                    7,500,000₫
                                </div>

                                <!-- Rating -->
                                <div class="rating">
                                    <div class="stars">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                    </div>
                                    <span class="rating-text">
                                        4.8 (127 reviews)
                                    </span>
                                </div>


                                <!-- Product Information -->
                                <div class="product-info">
                                    <div class="info-row">
                                        <span class="info-label">Category:</span>
                                        <span class="info-value">Electronics</span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Description:</span>
                                        <span class="info-value">High-quality wireless headphones with noise cancellation and premium sound quality.</span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Seller:</span>
                                        <span class="info-value">TechStore Pro</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <div class="action-buttons">
                                <button class="btn-wishlist" onclick="toggleWishlist()" id="wishlistBtn">
                                    <i class="fas fa-heart"></i> 
                                    <span id="wishlistText">Add to Wishlist</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Additional Demo Cards -->
                <div class="row mt-5">
                    <div class="col-md-6 mb-4">
                        <div class="product-card">
                            <div class="product-content">
                                <div class="product-image-section">
                                    <div class="product-image-placeholder">
                                        <i class="fas fa-laptop"></i>
                                        <span>Laptop Image</span>
                                    </div>
                                </div>
                                <div class="product-details-section">
                                    <div>
                                        <h1 class="product-name">Gaming Laptop Pro</h1>
                                        <div class="product-price">32,500,000₫</div>
                                        <div class="product-info">
                                            <div class="info-row">
                                                <span class="info-label">Category:</span>
                                                <span class="info-value">Computers</span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">Description:</span>
                                                <span class="info-value">High-performance gaming laptop with RTX graphics.</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="action-buttons">
                                        <button class="btn-wishlist">Add to Wishlist</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6 mb-4">
                        <div class="product-card">
                            <div class="product-content">
                                <div class="product-image-section">
                                    <div class="product-image-placeholder">
                                        <i class="fas fa-mobile-alt"></i>
                                        <span>Phone Image</span>
                                    </div>
                                </div>
                                <div class="product-details-section">
                                    <div>
                                        <h1 class="product-name">Smartphone X</h1>
                                        <div class="product-price">22,500,000₫</div>
                                        <div class="product-info">
                                            <div class="info-row">
                                                <span class="info-label">Category:</span>
                                                <span class="info-value">Mobile Phones</span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">Description:</span>
                                                <span class="info-value">Latest smartphone with advanced camera system.</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="action-buttons">
                                        <button class="btn-wishlist">Add to Wishlist</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- JavaScript Libraries -->
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Demo JavaScript -->
        <script>

            // Toggle wishlist
            function toggleWishlist() {
                const wishlistBtn = document.getElementById('wishlistBtn');
                const wishlistText = document.getElementById('wishlistText');
                const isInWishlist = wishlistBtn.classList.contains('in-wishlist');
                
                if (isInWishlist) {
                    wishlistBtn.classList.remove('in-wishlist');
                    wishlistText.textContent = 'Add to Wishlist';
                    showNotification('Removed from wishlist', 'success');
                } else {
                    wishlistBtn.classList.add('in-wishlist');
                    wishlistText.textContent = 'In Wishlist';
                    showNotification('Added to wishlist', 'success');
                }
            }

            // Show notification
            function showNotification(message, type) {
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
                
                const style = document.createElement('style');
                style.textContent = `
                    @keyframes slideIn {
                        from { transform: translateX(100%); opacity: 0; }
                        to { transform: translateX(0); opacity: 1; }
                    }
                `;
                document.head.appendChild(style);
                
                document.body.appendChild(notification);
                
                setTimeout(() => {
                    notification.remove();
                }, 3000);
            }
        </script>
    </body>
</html>
