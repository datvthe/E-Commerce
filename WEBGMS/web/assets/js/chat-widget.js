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
    if (!messageContent) {
        console.error('[Widget] Message has no content:', message);
        return;
    }
    
    console.log('[Widget] Appending message:', {
        senderId: message.senderId,
        content: messageContent.substring(0, 30),
        isOwn: message.senderId === widgetUserId
    });
    
    const messageDiv = document.createElement('div');
    
    const isOwn = message.senderId === widgetUserId;
    const isAI = message.isAiResponse || message.senderRole === 'ai';
    
    messageDiv.className = `widget-message ${isOwn ? 'widget-message-own' : 'widget-message-other'} ${isAI ? 'widget-message-ai' : ''}`;
    
    messageDiv.innerHTML = `
        ${!isOwn ? `<img src="${message.senderAvatar || widgetContextPath + '/assets/images/default-avatar.png'}" 
                         alt="Avatar" class="widget-message-avatar">` : ''}
        <div class="widget-message-content">
            <div class="widget-message-bubble">
                ${escapeWidgetHtml(messageContent)}
            </div>
            <div class="widget-message-time">${formatWidgetMessageTime(message.createdAt)}</div>
        </div>
    `;
    
    container.appendChild(messageDiv);
}

/**
 * Send message from widget
 */
function widgetSendMessage() {
    const input = document.getElementById('widgetMessageInput');
    const content = input.value.trim();
    
    if (!content) {
        console.log('[Widget] Empty message, not sending');
        return;
    }
    
    if (!widgetWebSocket || widgetWebSocket.readyState !== WebSocket.OPEN) {
        console.error('[Widget] WebSocket not connected');
        alert('Không thể gửi tin nhắn. Vui lòng thử lại.');
        return;
    }
    
    console.log('[Widget] Sending message:', content);
    
    const message = {
        type: 'message',
        content: content,
        messageType: 'text',
        senderRole: widgetUserRole
    };
    
    // Send via WebSocket
    widgetWebSocket.send(JSON.stringify(message));
    
    // Optimistically display user's own message immediately
    const userMessage = {
        senderId: widgetUserId,
        messageContent: content,
        content: content,
        senderRole: widgetUserRole,
        messageType: 'text',
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
