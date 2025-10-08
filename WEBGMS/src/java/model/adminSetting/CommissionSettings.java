/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.adminSetting;

import model.product.ProductCategories;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class CommissionSettings {

    private int commissionSettingId;
    private ProductCategories categoryId;         
    private BigDecimal baseRate;        
    private Boolean dynamicRateEnabled; 
    private LocalDateTime updatedAt;    

    public CommissionSettings() {
    }

    public CommissionSettings(int commissionSettingId, ProductCategories categoryId, BigDecimal baseRate, Boolean dynamicRateEnabled, LocalDateTime updatedAt) {
        this.commissionSettingId = commissionSettingId;
        this.categoryId = categoryId;
        this.baseRate = baseRate;
        this.dynamicRateEnabled = dynamicRateEnabled;
        this.updatedAt = updatedAt;
    }

    public int getCommissionSettingId() {
        return commissionSettingId;
    }

    public void setCommissionSettingId(int commissionSettingId) {
        this.commissionSettingId = commissionSettingId;
    }

    public ProductCategories getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(ProductCategories categoryId) {
        this.categoryId = categoryId;
    }

    public BigDecimal getBaseRate() {
        return baseRate;
    }

    public void setBaseRate(BigDecimal baseRate) {
        this.baseRate = baseRate;
    }

    public Boolean getDynamicRateEnabled() {
        return dynamicRateEnabled;
    }

    public void setDynamicRateEnabled(Boolean dynamicRateEnabled) {
        this.dynamicRateEnabled = dynamicRateEnabled;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "CommissionSettings{" + "commissionSettingId=" + commissionSettingId + ", categoryId=" + categoryId + ", baseRate=" + baseRate + ", dynamicRateEnabled=" + dynamicRateEnabled + ", updatedAt=" + updatedAt + '}';
    }

}
