/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.feedback;

import model.product.Products;
import model.user.Users;
import java.time.LocalDateTime;

public class Reviews {

    private int reviewId;
    private Products productId;
    private Users buyerId;
    private int rating;          // 1-5
    private String comment;     
    private String images;     
    private String status;   
    private LocalDateTime createdAt;

    public Reviews() {
    }

    public Reviews(int reviewId, Products productId, Users buyerId, int rating, String comment, String images, String status, LocalDateTime createdAt) {
        this.reviewId = reviewId;
        this.productId = productId;
        this.buyerId = buyerId;
        this.rating = rating;
        this.comment = comment;
        this.images = images;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getReviewId() {
        return reviewId;
    }

    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }

    public Products getProductId() {
        return productId;
    }

    public void setProductId(Products productId) {
        this.productId = productId;
    }

    public Users getBuyerId() {
        return buyerId;
    }

    public void setBuyerId(Users buyerId) {
        this.buyerId = buyerId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getImages() {
        return images;
    }

    public void setImages(String images) {
        this.images = images;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Reviews{" + "reviewId=" + reviewId + ", productId=" + productId + ", buyerId=" + buyerId + ", rating=" + rating + ", comment=" + comment + ", images=" + images + ", status=" + status + ", createdAt=" + createdAt + '}';
    }

}
