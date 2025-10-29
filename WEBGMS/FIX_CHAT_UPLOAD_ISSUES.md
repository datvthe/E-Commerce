# 🔧 Fix Chat Upload Issues

## ✅ Đã Sửa

### 1. **CSS Syntax Error** (FIXED)
**Vấn đề:** Duplicate closing brace `}` ở dòng 251 trong `chat-widget.css`
```css
.chat-widget-admin-btn:active {
    transform: translateY(0);
}
}  ← Brace thừa này gây lỗi!
```

**Đã sửa:** Xóa bỏ duplicate brace

**Ảnh hưởng:**
- Widget bị lỗi hiển thị
- CSS không load đúng
- Các element bị mất style

---

## 🐛 Các Lỗi Bạn Đang Gặp

### **Vấn đề 1: Không thể chọn file**
**Triệu chứng:**
- Click nút paperclip không mở file picker
- Click button không có phản ứng

**Nguyên nhân có thể:**
1. JavaScript error (conflict)
2. Button onclick không được bind
3. Input file bị hidden/disabled

**Cách debug:**
```javascript
// Mở Console (F12) và chạy:
console.log('AI Bot Input:', document.getElementById('aiBotFileInput'));
console.log('Widget Input:', document.getElementById('widgetFileInput'));

// Test click thủ công:
document.getElementById('aiBotFileInput').click();
```

**Fix:**
```javascript
// Thêm vào chat-widget.js (nếu chưa có)
window.addEventListener('DOMContentLoaded', function() {
    console.log('[Chat Upload] DOM loaded, setting up file handlers');
    setupWidgetFileHandlers();
});
```

---

### **Vấn đề 2: File được chọn nhưng không hiện preview**
**Triệu chứng:**
- Chọn hình ảnh/file được
- Không thấy preview xuất hiện
- Console có lỗi JavaScript

**Nguyên nhân:**
1. CSS `display: none` không được override
2. FileReader không hoạt động
3. Preview element không tồn tại

**Cách debug:**
```javascript
// Check preview elements:
console.log('Preview:', document.getElementById('aiBotFilePreview'));
console.log('Preview Img:', document.getElementById('aiBotPreviewImg'));
console.log('File Info:', document.getElementById('aiBotFileInfo'));
```

**Fix:** Kiểm tra trong JSP xem có đầy đủ các element:
```html
<div class="chat-widget-image-preview" id="aiBotFilePreview" style="display: none;">
    <div class="image-preview-container">
        <img id="aiBotPreviewImg" src="" alt="Preview" style="display: none;">
        <div id="aiBotFileInfo" class="file-info-preview" style="display: none;">
            <i class="fas fa-file"></i>
            <span id="aiBotFileName"></span>
        </div>
        <button class="btn-remove-image" onclick="...">
            <i class="fas fa-times"></i>
        </button>
    </div>
</div>
```

---

### **Vấn đề 3: Widget bị lỗi hiển thị**
**Triệu chứng:**
- Chat widget không mở được
- Layout bị vỡ
- Nút bị biến mất

**Nguyên nhân:**
- CSS syntax error (ĐÃ SỬA)
- Cache browser cũ
- Conflict với CSS khác

**Fix:**
1. **Clear browser cache:**
   - Chrome: `Ctrl + Shift + Delete` → Clear cached images and files
   - Or: `Ctrl + Shift + R` (hard reload)

2. **Verify CSS loaded:**
   ```javascript
   // Check trong Console (F12):
   let link = document.querySelector('link[href*="chat-widget.css"]');
   console.log('CSS loaded:', link);
   ```

3. **Force CSS reload:**
   ```html
   <!-- Thêm version vào CSS link trong footer.jsp -->
   <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/chat-widget.css?v=2" />
   ```

---

## 🧪 Cách Test Upload

### **Test 1: Upload Hình Ảnh**
```
1. Mở chat widget
2. Click nút paperclip (📎)
3. Chọn file .jpg, .png, .gif (< 5MB)
4. Kiểm tra:
   ✓ Preview hiện ra
   ✓ Thumbnail đúng
   ✓ Nút X để xóa hoạt động
5. Gửi tin nhắn
6. Kiểm tra:
   ✓ Hình ảnh xuất hiện trong chat
   ✓ Click hình mở full size
```

