<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Nộp tiền cọc</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/electro/css/bootstrap.min.css">
    <style>
        body { background: #fffaf2; font-family: 'Open Sans', sans-serif; }
        .deposit-box {
            max-width: 600px; margin: 80px auto; padding: 30px;
            background: white; border-radius: 15px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        .btn-orange { background-color: #ff7b00; border: none; color: white; }
        .btn-orange:hover { background-color: #e06a00; }
    </style>
</head>
<body>
    <div class="deposit-box text-center">
        <h3 class="mb-3 text-uppercase text-orange">Nộp tiền cọc</h3>
        <p class="text-muted">Vui lòng chuyển khoản <b>500.000đ</b> vào tài khoản dưới đây và tải lên biên lai xác nhận.</p>
        <hr>
        <p><b>Ngân hàng:</b> Vietcombank<br>
           <b>Số tài khoản:</b> 0123456789<br>
           <b>Chủ tài khoản:</b> GICUNGCO CO., LTD</p>
        <img src="${pageContext.request.contextPath}/views/assets/images/qrcode-vcb.png" width="150" class="my-3" alt="QR Code">
        <form action="${pageContext.request.contextPath}/seller/deposit" method="post" enctype="multipart/form-data">
            <div class="mb-3">
                <label for="depositProof" class="form-label">Tải lên biên lai chuyển khoản</label>
                <input type="file" name="depositProof" id="depositProof" class="form-control" required>
            </div>
            <input type="hidden" name="depositAmount" value="500000">
            <button type="submit" class="btn btn-orange w-100 py-2">Xác nhận đã chuyển khoản</button>
        </form>
    </div>
</body>
</html>
