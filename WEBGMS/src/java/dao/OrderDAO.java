package dao;

import model.order.Orders;
import model.user.Users;
import model.product.Products;
import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * OrderDAO - Data Access Object for Orders
 * Handles digital goods orders (instant delivery)
 */
public class OrderDAO extends DBConnection {
    
    /**
     * Tạo đơn hàng mới (digital goods - instant delivery)
     * @return order_id của đơn hàng mới tạo
     */
    public Long createInstantOrder(Long buyerId, Long sellerId, Long productId, 
                                   Integer quantity, BigDecimal unitPrice, 
                                   BigDecimal totalAmount, String transactionId) throws SQLException {
        
        String orderNumber = generateOrderNumber();
        
        String sql = "INSERT INTO orders " +
                    "(order_number, buyer_id, seller_id, product_id, quantity, " +
                    "unit_price, total_amount, currency, payment_method, payment_status, " +
                    "order_status, delivery_status, transaction_id, queue_status, created_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, 'VND', 'WALLET', 'PAID', 'PENDING', 'INSTANT', ?, 'WAITING', NOW())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, orderNumber);
            ps.setLong(2, buyerId);
            ps.setLong(3, sellerId);
            ps.setLong(4, productId);
            ps.setInt(5, quantity);
            ps.setBigDecimal(6, unitPrice);
            ps.setBigDecimal(7, totalAmount);
            ps.setString(8, transactionId);
            
            int affected = ps.executeUpdate();
            
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getLong(1);
                    }
                }
            }
        }
        
        return null;
    }
    
    /**
     * Generate unique order number
     * Format: ORDER-YYYYMMDD-XXXXX
     */
    private String generateOrderNumber() {
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMdd");
        String datePart = sdf.format(new java.util.Date());
        int randomPart = (int) (Math.random() * 100000);
        return String.format("ORDER-%s-%05d", datePart, randomPart);
    }
    
    /**
     * Lấy order theo ID
     */
    public Orders getOrderById(Long orderId) {
        String sql = "SELECT o.*, " +
                    "b.email as buyer_email, b.full_name as buyer_name, " +
                    "s.email as seller_email, s.full_name as seller_name, " +
                    "p.name as product_name, p.slug as product_slug " +
                    "FROM orders o " +
                    "LEFT JOIN users b ON o.buyer_id = b.user_id " +
                    "LEFT JOIN users s ON o.seller_id = s.user_id " +
                    "LEFT JOIN products p ON o.product_id = p.product_id " +
                    "WHERE o.order_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, orderId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractOrderFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Lấy orders của user (buyer)
     */
    public List<Orders> getOrdersByUserId(Long userId, int limit, int offset) {
        List<Orders> orders = new ArrayList<>();
        
        String sql = "SELECT o.*, " +
                    "p.name as product_name, p.slug as product_slug, " +
                    "s.full_name as seller_name " +
                    "FROM orders o " +
                    "LEFT JOIN products p ON o.product_id = p.product_id " +
                    "LEFT JOIN users s ON o.seller_id = s.user_id " +
                    "WHERE o.buyer_id = ? " +
                    "ORDER BY o.created_at DESC " +
                    "LIMIT ? OFFSET ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, userId);
            ps.setInt(2, limit);
            ps.setInt(3, offset);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(extractOrderFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return orders;
    }
    
    /**
     * Đếm tổng số orders của user
     */
    public int countOrdersByUserId(Long userId) {
        String sql = "SELECT COUNT(*) FROM orders WHERE buyer_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Cập nhật trạng thái order
     */
    public boolean updateOrderStatus(Long orderId, String orderStatus, String queueStatus) {
        String sql = "UPDATE orders SET order_status = ?, queue_status = ?, " +
                    "processed_at = IF(? = 'COMPLETED', NOW(), processed_at) " +
                    "WHERE order_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, orderStatus);
            ps.setString(2, queueStatus);
            ps.setString(3, queueStatus);
            ps.setLong(4, orderId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Extract Order từ ResultSet
     */
    private Orders extractOrderFromResultSet(ResultSet rs) throws SQLException {
        Orders order = new Orders();
        
        order.setOrderId(rs.getLong("order_id"));
        order.setOrderNumber(rs.getString("order_number"));
        order.setBuyerId(rs.getLong("buyer_id"));
        order.setSellerId(rs.getLong("seller_id"));
        order.setProductId(rs.getLong("product_id"));
        order.setQuantity(rs.getInt("quantity"));
        order.setUnitPrice(rs.getBigDecimal("unit_price"));
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        order.setCurrency(rs.getString("currency"));
        order.setPaymentMethod(rs.getString("payment_method"));
        order.setPaymentStatus(rs.getString("payment_status"));
        order.setOrderStatus(rs.getString("order_status"));
        order.setDeliveryStatus(rs.getString("delivery_status"));
        order.setTransactionId(rs.getString("transaction_id"));
        order.setQueueStatus(rs.getString("queue_status"));
        order.setProcessedAt(rs.getTimestamp("processed_at"));
        order.setCreatedAt(rs.getTimestamp("created_at"));
        order.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        // Joined data (if available)
        try {
            // Buyer
            try {
                String buyerEmail = rs.getString("buyer_email");
                if (buyerEmail != null) {
                    Users buyer = new Users();
                    buyer.setUser_id((int) rs.getLong("buyer_id"));
                    buyer.setEmail(buyerEmail);
                    buyer.setFull_name(rs.getString("buyer_name"));
                    order.setBuyer(buyer);
                }
            } catch (SQLException ignored) {}
            
            // Seller
            try {
                String sellerName = rs.getString("seller_name");
                if (sellerName != null) {
                    Users seller = new Users();
                    seller.setUser_id((int) rs.getLong("seller_id"));
                    seller.setFull_name(sellerName);
                    order.setSeller(seller);
                }
            } catch (SQLException ignored) {}
            
            // Product
            if (rs.getString("product_name") != null) {
                Products product = new Products();
                product.setProduct_id(rs.getLong("product_id"));
                product.setName(rs.getString("product_name"));
                product.setSlug(rs.getString("product_slug"));
                order.setProduct(product);
            }
        } catch (SQLException ignored) {
            // Joined columns might not exist
        }
        
        return order;
    }
    
    /**
     * Lấy tổng số orders (admin)
     */
    public int getTotalOrders() {
        String sql = "SELECT COUNT(*) FROM orders";
        
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
     * Lấy orders hôm nay
     */
    public int getOrdersToday() {
        String sql = "SELECT COUNT(*) FROM orders WHERE DATE(created_at) = CURDATE()";
        
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
     * Lấy doanh thu hôm nay (tất cả sellers)
     */
    public BigDecimal getRevenueTodayAll() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders " +
                    "WHERE DATE(created_at) = CURDATE() AND payment_status = 'PAID'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return BigDecimal.ZERO;
    }
    
    /**
     * Lấy recent orders (admin dashboard)
     */
    public List<Orders> getRecentOrders(int limit) {
        List<Orders> orders = new ArrayList<>();
        
        String sql = "SELECT o.*, " +
                    "b.full_name as buyer_name, " +
                    "p.name as product_name " +
                    "FROM orders o " +
                    "LEFT JOIN users b ON o.buyer_id = b.user_id " +
                    "LEFT JOIN products p ON o.product_id = p.product_id " +
                    "ORDER BY o.created_at DESC " +
                    "LIMIT ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(extractOrderFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return orders;
    }
}
