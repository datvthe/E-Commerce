/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.aiFeatures;

import model.product.Promotions;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class AIPricePredictions {

    private int pricePredId;
    private Promotions productId;
    private BigDecimal predictedPrice;
    private BigDecimal confidenceScore;
    private LocalDateTime validUntil;

    public AIPricePredictions() {
    }

    public AIPricePredictions(int pricePredId, Promotions productId, BigDecimal predictedPrice, BigDecimal confidenceScore, LocalDateTime validUntil) {
        this.pricePredId = pricePredId;
        this.productId = productId;
        this.predictedPrice = predictedPrice;
        this.confidenceScore = confidenceScore;
        this.validUntil = validUntil;
    }

    public int getPricePredId() {
        return pricePredId;
    }

    public void setPricePredId(int pricePredId) {
        this.pricePredId = pricePredId;
    }

    public Promotions getProductId() {
        return productId;
    }

    public void setProductId(Promotions productId) {
        this.productId = productId;
    }

    public BigDecimal getPredictedPrice() {
        return predictedPrice;
    }

    public void setPredictedPrice(BigDecimal predictedPrice) {
        this.predictedPrice = predictedPrice;
    }

    public BigDecimal getConfidenceScore() {
        return confidenceScore;
    }

    public void setConfidenceScore(BigDecimal confidenceScore) {
        this.confidenceScore = confidenceScore;
    }

    public LocalDateTime getValidUntil() {
        return validUntil;
    }

    public void setValidUntil(LocalDateTime validUntil) {
        this.validUntil = validUntil;
    }

    @Override
    public String toString() {
        return "AIPricePredictions{" + "pricePredId=" + pricePredId + ", productId=" + productId + ", predictedPrice=" + predictedPrice + ", confidenceScore=" + confidenceScore + ", validUntil=" + validUntil + '}';
    }

}
