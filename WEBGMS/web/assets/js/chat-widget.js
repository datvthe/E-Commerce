/**
 * Floating Chat Widget - JavaScript Controller
 */

let widgetContextPath = '';
let widgetUserId = -1;
let widgetUserRole = 'guest';
let widgetCurrentRoomId = null;
let widgetWebSocket = null;
let widgetUnreadCount = 0;

/**
 * Initialize chat widget
 */
function initChatWidget(contextPath, userId, userRole) {
    widgetContextPath = contextPath;
    widgetUserId = userId;
    widgetUserRole = userRole;
    
    console.log('[Widget] initChatWidget called - userId:', userId, 'role:', userRole);
    
    // Setup file handlers after a short delay to ensure elements are ready
    setTimeout(() => {
        console.log('[Widget] Setting up file handlers from initChatWidget');
        window.setupWidgetFileHandlers();
    }, 500);
    
    if (userId > 0) {
        loadWidgetChatRooms();
        // Refresh every 30 seconds
        setInterval(loadWidgetChatRooms, 30000);
    }
}

/**
 * Toggle widget visibility
 */
function toggleChatWidget() {
    const container = document.getElementById('chatWidgetContainer');
    const button = document.getElementById('chatWidgetToggle');
    
    if (container.style.display === 'none') {
        container.style.display = 'flex';
        button.innerHTML = '<i class="fas fa-times"></i>';
        
        // Setup file handlers when widget opens
        setTimeout(() => setupWidgetFileHandlers(), 100);
        
        if (widgetUserId > 0) {
            loadWidgetChatRooms();
        }
    } else {
        container.style.display = 'none';
        button.innerHTML = '<i class="fas fa-comments"></i>';
        if (widgetCurrentRoomId) {
            closeWidgetWebSocket();
        }
    }
}

/**
 * Load chat rooms for widget
 */
function loadWidgetChatRooms() {
    if (widgetUserId <= 0) return;
    
    fetch(widgetContextPath + '/chat/')
        .then(response => response.json())
        .then(rooms => {
            const listContainer = document.getElementById('widgetChatList');
            listContainer.innerHTML = '';
            
            if (rooms.length === 0) {
                listContainer.innerHTML = `
                    <div class="chat-widget-loading">
                        <i class="fas fa-comments"></i>
                        <p>Chưa có cuộc trò chuyện</p>
                    </div>
                `;
                return;
            }
            
            let totalUnread = 0;
            rooms.forEach(room => {
                totalUnread += room.unreadCount || 0;
                const item = createWidgetChatItem(room);
                listContainer.appendChild(item);
            });
            
            updateWidgetBadge(totalUnread);
        })
        .catch(error => console.error('Error loading widget chat rooms:', error));
}

/**
 * Create chat item element for widget
 */
function createWidgetChatItem(room) {
    const div = document.createElement('div');
    div.className = 'chat-widget-item';
    div.onclick = () => openWidgetChat(room.roomId);
    
    const unreadBadge = room.unreadCount > 0 ? 
        `<span class="chat-widget-item-badge">${room.unreadCount}</span>` : '';
    
    div.innerHTML = `
        <img src="${room.avatar || widgetContextPath + '/assets/images/default-avatar.png'}" 
             alt="Avatar" class="chat-widget-item-avatar">
        <div class="chat-widget-item-content">
            <h5 class="chat-widget-item-name">${room.roomName || 'Chat Room'}</h5>
            <p class="chat-widget-item-message">${room.lastMessage || 'Chưa có tin nhắn'}</p>
        </div>
        <div>
            <div class="chat-widget-item-time">${formatWidgetTime(room.lastMessageAt)}</div>
            ${unreadBadge}
        </div>
    `;
    
    return div;
}

/**
 * Open chat in widget
 */
