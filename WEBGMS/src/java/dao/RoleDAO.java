/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.user.Users;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
}
