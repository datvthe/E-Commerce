package dao;

import model.chat.ChatRoom;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ChatRoomDAO extends DBConnection {

    /**
     * Create a new chat room
     */
    public ChatRoom createChatRoom(String roomType, String roomName, Long productId, Long orderId) {
        String sql = "INSERT INTO chat_rooms (room_type, room_name, product_id, order_id, is_active, created_at) " +
                     "VALUES (?, ?, ?, ?, TRUE, NOW())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, roomType);
            ps.setString(2, roomName);
            if (productId != null) {
                ps.setLong(3, productId);
            } else {
                ps.setNull(3, Types.BIGINT);
            }
            if (orderId != null) {
                ps.setLong(4, orderId);
            } else {
                ps.setNull(4, Types.BIGINT);
            }
            
            int affected = ps.executeUpdate();
            if (affected > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    return getChatRoomById(keys.getLong(1));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get chat room by ID
     */
    public ChatRoom getChatRoomById(Long roomId) {
        String sql = "SELECT * FROM chat_rooms WHERE room_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, roomId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapChatRoom(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Find existing chat room between users
     */
    public ChatRoom findChatRoomBetweenUsers(Long user1Id, Long user2Id, Long productId) {
        String sql = "SELECT cr.* FROM chat_rooms cr " +
                     "INNER JOIN chat_participants cp1 ON cr.room_id = cp1.room_id " +
                     "INNER JOIN chat_participants cp2 ON cr.room_id = cp2.room_id " +
                     "WHERE cp1.user_id = ? AND cp2.user_id = ? " +
                     (productId != null ? "AND cr.product_id = ? " : "") +
                     "AND cr.is_active = TRUE " +
                     "LIMIT 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, user1Id);
            ps.setLong(2, user2Id);
            if (productId != null) {
                ps.setLong(3, productId);
            }
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapChatRoom(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Find chat room by user ID and room type
     */
    public ChatRoom findChatRoomByUserAndType(Long userId, String roomType) {
        String sql = "SELECT cr.* FROM chat_rooms cr " +
                     "INNER JOIN chat_participants cp ON cr.room_id = cp.room_id " +
                     "WHERE cp.user_id = ? AND cr.room_type = ? AND cr.is_active = TRUE " +
                     "LIMIT 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, userId);
            ps.setString(2, roomType);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapChatRoom(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Get all chat rooms for a user
     */
    public List<ChatRoom> getChatRoomsByUserId(Long userId) {
        List<ChatRoom> rooms = new ArrayList<>();
        String sql = "SELECT DISTINCT cr.* FROM chat_rooms cr " +
                     "INNER JOIN chat_participants cp ON cr.room_id = cp.room_id " +
                     "WHERE cp.user_id = ? AND cr.is_active = TRUE " +
                     "ORDER BY cr.last_message_at DESC, cr.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                rooms.add(mapChatRoom(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rooms;
    }

    /**
     * Update last message timestamp
     */
    public boolean updateLastMessageTime(Long roomId) {
        String sql = "UPDATE chat_rooms SET last_message_at = NOW(), updated_at = NOW() WHERE room_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, roomId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Deactivate chat room
     */
    public boolean deactivateChatRoom(Long roomId) {
        String sql = "UPDATE chat_rooms SET is_active = FALSE, updated_at = NOW() WHERE room_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, roomId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Map ResultSet to ChatRoom object
     */
    private ChatRoom mapChatRoom(ResultSet rs) throws SQLException {
        ChatRoom room = new ChatRoom();
        room.setRoomId(rs.getLong("room_id"));
        room.setRoomType(rs.getString("room_type"));
        room.setRoomName(rs.getString("room_name"));
        room.setProductId(rs.getObject("product_id", Long.class));
        room.setOrderId(rs.getObject("order_id", Long.class));
        room.setActive(rs.getBoolean("is_active"));
        room.setLastMessageAt(rs.getTimestamp("last_message_at"));
        room.setCreatedAt(rs.getTimestamp("created_at"));
        room.setUpdatedAt(rs.getTimestamp("updated_at"));
        return room;
    }
}
