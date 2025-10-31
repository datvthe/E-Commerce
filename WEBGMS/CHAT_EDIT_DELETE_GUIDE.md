# 📝 Chat Message Edit/Delete + Smaller Images

## ✅ Tính Năng Đã Thêm

### **1. Giảm Kích Thước Hình Ảnh Đã Gửi** 🖼️
**Vấn đề trước:** Hình ảnh trong chat quá lớn (250-300px), chiếm hết không gian

**Đã fix:**
- Preview hình: 150px × 150px
- Hình đã gửi: 180px × 180px
- `object-fit: cover` để cắt hình đẹp
- Hover: Scale 1.05 + shadow effect

```css
.message-image {
    max-width: 180px;
    max-height: 180px;
    object-fit: cover;
    border-radius: 12px;
}
```

---

### **2. Edit Tin Nhắn** ✏️
**Tính năng:**
- Hover lên tin nhắn của mình → Hiện nút Edit (✏️)
- Click Edit → Input box xuất hiện
- Sửa nội dung → Enter hoặc click ✓
- Hiển thị "(đã chỉnh sửa)" sau khi sửa

**Cách dùng:**
1. Hover lên tin nhắn bạn đã gửi
2. Click nút Edit (✏️) góc trên phải
3. Sửa nội dung trong input
4. Nhấn Enter hoặc click ✓
5. Click ✕ để hủy

**Backend:** POST `/chat/edit-message`
- Verify ownership (chỉ sửa tin nhắn của mình)
- Update `message_content`
- Set `is_edited = true`

---

### **3. Delete Tin Nhắn** 🗑️
**Tính năng:**
- Hover lên tin nhắn của mình → Hiện nút Delete (🗑️)
- Click Delete → Confirm dialog
- Xác nhận → Tin nhắn biến mất với animation
- Soft delete: Giữ data trong DB

**Cách dùng:**
1. Hover lên tin nhắn bạn đã gửi
2. Click nút Delete (🗑️) góc trên phải
3. Confirm "Bạn có chắc chắn muốn xóa?"
4. Tin nhắn fade out và biến mất

**Backend:** POST `/chat/delete-message`
- Verify ownership
- Soft delete: `is_deleted = true`
- Keep data in database (không xóa hẳn)

---

## 🎯 Giao Diện

### **Message Actions (Hover State)**
```
┌──────────────────────────────────┐
│  Tin nhắn của bạn        [✏️][🗑️]│
│  Đây là nội dung tin nhắn        │
│  21:11                           │
└──────────────────────────────────┘
     ↑ Hover → Buttons appear
```

### **Edit Mode**
```
┌──────────────────────────────────┐
│  [Input: Sửa nội dung...] [✓][✕]│
│  21:11                           │
└──────────────────────────────────┘
```

### **After Edit**
```
┌──────────────────────────────────┐
│  Nội dung đã sửa (đã chỉnh sửa)  │
│  21:11                           │
└──────────────────────────────────┘
```

---

## 📁 Files Đã Tạo/Sửa

### **Frontend:**
1. ✅ `chat-widget.css`
   - Message actions styles
   - Edit form styles
   - Button hover effects
   - Smaller image sizes

2. ✅ `aibot-widget.js`
   - Updated `createMessageElement()`
   - Show action buttons for own messages
   - Display smaller images (150px)

3. ✅ `message-actions.js` (NEW)
   - `editMessage()` function
   - `saveMessageEdit()` function
   - `cancelMessageEdit()` function
   - `deleteMessage()` function

4. ✅ `footer.jsp`
   - Load `message-actions.js`

### **Backend:**
1. ✅ `EditMessageController.java` (NEW)
   - URL: `/chat/edit-message`
   - Verify user ownership
   - Update message content
   - Set `is_edited = true`

2. ✅ `DeleteMessageController.java` (NEW)
   - URL: `/chat/delete-message`
   - Verify user ownership
   - Soft delete message
   - Set `is_deleted = true`

### **Database:**
1. ✅ `add_message_edit_delete_columns.sql` (NEW)
   - Add `is_edited` column
   - Add `is_deleted` column
   - Add `deleted_at` column
   - Add indexes for performance

---

## 🔧 Cài Đặt

### **Bước 1: Update Database**
```sql
-- Chạy file SQL trong MySQL Workbench
-- File: add_message_edit_delete_columns.sql

USE gicungco;

ALTER TABLE chat_messages 
ADD COLUMN IF NOT EXISTS is_edited BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS is_deleted BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS deleted_at DATETIME NULL;

CREATE INDEX IF NOT EXISTS idx_chat_messages_deleted ON chat_messages(is_deleted);
```

### **Bước 2: Rebuild Application**
```bash
# NetBeans
- Clean and Build (Shift + F11)
```

### **Bước 3: Restart Server**
```bash
# NetBeans
- Stop server
- Run (F6)
```

### **Bước 4: Clear Browser Cache**
```bash
# Chrome/Edge
Ctrl + Shift + Delete
→ Clear cached images and files
→ Restart browser
```

---

## 🧪 Cách Test

### **Test 1: Giảm Size Hình Ảnh**
```
1. Gửi hình ảnh trong chat
2. ✅ Kiểm tra hình chỉ 150-180px (không quá lớn)
3. ✅ Hover hình → Scale + shadow
4. ✅ Click hình → Mở full size trong tab mới
```

