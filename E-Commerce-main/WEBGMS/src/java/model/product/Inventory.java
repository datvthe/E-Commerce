/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.product;

import model.product.Products;
import model.user.Users;
import java.sql.Timestamp;

public class Inventory {

    private int inventory_id;
    private Products product_id;
    private Users seller_id;
    private int quantity;
    private int reserved_quantity;
    private int min_threshold;
    private Timestamp last_restocked_at;

    public Inventory() {
    }

    public Inventory(int inventory_id, Products product_id, Users seller_id, int quantity, int reserved_quantity, int min_threshold, Timestamp last_restocked_at) {
        this.inventory_id = inventory_id;
        this.product_id = product_id;
        this.seller_id = seller_id;
        this.quantity = quantity;
        this.reserved_quantity = reserved_quantity;
        this.min_threshold = min_threshold;
        this.last_restocked_at = last_restocked_at;
    }

    public int getInventory_id() {
        return inventory_id;
    }

    public void setInventory_id(int inventory_id) {
        this.inventory_id = inventory_id;
    }

    public Products getProduct_id() {
        return product_id;
    }

    public void setProduct_id(Products product_id) {
        this.product_id = product_id;
    }

    public Users getSeller_id() {
        return seller_id;
    }

    public void setSeller_id(Users seller_id) {
        this.seller_id = seller_id;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getReserved_quantity() {
        return reserved_quantity;
    }

    public void setReserved_quantity(int reserved_quantity) {
        this.reserved_quantity = reserved_quantity;
    }

    public int getMin_threshold() {
        return min_threshold;
    }

    public void setMin_threshold(int min_threshold) {
        this.min_threshold = min_threshold;
    }

    public Timestamp getLast_restocked_at() {
        return last_restocked_at;
    }

    public void setLast_restocked_at(Timestamp last_restocked_at) {
        this.last_restocked_at = last_restocked_at;
    }

    @Override
    public String toString() {
        return "Inventory{" + "inventory_id=" + inventory_id + ", product_id=" + product_id + ", seller_id=" + seller_id + ", quantity=" + quantity + ", reserved_quantity=" + reserved_quantity + ", min_threshold=" + min_threshold + ", last_restocked_at=" + last_restocked_at + '}';
    }

}
