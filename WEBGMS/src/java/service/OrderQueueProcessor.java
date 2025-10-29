package service;

import dao.OrderDAO;
import dao.OrderQueueDAO;
import dao.DigitalProductDAO;
import model.order.OrderQueue;
import model.order.DigitalProduct;
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
 * OrderQueueProcessor - Background worker tự động xử lý queue
 * Chạy mỗi 5 giây để kiểm tra và xử lý các đơn hàng đang chờ
 */
@WebListener
public class OrderQueueProcessor implements ServletContextListener {
    
    private ScheduledExecutorService scheduler;
    private final OrderQueueDAO queueDAO = new OrderQueueDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final DigitalProductDAO digitalProductDAO = new DigitalProductDAO();
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("🚀 [OrderQueueProcessor] Starting background worker...");
        
        // Tạo scheduler chạy mỗi 5 giây
        scheduler = Executors.newScheduledThreadPool(1);
        scheduler.scheduleAtFixedRate(() -> {
            processQueue();
        }, 5, 5, TimeUnit.SECONDS); // Delay 5s, chạy mỗi 5s
        
        System.out.println("✅ [OrderQueueProcessor] Background worker started!");
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
     * Xử lý queue - chạy định kỳ
     */
    private void processQueue() {
        try {
            // 1. Lấy các queue items đang chờ (tối đa 10)
            List<OrderQueue> waitingItems = queueDAO.getWaitingItems(10);
            
            if (waitingItems.isEmpty()) {
                // Không có order nào đang chờ
                return;
            }
            
            System.out.println("📦 [OrderQueueProcessor] Processing " + waitingItems.size() + " items...");
            
            // 2. Xử lý từng queue item
            for (OrderQueue queueItem : waitingItems) {
                processQueueItem(queueItem);
            }
            
        } catch (Exception e) {
            System.err.println("❌ [OrderQueueProcessor] Error: " + e.getMessage());
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
            
            // 2. Lấy digital products cho order này
            List<DigitalProduct> digitalItems = digitalProductDAO.getDigitalProductsByOrderId(queueItem.getOrderId());
            
            if (digitalItems == null || digitalItems.isEmpty()) {
                // Chưa có digital items → Có thể đơn hàng này đã được xử lý trước đó
                System.out.println("ℹ️ [OrderQueueProcessor] No digital items for order #" + queueItem.getOrderId());
                queueDAO.markFailed(queueItem.getQueueId(), "No digital items found");
                return;
            }
            
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

