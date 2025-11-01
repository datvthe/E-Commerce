@echo off
REM Script clean va restore lai trang thai hoat dong

echo ================================================
echo  CLEAN VA RESTORE LAI TRANG THAI HOAT DONG
echo ================================================
echo.

echo [1/4] Xoa cac file .class cu...
if exist "build\web\WEB-INF\classes\controller\seller" (
    del /Q "build\web\WEB-INF\classes\controller\seller\*.class" 2>nul
    echo   [OK] Da xoa file .class
) else (
    echo   [INFO] Khong co file .class
)

echo.
echo [2/4] Xoa thu muc build...
if exist "build" (
    rmdir /S /Q "build" 2>nul
    echo   [OK] Da xoa thu muc build
) else (
    echo   [INFO] Khong co thu muc build
)

echo.
echo [3/4] Xoa thu muc dist...
if exist "dist" (
    rmdir /S /Q "dist" 2>nul
    echo   [OK] Da xoa thu muc dist
) else (
    echo   [INFO] Khong co thu muc dist
)

echo.
echo [4/4] Kiem tra web.xml...
findstr /C:"SellerNotificationController" "web\WEB-INF\web.xml" >nul
if %errorlevel%==0 (
    echo   [WARNING] Van con mapping SellerNotificationController trong web.xml
    echo   [INFO] Nhung khong sao vi file controller da bi xoa
) else (
    echo   [OK] web.xml sach se
)

echo.
echo ================================================
echo  HOAN TAT CLEAN UP!
echo ================================================
echo.
echo  Da xoa het:
echo    - Controllers (Notification, CloseShop, V1, V2)
echo    - DAOs (NotificationDAO, ShopClosureRequestDAO)
echo    - Models (notification, shop)
echo    - JSP pages
echo    - Servlet mappings trong web.xml
echo    - Cac file build cu
echo.
echo ================================================
echo  CAC BUOC TIEP THEO
echo ================================================
echo.
echo  1. CLEAN AND BUILD trong NetBeans
echo     Right-click project WEBGMS ^> Clean and Build
echo.
echo  2. RESTART TOMCAT
echo     Stop ^> Doi 5s ^> Start
echo.
echo  3. TEST SELLER DASHBOARD
echo     http://localhost:9999/WEBGMS/seller/dashboard
echo.
echo     Neu van bi loi, kiem tra:
echo     - Co dang nhap chua?
echo     - Co seller record chua? (chay quick_add_seller.sql)
echo.
echo  4. SAU KHI DASHBOARD HOAT DONG
echo     Co the lam lai notification/close-shop neu can
echo     Nhung lan nay se don gian va than trong hon!
echo.
pause




