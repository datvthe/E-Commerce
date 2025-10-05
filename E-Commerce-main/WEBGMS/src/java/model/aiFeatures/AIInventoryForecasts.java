/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.aiFeatures;

import model.product.Products;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class AIInventoryForecasts {

    private int forecastId;
    private Products productId;
    private int predictedDemand;
    private String period;             // ENUM: daily, weekly, monthly
    private BigDecimal confidenceScore;
    private LocalDateTime createdAt;

    public AIInventoryForecasts() {
    }

    public AIInventoryForecasts(int forecastId, Products productId, int predictedDemand, String period, BigDecimal confidenceScore, LocalDateTime createdAt) {
        this.forecastId = forecastId;
        this.productId = productId;
        this.predictedDemand = predictedDemand;
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

    public Products getProductId() {
        return productId;
    }

    public void setProductId(Products productId) {
        this.productId = productId;
    }

    public int getPredictedDemand() {
        return predictedDemand;
    }

    public void setPredictedDemand(int predictedDemand) {
        this.predictedDemand = predictedDemand;
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
        return "AIInventoryForecasts{" + "forecastId=" + forecastId + ", productId=" + productId + ", predictedDemand=" + predictedDemand + ", period=" + period + ", confidenceScore=" + confidenceScore + ", createdAt=" + createdAt + '}';
    }

}
