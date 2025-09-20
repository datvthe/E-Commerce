/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.aiFeatures;

import model.product.Products;
import model.user.Users;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class AIRecommendations {

    private int recId;
    private Users userId;
    private Products productId;
    private BigDecimal score;
    private LocalDateTime generatedAt;

    public AIRecommendations() {
    }

    public AIRecommendations(int recId, Users userId, Products productId, BigDecimal score, LocalDateTime generatedAt) {
        this.recId = recId;
        this.userId = userId;
        this.productId = productId;
        this.score = score;
        this.generatedAt = generatedAt;
    }

    public int getRecId() {
        return recId;
    }

    public void setRecId(int recId) {
        this.recId = recId;
    }

    public Users getUserId() {
        return userId;
    }

    public void setUserId(Users userId) {
        this.userId = userId;
    }

    public Products getProductId() {
        return productId;
    }

    public void setProductId(Products productId) {
        this.productId = productId;
    }

    public BigDecimal getScore() {
        return score;
    }

    public void setScore(BigDecimal score) {
        this.score = score;
    }

    public LocalDateTime getGeneratedAt() {
        return generatedAt;
    }

    public void setGeneratedAt(LocalDateTime generatedAt) {
        this.generatedAt = generatedAt;
    }

    @Override
    public String toString() {
        return "AIRecommendations{" + "recId=" + recId + ", userId=" + userId + ", productId=" + productId + ", score=" + score + ", generatedAt=" + generatedAt + '}';
    }

}
