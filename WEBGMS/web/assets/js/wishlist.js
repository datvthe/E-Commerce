/**
 * ❤️ WISHLIST MANAGEMENT SYSTEM
 * Handles add/remove products to/from wishlist
 */

// Toggle wishlist (add or remove)
function toggleWishlist(productId, element) {
    // Check if user is logged in
    const userId = getUserId();
    if (!userId) {
        alert('Vui lòng đăng nhập để thêm vào danh sách yêu thích!');
        window.location.href = contextPath + '/login';
        return;
    }

    // Determine action based on current state
    const isInWishlist = element.classList.contains('in-wishlist');
    const action = isInWishlist ? 'remove' : 'add';
    
    // Disable button during request
    element.disabled = true;
    
    // Send AJAX request
    fetch(contextPath + '/wishlist', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `action=${action}&productId=${productId}`
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Toggle button state
            if (isInWishlist) {
                element.classList.remove('in-wishlist');
                element.innerHTML = '<i class="far fa-heart"></i>';
                element.title = 'Thêm vào yêu thích';
                showToast('Đã xóa khỏi danh sách yêu thích', 'success');
            } else {
                element.classList.add('in-wishlist');
                element.innerHTML = '<i class="fas fa-heart"></i>';
                element.title = 'Xóa khỏi yêu thích';
                showToast('Đã thêm vào danh sách yêu thích', 'success');
                
                // Animation effect
                element.classList.add('wishlist-added-animation');
                setTimeout(() => {
                    element.classList.remove('wishlist-added-animation');
                }, 600);
            }
            
            // Update wishlist count in header
            updateWishlistCount();
        } else {
            showToast(data.message || 'Có lỗi xảy ra', 'error');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showToast('Không thể kết nối đến server', 'error');
    })
    .finally(() => {
        element.disabled = false;
    });
}

// Add to wishlist (specific action)
function addToWishlist(productId) {
    const userId = getUserId();
    if (!userId) {
        alert('Vui lòng đăng nhập để thêm vào danh sách yêu thích!');
        window.location.href = contextPath + '/login';
        return;
    }
    
    fetch(contextPath + '/addToWishlist', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `productId=${productId}`
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showToast('Đã thêm vào danh sách yêu thích', 'success');
            updateWishlistCount();
            
            // Update all wishlist buttons for this product
            updateWishlistButtons(productId, true);
        } else {
            showToast(data.message || 'Sản phẩm đã có trong wishlist', 'info');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showToast('Có lỗi xảy ra', 'error');
    });
}

// Remove from wishlist (specific action)
function removeFromWishlist(productId) {
    fetch(contextPath + '/removeFromWishlist', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `productId=${productId}`
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showToast('Đã xóa khỏi danh sách yêu thích', 'success');
            updateWishlistCount();
            
            // Update all wishlist buttons for this product
            updateWishlistButtons(productId, false);
            
            // If on wishlist page, remove the product card
            if (window.location.pathname.includes('/wishlist')) {
                const productCard = document.querySelector(`[data-product-id="${productId}"]`);
                if (productCard) {
                    productCard.style.opacity = '0';
                    setTimeout(() => {
                        productCard.remove();
                        checkEmptyWishlist();
                    }, 300);
                }
            }
        } else {
            showToast(data.message || 'Có lỗi xảy ra', 'error');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showToast('Có lỗi xảy ra', 'error');
    });
}

// Update all wishlist buttons for a specific product
function updateWishlistButtons(productId, inWishlist) {
    const buttons = document.querySelectorAll(`[data-product-id="${productId}"].wishlist-btn`);
    buttons.forEach(btn => {
        if (inWishlist) {
            btn.classList.add('in-wishlist');
            btn.innerHTML = '<i class="fas fa-heart"></i>';
            btn.title = 'Xóa khỏi yêu thích';
        } else {
            btn.classList.remove('in-wishlist');
            btn.innerHTML = '<i class="far fa-heart"></i>';
            btn.title = 'Thêm vào yêu thích';
        }
    });
}

// Update wishlist count in header
function updateWishlistCount() {
    fetch(contextPath + '/api/wishlist/count')
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                const countElements = document.querySelectorAll('.wishlist-count, #wishlistCount');
                countElements.forEach(elem => {
                    elem.textContent = data.count;
                    if (data.count > 0) {
                        elem.style.display = 'inline-block';
                    } else {
                        elem.style.display = 'none';
                    }
                });
            }
        })
        .catch(error => console.error('Error updating wishlist count:', error));
}

