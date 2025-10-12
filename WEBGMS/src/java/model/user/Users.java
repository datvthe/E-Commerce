/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.user;

import java.sql.Date;

public class Users {

    private int user_id;
    private String full_name;
    private String email;
    private String password;
    private String phone_number;
    private String gender;          // male, female, other
    private Date date_of_birth;
    private String address;
    private String avatar_url;
    private String status;          // active, inactive, banned, pending
    private boolean email_verified;
    private Date last_login_at;
    private Date created_at;
    private Date updated_at;
    private Date deleted_at;

    public Users() {
    }

    public Users(int user_id, String full_name, String email, String password, String phone_number, String gender, Date date_of_birth, String address, String avatar_url, String status, boolean email_verified, Date last_login_at, Date created_at, Date updated_at, Date deleted_at) {
        this.user_id = user_id;
        this.full_name = full_name;
        this.email = email;
        this.password = password;
        this.phone_number = phone_number;
        this.gender = gender;
        this.date_of_birth = date_of_birth;
        this.address = address;
        this.avatar_url = avatar_url;
        this.status = status;
        this.email_verified = email_verified;
        this.last_login_at = last_login_at;
        this.created_at = created_at;
        this.updated_at = updated_at;
        this.deleted_at = deleted_at;
    }

    // Additional camelCase accessors to improve Java ergonomics while preserving existing API
    public int getUserId() {
        return user_id;
    }

    public void setUserId(int userId) {
        this.user_id = userId;
    }

    public String getFullName() {
        return full_name;
    }

    public void setFullName(String fullName) {
        this.full_name = fullName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPhoneNumber() {
        return phone_number;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phone_number = phoneNumber;
    }

    public Date getDateOfBirth() {
        return date_of_birth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.date_of_birth = dateOfBirth;
    }

    public String getAvatarUrl() {
        return avatar_url;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatar_url = avatarUrl;
    }

    public boolean getEmailVerified() {
        return email_verified;
    }

    public Date getLastLoginAt() {
        return last_login_at;
    }

    public void setLastLoginAt(Date lastLoginAt) {
        this.last_login_at = lastLoginAt;
    }

    public Date getCreatedAt() {
        return created_at;
    }

    public void setCreatedAt(Date createdAt) {
        this.created_at = createdAt;
    }

    public Date getUpdatedAt() {
        return updated_at;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updated_at = updatedAt;
    }

    public Date getDeletedAt() {
        return deleted_at;
    }

    public void setDeletedAt(Date deletedAt) {
        this.deleted_at = deletedAt;
    }

    @Override
    public int hashCode() {
        return Integer.hashCode(user_id);
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Users other = (Users) obj;
        return this.user_id == other.user_id;
    }

    public String getFull_name() {
        return full_name;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public void setFull_name(String full_name) {
        this.full_name = full_name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword_hash() {
        return password;
    }

    public void setPassword_hash(String password_hash) {
        this.password = password_hash;
    }

    public String getPhone_number() {
        return phone_number;
    }

    public void setPhone_number(String phone_number) {
        this.phone_number = phone_number;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Date getDate_of_birth() {
        return date_of_birth;
    }

    public void setDate_of_birth(Date date_of_birth) {
        this.date_of_birth = date_of_birth;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getAvatar_url() {
        return avatar_url;
    }

    public void setAvatar_url(String avatar_url) {
        this.avatar_url = avatar_url;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isEmail_verified() {
        return email_verified;
    }

    public void setEmail_verified(boolean email_verified) {
        this.email_verified = email_verified;
    }

    public Date getLast_login_at() {
        return last_login_at;
    }

    public void setLast_login_at(Date last_login_at) {
        this.last_login_at = last_login_at;
    }

    public Date getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Date created_at) {
        this.created_at = created_at;
    }

    public Date getUpdated_at() {
        return updated_at;
    }

    public void setUpdated_at(Date updated_at) {
        this.updated_at = updated_at;
    }

    public Date getDeleted_at() {
        return deleted_at;
    }

    public void setDeleted_at(Date deleted_at) {
        this.deleted_at = deleted_at;
    }

    @Override
    public String toString() {
        return "Users{"
                + "user_id=" + user_id
                + ", full_name=" + full_name
                + ", email=" + email
                + ", password=***"
                + ", phone_number=" + phone_number
                + ", gender=" + gender
                + ", date_of_birth=" + date_of_birth
                + ", address=" + address
                + ", avatar_url=" + avatar_url
                + ", status=" + status
                + ", email_verified=" + email_verified
                + ", last_login_at=" + last_login_at
                + ", created_at=" + created_at
                + ", updated_at=" + updated_at
                + ", deleted_at=" + deleted_at
                + '}';
    }

}
