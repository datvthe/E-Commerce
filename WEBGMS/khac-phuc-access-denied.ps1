# Script khac phuc loi Access Denied
# Chay script nay sau khi sua code

Write-Host "================================================" -ForegroundColor Cyan
Write-Host " KHAC PHUC LOI ACCESS DENIED" -ForegroundColor Yellow
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Kiem tra xem dang o dung thu muc chua
if (-not (Test-Path "build.xml")) {
    Write-Host "[ERROR] Khong tim thay build.xml" -ForegroundColor Red
    Write-Host "Vui long chay script nay trong thu muc WEBGMS" -ForegroundColor Red
    pause
    exit 1
}

Write-Host "[1/5] Kiem tra cac file da duoc sua..." -ForegroundColor Green

$files = @(
    "src\java\controller\seller\SellerNotificationController.java",
    "src\java\controller\seller\SellerCloseShopController.java",
    "web\WEB-INF\web.xml"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "  [OK] $file" -ForegroundColor Green
    } else {
        Write-Host "  [ERROR] Khong tim thay: $file" -ForegroundColor Red
        pause
        exit 1
    }
}

Write-Host ""
Write-Host "[2/5] Kiem tra import Users trong controller..." -ForegroundColor Green

$notification = Get-Content "src\java\controller\seller\SellerNotificationController.java" -Raw
if ($notification -match "import model\.user\.Users") {
    Write-Host "  [OK] SellerNotificationController da import Users" -ForegroundColor Green
} else {
    Write-Host "  [ERROR] SellerNotificationController chua import Users!" -ForegroundColor Red
    pause
    exit 1
}

$closeShop = Get-Content "src\java\controller\seller\SellerCloseShopController.java" -Raw
if ($closeShop -match "import model\.user\.Users") {
    Write-Host "  [OK] SellerCloseShopController da import Users" -ForegroundColor Green
} else {
    Write-Host "  [ERROR] SellerCloseShopController chua import Users!" -ForegroundColor Red
    pause
    exit 1
}

Write-Host ""
Write-Host "[3/5] Kiem tra servlet mapping trong web.xml..." -ForegroundColor Green

$webxml = Get-Content "web\WEB-INF\web.xml" -Raw
if ($webxml -match "SellerNotificationController") {
    Write-Host "  [OK] SellerNotificationController da duoc them vao web.xml" -ForegroundColor Green
} else {
    Write-Host "  [WARNING] Chua thay mapping cho SellerNotificationController" -ForegroundColor Yellow
}

if ($webxml -match "SellerCloseShopController") {
    Write-Host "  [OK] SellerCloseShopController da duoc them vao web.xml" -ForegroundColor Green
} else {
    Write-Host "  [WARNING] Chua thay mapping cho SellerCloseShopController" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[4/5] Xoa file class cu (neu co)..." -ForegroundColor Green

if (Test-Path "build\web\WEB-INF\classes\controller\seller") {
    Write-Host "  Dang xoa cac file .class cu..." -ForegroundColor Yellow
    Remove-Item "build\web\WEB-INF\classes\controller\seller\SellerNotificationController.class" -ErrorAction SilentlyContinue
    Remove-Item "build\web\WEB-INF\classes\controller\seller\SellerCloseShopController.class" -ErrorAction SilentlyContinue
    Write-Host "  [OK] Da xoa file class cu" -ForegroundColor Green
} else {
    Write-Host "  [INFO] Chua co file class cu" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "[5/5] CAC BUOC TIEP THEO:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  BUOC 1: Build lai project" -ForegroundColor White
Write-Host "  ----------------------------------------" -ForegroundColor Gray
Write-Host "  Trong NetBeans:" -ForegroundColor Cyan
Write-Host "  - Right-click vao project WEBGMS" -ForegroundColor White
Write-Host "  - Chon 'Clean and Build'" -ForegroundColor White
Write-Host ""
Write-Host "  Hoac chay lenh:" -ForegroundColor Cyan
Write-Host "  ant clean" -ForegroundColor Green
Write-Host "  ant compile" -ForegroundColor Green
Write-Host ""

Write-Host "  BUOC 2: Khoi dong lai Tomcat" -ForegroundColor White
Write-Host "  ----------------------------------------" -ForegroundColor Gray
Write-Host "  1. Stop Tomcat server trong NetBeans" -ForegroundColor White
Write-Host "  2. Doi 5 giay" -ForegroundColor White
Write-Host "  3. Start Tomcat server lai" -ForegroundColor White
Write-Host ""

Write-Host "  BUOC 3: Dang nhap lai" -ForegroundColor White
Write-Host "  ----------------------------------------" -ForegroundColor Gray
Write-Host "  1. Truy cap: http://localhost:9999/WEBGMS/login" -ForegroundColor Cyan
Write-Host "  2. Dang nhap voi tai khoan SELLER" -ForegroundColor White
Write-Host "     (Chu y: Phai la tai khoan co role_id = 2)" -ForegroundColor Yellow
Write-Host ""

Write-Host "  BUOC 4: Test cac chuc nang" -ForegroundColor White
Write-Host "  ----------------------------------------" -ForegroundColor Gray
Write-Host "  - Notifications:" -ForegroundColor White
Write-Host "    http://localhost:9999/WEBGMS/seller/notifications" -ForegroundColor Cyan
Write-Host ""
Write-Host "  - Close Shop:" -ForegroundColor White
Write-Host "    http://localhost:9999/WEBGMS/seller/close-shop" -ForegroundColor Cyan
Write-Host ""

Write-Host "================================================" -ForegroundColor Cyan
Write-Host " LUU Y QUAN TRONG!" -ForegroundColor Red
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Neu van bi loi 'access_denied', kiem tra:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Tai khoan dang dang nhap co phai la SELLER khong?" -ForegroundColor White
Write-Host "   - Kiem tra trong database:" -ForegroundColor Gray
Write-Host "     SELECT * FROM gicungco_user_roles WHERE user_id = YOUR_USER_ID;" -ForegroundColor Cyan
Write-Host "   - role_id phai = 2 (SELLER) hoac 1 (ADMIN)" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Co phai ban dang truy cap URL sai khong?" -ForegroundColor White
Write-Host "   - Dung: /seller/notifications" -ForegroundColor Green
Write-Host "   - Sai: /notifications hoac /seller-notifications" -ForegroundColor Red
Write-Host ""
Write-Host "3. Tomcat co that su duoc restart chua?" -ForegroundColor White
Write-Host "   - Phai STOP hoan toan, doi 5 giay, roi START lai" -ForegroundColor Gray
Write-Host ""

Write-Host "Doc them huong dan chi tiet trong file:" -ForegroundColor Cyan
Write-Host "SUMMARY_FIX.md" -ForegroundColor Green
Write-Host ""

pause




