package websocket;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.ChatMessageDAO;
import dao.ChatParticipantDAO;
import dao.ChatRoomDAO;
import model.chat.ChatMessage;
import service.AIResponseService;

import jakarta.websocket.*;
import jakarta.websocket.server.PathParam;
import jakarta.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@ServerEndpoint("/chat/{roomId}/{userId}")
public class ChatWebSocketServer {
    
    // Store active sessions: roomId -> Map of userId -> Session
    private static Map<Long, Map<Long, Session>> chatRooms = new ConcurrentHashMap<>();
    
    private ChatMessageDAO chatMessageDAO = new ChatMessageDAO();
    private ChatParticipantDAO participantDAO = new ChatParticipantDAO();
    private ChatRoomDAO chatRoomDAO = new ChatRoomDAO();
    private AIResponseService aiService = new AIResponseService();
    private Gson gson = new Gson();
    
    @OnOpen
    public void onOpen(Session session, @PathParam("roomId") Long roomId, @PathParam("userId") Long userId) {
        System.out.println("WebSocket opened: User " + userId + " joined room " + roomId);
        
        // Add session to room
        chatRooms.computeIfAbsent(roomId, k -> new ConcurrentHashMap<>()).put(userId, session);
        
        // Verify participant
        if (!participantDAO.isParticipant(roomId, userId)) {
            System.out.println("User " + userId + " is not a participant in room " + roomId);
            try {
                session.close(new CloseReason(CloseReason.CloseCodes.VIOLATED_POLICY, "Not a participant"));
            } catch (IOException e) {
                e.printStackTrace();
            }
            return;
        }
        
        // Mark messages as read
        participantDAO.updateLastRead(roomId, userId);
        
        // Send connection confirmation
        JsonObject response = new JsonObject();
        response.addProperty("type", "connected");
        response.addProperty("roomId", roomId);
        response.addProperty("userId", userId);
        response.addProperty("message", "Connected to chat room");
        
        try {
            session.getBasicRemote().sendText(gson.toJson(response));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    @OnMessage
    public void onMessage(String message, Session session, @PathParam("roomId") Long roomId, @PathParam("userId") Long userId) {
        System.out.println("Message from user " + userId + " in room " + roomId + ": " + message);
        
        try {
            JsonObject jsonMessage = gson.fromJson(message, JsonObject.class);
            String type = jsonMessage.get("type").getAsString();
            
            switch (type) {
                case "message":
                    handleChatMessage(jsonMessage, roomId, userId);
                    break;
                case "typing":
                    handleTypingIndicator(jsonMessage, roomId, userId);
                    break;
                case "read":
                    handleReadReceipt(jsonMessage, roomId, userId);
                    break;
                default:
                    System.out.println("Unknown message type: " + type);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    @OnClose
    public void onClose(Session session, @PathParam("roomId") Long roomId, @PathParam("userId") Long userId) {
        System.out.println("WebSocket closed: User " + userId + " left room " + roomId);
        
        // Remove session from room
        Map<Long, Session> roomSessions = chatRooms.get(roomId);
        if (roomSessions != null) {
            roomSessions.remove(userId);
            if (roomSessions.isEmpty()) {
                chatRooms.remove(roomId);
            }
        }
    }
    
    @OnError
    public void onError(Session session, Throwable throwable, @PathParam("roomId") Long roomId, @PathParam("userId") Long userId) {
        System.err.println("WebSocket error for user " + userId + " in room " + roomId);
        throwable.printStackTrace();
    }
    
    /**
     * Handle chat message
     */
    private void handleChatMessage(JsonObject jsonMessage, Long roomId, Long userId) {
        String messageContent = jsonMessage.get("content").getAsString();
        String messageType = jsonMessage.has("messageType") ? jsonMessage.get("messageType").getAsString() : "text";
        String senderRole = jsonMessage.has("senderRole") ? jsonMessage.get("senderRole").getAsString() : "customer";
        
        // Save message to database
        ChatMessage chatMessage = chatMessageDAO.createMessage(
            roomId,
            userId,
            senderRole,
            messageType,
            messageContent,
            null,
            false
        );
        
        if (chatMessage != null) {
            // Broadcast message to all users in room
            broadcastToRoom(roomId, createMessagePayload(chatMessage, "new_message"));
            
            // Check if AI should respond
            if (aiService.shouldRespond(messageContent, roomId)) {
                // Generate AI response asynchronously
                new Thread(() -> {
                    try {
                        Thread.sleep(1000); // Simulate thinking time
                        ChatMessage aiResponse = aiService.generateResponse(roomId, messageContent);
                        if (aiResponse != null) {
                            broadcastToRoom(roomId, createMessagePayload(aiResponse, "new_message"));
                        }
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }).start();
            }
        }
    }
    
    /**
     * Handle typing indicator
     */
    private void handleTypingIndicator(JsonObject jsonMessage, Long roomId, Long userId) {
        boolean isTyping = jsonMessage.get("isTyping").getAsBoolean();
        
        JsonObject response = new JsonObject();
        response.addProperty("type", "typing");
        response.addProperty("userId", userId);
        response.addProperty("isTyping", isTyping);
        
        // Broadcast to all other users in room
        broadcastToRoom(roomId, response, userId);
    }
    
    /**
     * Handle read receipt
     */
    private void handleReadReceipt(JsonObject jsonMessage, Long roomId, Long userId) {
        participantDAO.updateLastRead(roomId, userId);
        chatMessageDAO.markMessagesAsRead(roomId, userId);
        
        JsonObject response = new JsonObject();
        response.addProperty("type", "read");
        response.addProperty("userId", userId);
        response.addProperty("roomId", roomId);
        
        // Broadcast to all users in room
        broadcastToRoom(roomId, response);
    }
    
    /**
     * Create message payload for broadcasting
     */
    private JsonObject createMessagePayload(ChatMessage message, String type) {
        JsonObject payload = new JsonObject();
        payload.addProperty("type", type);
        payload.addProperty("messageId", message.getMessageId());
        payload.addProperty("roomId", message.getRoomId());
        payload.addProperty("senderId", message.getSenderId());
        payload.addProperty("senderName", message.getSenderName());
        payload.addProperty("senderAvatar", message.getSenderAvatar());
        payload.addProperty("senderRole", message.getSenderRole());
        payload.addProperty("messageType", message.getMessageType());
        payload.addProperty("content", message.getMessageContent());
        payload.addProperty("isAiResponse", message.isAiResponse());
        payload.addProperty("createdAt", message.getCreatedAt().toString());
        return payload;
    }
    
    /**
     * Broadcast message to all users in a room
     */
    private void broadcastToRoom(Long roomId, JsonObject message) {
        broadcastToRoom(roomId, message, null);
    }
    
    /**
     * Broadcast message to all users in a room except specified user
     */
    private void broadcastToRoom(Long roomId, JsonObject message, Long excludeUserId) {
        Map<Long, Session> roomSessions = chatRooms.get(roomId);
        if (roomSessions != null) {
            String messageText = gson.toJson(message);
            roomSessions.forEach((userId, session) -> {
                if (excludeUserId == null || !userId.equals(excludeUserId)) {
                    if (session.isOpen()) {
                        try {
                            session.getBasicRemote().sendText(messageText);
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                }
            });
        }
    }
}
