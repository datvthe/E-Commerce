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
    div.onclick = (e) => {
        // Don't open chat if clicking avatar
        if (!e.target.classList.contains('chat-item-avatar')) {
            openChatRoom(room.roomId);
        }
    };
    
    div.innerHTML = `
        <img src="${room.avatar || contextPath + '/assets/images/default-avatar.png'}" 
             alt="Avatar" 
             class="chat-item-avatar" 
             onclick="event.stopPropagation(); navigateToProfile('${room.otherUserId || room.userId}')">
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
            console.log('[Chat] Received ' + messages.length + ' messages from server');
            
            // Sort messages by creation time to ensure proper order (oldest first)
            // Since timestamps are corrupted, we'll use a more aggressive approach
            messages.sort((a, b) => {
                // Always use message_id as primary sort since timestamps are corrupted
                const idA = parseInt(a.messageId) || 0;
                const idB = parseInt(b.messageId) || 0;
                
                console.log('[Chat] Sorting by message_id - A:', idA, 'B:', idB);
                return idA - idB; // Ascending order (oldest first)
            });
            
            messages.forEach((msg, index) => {
                const parsedTime = new Date(msg.createdAt);
                console.log('[Chat] Message #' + (index + 1) + ' - ID: ' + msg.messageId + ', Raw Time: ' + msg.createdAt + ', Parsed Time: ' + parsedTime.toISOString() + ', Content: ' + (msg.content || msg.messageContent));
            });
            
            // Debug: Log the final order
            console.log('[Chat] Final message order:');
            messages.forEach((msg, index) => {
                console.log(`  ${index + 1}. ID: ${msg.messageId}, Content: "${msg.content || msg.messageContent}"`);
            });
            
            const chatMessages = document.getElementById('chatMessages');
            chatMessages.innerHTML = '';
            
            messages.forEach(message => {
                appendMessage(message);
            });
            
            // Scroll to bottom immediately to show newest messages
            setTimeout(() => {
                chatMessages.scrollTop = chatMessages.scrollHeight;
                console.log('[Chat] Scrolled to bottom - scrollTop: ' + chatMessages.scrollTop + ', scrollHeight: ' + chatMessages.scrollHeight);
                
                // Force scroll to bottom again after a short delay to ensure it works
                setTimeout(() => {
                    chatMessages.scrollTop = chatMessages.scrollHeight;
                    console.log('[Chat] Force scrolled to bottom - scrollTop: ' + chatMessages.scrollTop + ', scrollHeight: ' + chatMessages.scrollHeight);
                }, 100);
            }, 50);
        })
        .catch(error => console.error('Error loading messages:', error));
}

/**
 * Handle incoming WebSocket messages
 */
function handleWebSocketMessage(message) {
    console.log('[Chat] Received WebSocket message:', message.type, message);
    
    switch (message.type) {
        case 'connected':
            console.log('Connected to chat room:', message.roomId);
            break;
            
        case 'new_message':
            console.log('[Chat] Appending message from sender:', message.senderId, 'Current user:', currentUserId);
            appendMessage(message);
            scrollToBottom();
            
            // Play notification sound if not sender (use parseInt for comparison)
            if (parseInt(message.senderId) !== parseInt(currentUserId)) {
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
    
    // Convert both to numbers for comparison (handle string/number mismatch)
    const isOwn = parseInt(message.senderId) === parseInt(currentUserId);
    const isAI = message.isAiResponse || message.senderRole === 'ai';
    
    console.log('[Chat] Rendering message - senderId:', message.senderId, 'currentUserId:', currentUserId, 'isOwn:', isOwn);
    
    messageDiv.className = `message ${isOwn ? 'message-own' : 'message-other'} ${isAI ? 'message-ai' : ''}`;
    
    // Handle both 'content' and 'messageContent' field names
    const messageText = message.content || message.messageContent || '';
    
    messageDiv.innerHTML = `
        ${!isOwn ? `<img src="${message.senderAvatar || contextPath + '/assets/images/default-avatar.png'}" 
                         alt="Avatar" 
                         class="message-avatar" 
                         style="cursor: pointer;" 
                         onclick="navigateToProfile('${message.senderId}')">` : ''}
        <div class="message-content">
            ${!isOwn ? `<div class="message-sender">${message.senderName || 'User'}${isAI ? ' (AI)' : ''}</div>` : ''}
            <div class="message-bubble">
                ${escapeHtml(messageText)}
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
    
    // Use default role if not set
    const senderRole = currentUserRole && currentUserRole.trim() !== '' ? currentUserRole : 'customer';
    
    const message = {
        type: 'message',
        content: content,
        messageType: 'text',
        senderRole: senderRole
    };
    
    console.log('[Chat] Sending message:', content, 'with role:', senderRole);
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
        const avatarElement = document.getElementById('chatAvatar');
        avatarElement.src = otherParticipant.userAvatar || contextPath + '/assets/images/default-avatar.png';
        avatarElement.style.cursor = 'pointer';
        avatarElement.onclick = () => navigateToProfile(otherParticipant.userId);
        
        document.getElementById('chatName').textContent = otherParticipant.userName;
        document.getElementById('chatStatus').textContent = 'Online'; // Can be enhanced with real status
    }
}

