# Chat Image Upload Feature - Implementation Guide

## ✨ Overview

The chat widget now supports image uploads, allowing users to send images in their conversations. Images are displayed inline in the chat interface and can be clicked to open in full size.

## 🎯 Features

### User Interface
- **Image Upload Button**: Click the image icon (📷) in the chat input area
- **Image Preview**: Selected images are previewed before sending
- **Remove Image**: Cancel image upload before sending
- **Image Display**: Images are shown inline in chat messages
- **Full Size View**: Click on any image to open it in a new tab

### Technical Features
- **File Validation**: Only image files accepted (jpg, png, gif, webp, etc.)
- **Size Limit**: Maximum 5MB per image
- **Secure Upload**: Images are uploaded to `/uploads/chat-images/`
- **Unique Filenames**: UUID-based naming to prevent conflicts
- **WebSocket Integration**: Images are sent via WebSocket for real-time delivery

## 📁 File Structure

```
WEBGMS/
├── src/java/controller/chat/
│   └── ChatImageUploadController.java    # Backend image upload handler
├── web/
│   ├── assets/
│   │   ├── css/
│   │   │   └── chat-widget.css           # Image preview & display styles
│   │   └── js/
│   │       └── chat-widget.js            # Image upload logic
│   ├── uploads/
│   │   └── chat-images/                  # Uploaded images directory
│   └── views/component/
│       └── chat-widget.jsp               # Widget UI with image upload
```

## 🔧 Components

### 1. Frontend (chat-widget.jsp)

**AI Bot View:**
```jsp
<input type="file" id="aiBotImageInput" accept="image/*" 
       style="display: none;" onchange="handleAIBotImageSelect(event)">
<button class="btn-widget-attach" onclick="document.getElementById('aiBotImageInput').click()">
    <i class="fas fa-image"></i>
</button>

<div class="chat-widget-image-preview" id="aiBotImagePreview" style="display: none;">
    <img id="aiBotPreviewImg" src="" alt="Preview">
    <button class="btn-remove-image" onclick="removeAIBotImage()">×</button>
</div>
```

**Conversation View:**
```jsp
<input type="file" id="widgetImageInput" accept="image/*" 
       style="display: none;" onchange="handleWidgetImageSelect(event)">
<button class="btn-widget-attach" onclick="document.getElementById('widgetImageInput').click()">
    <i class="fas fa-image"></i>
</button>

<div class="chat-widget-image-preview" id="widgetImagePreview" style="display: none;">
    <img id="widgetPreviewImg" src="" alt="Preview">
    <button class="btn-remove-image" onclick="removeWidgetImage()">×</button>
</div>
```

### 2. JavaScript (chat-widget.js)

**Key Functions:**

- `handleWidgetImageSelect(event)` - Handle image selection for conversations
- `handleAIBotImageSelect(event)` - Handle image selection for AI bot
- `removeWidgetImage()` - Remove selected image
- `removeAIBotImage()` - Remove AI bot image
- `uploadChatImage(file)` - Upload image to server
- `widgetSendMessage()` - Updated to handle image messages
- `appendWidgetMessage(message)` - Updated to display images

**Image Upload Process:**
```javascript
async function widgetSendMessage() {
    let imageUrl = null;
    
    if (widgetSelectedImage) {
        imageUrl = await uploadChatImage(widgetSelectedImage);
        if (!imageUrl) return;
        removeWidgetImage();
    }
    
    const message = {
        type: 'message',
        content: content || 'Đã gửi một hình ảnh',
        messageType: imageUrl ? 'image' : 'text',
        attachmentUrl: imageUrl
    };
    
    widgetWebSocket.send(JSON.stringify(message));
}
```

### 3. Backend (ChatImageUploadController.java)

**Endpoint:** `POST /chat/upload-image`

**Features:**
- File validation (type and size)
- UUID-based unique filenames
- Secure file storage
- JSON response with image URL

**Request:**
```
POST /chat/upload-image
Content-Type: multipart/form-data
Body: image=<file>
```

**Response (Success):**
```json
{
    "success": true,
    "imageUrl": "/uploads/chat-images/abc123-uuid.jpg",
    "fileName": "abc123-uuid.jpg"
}
```

**Response (Error):**
```json
{
    "success": false,
    "error": "File size exceeds 5MB limit"
}
```

## 🎨 Styling (chat-widget.css)

**Image Preview:**
```css
.chat-widget-image-preview {
    padding: 10px;
    background: #f0f2f5;
    border-top: 1px solid #e4e6eb;
}

.image-preview-container {
    position: relative;
    max-width: 200px;
}

.btn-remove-image {
    position: absolute;
    top: 5px;
    right: 5px;
    background: rgba(0,0,0,0.6);
    color: white;
}
```

**Image Display:**
```css
.widget-message-image {
    max-width: 250px;
    border-radius: 12px;
    margin-top: 5px;
    cursor: pointer;
}
```

## 🚀 Usage

### For Users

1. **Upload Image:**
   - Click the image button (📷) in the chat input
   - Select an image from your device
   - Preview will appear below the input
   - Click send to upload and send

2. **Remove Image:**
   - Click the × button on the preview to cancel

3. **View Images:**
   - Images appear inline in the chat
   - Click any image to view full size in new tab

### For Developers

1. **Customize Upload Directory:**
```java
private static final String UPLOAD_DIR = "uploads/chat-images";
```

2. **Adjust File Size Limit:**
```java
private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
```

3. **Add Image Processing:**
```java
// Add in ChatImageUploadController.java
// Example: resize, compress, or add watermark
```

## 🔒 Security Considerations

1. **File Type Validation**: Only image/* MIME types accepted
2. **Size Limits**: Maximum 5MB per file
3. **UUID Filenames**: Prevents filename collisions and path traversal
4. **Authentication Required**: Only logged-in users can upload
5. **Directory Isolation**: Images stored in dedicated upload directory

## 📊 Database Schema

The `chat_messages` table already supports images via the `attachment_url` column:

```sql
CREATE TABLE chat_messages (
    message_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    message_type ENUM('text', 'image', 'file', ...) DEFAULT 'text',
    message_content LONGTEXT,
    attachment_url LONGTEXT DEFAULT NULL,
    ...
);
```

## 🐛 Troubleshooting

### Images Not Uploading

1. Check file size (< 5MB)
2. Check file type (must be image)
3. Check server permissions for `uploads/chat-images/` directory
4. Check server logs for errors

### Images Not Displaying

1. Check image URL path in database
2. Verify image exists in `uploads/chat-images/`
3. Check web server access to uploads directory
4. Clear browser cache

### WebSocket Issues

1. Ensure WebSocket connection is active
2. Check console for connection errors
3. Verify backend WebSocket handler processes image messages

## 🎉 Features Coming Soon

- Image compression before upload
- Multiple image uploads
- Image thumbnails in chat list
- Copy/paste image support
- Drag & drop upload
- Image gallery view

## 📞 Support

For issues or questions, contact the development team or check the project documentation.