### **Test 2: Edit Tin Nhắn**
```
1. Gửi tin nhắn: "Hello world"
2. Hover tin nhắn → ✅ Thấy nút Edit (✏️)
3. Click Edit → ✅ Input box xuất hiện
4. Sửa: "Hello Vietnam"
5. Nhấn Enter → ✅ Nội dung đổi thành "Hello Vietnam (đã chỉnh sửa)"
6. ✅ Database updated
```

### **Test 3: Delete Tin Nhắn**
```
1. Gửi tin nhắn: "Test delete"
2. Hover tin nhắn → ✅ Thấy nút Delete (🗑️)
3. Click Delete → ✅ Confirm dialog xuất hiện
4. Click OK → ✅ Tin nhắn fade out
5. ✅ Tin nhắn biến mất khỏi chat
6. ✅ Database: is_deleted = true (soft delete)
```

### **Test 4: Không Edit/Delete Được Tin Nhắn Của AI**
```
1. AI gửi tin nhắn
2. Hover lên → ✅ KHÔNG thấy nút Edit/Delete
3. ✅ Chỉ tin nhắn của user mới có action buttons
```

---

## 🔍 Debug

### **Nếu Không Thấy Action Buttons:**
```javascript
// Console (F12)
// 1. Check message element
let msg = document.querySelector('.chat-message-user');
console.log('Message:', msg);
console.log('Message ID:', msg.dataset.messageId);

// 2. Check if hover works
msg.querySelector('.message-actions').style.opacity = '1';
```

### **Nếu Edit Không Hoạt Động:**
```javascript
// Console (F12)
// Test edit function
editMessage('123'); // Replace 123 with actual message ID
```

### **Nếu Delete Không Hoạt Động:**
```javascript
// Console (F12)
// Test delete function
deleteMessage('123'); // Replace 123 with actual message ID
```

### **Check Backend Endpoints:**
```javascript
// Test edit endpoint
fetch('/WEBGMS/chat/edit-message', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({messageId: 123, newContent: 'Test'})
}).then(r => r.json()).then(console.log);

// Test delete endpoint
fetch('/WEBGMS/chat/delete-message', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({messageId: 123})
}).then(r => r.json()).then(console.log);
```

---

## 📊 Database Schema

### **chat_messages Table (Updated)**
```sql
CREATE TABLE chat_messages (
    message_id INT PRIMARY KEY AUTO_INCREMENT,
    room_id INT NOT NULL,
    sender_id BIGINT NOT NULL,
    message_content TEXT NOT NULL,
    is_edited BOOLEAN DEFAULT FALSE,         -- NEW
    is_deleted BOOLEAN DEFAULT FALSE,        -- NEW
    deleted_at DATETIME NULL,                -- NEW
    attachment_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (room_id) REFERENCES chat_rooms(room_id),
    FOREIGN KEY (sender_id) REFERENCES users(user_id),
    INDEX idx_deleted (is_deleted)
);
```

---

## 🚀 Features Summary

| Feature | Status | Size/Action |
|---------|--------|-------------|
| **Hình ảnh preview** | ✅ | 120px × 120px |
| **Hình đã gửi** | ✅ | 150-180px |
| **Edit button** | ✅ | Hover to show |
| **Edit form** | ✅ | Inline input |
| **Save edit** | ✅ | Enter or ✓ |
| **Cancel edit** | ✅ | Click ✕ |
| **Delete button** | ✅ | Hover to show |
| **Delete confirm** | ✅ | Confirm dialog |
| **Delete animation** | ✅ | Fade + slide |
| **Soft delete** | ✅ | Keep in DB |
| **Ownership check** | ✅ | Backend verify |
| **"(đã chỉnh sửa)"** | ✅ | Show after edit |

---

## ⚠️ Lưu Ý

### **Security:**
- ✅ Backend verify ownership (chỉ sửa/xóa tin nhắn của mình)
- ✅ SQL injection protected (PreparedStatement)
- ✅ Authentication required (session check)

### **Data Integrity:**
- ✅ Soft delete (không xóa hẳn khỏi DB)
- ✅ Track edit history (`is_edited` flag)
- ✅ Timestamp tracking (`updated_at`, `deleted_at`)

### **UX:**
- ✅ Hover to show actions (không làm loạn UI)
- ✅ Confirm before delete (prevent accidents)
- ✅ Smooth animations (professional look)
- ✅ Clear feedback ("đã chỉnh sửa" label)

---

## 🎉 Kết Quả

**Trước:**
- ❌ Hình ảnh quá lớn (250-300px)
- ❌ Không thể edit tin nhắn
- ❌ Không thể delete tin nhắn
- ❌ Không có actions menu

**Sau:**
- ✅ Hình ảnh nhỏ gọn (150-180px)
- ✅ Edit tin nhắn với inline form
- ✅ Delete tin nhắn với confirm
- ✅ Hover menu với animation
- ✅ Backend secure với ownership check
- ✅ Soft delete để giữ data
- ✅ Professional UX

---

## 📞 Hỗ Trợ

**Nếu gặp lỗi, gửi cho tôi:**

1. **Screenshot Console (F12)**
   - Tab Console → Copy errors
   - Tab Network → Screenshot failed requests

2. **Mô tả chi tiết:**
   - Tôi đang làm gì: ...
   - Lỗi xuất hiện: ...
   - Tin nhắn có messageId không: ...

3. **Database check:**
   ```sql
   SELECT * FROM chat_messages WHERE message_id = ?;
   -- Check is_edited, is_deleted columns exist
   ```

---

**All done! Happy chatting!** 💬✨


