<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!--         Spinner Start 
        <div id="spinner"
             class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
            <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
                <span class="sr-only">Loading...</span>
            </div>
        </div>
         Spinner End -->
        <!-- Toast Notifications -->
        <div class="position-fixed top-0 end-0 p-3" style="z-index: 1080;">
            <c:if test="${not empty sessionScope.message}">
                <div id="toast-success" class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
                    <div class="d-flex">
                        <div class="toast-body">${sessionScope.message}</div>
                        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                    </div>
                </div>
                <c:remove var="message" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div id="toast-error" class="toast align-items-center text-white bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true">
                    <div class="d-flex">
                        <div class="toast-body">${sessionScope.error}</div>
                        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                    </div>
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>
        </div>
        <script>
            (function () {
                try {
                    var toastSuccess = document.getElementById('toast-success');
                    if (toastSuccess) new bootstrap.Toast(toastSuccess, {delay: 3000}).show();
                    var toastError = document.getElementById('toast-error');
                    if (toastError) new bootstrap.Toast(toastError, {delay: 4000}).show();
                } catch (e) {}
            })();
        </script>

        <!-- Spinner Start -->
        <div id="spinner"
             class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
            <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
                <span class="sr-only">Loading...</span>
            </div>
        </div>
        <!-- Spinner End -->

        <!-- Enhanced Styles -->
        <style>
        .topbar-enhanced {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-bottom: 2px solid #dee2e6;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        .topbar-link {
            color: #6c757d !important;
            text-decoration: none;
            transition: all 0.3s ease;
            font-weight: 500;
        }
        .topbar-link:hover {
            color: #0d6efd !important;
            transform: translateY(-1px);
        }
        .phone-highlight {
            background: linear-gradient(135deg, #0d6efd, #0b5ed7);
            color: white !important;
            padding: 4px 12px;
            border-radius: 15px;
            font-weight: 600;
            margin-left: 8px;
            transition: all 0.3s ease;
        }
        .phone-highlight:hover {
            transform: scale(1.05);
            box-shadow: 0 3px 8px rgba(13, 110, 253, 0.3);
        }
        .user-dropdown .btn {
            border-radius: 20px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .user-dropdown .btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        .separator {
            color: #dee2e6;
            margin: 0 8px;
            font-weight: bold;
        }
        </style>
        
        <!-- Topbar Start -->
        <div class="container-fluid px-5 d-none border-bottom d-lg-block topbar-enhanced">
            <div class="row gx-0 align-items-center py-2">
                <div class="col-lg-4 text-center text-lg-start mb-lg-0">
                    <div class="d-inline-flex align-items-center" style="height: 45px;">
                        <i class="fas fa-headset me-2 text-primary"></i>
                        <a href="#" class="topbar-link me-2"><i class="fas fa-life-ring me-1"></i> Hỗ trợ</a>
                        <span class="separator">•</span>
                        <a href="#" class="topbar-link mx-2"><i class="fas fa-question-circle me-1"></i> Trợ giúp</a>
                        <span class="separator">•</span>
                        <a href="#" class="topbar-link ms-2"><i class="fas fa-envelope me-1"></i> Liên hệ</a>
                    </div>
                </div>
                <div class="col-lg-4 text-center d-flex align-items-center justify-content-center">
                    <i class="fas fa-phone-alt me-2 text-success"></i>
                    <small class="text-dark fw-bold me-2">Hotline 24/7:</small>
                    <a href="tel:+0123456789" class="text-decoration-none phone-highlight">
                        <i class="fas fa-phone me-1"></i>(+012) 1234 567890
                    </a>
                </div>

                <div class="col-lg-4 text-center text-lg-end">
                    <div class="d-inline-flex align-items-center gap-2" style="height: 45px;">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <div class="dropdown user-dropdown">
                                    <button class="btn btn-outline-primary btn-sm px-3 dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                        <i class="fas fa-user-circle me-1"></i>
                                        <span class="fw-bold">${sessionScope.user.full_name}</span>
                                        <i class="fas fa-caret-down ms-1"></i>
                                    </button>
                                    <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0" style="border-radius: 12px;">
                                        <li><h6 class="dropdown-header"><i class="fas fa-user me-2"></i>Tài khoản của tôi</h6></li>
                                        <li><a class="dropdown-item py-2" href="<%= request.getContextPath() %>/profile">
                                            <i class="fas fa-id-card me-2 text-primary"></i>Hồ sơ cá nhân
                                        </a></li>
                                        <li><a class="dropdown-item py-2" href="<%= request.getContextPath() %>/orders">
                                            <i class="fas fa-shopping-bag me-2 text-success"></i>Đơn hàng của tôi
                                        </a></li>
                                        <li><a class="dropdown-item py-2" href="<%= request.getContextPath() %>/wishlist">
                                            <i class="fas fa-heart me-2 text-danger"></i>Danh sách yêu thích
                                        </a></li>
                                        <li><hr class="dropdown-divider my-2"></li>
                                        <li><a class="dropdown-item py-2 text-danger" href="#" onclick="logout()">
                                            <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                                        </a></li>
                                    </ul>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <a href="<%= request.getContextPath() %>/login?force=1" class="btn btn-primary btn-sm px-4" style="border-radius: 20px; font-weight: 600;">
                                    <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
                                </a>
                                <span class="mx-2 text-muted">|</span>
                                <a href="<%= request.getContextPath() %>/register" class="btn btn-outline-primary btn-sm px-3" style="border-radius: 20px; font-weight: 600;">
                                    <i class="fas fa-user-plus me-2"></i>Đăng ký
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
        <style>
        .logo-enhanced {
            background: linear-gradient(135deg, #ffffff, #f8f9fa);
            padding: 20px 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }
        .brand-logo {
            transition: all 0.3s ease;
            text-decoration: none;
        }
        .brand-logo:hover {
            transform: scale(1.05);
        }
        .brand-logo h1 {
            background: linear-gradient(135deg, #0d6efd, #6f42c1);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-weight: 800;
        }
        .search-container {
            background: white;
            border-radius: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border: 2px solid #e9ecef;
            transition: all 0.3s ease;
        }
        .search-container:hover {
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
            border-color: #0d6efd;
        }
        .search-input {
            border: none !important;
            border-radius: 30px 0 0 30px !important;
            padding: 15px 20px !important;
            font-size: 16px;
        }
        .search-input:focus {
            box-shadow: none !important;
            border-color: transparent !important;
        }
        .search-select {
            border: none !important;
            border-left: 1px solid #dee2e6 !important;
            padding: 15px 10px !important;
            font-weight: 500;
        }
        .search-btn {
            border-radius: 0 30px 30px 0 !important;
            padding: 15px 20px !important;
            background: linear-gradient(135deg, #0d6efd, #6f42c1) !important;
            border: none !important;
            transition: all 0.3s ease;
        }
        .search-btn:hover {
            transform: scale(1.05);
            box-shadow: 0 4px 12px rgba(13, 110, 253, 0.4);
        }
        .stats-item {
            text-align: center;
            padding: 10px;
        }
        .stats-number {
            font-size: 24px;
            font-weight: 700;
            color: #0d6efd;
            display: block;
        }
        .stats-label {
            font-size: 12px;
            color: #6c757d;
            font-weight: 500;
        }
        </style>
        
        <div class="container-fluid px-5 py-4 d-none d-lg-block logo-enhanced">
            <div class="row gx-0 align-items-center">
                <div class="col-md-4 col-lg-3 text-center text-lg-start">
                    <div class="d-inline-flex align-items-center">
                        <a href="<%= request.getContextPath() %>/home" class="navbar-brand p-0 brand-logo">
                            <h1 class="display-5 m-0">
                                <i class="fas fa-gamepad me-3" style="color: #ff6b6b;"></i>
                                <span style="background: linear-gradient(135deg, #0d6efd, #6f42c1); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;">GameMarket</span>
                            </h1>
                            <small class="text-muted d-block mt-1" style="margin-left: 45px; font-size: 12px;">Premium Game Accounts</small>
                        </a>
                    </div>
                </div>
                <div class="col-md-4 col-lg-6 text-center">
                    <div class="position-relative">
                        <div class="d-flex search-container">
                            <input class="form-control search-input" type="text" 
                                   placeholder="Tìm kiếm tài khoản game..." 
                                   id="searchInput">
                            <select class="form-select search-select" style="width: 180px;" id="categorySelect">
                                <option value="all">Tất cả loại</option>
                                <option value="moba">MOBA</option>
                                <option value="fps">FPS</option>
                                <option value="rpg">RPG</option>
                                <option value="battle-royale">Battle Royale</option>
                            </select>
                            <button type="button" class="btn btn-primary search-btn" onclick="performSearch()">
                                <i class="fas fa-search"></i>
                            </button>
                        </div>
                        <!-- Search suggestions dropdown -->
                        <div id="searchSuggestions" class="position-absolute w-100 bg-white border border-top-0 rounded-bottom shadow-sm" style="top: 100%; z-index: 1050; display: none;">
                            <div class="p-2">
                                <small class="text-muted">Gợi ý tìm kiếm:</small>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 col-lg-3 text-center text-lg-end">
                    <div class="d-flex justify-content-center justify-content-lg-end">
                        <div class="stats-item me-3">
                            <span class="stats-number">1000+</span>
                            <span class="stats-label">Tài khoản</span>
                        </div>
                        <div class="stats-item me-3">
                            <span class="stats-number">500+</span>
                            <span class="stats-label">Khách hàng</span>
                        </div>
                        <div class="stats-item">
                            <span class="stats-number">24/7</span>
                            <span class="stats-label">Hỗ trợ</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Topbar End -->

        <style>
        .navbar-enhanced {
            background: linear-gradient(135deg, #0d6efd, #6f42c1) !important;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            border-top: 3px solid #ffd700;
        }
        .categories-dropdown {
            background: linear-gradient(135deg, #28a745, #20c997);
            border-radius: 25px;
            padding: 12px 20px;
            color: white;
            border: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .categories-dropdown:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(40, 167, 69, 0.3);
        }
        .nav-link-enhanced {
            color: white !important;
            font-weight: 600;
            padding: 12px 18px !important;
            border-radius: 20px;
            margin: 0 5px;
            transition: all 0.3s ease;
            position: relative;
        }
        .nav-link-enhanced:hover {
            background: rgba(255,255,255,0.15) !important;
            color: #ffd700 !important;
            transform: translateY(-2px);
        }
        .nav-link-enhanced.active {
            background: rgba(255,255,255,0.2) !important;
            color: #ffd700 !important;
        }
        .phone-btn {
            background: linear-gradient(135deg, #ffc107, #fd7e14) !important;
            border: none !important;
            border-radius: 25px !important;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .phone-btn:hover {
            transform: scale(1.05);
            box-shadow: 0 4px 12px rgba(255, 193, 7, 0.4);
        }
        </style>
        
        <!-- Navbar & Hero Start -->
        <div class="container-fluid nav-bar p-0">
            <div class="row gx-0 navbar-enhanced px-5 align-items-center">
                <div class="col-lg-3 d-none d-lg-block">
                    <nav class="navbar navbar-light position-relative" style="width: 280px;">
                        <button class="navbar-toggler categories-dropdown fs-5 w-100 px-0 text-start" type="button"
                                data-bs-toggle="collapse" data-bs-target="#allCat">
                            <h5 class="m-0"><i class="fas fa-th-large me-2"></i>Tất cả danh mục</h5>
                        </button>
                        <div class="collapse navbar-collapse rounded-bottom" id="allCat">
                            <div class="navbar-nav ms-auto py-0">
                                <ul class="list-unstyled categories-bars">
                                    <li>
                                        <div class="categories-bars-item">
                                            <a href="#">Accessories</a>
                                            <span>(3)</span>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="categories-bars-item">
                                            <a href="#">Electronics & Computer</a>
                                            <span>(5)</span>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="categories-bars-item">
                                            <a href="#">Laptops & Desktops</a>
                                            <span>(2)</span>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="categories-bars-item">
                                            <a href="#">Mobiles & Tablets</a>
                                            <span>(8)</span>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="categories-bars-item">
                                            <a href="#">SmartPhone & Smart TV</a>
                                            <span>(5)</span>
                                        </div>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </nav>
                </div>
                <div class="col-12 col-lg-9">
                    <nav class="navbar navbar-expand-lg navbar-light bg-primary">
                        <a href="" class="navbar-brand d-block d-lg-none">
                            <h1 class="display-5 text-secondary m-0"><i
                                    class="fas fa-shopping-bag text-white me-2"></i>gicungco</h1>
                            <!-- <img src="img/logo.png" alt="Logo"> -->
                        </a>
                        <button class="navbar-toggler ms-auto" type="button" data-bs-toggle="collapse"
                                data-bs-target="#navbarCollapse">
                            <span class="fa fa-bars fa-1x"></span>
                        </button>
                        <div class="collapse navbar-collapse" id="navbarCollapse">
                            <div class="navbar-nav ms-auto py-0">
                                <a href="<%= request.getContextPath() %>/home" class="nav-item nav-link nav-link-enhanced">
                                    <i class="fas fa-home me-2"></i>Trang chủ
                                </a>
                                <a href="<%= request.getContextPath() %>/products" class="nav-item nav-link nav-link-enhanced">
                                    <i class="fas fa-gamepad me-2"></i>Game Accounts
                                </a>
                                <a href="<%= request.getContextPath() %>/promotions" class="nav-item nav-link nav-link-enhanced">
                                    <i class="fas fa-tags me-2"></i>Khuyến mãi
                                </a>
                                <a href="<%= request.getContextPath() %>/categories" class="nav-item nav-link nav-link-enhanced">
                                    <i class="fas fa-th-list me-2"></i>Danh mục
                                </a>
                                
                                <!-- Role-based navigation -->
                                <jsp:include page="role-navigation.jsp" />
                                
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user}">
                                        <div class="nav-item dropdown">
                                            <a href="#" class="nav-link dropdown-toggle me-2 nav-link-enhanced" data-bs-toggle="dropdown">
                                                <i class="fas fa-user-circle me-1"></i>
                                                <span class="fw-bold">${sessionScope.user.full_name}</span>
                                            </a>
                                            <div class="dropdown-menu dropdown-menu-end shadow-sm border-0" style="border-radius: 12px; margin-top: 10px;">
                                                <h6 class="dropdown-header"><i class="fas fa-user me-2"></i>Tài khoản</h6>
                                                <a class="dropdown-item py-2" href="<%= request.getContextPath() %>/profile">
                                                    <i class="fas fa-id-card me-2 text-primary"></i>Hồ sơ cá nhân
                                                </a>
                                                <a class="dropdown-item py-2" href="<%= request.getContextPath() %>/orders">
                                                    <i class="fas fa-shopping-bag me-2 text-success"></i>Đơn hàng
                                                </a>
                                                <a class="dropdown-item py-2" href="<%= request.getContextPath() %>/wishlist">
                                                    <i class="fas fa-heart me-2 text-danger"></i>Yêu thích
                                                </a>
                                                <div class="dropdown-divider my-2"></div>
                                                <a class="dropdown-item py-2 text-danger" href="#" onclick="logout()">
                                                    <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                                                </a>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="<%= request.getContextPath() %>/login?force=1" class="nav-item nav-link me-2 nav-link-enhanced">
                                            <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                                <div class="nav-item dropdown d-block d-lg-none mb-3">
                                    <a href="#" class="nav-link" data-bs-toggle="dropdown"><span class="dropdown-toggle">All
                                            Category</span></a>
                                    <div class="dropdown-menu m-0">
                                        <ul class="list-unstyled categories-bars">
                                            <li>
                                                <div class="categories-bars-item">
                                                    <a href="#">Accessories</a>
                                                    <span>(3)</span>
                                                </div>
                                            </li>
                                            <li>
                                                <div class="categories-bars-item">
                                                    <a href="#">Electronics & Computer</a>
                                                    <span>(5)</span>
                                                </div>
                                            </li>
                                            <li>
                                                <div class="categories-bars-item">
                                                    <a href="#">Laptops & Desktops</a>
                                                    <span>(2)</span>
                                                </div>
                                            </li>
                                            <li>
                                                <div class="categories-bars-item">
                                                    <a href="#">Mobiles & Tablets</a>
                                                    <span>(8)</span>
                                                </div>
                                            </li>
                                            <li>
                                                <div class="categories-bars-item">
                                                    <a href="#">SmartPhone & Smart TV</a>
                                                    <span>(5)</span>
                                                </div>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <a href="<%= request.getContextPath() %>/views/chat/chat.jsp" class="nav-item nav-link nav-link-enhanced me-2" title="Tin nhắn">
                                <i class="fas fa-comments me-2"></i>Chat
                            </a>
                            <a href="tel:+0123456789" class="btn phone-btn rounded-pill py-3 px-4 mb-3 mb-md-3 mb-lg-0">
                                <i class="fas fa-phone-alt me-2"></i>
                                <strong>Hotline: 0123 456 789</strong>
                            </a>
                        </div>
                    </nav>
                </div>
            </div>
        </div>
        <!-- Navbar & Hero End -->

        <!-- Chat Widget is loaded in footer.jsp -->

        <script>
            // Enhanced search functionality
            function performSearch() {
                const searchInput = document.getElementById('searchInput');
                const categorySelect = document.getElementById('categorySelect');
                const searchTerm = searchInput.value.trim();
                const category = categorySelect.value;
                
                if (searchTerm === '') {
                    showToast('Vui lòng nhập từ khóa tìm kiếm!', 'warning');
                    return;
                }
                
                // Show loading state
                const searchBtn = document.querySelector('.search-btn');
                const originalContent = searchBtn.innerHTML;
                searchBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
                searchBtn.disabled = true;
                
                // Simulate search (replace with actual search logic)
                setTimeout(() => {
                    const searchUrl = `<%= request.getContextPath() %>/products?search=${encodeURIComponent(searchTerm)}&category=${category}`;
                    window.location.href = searchUrl;
                }, 1000);
            }
            
            // Search on Enter key
            document.addEventListener('DOMContentLoaded', function() {
                const searchInput = document.getElementById('searchInput');
                if (searchInput) {
                    searchInput.addEventListener('keypress', function(e) {
                        if (e.key === 'Enter') {
                            performSearch();
                        }
                    });
                    
                    // Auto-suggestions (simple implementation)
                    searchInput.addEventListener('input', function() {
                        const value = this.value.toLowerCase();
                        const suggestions = document.getElementById('searchSuggestions');
                        
                        if (value.length > 2) {
                            // Show suggestions
                            suggestions.style.display = 'block';
                            suggestions.innerHTML = `
                                <div class="p-2">
                                    <small class="text-muted">Gợi ý tìm kiếm:</small>
                                    <div class="mt-2">
                                        <div class="suggestion-item p-2 border-bottom cursor-pointer" onclick="selectSuggestion('League of Legends')">
                                            <i class="fas fa-search me-2 text-muted"></i>League of Legends
                                        </div>
                                        <div class="suggestion-item p-2 border-bottom cursor-pointer" onclick="selectSuggestion('PUBG Mobile')">
                                            <i class="fas fa-search me-2 text-muted"></i>PUBG Mobile
                                        </div>
                                        <div class="suggestion-item p-2 cursor-pointer" onclick="selectSuggestion('Valorant')">
                                            <i class="fas fa-search me-2 text-muted"></i>Valorant
                                        </div>
                                    </div>
                                </div>
                            `;
                        } else {
                            suggestions.style.display = 'none';
                        }
                    });
                    
                    // Hide suggestions when clicking outside
                    document.addEventListener('click', function(e) {
                        const suggestions = document.getElementById('searchSuggestions');
                        if (!e.target.closest('.search-container') && !e.target.closest('#searchSuggestions')) {
                            suggestions.style.display = 'none';
                        }
                    });
                }
            });
            
            function selectSuggestion(text) {
                document.getElementById('searchInput').value = text;
                document.getElementById('searchSuggestions').style.display = 'none';
                performSearch();
            }
            
            // Enhanced toast notifications
            function showToast(message, type = 'info') {
                const toastContainer = document.querySelector('.position-fixed.top-0.end-0.p-3');
                const toastId = 'toast-' + Date.now();
                let bgClass, iconClass;
                
                switch(type) {
                    case 'success':
                        bgClass = 'bg-success';
                        iconClass = 'fas fa-check-circle';
                        break;
                    case 'warning':
                        bgClass = 'bg-warning';
                        iconClass = 'fas fa-exclamation-triangle';
                        break;
                    case 'error':
                        bgClass = 'bg-danger';
                        iconClass = 'fas fa-times-circle';
                        break;
                    default:
                        bgClass = 'bg-info';
                        iconClass = 'fas fa-info-circle';
                }
                
                const toastHtml = `
                    <div id="${toastId}" class="toast align-items-center text-white ${bgClass} border-0" role="alert" aria-live="assertive" aria-atomic="true" style="border-radius: 12px;">
                        <div class="d-flex">
                            <div class="toast-body d-flex align-items-center">
                                <i class="${iconClass} me-2"></i>
                                ${message}
                            </div>
                            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                        </div>
                    </div>
                `;
                
                toastContainer.insertAdjacentHTML('beforeend', toastHtml);
                
                const toastElement = document.getElementById(toastId);
                const toast = new bootstrap.Toast(toastElement, {delay: 4000});
                toast.show();
                
                toastElement.addEventListener('hidden.bs.toast', function() {
                    toastElement.remove();
                });
            }
            
            function logout() {
                if (confirm('Bạn có chắc chắn muốn đăng xuất?')) {
                    fetch('<%= request.getContextPath() %>/logout?ajax=true', {
                        method: 'GET',
                        headers: {
                            'Content-Type': 'application/json',
                        }
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            // Show success message
                            showToast(data.message, 'success');
                            
                            // Update UI to show logged out state
                            updateLogoutUI();
                        } else {
                            showToast(data.message, 'error');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        showToast('Có lỗi xảy ra khi đăng xuất!', 'error');
                    });
                }
            }
            
            function updateLogoutUI() {
                // Update top bar logout button
                const topBarLogoutBtn = document.querySelector('.btn-outline-danger');
                if (topBarLogoutBtn) {
                    topBarLogoutBtn.outerHTML = '<a href="<%= request.getContextPath() %>/login?force=1" class="btn btn-outline-primary btn-sm px-3"><i class="bi bi-person me-1"></i>Đăng nhập / Đăng ký</a>';
                }
                
                // Update navbar logout button
                const navLogoutBtn = document.querySelector('.nav-item.nav-link.me-2.btn.btn-link');
                if (navLogoutBtn) {
                    navLogoutBtn.outerHTML = '<a href="<%= request.getContextPath() %>/login?force=1" class="nav-item nav-link me-2">Đăng nhập / Đăng ký</a>';
                }
            }
            
            function showToast(message, type) {
                // Create toast element
                const toastContainer = document.querySelector('.position-fixed.top-0.end-0.p-3');
                const toastId = 'toast-' + Date.now();
                const bgClass = type === 'success' ? 'bg-success' : 'bg-danger';
                
                const toastHtml = `
                    <div id="${toastId}" class="toast align-items-center text-white ${bgClass} border-0" role="alert" aria-live="assertive" aria-atomic="true">
                        <div class="d-flex">
                            <div class="toast-body">${message}</div>
                            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                        </div>
                    </div>
                `;
                
                toastContainer.insertAdjacentHTML('beforeend', toastHtml);
                
                // Show toast
                const toastElement = document.getElementById(toastId);
                const toast = new bootstrap.Toast(toastElement, {delay: 3000});
                toast.show();
                
                // Remove toast element after it's hidden
                toastElement.addEventListener('hidden.bs.toast', function() {
                    toastElement.remove();
                });
            }
        </script>
        
