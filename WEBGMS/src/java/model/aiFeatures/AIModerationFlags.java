/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.aiFeatures;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class AIModerationFlags {

    private int modFlagId;
    private String itemType;         // ENUM: product, promotion, review
    private int itemId;
    private String reason;          
    private BigDecimal confidenceScore; 
    private LocalDateTime createdAt;   

    public AIModerationFlags() {
    }

    public AIModerationFlags(int modFlagId, String itemType, int itemId, String reason, BigDecimal confidenceScore, LocalDateTime createdAt) {
        this.modFlagId = modFlagId;
        this.itemType = itemType;
        this.itemId = itemId;
        this.reason = reason;
        this.confidenceScore = confidenceScore;
        this.createdAt = createdAt;
    }

    public int getModFlagId() {
        return modFlagId;
    }

    public void setModFlagId(int modFlagId) {
        this.modFlagId = modFlagId;
    }

    public String getItemType() {
        return itemType;
    }

    public void setItemType(String itemType) {
        this.itemType = itemType;
    }

    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
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
        return "AIModerationFlags{" + "modFlagId=" + modFlagId + ", itemType=" + itemType + ", itemId=" + itemId + ", reason=" + reason + ", confidenceScore=" + confidenceScore + ", createdAt=" + createdAt + '}';
    }

}
