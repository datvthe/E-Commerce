package service;

import dao.OrderDAO;
import dao.OrderQueueDAO;
import model.order.OrderQueue;
import model.order.Orders;
import java.sql.Connection;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

/**
 * ✨ NEW: OrderQueueProcessor - Background worker xử lý fulfillment
 * 
 * OLD FLOW: Xử lý order_queue table
 * NEW FLOW: Xử lý orders có status='paid' nhưng delivery_status='pending'
 * 
 * Chạy mỗi 3 giây để:
 * 1. Lấy orders PAID nhưng chưa delivered
 * 2. Gọi OrderFulfillmentService để giao code
 * 3. Auto refund nếu hết code
 */
@WebListener
public class OrderQueueProcessor implements ServletContextListener {
    
    private ScheduledExecutorService scheduler;
    private final OrderDAO orderDAO = new OrderDAO();
    private final OrderFulfillmentService fulfillmentService = new OrderFulfillmentService();
    
    // Legacy DAOs - giữ lại để xử lý old queue nếu cần
    private final OrderQueueDAO queueDAO = new OrderQueueDAO();
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("🚀 [NEW FLOW] OrderQueueProcessor starting...");
        
        // Tạo scheduler chạy mỗi 3 giây (nhanh hơn để user nhận code sớm)
        scheduler = Executors.newScheduledThreadPool(1);
        scheduler.scheduleAtFixedRate(() -> {
            processNewFlowOrders();  // ✨ NEW: Xử lý theo flow mới
            // processQueue();  // Legacy: Giữ lại nếu cần xử lý old queue
        }, 2, 3, TimeUnit.SECONDS); // Delay 2s, chạy mỗi 3s
        
        System.out.println("✅ [OrderQueueProcessor] Background worker started!");
        System.out.println("   → Processing PAID orders every 3 seconds");
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("🛑 [OrderQueueProcessor] Stopping background worker...");
        
        if (scheduler != null) {
            scheduler.shutdown();
            try {
                if (!scheduler.awaitTermination(10, TimeUnit.SECONDS)) {
                    scheduler.shutdownNow();
                }
                System.out.println("✅ [OrderQueueProcessor] Background worker stopped!");
            } catch (InterruptedException e) {
                scheduler.shutdownNow();
                Thread.currentThread().interrupt();
            }
        }
    }
    
    /**
     * ✨ NEW FLOW: Xử lý orders PAID nhưng chưa delivered
     */
    private void processNewFlowOrders() {
        try {
            // Gọi OrderFulfillmentService để xử lý batch
            fulfillmentService.fulfillPendingOrders(10); // Process tối đa 10 orders/lần
            
        } catch (Exception e) {
            System.err.println("❌ [OrderQueueProcessor] Error in new flow: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * LEGACY: Xử lý queue - giữ lại để backward compatible
     */
    private void processQueue() {
        try {
            // 1. Lấy các queue items đang chờ (tối đa 10)
            List<OrderQueue> waitingItems = queueDAO.getWaitingItems(10);
            
            if (waitingItems.isEmpty()) {
                // Không có order nào đang chờ
                return;
            }
            
            System.out.println("📦 [LEGACY] OrderQueueProcessor processing " + waitingItems.size() + " items...");
            
            // 2. Xử lý từng queue item
            for (OrderQueue queueItem : waitingItems) {
                processQueueItem(queueItem);
            }
            
        } catch (Exception e) {
            System.err.println("❌ [LEGACY] OrderQueueProcessor Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Xử lý 1 queue item
     */
    private void processQueueItem(OrderQueue queueItem) {
        String processorId = "WORKER-" + UUID.randomUUID().toString().substring(0, 8);
        
        try {
            // 1. Start processing
            boolean started = queueDAO.startProcessing(queueItem.getQueueId(), processorId);
            
            if (!started) {
                System.out.println("⚠️ [OrderQueueProcessor] Queue #" + queueItem.getQueueId() + " already processing");
                return;
            }
            
            System.out.println("⚙️ [OrderQueueProcessor] Processing queue #" + queueItem.getQueueId() + 
                             " | Order #" + queueItem.getOrderId());
            
            // 2. ⚠️ SKIP: Legacy queue không dùng nữa
            System.out.println("ℹ️ [LEGACY] Skipping old queue item #" + queueItem.getQueueId());
            queueDAO.markCompleted(queueItem.getQueueId());
            return;
            
            // 3. Kiểm tra đã giao đủ chưa
            // (Logic này đã được xử lý trong CheckoutProcessController)
            // Queue processor chỉ cần verify và đánh dấu completed
            
            // 4. Cập nhật order status
            boolean orderUpdated = orderDAO.updateOrderStatus(
                queueItem.getOrderId(), 
                "COMPLETED", 
                "COMPLETED"
            );
            
            if (!orderUpdated) {
                System.out.println("⚠️ [OrderQueueProcessor] Failed to update order #" + queueItem.getOrderId());
                queueDAO.markFailed(queueItem.getQueueId(), "Failed to update order status");
                return;
            }
            
            // 5. Mark queue as completed
            boolean completed = queueDAO.markCompleted(queueItem.getQueueId());
            
            if (completed) {
                System.out.println("✅ [OrderQueueProcessor] Completed queue #" + queueItem.getQueueId() + 
                                 " | Order #" + queueItem.getOrderId() + 
                                 " | Items: " + digitalItems.size());
            }
            
        } catch (Exception e) {
            System.err.println("❌ [OrderQueueProcessor] Error processing queue #" + queueItem.getQueueId() + ": " + e.getMessage());
            e.printStackTrace();
            
            // Mark as failed
            try {
                queueDAO.markFailed(queueItem.getQueueId(), e.getMessage());
            } catch (Exception ex) {
                System.err.println("❌ [OrderQueueProcessor] Error marking failed: " + ex.getMessage());
            }
        }
    }
}

