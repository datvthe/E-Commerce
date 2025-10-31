// AI Bot Chat Widget JavaScript
let aiBotRoomId = null;
let aiBotInitialized = false;

// Get context path - use the one from chat-widget.js (set by footer.jsp)
function getContextPath() {
    // Use widgetContextPath from chat-widget.js (initialized by initChatWidget)
    if (typeof widgetContextPath !== 'undefined' && widgetContextPath) {
        return widgetContextPath;
    }
    // Fallback to WEBGMS
    console.warn('[AI Bot] widgetContextPath not found, using fallback /WEBGMS');
    return '/WEBGMS';
}

// Initialize AI Bot when widget opens
function initializeAIBot() {
    if (aiBotInitialized) {
        console.log('[AI Bot] Already initialized');
        return;
    }
    
    const contextPath = getContextPath();
    console.log('[AI Bot] Initializing with context path:', contextPath);
    console.log('[AI Bot] Full URL will be:', contextPath + '/aibot/init');
    
    // Check if user is logged in
    const container = document.getElementById('aiBotMessages');
    if (!container) {
        console.error('[AI Bot] Container "aiBotMessages" not found! User may not be logged in.');
        return;
    }
    
    // Show initializing message
    container.innerHTML = `
        <div class="chat-widget-loading">
            <i class="fas fa-robot fa-spin"></i>
            <p>Đang khởi tạo AI Trợ Lý...</p>
        </div>
    `;
    
    fetch(contextPath + '/aibot/init')
        .then(response => {
            console.log('AI Bot init response status:', response.status);
            if (!response.ok) {
                throw new Error(`HTTP ${response.status}: ${response.statusText}`);
            }
            return response.json();
        })
        .then(data => {
            console.log('AI Bot init data:', data);
            if (data.success) {
                aiBotRoomId = data.roomId;
                aiBotInitialized = true;
                loadAIBotMessages();
                console.log('AI Bot initialized successfully with room ID:', aiBotRoomId);
            } else {
                console.error('AI Bot init failed:', data.error);
                container.innerHTML = `
                    <div class="chat-error-message" style="position: relative; margin: 20px;">
                        <i class="fas fa-exclamation-triangle"></i>
                        <p><strong>Không thể khởi tạo AI Trợ Lý</strong></p>
                        <p>${data.error || 'Lỗi không xác định'}</p>
                        <button onclick="aiBotInitialized=false; initializeAIBot();" style="margin-top: 10px; padding: 8px 16px; background: #ff6b6b; color: white; border: none; border-radius: 4px; cursor: pointer;">
                            <i class="fas fa-redo"></i> Thử lại
                        </button>
                    </div>
                `;
            }
        })
        .catch(error => {
            console.error('AI Bot init error:', error);
            container.innerHTML = `
                <div class="chat-error-message" style="position: relative; margin: 20px;">
                    <i class="fas fa-exclamation-triangle"></i>
                    <p><strong>Lỗi kết nối</strong></p>
                    <p>${error.message}</p>
                    <button onclick="aiBotInitialized=false; initializeAIBot();" style="margin-top: 10px; padding: 8px 16px; background: #ff6b6b; color: white; border: none; border-radius: 4px; cursor: pointer;">
                        <i class="fas fa-redo"></i> Thử lại
                    </button>
                </div>
            `;
        });
}

// Load AI Bot messages
function loadAIBotMessages() {
    if (!aiBotRoomId) return;
    
    const contextPath = getContextPath();
    fetch(`${contextPath}/aibot/messages/${aiBotRoomId}`)
        .then(response => response.json())
        .then(messages => {
            displayAIBotMessages(messages);
        })
        .catch(error => {
            console.error('Error loading messages:', error);
        });
}

// Display AI Bot messages
function displayAIBotMessages(messages) {
    const container = document.getElementById('aiBotMessages');
    container.innerHTML = '';
    
    messages.forEach(msg => {
        const messageEl = createMessageElement(msg);
        container.appendChild(messageEl);
    });
    
    // Scroll to bottom
    container.scrollTop = container.scrollHeight;
}

