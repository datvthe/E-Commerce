@echo off
echo ================================================
echo  SUA LOI SELLER DASHBOARD
echo ================================================
echo.

echo [1/3] Xoa file build cu...
if exist "build" (
    rmdir /S /Q "build" 2>nul
    echo   [OK] Da xoa build
) else (
    echo   [INFO] Khong co build
)

echo.
echo [2/3] Kiem tra NotificationDAO...
findstr /C:"DBConnection.getConnection" "src\java\dao\NotificationDAO.java" >nul
if %errorlevel%==0 (
    echo   [OK] NotificationDAO da duoc sua dung
) else (
    echo   [ERROR] NotificationDAO van sai!
    goto :error
)

echo.
echo [3/3] HUONG DAN TIEP THEO
echo ================================================
echo.
echo  Da sua xong NotificationDAO!
echo  Loi la: Dung sai DBContext thay vi DBConnection
echo.
echo  BAY GIO HAY LAM:
echo.
echo  1. CLEAN AND BUILD
echo     NetBeans: Right-click WEBGMS ^> Clean and Build
echo     Doi den khi thay "BUILD SUCCESSFUL"
echo.
echo  2. RESTART TOMCAT
echo     Stop ^> Doi 5s ^> Start
echo.
echo  3. TEST SELLER DASHBOARD
echo     http://localhost:9999/WEBGMS/seller/dashboard
echo.
echo     KET QUA MONG DOI:
echo       - Dashboard hien thi binh thuong
echo       - Khong con loi
echo.
echo  4. NEU DASHBOARD OK, TEST NOTIFICATIONS
echo     http://localhost:9999/WEBGMS/seller/notifications
echo.
echo     (Nho chay SQL truoc: create_notifications_table.sql)
echo.
pause
goto :end

:error
echo.
echo [ERROR] Van con loi!
echo Vui long lien he de sua
pause
exit /b 1

:end
exit /b 0




