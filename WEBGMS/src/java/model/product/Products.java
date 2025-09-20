/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.product;

import model.user.Users;
import java.math.BigDecimal;
import java.sql.Timestamp;

public class Products {

    private long product_id;
    private Users seller_id;
    private String name;
    private String slug;
    private String description;
    private BigDecimal price;
    private String currency;
    private String status; // draft, pending, approved, rejected, active, inactive
    private ProductCategories category_id;
    private double average_rating;
    private int total_reviews;
    private Timestamp created_at;
    private Timestamp updated_at;
    private Timestamp deleted_at;

    public Products() {
    }

    public Products(long product_id, Users seller_id, String name, String slug, String description, BigDecimal price, String currency, String status, ProductCategories category_id, double average_rating, int total_reviews, Timestamp created_at, Timestamp updated_at, Timestamp deleted_at) {
        this.product_id = product_id;
        this.seller_id = seller_id;
        this.name = name;
        this.slug = slug;
        this.description = description;
        this.price = price;
        this.currency = currency;
        this.status = status;
        this.category_id = category_id;
        this.average_rating = average_rating;
        this.total_reviews = total_reviews;
        this.created_at = created_at;
        this.updated_at = updated_at;
        this.deleted_at = deleted_at;
    }

    public long getProduct_id() {
        return product_id;
    }

    public void setProduct_id(long product_id) {
        this.product_id = product_id;
    }

    public Users getSeller_id() {
        return seller_id;
    }

    public void setSeller_id(Users seller_id) {
        this.seller_id = seller_id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public ProductCategories getCategory_id() {
        return category_id;
    }

    public void setCategory_id(ProductCategories category_id) {
        this.category_id = category_id;
    }

    public double getAverage_rating() {
        return average_rating;
    }

    public void setAverage_rating(double average_rating) {
        this.average_rating = average_rating;
    }

    public int getTotal_reviews() {
        return total_reviews;
    }

    public void setTotal_reviews(int total_reviews) {
        this.total_reviews = total_reviews;
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

    public Timestamp getDeleted_at() {
        return deleted_at;
    }

    public void setDeleted_at(Timestamp deleted_at) {
        this.deleted_at = deleted_at;
    }

    @Override
    public String toString() {
        return "Products{" + "product_id=" + product_id + ", seller_id=" + seller_id + ", name=" + name + ", slug=" + slug + ", description=" + description + ", price=" + price + ", currency=" + currency + ", status=" + status + ", category_id=" + category_id + ", average_rating=" + average_rating + ", total_reviews=" + total_reviews + ", created_at=" + created_at + ", updated_at=" + updated_at + ", deleted_at=" + deleted_at + '}';
    }

}
