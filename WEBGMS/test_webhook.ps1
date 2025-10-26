# Test Webhook Script for Giicungco
# Usage: .\test_webhook.ps1 -UserId 5 -Amount 100000

param(
    [Parameter(Mandatory=$true)]
    [int]$UserId,
    
    [Parameter(Mandatory=$true)]
    [decimal]$Amount,
    
    [string]$NgrokUrl = "https://unspilled-shaniqua-conversably.ngrok-free.dev"
)

# Generate unique transaction ID
$TransactionId = "TEST-" + (Get-Date -Format "yyyyMMddHHmmss")

# Prepare webhook data
$body = @{
    description = "TOPUP-$UserId"
    amount = $Amount
    tran_id = $TransactionId
    bank_name = "VietComBank"
} | ConvertTo-Json

# Display request info
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Testing Webhook" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "URL: $NgrokUrl/WEBGMS/sepay/webhook" -ForegroundColor Yellow
Write-Host "User ID: $UserId" -ForegroundColor Yellow
Write-Host "Amount: $Amount VND" -ForegroundColor Yellow
Write-Host "Transaction ID: $TransactionId" -ForegroundColor Yellow
Write-Host "Description: TOPUP-$UserId" -ForegroundColor Yellow
Write-Host ""

# Send request
try {
    Write-Host "Sending request..." -ForegroundColor White
    
    $response = Invoke-RestMethod `
        -Uri "$NgrokUrl/WEBGMS/sepay/webhook" `
        -Method Post `
        -Body $body `
        -ContentType "application/json" `
        -ErrorAction Stop
    
    Write-Host "=====================================" -ForegroundColor Green
    Write-Host "SUCCESS!" -ForegroundColor Green
    Write-Host "=====================================" -ForegroundColor Green
    Write-Host "Response:" -ForegroundColor Green
    Write-Host ($response | ConvertTo-Json -Depth 10) -ForegroundColor White
    
    Write-Host ""
    Write-Host "Next Steps:" -ForegroundColor Cyan
    Write-Host "1. Check NetBeans console for logs" -ForegroundColor White
    Write-Host "2. Check Ngrok inspector: http://127.0.0.1:4040" -ForegroundColor White
    Write-Host "3. Run SQL query:" -ForegroundColor White
    Write-Host "   SELECT * FROM wallets WHERE user_id = $UserId;" -ForegroundColor Yellow
    Write-Host "   SELECT * FROM transactions WHERE transaction_id = '$TransactionId';" -ForegroundColor Yellow
    
} catch {
    Write-Host "=====================================" -ForegroundColor Red
    Write-Host "ERROR!" -ForegroundColor Red
    Write-Host "=====================================" -ForegroundColor Red
    Write-Host "Error Message: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting:" -ForegroundColor Yellow
    Write-Host "1. Is Ngrok running? Check: $NgrokUrl" -ForegroundColor White
    Write-Host "2. Is Tomcat running? Check NetBeans" -ForegroundColor White
    Write-Host "3. Check Ngrok inspector: http://127.0.0.1:4040" -ForegroundColor White
}

