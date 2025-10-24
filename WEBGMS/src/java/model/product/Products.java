/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package model.product;

import model.user.Users;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

public class Products {

    public enum ProductStatus {
        DRAFT, PENDING, APPROVED, REJECTED, ACTIVE, INACTIVE
    }

    private long product_id;
    private Users seller_id;
    private String name;
    private String slug;
    private String description;
    private BigDecimal price;
    private String currency;
    private String status; // kept for compatibility; use getStatusEnum/setStatusEnum for type-safety
    private int is_digital;
    private String delivery_time;
    private ProductCategories category_id;
    private double average_rating;
    private int total_reviews;
    private List<ProductImages> productImages;
    private Timestamp created_at;
    private Timestamp updated_at;
    private Timestamp deleted_at;
    private int quantity; 

    // Helper fields for joined data (wishlist projections)
    private String category_name;
    private String imageUrl;

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Products(long product_id, Users seller_id, String name, String slug, String description, BigDecimal price, String currency, String status, ProductCategories category_id, double average_rating, int total_reviews, Timestamp created_at, Timestamp updated_at, Timestamp deleted_at, int quantity) {
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
        this.quantity = quantity;
    }

    public Products() {
    }

    public Products(
            long product_id,
            Users seller_id,
            String name,
            String slug,
            String description,
            BigDecimal price,
            String currency,
            String status,
            ProductCategories category_id,
            double average_rating,
            int total_reviews,
            Timestamp created_at,
            Timestamp updated_at,
            Timestamp deleted_at
    ) {
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

    // Type-safe helpers
    public ProductStatus getStatusEnum() {
        if (status == null) return null;
        return ProductStatus.valueOf(status.trim().toUpperCase());
    }

    public void setStatusEnum(ProductStatus statusEnum) {
        this.status = statusEnum == null ? null : statusEnum.name().toLowerCase();
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

    public int getIs_digital() {
        return is_digital;
    }

    public void setIs_digital(int is_digital) {
        this.is_digital = is_digital;
    }

    public String getDelivery_time() {
        return delivery_time;
    }

    public void setDelivery_time(String delivery_time) {
        this.delivery_time = delivery_time;
    }

    // Additional camelCase accessors
    public long getProductId() { return product_id; }
    public void setProductId(long productId) { this.product_id = productId; }

    public Users getSeller() { return seller_id; }
    public void setSeller(Users seller) { this.seller_id = seller; }

    public ProductCategories getCategory() { return category_id; }
    public void setCategory(ProductCategories category) { this.category_id = category; }

    public double getAverageRating() { return average_rating; }
    public void setAverageRating(double averageRating) { this.average_rating = averageRating; }

    public int getTotalReviews() { return total_reviews; }
    public void setTotalReviews(int totalReviews) { this.total_reviews = totalReviews; }

    public Timestamp getCreatedAt() { return created_at; }
    public void setCreatedAt(Timestamp createdAt) { this.created_at = createdAt; }

    public Timestamp getUpdatedAt() { return updated_at; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updated_at = updatedAt; }

    public Timestamp getDeletedAt() { return deleted_at; }
    public void setDeletedAt(Timestamp deletedAt) { this.deleted_at = deletedAt; }
    
    // Additional properties for wishlist display
    private String category_name; // For displaying category name in wishlist
    private String imageUrl; // For displaying product image
    
    public String getCategory_name() { return category_name; }
    public void setCategory_name(String category_name) { this.category_name = category_name; }
    
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    // Wishlist projection helpers
    public String getCategory_name() { return category_name; }
    public void setCategory_name(String category_name) { this.category_name = category_name; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public List<ProductImages> getProductImages() {
        return productImages;
    }

    public void setProductImages(List<ProductImages> productImages) {
        this.productImages = productImages;
    }

    @Override
    public int hashCode() {
        return Long.hashCode(product_id);
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Products other = (Products) obj;
        return this.product_id == other.product_id;
    }

    @Override
    public String toString() {
        return "Products{" +
                "product_id=" + product_id +
                ", seller_id=" + (seller_id == null ? null : seller_id.getUser_id()) +
                ", name=" + name +
                ", slug=" + slug +
                ", descriptionLength=" + (description == null ? 0 : description.length()) +
                ", price=" + price +
                ", currency=" + currency +
                ", status=" + status +
                ", category_id=" + (category_id == null ? null : category_id.getCategory_id()) +
                ", average_rating=" + average_rating +
                ", total_reviews=" + total_reviews +
                ", created_at=" + created_at +
                ", updated_at=" + updated_at +
                ", deleted_at=" + deleted_at +
                '}';
    }
}
