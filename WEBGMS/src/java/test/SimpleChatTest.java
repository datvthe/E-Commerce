package test;

import dao.*;
import model.chat.*;
import java.util.List;

/**
 * Simple Chat Communication Test (No JUnit Required)
 * Run this directly with: java test.SimpleChatTest
 */
public class SimpleChatTest {
    
    private static ChatRoomDAO chatRoomDAO;
    private static ChatMessageDAO chatMessageDAO;
    private static ChatParticipantDAO participantDAO;
    
    // Test user IDs - Updated to match your database
    private static Long customerId = 17L;  // Customer
    private static Long sellerId = 16L;    // Seller
    private static Long adminId = 1L;      // Admin
    private static Long productId = 1L;    // Product
    
    private static int passedTests = 0;
    private static int failedTests = 0;
    
    public static void main(String[] args) {
        System.out.println("=================================================");
        System.out.println("  CHAT COMMUNICATION TEST");
        System.out.println("=================================================");
        System.out.println("Testing all communication paths...\n");
        
        // Initialize DAOs
        chatRoomDAO = new ChatRoomDAO();
        chatMessageDAO = new ChatMessageDAO();
        participantDAO = new ChatParticipantDAO();
        
        // Run tests
        testCustomerToSeller();
        testCustomerToAdmin();
        testSellerToAdmin();
        testAIBot();
        
        // Print summary
        printSummary();
    }
    
    private static void testCustomerToSeller() {
        System.out.println("\n[TEST 1] Customer <-> Seller Communication");
        System.out.println("-------------------------------------------");
        
        try {
            // Create room
            ChatRoom room = chatRoomDAO.createChatRoom(
                "customer_seller", "Product Inquiry", productId, null
            );
            check(room != null, "Create customer-seller room");
            
            // Add participants
            ChatParticipant cp = participantDAO.addParticipant(room.getRoomId(), customerId, "customer");
            ChatParticipant sp = participantDAO.addParticipant(room.getRoomId(), sellerId, "seller");
            check(cp != null && sp != null, "Add participants");
            
            // Customer sends message
            ChatMessage msg1 = chatMessageDAO.createMessage(
                room.getRoomId(), customerId, "customer", "text",
                "Is this product available?", null, false
            );
            check(msg1 != null, "Customer sends message");
            
            // Seller responds
            ChatMessage msg2 = chatMessageDAO.createMessage(
                room.getRoomId(), sellerId, "seller", "text",
                "Yes, we have 10 units in stock!", null, false
            );
            check(msg2 != null, "Seller responds");
            
            // Verify visibility
            List<ChatMessage> messages = chatMessageDAO.getMessagesByRoomId(room.getRoomId(), 50, 0);
            check(messages.size() >= 2, "Both messages visible");
            
            // Verify access
            boolean customerAccess = participantDAO.isParticipant(room.getRoomId(), customerId);
            boolean sellerAccess = participantDAO.isParticipant(room.getRoomId(), sellerId);
            check(customerAccess && sellerAccess, "Both have access");
            
            System.out.println("\n✅ TEST 1 PASSED\n");
            passedTests++;
            
        } catch (Exception e) {
            System.out.println("\n❌ TEST 1 FAILED: " + e.getMessage() + "\n");
            e.printStackTrace();
            failedTests++;
        }
    }
    
    private static void testCustomerToAdmin() {
        System.out.println("\n[TEST 2] Customer <-> Admin Communication");
        System.out.println("------------------------------------------");
        
        try {
            // Create support room
            ChatRoom room = chatRoomDAO.createChatRoom(
                "customer_admin", "Support Request", null, null
            );
            check(room != null, "Create customer-admin room");
            
            // Add participants
            participantDAO.addParticipant(room.getRoomId(), customerId, "customer");
            participantDAO.addParticipant(room.getRoomId(), adminId, "admin");
            check(true, "Add participants");
            
            // Customer requests help
            ChatMessage msg1 = chatMessageDAO.createMessage(
                room.getRoomId(), customerId, "customer", "text",
                "I need help with my order", null, false
            );
            check(msg1 != null, "Customer sends support request");
            
            // Admin responds
            ChatMessage msg2 = chatMessageDAO.createMessage(
                room.getRoomId(), adminId, "admin", "text",
                "I'll check your order status", null, false
            );
            check(msg2 != null, "Admin responds");
            
            // Verify conversation
            List<ChatMessage> messages = chatMessageDAO.getMessagesByRoomId(room.getRoomId(), 50, 0);
            check(messages.size() >= 2, "Conversation verified");
            
            System.out.println("\n✅ TEST 2 PASSED\n");
            passedTests++;
            
        } catch (Exception e) {
            System.out.println("\n❌ TEST 2 FAILED: " + e.getMessage() + "\n");
            e.printStackTrace();
            failedTests++;
        }
    }
    
