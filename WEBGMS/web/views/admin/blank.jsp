<%-- 
    Document   : admin-dashboard
    Created on : Sep 20, 2025, 11:52:17 AM
    Author     : trant
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>

        <title>Blank Page | PlainAdmin Demo</title>

    </head>
    <body>
        <jsp:include page="/views/component/sidebar.jsp" />


        <!-- ======== main-wrapper start =========== -->
        <main class="main-wrapper">

            <jsp:include page="/views/component/headerAdmin.jsp" />

            <!-- ========== section start ========== -->
            <section class="section">
                <div class="container-fluid">
                    <!-- ========== title-wrapper start ========== -->
                    <div class="title-wrapper pt-30">
                        <div class="row align-items-center">
                            <div class="col-md-6">
                                <div class="title">
                                    <h2>Title</h2>
                                </div>
                            </div>
                            <!-- end col -->
                            <div class="col-md-6">
                                <div class="breadcrumb-wrapper">
                                    <nav aria-label="breadcrumb">
                                        <ol class="breadcrumb">
                                            <li class="breadcrumb-item">
                                                <a href="#0">Dashboard</a>
                                            </li>
                                            <li class="breadcrumb-item active" aria-current="page">
                                                Page
                                            </li>
                                        </ol>
                                    </nav>
                                </div>
                            </div>
                            <!-- end col -->
                        </div>
                        <!-- end row -->
                    </div>
                    <!-- ========== title-wrapper end ========== -->
                </div>
                <!-- end container -->
            </section>
            <!-- ========== section end ========== -->


        </main>

    </body>
</html>