function openWidgetChat(roomId) {
    widgetCurrentRoomId = roomId;
    
    // Switch views
    document.getElementById('chatWidgetListView').style.display = 'none';
    document.getElementById('chatWidgetConversationView').style.display = 'flex';
    
    // Setup file handlers for this view
    setupWidgetFileHandlers();
    
    // Load room details
    fetch(widgetContextPath + '/chat/room/' + roomId)
        .then(response => response.json())
        .then(data => {
            const participants = data.participants;
            const otherParticipant = participants.find(p => p.userId !== widgetUserId);
            
            if (otherParticipant) {
                document.getElementById('widgetChatTitle').textContent = otherParticipant.userName;
            }
            
            loadWidgetMessages(roomId);
            connectWidgetWebSocket(roomId);
        })
        .catch(error => console.error('Error loading widget chat:', error));
}

/**
 * Load messages for widget
 */
function loadWidgetMessages(roomId) {
    fetch(widgetContextPath + '/chat/messages/' + roomId + '?limit=20')
        .then(response => response.json())
        .then(messages => {
            const container = document.getElementById('widgetMessages');
            container.innerHTML = '';
            
            // Sort messages by creation time to ensure proper order
            // Since timestamps are corrupted, we'll use message_id sorting
            messages.sort((a, b) => {
                // Always use message_id as primary sort since timestamps are corrupted
                const idA = parseInt(a.messageId) || 0;
                const idB = parseInt(b.messageId) || 0;
                
                console.log('[Widget] Sorting by message_id - A:', idA, 'B:', idB);
                return idA - idB; // Ascending order (oldest first)
            });
            
            messages.forEach(message => {
                appendWidgetMessage(message);
            });
            
            // Ensure scroll to bottom after loading messages
            setTimeout(() => {
                scrollWidgetToBottom();
                // Force scroll again to ensure it works
                setTimeout(() => {
                    scrollWidgetToBottom();
                }, 50);
            }, 10);
            
            markWidgetAsRead(roomId);
        })
        .catch(error => console.error('Error loading widget messages:', error));
}

/**
 * Connect WebSocket for widget
 */
function connectWidgetWebSocket(roomId) {
    if (widgetWebSocket) {
        widgetWebSocket.close();
    }
    
    const wsProtocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
    const wsUrl = `${wsProtocol}//${window.location.host}${widgetContextPath}/chat/${roomId}/${widgetUserId}`;
    
    widgetWebSocket = new WebSocket(wsUrl);
    
    widgetWebSocket.onopen = function() {
        console.log('Widget WebSocket connected');
    };
    
    widgetWebSocket.onmessage = function(event) {
        const message = JSON.parse(event.data);
        handleWidgetWebSocketMessage(message);
    };
    
    widgetWebSocket.onerror = function(error) {
        console.error('Widget WebSocket error:', error);
    };
    
    widgetWebSocket.onclose = function() {
        console.log('Widget WebSocket closed');
    };
}

/**
 * Handle WebSocket messages for widget
 */
function handleWidgetWebSocketMessage(message) {
    console.log('[Widget] WebSocket message received:', message.type, message);
    
    switch (message.type) {
        case 'connected':
            console.log('Widget connected to room:', message.roomId);
            break;
            
        case 'new_message':
            // Only append if it's from another user (avoid duplicates)
            if (message.senderId !== widgetUserId) {
                console.log('[Widget] Appending message from other user');
                appendWidgetMessage(message);
                scrollWidgetToBottom();
                playWidgetNotification();
            } else {
                console.log('[Widget] Skipping own message (already displayed)');
            }
            break;
            
        case 'typing':
            if (message.userId !== widgetUserId) {
                showWidgetTyping(message.isTyping);
            }
            break;
            
        default:
            console.log('[Widget] Unknown message type:', message.type);
    }
}

/**
 * Append message to widget
 */