/**
 * Utility functions
 */
function scrollToBottom(smooth = true) {
    const chatMessages = document.getElementById('chatMessages');
    if (chatMessages) {
        if (smooth) {
            // Use smooth scroll for better UX when sending messages
            chatMessages.scrollTo({
                top: chatMessages.scrollHeight,
                behavior: 'smooth'
            });
        } else {
            // Instant scroll for initial load - use multiple methods to ensure it works
            chatMessages.scrollTop = chatMessages.scrollHeight;
            
            // Force scroll with a small delay to handle dynamic content
            setTimeout(() => {
                chatMessages.scrollTop = chatMessages.scrollHeight;
            }, 10);
        }
    }
}

function adjustTextareaHeight(textarea) {
    textarea.style.height = 'auto';
    textarea.style.height = Math.min(textarea.scrollHeight, 120) + 'px';
}

function formatTime(timestamp) {
    if (!timestamp) return '';
    
    // Parse timestamp properly
    const date = new Date(timestamp);
    if (isNaN(date.getTime())) return '';
    
    const now = new Date();
    const diff = now - date;
    
    // Just now (less than 1 minute)
    if (diff < 60000 && diff >= 0) return 'Vừa xong';
    
    // Minutes ago (less than 1 hour)
    if (diff < 3600000 && diff >= 0) {
        const minutes = Math.floor(diff / 60000);
        return minutes + ' phút trước';
    }
    
    // Hours ago (less than 24 hours)
    if (diff < 86400000 && diff >= 0) {
        const hours = Math.floor(diff / 3600000);
        return hours + ' giờ trước';
    }
    
    // Days ago (less than 7 days)
    if (diff < 604800000 && diff >= 0) {
        const days = Math.floor(diff / 86400000);
        return days + ' ngày trước';
    }
    
    // Show full date for older messages
    return date.toLocaleDateString('vi-VN', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric'
    });
}

function formatMessageTime(timestamp) {
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
        console.warn('[Chat] Invalid timestamp:', timestamp);
        return '';
    }
    
    // Debug: Log the parsed date
    console.log('[Chat] Parsed timestamp:', timestamp, '->', date.toISOString());
    
    const now = new Date();
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const messageDate = new Date(date.getFullYear(), date.getMonth(), date.getDate());
    const diffDays = Math.floor((today - messageDate) / 86400000);
    
    // Today: show time only
    if (diffDays === 0) {
        return date.toLocaleTimeString('vi-VN', { 
            hour: '2-digit', 
            minute: '2-digit',
            hour12: false
        });
    }
    
    // Yesterday
    if (diffDays === 1) {
        return 'Hôm qua ' + date.toLocaleTimeString('vi-VN', { 
            hour: '2-digit', 
            minute: '2-digit',
            hour12: false
        });
    }
    
    // This week (within 7 days)
    if (diffDays < 7) {
        const weekdays = ['Chủ nhật', 'Thứ hai', 'Thứ ba', 'Thứ tư', 'Thứ năm', 'Thứ sáu', 'Thứ bảy'];
        return weekdays[date.getDay()] + ' ' + date.toLocaleTimeString('vi-VN', { 
            hour: '2-digit', 
            minute: '2-digit',
            hour12: false
        });
    }
    
    // Older: show date and time
    return date.toLocaleDateString('vi-VN', {
        day: '2-digit',
        month: '2-digit'
    }) + ' ' + date.toLocaleTimeString('vi-VN', { 
        hour: '2-digit', 
        minute: '2-digit',
        hour12: false
    });
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

/**
 * Navigate to user profile
 */
function navigateToProfile(userId) {
    if (!userId) {
        console.error('User ID is required to navigate to profile');
        return;
    }
    window.location.href = contextPath + '/profile?id=' + userId;
}
