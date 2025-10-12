/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.user.Users;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.user.Roles;
import model.user.UserRoles;

import model.user.Roles;

public class RoleDAO extends DBConnection {

    public Roles getRoleById(int roleId) {
        Roles role = null;
        String sql = "SELECT * FROM Roles WHERE role_id = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roleId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                role = new Roles();
                role.setRole_id(rs.getInt("role_id"));
                role.setRole_name(rs.getString("role_name"));
                role.setDescription(rs.getString("description"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return role;
    }
    
    public Roles getRoleByName(String roleName) {
        Roles role = null;
        String sql = "SELECT * FROM Roles WHERE role_name = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, roleName);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                role = new Roles();
                role.setRole_id(rs.getInt("role_id"));
                role.setRole_name(rs.getString("role_name"));
                role.setDescription(rs.getString("description"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return role;
    }
    
    public List<Roles> getAllRoles() {
        List<Roles> roles = new ArrayList<>();
        String sql = "SELECT * FROM Roles ORDER BY role_id";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Roles role = new Roles();
                role.setRole_id(rs.getInt("role_id"));
                role.setRole_name(rs.getString("role_name"));
                role.setDescription(rs.getString("description"));
                roles.add(role);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return roles;
    }
    
    public boolean assignRoleToUser(int userId, int roleId) {
        String sql = "INSERT INTO User_Roles (user_id, role_id, assigned_at) VALUES (?, ?, NOW())";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, roleId);
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean removeRoleFromUser(int userId, int roleId) {
        String sql = "DELETE FROM User_Roles WHERE user_id = ? AND role_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, roleId);
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updateUserRole(int userId, int newRoleId) {
        String sql = "UPDATE User_Roles SET role_id = ?, assigned_at = NOW() WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, newRoleId);
            ps.setInt(2, userId);
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<UserRoles> getUsersByRole(int roleId) {
        List<UserRoles> userRoles = new ArrayList<>();
        String sql = "SELECT ur.*, u.full_name, u.email FROM User_Roles ur " +
                    "JOIN Users u ON ur.user_id = u.user_id " +
                    "WHERE ur.role_id = ? ORDER BY ur.assigned_at DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                UserRoles userRole = new UserRoles();
                userRole.setUser_role_id(rs.getInt("user_role_id"));
                userRole.setAssigned_at(rs.getTimestamp("assigned_at"));
                
                // Set user info
                Users user = new Users();
                user.setUser_id(rs.getInt("user_id"));
                user.setFull_name(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                userRole.setUser_id(user);
                
                // Set role info
                Roles role = getRoleById(roleId);
                userRole.setRole_id(role);
                
                userRoles.add(userRole);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return userRoles;
    }
}
