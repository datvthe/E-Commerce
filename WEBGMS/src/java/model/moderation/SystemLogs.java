/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.moderation;

import model.user.Users;
import java.time.LocalDateTime;

public class SystemLogs {

    private int logId;
    private Users userId;        
    private String action;     
    private String ipAddress;
    private String deviceInfo;   
    private String details;     
    private LocalDateTime createdAt;

    public SystemLogs() {
    }

    public SystemLogs(int logId, Users userId, String action, String ipAddress, String deviceInfo, String details, LocalDateTime createdAt) {
        this.logId = logId;
        this.userId = userId;
        this.action = action;
        this.ipAddress = ipAddress;
        this.deviceInfo = deviceInfo;
        this.details = details;
        this.createdAt = createdAt;
    }

    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public Users getUserId() {
        return userId;
    }

    public void setUserId(Users userId) {
        this.userId = userId;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public String getDeviceInfo() {
        return deviceInfo;
    }

    public void setDeviceInfo(String deviceInfo) {
        this.deviceInfo = deviceInfo;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "SystemLogs{" + "logId=" + logId + ", userId=" + userId + ", action=" + action + ", ipAddress=" + ipAddress + ", deviceInfo=" + deviceInfo + ", details=" + details + ", createdAt=" + createdAt + '}';
    }

}
