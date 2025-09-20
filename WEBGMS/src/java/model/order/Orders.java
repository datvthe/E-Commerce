/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.order;

import model.user.Users;
import java.math.BigDecimal;
import java.sql.Timestamp;

public class Orders {

    private int order_id;
    private Users buyer_id;
    private Users seller_id;
    private String status;           // pending, paid, shipped, delivered, cancelled, refunded
    private BigDecimal total_amount;
    private String currency;
    private String shipping_address;
    private String shipping_method;
    private String tracking_number;
    private Timestamp created_at;
    private Timestamp updated_at;

    public Orders() {
    }

    public Orders(int order_id, Users buyer_id, Users seller_id, String status, BigDecimal total_amount, String currency, String shipping_address, String shipping_method, String tracking_number, Timestamp created_at, Timestamp updated_at) {
        this.order_id = order_id;
        this.buyer_id = buyer_id;
        this.seller_id = seller_id;
        this.status = status;
        this.total_amount = total_amount;
        this.currency = currency;
        this.shipping_address = shipping_address;
        this.shipping_method = shipping_method;
        this.tracking_number = tracking_number;
        this.created_at = created_at;
        this.updated_at = updated_at;
    }

    public int getOrder_id() {
        return order_id;
    }

    public void setOrder_id(int order_id) {
        this.order_id = order_id;
    }

    public Users getBuyer_id() {
        return buyer_id;
    }

    public void setBuyer_id(Users buyer_id) {
        this.buyer_id = buyer_id;
    }

    public Users getSeller_id() {
        return seller_id;
    }

    public void setSeller_id(Users seller_id) {
        this.seller_id = seller_id;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public BigDecimal getTotal_amount() {
        return total_amount;
    }

    public void setTotal_amount(BigDecimal total_amount) {
        this.total_amount = total_amount;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public String getShipping_address() {
        return shipping_address;
    }

    public void setShipping_address(String shipping_address) {
        this.shipping_address = shipping_address;
    }

    public String getShipping_method() {
        return shipping_method;
    }

    public void setShipping_method(String shipping_method) {
        this.shipping_method = shipping_method;
    }

    public String getTracking_number() {
        return tracking_number;
    }

    public void setTracking_number(String tracking_number) {
        this.tracking_number = tracking_number;
    }

    public Timestamp getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Timestamp created_at) {
        this.created_at = created_at;
    }

    public Timestamp getUpdated_at() {
        return updated_at;
    }

    public void setUpdated_at(Timestamp updated_at) {
        this.updated_at = updated_at;
    }

    @Override
    public String toString() {
        return "Orders{" + "order_id=" + order_id + ", buyer_id=" + buyer_id + ", seller_id=" + seller_id + ", status=" + status + ", total_amount=" + total_amount + ", currency=" + currency + ", shipping_address=" + shipping_address + ", shipping_method=" + shipping_method + ", tracking_number=" + tracking_number + ", created_at=" + created_at + ", updated_at=" + updated_at + '}';
    }

}
