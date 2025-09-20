/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.user;

import model.user.Users;
import java.sql.Timestamp;

public class UserTokens {

    private int id;
    private Users user_id;
    private String token;
    private Timestamp expiry;

    public UserTokens() {
    }

    public UserTokens(int id, Users user_id, String token, Timestamp expiry) {
        this.id = id;
        this.user_id = user_id;
        this.token = token;
        this.expiry = expiry;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Users getUser_id() {
        return user_id;
    }

    public void setUser_id(Users user_id) {
        this.user_id = user_id;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public Timestamp getExpiry() {
        return expiry;
    }

    public void setExpiry(Timestamp expiry) {
        this.expiry = expiry;
    }

    @Override
    public String toString() {
        return "UserTokens{" + "id=" + id + ", user_id=" + user_id + ", token=" + token + ", expiry=" + expiry + '}';
    }

}