// Create message element
function createMessageElement(msg) {
    if (!msg) {
        console.error('[AI Bot] Cannot create message element: msg is null/undefined');
        return null;
    }
    
    if (!msg.messageContent) {
        console.error('[AI Bot] Cannot create message element: missing messageContent', msg);
        return null;
    }
    
    const div = document.createElement('div');
    const isAi = msg.senderRole === 'ai' || msg.isAiResponse === true;
    const isOwnMessage = !isAi; // User's own message
    div.className = `chat-message ${isAi ? 'chat-message-ai' : 'chat-message-user'}`;
    div.dataset.messageId = msg.messageId || msg.message_id || '';
    
    // Add own message class for right alignment
    if (isOwnMessage) {
        div.classList.add('widget-message-own');
        console.log('✅ AI CHAT - TIN NHAN CUA BAN');
    } else {
        div.classList.add('widget-message-other');
    }
    
    let time = 'now';
    if (msg.createdAt) {
        try {
            time = new Date(msg.createdAt).toLocaleTimeString('vi-VN', {
                hour: '2-digit',
                minute: '2-digit'
            });
        } catch (e) {
            console.warn('[AI Bot] Error formatting time:', e);
        }
    }
    
    // Format message content (convert markdown-like syntax to HTML)
    let formattedContent = String(msg.messageContent)
        .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')  // Bold
        .replace(/\n/g, '<br>');  // Line breaks
    
    // Check for attachment (image/file)
    let attachmentHtml = '';
    if (msg.attachmentUrl) {
        const isImage = /\.(jpg|jpeg|png|gif|webp)$/i.test(msg.attachmentUrl);
        if (isImage) {
            attachmentHtml = `
                <img src="${getContextPath()}${msg.attachmentUrl}" 
                     class="message-image" 
                     alt="Image" 
                     onclick="window.open('${getContextPath()}${msg.attachmentUrl}', '_blank')"
                     style="max-width: 150px; max-height: 150px; object-fit: cover;">
            `;
        } else {
            const fileName = msg.attachmentUrl.split('/').pop();
            attachmentHtml = `
                <a href="${getContextPath()}${msg.attachmentUrl}" 
                   target="_blank" 
                   class="widget-message-file">
                    <i class="fas fa-file"></i>
                    <span>${fileName}</span>
                    <i class="fas fa-download"></i>
                </a>
            `;
        }
    }
    
    // Action buttons (only for user's own messages, not AI)
    let actionsHtml = '';
    if (isOwnMessage && msg.messageId) {
        actionsHtml = `
            <div class="message-actions">
                <button class="btn-message-action btn-message-edit" 
                        onclick="event.stopPropagation(); editMessage('${msg.messageId}');" 
                        title="Sửa">
                    <i class="fas fa-edit"></i>
                </button>
                <button class="btn-message-action btn-message-delete" 
                        onclick="event.stopPropagation(); deleteMessage('${msg.messageId}');" 
                        title="Xóa">
                    <i class="fas fa-trash"></i>
                </button>
            </div>
        `;
    }
    
    div.innerHTML = `
        ${isAi ? '<i class="fas fa-robot message-icon"></i>' : ''}
        <div class="chat-message-content">
            <div class="chat-message-bubble" id="bubble-${msg.messageId}">
                <p id="text-${msg.messageId}">${formattedContent}</p>
                ${attachmentHtml}
            </div>
            <div class="widget-message-footer">
                <span class="chat-message-time">${time}</span>
                ${isOwnMessage ? actionsHtml : ''}
            </div>
        </div>
    `;
    
    return div;
}

// Send message to AI Bot
async function sendToAIBot() {
    const input = document.getElementById('aiBotMessageInput');
    const message = input.value.trim();
    
    // Check if there's a file to upload (from global variable set by chat-widget.js)
    const hasFile = typeof aiBotSelectedFile !== 'undefined' && aiBotSelectedFile !== null;
    
    console.log('[AI Bot] sendToAIBot called - Message:', message, 'Has file:', hasFile);
    
    // Must have either message or file
    if (!message && !hasFile) {
        console.log('[AI Bot] No message or file to send');
        return;
    }
    
    if (!aiBotRoomId) {
        console.error('[AI Bot] No room ID');
        alert('Chưa khởi tạo AI Bot!');
        return;
    }
    
    // Disable input
    input.disabled = true;
    
    // Show typing indicator
    document.getElementById('aiBotTypingIndicator').style.display = 'flex';
    
    let attachmentUrl = null;
    
    // Upload file first if exists
    if (hasFile) {
        console.log('[AI Bot] Uploading file first...', aiBotSelectedFile.name);
        try {
            const uploadResult = await window.uploadChatFile(aiBotSelectedFile);
            if (uploadResult && uploadResult.url) {
                attachmentUrl = uploadResult.url;
                console.log('[AI Bot] File uploaded successfully:', attachmentUrl);
                
                // Clear file preview
                document.getElementById('aiBotFilePreview').style.display = 'none';
                document.getElementById('aiBotFileInput').value = '';
                aiBotSelectedFile = null;
            } else {
                console.error('[AI Bot] File upload failed');
                alert('Không thể tải file lên. Vui lòng thử lại!');
                input.disabled = false;
                document.getElementById('aiBotTypingIndicator').style.display = 'none';
                return;
            }
        } catch (error) {
            console.error('[AI Bot] File upload error:', error);
            alert('Lỗi khi tải file: ' + error.message);
            input.disabled = false;
            document.getElementById('aiBotTypingIndicator').style.display = 'none';
            return;
        }
    }
    
    // Prepare message
    const messageToSend = message || '[Đã gửi file]';
    
    console.log('[AI Bot] Sending message with attachment:', attachmentUrl);
    
    const contextPath = getContextPath();
    fetch(contextPath + '/aibot/send', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            roomId: aiBotRoomId,
            message: messageToSend,
            attachmentUrl: attachmentUrl
        })
    })
    .then(response => {
        console.log('[AI Bot] Send response status:', response.status);
        return response.json();
    })
    .then(data => {
        console.log('[AI Bot] Send response data:', data);
        if (data.success) {
            // Clear input
            input.value = '';
            
            const container = document.getElementById('aiBotMessages');
            
            // Check if we have message data
            if (!data.userMessage || !data.aiResponse) {
                console.error('[AI Bot] Missing message data:', data);
                showError('Lỗi: Không nhận được phản hồi đầy đủ');
                return;
            }
            
            // Add user message immediately
            console.log('[AI Bot] User message:', data.userMessage);
            const userMsgEl = createMessageElement(data.userMessage);
            if (userMsgEl) {
                container.appendChild(userMsgEl);
                container.scrollTop = container.scrollHeight;
            }
            
            // Add AI response with delay
            setTimeout(() => {
                console.log('[AI Bot] AI response:', data.aiResponse);
                const aiMsgEl = createMessageElement(data.aiResponse);
                if (aiMsgEl) {
                    container.appendChild(aiMsgEl);
                    container.scrollTop = container.scrollHeight;
                }
                
                // Hide typing indicator
                document.getElementById('aiBotTypingIndicator').style.display = 'none';
            }, 500);
        } else {
            console.error('[AI Bot] Send failed:', data.error);
            showError('Không thể gửi tin nhắn: ' + (data.error || 'Lỗi không xác định'));
        }
    })
    .catch(error => {
        console.error('Error sending message:', error);
        showError('Lỗi kết nối');
    })
    .finally(() => {
        input.disabled = false;
        input.focus();
        document.getElementById('aiBotTypingIndicator').style.display = 'none';
    });
}

