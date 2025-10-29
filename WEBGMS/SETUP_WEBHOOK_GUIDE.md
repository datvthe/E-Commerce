# 🔗 Hướng Dẫn Kết Nối Webhook - Giicungco

## 📋 Tổng Quan

Webhook cho phép SePay (hoặc payment gateway) tự động thông báo đến server của bạn khi có giao dịch mới. Hướng dẫn này sẽ giúp bạn setup webhook cho cả môi trường development và production.

---

## 🛠️ Phương Án 1: Development (Localhost) - Sử Dụng Ngrok

### Bước 1: Tải Ngrok

1. Truy cập: https://ngrok.com/
2. Đăng ký tài khoản miễn phí
3. Tải Ngrok về: https://ngrok.com/download
4. Giải nén file vào thư mục bất kỳ (ví dụ: `C:\ngrok\`)

### Bước 2: Setup Ngrok

1. **Get Auth Token:**
   - Đăng nhập Ngrok
   - Copy auth token tại: https://dashboard.ngrok.com/get-started/your-authtoken

2. **Config Auth Token:**
```bash
cd C:\ngrok
ngrok config add-authtoken YOUR_AUTH_TOKEN_HERE
```

### Bước 3: Chạy Project Java

1. Mở NetBeans
2. Run project WEBGMS
3. Đảm bảo server chạy tại: `http://localhost:9999/WEBGMS`

### Bước 4: Start Ngrok Tunnel

Mở **PowerShell** hoặc **CMD** mới:

```bash
cd C:\ngrok
ngrok http 9999
```

**Output mẫu:**
```
ngrok

Session Status                online
Account                       your-email@gmail.com
Version                       3.x.x
Region                        Asia Pacific (ap)
Latency                       -
Web Interface                 http://127.0.0.1:4040
Forwarding                    https://abc123.ngrok-free.app -> http://localhost:9999

Connections                   ttl     opn     rt1     rt5     p50     p90
                              0       0       0.00    0.00    0.00    0.00
```

✅ **Copy URL này**: `https://abc123.ngrok-free.app`

### Bước 5: Config Webhook trong SePay

1. Đăng nhập SePay Dashboard
2. Vào **Settings** → **Webhook**
3. Nhập URL:
```
https://abc123.ngrok-free.app/WEBGMS/sepay/webhook
```
4. Method: **POST**
5. Save

### Bước 6: Test Webhook

**Cách 1: Test từ SePay Dashboard**
- Click "Test Webhook" trong SePay
- Xem response

**Cách 2: Test bằng Postman**

```http
POST https://abc123.ngrok-free.app/WEBGMS/sepay/webhook
Content-Type: application/json

{
  "description": "TOPUP-5",
  "amount": 100000,
  "tran_id": "TEST123456",
  "bank_name": "VietComBank"
}
```

**Cách 3: Test bằng curl**

```bash
curl -X POST https://abc123.ngrok-free.app/WEBGMS/sepay/webhook \
  -H "Content-Type: application/json" \
  -d '{"description":"TOPUP-5","amount":100000,"tran_id":"TEST123456","bank_name":"VietComBank"}'
```

### Bước 7: Kiểm Tra Logs

**Trong NetBeans Output:**
```
📩 Webhook nhận được từ SePay: {"description":"TOPUP-5","amount":100000,...}
✅ Nạp tiền thành công: +100000đ cho user_id=5
```

**Trong Ngrok Web Interface:**
- Truy cập: http://127.0.0.1:4040
- Xem tất cả requests đến webhook
- Inspect request/response

---

## 🌐 Phương Án 2: Production (Server Thật)

### Bước 1: Deploy Lên Server

**Option A: VPS (Recommended)**
- AWS EC2
- DigitalOcean Droplet
- Google Cloud VM
- Azure VM

**Option B: Shared Hosting**
- Hostinger Java Hosting
- A2 Hosting

### Bước 2: Setup Domain & SSL

1. **Mua Domain:**
   - Namecheap, GoDaddy, etc.
   - Ví dụ: `giicungco.com`

2. **Setup SSL Certificate:**
   - Let's Encrypt (miễn phí)
   - Cloudflare SSL

3. **Point Domain to Server:**
   ```
   A Record: @ → Server IP
   A Record: www → Server IP
   ```

### Bước 3: Config Tomcat

1. **Upload file WAR:**
```bash
scp WEBGMS.war user@your-server:/opt/tomcat/webapps/
```

2. **Start Tomcat:**
```bash
sudo systemctl start tomcat
```

3. **Verify:**
```bash
curl http://your-domain.com:8080/WEBGMS/sepay/webhook
```

### Bước 4: Setup Nginx Reverse Proxy

**File: `/etc/nginx/sites-available/giicungco`**

```nginx
server {
    listen 80;
    listen 443 ssl;
    server_name giicungco.com www.giicungco.com;

    ssl_certificate /etc/letsencrypt/live/giicungco.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/giicungco.com/privkey.pem;

    location /WEBGMS/ {
        proxy_pass http://localhost:8080/WEBGMS/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

**Enable site:**
```bash
sudo ln -s /etc/nginx/sites-available/giicungco /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### Bước 5: Config Webhook URL trong SePay

```
https://giicungco.com/WEBGMS/sepay/webhook
```

✅ **HTTPS bắt buộc** cho production!

---

## 🧪 Testing Webhook

### Test Script 1: Simple Test (Python)

**File: `test_webhook.py`**

```python
import requests
import json

# Replace with your webhook URL
WEBHOOK_URL = "https://abc123.ngrok-free.app/WEBGMS/sepay/webhook"

# Test data
data = {
    "description": "TOPUP-5",
    "amount": 100000,
    "tran_id": "TEST" + str(int(time.time())),
    "bank_name": "VietComBank"
}

# Send POST request
response = requests.post(
    WEBHOOK_URL,
    headers={"Content-Type": "application/json"},
    data=json.dumps(data)
)

print("Status Code:", response.status_code)
print("Response:", response.json())
```

**Run:**
```bash
python test_webhook.py
```

### Test Script 2: PowerShell

**File: `test_webhook.ps1`**

```powershell
$url = "https://abc123.ngrok-free.app/WEBGMS/sepay/webhook"
$body = @{
    description = "TOPUP-5"
    amount = 100000
    tran_id = "TEST123456"
    bank_name = "VietComBank"
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType "application/json"
Write-Host "Response: $response"
```

**Run:**
```powershell
.\test_webhook.ps1
```

### Test Script 3: Node.js

**File: `test_webhook.js`**

```javascript
const axios = require('axios');

const WEBHOOK_URL = 'https://abc123.ngrok-free.app/WEBGMS/sepay/webhook';

const data = {
  description: 'TOPUP-5',
  amount: 100000,
  tran_id: 'TEST' + Date.now(),
  bank_name: 'VietComBank'
};

axios.post(WEBHOOK_URL, data)
  .then(response => {
    console.log('Status:', response.status);
    console.log('Response:', response.data);
  })
  .catch(error => {
    console.error('Error:', error.message);
  });
```

**Run:**
```bash
node test_webhook.js
```

---

## 🔍 Debugging Webhook

### 1. Check Logs

**NetBeans Output Console:**
```java
📩 Webhook nhận được từ SePay: {...}
⚠️ Không tìm thấy userId trong mô tả: Invalid description
✅ Nạp tiền thành công: +100000đ cho user_id=5
```

### 2. Ngrok Web Inspector

- Truy cập: http://127.0.0.1:4040
- Xem mọi request real-time
- Inspect Headers, Body, Response

### 3. Database Check

```sql
-- Check wallet balance
SELECT * FROM wallets WHERE user_id = 5;

-- Check transactions
SELECT * FROM transactions 
WHERE user_id = 5 
ORDER BY created_at DESC 
LIMIT 5;
```

### 4. Common Issues

**Issue 1: Connection Refused**
```
Error: Connection refused to https://abc123.ngrok-free.app
```
**Solution:** Đảm bảo Ngrok đang chạy và Tomcat đang chạy

**Issue 2: 404 Not Found**
```
Status: 404
```
**Solution:** Check URL đúng format:
```
https://YOUR_DOMAIN/WEBGMS/sepay/webhook
```

**Issue 3: Invalid JSON**
```
Error parsing JSON
```
**Solution:** Check Content-Type header = `application/json`

**Issue 4: User Not Found**
```
⚠️ Không tìm thấy userId trong mô tả
```
**Solution:** 
- Description phải có format: `TOPUP-5` (với số là user_id)
- Check user_id tồn tại trong database

---

## 📱 Setup SePay Account

### Bước 1: Đăng Ký SePay

1. Truy cập: https://sepay.vn/
2. Đăng ký tài khoản
3. Xác thực email/phone

### Bước 2: Liên Kết Ngân Hàng

1. Đăng nhập SePay Dashboard
2. Vào **Liên kết tài khoản**
3. Chọn ngân hàng (VietComBank, ACB, etc.)
4. Nhập thông tin tài khoản
5. Xác thực qua OTP

### Bước 3: Lấy API Key (Nếu Cần)

1. Vào **Settings** → **API Keys**
2. Generate new API key
3. Copy và lưu lại (chỉ hiển thị 1 lần)

### Bước 4: Config Webhook

1. Vào **Settings** → **Webhooks**
2. Nhập Webhook URL:
   - Dev: `https://abc123.ngrok-free.app/WEBGMS/sepay/webhook`
   - Prod: `https://giicungco.com/WEBGMS/sepay/webhook`
3. Events: Chọn "Incoming Transfer"
4. Method: POST
5. Content-Type: application/json
6. Save

### Bước 5: Test Webhook

1. Click "Test Webhook" trong dashboard
2. Hoặc chuyển khoản thử với số tiền nhỏ (1,000 VNĐ)
3. Description: `TOPUP-5` (với user_id = 5)

---

## 🔐 Security Best Practices

### 1. Verify Webhook Signature (Advanced)

**Update `SepayWebhookController.java`:**

```java
private boolean verifySignature(String payload, String signature) {
    String secret = "YOUR_WEBHOOK_SECRET";
    String computed = HmacUtils.hmacSha256Hex(secret, payload);
    return computed.equals(signature);
}

@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) {
    String signature = request.getHeader("X-Sepay-Signature");
    String payload = // read request body
    
    if (!verifySignature(payload, signature)) {
        response.setStatus(401);
        return;
    }
    
    // Process webhook...
}
```

### 2. IP Whitelist

**In `web.xml`:**

```xml
<filter>
    <filter-name>WebhookIPFilter</filter-name>
    <filter-class>filter.WebhookIPFilter</filter-class>
</filter>
<filter-mapping>
    <filter-name>WebhookIPFilter</filter-name>
    <url-pattern>/sepay/webhook</url-pattern>
</filter-mapping>
```

**Create `WebhookIPFilter.java`:**

```java
package filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

public class WebhookIPFilter implements Filter {
    private static final List<String> ALLOWED_IPS = Arrays.asList(
        "103.163.215.0/24", // SePay IPs
        "127.0.0.1" // Localhost for testing
    );

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        String ip = req.getRemoteAddr();
        
        if (isAllowed(ip)) {
            chain.doFilter(request, response);
        } else {
            ((HttpServletResponse) response).setStatus(403);
        }
    }
    
    private boolean isAllowed(String ip) {
        return ALLOWED_IPS.stream().anyMatch(allowed -> ip.startsWith(allowed.split("/")[0]));
    }
}
```

### 3. Rate Limiting

```java
// Limit to 100 requests per minute per IP
private Map<String, Integer> requestCounts = new ConcurrentHashMap<>();

if (requestCounts.getOrDefault(ip, 0) > 100) {
    response.setStatus(429); // Too Many Requests
    return;
}
```

---

## 📊 Monitoring & Alerts

### 1. Log All Webhooks

**Create log file:**

```java
private static final Logger logger = Logger.getLogger(SepayWebhookController.class.getName());

logger.info("Webhook received: " + json);
logger.info("User ID: " + userId + ", Amount: " + amount);
```

### 2. Email Alerts

```java
if (amount > 10000000) { // 10 triệu
    sendEmailAlert("Large deposit: " + amount + " for user " + userId);
}
```

### 3. Database Monitoring

```sql
-- Failed webhooks
SELECT * FROM webhook_logs 
WHERE status = 'FAILED' 
AND created_at > NOW() - INTERVAL 1 HOUR;

-- Large transactions
SELECT * FROM transactions 
WHERE amount > 10000000 
ORDER BY created_at DESC;
```

---

## 🎯 Quick Start Checklist

### Development:
- [ ] Download Ngrok
- [ ] Setup Ngrok auth token
- [ ] Run WEBGMS project (localhost:9999)
- [ ] Start Ngrok: `ngrok http 9999`
- [ ] Copy Ngrok URL
- [ ] Config webhook in SePay: `https://xxx.ngrok-free.app/WEBGMS/sepay/webhook`
- [ ] Test with Postman/curl
- [ ] Check logs in NetBeans
- [ ] Verify database updated

### Production:
- [ ] Deploy to VPS/Cloud
- [ ] Setup domain
- [ ] Install SSL certificate
- [ ] Config Nginx reverse proxy
- [ ] Update webhook URL in SePay
- [ ] Test with real transfer
- [ ] Monitor logs
- [ ] Setup alerts

---

## 🆘 Troubleshooting

### Problem: Ngrok session expired
**Solution:** Free plan có giới hạn 2 giờ. Restart ngrok hoặc upgrade plan.

### Problem: Webhook returns 500
**Solution:** Check NetBeans logs, database connection, và Java exceptions.

### Problem: Balance not updated
**Solution:** 
1. Check description format: `TOPUP-5`
2. Check user_id exists
3. Check wallet record exists
4. Check database transaction logs

### Problem: Cannot access Ngrok URL
**Solution:** 
1. Check firewall
2. Ensure Tomcat is running
3. Try different port: `ngrok http 8080`

---

## 📚 Resources

- **Ngrok Docs:** https://ngrok.com/docs
- **SePay API Docs:** https://sepay.vn/docs
- **Postman:** https://www.postman.com/downloads/
- **Let's Encrypt:** https://letsencrypt.org/

---

## 💡 Pro Tips

1. **Always use HTTPS** in production
2. **Log everything** for debugging
3. **Test webhook thoroughly** before going live
4. **Monitor transactions** regularly
5. **Setup backup webhook URL** for redundancy
6. **Use webhook signature** verification
7. **Keep Ngrok running** during development

---

**Created by**: AI Assistant  
**Date**: October 26, 2025  
**Version**: 1.0.0  
**Status**: ✅ Ready to Use


