/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.aiFeatures;

import model.user.Users;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class AISalesForecasts {

    private int forecastId;
    private Users sellerId;            
    private BigDecimal predictedRevenue; 
    private String period;             // ENUM: daily, weekly, monthly
    private BigDecimal confidenceScore; 
    private LocalDateTime createdAt;  

    public AISalesForecasts() {
    }

    public AISalesForecasts(int forecastId, Users sellerId, BigDecimal predictedRevenue, String period, BigDecimal confidenceScore, LocalDateTime createdAt) {
        this.forecastId = forecastId;
        this.sellerId = sellerId;
        this.predictedRevenue = predictedRevenue;
        this.period = period;
        this.confidenceScore = confidenceScore;
        this.createdAt = createdAt;
    }

    public int getForecastId() {
        return forecastId;
    }

    public void setForecastId(int forecastId) {
        this.forecastId = forecastId;
    }

    public Users getSellerId() {
        return sellerId;
    }

    public void setSellerId(Users sellerId) {
        this.sellerId = sellerId;
    }

    public BigDecimal getPredictedRevenue() {
        return predictedRevenue;
    }

    public void setPredictedRevenue(BigDecimal predictedRevenue) {
        this.predictedRevenue = predictedRevenue;
    }

    public String getPeriod() {
        return period;
    }

    public void setPeriod(String period) {
        this.period = period;
    }

    public BigDecimal getConfidenceScore() {
        return confidenceScore;
    }

    public void setConfidenceScore(BigDecimal confidenceScore) {
        this.confidenceScore = confidenceScore;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "AISalesForecasts{" + "forecastId=" + forecastId + ", sellerId=" + sellerId + ", predictedRevenue=" + predictedRevenue + ", period=" + period + ", confidenceScore=" + confidenceScore + ", createdAt=" + createdAt + '}';
    }

}
