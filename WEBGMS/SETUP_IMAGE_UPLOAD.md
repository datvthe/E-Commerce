# 🖼️ Chat Image Upload - Setup Guide

## Quick Setup (3 Steps)

### ✅ Step 1: Update Database Schema

Run this SQL command in your database management tool:

```sql
USE gicungco;

-- Add attachment_url column for image uploads
ALTER TABLE chat_messages 
ADD COLUMN attachment_url LONGTEXT DEFAULT NULL 
AFTER message_content;

-- Verify it was added
DESCRIBE chat_messages;
```

**OR** run the complete schema update script:
```bash
# In your database tool, execute:
update_chat_messages_schema.sql
```

### ✅ Step 2: Create Upload Directory

The upload directory should be created automatically, but you can verify it exists:

```
WEBGMS/web/uploads/chat-images/
```

If it doesn't exist, create it manually with proper write permissions.

### ✅ Step 3: Test Image Upload

1. **Open your application**
2. **Log in as a user**
3. **Open the chat widget** (floating chat button)
4. **Click the image icon** (📷)
5. **Select an image** (max 5MB)
6. **Send the message**
7. **Image should appear in chat!**

## 🔍 Verify Installation

### Check Database:
```sql
-- Check if column exists
DESCRIBE chat_messages;

-- Should show:
-- attachment_url | LONGTEXT | YES | NULL
```

### Check Upload Directory:
```bash
# Check if directory exists and is writable
ls -la WEBGMS/web/uploads/chat-images/
```

### Check Backend:
- File exists: `ChatImageUploadController.java`
- Endpoint accessible: `POST /chat/upload-image`

### Check Frontend:
- File modified: `chat-widget.jsp` (has image upload buttons)
- File modified: `chat-widget.js` (has upload functions)
- File modified: `chat-widget.css` (has image styles)

## 🎯 Expected Behavior

### When User Uploads Image:

1. **Click Image Button** → File picker opens
2. **Select Image** → Preview appears below input
3. **Click Send** → Image uploads to server
4. **Success** → Image appears in chat for both users
5. **Click Image** → Opens full size in new tab

### Database Entry:
```
message_id: 42
message_type: 'image'
message_content: 'Đã gửi một hình ảnh'
attachment_url: '/uploads/chat-images/abc123-uuid.jpg'
```

### Stored File:
```
WEBGMS/web/uploads/chat-images/abc123-uuid.jpg
```

## 🐛 Troubleshooting

### Issue: "Column 'attachment_url' not found"
**Solution:** Run the database update script above

### Issue: "Upload failed"
**Solution:** 
1. Check file size (< 5MB)
2. Check file type (must be image)
3. Check directory permissions
4. Check server logs

### Issue: "Image not displaying"
**Solution:**
1. Clear browser cache
2. Check image URL in database
3. Verify file exists in uploads directory
4. Check web server can access uploads folder

### Issue: "Permission denied"
**Solution:**
```bash
# Set proper permissions (Linux/Mac)
chmod 755 WEBGMS/web/uploads/
chmod 755 WEBGMS/web/uploads/chat-images/

# Or (Windows)
# Right-click folder → Properties → Security → Edit permissions
```

## 📊 Database Schema

### Before:
```sql
CREATE TABLE chat_messages (
    message_id BIGINT PRIMARY KEY,
    message_type ENUM('text', 'system'),
    message_content LONGTEXT,
    -- attachment_url column missing!
    ...
);
```

### After:
```sql
CREATE TABLE chat_messages (
    message_id BIGINT PRIMARY KEY,
    message_type ENUM('text', 'image', 'system'),
    message_content LONGTEXT,
    attachment_url LONGTEXT DEFAULT NULL,  -- ✅ Added!
    metadata JSON DEFAULT NULL,            -- ✅ Added!
    ...
);
```

## 🎉 Success Checklist

- [ ] Database column `attachment_url` added
- [ ] Upload directory exists and is writable
- [ ] `ChatImageUploadController.java` file exists
- [ ] Frontend files updated (jsp, js, css)
- [ ] Tested image upload successfully
- [ ] Image displays in chat
- [ ] Can click to view full size

## 📞 Support

If you encounter any issues:
1. Check the console for error messages (F12 in browser)
2. Check server logs for backend errors
3. Verify all files are in place
4. Run the SQL schema update again

**That's it! Your chat now supports image uploads! 🎊**

