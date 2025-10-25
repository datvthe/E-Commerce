package dao;

import model.chat.ChatMessage;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ChatMessageDAO extends DBConnection {

    /**
     * Send/create a new message
     */
    public ChatMessage createMessage(Long roomId, Long senderId, String senderRole, 
                                     String messageType, String messageContent, 
                                     String attachmentUrl, boolean isAiResponse) {
        System.out.println("[ChatMessageDAO] Creating message - roomId: " + roomId + ", senderId: " + senderId + ", content: " + messageContent);
        
        String sql = "INSERT INTO chat_messages (room_id, sender_id, sender_role, message_type, " +
                     "message_content, attachment_url, is_ai_response, is_read) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, FALSE)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            if (conn == null) {
                System.err.println("[ChatMessageDAO] ERROR: Database connection is null!");
                return null;
            }
            
            ps.setLong(1, roomId);
            if (senderId != null) {
                ps.setLong(2, senderId);
            } else {
                ps.setNull(2, Types.BIGINT);
            }
            ps.setString(3, senderRole);
            ps.setString(4, messageType);
            ps.setString(5, messageContent);
            ps.setString(6, attachmentUrl);
            ps.setBoolean(7, isAiResponse);
            
            System.out.println("[ChatMessageDAO] Executing SQL: " + sql);
            int affected = ps.executeUpdate();
            System.out.println("[ChatMessageDAO] Rows affected: " + affected);
            
            if (affected > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    Long messageId = keys.getLong(1);
                    System.out.println("[ChatMessageDAO] Message created with ID: " + messageId);
                    
                    // Update last message time in chat room
                    new ChatRoomDAO().updateLastMessageTime(roomId);
                    
                    ChatMessage message = getMessageById(messageId);
                    System.out.println("[ChatMessageDAO] Retrieved message: " + (message != null ? "SUCCESS" : "FAILED"));
                    return message;
                } else {
                    System.err.println("[ChatMessageDAO] ERROR: No generated keys returned!");
                }
            } else {
                System.err.println("[ChatMessageDAO] ERROR: No rows affected by insert!");
            }
        } catch (Exception e) {
            System.err.println("[ChatMessageDAO] EXCEPTION during message creation:");
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get message by ID
     */
    public ChatMessage getMessageById(Long messageId) {
        String sql = "SELECT cm.*, u.full_name as sender_name, u.avatar_url as sender_avatar " +
                     "FROM chat_messages cm " +
                     "LEFT JOIN users u ON cm.sender_id = u.user_id " +
                     "WHERE cm.message_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, messageId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapChatMessage(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get messages by room ID
     */
    public List<ChatMessage> getMessagesByRoomId(Long roomId, int limit, int offset) {
        System.out.println("[ChatMessageDAO] Loading messages for room: " + roomId + ", limit: " + limit + ", offset: " + offset);
        
        List<ChatMessage> messages = new ArrayList<>();
        String sql = "SELECT cm.*, u.full_name as sender_name, u.avatar_url as sender_avatar " +
                     "FROM chat_messages cm " +
                     "LEFT JOIN users u ON cm.sender_id = u.user_id " +
                     "WHERE cm.room_id = ? AND cm.is_deleted = FALSE " +
                     "ORDER BY cm.message_id ASC " +
                     "LIMIT ? OFFSET ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            if (conn == null) {
                System.err.println("[ChatMessageDAO] ERROR: Database connection is null!");
                return messages;
            }
            
            ps.setLong(1, roomId);
            ps.setInt(2, limit);
            ps.setInt(3, offset);
            try (ResultSet rs = ps.executeQuery()) {
                int count = 0;
                while (rs.next()) {
                    messages.add(mapChatMessage(rs));
                    count++;
                    System.out.println("[ChatMessageDAO] Message #" + count + " - ID: " + rs.getLong("message_id") + ", Time: " + rs.getTimestamp("created_at"));
                }
                
                System.out.println("[ChatMessageDAO] Loaded " + count + " messages for room " + roomId);
            }
        } catch (Exception e) {
            System.err.println("[ChatMessageDAO] EXCEPTION while loading messages:");
            e.printStackTrace();
        }
        return messages;
    }

    /**
     * Get recent messages by room ID
     */
    public List<ChatMessage> getRecentMessages(Long roomId, int limit) {
        return getMessagesByRoomId(roomId, limit, 0);
    }

    /**
     * Mark messages as read
     */
    public boolean markMessagesAsRead(Long roomId, Long userId) {
        String sql = "UPDATE chat_messages SET is_read = TRUE, updated_at = NOW() " +
                     "WHERE room_id = ? AND sender_id != ? AND is_read = FALSE";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, roomId);
            ps.setLong(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get unread message count for a room
     */
    public int getUnreadCount(Long roomId, Long userId) {
        String sql = "SELECT COUNT(*) as count FROM chat_messages " +
                     "WHERE room_id = ? AND sender_id != ? AND is_read = FALSE AND is_deleted = FALSE";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, roomId);
            ps.setLong(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Delete message (soft delete)
     */
    public boolean deleteMessage(Long messageId) {
        String sql = "UPDATE chat_messages SET is_deleted = TRUE, updated_at = NOW() WHERE message_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, messageId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update message content
     */
    public boolean updateMessage(Long messageId, String newContent) {
        String sql = "UPDATE chat_messages SET message_content = ?, is_edited = TRUE, updated_at = NOW() " +
                     "WHERE message_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, newContent);
            ps.setLong(2, messageId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get last message in a room
     */
    public ChatMessage getLastMessage(Long roomId) {
        String sql = "SELECT cm.*, u.full_name as sender_name, u.avatar_url as sender_avatar " +
                     "FROM chat_messages cm " +
                     "LEFT JOIN users u ON cm.sender_id = u.user_id " +
                     "WHERE cm.room_id = ? AND cm.is_deleted = FALSE " +
                     "ORDER BY cm.created_at DESC LIMIT 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapChatMessage(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Map ResultSet to ChatMessage object
     */
    private ChatMessage mapChatMessage(ResultSet rs) throws SQLException {
        ChatMessage message = new ChatMessage();
        message.setMessageId(rs.getLong("message_id"));
        message.setRoomId(rs.getLong("room_id"));
        message.setSenderId(rs.getObject("sender_id", Long.class));
        message.setSenderRole(rs.getString("sender_role"));
        message.setMessageType(rs.getString("message_type"));
        message.setMessageContent(rs.getString("message_content"));
        message.setAttachmentUrl(rs.getString("attachment_url"));
        message.setMetadata(rs.getString("metadata"));
        message.setAiResponse(rs.getBoolean("is_ai_response"));
        message.setRead(rs.getBoolean("is_read"));
        message.setEdited(rs.getBoolean("is_edited"));
        message.setDeleted(rs.getBoolean("is_deleted"));
        message.setCreatedAt(rs.getTimestamp("created_at"));
        message.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        // Additional fields
        message.setSenderName(rs.getString("sender_name"));
        message.setSenderAvatar(rs.getString("sender_avatar"));
        
        return message;
    }
}
