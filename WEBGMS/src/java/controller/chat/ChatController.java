package controller.chat;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.*;
import model.chat.*;
import model.user.Users;
import service.AIResponseService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/chat/*")
public class ChatController extends HttpServlet {
    
    private ChatRoomDAO chatRoomDAO = new ChatRoomDAO();
    private ChatMessageDAO chatMessageDAO = new ChatMessageDAO();
    private ChatParticipantDAO participantDAO = new ChatParticipantDAO();
    private AIResponseService aiService = new AIResponseService();
    private Gson gson = new Gson();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Please login first");
            return;
        }
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // Get all chat rooms for user
            listChatRooms(request, response, user);
        } else if (pathInfo.startsWith("/room/")) {
            // Get specific room details
            String roomIdStr = pathInfo.substring("/room/".length());
            try {
                Long roomId = Long.parseLong(roomIdStr);
                getChatRoomDetails(request, response, user, roomId);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid room ID");
            }
        } else if (pathInfo.startsWith("/messages/")) {
            // Get messages for a room
            String roomIdStr = pathInfo.substring("/messages/".length());
            try {
                Long roomId = Long.parseLong(roomIdStr);
                getChatMessages(request, response, user, roomId);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid room ID");
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Please login first");
            return;
        }
        
        if (pathInfo == null || pathInfo.equals("/create")) {
            // Create new chat room
            createChatRoom(request, response, user);
        } else if (pathInfo.equals("/send")) {
            // Send message (alternative to WebSocket)
            sendMessage(request, response, user);
        } else if (pathInfo.equals("/markRead")) {
            // Mark messages as read
            markMessagesAsRead(request, response, user);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    /**
     * List all chat rooms for user
     */
    private void listChatRooms(HttpServletRequest request, HttpServletResponse response, Users user) 
            throws IOException {
        
        List<ChatRoom> rooms = chatRoomDAO.getChatRoomsByUserId((long) user.getUser_id());
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(rooms));
        out.flush();
    }
    
    /**
     * Get chat room details with participants
     */
    private void getChatRoomDetails(HttpServletRequest request, HttpServletResponse response, 
                                    Users user, Long roomId) throws IOException {
        
        // Verify user is participant
        if (!participantDAO.isParticipant(roomId, (long) user.getUser_id())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Not authorized");
            return;
        }
        
        ChatRoom room = chatRoomDAO.getChatRoomById(roomId);
        if (room == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Room not found");
            return;
        }
        
        List<ChatParticipant> participants = participantDAO.getParticipantsByRoomId(roomId);
        
        JsonObject result = new JsonObject();
        result.add("room", gson.toJsonTree(room));
        result.add("participants", gson.toJsonTree(participants));
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(result));
        out.flush();
    }
    
    /**
     * Get messages for a chat room
     */
    private void getChatMessages(HttpServletRequest request, HttpServletResponse response, 
                                 Users user, Long roomId) throws IOException {
        
        // Verify user is participant
        if (!participantDAO.isParticipant(roomId, (long) user.getUser_id())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Not authorized");
            return;
        }
        
        int limit = 50;
        int offset = 0;
        
        String limitParam = request.getParameter("limit");
        String offsetParam = request.getParameter("offset");
        
        if (limitParam != null) {
            try {
                limit = Integer.parseInt(limitParam);
            } catch (NumberFormatException ignored) {}
        }
        
        if (offsetParam != null) {
            try {
                offset = Integer.parseInt(offsetParam);
            } catch (NumberFormatException ignored) {}
        }
        
        List<ChatMessage> messages = chatMessageDAO.getMessagesByRoomId(roomId, limit, offset);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(messages));
        out.flush();
    }
    
    /**
     * Create new chat room
     */
    private void createChatRoom(HttpServletRequest request, HttpServletResponse response, Users user) 
            throws IOException {
        
        String roomType = request.getParameter("roomType");
        String roomName = request.getParameter("roomName");
        String otherUserIdStr = request.getParameter("otherUserId");
        String productIdStr = request.getParameter("productId");
        String userRole = request.getParameter("userRole");
        
        if (otherUserIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Other user ID required");
            return;
        }
        
        Long otherUserId = Long.parseLong(otherUserIdStr);
        Long productId = productIdStr != null ? Long.parseLong(productIdStr) : null;
        
        // Check if room already exists
        ChatRoom existingRoom = chatRoomDAO.findChatRoomBetweenUsers(
            (long) user.getUser_id(), otherUserId, productId
        );
        
        if (existingRoom != null) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(existingRoom));
            out.flush();
            return;
        }
        
        // Create new room
        ChatRoom newRoom = chatRoomDAO.createChatRoom(
            roomType != null ? roomType : "customer_seller",
            roomName,
            productId,
            null
        );
        
        if (newRoom != null) {
            // Add participants
            participantDAO.addParticipant(newRoom.getRoomId(), (long) user.getUser_id(), 
                                        userRole != null ? userRole : "customer");
            participantDAO.addParticipant(newRoom.getRoomId(), otherUserId, 
                                        "seller"); // Assume other user is seller
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(newRoom));
            out.flush();
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to create room");
        }
    }
    
    /**
     * Send message (HTTP alternative to WebSocket)
     */
    private void sendMessage(HttpServletRequest request, HttpServletResponse response, Users user) 
            throws IOException {
        
        String roomIdStr = request.getParameter("roomId");
        String content = request.getParameter("content");
        String senderRole = request.getParameter("senderRole");
        
        if (roomIdStr == null || content == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Room ID and content required");
            return;
        }
        
        Long roomId = Long.parseLong(roomIdStr);
        
        // Verify user is participant
        if (!participantDAO.isParticipant(roomId, (long) user.getUser_id())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Not authorized");
            return;
        }
        
        ChatMessage message = chatMessageDAO.createMessage(
            roomId,
            (long) user.getUser_id(),
            senderRole != null ? senderRole : "customer",
            "text",
            content,
            null,
            false
        );
        
        if (message != null) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(message));
            out.flush();
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to send message");
        }
    }
    
    /**
     * Mark messages as read
     */
    private void markMessagesAsRead(HttpServletRequest request, HttpServletResponse response, Users user) 
            throws IOException {
        
        String roomIdStr = request.getParameter("roomId");
        
        if (roomIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Room ID required");
            return;
        }
        
        Long roomId = Long.parseLong(roomIdStr);
        
        participantDAO.updateLastRead(roomId, (long) user.getUser_id());
        chatMessageDAO.markMessagesAsRead(roomId, (long) user.getUser_id());
        
        JsonObject result = new JsonObject();
        result.addProperty("success", true);
        result.addProperty("message", "Messages marked as read");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(result));
        out.flush();
    }
}
