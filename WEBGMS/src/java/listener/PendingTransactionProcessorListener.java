package listener;

import service.PendingTransactionProcessor;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

/**
 * PendingTransactionProcessorListener - Khởi động background processor
 * Tự động start khi app deploy, stop khi app undeploy
 */
@WebListener
public class PendingTransactionProcessorListener implements ServletContextListener {
    
    private Thread processorThread;
    private PendingTransactionProcessor processor;
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("🚀 Starting PendingTransactionProcessor...");
        
        processor = new PendingTransactionProcessor();
        processorThread = new Thread(processor, "PendingTransactionProcessor-Thread");
        processorThread.setDaemon(true); // Daemon thread sẽ tự động stop khi app stop
        processorThread.start();
        
        System.out.println("✅ PendingTransactionProcessor started successfully!");
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("🛑 Stopping PendingTransactionProcessor...");
        
        if (processor != null) {
            processor.stop();
        }
        
        if (processorThread != null && processorThread.isAlive()) {
            processorThread.interrupt();
            try {
                processorThread.join(5000); // Đợi tối đa 5 giây
            } catch (InterruptedException e) {
                System.err.println("⚠️ Interrupted while waiting for processor to stop");
                Thread.currentThread().interrupt();
            }
        }
        
        System.out.println("✅ PendingTransactionProcessor stopped!");
    }
}

