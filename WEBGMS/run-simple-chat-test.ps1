# Simple Chat Communication Test Runner
# No JUnit required - runs standalone

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  CHAT COMMUNICATION TEST" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Check Java
Write-Host "Checking Java..." -ForegroundColor Yellow
java -version 2>&1 | Select-Object -First 1
Write-Host ""

# Step 1: Check if project is built
Write-Host "Step 1: Checking project build..." -ForegroundColor Yellow

if (-not (Test-Path "build\web\WEB-INF\classes\dao")) {
    Write-Host "Project not built yet. Please build it first:" -ForegroundColor Red
    Write-Host ""
    Write-Host "Option 1: Build in NetBeans" -ForegroundColor Yellow
    Write-Host "  - Open project in NetBeans" -ForegroundColor Gray
    Write-Host "  - Press F11 or click 'Clean and Build'" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Option 2: Build with Ant" -ForegroundColor Yellow
    Write-Host "  - Run: ant compile" -ForegroundColor Gray
    Write-Host ""
    exit 1
}

Write-Host "OK - Project is built" -ForegroundColor Green

# Step 2: Compile the test
Write-Host ""
Write-Host "Step 2: Compiling test file..." -ForegroundColor Yellow

$classpath = "build\web\WEB-INF\classes;web\WEB-INF\lib\*;web\WEB-INF\lib\mysql-connector-j-9.4.0\mysql-connector-j-9.4.0.jar"
$testFile = "src\java\test\SimpleChatTest.java"
$outputDir = "build\test\classes"

# Create output directory
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

javac -cp $classpath -d $outputDir $testFile 2>&1 | Out-Null

if ($LASTEXITCODE -eq 0) {
    Write-Host "OK - Test compiled" -ForegroundColor Green
} else {
    Write-Host "FAILED - Compilation error" -ForegroundColor Red
    javac -cp $classpath -d $outputDir $testFile
    exit 1
}

# Step 3: Run the test
Write-Host ""
Write-Host "Step 3: Running tests..." -ForegroundColor Yellow
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

$testClasspath = "$outputDir;$classpath"
java -cp $testClasspath test.SimpleChatTest

Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "Test execution completed!" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
