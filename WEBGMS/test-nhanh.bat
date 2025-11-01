@echo off
echo ================================================
echo  KIEM TRA NOTIFICATIONS DON GIAN
echo ================================================
echo.

cd /d "%~dp0"

echo [1/3] Kiem tra cac file da duoc tao...
echo.

if exist "src\java\model\notification\Notification.java" (
    echo   [OK] Notification.java
) else (
    echo   [ERROR] Thieu Notification.java
    goto :error
)

if exist "src\java\dao\NotificationDAO.java" (
    echo   [OK] NotificationDAO.java
) else (
    echo   [ERROR] Thieu NotificationDAO.java
    goto :error
)

if exist "src\java\controller\seller\SellerNotificationController.java" (
    echo   [OK] SellerNotificationController.java
) else (
    echo   [ERROR] Thieu SellerNotificationController.java
    goto :error
)

if exist "web\views\seller\seller-notifications.jsp" (
    echo   [OK] seller-notifications.jsp
) else (
    echo   [ERROR] Thieu seller-notifications.jsp
    goto :error
)

if exist "create_notifications_table.sql" (
    echo   [OK] create_notifications_table.sql
) else (
    echo   [ERROR] Thieu create_notifications_table.sql
    goto :error
)

echo.
echo [2/3] Kiem tra web.xml...
echo.

findstr /C:"SellerNotificationController" "web\WEB-INF\web.xml" >nul
if %errorlevel%==0 (
    echo   [OK] Servlet mapping da duoc them vao web.xml
) else (
    echo   [ERROR] Chua thay servlet mapping
    goto :error
)

echo.
echo [3/3] Xoa file build cu...
echo.

if exist "build\web\WEB-INF\classes\controller\seller" (
    del /Q "build\web\WEB-INF\classes\controller\seller\*.class" 2>nul
    echo   [OK] Da xoa file .class cu
) else (
    echo   [INFO] Chua co file .class
)

echo.
echo ================================================
echo  TAT CA FILE DA SAN SANG!
echo ================================================
echo.
echo  CAC BUOC TIEP THEO:
echo.
echo  1. CHAY SQL
echo     --------------------------------------------
echo     Mo MySQL va chay file:
echo       create_notifications_table.sql
echo.
echo  2. BUILD PROJECT
echo     --------------------------------------------
echo     Trong NetBeans:
echo       Right-click project WEBGMS
echo       ^> Clean and Build
echo.
echo  3. RESTART TOMCAT
echo     --------------------------------------------
echo       Stop ^> Doi 5s ^> Start
echo.
echo  4. DANG NHAP
echo     --------------------------------------------
echo       http://localhost:9999/WEBGMS/login
echo.
echo  5. TEST NOTIFICATIONS
echo     --------------------------------------------
echo       http://localhost:9999/WEBGMS/seller/notifications
echo.
echo       KET QUA MONG DOI:
echo         - Hien thi trang notifications
echo         - Co 3 thong bao mau
echo         - Danh dau duoc da doc
echo         - Xoa duoc thong bao
echo.
echo  Doc them chi tiet trong file:
echo    HUONG_DAN_DON_GIAN.txt
echo.
pause
goto :end

:error
echo.
echo ================================================
echo  CO LOI XAY RA!
echo ================================================
echo.
echo  Vui long kiem tra lai cac file.
echo.
pause
exit /b 1

:end
exit /b 0




