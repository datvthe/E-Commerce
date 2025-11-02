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
     * ✨ Tạo đơn hàng mới (digital goods - instant delivery)
     * 
     * ⚠️ NGUYÊN TẮC: 1 ORDER = 1 CODE DUY NHẤT
     * ════════════════════════════════════════
     * - Mỗi order CHỈ chứa 1 code
     * - Quantity LUÔN = 1 (cố định)
     * - Nếu user muốn mua 3 codes → Tạo 3 orders riêng biệt
     * - Dùng order_id làm identifier
     * 
     * @param productPrice - Giá 1 code (= total_amount)
     * @return order_id của đơn hàng mới tạo
     */
    public Long createInstantOrder(Long buyerId, Long sellerId, BigDecimal productPrice, 
                                   String transactionId, Connection conn) throws SQLException {
        
        // ✅ INSERT vào orders (theo cấu trúc: buyer_id, seller_id, status, total_amount)
        String sql = "INSERT INTO orders " +
                    "(buyer_id, seller_id, status, total_amount, currency, created_at) " +
                    "VALUES (?, ?, 'paid', ?, 'VND', NOW())";
        
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setLong(1, buyerId);
            ps.setLong(2, sellerId);
            ps.setBigDecimal(3, productPrice); // total_amount = giá 1 code
            
            int affected = ps.executeUpdate();
            
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        Long orderId = rs.getLong(1);
                        System.out.println("✅ Created order ID: " + orderId + " | Amount: " + productPrice);
                        return orderId;
                    }
                }
            }
        }
        
        return null;
    }
    
    /**
     * ✨ Insert vào order_items - KHÔNG dùng digital_code_id vì DB không có cột này
     * Code sẽ được track qua: digital_goods_codes.used_by + used_at
     */
    public void insertOrderItem(Long orderId, Integer codeId, Long productId, 
                                BigDecimal price, Connection conn) throws SQLException {
        
        // ✅ 1 ORDER = 1 CODE → quantity luôn = 1
        // ⚠️ KHÔNG dùng digital_code_id vì table không có cột này
        String sql = "INSERT INTO order_items " +
                    "(order_id, product_id, quantity, price_at_purchase, discount_applied, subtotal) " +
                    "VALUES (?, ?, 1, ?, 0, ?)";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            ps.setLong(2, productId);
            ps.setBigDecimal(3, price);
            ps.setBigDecimal(4, price); // subtotal = price (vì quantity = 1)
            
            ps.executeUpdate();
            System.out.println("  ✓ Added order_item: order=" + orderId + ", product=" + productId);
        }
    }
    
    /**
     * ⚠️ DEPRECATED: Table order_items không có cột digital_code_id
     * Link giữa order và code được track qua:
     * - digital_goods_codes.used_by = buyer_id
     * - digital_goods_codes.used_at ≈ order.created_at
     */
    @Deprecated
    public boolean updateOrderItemCode(Long orderId, Integer codeId, Connection conn) throws SQLException {
        // Do nothing - table không có cột này
        System.out.println("⚠️ Table order_items không có digital_code_id - tracking via used_by + used_at");
        return true;
    }
    
    /**
     * Lấy order theo ID (JOIN với order_items để lấy product_id)
     */
    public Orders getOrderById(Long orderId) {
        String sql = "SELECT o.*, " +
                    "b.email as buyer_email, b.full_name as buyer_name, " +
                    "s.email as seller_email, s.full_name as seller_name, " +
                    "oi.product_id, p.name as product_name, p.slug as product_slug " +
                    "FROM orders o " +
                    "LEFT JOIN users b ON o.buyer_id = b.user_id " +
                    "LEFT JOIN users s ON o.seller_id = s.user_id " +
                    "LEFT JOIN order_items oi ON o.order_id = oi.order_id " +
                    "LEFT JOIN products p ON oi.product_id = p.product_id " +
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
                    "oi.product_id, p.name as product_name, p.slug as product_slug, " +
                    "s.full_name as seller_name " +
                    "FROM orders o " +
                    "LEFT JOIN order_items oi ON o.order_id = oi.order_id " +
                    "LEFT JOIN products p ON oi.product_id = p.product_id " +
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
     * ✨ NEW FLOW: Tạo order với status PENDING (chưa trừ tiền)
     * CHỈ DÙNG status, KHÔNG dùng delivery_status
     */
    public Long createPendingOrder(Long buyerId, Long sellerId, Long productId, 
                                   Integer quantity, BigDecimal totalAmount, 
                                   Connection conn) throws SQLException {
        
        String sql = "INSERT INTO orders " +
                    "(buyer_id, seller_id, status, total_amount, currency, created_at) " +
                    "VALUES (?, ?, 'pending', ?, 'VND', NOW())";
        
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, buyerId);
            ps.setLong(2, sellerId);
            ps.setBigDecimal(3, totalAmount);
            
            int affected = ps.executeUpdate();
            
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        Long orderId = rs.getLong(1);
                        System.out.println("✅ Created PENDING order ID: " + orderId);
                        return orderId;
                    }
                }
            }
        }
        
        return null;
    }
    
    /**
     * Cập nhật order sang PAID (sau khi trừ tiền thành công)
     */
    public boolean updateOrderToPaid(Long orderId, String transactionId, Connection conn) throws SQLException {
        String sql = "UPDATE orders SET status = 'paid', updated_at = NOW() WHERE order_id = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Cập nhật order sang DELIVERED (sau khi giao code thành công)
     * CHỈ DÙNG status
     */
    public boolean updateOrderToDelivered(Long orderId, Connection conn) throws SQLException {
        String sql = "UPDATE orders SET status = 'delivered', updated_at = NOW() WHERE order_id = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Cập nhật order sang CANCELLED (khi hết code hoặc lỗi)
     * KHÔNG dùng notes vì table không có cột này
     */
    public boolean updateOrderToCancelled(Long orderId, String reason, Connection conn) throws SQLException {
        String sql = "UPDATE orders SET status = 'cancelled', updated_at = NOW() WHERE order_id = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Cập nhật order sang REFUNDED (khi user yêu cầu hoàn tiền)
     * KHÔNG dùng notes vì table không có cột này
     */
    public boolean updateOrderToRefunded(Long orderId, String reason, Connection conn) throws SQLException {
        String sql = "UPDATE orders SET status = 'refunded', updated_at = NOW() WHERE order_id = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * ⚠️ DEPRECATED: Không dùng delivery_status nữa, chỉ dùng status
     * Method này giữ lại để backward compatible nhưng không làm gì
     */
    @Deprecated
    public boolean updateDeliveryStatus(Long orderId, String deliveryStatus, Connection conn) throws SQLException {
        // Do nothing - không có cột delivery_status trong DB
        System.out.println("⚠️ updateDeliveryStatus is deprecated - using status only");
        return true;
    }
    
    /**
     * Cập nhật trạng thái order (legacy method - giữ lại để backward compatible)
     */
    public boolean updateOrderStatus(Long orderId, String status) {
        String sql = "UPDATE orders SET status = ?, updated_at = NOW() " +
                    "WHERE order_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setLong(2, orderId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * ✨ Lấy danh sách orders PAID nhưng chưa DELIVERED (để xử lý trong queue)
     * CHỈ DÙNG status (không dùng delivery_status)
     */
    public List<Orders> getPaidPendingDeliveryOrders(int limit) {
        List<Orders> orders = new ArrayList<>();
        
        String sql = "SELECT o.*, " +
                    "oi.product_id, p.name as product_name " +
                    "FROM orders o " +
                    "LEFT JOIN order_items oi ON o.order_id = oi.order_id " +
                    "LEFT JOIN products p ON oi.product_id = p.product_id " +
                    "WHERE o.status = 'paid' " +
                    "ORDER BY o.created_at ASC " +
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
    
    /**
     * Extract Order từ ResultSet
     */
    private Orders extractOrderFromResultSet(ResultSet rs) throws SQLException {
        Orders order = new Orders();
        
        order.setOrderId(rs.getLong("order_id"));
        order.setOrderNumber("ORD-" + rs.getLong("order_id")); // Generated, không lưu DB
        order.setBuyerId(rs.getLong("buyer_id"));
        order.setSellerId(rs.getLong("seller_id"));
        
        // ✅ 1 ORDER = 1 CODE → quantity luôn = 1
        order.setQuantity(1);
        order.setUnitPrice(rs.getBigDecimal("total_amount")); // Price 1 code = total_amount
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        order.setCurrency(rs.getString("currency"));
        
        // Status từ orders.status
        String status = rs.getString("status");
        order.setPaymentStatus(status); // paid, pending, cancelled, refunded, delivered
        order.setOrderStatus(status);
        
        // ✨ NOTE: KHÔNG dùng delivery_status nữa, chỉ dùng status
        // deliveryStatus được set = status
        order.setDeliveryStatus(status);
        
        // Product info từ JOIN order_items
        try {
            Long productIdObj = rs.getObject("product_id", Long.class);
            if (productIdObj != null) {
                order.setProductId(productIdObj);
                
                Products product = new Products();
                product.setProduct_id(productIdObj);
                
                String productName = rs.getString("product_name");
                if (productName != null) {
                    product.setName(productName);
                }
                
                String productSlug = rs.getString("product_slug");
                if (productSlug != null) {
                    product.setSlug(productSlug);
                }
                
                order.setProduct(product);
            }
        } catch (SQLException ignored) {
            // order_items might not be joined
        }
        
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
