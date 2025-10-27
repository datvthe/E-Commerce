<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Floating Chat Widget -->
<div id="chatWidget" class="chat-widget">
    <!-- Chat Widget Button -->
    <button class="chat-widget-btn" id="chatWidgetToggle" onclick="toggleChatWidget()">
        <i class="fas fa-comments"></i>
        <span class="chat-widget-badge" id="chatWidgetBadge" style="display: none;">0</span>
    </button>
    
    <!-- Chat Widget Container -->
    <div class="chat-widget-container" id="chatWidgetContainer" style="display: none;">
        <!-- Widget Header -->
        <div class="chat-widget-header">
            <div class="chat-widget-header-content">
                <img src="${pageContext.request.contextPath}/assets/images/chat-bot.png" 
                     onerror="this.src='https://via.placeholder.com/40x40/0084ff/ffffff?text=AI'"
                     alt="Chat" class="chat-widget-avatar">
                <div>
                    <h4 class="chat-widget-title">Trò chuyện</h4>
                    <p class="chat-widget-subtitle">Chúng tôi luôn sẵn sàng hỗ trợ</p>
                </div>
            </div>
                <div class="chat-widget-header-actions">
                <button class="btn-widget-action" onclick="showChatList()" title="Danh sách chat">
                    <i class="fas fa-list"></i>
                </button>
                <button class="btn-widget-action" onclick="toggleChatWidget()" title="Đóng">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </div>
        
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <!-- AI Bot View (Default) -->
                <div class="chat-widget-view" id="chatWidgetAIBotView">
                    <div class="chat-widget-messages" id="aiBotMessages">
                        <div class="chat-widget-loading">
                            <i class="fas fa-robot fa-spin"></i>
                            <p>Đang khởi tạo AI Trợ Lý...</p>
                        </div>
                    </div>
                    
                    <div class="chat-widget-typing" id="aiBotTypingIndicator" style="display: none;">
                        <span></span><span></span><span></span>
                        <p>AI đang nhập...</p>
                    </div>
                    
                    <!-- Admin Connect Button -->
                    <div class="chat-widget-admin-btn" id="connectAdminBtn" onclick="connectToAdmin()">
                        <i class="fas fa-user-shield"></i>
                        <span>Kết nối với Admin</span>
                    </div>
                    
                    <div class="chat-widget-input">
                        <input type="file" id="aiBotFileInput" accept="image/*,application/pdf,.doc,.docx,.xls,.xlsx,.zip,.rar" 
                               style="display: none;"
                               onchange="(async function(e){
                                   console.log('[AI Bot] File input changed!');
                                   var file = e.target.files[0];
                                   if (!file) return;
                                   console.log('[AI Bot] File:', file.name, file.type, file.size);
                                   
                                   var maxSize = file.type.startsWith('image/') ? 5*1024*1024 : 10*1024*1024;
                                   if (file.size > maxSize) {
                                       alert('File quá lớn! Tối đa ' + (maxSize/1024/1024) + 'MB');
                                       e.target.value = '';
                                       return;
                                   }
                                   
                                   // Show temporary preview
                                   var preview = document.getElementById('aiBotFilePreview');
                                   var img = document.getElementById('aiBotPreviewImg');
                                   var info = document.getElementById('aiBotFileInfo');
                                   var name = document.getElementById('aiBotFileName');
                                   
                                   if (file.type.startsWith('image/')) {
                                       var reader = new FileReader();
                                       reader.onload = function(evt) {
                                           img.src = evt.target.result;
                                           img.style.display = 'block';
                                           info.style.display = 'none';
                                       };
                                       reader.readAsDataURL(file);
                                   } else {
                                       name.textContent = file.name;
                                       info.style.display = 'block';
                                       img.style.display = 'none';
                                   }
                                   preview.style.display = 'block';
                                   
                                   // Auto-send file immediately
                                   console.log('[AI Bot] Auto-sending file...');
                                   aiBotSelectedFile = file;
                                   await sendToAIBot();
                                   
                                   // Clear file input
                                   e.target.value = '';
                               })(event)">
                        <button class="btn-widget-attach" title="Đính kèm file" onclick="console.log('[AI Bot] Attach button clicked'); document.getElementById('aiBotFileInput').click();">
                            <i class="fas fa-paperclip"></i>
                        </button>
                        <textarea id="aiBotMessageInput" 
                                  placeholder="Nhập tin nhắn..." 
                                  rows="1"></textarea>
                        <button class="btn-widget-send" onclick="sendToAIBot()">
                            <i class="fas fa-paper-plane"></i>
                        </button>
                    </div>
                    
                    <!-- File Preview -->
                    <div class="chat-widget-image-preview" id="aiBotFilePreview" style="display: none;">
                        <div class="image-preview-container">
                            <img id="aiBotPreviewImg" src="" alt="Preview" style="display: none;">
                            <div id="aiBotFileInfo" class="file-info-preview" style="display: none;">
                                <i class="fas fa-file"></i>
                                <span id="aiBotFileName"></span>
                            </div>
                            <button class="btn-remove-image" onclick="aiBotSelectedFile=null; document.getElementById('aiBotFileInput').value=''; document.getElementById('aiBotFilePreview').style.display='none';">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- Chat List View -->
                <div class="chat-widget-view" id="chatWidgetListView" style="display: none;">
                    <div class="chat-widget-back" onclick="backToAIBot()">
                        <i class="fas fa-robot"></i>
                        <span>AI Trợ Lý</span>
                    </div>
                    
                    <div class="chat-widget-search">
                        <input type="text" class="chat-widget-search-input" 
                               placeholder="Tìm kiếm..." id="widgetSearchInput">
                        <i class="fas fa-search"></i>
                    </div>
                    
                    <div class="chat-widget-list" id="widgetChatList">
                        <div class="chat-widget-loading">
                            <i class="fas fa-spinner fa-spin"></i>
                            <p>Đang tải...</p>
                        </div>
                    </div>
                </div>
                
                <!-- Chat Conversation View -->
                <div class="chat-widget-view" id="chatWidgetConversationView" style="display: none;">
                    <div class="chat-widget-back" onclick="backToList()">
                        <i class="fas fa-arrow-left"></i>
                        <span id="widgetChatTitle">Quay lại</span>
                    </div>
                    
                    <div class="chat-widget-messages" id="widgetMessages">
                        <!-- Messages will be loaded here -->
                    </div>
                    
                    <div class="chat-widget-typing" id="widgetTypingIndicator" style="display: none;">
                        <span></span><span></span><span></span>
                        <p>đang nhập...</p>
                    </div>
                    
                    <div class="chat-widget-input">
                        <input type="file" id="widgetFileInput" accept="image/*,application/pdf,.doc,.docx,.xls,.xlsx,.zip,.rar" 
                               style="display: none;"
                               onchange="(async function(e){
                                   console.log('[Widget] File input changed!');
                                   var file = e.target.files[0];
                                   if (!file) return;
                                   console.log('[Widget] File:', file.name, file.type, file.size);
                                   
                                   var maxSize = file.type.startsWith('image/') ? 5*1024*1024 : 10*1024*1024;
                                   if (file.size > maxSize) {
                                       alert('File quá lớn! Tối đa ' + (maxSize/1024/1024) + 'MB');
                                       e.target.value = '';
                                       return;
                                   }
                                   
                                   // Show temporary preview
                                   var preview = document.getElementById('widgetFilePreview');
                                   var img = document.getElementById('widgetPreviewImg');
                                   var info = document.getElementById('widgetFileInfo');
                                   var name = document.getElementById('widgetFileName');
                                   
                                   if (file.type.startsWith('image/')) {
                                       var reader = new FileReader();
                                       reader.onload = function(evt) {
                                           img.src = evt.target.result;
                                           img.style.display = 'block';
                                           info.style.display = 'none';
                                       };
                                       reader.readAsDataURL(file);
                                   } else {
                                       name.textContent = file.name;
                                       info.style.display = 'block';
                                       img.style.display = 'none';
                                   }
                                   preview.style.display = 'block';
                                   
                                   // Auto-send file immediately
                                   console.log('[Widget] Auto-sending file...');
                                   widgetSelectedFile = file;
                                   await widgetSendMessage();
                                   
                                   // Clear file input
                                   e.target.value = '';
                               })(event)">
                        <button class="btn-widget-attach" title="Đính kèm file" onclick="console.log('[Widget] Attach button clicked'); document.getElementById('widgetFileInput').click();">
                            <i class="fas fa-paperclip"></i>
                        </button>
                        <textarea id="widgetMessageInput" 
                                  placeholder="Nhập tin nhắn..." 
                                  rows="1"></textarea>
                        <button class="btn-widget-send" onclick="widgetSendMessage()">
                            <i class="fas fa-paper-plane"></i>
                        </button>
                    </div>
                    
                    <!-- File Preview -->
                    <div class="chat-widget-image-preview" id="widgetFilePreview" style="display: none;">
                        <div class="image-preview-container">
                            <img id="widgetPreviewImg" src="" alt="Preview" style="display: none;">
                            <div id="widgetFileInfo" class="file-info-preview" style="display: none;">
                                <i class="fas fa-file"></i>
                                <span id="widgetFileName"></span>
                            </div>
                            <button class="btn-remove-image" onclick="widgetSelectedFile=null; document.getElementById('widgetFileInput').value=''; document.getElementById('widgetFilePreview').style.display='none';">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Guest View - Login Prompt -->
                <div class="chat-widget-guest">
                    <div class="chat-widget-guest-icon">
                        <i class="fas fa-user-lock"></i>
                    </div>
                    <h4>Đăng nhập để chat</h4>
                    <p>Vui lòng đăng nhập để sử dụng tính năng chat</p>
                    <a href="${pageContext.request.contextPath}/login?force=1" class="btn-widget-login">
                        <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập ngay
                    </a>
                    <p class="chat-widget-guest-help">
                        <i class="fas fa-question-circle me-1"></i>
                        Hoặc liên hệ: <a href="tel:+0123456789">(+012) 1234 567890</a>
                    </p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
