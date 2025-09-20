/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.product;

import model.product.Products;
import java.sql.Timestamp;

public class ProductAttributes {

    private int attribute_id;
    private Products product_id;
    private String attribute_name;
    private String attribute_value;
    private Timestamp created_at;

    public ProductAttributes() {
    }

    public ProductAttributes(int attribute_id, Products product_id, String attribute_name, String attribute_value, Timestamp created_at) {
        this.attribute_id = attribute_id;
        this.product_id = product_id;
        this.attribute_name = attribute_name;
        this.attribute_value = attribute_value;
        this.created_at = created_at;
    }

    public int getAttribute_id() {
        return attribute_id;
    }

    public void setAttribute_id(int attribute_id) {
        this.attribute_id = attribute_id;
    }

    public Products getProduct_id() {
        return product_id;
    }

    public void setProduct_id(Products product_id) {
        this.product_id = product_id;
    }

    public String getAttribute_name() {
        return attribute_name;
    }

    public void setAttribute_name(String attribute_name) {
        this.attribute_name = attribute_name;
    }

    public String getAttribute_value() {
        return attribute_value;
    }

    public void setAttribute_value(String attribute_value) {
        this.attribute_value = attribute_value;
    }

    public Timestamp getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Timestamp created_at) {
        this.created_at = created_at;
    }

    @Override
    public String toString() {
        return "ProductAttributes{" + "attribute_id=" + attribute_id + ", product_id=" + product_id + ", attribute_name=" + attribute_name + ", attribute_value=" + attribute_value + ", created_at=" + created_at + '}';
    }

}
