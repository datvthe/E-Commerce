package model.chat;

import java.sql.Timestamp;

public class ChatParticipant {
    private Long participantId;
    private Long roomId;
    private Long userId;
    private String userRole; // customer, seller, admin
    private Timestamp joinedAt;
    private Timestamp lastReadAt;
    private int unreadCount;
    private boolean isActive;
    
    // Additional fields for display
    private String userName;
    private String userAvatar;
    private String userEmail;

    public ChatParticipant() {
    }

    public ChatParticipant(Long participantId, Long roomId, Long userId, String userRole, 
                          Timestamp joinedAt, Timestamp lastReadAt, int unreadCount, boolean isActive) {
        this.participantId = participantId;
        this.roomId = roomId;
        this.userId = userId;
        this.userRole = userRole;
        this.joinedAt = joinedAt;
        this.lastReadAt = lastReadAt;
        this.unreadCount = unreadCount;
        this.isActive = isActive;
    }

    // Getters and Setters
    public Long getParticipantId() {
        return participantId;
    }

    public void setParticipantId(Long participantId) {
        this.participantId = participantId;
    }

    public Long getRoomId() {
        return roomId;
    }

    public void setRoomId(Long roomId) {
        this.roomId = roomId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getUserRole() {
        return userRole;
    }

    public void setUserRole(String userRole) {
        this.userRole = userRole;
    }

    public Timestamp getJoinedAt() {
        return joinedAt;
    }

    public void setJoinedAt(Timestamp joinedAt) {
        this.joinedAt = joinedAt;
    }

    public Timestamp getLastReadAt() {
        return lastReadAt;
    }

    public void setLastReadAt(Timestamp lastReadAt) {
        this.lastReadAt = lastReadAt;
    }

    public int getUnreadCount() {
        return unreadCount;
    }

    public void setUnreadCount(int unreadCount) {
        this.unreadCount = unreadCount;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserAvatar() {
        return userAvatar;
    }

    public void setUserAvatar(String userAvatar) {
        this.userAvatar = userAvatar;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    @Override
    public String toString() {
        return "ChatParticipant{" +
                "participantId=" + participantId +
                ", roomId=" + roomId +
                ", userId=" + userId +
                ", userRole='" + userRole + '\'' +
                ", unreadCount=" + unreadCount +
                ", isActive=" + isActive +
                '}';
    }
}
