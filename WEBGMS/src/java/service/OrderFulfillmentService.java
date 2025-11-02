package service;

import dao.*;
import model.order.Orders;
import model.order.DigitalGoodsCode;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

/**
 * OrderFulfillmentService - Xử lý giao digital codes cho orders PAID
 * 
 * FLOW:
 * 1. Nhận order_id (status = 'paid')
 * 2. Kiểm tra còn code không
 * 3. Nếu còn → Gán code → Update status = 'delivered'
 * 4. Nếu hết → Update status = 'cancelled' (KHÔNG auto refund, customer tự refund)
 */
public class OrderFulfillmentService {
    
    private final OrderDAO orderDAO = new OrderDAO();
    private final DigitalGoodsCodeDAO digitalGoodsDAO = new DigitalGoodsCodeDAO();
    
    /**
     * Xử lý fulfillment cho 1 order
     * 
     * @param orderId Order cần xử lý
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean fulfillOrder(Long orderId) {
        Connection conn = null;
        
        try {
            // 1. Lấy order info
            Orders order = orderDAO.getOrderById(orderId);
            
            if (order == null) {
                System.err.println("❌ [Fulfillment] Order not found: " + orderId);
                return false;
            }
            
            // 2. Kiểm tra status
            if (!"paid".equalsIgnoreCase(order.getPaymentStatus())) {
                System.err.println("❌ [Fulfillment] Order not paid: " + orderId);
                return false;
            }
            
            if ("delivered".equalsIgnoreCase(order.getPaymentStatus())) {
                System.out.println("ℹ️ [Fulfillment] Order already delivered: " + orderId);
                return true; // Already delivered
            }
            
            // 3. Lấy product_id từ order
            Long productId = order.getProductId();
            if (productId == null) {
                System.err.println("❌ [Fulfillment] No product_id for order: " + orderId);
                return false;
            }
            
            // 4. BEGIN TRANSACTION
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // 5. ⚠️ SKIP: Không cần update delivery_status nữa
            // Chỉ dùng status thôi
            
            // 6. Kiểm tra & Lock available codes
            List<DigitalGoodsCode> availableCodes = digitalGoodsDAO.getAvailableCodesWithLock(
                productId, 
                order.getQuantity(), 
                conn
            );
            
            if (availableCodes.isEmpty()) {
                // ⚠️ HẾT CODE → CHỈ CANCEL, KHÔNG AUTO REFUND
                // Customer phải tự click nút "Yêu cầu hoàn tiền"
                System.err.println("⚠️ [Fulfillment] Out of stock for order: " + orderId);
                System.err.println("   → Order will be CANCELLED");
                System.err.println("   → Customer must manually request refund");
                
                // Cancel order
                orderDAO.updateOrderToCancelled(orderId, "Out of stock", conn);
                
                // Commit transaction
                conn.commit();
                
                // KHÔNG gọi refund tự động nữa
                // refundService.processRefund() - REMOVED
                
                return false;
            }
            
            // 7. Gán codes cho user
            // ⚠️ Link order-code được track qua: used_by + used_at ≈ created_at
            // KHÔNG cần update order_items vì table không có digital_code_id
            
            boolean allAssigned = true;
            for (DigitalGoodsCode code : availableCodes) {
                // Mark code as used
                boolean assigned = digitalGoodsDAO.markCodeAsUsed(
                    code.getCodeId(), 
                    order.getBuyerId(), 
                    conn
                );
                
                if (!assigned) {
                    allAssigned = false;
                    break;
                }
                
                System.out.println("  ✓ Assigned code " + code.getCodeId() + " to order " + orderId);
            }
            
            if (!allAssigned) {
                conn.rollback();
                System.err.println("❌ [Fulfillment] Failed to assign codes for order: " + orderId);
                return false;
            }
            
            // 8. Update order to DELIVERED
            boolean updated = orderDAO.updateOrderToDelivered(orderId, conn);
            
            if (!updated) {
                conn.rollback();
                System.err.println("❌ [Fulfillment] Failed to update order to delivered: " + orderId);
                return false;
            }
            
            // 9. COMMIT
            conn.commit();
            
            System.out.println("✅ [Fulfillment] Successfully fulfilled order: " + orderId + 
                             " | Codes: " + availableCodes.size());
            
            return true;
            
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ignored) {}
            }
            
            System.err.println("❌ [Fulfillment] Error fulfilling order " + orderId + ": " + e.getMessage());
            e.printStackTrace();
            return false;
            
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    /**
     * Batch fulfillment - Xử lý nhiều orders cùng lúc
     */
    public void fulfillPendingOrders(int batchSize) {
        try {
            // Lấy orders PAID nhưng chưa delivered
            List<Orders> pendingOrders = orderDAO.getPaidPendingDeliveryOrders(batchSize);
            
            if (pendingOrders.isEmpty()) {
                return;
            }
            
            System.out.println("📦 [Fulfillment] Processing " + pendingOrders.size() + " orders...");
            
            int success = 0;
            int failed = 0;
            
            for (Orders order : pendingOrders) {
                boolean result = fulfillOrder(order.getOrderId());
                if (result) {
                    success++;
                } else {
                    failed++;
                }
            }
            
            System.out.println("📊 [Fulfillment] Batch complete: " + success + " success, " + failed + " failed");
            
        } catch (Exception e) {
            System.err.println("❌ [Fulfillment] Batch error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

