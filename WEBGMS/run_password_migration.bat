@echo off
echo Starting password migration...
echo.

cd /d "%~dp0"

echo Compiling Java files...
javac -cp "web/WEB-INF/lib/*;src" -d build src/java/util/PasswordUtil.java
javac -cp "web/WEB-INF/lib/*;src;build" -d build src/java/util/PasswordMigration.java
javac -cp "web/WEB-INF/lib/*;src;build" -d build src/java/dao/DBConnection.java
javac -cp "web/WEB-INF/lib/*;src;build" -d build src/java/model/user/Users.java

echo.
echo Running password migration...
java -cp "web/WEB-INF/lib/*;build" util.PasswordMigration

echo.
echo Migration completed!
pause
