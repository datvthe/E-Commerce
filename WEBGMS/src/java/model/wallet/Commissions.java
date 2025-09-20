/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.wallet;

import model.order.Orders;
import model.user.Users;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Commissions {

    private int commissionId;
    private Orders orderId;
    private Users sellerId;
    private BigDecimal rate;      
    private BigDecimal amount;  
    private String status;         // ENUM: calculated, transferred
    private LocalDateTime createdAt;

    public Commissions() {
    }

    public Commissions(int commissionId, Orders orderId, Users sellerId, BigDecimal rate, BigDecimal amount, String status, LocalDateTime createdAt) {
        this.commissionId = commissionId;
        this.orderId = orderId;
        this.sellerId = sellerId;
        this.rate = rate;
        this.amount = amount;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getCommissionId() {
        return commissionId;
    }

    public void setCommissionId(int commissionId) {
        this.commissionId = commissionId;
    }

    public Orders getOrderId() {
        return orderId;
    }

    public void setOrderId(Orders orderId) {
        this.orderId = orderId;
    }

    public Users getSellerId() {
        return sellerId;
    }

    public void setSellerId(Users sellerId) {
        this.sellerId = sellerId;
    }

    public BigDecimal getRate() {
        return rate;
    }

    public void setRate(BigDecimal rate) {
        this.rate = rate;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Commissions{" + "commissionId=" + commissionId + ", orderId=" + orderId + ", sellerId=" + sellerId + ", rate=" + rate + ", amount=" + amount + ", status=" + status + ", createdAt=" + createdAt + '}';
    }

}
