/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.product;

import model.product.Products;

public class ProductTags {

    private int tag_id;
    private Products product_id;
    private String tag_name;
    private String source; // manual hoặc ai

    public ProductTags() {
    }

    public ProductTags(int tag_id, Products product_id, String tag_name, String source) {
        this.tag_id = tag_id;
        this.product_id = product_id;
        this.tag_name = tag_name;
        this.source = source;
    }

    public int getTag_id() {
        return tag_id;
    }

    public void setTag_id(int tag_id) {
        this.tag_id = tag_id;
    }

    public Products getProduct_id() {
        return product_id;
    }

    public void setProduct_id(Products product_id) {
        this.product_id = product_id;
    }

    public String getTag_name() {
        return tag_name;
    }

    public void setTag_name(String tag_name) {
        this.tag_name = tag_name;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    @Override
    public String toString() {
        return "ProductTags{" + "tag_id=" + tag_id + ", product_id=" + product_id + ", tag_name=" + tag_name + ", source=" + source + '}';
    }

}
