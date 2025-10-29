/**
 * Message Edit/Delete Actions for Chat Widget
 */

// Edit message
window.editMessage = function(messageId) {
    console.log('[Message Actions] Edit message:', messageId);
    
    const textElement = document.getElementById(`text-${messageId}`);
    const bubbleElement = document.getElementById(`bubble-${messageId}`);
    
    if (!textElement || !bubbleElement) {
        console.error('[Message Actions] Message elements not found');
        return;
    }
    
    // Get current text (strip HTML)
    const currentText = textElement.innerText;
    
    // Replace with edit form
    const originalHTML = textElement.innerHTML;
    textElement.innerHTML = `
        <div class="message-edit-form">
            <input type="text" 
                   class="message-edit-input" 
                   id="edit-input-${messageId}" 
                   value="${currentText.replace(/"/g, '&quot;')}"
                   onkeypress="if(event.key==='Enter') saveMessageEdit('${messageId}', '${originalHTML.replace(/'/g, "\\'")}')">
            <button class="btn-save-edit" onclick="saveMessageEdit('${messageId}', '${originalHTML.replace(/'/g, "\\'")}')">
                <i class="fas fa-check"></i>
            </button>
            <button class="btn-cancel-edit" onclick="cancelMessageEdit('${messageId}', '${originalHTML.replace(/'/g, "\\'")}')">
                <i class="fas fa-times"></i>
            </button>
        </div>
    `;
    
    // Focus input
    document.getElementById(`edit-input-${messageId}`).focus();
};

// Save edited message
window.saveMessageEdit = function(messageId, originalHTML) {
    console.log('[Message Actions] Save edit for message:', messageId);
    
    const inputElement = document.getElementById(`edit-input-${messageId}`);
    const textElement = document.getElementById(`text-${messageId}`);
    
    if (!inputElement || !textElement) {
        console.error('[Message Actions] Elements not found');
        return;
    }
    
    const newText = inputElement.value.trim();
    
    if (!newText) {
        alert('Tin nhắn không được để trống!');
        return;
    }
    
    // Show loading
    textElement.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang cập nhật...';
    
    // Get context path (from aibot-widget.js or chat-widget.js)
    const contextPath = typeof getContextPath === 'function' ? getContextPath() : 
                       (typeof widgetContextPath !== 'undefined' ? widgetContextPath : '/WEBGMS');
    
    // Send update request
    fetch(`${contextPath}/chat/edit-message`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            messageId: messageId,
            newContent: newText
        })
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Update with new text
            textElement.innerHTML = `${newText} <span style="font-size: 0.8em; opacity: 0.7;">(đã chỉnh sửa)</span>`;
            console.log('[Message Actions] Message updated successfully');
        } else {
            console.error('[Message Actions] Update failed:', data.error);
            alert('Không thể cập nhật tin nhắn: ' + (data.error || 'Lỗi không xác định'));
            textElement.innerHTML = originalHTML;
        }
    })
    .catch(error => {
        console.error('[Message Actions] Update error:', error);
        alert('Lỗi khi cập nhật tin nhắn!');
        textElement.innerHTML = originalHTML;
    });
};

// Cancel edit
window.cancelMessageEdit = function(messageId, originalHTML) {
    console.log('[Message Actions] Cancel edit for message:', messageId);
    
    const textElement = document.getElementById(`text-${messageId}`);
    if (textElement) {
        textElement.innerHTML = originalHTML;
    }
};

// Delete message
window.deleteMessage = function(messageId) {
    console.log('[Message Actions] Delete message:', messageId);
    
    if (!confirm('Bạn có chắc chắn muốn xóa tin nhắn này?')) {
        return;
    }
    
    const messageElement = document.querySelector(`[data-message-id="${messageId}"]`);
    if (!messageElement) {
        console.error('[Message Actions] Message element not found');
        return;
    }
    
    // Show deleting animation
    messageElement.style.opacity = '0.5';
    
    // Get context path
    const contextPath = typeof getContextPath === 'function' ? getContextPath() : 
                       (typeof widgetContextPath !== 'undefined' ? widgetContextPath : '/WEBGMS');
    
    // Send delete request
    fetch(`${contextPath}/chat/delete-message`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            messageId: messageId
        })
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Replace message content with "Deleted" notice (Facebook style)
            const textElement = document.getElementById(`text-${messageId}`);
            const bubbleElement = document.getElementById(`bubble-${messageId}`);
            
            if (textElement && bubbleElement) {
                // Remove action buttons
                const actions = messageElement.querySelector('.message-actions');
                if (actions) actions.remove();
                
                // CLEAR ALL CONTENT in bubble (text + images + files)
                bubbleElement.innerHTML = '🚫 Tin nhắn này đã bị xóa';
                
                // Add deleted class for styling
                messageElement.classList.add('message-deleted');
                bubbleElement.style.background = '#f0f0f0';
                bubbleElement.style.color = '#999';
                bubbleElement.style.border = '1px dashed #ccc';
                bubbleElement.style.fontStyle = 'italic';
                
                messageElement.style.opacity = '1';
                console.log('[Message Actions] Message marked as deleted (text + attachments)');
            } else {
                // Fallback: just remove
                messageElement.style.transition = 'all 0.3s ease';
                messageElement.style.opacity = '0';
                setTimeout(() => messageElement.remove(), 300);
            }
        } else {
            console.error('[Message Actions] Delete failed:', data.error);
            alert('Không thể xóa tin nhắn: ' + (data.error || 'Lỗi không xác định'));
            messageElement.style.opacity = '1';
        }
    })
    .catch(error => {
        console.error('[Message Actions] Delete error:', error);
        alert('Lỗi khi xóa tin nhắn!');
        messageElement.style.opacity = '1';
    });
};

console.log('[Message Actions] Module loaded');

