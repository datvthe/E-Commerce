package service;

import dao.ChatRoomDAO;
import dao.ChatMessageDAO;
import dao.ChatParticipantDAO;
import model.chat.ChatRoom;
import model.chat.ChatMessage;

import java.util.HashMap;
import java.util.Map;

public class AIBotService {
    
    private ChatRoomDAO chatRoomDAO;
    private ChatMessageDAO chatMessageDAO;
    private ChatParticipantDAO chatParticipantDAO;
    
    // AI Bot constants
    public static final String AI_BOT_ROOM_TYPE = "ai_bot";
    public static final String AI_BOT_SENDER_ROLE = "ai";
    
    public AIBotService() {
        this.chatRoomDAO = new ChatRoomDAO();
        this.chatMessageDAO = new ChatMessageDAO();
        this.chatParticipantDAO = new ChatParticipantDAO();
    }
    
    /**
     * Get or create AI Bot chat room for a user
     */
    public ChatRoom getOrCreateAIBotRoom(Long userId, String userName) {
        try {
            System.out.println("[AIBotService] Getting/creating room for user: " + userId);
            
            // Check if user already has an AI Bot room
            ChatRoom existingRoom = chatRoomDAO.findChatRoomByUserAndType(userId, AI_BOT_ROOM_TYPE);
            
            if (existingRoom != null) {
                System.out.println("[AIBotService] Found existing room: " + existingRoom.getRoomId());
                return existingRoom;
            }
            
            System.out.println("[AIBotService] Creating new room...");
            
            // Create new AI Bot room
            ChatRoom room = chatRoomDAO.createChatRoom(AI_BOT_ROOM_TYPE, "AI Trợ Lý - " + userName, null, null);
            
            if (room != null) {
                System.out.println("[AIBotService] Room created: " + room.getRoomId());
                
                // Add user as participant
                System.out.println("[AIBotService] Adding participant...");
                chatParticipantDAO.addParticipant(room.getRoomId(), userId, "customer");
                
                // Send welcome message
                System.out.println("[AIBotService] Sending welcome message...");
                sendWelcomeMessage(room.getRoomId(), userName);
                
                System.out.println("[AIBotService] Room setup complete!");
            } else {
                System.err.println("[AIBotService] Failed to create room - returned null");
            }
            
            return room;
            
        } catch (Exception e) {
            System.err.println("[AIBotService] Exception in getOrCreateAIBotRoom:");
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Send welcome message to user
     */
    private void sendWelcomeMessage(Long roomId, String userName) {
        String welcomeMsg = String.format(
            "👋 Xin chào %s!\n\n" +
            "Tôi là AI Trợ Lý của WEBGMS. Tôi có thể giúp bạn:\n\n" +
            "🛍️ **Tìm hiểu về sản phẩm**\n" +
            "📦 **Kiểm tra đơn hàng**\n" +
            "💳 **Hướng dẫn thanh toán**\n" +
            "🚚 **Chính sách vận chuyển**\n" +
            "↩️ **Chính sách đổi trả**\n" +
            "❓ **Câu hỏi thường gặp**\n\n" +
            "💬 Bạn cần hỗ trợ gì không?", 
            userName
        );
        
        chatMessageDAO.createMessage(
            roomId,
            null, // AI has no sender_id
            AI_BOT_SENDER_ROLE,
            "text",
            welcomeMsg,
            null,
            true // is AI response
        );
    }
    
    /**
     * Process user message and generate AI Bot response
     */
    public ChatMessage processMessage(Long roomId, String messageContent, Long userId) {
        if (messageContent == null || messageContent.trim().isEmpty()) {
            return null;
        }
        
        String response = generateBotResponse(messageContent);
        
        // Create AI response message
        ChatMessage aiMessage = chatMessageDAO.createMessage(
            roomId,
            null, // AI has no sender_id
            AI_BOT_SENDER_ROLE,
            "text",
            response,
            null,
            true // is AI response
        );
        
        return aiMessage;
    }
    
    /**
     * Generate AI Bot response based on user message
     */
    private String generateBotResponse(String messageContent) {
        String lowerMsg = messageContent.toLowerCase();
        
        // Greetings
        if (matchesPattern(lowerMsg, new String[]{"xin chào", "chào", "hello", "hi", "hey"})) {
            return "👋 Xin chào! Rất vui được hỗ trợ bạn. Bạn cần tôi giúp gì?";
        }
        
        // Product inquiries
        if (matchesPattern(lowerMsg, new String[]{"sản phẩm", "product", "mua", "buy", "giá", "price"})) {
            return "🛍️ **Về Sản Phẩm:**\n\n" +
                   "Chúng tôi có đa dạng các sản phẩm chất lượng cao:\n" +
                   "• Điện thoại & Phụ kiện\n" +
                   "• Laptop & Máy tính\n" +
                   "• Đồng hồ thời trang\n" +
                   "• Và nhiều hơn nữa!\n\n" +
                   "👉 Bạn có thể xem danh sách sản phẩm tại: [Trang sản phẩm](/products)\n\n" +
                   "Bạn đang tìm loại sản phẩm nào?";
        }
        
        // Order tracking
        if (matchesPattern(lowerMsg, new String[]{"đơn hàng", "order", "kiểm tra", "track", "trạng thái"})) {
            return "📦 **Kiểm Tra Đơn Hàng:**\n\n" +
                   "Để kiểm tra đơn hàng của bạn:\n" +
                   "1. Vào mục \"Đơn hàng của tôi\"\n" +
                   "2. Nhập mã đơn hàng (ví dụ: ORD-12345)\n" +
                   "3. Xem chi tiết và trạng thái\n\n" +
                   "💡 Hoặc bạn có thể cung cấp mã đơn hàng cho tôi để kiểm tra!";
        }
        
        // Payment
        if (matchesPattern(lowerMsg, new String[]{"thanh toán", "payment", "pay", "tiền", "chuyển khoản"})) {
            return "💳 **Phương Thức Thanh Toán:**\n\n" +
                   "Chúng tôi hỗ trợ:\n" +
                   "• 💵 Thanh toán khi nhận hàng (COD)\n" +
                   "• 🏦 Chuyển khoản ngân hàng\n" +
                   "• 💳 Thẻ tín dụng/Ghi nợ\n" +
                   "• 📱 Ví điện tử (Momo, ZaloPay)\n\n" +
                   "Tất cả giao dịch được bảo mật 100%!";
        }
        
        // Shipping
        if (matchesPattern(lowerMsg, new String[]{"vận chuyển", "ship", "giao hàng", "delivery", "phí ship"})) {
            return "🚚 **Chính Sách Vận Chuyển:**\n\n" +
                   "📍 Giao hàng toàn quốc\n" +
                   "⚡ Giao nhanh 2-3 ngày\n" +
                   "🆓 Miễn phí ship đơn > 500.000đ\n" +
                   "📦 Đóng gói cẩn thận, chắc chắn\n\n" +
                   "Kiểm tra hàng trước khi thanh toán!";
        }
        
        // Return/Refund
        if (matchesPattern(lowerMsg, new String[]{"đổi trả", "hoàn tiền", "return", "refund", "bảo hành"})) {
            return "↩️ **Chính Sách Đổi Trả:**\n\n" +
                   "✅ Đổi trả trong 7 ngày\n" +
                   "✅ Hoàn tiền 100% nếu lỗi nhà sản xuất\n" +
                   "✅ Bảo hành theo chính sách nhà cung cấp\n" +
                   "✅ Hỗ trợ đổi size, màu miễn phí\n\n" +
                   "Điều kiện: Sản phẩm còn nguyên tem, chưa qua sử dụng";
        }
        
        // Contact admin
        if (matchesPattern(lowerMsg, new String[]{"admin", "nhân viên", "người bán", "seller", "tư vấn", "hỗ trợ"})) {
            return "👨‍💼 **Liên Hệ Với Admin:**\n\n" +
                   "Bạn cần tư vấn trực tiếp từ nhân viên?\n\n" +
                   "Tôi có thể kết nối bạn với Admin để được hỗ trợ tốt hơn.\n\n" +
                   "🔘 Nhấn nút **\"Kết nối với Admin\"** bên dưới để bắt đầu!";
        }
        
        // Thanks
        if (matchesPattern(lowerMsg, new String[]{"cảm ơn", "thank", "cám ơn", "thanks"})) {
            return "😊 Không có gì! Rất vui được giúp đỡ bạn.\n\n" +
                   "Nếu cần thêm hỗ trợ, đừng ngại hỏi tôi nhé!";
        }
        
        // Goodbye
        if (matchesPattern(lowerMsg, new String[]{"tạm biệt", "bye", "goodbye", "gặp lại"})) {
            return "👋 Tạm biệt! Chúc bạn một ngày tốt lành.\n\n" +
                   "Quay lại bất cứ khi nào bạn cần hỗ trợ! 😊";
        }
        
        // Default response
        return "🤖 Tôi hiểu bạn đang hỏi về: \"" + messageContent + "\"\n\n" +
               "Tôi có thể giúp bạn với:\n" +
               "• Thông tin sản phẩm\n" +
               "• Kiểm tra đơn hàng\n" +
               "• Hướng dẫn thanh toán\n" +
               "• Chính sách vận chuyển/đổi trả\n\n" +
               "Hoặc nếu cần, tôi có thể **kết nối bạn với Admin** để được tư vấn chi tiết hơn!\n\n" +
               "📞 Hotline: (+012) 1234 567890";
    }
    
    /**
     * Check if message matches any pattern
     */
    private boolean matchesPattern(String message, String[] patterns) {
        for (String pattern : patterns) {
            if (message.contains(pattern)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Create admin escalation room
     */
    public ChatRoom escalateToAdmin(Long userId, String userName, Long aiBotRoomId) {
        // Create new admin chat room
        ChatRoom adminRoom = chatRoomDAO.createChatRoom("customer_admin", "Chat với Admin - " + userName, null, null);
        
        if (adminRoom != null) {
            // Add user as participant
            chatParticipantDAO.addParticipant(adminRoom.getRoomId(), userId, "customer");
            
            // Add admin (user_id = 1) as participant
            chatParticipantDAO.addParticipant(adminRoom.getRoomId(), 1L, "admin");
            
            // Send escalation message
            String escalationMsg = "📌 **Đã kết nối với Admin**\n\n" +
                                  "Xin chào! Bạn đã được chuyển đến phòng chat với Admin.\n" +
                                  "Nhân viên hỗ trợ sẽ phản hồi trong giây lát.\n\n" +
                                  "⏰ Thời gian hỗ trợ: 8:00 - 22:00 hàng ngày";
            
            chatMessageDAO.createMessage(
                adminRoom.getRoomId(),
                null,
                AI_BOT_SENDER_ROLE,
                "system",
                escalationMsg,
                null,
                true
            );
        }
        
        return adminRoom;
    }
}
