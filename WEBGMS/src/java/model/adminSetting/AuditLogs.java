/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.adminSetting;

import model.user.Users;
import java.time.LocalDateTime;

public class AuditLogs {

    private int auditId;
    private Users adminId;         
    private String action;        // hành động (CREATE, UPDATE, DELETE, ...)
    private String targetTable;  
    private int targetId;        
    private String oldValue;      
    private String newValue;      
    private LocalDateTime createdAt;

    public AuditLogs() {
    }

    public AuditLogs(int auditId, Users adminId, String action, String targetTable, int targetId, String oldValue, String newValue, LocalDateTime createdAt) {
        this.auditId = auditId;
        this.adminId = adminId;
        this.action = action;
        this.targetTable = targetTable;
        this.targetId = targetId;
        this.oldValue = oldValue;
        this.newValue = newValue;
        this.createdAt = createdAt;
    }

    public int getAuditId() {
        return auditId;
    }

    public void setAuditId(int auditId) {
        this.auditId = auditId;
    }

    public Users getAdminId() {
        return adminId;
    }

    public void setAdminId(Users adminId) {
        this.adminId = adminId;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getTargetTable() {
        return targetTable;
    }

    public void setTargetTable(String targetTable) {
        this.targetTable = targetTable;
    }

    public int getTargetId() {
        return targetId;
    }

    public void setTargetId(int targetId) {
        this.targetId = targetId;
    }

    public String getOldValue() {
        return oldValue;
    }

    public void setOldValue(String oldValue) {
        this.oldValue = oldValue;
    }

    public String getNewValue() {
        return newValue;
    }

    public void setNewValue(String newValue) {
        this.newValue = newValue;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "AuditLogs{" + "auditId=" + auditId + ", adminId=" + adminId + ", action=" + action + ", targetTable=" + targetTable + ", targetId=" + targetId + ", oldValue=" + oldValue + ", newValue=" + newValue + ", createdAt=" + createdAt + '}';
    }

}
