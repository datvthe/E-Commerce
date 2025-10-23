/**
 * Real-time Chat System with WebSocket and AI Support
 */

let chatWebSocket = null;
let currentRoomId = null;
let currentUserId = null;
let currentUserRole = null;
let contextPath = '';
let typingTimeout = null;

/**
 * Initialize chat system
 */
function initializeChat(userId, userRole, context) {
    currentUserId = userId;
    currentUserRole = userRole;
    contextPath = context;
    
    loadChatRooms();
    setupEventListeners();
}

/**
 * Load all chat rooms for current user
 */
function loadChatRooms() {
    fetch(contextPath + '/chat/')
        .then(response => response.json())
        .then(rooms => {
            const chatList = document.getElementById('chatList');
            chatList.innerHTML = '';
            
            if (rooms.length === 0) {
                chatList.innerHTML = '<div class="no-chats">Chưa có cuộc trò chuyện nào</div>';
                return;
            }
            
            rooms.forEach(room => {
                const roomElement = createChatRoomElement(room);
                chatList.appendChild(roomElement);
            });
        })
        .catch(error => console.error('Error loading chat rooms:', error));
}

/**
 * Create chat room list item
 */
function createChatRoomElement(room) {
    const div = document.createElement('div');
    div.className = 'chat-item';
    div.dataset.roomId = room.roomId;
    div.onclick = () => openChatRoom(room.roomId);
    
    div.innerHTML = `
        <img src="${room.avatar || contextPath + '/assets/images/default-avatar.png'}" alt="Avatar" class="chat-item-avatar">
        <div class="chat-item-content">
            <div class="chat-item-header">
                <h4 class="chat-item-name">${room.roomName || 'Chat Room'}</h4>
                <span class="chat-item-time">${formatTime(room.lastMessageAt)}</span>
            </div>
            <p class="chat-item-message">${room.lastMessage || 'Chưa có tin nhắn'}</p>
        </div>
        ${room.unreadCount > 0 ? '<span class="badge">' + room.unreadCount + '</span>' : ''}
    `;
    
    return div;
}

/**
 * Open chat room and establish WebSocket connection
 */
function openChatRoom(roomId) {
    currentRoomId = roomId;
    
    // Close existing WebSocket if any
    if (chatWebSocket) {
        chatWebSocket.close();
    }
    
    // Show chat area
    document.getElementById('noChatSelected').style.display = 'none';
    document.getElementById('chatArea').style.display = 'flex';
    
    // Load room details
    fetch(contextPath + '/chat/room/' + roomId)
        .then(response => response.json())
        .then(data => {
            updateChatHeader(data);
            loadChatMessages(roomId);
        })
        .catch(error => console.error('Error loading room details:', error));
    
    // Establish WebSocket connection
    const wsProtocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
    const wsUrl = `${wsProtocol}//${window.location.host}${contextPath}/chat/${roomId}/${currentUserId}`;
    
    chatWebSocket = new WebSocket(wsUrl);
    
    chatWebSocket.onopen = function(event) {
        console.log('WebSocket connected to room:', roomId);
    };
    
    chatWebSocket.onmessage = function(event) {
        const message = JSON.parse(event.data);
        handleWebSocketMessage(message);
    };
    
    chatWebSocket.onerror = function(error) {
        console.error('WebSocket error:', error);
    };
    
    chatWebSocket.onclose = function(event) {
        console.log('WebSocket closed:', event.code, event.reason);
    };
    
    // Mark messages as read
    markMessagesAsRead(roomId);
}

/**
 * Load chat messages
 */
function loadChatMessages(roomId) {
    fetch(contextPath + '/chat/messages/' + roomId)
        .then(response => response.json())
        .then(messages => {
            const chatMessages = document.getElementById('chatMessages');
            chatMessages.innerHTML = '';
            
            messages.reverse().forEach(message => {
                appendMessage(message);
            });
            
            scrollToBottom();
        })
        .catch(error => console.error('Error loading messages:', error));
}

/**
 * Handle incoming WebSocket messages
 */
function handleWebSocketMessage(message) {
    switch (message.type) {
        case 'connected':
            console.log('Connected to chat room:', message.roomId);
            break;
            
        case 'new_message':
            appendMessage(message);
            scrollToBottom();
            
            // Play notification sound if not sender
            if (message.senderId !== currentUserId) {
                playNotificationSound();
            }
            break;
            
        case 'typing':
            if (message.userId !== currentUserId) {
                showTypingIndicator(message.isTyping);
            }
            break;
            
        case 'read':
            updateReadStatus(message.userId);
            break;
    }
}

/**
 * Append message to chat
 */
function appendMessage(message) {
    const chatMessages = document.getElementById('chatMessages');
    const messageDiv = document.createElement('div');
    
    const isOwn = message.senderId === currentUserId;
    const isAI = message.isAiResponse || message.senderRole === 'ai';
    
    messageDiv.className = `message ${isOwn ? 'message-own' : 'message-other'} ${isAI ? 'message-ai' : ''}`;
    
    messageDiv.innerHTML = `
        ${!isOwn ? `<img src="${message.senderAvatar || contextPath + '/assets/images/default-avatar.png'}" alt="Avatar" class="message-avatar">` : ''}
        <div class="message-content">
            ${!isOwn ? `<div class="message-sender">${message.senderName}${isAI ? ' (AI)' : ''}</div>` : ''}
            <div class="message-bubble">
                ${escapeHtml(message.content)}
                ${message.isEdited ? '<span class="message-edited">(đã chỉnh sửa)</span>' : ''}
            </div>
            <div class="message-time">${formatMessageTime(message.createdAt)}</div>
        </div>
    `;
    
    chatMessages.appendChild(messageDiv);
}

