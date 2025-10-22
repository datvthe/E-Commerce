/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
/**
 *
 * @author ASUS
 */
public class OrderDAO extends DBConnection{
    public int countBySeller(int sellerId) {
    String sql = "SELECT COUNT(*) FROM Orders WHERE seller_id = ?";
    try (Connection conn = (Connection) DBConnection.getConnection();
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
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, sellerId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) return rs.getDouble(1);
    } catch (Exception e) {
        e.printStackTrace();
    }
    return 0;
}
}
