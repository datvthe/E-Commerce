/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.order.Orders;
import model.order.OrderItems;
import model.product.Products;
import model.user.Users;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class for Order operations
 */
public class OrderDAO extends DBConnection {
    
    public int countBySeller(int sellerId) {
        String sql = "SELECT COUNT(*) FROM orders WHERE seller_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sellerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public double revenueToday(int sellerId) {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE seller_id = ? AND DATE(created_at) = CURDATE()";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sellerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get orders by seller with pagination and filters
     */
    public List<Orders> getOrdersBySeller(int sellerId, String status, int page, int pageSize) {
        List<Orders> orders = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        StringBuilder sql = new StringBuilder("SELECT o.*, b.user_id as buyer_user_id, b.full_name as buyer_name, b.email as buyer_email ");
        sql.append("FROM orders o ");
        sql.append("LEFT JOIN users b ON o.buyer_id = b.user_id ");
        sql.append("WHERE o.seller_id = ? ");
        
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND o.status = ? ");
        }
        
        sql.append("ORDER BY o.created_at DESC LIMIT ? OFFSET ?");

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            ps.setInt(paramIndex++, sellerId);
            
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(paramIndex++, status);
            }
            
            ps.setInt(paramIndex++, pageSize);
            ps.setInt(paramIndex++, offset);
            
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
                
                // Set buyer
                Users buyer = new Users();
                buyer.setUser_id(rs.getInt("buyer_user_id"));
                buyer.setFull_name(rs.getString("buyer_name"));
                buyer.setEmail(rs.getString("buyer_email"));
                order.setBuyer_id(buyer);
                
                // Set seller
                Users seller = new Users();
                seller.setUser_id(sellerId);
                order.setSeller_id(seller);
                
                orders.add(order);
            }
        } catch (Exception e) {
            System.err.println("Error getting orders by seller: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * Get order by ID with full details
     */
    public Orders getOrderById(int orderId) {
        Orders order = null;
        String sql = "SELECT o.*, b.user_id as buyer_user_id, b.full_name as buyer_name, b.email as buyer_email, " +
                    "s.user_id as seller_user_id, s.full_name as seller_name, s.email as seller_email " +
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
                
                // Set buyer
                Users buyer = new Users();
                buyer.setUser_id(rs.getInt("buyer_user_id"));
                buyer.setFull_name(rs.getString("buyer_name"));
                buyer.setEmail(rs.getString("buyer_email"));
                order.setBuyer_id(buyer);
                
                // Set seller
                Users seller = new Users();
                seller.setUser_id(rs.getInt("seller_user_id"));
                seller.setFull_name(rs.getString("seller_name"));
                seller.setEmail(rs.getString("seller_email"));
                order.setSeller_id(seller);
            }
        } catch (Exception e) {
            System.err.println("Error getting order by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return order;
    }

    /**
     * Get order items for an order
     */
    public List<OrderItems> getOrderItems(int orderId) {
        List<OrderItems> items = new ArrayList<>();
        String sql = "SELECT oi.*, p.product_id, p.name as product_name, p.price as current_price " +
                    "FROM order_items oi " +
                    "LEFT JOIN products p ON oi.product_id = p.product_id " +
                    "WHERE oi.order_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                OrderItems item = new OrderItems();
                item.setOrderItemId(rs.getInt("order_item_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPriceAtPurchase(rs.getBigDecimal("price_at_purchase"));
                item.setDiscountApplied(rs.getBigDecimal("discount_applied"));
                item.setSubtotal(rs.getBigDecimal("subtotal"));
                
                // Set product
                Products product = new Products();
                product.setProduct_id(rs.getLong("product_id"));
                product.setName(rs.getString("product_name"));
                product.setPrice(rs.getBigDecimal("current_price"));
                item.setProductId(product);
                
                items.add(item);
            }
        } catch (Exception e) {
            System.err.println("Error getting order items: " + e.getMessage());
            e.printStackTrace();
        }
        return items;
    }

    /**
     * Update order status
     */
    public boolean updateOrderStatus(int orderId, String newStatus) {
        String sql = "UPDATE orders SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE order_id = ?";
        
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error updating order status: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get order count by seller with status filter
     */
    public int getOrderCountBySeller(int sellerId, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM orders WHERE seller_id = ?");
        
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND status = ?");
        }
        
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, sellerId);
            
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(2, status);
            }
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.err.println("Error getting order count by seller: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get revenue by seller for a period
     */
    public BigDecimal getRevenueBySeller(int sellerId, String status) {
        StringBuilder sql = new StringBuilder("SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE seller_id = ?");
        
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND status = ?");
        }
        
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, sellerId);
            
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(2, status);
            }
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (Exception e) {
            System.err.println("Error getting revenue by seller: " + e.getMessage());
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }
}