/**
 * Send message via WebSocket
 */
function sendMessage() {
    const messageInput = document.getElementById('messageInput');
    const content = messageInput.value.trim();
    
    if (!content || !chatWebSocket || chatWebSocket.readyState !== WebSocket.OPEN) {
        return;
    }
    
    const message = {
        type: 'message',
        content: content,
        messageType: 'text',
        senderRole: currentUserRole
    };
    
    chatWebSocket.send(JSON.stringify(message));
    messageInput.value = '';
    adjustTextareaHeight(messageInput);
}

/**
 * Send typing indicator
 */
function sendTypingIndicator(isTyping) {
    if (!chatWebSocket || chatWebSocket.readyState !== WebSocket.OPEN) {
        return;
    }
    
    const message = {
        type: 'typing',
        isTyping: isTyping
    };
    
    chatWebSocket.send(JSON.stringify(message));
}

/**
 * Show typing indicator
 */
function showTypingIndicator(isTyping) {
    const indicator = document.getElementById('typingIndicator');
    indicator.style.display = isTyping ? 'flex' : 'none';
    
    if (isTyping) {
        scrollToBottom();
    }
}

/**
 * Mark messages as read
 */
function markMessagesAsRead(roomId) {
    if (!chatWebSocket || chatWebSocket.readyState !== WebSocket.OPEN) {
        return;
    }
    
    const message = {
        type: 'read'
    };
    
    chatWebSocket.send(JSON.stringify(message));
}

/**
 * Setup event listeners
 */
function setupEventListeners() {
    const messageInput = document.getElementById('messageInput');
    
    messageInput.addEventListener('keypress', function(e) {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            sendMessage();
        }
    });
    
    messageInput.addEventListener('input', function() {
        adjustTextareaHeight(this);
        
        // Send typing indicator
        clearTimeout(typingTimeout);
        sendTypingIndicator(true);
        
        typingTimeout = setTimeout(() => {
            sendTypingIndicator(false);
        }, 1000);
    });
    
    // Search functionality
    document.getElementById('searchInput').addEventListener('input', function(e) {
        filterChatRooms(e.target.value);
    });
}

/**
 * Filter chat rooms by search query
 */
function filterChatRooms(query) {
    const chatItems = document.querySelectorAll('.chat-item');
    const lowerQuery = query.toLowerCase();
    
    chatItems.forEach(item => {
        const name = item.querySelector('.chat-item-name').textContent.toLowerCase();
        const message = item.querySelector('.chat-item-message').textContent.toLowerCase();
        
        if (name.includes(lowerQuery) || message.includes(lowerQuery)) {
            item.style.display = 'flex';
        } else {
            item.style.display = 'none';
        }
    });
}

/**
 * Close current chat
 */
function closeChat() {
    if (chatWebSocket) {
        chatWebSocket.close();
        chatWebSocket = null;
    }
    
    currentRoomId = null;
    document.getElementById('chatArea').style.display = 'none';
    document.getElementById('noChatSelected').style.display = 'flex';
}

/**
 * Update chat header with room info
 */
function updateChatHeader(data) {
    const room = data.room;
    const participants = data.participants;
    
    // Find other participant
    const otherParticipant = participants.find(p => p.userId !== currentUserId);
    
    if (otherParticipant) {
        document.getElementById('chatAvatar').src = otherParticipant.userAvatar || contextPath + '/assets/images/default-avatar.png';
        document.getElementById('chatName').textContent = otherParticipant.userName;
        document.getElementById('chatStatus').textContent = 'Online'; // Can be enhanced with real status
    }
}

/**
 * Utility functions
 */
function scrollToBottom() {
    const chatMessages = document.getElementById('chatMessages');
    chatMessages.scrollTop = chatMessages.scrollHeight;
}

function adjustTextareaHeight(textarea) {
    textarea.style.height = 'auto';
    textarea.style.height = Math.min(textarea.scrollHeight, 120) + 'px';
}

function formatTime(timestamp) {
    if (!timestamp) return '';
    const date = new Date(timestamp);
    const now = new Date();
    const diff = now - date;
    
    if (diff < 60000) return 'Vừa xong';
    if (diff < 3600000) return Math.floor(diff / 60000) + ' phút trước';
    if (diff < 86400000) return Math.floor(diff / 3600000) + ' giờ trước';
    
    return date.toLocaleDateString('vi-VN');
}

function formatMessageTime(timestamp) {
    if (!timestamp) return '';
    const date = new Date(timestamp);
    return date.toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' });
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML.replace(/\n/g, '<br>');
}

function playNotificationSound() {
    // Implement notification sound if needed
}

function updateReadStatus(userId) {
    // Update UI to show messages as read
}

// Modal functions
function showNewChatModal() {
    document.getElementById('newChatModal').style.display = 'flex';
}

function closeNewChatModal() {
    document.getElementById('newChatModal').style.display = 'none';
}

function createNewChat() {
    // Implement new chat creation
    alert('Feature coming soon!');
}