function appendWidgetMessage(message) {
    if (!message) {
        console.error('[Widget] Cannot append null/undefined message');
        return;
    }
    
    const container = document.getElementById('widgetMessages');
    if (!container) {
        console.error('[Widget] Container "widgetMessages" not found');
        return;
    }
    
    const messageContent = message.content || message.messageContent;
    const messageType = message.messageType || 'text';
    const attachmentUrl = message.attachmentUrl || message.attachment_url;
    
    // Skip if no content and no image
    if (!messageContent && !attachmentUrl) {
        console.error('[Widget] Message has no content or image:', message);
        return;
    }
    
    console.log('[Widget] Appending message:', {
        senderId: message.senderId,
        content: messageContent ? messageContent.substring(0, 30) : '(image)',
        type: messageType,
        isOwn: message.senderId === widgetUserId
    });
    
    const messageDiv = document.createElement('div');
    
    const isOwn = message.senderId === widgetUserId;
    const isAI = message.isAiResponse || message.senderRole === 'ai';
    
    messageDiv.className = `widget-message ${isOwn ? 'widget-message-own' : 'widget-message-other'} ${isAI ? 'widget-message-ai' : ''}`;
    
    // Build message content HTML
    let messageHTML = '';
    if (messageContent && messageContent.trim()) {
        messageHTML += `<div class="widget-message-bubble">${escapeWidgetHtml(messageContent)}</div>`;
    }
    if (messageType === 'image' && attachmentUrl) {
        messageHTML += `<img src="${widgetContextPath}${attachmentUrl}" alt="Image" class="widget-message-image" onclick="window.open('${widgetContextPath}${attachmentUrl}', '_blank')">`;
    } else if (messageType === 'file' && attachmentUrl) {
        const fileName = attachmentUrl.split('/').pop();
        messageHTML += `<div class="widget-message-file" onclick="window.open('${widgetContextPath}${attachmentUrl}', '_blank')">
            <i class="fas fa-file"></i>
            <span>${fileName}</span>
            <i class="fas fa-download"></i>
        </div>`;
    }
    
    messageDiv.innerHTML = `
        ${!isOwn ? `<img src="${message.senderAvatar || widgetContextPath + '/assets/images/default-avatar.png'}" 
                         alt="Avatar" class="widget-message-avatar">` : ''}
        <div class="widget-message-content">
            ${messageHTML}
            <div class="widget-message-time">${formatWidgetMessageTime(message.createdAt)}</div>
        </div>
    `;
    
    container.appendChild(messageDiv);
}

/**
 * Send message from widget
 */
async function widgetSendMessage() {
    console.log('[Widget] widgetSendMessage called');
    const input = document.getElementById('widgetMessageInput');
    const content = input.value.trim();
    
    console.log('[Widget] Message content:', content);
    console.log('[Widget] widgetSelectedFile:', widgetSelectedFile);
    
    // Check if there's a message or file
    if (!content && !widgetSelectedFile) {
        console.log('[Widget] Empty message, not sending');
        return;
    }
    
    if (!widgetWebSocket || widgetWebSocket.readyState !== WebSocket.OPEN) {
        console.error('[Widget] WebSocket not connected');
        alert('Không thể gửi tin nhắn. Vui lòng thử lại.');
        return;
    }
    
    let attachmentUrl = null;
    let messageType = 'text';
    
    // Upload file if selected
    if (widgetSelectedFile) {
        console.log('[Widget] File detected! Uploading file:', widgetSelectedFile.name);
        const uploadResult = await uploadChatFile(widgetSelectedFile);
        console.log('[Widget] Upload result:', uploadResult);
        
        if (!uploadResult) {
            console.error('[Widget] Upload failed, aborting send');
            return; // Upload failed
        }
        
        attachmentUrl = uploadResult.url;
        messageType = uploadResult.type === 'image' ? 'image' : 'file';
        console.log('[Widget] File uploaded successfully! URL:', attachmentUrl, 'Type:', messageType);
        removeWidgetFile(); // Clear preview
    }
    
    console.log('[Widget] Sending message:', content, 'Attachment:', attachmentUrl);
    
    const message = {
        type: 'message',
        content: content || (messageType === 'image' ? 'Đã gửi một hình ảnh' : 'Đã gửi một file'),
        messageType: messageType,
        senderRole: widgetUserRole,
        attachmentUrl: attachmentUrl
    };
    
    // Send via WebSocket
    widgetWebSocket.send(JSON.stringify(message));
    
    // Optimistically display user's own message immediately
    const userMessage = {
        senderId: widgetUserId,
        messageContent: content || (messageType === 'image' ? 'Đã gửi một hình ảnh' : 'Đã gửi một file'),
        content: content || (messageType === 'image' ? 'Đã gửi một hình ảnh' : 'Đã gửi một file'),
        senderRole: widgetUserRole,
        messageType: messageType,
        attachmentUrl: attachmentUrl,
        createdAt: new Date().toISOString(),
        isAiResponse: false
    };
    
    appendWidgetMessage(userMessage);
    scrollWidgetToBottom();
    
    // Clear input
    input.value = '';
    input.style.height = 'auto';
}

