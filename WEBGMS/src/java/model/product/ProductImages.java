/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.product;

import model.product.Products;

public class ProductImages {

    private int image_id;
    private Products product_id;
    private String url;
    private String alt_text;
    private boolean is_primary;

    public ProductImages() {
    }

    public ProductImages(int image_id, Products product_id, String url, String alt_text, boolean is_primary) {
        this.image_id = image_id;
        this.product_id = product_id;
        this.url = url;
        this.alt_text = alt_text;
        this.is_primary = is_primary;
    }

    public int getImage_id() {
        return image_id;
    }

    public void setImage_id(int image_id) {
        this.image_id = image_id;
    }

    public Products getProduct_id() {
        return product_id;
    }

    public void setProduct_id(Products product_id) {
        this.product_id = product_id;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getAlt_text() {
        return alt_text;
    }

    public void setAlt_text(String alt_text) {
        this.alt_text = alt_text;
    }

    public boolean isIs_primary() {
        return is_primary;
    }

    public void setIs_primary(boolean is_primary) {
        this.is_primary = is_primary;
    }

    @Override
    public String toString() {
        return "ProductImages{" + "image_id=" + image_id + ", product_id=" + product_id + ", url=" + url + ", alt_text=" + alt_text + ", is_primary=" + is_primary + '}';
    }

}
