/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.order.Orders;
import model.order.OrderItems;
import model.product.Products;
import model.user.Users;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ASUS
 */
public class OrderDAO extends DBConnection {

    // ===== Admin-wide metrics =====
    public int getTotalOrders() {
        String sql = "SELECT COUNT(*) FROM orders";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getOrdersToday() {
        String sql = "SELECT COUNT(*) FROM orders WHERE DATE(created_at) = CURDATE()";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public java.math.BigDecimal getRevenueTodayAll() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE DATE(created_at) = CURDATE()";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getBigDecimal(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return java.math.BigDecimal.ZERO;
    }

    public List<Orders> getRecentOrders(int limit) {
        List<Orders> orders = new ArrayList<>();
        String sql = "SELECT o.*, b.user_id as buyer_user_id, b.full_name as buyer_name, s.user_id as seller_user_id, s.full_name as seller_name " +
                     "FROM orders o " +
                     "LEFT JOIN users b ON o.buyer_id = b.user_id " +
                     "LEFT JOIN users s ON o.seller_id = s.user_id " +
                     "ORDER BY o.created_at DESC LIMIT ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Orders order = new Orders();
                order.setOrder_id(rs.getInt("order_id"));
                order.setStatus(rs.getString("status"));
                order.setTotal_amount(rs.getBigDecimal("total_amount"));
                order.setCurrency(rs.getString("currency"));
                order.setCreated_at(rs.getTimestamp("created_at"));
                // buyer
                Users buyer = new Users();
                buyer.setUser_id(rs.getInt("buyer_user_id"));
                buyer.setFull_name(rs.getString("buyer_name"));
                order.setBuyer_id(buyer);
                // seller
                Users seller = new Users();
                seller.setUser_id(rs.getInt("seller_user_id"));
                seller.setFull_name(rs.getString("seller_name"));
                order.setSeller_id(seller);
                orders.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public int countBySeller(int sellerId) {
        String sql = "SELECT COUNT(*) FROM Orders WHERE seller_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sellerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public double revenueToday(int sellerId) {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM Orders WHERE seller_id = ? AND DATE(order_date) = CURDATE()";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sellerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ===== Admin: list orders with pagination and optional status filter =====
    public List<Orders> getAllOrders(String status, int page, int pageSize) {
        List<Orders> orders = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT o.*, ");
        sql.append("b.user_id AS buyer_user_id, b.full_name AS buyer_name, b.email AS buyer_email, ");
        sql.append("s.user_id AS seller_user_id, s.full_name AS seller_name, s.email AS seller_email ");
        sql.append("FROM orders o ");
        sql.append("LEFT JOIN users b ON o.buyer_id = b.user_id ");
        sql.append("LEFT JOIN users s ON o.seller_id = s.user_id ");
        if (status != null && !status.trim().isEmpty()) {
            sql.append("WHERE o.status = ? ");
        }
        sql.append("ORDER BY o.created_at DESC LIMIT ? OFFSET ?");
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(idx++, status);
            }
            ps.setInt(idx++, pageSize);
            ps.setInt(idx, offset);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Orders order = new Orders();
                order.setOrder_id(rs.getInt("order_id"));
                order.setStatus(rs.getString("status"));
                order.setTotal_amount(rs.getBigDecimal("total_amount"));
                order.setCurrency(rs.getString("currency"));
                order.setShipping_address(rs.getString("shipping_address"));
                order.setShipping_method(rs.getString("shipping_method"));
                order.setTracking_number(rs.getString("tracking_number"));
                order.setCreated_at(rs.getTimestamp("created_at"));
                order.setUpdated_at(rs.getTimestamp("updated_at"));
                Users buyer = new Users();
                buyer.setUser_id(rs.getInt("buyer_user_id"));
                buyer.setFull_name(rs.getString("buyer_name"));
                buyer.setEmail(rs.getString("buyer_email"));
                order.setBuyer_id(buyer);
                Users seller = new Users();
                seller.setUser_id(rs.getInt("seller_user_id"));
                seller.setFull_name(rs.getString("seller_name"));
                seller.setEmail(rs.getString("seller_email"));
                order.setSeller_id(seller);
                orders.add(order);
            }
        } catch (Exception e) {
            System.err.println("Error getAllOrders: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    public int getOrderCount(String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM orders ");
        if (status != null && !status.trim().isEmpty()) {
            sql.append("WHERE status = ?");
        }
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(1, status);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            System.err.println("Error getOrderCount: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public boolean deleteOrder(int orderId) {
        String deleteItems = "DELETE FROM order_items WHERE order_id = ?";
        String deleteOrder = "DELETE FROM orders WHERE order_id = ?";
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps1 = conn.prepareStatement(deleteItems);
                 PreparedStatement ps2 = conn.prepareStatement(deleteOrder)) {
                ps1.setInt(1, orderId);
                ps1.executeUpdate();
                ps2.setInt(1, orderId);
                int affected = ps2.executeUpdate();
                conn.commit();
                return affected > 0;
            } catch (Exception e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (Exception e) {
            System.err.println("Error deleteOrder: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public int createOrder(Orders order) {
        String sql = "INSERT INTO orders (buyer_id, seller_id, status, total_amount, currency, shipping_address, shipping_method, tracking_number, created_at, updated_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            Users buyer = order.getBuyer_id();
            Users seller = order.getSeller_id();
            if (buyer != null) {
                ps.setInt(1, buyer.getUser_id());
            } else {
                ps.setNull(1, java.sql.Types.INTEGER);
            }
            if (seller != null) {
                ps.setInt(2, seller.getUser_id());
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            ps.setString(3, order.getStatus() == null || order.getStatus().isEmpty() ? "pending" : order.getStatus());
            ps.setBigDecimal(4, order.getTotal_amount());
            ps.setString(5, order.getCurrency());
            ps.setString(6, order.getShipping_address());
            ps.setString(7, order.getShipping_method());
            ps.setString(8, order.getTracking_number());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            System.err.println("Error createOrder: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    public Orders getOrderById(int orderId) {
        Orders order = null;
        String sql = "SELECT o.*, " +
                "b.user_id AS buyer_user_id, b.full_name AS buyer_name, b.email AS buyer_email, " +
                "s.user_id AS seller_user_id, s.full_name AS seller_name, s.email AS seller_email " +
                "FROM orders o " +
                "LEFT JOIN users b ON o.buyer_id = b.user_id " +
                "LEFT JOIN users s ON o.seller_id = s.user_id " +
                "WHERE o.order_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                order = new Orders();
                order.setOrder_id(rs.getInt("order_id"));
                order.setStatus(rs.getString("status"));
                order.setTotal_amount(rs.getBigDecimal("total_amount"));
                order.setCurrency(rs.getString("currency"));
                order.setShipping_address(rs.getString("shipping_address"));
                order.setShipping_method(rs.getString("shipping_method"));
                order.setTracking_number(rs.getString("tracking_number"));
                order.setCreated_at(rs.getTimestamp("created_at"));
                order.setUpdated_at(rs.getTimestamp("updated_at"));
                Users buyer = new Users();
                buyer.setUser_id(rs.getInt("buyer_user_id"));
                buyer.setFull_name(rs.getString("buyer_name"));
                buyer.setEmail(rs.getString("buyer_email"));
                order.setBuyer_id(buyer);
                Users seller = new Users();
                seller.setUser_id(rs.getInt("seller_user_id"));
                seller.setFull_name(rs.getString("seller_name"));
                seller.setEmail(rs.getString("seller_email"));
                order.setSeller_id(seller);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return order;
    }

    public List<OrderItems> getOrderItems(int orderId) {
        List<OrderItems> items = new ArrayList<>();
        String sql = "SELECT oi.*, p.product_id, p.name, p.price, p.currency FROM order_items oi " +
                "LEFT JOIN products p ON oi.product_id = p.product_id " +
                "WHERE oi.order_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderItems item = new OrderItems();
                item.setOrderItemId(rs.getInt("order_item_id"));
                Orders order = new Orders(); order.setOrder_id(orderId); item.setOrderId(order);
                Products product = new Products();
                product.setProduct_id(rs.getLong("product_id"));
                product.setName(rs.getString("name"));
                product.setPrice(rs.getBigDecimal("price"));
                product.setCurrency(rs.getString("currency"));
                item.setProductId(product);
                item.setQuantity(rs.getInt("quantity"));
                item.setPriceAtPurchase(rs.getBigDecimal("price_at_purchase"));
                item.setDiscountApplied(rs.getBigDecimal("discount_applied"));
                item.setSubtotal(rs.getBigDecimal("subtotal"));
                items.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return items;
    }

    public boolean updateOrderStatus(int orderId, String newStatus) {
        String sql = "UPDATE orders SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE order_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Orders> getOrdersBySeller(int sellerId, String status, int page, int pageSize) {
        List<Orders> orders = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT o.*, b.user_id AS buyer_user_id, b.full_name AS buyer_name ");
        sql.append("FROM orders o ");
        sql.append("LEFT JOIN users b ON o.buyer_id = b.user_id ");
        sql.append("WHERE o.seller_id = ? ");
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND o.status = ? ");
        }
        sql.append("ORDER BY o.created_at DESC LIMIT ? OFFSET ?");
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, sellerId);
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(idx++, status);
            }
            ps.setInt(idx++, pageSize);
            ps.setInt(idx, offset);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Orders order = new Orders();
                order.setOrder_id(rs.getInt("order_id"));
                order.setStatus(rs.getString("status"));
                order.setTotal_amount(rs.getBigDecimal("total_amount"));
                order.setCurrency(rs.getString("currency"));
                order.setCreated_at(rs.getTimestamp("created_at"));
                Users buyer = new Users();
                buyer.setUser_id(rs.getInt("buyer_user_id"));
                buyer.setFull_name(rs.getString("buyer_name"));
                order.setBuyer_id(buyer);
                orders.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public int getOrderCountBySeller(int sellerId, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM orders WHERE seller_id = ? ");
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND status = ?");
        }
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, sellerId);
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(2, status);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public BigDecimal getRevenueBySeller(int sellerId, String status) {
        StringBuilder sql = new StringBuilder("SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE seller_id = ? ");
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND status = ? ");
        }
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, sellerId);
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(2, status);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getBigDecimal(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return java.math.BigDecimal.ZERO;
    }
}
