package dao;

import model.order.Orders;
import model.order.OrderItems;
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
     * Tạo đơn hàng PENDING (khởi tạo khi khách bấm Thanh toán - chờ gateway)
     */
    public Long createPendingOrder(Long buyerId, Long sellerId, Long productId,
                                   Integer quantity, java.math.BigDecimal unitPrice,
                                   java.math.BigDecimal totalAmount, String paymentMethod) throws SQLException {
        String orderNumber = generateOrderNumber();
        String sql = "INSERT INTO orders (order_number, buyer_id, seller_id, product_id, quantity, unit_price, total_amount, currency, payment_method, payment_status, order_status, delivery_status, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, 'VND', ?, 'PENDING', 'PENDING', 'INSTANT', NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, orderNumber);
            ps.setLong(2, buyerId);
            ps.setLong(3, sellerId);
            ps.setLong(4, productId);
            ps.setInt(5, quantity);
            ps.setBigDecimal(6, unitPrice);
            ps.setBigDecimal(7, totalAmount);
            ps.setString(8, paymentMethod != null ? paymentMethod : "GATEWAY");
            int affected = ps.executeUpdate();
            if (affected > 0) { try (ResultSet rs = ps.getGeneratedKeys()) { if (rs.next()) return rs.getLong(1); } }
        } catch (SQLException e) {
            // Legacy fallback (no product columns)
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO orders (buyer_id, seller_id, total_amount, currency, status, created_at) VALUES (?, ?, ?, 'VND', 'pending', NOW())",
                    Statement.RETURN_GENERATED_KEYS)) {
                ps.setLong(1, buyerId);
                ps.setLong(2, sellerId);
                ps.setBigDecimal(3, totalAmount);
                if (ps.executeUpdate() > 0) { try (ResultSet rs = ps.getGeneratedKeys()) { if (rs.next()) return rs.getLong(1); } }
            }
        }
        return null;
    }

    /**
     * Thêm 1 order_item cho đơn (idempotent đơn giản theo cặp order_id, product_id, quantity)
     */
    public void addOrderItem(long orderId, long productId, int quantity, java.math.BigDecimal unitPrice) throws SQLException {
        String sql = "INSERT INTO order_items (order_id, product_id, quantity, unit_price, total_price) VALUES (?, ?, ?, ?, ? )";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            ps.setLong(2, productId);
            ps.setInt(3, quantity);
            ps.setBigDecimal(4, unitPrice);
            ps.setBigDecimal(5, unitPrice.multiply(new java.math.BigDecimal(quantity)));
            ps.executeUpdate();
        } catch (SQLException ignore) { /* table may differ; ignore silently */ }
    }

    /**
     * Đánh dấu đơn đã thanh toán qua cổng (gateway callback)
     */
    public boolean markOrderPaid(Long orderId, String transactionId, String method) {
        String sql = "UPDATE orders SET payment_status='PAID', order_status='PAID', payment_method = COALESCE(?, payment_method), transaction_id = ?, updated_at = NOW() WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, method);
            ps.setString(2, transactionId);
            ps.setLong(3, orderId);
            int ok = ps.executeUpdate();
            if (ok > 0) return true;
        } catch (SQLException e) {
            // Legacy update
            try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement("UPDATE orders SET status='paid', updated_at = NOW() WHERE order_id = ?")) {
                ps.setLong(1, orderId);
                return ps.executeUpdate() > 0;
            } catch (SQLException ignored) {}
        }
        return false;
    }

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
        
        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
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
                        if (rs.next()) return rs.getLong(1);
                    }
                }
            } catch (SQLException e) {
                // Fallback for legacy schema without order_number/product_id/quantity, etc.
                String legacy = "INSERT INTO orders (buyer_id, seller_id, total_amount, currency, status, created_at) " +
                                "VALUES (?, ?, ?, 'VND', 'paid', NOW())";
                try (PreparedStatement ps2 = conn.prepareStatement(legacy, Statement.RETURN_GENERATED_KEYS)) {
                    ps2.setLong(1, buyerId);
                    ps2.setLong(2, sellerId);
                    ps2.setBigDecimal(3, totalAmount);
                    int affected2 = ps2.executeUpdate();
                    if (affected2 > 0) {
                        try (ResultSet rs = ps2.getGeneratedKeys()) {
                            if (rs.next()) return rs.getLong(1);
                        }
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
            // Fallback when legacy schema doesn't have product_id or joined columns
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                    "SELECT o.*, b.email as buyer_email, b.full_name as buyer_name, " +
                    "s.email as seller_email, s.full_name as seller_name " +
                    "FROM orders o " +
                    "LEFT JOIN users b ON o.buyer_id = b.user_id " +
                    "LEFT JOIN users s ON o.seller_id = s.user_id " +
                    "WHERE o.order_id = ?")) {
                ps.setLong(1, orderId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) return extractOrderFromResultSet(rs);
                }
            } catch (SQLException ignored) {
                ignored.printStackTrace();
            }
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
        String sql = "UPDATE orders SET order_status = ?, queue_status = ?, processed_at = IF(? = 'COMPLETED', NOW(), processed_at) WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, orderStatus);
                ps.setString(2, queueStatus);
                ps.setString(3, queueStatus);
                ps.setLong(4, orderId);
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                // Fallback for legacy schema that only has 'status' (often ENUM with values like 'pending','paid','delivered','cancelled','refunded')
                String legacyStatus = mapLegacyStatus(orderStatus);
                try (PreparedStatement ps2 = conn.prepareStatement("UPDATE orders SET status = ? WHERE order_id = ?")) {
                    ps2.setString(1, legacyStatus);
                    ps2.setLong(2, orderId);
                    return ps2.executeUpdate() > 0;
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    // Map new statuses to legacy 'status' column values
    private String mapLegacyStatus(String orderStatus) {
        if (orderStatus == null) return "pending";
        String s = orderStatus.trim().toUpperCase();
        switch (s) {
            case "COMPLETED":
                return "delivered"; // legacy delivered = completed
            case "PROCESSING":
                return "pending"; // legacy has no processing
            case "FAILED":
                return "cancelled";
            case "CANCELED":
            case "CANCELLED":
                return "cancelled";
            case "REFUNDED":
                return "refunded";
            case "PAID":
                return "paid";
            default:
                return s.toLowerCase();
        }
    }
    
    /**
     * Extract Order từ ResultSet
     */
    private Orders extractOrderFromResultSet(ResultSet rs) throws SQLException {
        Orders order = new Orders();
        
        order.setOrderId(rs.getLong("order_id"));
        try { order.setOrderNumber(rs.getString("order_number")); } catch (SQLException ignore) {}
        order.setBuyerId(rs.getLong("buyer_id"));
        order.setSellerId(rs.getLong("seller_id"));
        try { order.setProductId(rs.getLong("product_id")); } catch (SQLException ignore) {}
        try { order.setQuantity(rs.getInt("quantity")); } catch (SQLException ignore) {}
        try { order.setUnitPrice(rs.getBigDecimal("unit_price")); } catch (SQLException ignore) {}
        try { order.setTotalAmount(rs.getBigDecimal("total_amount")); } catch (SQLException ignore) {}
        try { order.setCurrency(rs.getString("currency")); } catch (SQLException ignore) {}
        try { order.setPaymentMethod(rs.getString("payment_method")); } catch (SQLException ignore) {}
        try { order.setPaymentStatus(rs.getString("payment_status")); } catch (SQLException ignore) {}
        try { order.setOrderStatus(rs.getString("order_status")); } catch (SQLException ignore) {}
        try { if (order.getOrderStatus() == null) order.setOrderStatus(rs.getString("status")); } catch (SQLException ignore) {}
        try { order.setDeliveryStatus(rs.getString("delivery_status")); } catch (SQLException ignore) {}
        try { order.setTransactionId(rs.getString("transaction_id")); } catch (SQLException ignore) {}
        try { order.setQueueStatus(rs.getString("queue_status")); } catch (SQLException ignore) {}
        try { order.setProcessedAt(rs.getTimestamp("processed_at")); } catch (SQLException ignore) {}
        order.setCreatedAt(rs.getTimestamp("created_at"));
        try { order.setUpdatedAt(rs.getTimestamp("updated_at")); } catch (SQLException ignore) {}
        
        // Joined data (if available)
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
        try {
            if (rs.getString("product_name") != null) {
                Products product = new Products();
                product.setProduct_id(rs.getLong("product_id"));
                product.setName(rs.getString("product_name"));
                product.setSlug(rs.getString("product_slug"));
                order.setProduct(product);
            }
        } catch (SQLException ignored) {}
        
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
     * Lấy orders hiển thị cho Admin (chỉ Paid/Completed)
     */
    public List<Orders> getAdminVisibleOrders(int page, int pageSize) {
        List<Orders> list = new ArrayList<>();
        String orderStatusExpr = "COALESCE(o.status, o.order_status)";
        String sql = "SELECT " +
                "o.order_id, NULL AS order_number, o.buyer_id, o.seller_id, " +
                "NULL AS product_id, NULL AS quantity, NULL AS unit_price, " +
                "o.total_amount, o.currency, o.payment_method, o.payment_status, " +
                orderStatusExpr + " AS order_status, o.delivery_status, o.transaction_id, o.queue_status, " +
                "o.processed_at, o.created_at, o.updated_at, " +
                "b.email AS buyer_email, b.full_name AS buyer_name, " +
                "s.email AS seller_email, s.full_name AS seller_name, " +
                "NULL AS product_name, NULL AS product_slug " +
                "FROM orders o " +
                "LEFT JOIN users b ON o.buyer_id = b.user_id " +
                "LEFT JOIN users s ON o.seller_id = s.user_id " +
                "WHERE (UPPER(COALESCE(o.payment_status,'')) = 'PAID' OR LOWER(" + orderStatusExpr + ") IN ('paid','completed','delivered')) " +
                "ORDER BY o.created_at DESC LIMIT ? OFFSET ?";
        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, pageSize);
                ps.setInt(2, (page - 1) * pageSize);
                try (ResultSet rs = ps.executeQuery()) { while (rs.next()) list.add(extractOrderFromResultSet(rs)); }
                return list;
            } catch (SQLException primary) {
                // Legacy fallback: no payment_status/order_number columns
                String legacy = "SELECT " +
                        "o.order_id, NULL AS order_number, o.buyer_id, o.seller_id, " +
                        "NULL AS product_id, NULL AS quantity, NULL AS unit_price, " +
                        "o.total_amount, o.currency, NULL AS payment_method, NULL AS payment_status, " +
                        "o.status AS order_status, o.delivery_status, NULL AS transaction_id, NULL AS queue_status, " +
                        "NULL AS processed_at, o.created_at, o.updated_at, " +
                        "b.email AS buyer_email, b.full_name AS buyer_name, " +
                        "s.email AS seller_email, s.full_name AS seller_name, " +
                        "NULL AS product_name, NULL AS product_slug " +
                        "FROM orders o " +
                        "LEFT JOIN users b ON o.buyer_id = b.user_id " +
                        "LEFT JOIN users s ON o.seller_id = s.user_id " +
                        "WHERE LOWER(o.status) IN ('paid','delivered') " +
                        "ORDER BY o.created_at DESC LIMIT ? OFFSET ?";
                try (PreparedStatement ps2 = conn.prepareStatement(legacy)) {
                    ps2.setInt(1, pageSize);
                    ps2.setInt(2, (page - 1) * pageSize);
                    try (ResultSet rs = ps2.executeQuery()) { while (rs.next()) list.add(extractOrderFromResultSet(rs)); }
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
    public int getAdminVisibleOrderCount() {
        String orderStatusExpr = "COALESCE(status, order_status)";
        String sql = "SELECT COUNT(*) FROM orders WHERE (UPPER(COALESCE(payment_status,'')) = 'PAID' OR LOWER(" + orderStatusExpr + ") IN ('paid','completed','delivered'))";
        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            } catch (SQLException primary) {
                String legacy = "SELECT COUNT(*) FROM orders WHERE LOWER(status) IN ('paid','delivered')";
                try (PreparedStatement ps2 = conn.prepareStatement(legacy); ResultSet rs2 = ps2.executeQuery()) {
                    if (rs2.next()) return rs2.getInt(1);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    /**
     * Lấy recent orders (admin dashboard)
     */
    public List<Orders> getRecentOrders(int limit) {
        List<Orders> orders = new ArrayList<>();
        
        String sql = "SELECT " +
                "o.order_id, o.order_number, o.buyer_id, o.seller_id, " +
                "NULL AS product_id, NULL AS quantity, NULL AS unit_price, " +
                "o.total_amount, o.currency, o.payment_method, NULL AS payment_status, " +
                "o.status AS order_status, o.delivery_status, NULL AS transaction_id, NULL AS queue_status, " +
                "NULL AS processed_at, o.created_at, o.updated_at, " +
                "b.email AS buyer_email, b.full_name AS buyer_name, " +
                "s.email AS seller_email, s.full_name AS seller_name, " +
                "NULL AS product_name, NULL AS product_slug " +
                "FROM orders o " +
                "LEFT JOIN users b ON o.buyer_id = b.user_id " +
                "LEFT JOIN users s ON o.seller_id = s.user_id " +
                "ORDER BY o.created_at DESC LIMIT ?";
        
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

    // Overload for controllers using int orderId
    public Orders getOrderById(int orderId) {
        final String orderStatusExpr = "COALESCE(o.status, o.order_status)";
        String sql = "SELECT " +
                "o.order_id, NULL AS order_number, o.buyer_id, o.seller_id, " +
                "NULL AS product_id, NULL AS quantity, NULL AS unit_price, " +
                "o.total_amount, o.currency, o.payment_method, COALESCE(o.payment_status, NULL) AS payment_status, " +
                orderStatusExpr + " AS order_status, COALESCE(o.delivery_status, NULL) AS delivery_status, COALESCE(o.transaction_id, NULL) AS transaction_id, COALESCE(o.queue_status, NULL) AS queue_status, " +
                "NULL AS processed_at, o.created_at, COALESCE(o.updated_at, o.created_at) AS updated_at, " +
                "b.email AS buyer_email, b.full_name AS buyer_name, " +
                "s.email AS seller_email, s.full_name AS seller_name, " +
                "NULL AS product_name, NULL AS product_slug " +
                "FROM orders o " +
                "LEFT JOIN users b ON o.buyer_id = b.user_id " +
                "LEFT JOIN users s ON o.seller_id = s.user_id " +
                "WHERE o.order_id = ?";
        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, orderId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return extractOrderFromResultSet(rs);
                    }
                }
            } catch (SQLException primary) {
                // Legacy fallback: schema with only 'status' and no payment/queue columns
                String legacy = "SELECT " +
                        "o.order_id, NULL AS order_number, o.buyer_id, o.seller_id, " +
                        "NULL AS product_id, NULL AS quantity, NULL AS unit_price, " +
                        "o.total_amount, o.currency, NULL AS payment_method, NULL AS payment_status, " +
                        "o.status AS order_status, NULL AS delivery_status, NULL AS transaction_id, NULL AS queue_status, " +
                        "NULL AS processed_at, o.created_at, NULL AS updated_at, " +
                        "b.email AS buyer_email, b.full_name AS buyer_name, " +
                        "s.email AS seller_email, s.full_name AS seller_name, " +
                        "NULL AS product_name, NULL AS product_slug " +
                        "FROM orders o " +
                        "LEFT JOIN users b ON o.buyer_id = b.user_id " +
                        "LEFT JOIN users s ON o.seller_id = s.user_id " +
                        "WHERE o.order_id = ?";
                try (PreparedStatement ps2 = conn.prepareStatement(legacy)) {
                    ps2.setInt(1, orderId);
                    try (ResultSet rs2 = ps2.executeQuery()) { if (rs2.next()) return extractOrderFromResultSet(rs2); }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Top buyer by number of orders (ties broken by total amount)
    public model.analytics.TopBuyerStats getTopBuyerByOrders() {
        String sql = "SELECT o.buyer_id, u.full_name, u.email, COUNT(*) AS orders, COALESCE(SUM(o.total_amount),0) AS total " +
                     "FROM orders o JOIN users u ON u.user_id = o.buyer_id " +
                     "GROUP BY o.buyer_id, u.full_name, u.email " +
                     "ORDER BY orders DESC, total DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                model.analytics.TopBuyerStats s = new model.analytics.TopBuyerStats();
                s.setUserId(rs.getInt("buyer_id"));
                s.setFullName(rs.getString("full_name"));
                s.setEmail(rs.getString("email"));
                s.setOrders(rs.getInt("orders"));
                s.setTotalAmount(rs.getBigDecimal("total"));
                return s;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Top N buyers by number of orders
    public java.util.List<model.analytics.TopBuyerStats> getTopBuyersByOrders(int limit) {
        java.util.List<model.analytics.TopBuyerStats> list = new java.util.ArrayList<>();
        String sql = "SELECT o.buyer_id, u.full_name, u.email, COUNT(*) AS orders, COALESCE(SUM(o.total_amount),0) AS total " +
                     "FROM orders o JOIN users u ON u.user_id = o.buyer_id " +
                     "GROUP BY o.buyer_id, u.full_name, u.email " +
                     "ORDER BY orders DESC, total DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    model.analytics.TopBuyerStats s = new model.analytics.TopBuyerStats();
                    s.setUserId(rs.getInt("buyer_id"));
                    s.setFullName(rs.getString("full_name"));
                    s.setEmail(rs.getString("email"));
                    s.setOrders(rs.getInt("orders"));
                    s.setTotalAmount(rs.getBigDecimal("total"));
                    list.add(s);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Wrapper to keep backward compatibility with controllers calling (int, String)
    public boolean updateOrderStatus(int orderId, String orderStatus) {
        return updateOrderStatus((long) orderId, orderStatus, "PROCESSING");
    }

    public boolean deleteOrder(int orderId) {
        String sql = "DELETE FROM orders WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int createOrder(Orders order) {
        String sql = "INSERT INTO orders (buyer_id, seller_id, order_number, total_amount, currency, status, created_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, NOW())";
        String orderNumber = generateOrderNumber();
        Long buyerId = order.getBuyerId() != null ? order.getBuyerId() : (order.getBuyer() != null ? Long.valueOf(order.getBuyer().getUser_id()) : null);
        Long sellerId = order.getSellerId() != null ? order.getSellerId() : (order.getSeller() != null ? Long.valueOf(order.getSeller().getUser_id()) : null);
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, buyerId != null ? buyerId : 0L);
            ps.setLong(2, sellerId != null ? sellerId : 0L);
            ps.setString(3, orderNumber);
            ps.setBigDecimal(4, order.getTotalAmount());
            ps.setString(5, order.getCurrency() != null ? order.getCurrency() : "VND");
            ps.setString(6, order.getOrderStatus() != null ? order.getOrderStatus() : "pending");
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<OrderItems> getOrderItems(int orderId) {
        List<OrderItems> items = new ArrayList<>();
        String sql = "SELECT oi.*, p.name AS product_name, p.slug AS product_slug FROM order_items oi " +
                "LEFT JOIN products p ON oi.product_id = p.product_id WHERE oi.order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItems item = new OrderItems();
                    // Handle different PK column names across schemas
                    try { item.setOrderItemId(rs.getInt("order_item_id")); } catch (SQLException ignored) { item.setOrderItemId(rs.getInt("item_id")); }
                    Orders orderRef = new Orders();
                    orderRef.setOrderId(rs.getLong("order_id"));
                    item.setOrderId(orderRef);
                    Products product = new Products();
                    product.setProduct_id(rs.getLong("product_id"));
                    product.setName(rs.getString("product_name"));
                    product.setSlug(rs.getString("product_slug"));
                    item.setProductId(product);
                    try { item.setQuantity(rs.getInt("quantity")); } catch (SQLException ignored) { item.setQuantity(1); }
                    try { item.setPriceAtPurchase(rs.getBigDecimal("unit_price")); } catch (SQLException ignored) { item.setPriceAtPurchase(BigDecimal.ZERO); }
                    try { item.setSubtotal(rs.getBigDecimal("total_price")); } catch (SQLException ignored) { item.setSubtotal(BigDecimal.ZERO); }
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    public List<Orders> getAllOrders(String status, int page, int pageSize) {
        List<Orders> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        final String orderStatusExpr = "COALESCE(o.status, o.order_status)";
        sql.append("SELECT ")
           .append("o.order_id, NULL AS order_number, o.buyer_id, o.seller_id, ")
           .append("NULL AS product_id, NULL AS quantity, NULL AS unit_price, ")
           .append("o.total_amount, o.currency, o.payment_method, COALESCE(o.payment_status, NULL) AS payment_status, ")
           .append(orderStatusExpr + " AS order_status, COALESCE(o.delivery_status, NULL) AS delivery_status, COALESCE(o.transaction_id, NULL) AS transaction_id, COALESCE(o.queue_status, NULL) AS queue_status, ")
           .append("NULL AS processed_at, o.created_at, COALESCE(o.updated_at, o.created_at) AS updated_at, ")
           .append("b.email AS buyer_email, b.full_name AS buyer_name, ")
           .append("s.email AS seller_email, s.full_name AS seller_name, ")
           .append("NULL AS product_name, NULL AS product_slug ")
           .append("FROM orders o ")
           .append("LEFT JOIN users b ON o.buyer_id = b.user_id ")
           .append("LEFT JOIN users s ON o.seller_id = s.user_id ");
        if (status != null && !status.trim().isEmpty() && !"all".equalsIgnoreCase(status)) {
            // Filter by either legacy 'status' or new 'order_status'
            sql.append("WHERE LOWER(" + orderStatusExpr + ") = LOWER(?) ");
        }
        sql.append("ORDER BY o.created_at DESC LIMIT ? OFFSET ?");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (status != null && !status.trim().isEmpty() && !"all".equalsIgnoreCase(status)) {
                ps.setString(idx++, status);
            }
            ps.setInt(idx++, pageSize);
            ps.setInt(idx, (page - 1) * pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractOrderFromResultSet(rs));
                }
            }
        } catch (SQLException primary) {
            // Legacy-safe fallback: select minimal guaranteed columns
            try (Connection conn = DBConnection.getConnection()) {
                StringBuilder legacy = new StringBuilder();
                legacy.append("SELECT ")
                      .append("o.order_id, NULL AS order_number, o.buyer_id, o.seller_id, ")
                      .append("NULL AS product_id, NULL AS quantity, NULL AS unit_price, ")
                      .append("o.total_amount, o.currency, NULL AS payment_method, NULL AS payment_status, ")
                      .append("o.status AS order_status, NULL AS delivery_status, NULL AS transaction_id, NULL AS queue_status, ")
                      .append("NULL AS processed_at, o.created_at, NULL AS updated_at, ")
                      .append("b.email AS buyer_email, b.full_name AS buyer_name, ")
                      .append("s.email AS seller_email, s.full_name AS seller_name, ")
                      .append("NULL AS product_name, NULL AS product_slug ")
                      .append("FROM orders o ")
                      .append("LEFT JOIN users b ON o.buyer_id = b.user_id ")
                      .append("LEFT JOIN users s ON o.seller_id = s.user_id ");
                if (status != null && !status.trim().isEmpty() && !"all".equalsIgnoreCase(status)) {
                    legacy.append("WHERE LOWER(o.status) = LOWER(?) ");
                }
                legacy.append("ORDER BY o.created_at DESC LIMIT ? OFFSET ?");
                try (PreparedStatement ps2 = conn.prepareStatement(legacy.toString())) {
                    int i = 1;
                    if (status != null && !status.trim().isEmpty() && !"all".equalsIgnoreCase(status)) {
                        ps2.setString(i++, status);
                    }
                    ps2.setInt(i++, pageSize);
                    ps2.setInt(i, (page - 1) * pageSize);
                    try (ResultSet rs = ps2.executeQuery()) { while (rs.next()) list.add(extractOrderFromResultSet(rs)); }
                }
            } catch (SQLException ignored) { ignored.printStackTrace(); }
        }
        return list;
    }

    public int getOrderCount(String status) {
        // Count by combined legacy/new status column where possible
        String orderStatusExpr = "COALESCE(status, order_status)";
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM orders");
        if (status != null && !status.trim().isEmpty() && !"all".equalsIgnoreCase(status)) {
            sql.append(" WHERE LOWER(" + orderStatusExpr + ") = LOWER(?)");
        }
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (status != null && !status.trim().isEmpty() && !"all".equalsIgnoreCase(status)) {
                ps.setString(1, status);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException primary) {
            // Fallback for very old schema: count all
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps2 = conn.prepareStatement("SELECT COUNT(*) FROM orders");
                 ResultSet rs2 = ps2.executeQuery()) {
                if (rs2.next()) return rs2.getInt(1);
            } catch (SQLException ignored) { ignored.printStackTrace(); }
        }
        return 0;
    }

    public List<Orders> getOrdersBySeller(int sellerUserId, String status, int page, int pageSize) {
        List<Orders> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        final String orderStatusExpr = "COALESCE(o.status, o.order_status)";
        sql.append("SELECT ")
           .append("o.order_id, NULL AS order_number, o.buyer_id, o.seller_id, ")
           .append("NULL AS product_id, NULL AS quantity, NULL AS unit_price, ")
           .append("o.total_amount, o.currency, o.payment_method, NULL AS payment_status, ")
           .append(orderStatusExpr + " AS order_status, o.delivery_status, NULL AS transaction_id, NULL AS queue_status, ")
           .append("NULL AS processed_at, o.created_at, o.updated_at, ")
           .append("b.email AS buyer_email, b.full_name AS buyer_name, ")
           .append("s.email AS seller_email, s.full_name AS seller_name, ")
           .append("NULL AS product_name, NULL AS product_slug ")
           .append("FROM orders o ")
           .append("LEFT JOIN users b ON o.buyer_id = b.user_id ")
           .append("LEFT JOIN users s ON o.seller_id = s.user_id ")
           .append("WHERE o.seller_id = ? ");
        if (status != null && !status.trim().isEmpty() && !"all".equalsIgnoreCase(status)) {
            sql.append("AND LOWER(" + orderStatusExpr + ") = LOWER(?) ");
        }
        sql.append("ORDER BY o.created_at DESC LIMIT ? OFFSET ?");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, sellerUserId);
            if (status != null && !status.trim().isEmpty() && !"all".equalsIgnoreCase(status)) {
                ps.setString(idx++, status);
            }
            ps.setInt(idx++, pageSize);
            ps.setInt(idx, (page - 1) * pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(extractOrderFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getOrderCountBySeller(int sellerUserId, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM orders WHERE seller_id = ?");
        final String orderStatusExpr = "COALESCE(status, order_status)";
        if (status != null && !status.trim().isEmpty() && !"all".equalsIgnoreCase(status)) {
            sql.append(" AND LOWER(" + orderStatusExpr + ") = LOWER(?)");
        }
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, sellerUserId);
            if (status != null && !status.trim().isEmpty() && !"all".equalsIgnoreCase(status)) {
                ps.setString(2, status);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public double revenueToday(int sellerUserId) {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE seller_id = ? AND DATE(created_at) = CURDATE() AND status IN ('paid','delivered')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sellerUserId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getBigDecimal(1).doubleValue();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public BigDecimal getRevenueBySeller(int sellerUserId, String status) {
        StringBuilder sql = new StringBuilder("SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE seller_id = ?");
        if (status != null && !status.trim().isEmpty() && !"all".equalsIgnoreCase(status)) {
            sql.append(" AND LOWER(status) = LOWER(?)");
        } else {
            sql.append(" AND status IN ('paid','delivered')");
        }
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, sellerUserId);
            if (status != null && !status.trim().isEmpty() && !"all".equalsIgnoreCase(status)) {
                ps.setString(2, status);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }
}
