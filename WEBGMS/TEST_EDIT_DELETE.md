# 🧪 Test Edit/Delete Functions

## ✅ Đã Sửa

### **1. Vị trí nút:** Bên trái tin nhắn, hàng ngang
```
Layout: [Tin nhắn] [🟧 Edit] [🟥 Delete]
```

### **2. Style mới:**
- Hình vuông bo góc: 32px × 32px
- Edit button: Cam (orange)
- Delete button: Đỏ (red)
- Hover: Nút nhô lên 2px

### **3. Fixed onclick:**
- Thêm `event.stopPropagation()`
- Tránh conflict với events khác

---

## 🔍 Debug Steps

### **Bước 1: Check Console**
Mở Console (F12) và chạy:

```javascript
// 1. Check if functions exist
console.log('editMessage:', typeof window.editMessage);
console.log('deleteMessage:', typeof window.deleteMessage);

// 2. Check if message-actions.js loaded
console.log('Message actions loaded:', document.querySelector('script[src*="message-actions.js"]') !== null);

// 3. Find all messages with messageId
let messages = document.querySelectorAll('[data-message-id]');
console.log('Messages with ID:', messages.length);
messages.forEach(msg => {
    console.log('Message ID:', msg.dataset.messageId);
});

// 4. Check action buttons
let actionButtons = document.querySelectorAll('.btn-message-action');
console.log('Action buttons found:', actionButtons.length);

// 5. Test click manually
let editBtn = document.querySelector('.btn-message-edit');
if (editBtn) {
    console.log('Edit button found!');
    editBtn.click(); // Test click
} else {
    console.error('Edit button NOT found!');
}
```

---

## 🐛 Common Issues & Fixes

### **Issue 1: Functions không tồn tại**
```javascript
// Error: editMessage is not defined
```

**Fix:**
```html
<!-- Check if message-actions.js is loaded -->
<!-- Should be in footer.jsp or chat.jsp -->
<script src="${pageContext.request.contextPath}/assets/js/message-actions.js"></script>
```

---

### **Issue 2: messageId = undefined hoặc empty**
```javascript
// Console shows: Message ID: undefined
```

**Fix:** Check backend trả về messageId:
```javascript
// In chat.js or chat-widget.js
console.log('Message data:', message);
console.log('messageId:', message.messageId || message.message_id);
```

Backend phải return:
```json
{
  "messageId": 123,
  "content": "Hello",
  "senderId": 456,
  ...
}
```

---

### **Issue 3: Buttons không hiện khi hover**
```javascript
// Buttons exist but opacity = 0 always
```

**Fix:** Check CSS:
```css
/* Should have this in chat-widget.css */
.widget-message:hover .message-actions,
.chat-message:hover .message-actions,
.message:hover .message-actions {
    opacity: 1 !important; /* Force show for testing */
}
```

Force show for testing:
```javascript
// In Console
document.querySelectorAll('.message-actions').forEach(el => {
    el.style.opacity = '1';
    el.style.display = 'flex';
});
```

---

### **Issue 4: Click không hoạt động**
```javascript
// Button appears but click does nothing
```

**Fix 1:** Check onclick attribute exists:
```javascript
let btn = document.querySelector('.btn-message-edit');
console.log('Button:', btn);
console.log('onclick:', btn.getAttribute('onclick'));
```

**Fix 2:** Test function directly:
```javascript
// Get first message ID
let msgId = document.querySelector('[data-message-id]').dataset.messageId;
console.log('Testing with messageId:', msgId);

// Test edit
editMessage(msgId);

// Test delete
deleteMessage(msgId);
```

---

### **Issue 5: Backend endpoint không hoạt động**
```javascript
// Error: 404 Not Found - /chat/edit-message
```

**Fix:** Verify endpoints:
```javascript
// Test edit endpoint
fetch('/WEBGMS/chat/edit-message', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({
        messageId: 123, // Replace with real ID
        newContent: 'Test edit'
    })
})
.then(r => r.text())
.then(text => {
    console.log('Response:', text);
    try {
        let json = JSON.parse(text);
        console.log('JSON:', json);
    } catch(e) {
        console.error('Not JSON, raw text:', text);
    }
});
```

Check if controllers exist:
- `WEBGMS/src/java/controller/chat/EditMessageController.java`
- `WEBGMS/src/java/controller/chat/DeleteMessageController.java`

---

## 🔬 Manual Test Script

Paste this in Console (F12):

