/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.aiFeatures;

import model.order.Transactions;
import java.time.LocalDateTime;

public class AIFraudDetections {

    private int fraudAiId;
    private Transactions transactionId;    
    private Integer riskScore;     
    private String recommendation; // ENUM: block, review, allow
    private LocalDateTime generatedAt;

    public AIFraudDetections() {
    }

    public AIFraudDetections(int fraudAiId, Transactions transactionId, Integer riskScore, String recommendation, LocalDateTime generatedAt) {
        this.fraudAiId = fraudAiId;
        this.transactionId = transactionId;
        this.riskScore = riskScore;
        this.recommendation = recommendation;
        this.generatedAt = generatedAt;
    }

    public int getFraudAiId() {
        return fraudAiId;
    }

    public void setFraudAiId(int fraudAiId) {
        this.fraudAiId = fraudAiId;
    }

    public Transactions getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(Transactions transactionId) {
        this.transactionId = transactionId;
    }

    public Integer getRiskScore() {
        return riskScore;
    }

    public void setRiskScore(Integer riskScore) {
        this.riskScore = riskScore;
    }

    public String getRecommendation() {
        return recommendation;
    }

    public void setRecommendation(String recommendation) {
        this.recommendation = recommendation;
    }

    public LocalDateTime getGeneratedAt() {
        return generatedAt;
    }

    public void setGeneratedAt(LocalDateTime generatedAt) {
        this.generatedAt = generatedAt;
    }

    @Override
    public String toString() {
        return "AIFraudDetections{" + "fraudAiId=" + fraudAiId + ", transactionId=" + transactionId + ", riskScore=" + riskScore + ", recommendation=" + recommendation + ", generatedAt=" + generatedAt + '}';
    }

}
