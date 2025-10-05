/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.feedback;

import model.user.Users;
import java.time.LocalDateTime;

public class SupportTickets {

    private int ticketId;
    private Users userId;
    private String category;     // ENUM: refund, dispute, complaint, technical
    private String description;  
    private String priority;     // ENUM: low, medium, high
    private String status;       // ENUM: open, in_progress, resolved, closed
    private Users assignedTo;
    private LocalDateTime createdAt;
    private LocalDateTime resolvedAt;

    public SupportTickets() {
    }

    public SupportTickets(int ticketId, Users userId, String category, String description, String priority, String status, Users assignedTo, LocalDateTime createdAt, LocalDateTime resolvedAt) {
        this.ticketId = ticketId;
        this.userId = userId;
        this.category = category;
        this.description = description;
        this.priority = priority;
        this.status = status;
        this.assignedTo = assignedTo;
        this.createdAt = createdAt;
        this.resolvedAt = resolvedAt;
    }

    public int getTicketId() {
        return ticketId;
    }

    public void setTicketId(int ticketId) {
        this.ticketId = ticketId;
    }

    public Users getUserId() {
        return userId;
    }

    public void setUserId(Users userId) {
        this.userId = userId;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Users getAssignedTo() {
        return assignedTo;
    }

    public void setAssignedTo(Users assignedTo) {
        this.assignedTo = assignedTo;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getResolvedAt() {
        return resolvedAt;
    }

    public void setResolvedAt(LocalDateTime resolvedAt) {
        this.resolvedAt = resolvedAt;
    }

    @Override
    public String toString() {
        return "SupportTickets{" + "ticketId=" + ticketId + ", userId=" + userId + ", category=" + category + ", description=" + description + ", priority=" + priority + ", status=" + status + ", assignedTo=" + assignedTo + ", createdAt=" + createdAt + ", resolvedAt=" + resolvedAt + '}';
    }

}
