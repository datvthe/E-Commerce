@echo off
cls
echo.
echo ╔════════════════════════════════════════════════════════╗
echo ║     CHECKLIST TEST NOTIFICATIONS                       ║
echo ╚════════════════════════════════════════════════════════╝
echo.
echo.
echo  [ ] 1. CHAY SQL
echo      ─────────────────────────────────────────────────
echo      File: create_notifications_table.sql
echo      Copy va paste vao MySQL
echo      Check: SELECT * FROM gicungco_notifications;
echo.
echo.
echo  [ ] 2. CLEAN AND BUILD
echo      ─────────────────────────────────────────────────
echo      NetBeans: Right-click WEBGMS ^> Clean and Build
echo      Doi thay: "BUILD SUCCESSFUL"
echo.
echo.
echo  [ ] 3. RESTART TOMCAT
echo      ─────────────────────────────────────────────────
echo      Stop ^> Doi 5s ^> Start
echo      Doi thay: "Server startup"
echo.
echo.
echo  [ ] 4. DANG NHAP
echo      ─────────────────────────────────────────────────
echo      URL: http://localhost:9999/WEBGMS/login
echo.
echo.
echo  [ ] 5. TEST DASHBOARD (QUAN TRONG!)
echo      ─────────────────────────────────────────────────
echo      URL: http://localhost:9999/WEBGMS/seller/dashboard
echo      Ket qua: Dashboard phai hien thi binh thuong
echo.
echo.
echo  [ ] 6. TEST NOTIFICATIONS
echo      ─────────────────────────────────────────────────
echo      URL: http://localhost:9999/WEBGMS/seller/notifications
echo.
echo      Ket qua mong doi:
echo        - Hien thi trang notifications
echo        - Co 3 thong bao mau
echo        - Danh dau duoc da doc
echo        - Xoa duoc thong bao
echo.
echo.
echo ════════════════════════════════════════════════════════
echo.
echo  Doc huong dan chi tiet trong file:
echo    TEST_NOTIFICATIONS_STEP_BY_STEP.txt
echo.
echo ════════════════════════════════════════════════════════
echo.
pause




