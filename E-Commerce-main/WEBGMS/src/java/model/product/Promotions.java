/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.product;

import model.product.Products;
import model.user.Users;
import java.math.BigDecimal;
import java.sql.Timestamp;

public class Promotions {

    private long promotion_id;
    private Users seller_id;
    private Products product_id;
    private String promotion_type;   // percentage, fixed, coupon, flash_sale
    private BigDecimal discount_value;
    private String coupon_code;
    private Timestamp start_date;
    private Timestamp end_date;
    private String status;           // pending, approved, rejected, active, expired

    public Promotions() {
    }

    public Promotions(long promotion_id, Users seller_id, Products product_id, String promotion_type, BigDecimal discount_value, String coupon_code, Timestamp start_date, Timestamp end_date, String status) {
        this.promotion_id = promotion_id;
        this.seller_id = seller_id;
        this.product_id = product_id;
        this.promotion_type = promotion_type;
        this.discount_value = discount_value;
        this.coupon_code = coupon_code;
        this.start_date = start_date;
        this.end_date = end_date;
        this.status = status;
    }

    public long getPromotion_id() {
        return promotion_id;
    }

    public void setPromotion_id(long promotion_id) {
        this.promotion_id = promotion_id;
    }

    public Users getSeller_id() {
        return seller_id;
    }

    public void setSeller_id(Users seller_id) {
        this.seller_id = seller_id;
    }

    public Products getProduct_id() {
        return product_id;
    }

    public void setProduct_id(Products product_id) {
        this.product_id = product_id;
    }

    public String getPromotion_type() {
        return promotion_type;
    }

    public void setPromotion_type(String promotion_type) {
        this.promotion_type = promotion_type;
    }

    public BigDecimal getDiscount_value() {
        return discount_value;
    }

    public void setDiscount_value(BigDecimal discount_value) {
        this.discount_value = discount_value;
    }

    public String getCoupon_code() {
        return coupon_code;
    }

    public void setCoupon_code(String coupon_code) {
        this.coupon_code = coupon_code;
    }

    public Timestamp getStart_date() {
        return start_date;
    }

    public void setStart_date(Timestamp start_date) {
        this.start_date = start_date;
    }

    public Timestamp getEnd_date() {
        return end_date;
    }

    public void setEnd_date(Timestamp end_date) {
        this.end_date = end_date;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Promotions{" + "promotion_id=" + promotion_id + ", seller_id=" + seller_id + ", product_id=" + product_id + ", promotion_type=" + promotion_type + ", discount_value=" + discount_value + ", coupon_code=" + coupon_code + ", start_date=" + start_date + ", end_date=" + end_date + ", status=" + status + '}';
    }

}
