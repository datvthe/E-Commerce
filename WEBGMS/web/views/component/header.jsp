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

        <!-- Topbar Start -->
        <div class="container-fluid px-5 d-none border-bottom d-lg-block">
            <div class="row gx-0 align-items-center">
                <div class="col-lg-4 text-center text-lg-start mb-lg-0">
                    <div class="d-inline-flex align-items-center" style="height: 45px;">
                        <a href="#" class="text-muted me-2"> Hỗ trợ</a><small> / </small>
                        <a href="#" class="text-muted mx-2"> Trợ giúp</a><small> / </small>
                        <a href="#" class="text-muted ms-2"> Liên hệ</a>
                    </div>
                </div>
                <div class="col-lg-4 text-center d-flex align-items-center justify-content-center">
                    <small class="text-dark">Gọi chúng tôi:</small>
                    <a href="#" class="text-muted">(+012) 1234 567890</a>
                </div>

                <div class="col-lg-4 text-center text-lg-end">
                    <div class="d-inline-flex align-items-center gap-2" style="height: 45px;">
                        <span class="text-muted me-3"><small>VND</small></span>
                        <span class="text-muted mx-2"><small>Tiếng Việt</small></span>
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <div class="dropdown">
                                    <button class="btn btn-outline-primary btn-sm px-3 dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                        <i class="bi bi-person me-1"></i>${sessionScope.user.full_name}
                                    </button>
                                    <ul class="dropdown-menu">
                                        <li><a class="dropdown-item" href="<%= request.getContextPath() %>/profile"><i class="fas fa-user me-2"></i>Hồ sơ cá nhân</a></li>
                                        <li><a class="dropdown-item" href="<%= request.getContextPath() %>/orders"><i class="fas fa-shopping-bag me-2"></i>Đơn hàng</a></li>
                                        <li><a class="dropdown-item" href="<%= request.getContextPath() %>/wishlist"><i class="fas fa-heart me-2"></i>Yêu thích</a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item" href="#" onclick="logout()"><i class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a></li>
                                    </ul>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <a href="<%= request.getContextPath() %>/login?force=1" class="btn btn-outline-primary btn-sm px-3"><i class="bi bi-person me-1"></i>Đăng nhập / Đăng ký</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
        <div class="container-fluid px-5 py-4 d-none d-lg-block">
            <div class="row gx-0 align-items-center text-center">
                <div class="col-md-4 col-lg-3 text-center text-lg-start">
                    <div class="d-inline-flex align-items-center">
                        <a href="" class="navbar-brand p-0">
                            <h1 class="display-5 text-primary m-0"><i
                                    class="fas fa-shopping-bag text-secondary me-2"></i>gicungco</h1>
                            <!-- <img src="img/logo.png" alt="Logo"> -->
                        </a>
                    </div>
                </div>
                <div class="col-md-4 col-lg-6 text-center">
                    <div class="position-relative ps-4">
                        <div class="d-flex border rounded-pill">
                            <input class="form-control border-0 rounded-pill w-100 py-3" type="text"
                                   data-bs-target="#dropdownToggle123" placeholder="Tìm kiếm sản phẩm">
                            <select class="form-select text-dark border-0 border-start rounded-0 p-3" style="width: 200px;">
                                <option value="All Category">All Category</option>
                                <option value="Pest Control-2">Category 1</option>
                                <option value="Pest Control-3">Category 2</option>
                                <option value="Pest Control-4">Category 3</option>
                                <option value="Pest Control-5">Category 4</option>
                            </select>
                            <button type="button" class="btn btn-primary rounded-pill py-3 px-5" style="border: 0;"><i
                                    class="fas fa-search"></i></button>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 col-lg-3 text-center text-lg-end">
                    <div class="d-inline-flex align-items-center">
                        <!-- Cart removed -->
                    </div>
                </div>
            </div>
        </div>
        <!-- Topbar End -->

        <!-- Navbar & Hero Start -->
        <div class="container-fluid nav-bar p-0">
            <div class="row gx-0 bg-primary px-5 align-items-center">
                <div class="col-lg-3 d-none d-lg-block">
                    <nav class="navbar navbar-light position-relative" style="width: 250px;">
                        <button class="navbar-toggler border-0 fs-4 w-100 px-0 text-start" type="button"
                                data-bs-toggle="collapse" data-bs-target="#allCat">
                            <h4 class="m-0"><i class="fa fa-bars me-2"></i>All Categories</h4>
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
                                <a href="<%= request.getContextPath() %>/home" class="nav-item nav-link">Trang chủ</a>
                                <a href="<%= request.getContextPath() %>/products" class="nav-item nav-link">Danh mục sản phẩm</a>
                                <a href="<%= request.getContextPath() %>/promotions" class="nav-item nav-link">Khuyến mãi</a>
                                
                                <!-- Role-based navigation -->
                                <jsp:include page="role-navigation.jsp" />
                                
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user}">
                                        <div class="nav-item dropdown">
                                            <a href="#" class="nav-link dropdown-toggle me-2" data-bs-toggle="dropdown">
                                                <i class="fas fa-user me-1"></i>${sessionScope.user.full_name}
                                            </a>
                                            <div class="dropdown-menu">
                                                <a class="dropdown-item" href="<%= request.getContextPath() %>/profile"><i class="fas fa-user me-2"></i>Hồ sơ cá nhân</a>
                                                <a class="dropdown-item" href="<%= request.getContextPath() %>/orders"><i class="fas fa-shopping-bag me-2"></i>Đơn hàng</a>
                                                <a class="dropdown-item" href="<%= request.getContextPath() %>/wishlist"><i class="fas fa-heart me-2"></i>Yêu thích</a>
                                                <div class="dropdown-divider"></div>
                                                <a class="dropdown-item" href="#" onclick="logout()"><i class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="<%= request.getContextPath() %>/login?force=1" class="nav-item nav-link me-2">Đăng nhập / Đăng ký</a>
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
                            <a href="#" class="btn btn-secondary rounded-pill py-2 px-4 px-lg-3 mb-3 mb-md-3 mb-lg-0"><i
                                    class="fa fa-mobile-alt me-2"></i> +0123 456 7890</a>
                        </div>
                    </nav>
                </div>
            </div>
        </div>
        <!-- Navbar & Hero End -->

        <script>
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
        
