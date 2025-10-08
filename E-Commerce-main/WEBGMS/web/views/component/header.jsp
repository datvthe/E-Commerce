<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>Gicungco Marketplace System</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="" name="keywords">
        <meta content="" name="description">

        <!-- Google Web Fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link
            href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500;600;700&family=Roboto:wght@400;500;700&display=swap"
            rel="stylesheet">

        <!-- Icon Font Stylesheet -->
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Libraries Stylesheet -->
        <link href="<%= request.getContextPath() %>/views/assets/user/lib/animate/animate.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath() %>/views/assets/user/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">


        <!-- Customized Bootstrap Stylesheet -->
        <link href="<%= request.getContextPath() %>/views/assets/user/css/bootstrap.min.css" rel="stylesheet">

        <!-- Template Stylesheet -->
        <link href="<%= request.getContextPath() %>/views/assets/user/css/style.css" rel="stylesheet">
    </head>

    <body>
<!--         Spinner Start 
        <div id="spinner"
             class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
            <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
                <span class="sr-only">Loading...</span>
            </div>
        </div>
         Spinner End -->
        <%-- Temporarily disable notifications to resolve JSP compile error --%>
        <%-- <jsp:include page="/views/component/notification.jsp" /> --%>


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
                    <div class="d-inline-flex align-items-center" style="height: 45px;">
                        <span class="text-muted me-3"><small>VND</small></span>
                        <span class="text-muted mx-2"><small>Tiếng Việt</small></span>
                        <div class="dropdown">
                            <a href="#" class="dropdown-toggle text-muted ms-2" data-bs-toggle="dropdown"><small><i
                                        class="fa fa-home me-2"></i> Tài khoản</small></a>
                            <div class="dropdown-menu rounded">
                                <a href="<%= request.getContextPath() %>/login?force=1" class="dropdown-item" onclick="window.location.href=this.href; return false;"> Đăng nhập / Đăng ký</a>
                                <a href="<%= request.getContextPath() %>/logout" class="dropdown-item" onclick="window.location.href=this.href; return false;"> Đăng xuất</a>
                            </div>
                        </div>
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
                        <a href="<%= request.getContextPath() %>/cart" class="text-muted d-flex align-items-center justify-content-center"><span
                                class="rounded-circle btn-md-square border"><i class="fas fa-shopping-cart"></i></span>
                            <span class="text-dark ms-2">0₫</span></a>
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
                                <a href="<%= request.getContextPath() %>/login" class="nav-item nav-link">Danh mục sản phẩm</a>
                                <a href="<%= request.getContextPath() %>/login" class="nav-item nav-link">Khuyến mãi</a>
                                <a href="<%= request.getContextPath() %>/login" class="nav-item nav-link">Giỏ hàng</a>
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user}">
                                        <a href="<%= request.getContextPath() %>/logout" class="nav-item nav-link me-2">Đăng xuất</a>
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


    </body>
</html>
