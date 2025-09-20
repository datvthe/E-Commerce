/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.moderation;

import model.order.Transactions;
import java.time.LocalDateTime;

public class FraudFlags {

    private int flagId;
    private Transactions transactionId;
    private String reason;       
    private Integer riskScore;   
    private String status;       // ENUM: pending, confirmed, dismissed
    private String detectedBy;   // ENUM: AI, Manager
    private LocalDateTime createdAt;

    public FraudFlags() {
    }

    public FraudFlags(int flagId, Transactions transactionId, String reason, Integer riskScore, String status, String detectedBy, LocalDateTime createdAt) {
        this.flagId = flagId;
        this.transactionId = transactionId;
        this.reason = reason;
        this.riskScore = riskScore;
        this.status = status;
        this.detectedBy = detectedBy;
        this.createdAt = createdAt;
    }

    public int getFlagId() {
        return flagId;
    }

    public void setFlagId(int flagId) {
        this.flagId = flagId;
    }

    public Transactions getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(Transactions transactionId) {
        this.transactionId = transactionId;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public Integer getRiskScore() {
        return riskScore;
    }

    public void setRiskScore(Integer riskScore) {
        this.riskScore = riskScore;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDetectedBy() {
        return detectedBy;
    }

    public void setDetectedBy(String detectedBy) {
        this.detectedBy = detectedBy;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "FraudFlags{" + "flagId=" + flagId + ", transactionId=" + transactionId + ", reason=" + reason + ", riskScore=" + riskScore + ", status=" + status + ", detectedBy=" + detectedBy + ", createdAt=" + createdAt + '}';
    }

}
