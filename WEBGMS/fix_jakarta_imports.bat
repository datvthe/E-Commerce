@echo off
echo Fixing jakarta imports to javax...

REM Fix CommonHomeController
powershell -Command "(Get-Content 'src\java\controller\common\CommonHomeController.java') -replace 'jakarta\.servlet', 'javax.servlet' | Set-Content 'src\java\controller\common\CommonHomeController.java'"

REM Fix CommonLoginController  
powershell -Command "(Get-Content 'src\java\controller\common\CommonLoginController.java') -replace 'jakarta\.servlet', 'javax.servlet' | Set-Content 'src\java\controller\common\CommonLoginController.java'"

REM Fix CommonRegisterController
powershell -Command "(Get-Content 'src\java\controller\common\CommonRegisterController.java') -replace 'jakarta\.servlet', 'javax.servlet' | Set-Content 'src\java\controller\common\CommonRegisterController.java'"

REM Fix CommonLogoutController
powershell -Command "(Get-Content 'src\java\controller\common\CommonLogoutController.java') -replace 'jakarta\.servlet', 'javax.servlet' | Set-Content 'src\java\controller\common\CommonLogoutController.java'"

REM Fix ForgotPasswordController
powershell -Command "(Get-Content 'src\java\controller\common\ForgotPasswordController.java') -replace 'jakarta\.servlet', 'javax.servlet' | Set-Content 'src\java\controller\common\ForgotPasswordController.java'"

REM Fix RBACInitController
powershell -Command "(Get-Content 'src\java\controller\common\RBACInitController.java') -replace 'jakarta\.servlet', 'javax.servlet' | Set-Content 'src\java\controller\common\RBACInitController.java'"

REM Fix AdminDashboardController
powershell -Command "(Get-Content 'src\java\controller\admin\AdminDashboardController.java') -replace 'jakarta\.servlet', 'javax.servlet' | Set-Content 'src\java\controller\admin\AdminDashboardController.java'"

REM Fix ProductDetailController
powershell -Command "(Get-Content 'src\java\controller\user\ProductDetailController.java') -replace 'jakarta\.servlet', 'javax.servlet' | Set-Content 'src\java\controller\user\ProductDetailController.java'"

REM Fix ProductsController
powershell -Command "(Get-Content 'src\java\controller\user\ProductsController.java') -replace 'jakarta\.servlet', 'javax.servlet' | Set-Content 'src\java\controller\user\ProductsController.java'"

REM Fix WishlistController
powershell -Command "(Get-Content 'src\java\controller\user\WishlistController.java') -replace 'jakarta\.servlet', 'javax.servlet' | Set-Content 'src\java\controller\user\WishlistController.java'"

REM Fix ReviewController
powershell -Command "(Get-Content 'src\java\controller\user\ReviewController.java') -replace 'jakarta\.servlet', 'javax.servlet' | Set-Content 'src\java\controller\user\ReviewController.java'"

REM Fix ManagerDashboardController
powershell -Command "(Get-Content 'src\java\controller\manager\ManagerDashboardController.java') -replace 'jakarta\.servlet', 'javax.servlet' | Set-Content 'src\java\controller\manager\ManagerDashboardController.java'"

REM Fix SellerDashboardController
powershell -Command "(Get-Content 'src\java\controller\seller\SellerDashboardController.java') -replace 'jakarta\.servlet', 'javax.servlet' | Set-Content 'src\java\controller\seller\SellerDashboardController.java'"

REM Fix RoleBasedAccessFilter
powershell -Command "(Get-Content 'src\java\filter\RoleBasedAccessFilter.java') -replace 'jakarta\.servlet', 'javax.servlet' | Set-Content 'src\java\filter\RoleBasedAccessFilter.java'"

REM Fix RoleBasedAccessControl
powershell -Command "(Get-Content 'src\java\service\RoleBasedAccessControl.java') -replace 'jakarta\.servlet', 'javax.servlet' | Set-Content 'src\java\service\RoleBasedAccessControl.java'"

REM Fix Router
powershell -Command "(Get-Content 'src\java\Router.java') -replace 'jakarta\.servlet', 'javax.servlet' | Set-Content 'src\java\Router.java'"

REM Fix ClearMessageController
powershell -Command "(Get-Content 'src\java\ClearMessageController.java') -replace 'jakarta\.servlet', 'javax.servlet' | Set-Content 'src\java\ClearMessageController.java'"

echo All jakarta imports fixed to javax!
echo Please restart Tomcat server.
pause
