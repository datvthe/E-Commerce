@echo off
echo Fixing javax imports back to jakarta...

REM Fix CommonHomeController
powershell -Command "(Get-Content 'src\java\controller\common\CommonHomeController.java') -replace 'javax\.servlet', 'jakarta.servlet' | Set-Content 'src\java\controller\common\CommonHomeController.java'"

REM Fix CommonLoginController  
powershell -Command "(Get-Content 'src\java\controller\common\CommonLoginController.java') -replace 'javax\.servlet', 'jakarta.servlet' | Set-Content 'src\java\controller\common\CommonLoginController.java'"

REM Fix CommonRegisterController
powershell -Command "(Get-Content 'src\java\controller\common\CommonRegisterController.java') -replace 'javax\.servlet', 'jakarta.servlet' | Set-Content 'src\java\controller\common\CommonRegisterController.java'"

REM Fix CommonLogoutController
powershell -Command "(Get-Content 'src\java\controller\common\CommonLogoutController.java') -replace 'javax\.servlet', 'jakarta.servlet' | Set-Content 'src\java\controller\common\CommonLogoutController.java'"

REM Fix ForgotPasswordController
powershell -Command "(Get-Content 'src\java\controller\common\ForgotPasswordController.java') -replace 'javax\.servlet', 'jakarta.servlet' | Set-Content 'src\java\controller\common\ForgotPasswordController.java'"

REM Fix RBACInitController
powershell -Command "(Get-Content 'src\java\controller\common\RBACInitController.java') -replace 'javax\.servlet', 'jakarta.servlet' | Set-Content 'src\java\controller\common\RBACInitController.java'"

REM Fix AdminDashboardController
powershell -Command "(Get-Content 'src\java\controller\admin\AdminDashboardController.java') -replace 'javax\.servlet', 'jakarta.servlet' | Set-Content 'src\java\controller\admin\AdminDashboardController.java'"

REM Fix ProductDetailController
powershell -Command "(Get-Content 'src\java\controller\user\ProductDetailController.java') -replace 'javax\.servlet', 'jakarta.servlet' | Set-Content 'src\java\controller\user\ProductDetailController.java'"

REM Fix ProductsController
powershell -Command "(Get-Content 'src\java\controller\user\ProductsController.java') -replace 'javax\.servlet', 'jakarta.servlet' | Set-Content 'src\java\controller\user\ProductsController.java'"

REM Fix WishlistController
powershell -Command "(Get-Content 'src\java\controller\user\WishlistController.java') -replace 'javax\.servlet', 'jakarta.servlet' | Set-Content 'src\java\controller\user\WishlistController.java'"

REM Fix ReviewController
powershell -Command "(Get-Content 'src\java\controller\user\ReviewController.java') -replace 'javax\.servlet', 'jakarta.servlet' | Set-Content 'src\java\controller\user\ReviewController.java'"

REM Fix ManagerDashboardController
powershell -Command "(Get-Content 'src\java\controller\manager\ManagerDashboardController.java') -replace 'javax\.servlet', 'jakarta.servlet' | Set-Content 'src\java\controller\manager\ManagerDashboardController.java'"

REM Fix SellerDashboardController
powershell -Command "(Get-Content 'src\java\controller\seller\SellerDashboardController.java') -replace 'javax\.servlet', 'jakarta.servlet' | Set-Content 'src\java\controller\seller\SellerDashboardController.java'"

REM Fix RoleBasedAccessFilter
powershell -Command "(Get-Content 'src\java\filter\RoleBasedAccessFilter.java') -replace 'javax\.servlet', 'jakarta.servlet' | Set-Content 'src\java\filter\RoleBasedAccessFilter.java'"

REM Fix RoleBasedAccessControl
powershell -Command "(Get-Content 'src\java\service\RoleBasedAccessControl.java') -replace 'javax\.servlet', 'jakarta.servlet' | Set-Content 'src\java\service\RoleBasedAccessControl.java'"

REM Fix Router
powershell -Command "(Get-Content 'src\java\Router.java') -replace 'javax\.servlet', 'jakarta.servlet' | Set-Content 'src\java\Router.java'"

REM Fix ClearMessageController
powershell -Command "(Get-Content 'src\java\ClearMessageController.java') -replace 'javax\.servlet', 'jakarta.servlet' | Set-Content 'src\java\ClearMessageController.java'"

REM Fix ProfileController
powershell -Command "(Get-Content 'src\java\controller\common\ProfileController.java') -replace 'javax\.servlet', 'jakarta.servlet' | Set-Content 'src\java\controller\common\ProfileController.java'"

REM Fix UpdateProfileController
powershell -Command "(Get-Content 'src\java\controller\common\UpdateProfileController.java') -replace 'javax\.servlet', 'jakarta.servlet' | Set-Content 'src\java\controller\common\UpdateProfileController.java'"

REM Fix ChangePasswordController
powershell -Command "(Get-Content 'src\java\controller\common\ChangePasswordController.java') -replace 'javax\.servlet', 'jakarta.servlet' | Set-Content 'src\java\controller\common\ChangePasswordController.java'"

echo All javax imports fixed back to jakarta!
echo Please restart Tomcat server.
pause
