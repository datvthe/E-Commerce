# 🐛 Debug File Upload - Step by Step

## Issue: Files not uploading/appearing in chat

### 🔍 Step 1: Test Upload Endpoint

1. **Open**: `test_upload.html` in your browser
   ```
   http://localhost:8080/WEBGMS/test_upload.html
   ```

2. **Select a file** (image or PDF)

3. **Click "Upload File"**

4. **Check results**:
   - ✅ Success → Upload endpoint works
   - ❌ Error → Check what error appears

### 🔍 Step 2: Check Browser Console

1. **Open chat widget**
2. **Press F12** (open Developer Tools)
3. **Go to Console tab**
4. **Select a file in chat**
5. **Look for these logs**:
   ```
   [Upload] Starting upload for file: test.jpg
   [Upload] FormData created with param: image
   [Upload] Upload URL: /WEBGMS/chat/upload-file
   [Upload] Response status: 200
   [Upload] Success response: {...}
   ```

### 🔍 Step 3: Check Server Logs

Look for these messages in your server console:

**When upload starts:**
```
[ChatUpload] ========== FILE UPLOAD REQUEST ==========
[ChatUpload] Request URI: /WEBGMS/chat/upload-file
[ChatUpload] Content Type: multipart/form-data
[ChatUpload] User session: 1
[ChatUpload] Starting file upload process...
[ChatUpload] Checking 'image' part: found
[ChatUpload] File part found! Size: 123456 bytes
```

**When upload succeeds:**
```
[ChatUpload] Saving file to: C:\path\to\uploads\chat-images\abc123.jpg
[ChatUpload] File saved successfully!
[ChatUpload] File URL: /uploads/chat-images/abc123.jpg
[ChatUpload] Success response: {"success":true,...}
[ChatUpload] ========== UPLOAD COMPLETE ==========
```

### 🔍 Step 4: Check Network Tab

1. **Open Developer Tools (F12)**
2. **Go to Network tab**
3. **Select a file and send**
4. **Find the upload request**: `/chat/upload-file`
5. **Check**:
   - Status code: Should be **200**
   - Response: Should contain `{"success":true,...}`

### 🔍 Step 5: Check Database

After successful upload, check if message was saved:

```sql
SELECT 
    message_id,
    message_type,
    message_content,
    attachment_url,
    created_at
FROM chat_messages 
ORDER BY message_id DESC
LIMIT 10;
```

Expected result:
```
message_type: 'image' or 'file'
attachment_url: '/uploads/chat-images/abc123.jpg'
```

### 🔍 Step 6: Check File System

Verify files are being saved:

**Windows:**
```
C:\path\to\WEBGMS\web\uploads\chat-images\
C:\path\to\WEBGMS\web\uploads\chat-files\
```

**Linux/Mac:**
```
/path/to/WEBGMS/web/uploads/chat-images/
/path/to/WEBGMS/web/uploads/chat-files/
```

## 🐛 Common Issues & Solutions

### Issue 1: "401 Unauthorized"
**Cause:** User not logged in
**Solution:** Make sure you're logged in before uploading

### Issue 2: "404 Not Found"
**Cause:** Servlet not registered
**Solution:** 
1. Check servlet annotation: `@WebServlet("/chat/upload-file")`
2. Restart server
3. Check web.xml doesn't override annotations

### Issue 3: "500 Internal Server Error"
**Cause:** Exception during upload
**Solution:** Check server logs for stack trace

### Issue 4: Upload succeeds but file doesn't appear in chat
**Cause:** WebSocket not sending attachment_url
**Solution:** Check WebSocket logs:
```
[WebSocket] Message type: image
[WebSocket] Attachment URL: /uploads/chat-images/...
```

### Issue 5: Files upload but images don't display
**Cause:** Incorrect file path
**Solution:** 
1. Check file URL in database
2. Verify web server can serve files from uploads/ directory
3. Add to web.xml if needed:
```xml
<servlet-mapping>
    <servlet-name>default</servlet-name>
    <url-pattern>/uploads/*</url-pattern>
</servlet-mapping>
```

## 📊 Quick Checklist

- [ ] User is logged in
- [ ] Upload endpoint responds (test with test_upload.html)
- [ ] Browser console shows upload logs
- [ ] Server logs show upload process
- [ ] Network tab shows 200 response
- [ ] Database contains attachment_url
- [ ] File exists in uploads/ directory
- [ ] WebSocket sends attachment in message
- [ ] Message appears in chat

## 🧪 Manual Test

Run this in browser console while on chat page:

```javascript
// Test upload endpoint directly
const testUpload = async () => {
    const input = document.createElement('input');
    input.type = 'file';
    input.accept = 'image/*';
    
    input.onchange = async (e) => {
        const file = e.target.files[0];
        const formData = new FormData();
        formData.append('image', file);
        
        try {
            const response = await fetch('/WEBGMS/chat/upload-file', {
                method: 'POST',
                body: formData
            });
            
            const data = await response.json();
            console.log('Upload result:', data);
        } catch (error) {
            console.error('Upload error:', error);
        }
    };
    
    input.click();
};

testUpload();
```

## 📞 Next Steps

1. **Run test_upload.html** - Does it work?
   - ✅ Yes → Problem is in chat widget integration
   - ❌ No → Problem is in upload endpoint

2. **Check server logs** - Do you see upload logs?
   - ✅ Yes → Check what error appears
   - ❌ No → Servlet not being called

3. **Check browser console** - Any errors?
   - Look for fetch errors, CORS issues, etc.

4. **Share the error** with me so I can help!