```javascript
console.log('=== EDIT/DELETE TEST ===');

// 1. Check functions
console.log('1. Functions exist:');
console.log('  editMessage:', typeof window.editMessage);
console.log('  deleteMessage:', typeof window.deleteMessage);

// 2. Check messages
let messages = document.querySelectorAll('[data-message-id]');
console.log('2. Messages:', messages.length);

if (messages.length > 0) {
    let msg = messages[0];
    let msgId = msg.dataset.messageId;
    console.log('  First message ID:', msgId);
    
    // 3. Check buttons
    let actions = msg.querySelector('.message-actions');
    console.log('3. Actions div:', actions !== null);
    
    if (actions) {
        let editBtn = actions.querySelector('.btn-message-edit');
        let deleteBtn = actions.querySelector('.btn-message-delete');
        console.log('  Edit button:', editBtn !== null);
        console.log('  Delete button:', deleteBtn !== null);
        
        // 4. Force show
        actions.style.opacity = '1';
        actions.style.display = 'flex';
        console.log('4. Buttons force shown');
        
        // 5. Test edit function
        if (typeof window.editMessage === 'function') {
            console.log('5. Testing editMessage...');
            try {
                window.editMessage(msgId);
                console.log('  ✓ editMessage called successfully');
            } catch(e) {
                console.error('  ✗ editMessage error:', e);
            }
        }
    } else {
        console.error('  ✗ No .message-actions found!');
        console.log('  Message HTML:', msg.innerHTML.substring(0, 200));
    }
} else {
    console.error('✗ No messages found with data-message-id attribute!');
    console.log('Searching for any message elements...');
    let anyMessages = document.querySelectorAll('.widget-message, .chat-message, .message');
    console.log('Total message elements:', anyMessages.length);
    if (anyMessages.length > 0) {
        console.log('First message HTML:', anyMessages[0].innerHTML.substring(0, 300));
    }
}

console.log('=== TEST COMPLETE ===');
```

---

## 📋 Checklist

Run through this checklist:

### **Frontend:**
- [ ] `message-actions.js` loaded in page?
- [ ] `editMessage` function exists? (`typeof window.editMessage`)
- [ ] `deleteMessage` function exists? (`typeof window.deleteMessage`)
- [ ] Messages have `data-message-id` attribute?
- [ ] `.message-actions` div exists in messages?
- [ ] `.btn-message-edit` button exists?
- [ ] `.btn-message-delete` button exists?
- [ ] CSS `.message-actions` has correct styles?
- [ ] Hover shows buttons (`opacity: 1`)?

### **Backend:**
- [ ] Database has `is_edited` column?
- [ ] Database has `is_deleted` column?
- [ ] `EditMessageController.java` exists?
- [ ] `DeleteMessageController.java` exists?
- [ ] Controllers are compiled (`.class` files exist)?
- [ ] Servlet URLs registered (`@WebServlet`)?

### **Integration:**
- [ ] Can reach `/chat/edit-message` endpoint?
- [ ] Can reach `/chat/delete-message` endpoint?
- [ ] Backend returns JSON response?
- [ ] Frontend receives response?
- [ ] UI updates after edit/delete?

---

## 🚀 Quick Fix Checklist

If still not working:

```bash
# 1. Clear everything
Ctrl + Shift + Delete (clear cache)

# 2. Rebuild
Shift + F11 (Clean and Build)

# 3. Check files exist
# Look for these .class files:
WEBGMS/build/web/WEB-INF/classes/controller/chat/EditMessageController.class
WEBGMS/build/web/WEB-INF/classes/controller/chat/DeleteMessageController.class

# 4. Check JS files copied
WEBGMS/build/web/assets/js/message-actions.js

# 5. Restart server
F6 (Run)

# 6. Hard reload page
Ctrl + Shift + R
```

---

## 📞 Still Not Working?

Gửi cho tôi:

1. **Console screenshot (F12)**
   - Chạy manual test script ở trên
   - Screenshot kết quả

2. **Network tab**
   - Filter: "edit" hoặc "delete"
   - Screenshot các request failed

3. **Message HTML**
   ```javascript
   let msg = document.querySelector('[data-message-id]');
   console.log(msg ? msg.outerHTML : 'No message found');
   ```

4. **Functions check**
   ```javascript
   console.log('editMessage:', window.editMessage);
   console.log('deleteMessage:', window.deleteMessage);
   console.log('All window functions:', Object.keys(window).filter(k => k.includes('Message')));
   ```


