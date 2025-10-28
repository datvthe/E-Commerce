package controller.chat;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.*;
import model.chat.*;
import model.user.Users;
import service.AIBotService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.BufferedReader;
import java.util.List;

@WebServlet("/aibot/*")
public class AIBotController extends HttpServlet {
    
    private AIBotService aiBotService = new AIBotService();
    private ChatMessageDAO chatMessageDAO = new ChatMessageDAO();
    private Gson gson = new Gson();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        if (user == null) {
            sendJsonError(response, HttpServletResponse.SC_UNAUTHORIZED, "Please login first");
            return;
        }
        
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/init")) {
            // Initialize or get AI Bot room
            initAIBot(request, response, user);
        } else if (pathInfo.startsWith("/messages/")) {
            // Get messages for AI Bot room
            String roomIdStr = pathInfo.substring("/messages/".length());
            try {
                Long roomId = Long.parseLong(roomIdStr);
                getAIBotMessages(request, response, user, roomId);
            } catch (NumberFormatException e) {
                sendJsonError(response, HttpServletResponse.SC_BAD_REQUEST, "Invalid room ID");
            }
        } else {
            sendJsonError(response, HttpServletResponse.SC_NOT_FOUND, "Endpoint not found");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        if (user == null) {
            sendJsonError(response, HttpServletResponse.SC_UNAUTHORIZED, "Please login first");
            return;
        }
        
        if (pathInfo == null || pathInfo.equals("/send")) {
            // Send message to AI Bot
            sendMessageToAIBot(request, response, user);
        } else if (pathInfo.equals("/escalate")) {
            // Escalate to admin
            escalateToAdmin(request, response, user);
        } else {
            sendJsonError(response, HttpServletResponse.SC_NOT_FOUND, "Endpoint not found");
        }
    }
    
    /**
     * Initialize AI Bot room for user
     */
    private void initAIBot(HttpServletRequest request, HttpServletResponse response, Users user) 
            throws IOException {
        
        try {
            System.out.println("[AI Bot] Initializing for user: " + user.getUser_id() + " (" + user.getFullName() + ")");
            
            String userName = user.getFullName() != null ? user.getFullName() : "User";
            ChatRoom botRoom = aiBotService.getOrCreateAIBotRoom((long) user.getUser_id(), userName);
            
            if (botRoom == null) {
                System.err.println("[AI Bot] Failed to create room - returned null");
                sendJsonError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to create AI Bot room");
                return;
            }
            
            System.out.println("[AI Bot] Room created successfully: ID=" + botRoom.getRoomId());
            
            JsonObject result = new JsonObject();
            result.addProperty("success", true);
            result.addProperty("roomId", botRoom.getRoomId());
            result.addProperty("roomName", botRoom.getRoomName());
            result.addProperty("roomType", botRoom.getRoomType());
            
            sendJsonResponse(response, result);
            
        } catch (Exception e) {
            System.err.println("[AI Bot] Exception during initialization:");
            e.printStackTrace();
            sendJsonError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Error: " + e.getClass().getSimpleName() + ": " + e.getMessage());
        }
    }
    
    /**
     * Get messages for AI Bot room
     */
    private void getAIBotMessages(HttpServletRequest request, HttpServletResponse response, 
                                  Users user, Long roomId) throws IOException {
        
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
     * Send message to AI Bot and get response
     */
    private void sendMessageToAIBot(HttpServletRequest request, HttpServletResponse response, Users user) 
            throws IOException {
        
        // Read JSON body
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        
        JsonObject jsonRequest = gson.fromJson(sb.toString(), JsonObject.class);
        Long roomId = jsonRequest.get("roomId").getAsLong();
        String messageContent = jsonRequest.get("message").getAsString();
        
        if (messageContent == null || messageContent.trim().isEmpty()) {
            sendJsonError(response, HttpServletResponse.SC_BAD_REQUEST, "Message content required");
            return;
        }
        
        // Save user message
        ChatMessage userMessage = chatMessageDAO.createMessage(
            roomId,
            (long) user.getUser_id(),
            "customer",
            "text",
            messageContent,
            null,
            false
        );
        
        if (userMessage == null) {
            sendJsonError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to save message");
            return;
        }
        
        // Generate AI response
        ChatMessage aiResponse = aiBotService.processMessage(roomId, messageContent, (long) user.getUser_id());
        
        // Prepare response
        JsonObject result = new JsonObject();
        result.addProperty("success", true);
        result.add("userMessage", gson.toJsonTree(userMessage));
        result.add("aiResponse", gson.toJsonTree(aiResponse));
        
        sendJsonResponse(response, result);
    }
    
    /**
     * Escalate conversation to admin
     */
    private void escalateToAdmin(HttpServletRequest request, HttpServletResponse response, Users user) 
            throws IOException {
        
        try {
            System.out.println("[AIBot Controller] Escalate request from user: " + user.getUser_id());
            
            // Read JSON body
            StringBuilder sb = new StringBuilder();
            try (BufferedReader reader = request.getReader()) {
                String line;
                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }
            }
            
            System.out.println("[AIBot Controller] Request body: " + sb.toString());
            
            JsonObject jsonRequest = gson.fromJson(sb.toString(), JsonObject.class);
            Long aiBotRoomId = jsonRequest.get("aiBotRoomId").getAsLong();
            
            System.out.println("[AIBot Controller] AI Bot Room ID: " + aiBotRoomId);
            
            String userName = user.getFullName() != null ? user.getFullName() : "User";
            ChatRoom adminRoom = aiBotService.escalateToAdmin((long) user.getUser_id(), userName, aiBotRoomId);
            
            if (adminRoom == null) {
                System.err.println("[AIBot Controller] Failed to create/find admin room");
                sendJsonError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to create admin room");
                return;
            }
            
            System.out.println("[AIBot Controller] Admin room created/found: " + adminRoom.getRoomId());
            
            JsonObject result = new JsonObject();
            result.addProperty("success", true);
            result.addProperty("adminRoomId", adminRoom.getRoomId());
            result.addProperty("roomName", adminRoom.getRoomName());
            result.addProperty("message", "Successfully connected to admin");
            
            sendJsonResponse(response, result);
            
        } catch (Exception e) {
            System.err.println("[AIBot Controller] Exception in escalateToAdmin:");
            e.printStackTrace();
            sendJsonError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Error: " + e.getClass().getSimpleName() + ": " + e.getMessage());
        }
    }
    
    /**
     * Send JSON response
     */
    private void sendJsonResponse(HttpServletResponse response, JsonObject json) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(json));
        out.flush();
    }
    
    /**
     * Send JSON error response
     */
    private void sendJsonError(HttpServletResponse response, int statusCode, String message) throws IOException {
        response.setStatus(statusCode);
        JsonObject error = new JsonObject();
        error.addProperty("success", false);
        error.addProperty("error", message);
        sendJsonResponse(response, error);
   }
}