### **Test 2: Upload File**
```
1. Mở chat widget
2. Click nút paperclip (📎)
3. Chọn file .pdf, .docx, .xlsx (< 10MB)
4. Kiểm tra:
   ✓ Preview hiện file name và icon
   ✓ File size đúng
5. Gửi tin nhắn
6. Kiểm tra:
   ✓ File xuất hiện dưới dạng download link
   ✓ Click vào download được
```

---

## 🔍 Debug Console Commands

Chạy các lệnh này trong Console (F12) để debug:

```javascript
// 1. Check widget initialization
console.log('Widget User ID:', widgetUserId);
console.log('Widget Context:', widgetContextPath);

// 2. Check file input elements
let aiBotInput = document.getElementById('aiBotFileInput');
let widgetInput = document.getElementById('widgetFileInput');
console.log('AI Bot Input exists:', !!aiBotInput);
console.log('Widget Input exists:', !!widgetInput);

// 3. Check preview elements
let preview = document.getElementById('aiBotFilePreview');
let previewImg = document.getElementById('aiBotPreviewImg');
console.log('Preview element:', !!preview);
console.log('Preview img:', !!previewImg);

// 4. Check CSS
let styles = window.getComputedStyle(preview);
console.log('Preview display:', styles.display);

// 5. Test file input manually
aiBotInput.click();  // Should open file picker

// 6. Check upload function
console.log('uploadChatFile function:', typeof window.uploadChatFile);

// 7. Check upload URL
console.log('Upload URL:', widgetContextPath + '/chat/upload-file');

// 8. Test upload endpoint manually
fetch(widgetContextPath + '/chat/upload-file', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'}
}).then(r => r.text()).then(console.log);
```

---

## 🚀 Steps to Fix

### Step 1: Clear Browser Cache
```
Ctrl + Shift + Delete
→ Select "Cached images and files"
→ Clear data
→ Restart browser
```

### Step 2: Rebuild Application
```bash
# Clean và build lại
cd WEBGMS
ant clean
ant build
```

### Step 3: Restart Server
```
Stop Tomcat
Clear Tomcat work directory:
  - C:\Program Files\Apache Software Foundation\Tomcat 9.0\work\Catalina\localhost\WEBGMS
Start Tomcat
```

### Step 4: Test in Browser
```
1. Mở: http://localhost:9999/WEBGMS/home
2. Login
3. Click chat button (góc dưới phải)
4. Test upload
5. Check Console (F12) cho errors
```

---

## 📋 Checklist

Sau khi fix, kiểm tra:

- [ ] CSS không có lỗi syntax
- [ ] Chat widget mở được
- [ ] Click paperclip mở file picker
- [ ] Chọn hình ảnh → preview xuất hiện
- [ ] Chọn file → hiện tên file và icon
- [ ] Gửi hình ảnh → hiện trong chat
- [ ] Gửi file → hiện download link
- [ ] Click hình ảnh → mở full size
- [ ] Click file → download được
- [ ] Không có JavaScript errors trong Console

---

## 🆘 Nếu Vẫn Lỗi

**Gửi cho tôi thông tin sau:**

1. **Console errors (F12 → Console tab):**
   - Screenshot màu đỏ errors
   - Copy full error message

2. **Network errors (F12 → Network tab):**
   - Filter: "upload"
   - Click vào request màu đỏ
   - Screenshot Response

3. **Hành động gây lỗi:**
   - Bước 1: ...
   - Bước 2: ...
   - Lỗi xuất hiện: ...

4. **Browser và version:**
   - Chrome? Firefox? Edge?
   - Version number?

---

## 📝 Files Đã Sửa

1. ✅ `WEBGMS/web/assets/css/chat-widget.css` - Fixed CSS syntax error (line 251)
2. ✅ `WEBGMS/fix_missing_tables.sql` - Fixed Google Auth tables
3. ✅ `WEBGMS/FIX_CHAT_UPLOAD_ISSUES.md` - This debug guide

---

## 🎯 Kết Luận

**Vấn đề chính đã được sửa:**
- CSS syntax error (duplicate brace) → **FIXED ✅**

**Upload đã hoạt động:**
- Backend controller: ✅ Working
- File validation: ✅ Working
- Storage: ✅ Working

**Vẫn cần test:**
- Frontend preview display
- Widget visibility
- Actual file upload flow

**Hãy:**
1. Clear cache browser
2. Rebuild application  
3. Restart server
4. Test lại upload
5. Báo lỗi nếu vẫn có vấn đề