/**
 * Back to chat list
 */
function backToList() {
    document.getElementById('chatWidgetConversationView').style.display = 'none';
    document.getElementById('chatWidgetListView').style.display = 'flex';
    
    if (widgetWebSocket) {
        widgetWebSocket.close();
        widgetWebSocket = null;
    }
    
    widgetCurrentRoomId = null;
    loadWidgetChatRooms();
}

/**
 * Open full chat page
 */
function openFullChat() {
    if (widgetCurrentRoomId) {
        window.open(widgetContextPath + '/views/chat/chat.jsp?room=' + widgetCurrentRoomId, '_blank');
    } else {
        window.location.href = widgetContextPath + '/views/chat/chat.jsp';
    }
}

/**
 * Mark messages as read
 */
function markWidgetAsRead(roomId) {
    fetch(widgetContextPath + '/chat/markRead', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'roomId=' + roomId
    }).catch(error => console.error('Error marking as read:', error));
}

/**
 * Show typing indicator
 */
function showWidgetTyping(isTyping) {
    const indicator = document.getElementById('widgetTypingIndicator');
    indicator.style.display = isTyping ? 'flex' : 'none';
    if (isTyping) {
        scrollWidgetToBottom();
    }
}

/**
 * Update widget badge
 */
function updateWidgetBadge(count) {
    widgetUnreadCount = count;
    const badge = document.getElementById('chatWidgetBadge');
    
    if (count > 0) {
        badge.textContent = count > 99 ? '99+' : count;
        badge.style.display = 'block';
    } else {
        badge.style.display = 'none';
    }
}

/**
 * Close WebSocket
 */
function closeWidgetWebSocket() {
    if (widgetWebSocket) {
        widgetWebSocket.close();
        widgetWebSocket = null;
    }
}

/**
 * Utility functions
 */
function scrollWidgetToBottom() {
    const container = document.getElementById('widgetMessages');
    if (container) {
        container.scrollTop = container.scrollHeight;
        
        // Force scroll with a small delay to handle dynamic content
        setTimeout(() => {
            container.scrollTop = container.scrollHeight;
        }, 10);
    }
}

function formatWidgetTime(timestamp) {
    if (!timestamp) return '';
    const date = new Date(timestamp);
    const now = new Date();
    const diff = now - date;
    
    if (diff < 60000) return 'Vừa xong';
    if (diff < 3600000) return Math.floor(diff / 60000) + 'p';
    if (diff < 86400000) return Math.floor(diff / 3600000) + 'h';
    return date.toLocaleDateString('vi-VN', {day: '2-digit', month: '2-digit'});
}

function formatWidgetMessageTime(timestamp) {
    if (!timestamp) return '';
    
    // Handle different timestamp formats
    let date;
    if (typeof timestamp === 'string') {
        // Try to parse as ISO string first
        date = new Date(timestamp);
        // If that fails, try parsing as timestamp
        if (isNaN(date.getTime())) {
            date = new Date(parseInt(timestamp));
        }
        // If still fails, try parsing as MySQL datetime format
        if (isNaN(date.getTime())) {
            // Handle MySQL datetime format: "2024-01-01 12:00:00"
            const mysqlDate = timestamp.replace(' ', 'T');
            date = new Date(mysqlDate);
        }
    } else {
        date = new Date(timestamp);
    }
    
    if (isNaN(date.getTime())) {
        console.warn('[Widget] Invalid timestamp:', timestamp);
        return '';
    }
    
    return date.toLocaleTimeString('vi-VN', {
        hour: '2-digit', 
        minute: '2-digit',
        hour12: false
    });
}

function escapeWidgetHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML.replace(/\n/g, '<br>');
}

function playWidgetNotification() {
    // Play sound or show notification
    if (document.getElementById('chatWidgetContainer').style.display === 'none') {
        updateWidgetBadge(widgetUnreadCount + 1);
    }
}

/**
 * Input handlers
 */
document.addEventListener('DOMContentLoaded', function() {
    console.log('[Widget] DOMContentLoaded - Setting up event listeners');
    
    const input = document.getElementById('widgetMessageInput');
    if (input) {
        input.addEventListener('keypress', function(e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                widgetSendMessage();
            }
        });
        
        input.addEventListener('input', function() {
            this.style.height = 'auto';
            this.style.height = Math.min(this.scrollHeight, 80) + 'px';
        });
    }
    
    // Setup file input handlers
    window.setupWidgetFileHandlers();
    
    // Setup again after delays to catch dynamically loaded elements
    setTimeout(() => window.setupWidgetFileHandlers(), 1000);
    setTimeout(() => window.setupWidgetFileHandlers(), 2000);
    
    // Search functionality
    const searchInput = document.getElementById('widgetSearchInput');
    if (searchInput) {
        searchInput.addEventListener('input', function(e) {
            const query = e.target.value.toLowerCase();
            const items = document.querySelectorAll('.chat-widget-item');
            
            items.forEach(item => {
                const name = item.querySelector('.chat-widget-item-name').textContent.toLowerCase();
                const message = item.querySelector('.chat-widget-item-message').textContent.toLowerCase();
                
                if (name.includes(query) || message.includes(query)) {
                    item.style.display = 'flex';
                } else {
                    item.style.display = 'none';
                }
            });
        });
    }
});

/**
 * File Upload Functions
 */
let widgetSelectedFile = null;
let aiBotSelectedFile = null;

// Setup file input handlers
window.setupWidgetFileHandlers = function() {
    console.log('[Widget] Setting up file handlers');
    
    const widgetFileInput = document.getElementById('widgetFileInput');
    if (widgetFileInput) {
        // Remove old listener if any
        widgetFileInput.removeEventListener('change', window.handleWidgetFileSelect);
        // Add new listener
        widgetFileInput.addEventListener('change', window.handleWidgetFileSelect);
        console.log('[Widget] widgetFileInput handler attached');
    } else {
        console.warn('[Widget] widgetFileInput element not found');
    }
    
    const aiBotFileInput = document.getElementById('aiBotFileInput');
    if (aiBotFileInput) {
        // Remove old listener if any
        aiBotFileInput.removeEventListener('change', window.handleAIBotFileSelect);
        // Add new listener
        aiBotFileInput.addEventListener('change', window.handleAIBotFileSelect);
        console.log('[Widget] aiBotFileInput handler attached');
    } else {
        console.warn('[Widget] aiBotFileInput element not found');
    }
}

