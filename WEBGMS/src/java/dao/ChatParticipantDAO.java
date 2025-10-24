package dao;

import model.chat.ChatParticipant;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ChatParticipantDAO extends DBConnection {

    /**
     * Add participant to chat room
     */
    public ChatParticipant addParticipant(Long roomId, Long userId, String userRole) {
        String sql = "INSERT INTO chat_participants (room_id, user_id, user_role, joined_at, is_active) " +
                     "VALUES (?, ?, ?, NOW(), TRUE) " +
                     "ON DUPLICATE KEY UPDATE is_active = TRUE";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setLong(1, roomId);
            ps.setLong(2, userId);
            ps.setString(3, userRole);
            
            int affected = ps.executeUpdate();
            if (affected > 0) {
                return getParticipant(roomId, userId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get participant by room and user
     */
    public ChatParticipant getParticipant(Long roomId, Long userId) {
        String sql = "SELECT cp.*, u.full_name as user_name, u.avatar_url as user_avatar, u.email as user_email " +
                     "FROM chat_participants cp " +
                     "INNER JOIN users u ON cp.user_id = u.user_id " +
                     "WHERE cp.room_id = ? AND cp.user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, roomId);
            ps.setLong(2, userId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapParticipant(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get all participants in a room
     */
    public List<ChatParticipant> getParticipantsByRoomId(Long roomId) {
        List<ChatParticipant> participants = new ArrayList<>();
        String sql = "SELECT cp.*, u.full_name as user_name, u.avatar_url as user_avatar, u.email as user_email " +
                     "FROM chat_participants cp " +
                     "INNER JOIN users u ON cp.user_id = u.user_id " +
                     "WHERE cp.room_id = ? AND cp.is_active = TRUE " +
                     "ORDER BY cp.joined_at ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, roomId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                participants.add(mapParticipant(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return participants;
    }

    /**
     * Update last read timestamp
     */
    public boolean updateLastRead(Long roomId, Long userId) {
        String sql = "UPDATE chat_participants SET last_read_at = NOW(), unread_count = 0 " +
                     "WHERE room_id = ? AND user_id = ?";
        
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
     * Increment unread count
     */
    public boolean incrementUnreadCount(Long roomId, Long userId) {
        String sql = "UPDATE chat_participants SET unread_count = unread_count + 1 " +
                     "WHERE room_id = ? AND user_id = ?";
        
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
     * Remove participant from room
     */
    public boolean removeParticipant(Long roomId, Long userId) {
        String sql = "UPDATE chat_participants SET is_active = FALSE WHERE room_id = ? AND user_id = ?";
        
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
     * Hide chat room from user's view (soft delete)
     */
    public boolean hideRoom(Long roomId, Long userId) {
        String sql = "UPDATE chat_participants SET is_hidden = TRUE WHERE room_id = ? AND user_id = ?";
        
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
     * Unhide chat room for user
     */
    public boolean unhideRoom(Long roomId, Long userId) {
        String sql = "UPDATE chat_participants SET is_hidden = FALSE WHERE room_id = ? AND user_id = ?";
        
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
     * Check if user is participant in room
     */
    public boolean isParticipant(Long roomId, Long userId) {
        String sql = "SELECT COUNT(*) as count FROM chat_participants " +
                     "WHERE room_id = ? AND user_id = ? AND is_active = TRUE";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, roomId);
            ps.setLong(2, userId);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        } catch (Exception e) {
            System.err.println("[ChatParticipantDAO] Error checking participant:");
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Map ResultSet to ChatParticipant object
     */
    private ChatParticipant mapParticipant(ResultSet rs) throws SQLException {
        ChatParticipant participant = new ChatParticipant();
        participant.setParticipantId(rs.getLong("participant_id"));
        participant.setRoomId(rs.getLong("room_id"));
        participant.setUserId(rs.getLong("user_id"));
        participant.setUserRole(rs.getString("user_role"));
        participant.setJoinedAt(rs.getTimestamp("joined_at"));
        participant.setLastReadAt(rs.getTimestamp("last_read_at"));
        participant.setUnreadCount(rs.getInt("unread_count"));
        participant.setActive(rs.getBoolean("is_active"));
        
        // Additional fields
        participant.setUserName(rs.getString("user_name"));
        participant.setUserAvatar(rs.getString("user_avatar"));
        participant.setUserEmail(rs.getString("user_email"));
        
        return participant;
    }
}
