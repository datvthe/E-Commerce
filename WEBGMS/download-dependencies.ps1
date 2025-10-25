# PowerShell Script to Download Chat System Dependencies
# Run this script to automatically download required JAR files

$libDir = "C:\Users\Admin\Desktop\New folder\WEBGMS\web\WEB-INF\lib"

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Chat System Dependency Downloader" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Create lib directory if it doesn't exist
if (-not (Test-Path $libDir)) {
    New-Item -ItemType Directory -Path $libDir -Force | Out-Null
    Write-Host "[✓] Created lib directory" -ForegroundColor Green
}

# Function to download file
function Download-Dependency {
    param (
        [string]$Url,
        [string]$FileName,
        [string]$Description
    )
    
    $outputPath = Join-Path $libDir $FileName
    
    Write-Host "[→] Downloading $Description..." -ForegroundColor Yellow
    
    try {
        Invoke-WebRequest -Uri $Url -OutFile $outputPath -UseBasicParsing
        Write-Host "[✓] Downloaded $FileName" -ForegroundColor Green
    } catch {
        Write-Host "[✗] Failed to download $FileName" -ForegroundColor Red
        Write-Host "    Error: $_" -ForegroundColor Red
        Write-Host "    Please download manually from: $Url" -ForegroundColor Yellow
    }
}

Write-Host "Downloading dependencies..." -ForegroundColor Cyan
Write-Host ""

# Download Jakarta WebSocket API
Download-Dependency `
    -Url "https://repo1.maven.org/maven2/jakarta/websocket/jakarta.websocket-api/2.0.0/jakarta.websocket-api-2.0.0.jar" `
    -FileName "jakarta.websocket-api-2.0.0.jar" `
    -Description "Jakarta WebSocket API 2.0.0"

# Download GSON
Download-Dependency `
    -Url "https://repo1.maven.org/maven2/com/google/code/gson/gson/2.10.1/gson-2.10.1.jar" `
    -FileName "gson-2.10.1.jar" `
    -Description "Google GSON 2.10.1"

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Download Complete!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Check web/WEB-INF/lib directory for the JAR files" -ForegroundColor White
Write-Host "2. If using NetBeans, right-click project -> Properties -> Libraries" -ForegroundColor White
Write-Host "3. Add the JAR files to your project classpath" -ForegroundColor White
Write-Host "4. Clean and rebuild your project" -ForegroundColor White
Write-Host ""
Write-Host "JAR files location: $libDir" -ForegroundColor Cyan
