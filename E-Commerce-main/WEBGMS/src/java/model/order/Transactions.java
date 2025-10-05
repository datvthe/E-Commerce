/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.order;

import model.user.Users;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Transactions {

    private int transactionId;
    private Users userId;
    private String type;       // ENUM: deposit, withdraw, order_payment, refund, commission
    private BigDecimal amount;
    private String currency;
    private String status;     // ENUM: pending, success, failed
    private Long referenceId;
    private LocalDateTime createdAt;

    public Transactions() {
    }

    public Transactions(int transactionId, Users userId, String type, BigDecimal amount, String currency, String status, Long referenceId, LocalDateTime createdAt) {
        this.transactionId = transactionId;
        this.userId = userId;
        this.type = type;
        this.amount = amount;
        this.currency = currency;
        this.status = status;
        this.referenceId = referenceId;
        this.createdAt = createdAt;
    }

    public int getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(int transactionId) {
        this.transactionId = transactionId;
    }

    public Users getUserId() {
        return userId;
    }

    public void setUserId(Users userId) {
        this.userId = userId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Long getReferenceId() {
        return referenceId;
    }

    public void setReferenceId(Long referenceId) {
        this.referenceId = referenceId;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Transactions{" + "transactionId=" + transactionId + ", userId=" + userId + ", type=" + type + ", amount=" + amount + ", currency=" + currency + ", status=" + status + ", referenceId=" + referenceId + ", createdAt=" + createdAt + '}';
    }

}
