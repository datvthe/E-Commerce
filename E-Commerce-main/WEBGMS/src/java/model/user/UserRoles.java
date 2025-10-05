/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.user;

import model.user.Roles;
import model.user.Users;
import java.sql.Timestamp;

public class UserRoles {

    private int user_role_id;
    private Users user_id;
    private Roles role_id;
    private Timestamp assigned_at;

    public UserRoles() {
    }

    public UserRoles(int user_role_id, Users user_id, Roles role_id, Timestamp assigned_at) {
        this.user_role_id = user_role_id;
        this.user_id = user_id;
        this.role_id = role_id;
        this.assigned_at = assigned_at;
    }

    public int getUser_role_id() {
        return user_role_id;
    }

    public void setUser_role_id(int user_role_id) {
        this.user_role_id = user_role_id;
    }

    public Users getUser_id() {
        return user_id;
    }

    public void setUser_id(Users user_id) {
        this.user_id = user_id;
    }

    public Roles getRole_id() {
        return role_id;
    }

    public void setRole_id(Roles role_id) {
        this.role_id = role_id;
    }

    public Timestamp getAssigned_at() {
        return assigned_at;
    }

    public void setAssigned_at(Timestamp assigned_at) {
        this.assigned_at = assigned_at;
    }

    @Override
    public String toString() {
        return "UserRoles{" + "user_role_id=" + user_role_id + ", user_id=" + user_id + ", role_id=" + role_id + ", assigned_at=" + assigned_at + '}';
    }

}
