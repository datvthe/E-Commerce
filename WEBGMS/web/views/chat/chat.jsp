<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat - WEBGMS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/chat.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="chat-container">
        <!-- Chat Sidebar -->
        <div class="chat-sidebar">
            <div class="chat-sidebar-header">
                <h3><i class="fas fa-comments"></i> Tin nhắn</h3>
                <button class="btn-new-chat" onclick="showNewChatModal()">
                    <i class="fas fa-plus"></i>
                </button>
            </div>
            
            <div class="chat-search">
                <input type="text" id="searchInput" placeholder="Tìm kiếm cuộc trò chuyện...">
                <i class="fas fa-search"></i>
            </div>
            
            <div class="chat-list" id="chatList">
                <!-- Chat rooms will be loaded here -->
            </div>
        </div>
        
        <!-- Chat Main Area -->
        <div class="chat-main">
            <div class="no-chat-selected" id="noChatSelected">
                <i class="fas fa-comments"></i>
                <h3>Chọn cuộc trò chuyện</h3>
                <p>Chọn một cuộc trò chuyện từ danh sách bên trái để bắt đầu.</p>
            </div>
            
            <div class="chat-area" id="chatArea" style="display: none;">
                <!-- Chat Header -->
                <div class="chat-header">
                    <div class="chat-header-info">
                        <img id="chatAvatar" src="" alt="Avatar" class="chat-avatar">
                        <div class="chat-header-text">
                            <h4 id="chatName">Loading...</h4>
                            <span id="chatStatus" class="chat-status">Online</span>
                        </div>
                    </div>
                    <div class="chat-header-actions">
                        <button class="btn-icon" title="Thông tin">
                            <i class="fas fa-info-circle"></i>
                        </button>
                        <button class="btn-icon" title="Đóng" onclick="closeChat()">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                </div>
                
                <!-- Chat Messages -->
                <div class="chat-messages" id="chatMessages">
                    <!-- Messages will be loaded here -->
                </div>
                
                <!-- Typing Indicator -->
                <div class="typing-indicator" id="typingIndicator" style="display: none;">
                    <span></span>
                    <span></span>
                    <span></span>
                    <p>đang nhập...</p>
                </div>
                
                <!-- Chat Input -->
                <div class="chat-input">
                    <button class="btn-icon" title="Đính kèm">
                        <i class="fas fa-paperclip"></i>
                    </button>
                    <textarea id="messageInput" placeholder="Nhập tin nhắn..." rows="1"></textarea>
                    <button class="btn-send" id="sendBtn" onclick="sendMessage()">
                        <i class="fas fa-paper-plane"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- New Chat Modal -->
    <div class="modal" id="newChatModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Cuộc trò chuyện mới</h3>
                <button class="btn-close" onclick="closeNewChatModal()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label>Người nhận:</label>
                    <input type="text" id="recipientSearch" placeholder="Tìm kiếm người dùng...">
                </div>
                <div class="form-group">
                    <label>Loại cuộc trò chuyện:</label>
                    <select id="chatType">
                        <option value="customer_seller">Khách hàng - Người bán</option>
                        <option value="customer_admin">Khách hàng - Admin</option>
                        <option value="seller_admin">Người bán - Admin</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="closeNewChatModal()">Hủy</button>
                <button class="btn btn-primary" onclick="createNewChat()">Tạo</button>
            </div>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/assets/js/chat.js"></script>
    <script>
        // Initialize chat
        const userId = ${sessionScope.user.user_id};
        const userRole = '${sessionScope.user.default_role}';
        const contextPath = '${pageContext.request.contextPath}';
        
        document.addEventListener('DOMContentLoaded', function() {
            initializeChat(userId, userRole, contextPath);
        });
    </script>
</body>
</html>