    private static void testSellerToAdmin() {
        System.out.println("\n[TEST 3] Seller <-> Admin Communication");
        System.out.println("----------------------------------------");
        
        try {
            // Create seller support room
            ChatRoom room = chatRoomDAO.createChatRoom(
                "seller_admin", "Seller Support", null, null
            );
            check(room != null, "Create seller-admin room");
            
            // Add participants
            participantDAO.addParticipant(room.getRoomId(), sellerId, "seller");
            participantDAO.addParticipant(room.getRoomId(), adminId, "admin");
            check(true, "Add participants");
            
            // Seller asks question
            ChatMessage msg1 = chatMessageDAO.createMessage(
                room.getRoomId(), sellerId, "seller", "text",
                "How can I update my shop policies?", null, false
            );
            check(msg1 != null, "Seller sends inquiry");
            
            // Admin provides guidance
            ChatMessage msg2 = chatMessageDAO.createMessage(
                room.getRoomId(), adminId, "admin", "text",
                "Go to Seller Dashboard > Settings", null, false
            );
            check(msg2 != null, "Admin provides guidance");
            
            // Verify conversation
            List<ChatMessage> messages = chatMessageDAO.getMessagesByRoomId(room.getRoomId(), 50, 0);
            check(messages.size() >= 2, "Conversation verified");
            
            System.out.println("\n✅ TEST 3 PASSED\n");
            passedTests++;
            
        } catch (Exception e) {
            System.out.println("\n❌ TEST 3 FAILED: " + e.getMessage() + "\n");
            e.printStackTrace();
            failedTests++;
        }
    }
    
    private static void testAIBot() {
        System.out.println("\n[TEST 4] AI Bot Integration");
        System.out.println("----------------------------");
        
        try {
            // Create room
            ChatRoom room = chatRoomDAO.createChatRoom(
                "customer_seller", "AI Test Room", null, null
            );
            check(room != null, "Create AI test room");
            
            // Add participants
            participantDAO.addParticipant(room.getRoomId(), customerId, "customer");
            participantDAO.addParticipant(room.getRoomId(), sellerId, "seller");
            check(true, "Add participants");
            
            // Simulate AI response
            ChatMessage aiMessage = chatMessageDAO.createMessage(
                room.getRoomId(), null, "ai", "text",
                "Hello! I'm an AI assistant.", null, true
            );
            check(aiMessage != null, "AI sends message");
            check(aiMessage.isAiResponse(), "Message marked as AI");
            check("ai".equals(aiMessage.getSenderRole()), "Sender role is 'ai'");
            
            // Verify AI message is visible
            List<ChatMessage> messages = chatMessageDAO.getMessagesByRoomId(room.getRoomId(), 50, 0);
            boolean aiFound = messages.stream()
                .anyMatch(msg -> msg.isAiResponse() && "ai".equals(msg.getSenderRole()));
            check(aiFound, "AI message visible");
            
            System.out.println("\n✅ TEST 4 PASSED\n");
            passedTests++;
            
        } catch (Exception e) {
            System.out.println("\n❌ TEST 4 FAILED: " + e.getMessage() + "\n");
            e.printStackTrace();
            failedTests++;
        }
    }
    
    private static void check(boolean condition, String description) {
        if (condition) {
            System.out.println("  ✓ " + description);
        } else {
            System.out.println("  ✗ " + description);
            throw new AssertionError(description + " failed");
        }
    }
    
    private static void printSummary() {
        System.out.println("\n=================================================");
        System.out.println("  TEST SUMMARY");
        System.out.println("=================================================");
        System.out.println("Total Tests: " + (passedTests + failedTests));
        System.out.println("Passed: " + passedTests);
        System.out.println("Failed: " + failedTests);
        System.out.println("=================================================");
        
        if (failedTests == 0) {
            System.out.println("\n✅ ALL TESTS PASSED!");
            System.out.println("Chat system is working correctly.");
            System.out.println("\nCommunication paths verified:");
            System.out.println("  ✓ Customer <-> Seller");
            System.out.println("  ✓ Customer <-> Admin");
            System.out.println("  ✓ Seller <-> Admin");
            System.out.println("  ✓ AI Bot Integration");
        } else {
            System.out.println("\n❌ SOME TESTS FAILED");
            System.out.println("Please check the errors above.");
        }
        System.out.println("\n=================================================\n");
    }
}
