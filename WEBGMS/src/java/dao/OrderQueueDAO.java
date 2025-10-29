package dao;

import model.order.OrderQueue;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * OrderQueueDAO - Quản lý hàng đợi xử lý đơn hàng
 */
public class OrderQueueDAO extends DBConnection {
    
    /**
     * Thêm order vào queue
     */
    public boolean addToQueue(Long orderId, int priority) {
        String sql = "INSERT INTO order_queue (order_id, priority, status, attempts) " +
                    "VALUES (?, ?, 'WAITING', 0)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, orderId);
            ps.setInt(2, priority);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Lấy các queue items đang chờ xử lý
     * @param limit số lượng items cần lấy
     */
    public List<OrderQueue> getWaitingItems(int limit) {
        List<OrderQueue> items = new ArrayList<>();
        
        String sql = "SELECT * FROM order_queue " +
                    "WHERE status = 'WAITING' " +
                    "ORDER BY priority DESC, created_at ASC " +
                    "LIMIT ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(extractQueueFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return items;
    }
    
    /**
     * Cập nhật trạng thái queue thành PROCESSING
     */
    public boolean startProcessing(Long queueId, String processorId) {
        String sql = "UPDATE order_queue " +
                    "SET status = 'PROCESSING', " +
                    "processor_id = ?, " +
                    "started_at = NOW(), " +
                    "attempts = attempts + 1 " +
                    "WHERE queue_id = ? AND status = 'WAITING'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, processorId);
            ps.setLong(2, queueId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Đánh dấu queue đã hoàn thành
     */
    public boolean markCompleted(Long queueId) {
        String sql = "UPDATE order_queue " +
                    "SET status = 'COMPLETED', " +
                    "completed_at = NOW() " +
                    "WHERE queue_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, queueId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Đánh dấu queue thất bại
     */
    public boolean markFailed(Long queueId, String errorMessage) {
        String sql = "UPDATE order_queue " +
                    "SET status = 'FAILED', " +
                    "error_message = ?, " +
                    "completed_at = NOW() " +
                    "WHERE queue_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, errorMessage);
            ps.setLong(2, queueId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Lấy queue theo order_id
     */
    public OrderQueue getByOrderId(Long orderId) {
        String sql = "SELECT * FROM order_queue WHERE order_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, orderId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractQueueFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Đếm số queue đang chờ
     */
    public int countWaitingItems() {
        String sql = "SELECT COUNT(*) FROM order_queue WHERE status = 'WAITING'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Extract OrderQueue từ ResultSet
     */
    private OrderQueue extractQueueFromResultSet(ResultSet rs) throws SQLException {
        OrderQueue queue = new OrderQueue();
        
        queue.setQueueId(rs.getLong("queue_id"));
        queue.setOrderId(rs.getLong("order_id"));
        queue.setPriority(rs.getInt("priority"));
        queue.setStatus(rs.getString("status"));
        queue.setAttempts(rs.getInt("attempts"));
        queue.setErrorMessage(rs.getString("error_message"));
        queue.setProcessorId(rs.getString("processor_id"));
        queue.setCreatedAt(rs.getTimestamp("created_at"));
        queue.setStartedAt(rs.getTimestamp("started_at"));
        queue.setCompletedAt(rs.getTimestamp("completed_at"));
        
        return queue;
    }
}

