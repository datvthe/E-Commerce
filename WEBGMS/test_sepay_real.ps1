param (
    [int]$UserId = 15,
    [double]$Amount = 5000,
    [string]$WebhookUrl = "https://unspilled-shaniqua-conversably.ngrok-free.dev/WEBGMS/sepay/webhook"
)

$timestamp = (Get-Date).ToString("yyyyMMddHHmmssfff")
$transactionId = "REAL-" + $timestamp

Write-Host "=== SePay Real Format Test ===" -ForegroundColor Cyan
Write-Host "Target URL: $WebhookUrl"
Write-Host "Testing User ID: $UserId"
Write-Host "Testing Amount: $Amount"
Write-Host ""

$body = @{
    gateway = "TPBank"
    transactionDate = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    accountNumber = "98220112005"
    subAccount = $null
    code = $null
    content = "TOPUP-$UserId"
    transferType = "in"
    description = "BankAPINotify TOPUP-$UserId"
    transferAmount = $Amount
    referenceCode = "661V" + $timestamp
    accumulated = $Amount
    id = $transactionId
} | ConvertTo-Json

Write-Host "Sending POST request with SePay Real Format:" -ForegroundColor Yellow
Write-Host $body
Write-Host ""

try {
    $response = Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body $body -ContentType "application/json"
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Green
    Write-Host "SUCCESS!" -ForegroundColor Green
    Write-Host "============================================" -ForegroundColor Green
    Write-Host ""
    $response | ConvertTo-Json
    Write-Host ""
    Write-Host "Next Steps:" -ForegroundColor Cyan
    Write-Host "  1. Check NetBeans Output for logs"
    Write-Host "  2. Check Ngrok Inspector: http://127.0.0.1:4040"
    Write-Host "  3. Refresh wallet page: http://localhost:8080/WEBGMS/wallet"
} catch {
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Red
    Write-Host "ERROR!" -ForegroundColor Red
    Write-Host "============================================" -ForegroundColor Red
    Write-Host ""
    Write-Host $_.Exception.Message -ForegroundColor Red
    if ($_.Exception.Response) {
        $errorResponse = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorResponse)
        $responseBody = $reader.ReadToEnd()
        Write-Host ""
        Write-Host "Server Response:" -ForegroundColor Yellow
        Write-Host $responseBody -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "Troubleshooting:" -ForegroundColor Cyan
    Write-Host "  1. Check NetBeans Output for error logs"
    Write-Host "  2. Check Ngrok Inspector: http://127.0.0.1:4040"
    Write-Host "  3. Verify userId exists in users table"
}