// Check if wishlist page is empty
function checkEmptyWishlist() {
    if (!window.location.pathname.includes('/wishlist')) return;
    
    const productCards = document.querySelectorAll('.product-card');
    if (productCards.length === 0) {
        const container = document.getElementById('productsContainer');
        if (container) {
            container.innerHTML = `
                <div class="col-12 text-center py-5">
                    <i class="fas fa-heart-broken fa-3x text-muted mb-3"></i>
                    <h4 class="text-muted">Danh sách yêu thích trống</h4>
                    <p class="text-muted">Hãy thêm những sản phẩm bạn yêu thích vào đây!</p>
                    <a href="${contextPath}/products" class="btn btn-primary">
                        <i class="fas fa-shopping-bag"></i> Mua sắm ngay
                    </a>
                </div>
            `;
        }
    }
}

// Clear entire wishlist
function clearWishlist() {
    if (!confirm('Bạn có chắc muốn xóa toàn bộ danh sách yêu thích?')) {
        return;
    }
    
    fetch(contextPath + '/clearWishlist', {
        method: 'POST'
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showToast('Đã xóa toàn bộ danh sách yêu thích', 'success');
            updateWishlistCount();
            
            // Reload page if on wishlist page
            if (window.location.pathname.includes('/wishlist')) {
                setTimeout(() => {
                    window.location.reload();
                }, 1000);
            }
        } else {
            showToast(data.message || 'Có lỗi xảy ra', 'error');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showToast('Có lỗi xảy ra', 'error');
    });
}

// Get user ID from session (if available)
function getUserId() {
    // Check multiple sources for user ID
    if (window.currentUserId) {
        return window.currentUserId;
    }
    
    // Check if userId is in global scope (set by JSP)
    if (typeof currentUserId !== 'undefined') {
        return currentUserId;
    }
    
    // Check session storage
    const storedUserId = sessionStorage.getItem('userId');
    if (storedUserId) {
        return parseInt(storedUserId);
    }
    
    return null;
}

// Show toast notification
function showToast(message, type = 'info') {
    // Check if toast container exists
    let toastContainer = document.getElementById('toast-container');
    if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.id = 'toast-container';
        toastContainer.style.cssText = 'position: fixed; top: 20px; right: 20px; z-index: 9999;';
        document.body.appendChild(toastContainer);
    }
    
    // Create toast element
    const toast = document.createElement('div');
    toast.className = `alert alert-${type === 'error' ? 'danger' : type === 'success' ? 'success' : 'info'} fade show`;
    toast.style.cssText = 'min-width: 250px; margin-bottom: 10px; animation: slideInRight 0.3s ease-out;';
    toast.innerHTML = `
        <div class="d-flex align-items-center">
            <i class="fas fa-${type === 'error' ? 'exclamation-circle' : type === 'success' ? 'check-circle' : 'info-circle'} me-2"></i>
            <span>${message}</span>
        </div>
    `;
    
    toastContainer.appendChild(toast);
    
    // Auto remove after 3 seconds
    setTimeout(() => {
        toast.style.animation = 'slideOutRight 0.3s ease-out';
        setTimeout(() => toast.remove(), 300);
    }, 3000);
}

// Initialize wishlist on page load
document.addEventListener('DOMContentLoaded', function() {
    // Update wishlist count
    if (getUserId()) {
        updateWishlistCount();
    }
    
    // Add CSS animations
    if (!document.getElementById('wishlist-animations')) {
        const style = document.createElement('style');
        style.id = 'wishlist-animations';
        style.textContent = `
            @keyframes slideInRight {
                from { transform: translateX(100%); opacity: 0; }
                to { transform: translateX(0); opacity: 1; }
            }
            @keyframes slideOutRight {
                from { transform: translateX(0); opacity: 1; }
                to { transform: translateX(100%); opacity: 0; }
            }
            @keyframes heartBeat {
                0%, 100% { transform: scale(1); }
                25% { transform: scale(1.3); }
                50% { transform: scale(1); }
                75% { transform: scale(1.2); }
            }
            .wishlist-added-animation {
                animation: heartBeat 0.6s ease-in-out;
            }
            .wishlist-btn {
                transition: all 0.3s ease;
            }
            .wishlist-btn:hover {
                transform: scale(1.1);
            }
            .wishlist-btn.in-wishlist {
                color: #dc3545;
            }
            .wishlist-btn.in-wishlist i {
                color: #dc3545;
            }
        `;
        document.head.appendChild(style);
    }
});