// Handle file selection for widget conversation
window.handleWidgetFileSelect = function(event) {
    console.log('[Widget] handleWidgetFileSelect called');
    const file = event.target.files[0];
    if (!file) {
        console.log('[Widget] No file selected');
        return;
    }
    
    console.log('[Widget] File selected:', file.name, 'Type:', file.type, 'Size:', file.size);
    
    // Validate file size (10MB max)
    const maxSize = file.type.startsWith('image/') ? 5 * 1024 * 1024 : 10 * 1024 * 1024;
    if (file.size > maxSize) {
        console.error('[Widget] File too large:', file.size, 'Max:', maxSize);
        alert(`Kích thước file không được vượt quá ${maxSize / 1024 / 1024}MB!`);
        return;
    }
    
    widgetSelectedFile = file;
    console.log('[Widget] File stored in widgetSelectedFile');
    
    // Preview file
    const previewContainer = document.getElementById('widgetFilePreview');
    const previewImg = document.getElementById('widgetPreviewImg');
    const fileInfo = document.getElementById('widgetFileInfo');
    const fileName = document.getElementById('widgetFileName');
    
    console.log('[Widget] Preview elements:', {
        container: !!previewContainer,
        img: !!previewImg,
        fileInfo: !!fileInfo,
        fileName: !!fileName
    });
    
    if (file.type.startsWith('image/')) {
        // Preview image
        console.log('[Widget] Previewing image...');
        const reader = new FileReader();
        reader.onload = function(e) {
            previewImg.src = e.target.result;
            previewImg.style.display = 'block';
            fileInfo.style.display = 'none';
            console.log('[Widget] Image preview loaded');
        };
        reader.readAsDataURL(file);
    } else {
        // Show file info
        console.log('[Widget] Showing file info for:', file.name);
        fileName.textContent = file.name;
        fileInfo.style.display = 'block';
        previewImg.style.display = 'none';
    }
    
    previewContainer.style.display = 'block';
    console.log('[Widget] Preview container shown');
}

// Remove selected file from widget
window.removeWidgetFile = function() {
    widgetSelectedFile = null;
    document.getElementById('widgetFileInput').value = '';
    document.getElementById('widgetFilePreview').style.display = 'none';
}

// Handle file selection for AI bot
window.handleAIBotFileSelect = function(event) {
    const file = event.target.files[0];
    if (!file) return;
    
    // Validate file size (10MB max)
    const maxSize = file.type.startsWith('image/') ? 5 * 1024 * 1024 : 10 * 1024 * 1024;
    if (file.size > maxSize) {
        alert(`Kích thước file không được vượt quá ${maxSize / 1024 / 1024}MB!`);
        return;
    }
    
    aiBotSelectedFile = file;
    
    // Preview file
    const previewContainer = document.getElementById('aiBotFilePreview');
    const previewImg = document.getElementById('aiBotPreviewImg');
    const fileInfo = document.getElementById('aiBotFileInfo');
    const fileName = document.getElementById('aiBotFileName');
    
    if (file.type.startsWith('image/')) {
        // Preview image
        const reader = new FileReader();
        reader.onload = function(e) {
            previewImg.src = e.target.result;
            previewImg.style.display = 'block';
            fileInfo.style.display = 'none';
        };
        reader.readAsDataURL(file);
    } else {
        // Show file info
        fileName.textContent = file.name;
        fileInfo.style.display = 'block';
        previewImg.style.display = 'none';
    }
    
    previewContainer.style.display = 'block';
}

// Remove selected file from AI bot
window.removeAIBotFile = function() {
    aiBotSelectedFile = null;
    document.getElementById('aiBotFileInput').value = '';
    document.getElementById('aiBotFilePreview').style.display = 'none';
}

// Upload file to server
window.uploadChatFile = async function(file) {
    console.log('[Upload] Starting upload for file:', file.name, 'Type:', file.type, 'Size:', file.size);
    
    const formData = new FormData();
    const paramName = file.type.startsWith('image/') ? 'image' : 'file';
    formData.append(paramName, file);
    
    console.log('[Upload] FormData created with param:', paramName);
    console.log('[Upload] Upload URL:', widgetContextPath + '/chat/upload-file');
    
    try {
        const response = await fetch(widgetContextPath + '/chat/upload-file', {
            method: 'POST',
            body: formData
        });
        
        console.log('[Upload] Response status:', response.status);
        console.log('[Upload] Response ok:', response.ok);
        
        if (!response.ok) {
            const errorText = await response.text();
            console.error('[Upload] Error response:', errorText);
            throw new Error('Upload failed: ' + response.status);
        }
        
        const data = await response.json();
        console.log('[Upload] Success response:', data);
        
        return {
            url: data.fileUrl || data.imageUrl,
            type: data.fileType,
            name: data.fileName
        };
    } catch (error) {
        console.error('[Upload] Exception:', error);
        alert('Không thể tải file lên. Vui lòng thử lại!\n' + error.message);
        return null;
    }
}