// Connect to Admin
function connectToAdmin() {
    // Check if AI Bot is initialized
    if (!aiBotInitialized || !aiBotRoomId) {
        alert('⏳ Vui lòng đợi AI Trợ Lý khởi tạo xong trước khi kết nối với Admin.');
        return;
    }
    
    if (!confirm('Bạn muốn kết nối với Admin để được tư vấn trực tiếp?')) {
        return;
    }
    
    // Disable button and show loading
    const btnElement = document.getElementById('connectAdminBtn');
    if (btnElement) {
        btnElement.style.opacity = '0.6';
        btnElement.style.pointerEvents = 'none';
        btnElement.innerHTML = '<i class="fas fa-spinner fa-spin"></i> <span>Đang kết nối...</span>';
    }
    
    const contextPath = getContextPath();
    fetch(contextPath + '/aibot/escalate', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            aiBotRoomId: aiBotRoomId
        })
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            alert('✅ Đã kết nối với Admin!\n\nBạn có thể xem cuộc trò chuyện trong danh sách chat.');
            showChatList();
        } else {
            showError('Không thể kết nối với Admin: ' + (data.error || 'Lỗi không xác định'));
            // Reset button
            if (btnElement) {
                btnElement.style.opacity = '1';
                btnElement.style.pointerEvents = 'auto';
                btnElement.innerHTML = '<i class="fas fa-user-shield"></i> <span>Kết nối với Admin</span>';
            }
        }
    })
    .catch(error => {
        console.error('Error escalating to admin:', error);
        showError('Lỗi kết nối: ' + error.message);
        // Reset button
        if (btnElement) {
            btnElement.style.opacity = '1';
            btnElement.style.pointerEvents = 'auto';
            btnElement.innerHTML = '<i class="fas fa-user-shield"></i> <span>Kết nối với Admin</span>';
        }
    });
}

// Show chat list view
function showChatList() {
    document.getElementById('chatWidgetAIBotView').style.display = 'none';
    document.getElementById('chatWidgetListView').style.display = 'flex';
    
    // Load chat list from chat-widget.js
    if (typeof loadWidgetChatRooms === 'function') {
        loadWidgetChatRooms();
    }
}

// Back to AI Bot view
function backToAIBot() {
    document.getElementById('chatWidgetListView').style.display = 'none';
    document.getElementById('chatWidgetAIBotView').style.display = 'flex';
}

// Show error message
function showError(message) {
    const container = document.getElementById('aiBotMessages');
    const errorDiv = document.createElement('div');
    errorDiv.className = 'chat-error-message';
    errorDiv.innerHTML = `<i class="fas fa-exclamation-circle"></i> ${message}`;
    container.appendChild(errorDiv);
    
    setTimeout(() => {
        errorDiv.remove();
    }, 3000);
}

// Handle Enter key in textarea
document.addEventListener('DOMContentLoaded', function() {
    const aiBotInput = document.getElementById('aiBotMessageInput');
    if (aiBotInput) {
        aiBotInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                sendToAIBot();
            }
        });
        
        // Auto-resize textarea
        aiBotInput.addEventListener('input', function() {
            this.style.height = 'auto';
            this.style.height = Math.min(this.scrollHeight, 100) + 'px';
        });
    }
});

// Initialize AI Bot when widget is opened
const originalToggleChatWidget = window.toggleChatWidget;
window.toggleChatWidget = function() {
    if (originalToggleChatWidget) {
        originalToggleChatWidget();
    }
    
    const container = document.getElementById('chatWidgetContainer');
    if (container && container.style.display !== 'none') {
        // Widget is being opened
        if (!aiBotInitialized) {
            setTimeout(() => {
                initializeAIBot();
            }, 300);
        }
    }
};
