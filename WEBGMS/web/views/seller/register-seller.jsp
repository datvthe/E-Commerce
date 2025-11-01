<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Đăng ký bán hàng | Gicungco</title>

        <!-- Bootstrap + Icon -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

        <style>
            body {
                background-color: #fff8f0;
                font-family: 'Segoe UI', sans-serif;
            }
            .register-card {
                background: #fff;
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                padding: 40px;
                margin-top: 50px;
            }
            .title {
                color: #ff7b00;
                font-weight: 700;
                text-align: center;
                margin-bottom: 25px;
            }
            .btn-orange {
                background-color: #ff7b00;
                color: white;
                border: none;
                transition: all 0.3s ease;
            }
            .btn-orange:hover {
                background-color: #e36c00;
            }
            label {
                font-weight: 500;
                color: #444;
            }
            .form-control:focus {
                border-color: #ff7b00;
                box-shadow: 0 0 0 0.2rem rgba(255, 123, 0, 0.25);
            }
        </style>
    </head>
    <body>

        <div class="container col-lg-8 col-md-10">
            <div class="register-card">
                <h2 class="title"><i class="bi bi-shop me-2"></i>Đăng ký bán hàng</h2>
                <form action="${pageContext.request.contextPath}/seller/register" method="post">

                    <!-- Thông tin cơ bản -->
                    <h5 class="text-orange mb-3 mt-4">Thông tin cá nhân</h5>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label>Họ và tên</label>
                            <input type="text" name="fullName" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label>Email</label>
                            <input type="email" name="email" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label>Số điện thoại</label>
                            <input type="text" name="phone" class="form-control">
                        </div>
                    </div>

                    <!-- Thông tin shop -->
                    <h5 class="text-orange mb-3 mt-4">Thông tin cửa hàng</h5>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label>Tên cửa hàng</label>
                            <input type="text" name="shopName" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label>Danh mục chính</label>
                            <select name="mainCategory" class="form-control">
                                <option value="">-- Chọn danh mục --</option>
                                <option value="Tài khoản game">Tài khoản game</option>
                                <option value="Mã phim, phần mềm">Mã phim, phần mềm</option>
                                <option value="Thẻ cào, giftcode">Thẻ cào / giftcode</option>
                                <option value="Khác">Khác</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label>Mô tả cửa hàng</label>
                            <textarea name="shopDescription" rows="3" class="form-control" placeholder="Giới thiệu ngắn gọn về sản phẩm, dịch vụ bạn cung cấp..."></textarea>
                        </div>
                    </div>

                    <!-- Thông tin thanh toán -->
                    <h5 class="text-orange mb-3 mt-4">Thông tin thanh toán</h5>
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label>Ngân hàng</label>
                            <select name="bankName" class="form-control">
                                <option value="">-- Chọn ngân hàng --</option>
                                <option value="Vietcombank">Vietcombank - Ngân hàng Ngoại thương Việt Nam</option>
                                <option value="BIDV">BIDV - Ngân hàng Đầu tư và Phát triển Việt Nam</option>
                                <option value="Vietinbank">Vietinbank - Ngân hàng Công thương Việt Nam</option>
                                <option value="Agribank">Agribank - Ngân hàng Nông nghiệp và Phát triển Nông thôn</option>
                                <option value="Techcombank">Techcombank - Ngân hàng Kỹ thương Việt Nam</option>
                                <option value="ACB">ACB - Ngân hàng Á Châu</option>
                                <option value="MBBank">MBBank - Ngân hàng Quân đội</option>
                                <option value="VPBank">VPBank - Ngân hàng Việt Nam Thịnh Vượng</option>
                                <option value="TPBank">TPBank - Ngân hàng Tiên Phong</option>
                                <option value="Sacombank">Sacombank - Ngân hàng TMCP Sài Gòn Thương Tín</option>
                                <option value="VIB">VIB - Ngân hàng Quốc tế</option>
                                <option value="SHB">SHB - Ngân hàng Sài Gòn - Hà Nội</option>
                                <option value="HDBank">HDBank - Ngân hàng Phát triển Thành phố Hồ Chí Minh</option>
                                <option value="Eximbank">Eximbank - Ngân hàng Xuất Nhập khẩu Việt Nam</option>
                                <option value="MSB">MSB - Ngân hàng Hàng Hải</option>
                                <option value="SeABank">SeABank - Ngân hàng Đông Nam Á</option>
                                <option value="PVcomBank">PVcomBank - Ngân hàng Đại Chúng</option>
                                <option value="OCB">OCB - Ngân hàng Phương Đông</option>
                                <option value="NCB">NCB - Ngân hàng Quốc Dân</option>
                                <option value="NamABank">NamABank - Ngân hàng Nam Á</option>
                                <option value="ABBank">ABBank - Ngân hàng An Bình</option>
                                <option value="VietABank">VietABank - Ngân hàng Việt Á</option>
                                <option value="BacABank">BacABank - Ngân hàng Bắc Á</option>
                                <option value="PGBank">PGBank - Ngân hàng Xăng dầu Petrolimex</option>
                                <option value="PublicBank">PublicBank - Ngân hàng Đại chúng</option>
                                <option value="KienLongBank">KienLongBank - Ngân hàng Kiên Long</option>
                                <option value="LPBank">LPBank - Ngân hàng Lào - Việt</option>
                                <option value="HSBC">HSBC - Ngân hàng TNHH MTV HSBC</option>
                                <option value="Standard Chartered">Standard Chartered - Ngân hàng TNHH Standard Chartered</option>
                                <option value="HongLeong">HongLeong Bank - Ngân hàng TNHH MTV Hong Leong Việt Nam</option>
                                <option value="Woori">Woori Bank - Ngân hàng TNHH MTV Woori Việt Nam</option>
                                <option value="Shinhan">Shinhan Bank - Ngân hàng TNHH MTV Shinhan Việt Nam</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label>Số tài khoản</label>
                            <input type="text" name="bankAccount" class="form-control">
                        </div>
                        <div class="col-md-4">
                            <label>Chủ tài khoản</label>
                            <input type="text" name="accountOwner" class="form-control">
                        </div>
                    </div>

                    <!-- Chú ý -->
                    <h5 class="text-orange mb-3 mt-4">Chú ý</h5>
                    <div class="p-3 mt-2 rounded" style="background:#fff3e0;border:1px solid #ffb74d;font-size:15px;">
                        ⚠️ <strong>Chú ý:</strong> Bạn sẽ bị trừ <strong>200.000₫</strong> trong số dư để có thể bán hàng.
                    </div>

                    <c:choose>
                        <c:when test="${walletBalance < 200000}">
                            <div class="alert alert-danger mt-3" style="font-size:15px;">
                                ❗ Nếu số dư của bạn <strong>nhỏ hơn 200.000₫</strong>, vui lòng nạp thêm tiền trước khi đăng ký bán hàng.
                                <br>
                                💰 <strong>Số dư hiện tại:</strong>
                                <span style="color:#b30000; font-weight:600;">
                                    ${String.format("%,.0f", walletBalance)}₫
                                </span>
                                <br>
                                <a href="${pageContext.request.contextPath}/wallet" class="btn btn-sm btn-danger mt-2">
                                    <i class="bi bi-wallet2 me-1"></i> Nạp thêm tiền
                                </a>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <div class="alert alert-success mt-3" style="font-size:15px;">
                                ✅ Bạn đủ điều kiện đăng ký bán hàng.
                                <br>
                                💰 <strong>Số dư hiện tại:</strong>
                                <span style="color:#007bff; font-weight:600;">
                                    ${String.format("%,.0f", walletBalance)}₫
                                </span>
                            </div>
                        </c:otherwise>
                    </c:choose>


                    <!-- Điều khoản bán hàng -->
                    <h5 class="text-orange mb-3 mt-4">Điều khoản bán hàng</h5>
                    <div class="border rounded p-3" style="background-color:#fffdf8; max-height:250px; overflow-y:auto; font-size:15px;">
                        <p><strong>1. Phí đăng ký:</strong> Người bán đồng ý bị trừ 200.000₫ trong số dư tài khoản để kích hoạt gian hàng.</p>
                        <p><strong>2. Quy định sản phẩm:</strong> Sản phẩm đăng bán phải hợp pháp, đúng mô tả và không vi phạm quy định pháp luật Việt Nam.</p>
                        <p><strong>3. Giao dịch và thanh toán:</strong> Tất cả giao dịch phải thực hiện thông qua hệ thống Gicungco để đảm bảo an toàn.</p>
                        <p><strong>4. Chính sách hoàn tiền:</strong> Phí 200.000₫ có thể được hoàn lại khi người bán ngừng kinh doanh hoặc bị từ chối đăng ký.</p>
                        <p><strong>5. Trách nhiệm người bán:</strong> Người bán chịu trách nhiệm về chất lượng, nguồn gốc sản phẩm, và các khiếu nại của khách hàng.</p>
                        <p><strong>6. Vi phạm:</strong> Nếu phát hiện hành vi gian lận, Gicungco có quyền khóa tài khoản và không hoàn phí.</p>
                    </div>

                    <!-- Đồng ý điều khoản -->
                    <div class="form-check mt-4">
                        <input class="form-check-input" type="checkbox" id="agreeTerms" name="agreeTerms" required>
                        <label class="form-check-label" for="agreeTerms">
                            Tôi đã đọc và <strong>đồng ý</strong> với tất cả điều khoản bán hàng ở trên.
                        </label>
                    </div>

                    <div class="text-center mt-5">
                        <button type="submit" class="btn btn-orange px-5 py-2">
                            <i class="bi bi-send-fill me-2"></i>Gửi đăng ký
                        </button>
                    </div>
                    <script>
                        document.addEventListener("DOMContentLoaded", function () {
                            const requiredBalance = 200000;
                            const currentBalance = ${currentBalance}; // 👈 Số dư truyền từ server vào
                            const balanceAlert = document.getElementById("balanceAlert");
                            const submitBtn = document.getElementById("submitBtn");

                            if (currentBalance < requiredBalance) {
                                balanceAlert.classList.remove("d-none");
                                submitBtn.disabled = true;
                                submitBtn.classList.add("disabled");
                            } else {
                                balanceAlert.classList.add("d-none");
                                submitBtn.disabled = false;
                                submitBtn.classList.remove("disabled");
                            }
                        });
                    </script>


                </form>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
