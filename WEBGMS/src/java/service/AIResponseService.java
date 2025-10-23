package service;

import dao.AITemplateDAO;
import dao.ChatMessageDAO;
import dao.ProductDAO;
import dao.OrderDAO;
import model.chat.AITemplate;
import model.chat.ChatMessage;

public class AIResponseService {
    
    private AITemplateDAO aiTemplateDAO;
    private ChatMessageDAO chatMessageDAO;
    private ProductDAO productDAO;
    private OrderDAO orderDAO;
    
    public AIResponseService() {
        this.aiTemplateDAO = new AITemplateDAO();
        this.chatMessageDAO = new ChatMessageDAO();
        this.productDAO = new ProductDAO();
        this.orderDAO = new OrderDAO();
    }
    
    /**
     * Process incoming message and generate AI response if applicable
     * @param roomId Chat room ID
     * @param messageContent User's message content
     * @return AI response message or null if no match found
     */
    public ChatMessage generateResponse(Long roomId, String messageContent) {
        if (messageContent == null || messageContent.trim().isEmpty()) {
            return null;
        }
        
        String responseText;
        
        // Find matching template
        AITemplate template = aiTemplateDAO.findMatchingTemplate(messageContent);
        
        if (template != null) {
            responseText = template.getResponseText();
        } else {
            // Default response when no template matches
            responseText = generateDefaultResponse(messageContent);
        }
        
        // Enhance response based on context
        responseText = enhanceResponse(responseText, messageContent, roomId);
        
        // Create AI response message
        ChatMessage aiMessage = chatMessageDAO.createMessage(
            roomId,
            null, // AI has no sender_id
            "ai",
            "text",
            responseText,
            null,
            true // is AI response
        );
        
        return aiMessage;
    }
    
    /**
     * Enhance AI response with contextual information
     */
    private String enhanceResponse(String baseResponse, String messageContent, Long roomId) {
        String lowerMessage = messageContent.toLowerCase();
        
        // Check for order-related queries
        if (lowerMessage.contains("đơn hàng") || lowerMessage.contains("order")) {
            // Extract order number if present
            String orderNumber = extractOrderNumber(messageContent);
            if (orderNumber != null) {
                baseResponse += "\n\nMã đơn hàng của bạn: " + orderNumber + 
                              ". Vui lòng chờ trong giây lát để kiểm tra.";
            }
        }
        
        // Check for product-related queries
        if (lowerMessage.contains("sản phẩm") || lowerMessage.contains("product")) {
            baseResponse += "\n\nBạn có thể xem thêm thông tin chi tiết về sản phẩm trong danh sách sản phẩm.";
        }
        
        // Add helpful closing
        if (!lowerMessage.contains("cảm ơn") && !lowerMessage.contains("thank")) {
            baseResponse += "\n\nCó điều gì khác tôi có thể giúp bạn không?";
        }
        
        return baseResponse;
    }
    
    /**
     * Extract order number from message
     */
    private String extractOrderNumber(String message) {
        // Simple pattern matching for order numbers (e.g., ORD-12345)
        java.util.regex.Pattern pattern = java.util.regex.Pattern.compile("(ORD-\\d+|#\\d+)");
        java.util.regex.Matcher matcher = pattern.matcher(message);
        
        if (matcher.find()) {
            return matcher.group(1);
        }
        return null;
    }
    
    /**
     * Check if AI should respond to this message
     * AI ALWAYS responds to provide instant support
     */
    public boolean shouldRespond(String messageContent, Long roomId) {
        if (messageContent == null || messageContent.trim().isEmpty()) {
            return false;
        }
        
        // AI ALWAYS responds to every message for better customer support
        return true;
    }
    
    /**
     * Generate default AI response when no template matches
     */
    private String generateDefaultResponse(String messageContent) {
        String lowerMessage = messageContent.toLowerCase();
        
        // Check message characteristics
        if (lowerMessage.contains("?")) {
            return "Đây là một câu hỏi hay! Tôi đang xử lý thông tin của bạn. "
                + "Trong khi chờ, bạn có thể xem thêm sản phẩm của chúng tôi hoặc "
                + "liên hệ hotline (+012) 1234 567890 để được hỗ trợ trực tiếp.";
        }
        
        // Default friendly response
        return "Cảm ơn bạn đã liên hệ! Tôi đang ghi nhận tin nhắn của bạn. "
            + "Người bán sẽ phản hồi sớm nhất có thể. "
            + "Nếu cần hỗ trợ gấp, vui lòng gọi (+012) 1234 567890.";
    }
    
    /**
     * Get greeting message for new chat rooms
     */
    public String getGreetingMessage(String userRole) {
        switch (userRole) {
            case "customer":
                return "Xin chào! Tôi là trợ lý AI. Tôi sẽ hỗ trợ bạn trong khi chờ người bán phản hồi. Bạn cần giúp gì?";
            case "seller":
                return "Xin chào! Tôi là trợ lý AI. Tôi có thể giúp bạn với các câu hỏi thường gặp từ khách hàng.";
            case "admin":
                return "Xin chào Admin! Hệ thống AI sẵn sàng hỗ trợ.";
            default:
                return "Xin chào! Tôi là trợ lý AI. Tôi có thể giúp gì cho bạn?";
        }
    }
}
