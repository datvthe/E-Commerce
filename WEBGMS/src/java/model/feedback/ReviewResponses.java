/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.feedback;

import model.feedback.Reviews;
import model.user.Users;
import java.time.LocalDateTime;

public class ReviewResponses {

    private int responseId;
    private Reviews reviewId;
    private Users sellerId;
    private String responseText;
    private LocalDateTime createdAt;

    public ReviewResponses() {
    }

    public ReviewResponses(int responseId, Reviews reviewId, Users sellerId, String responseText, LocalDateTime createdAt) {
        this.responseId = responseId;
        this.reviewId = reviewId;
        this.sellerId = sellerId;
        this.responseText = responseText;
        this.createdAt = createdAt;
    }

    public int getResponseId() {
        return responseId;
    }

    public void setResponseId(int responseId) {
        this.responseId = responseId;
    }

    public Reviews getReviewId() {
        return reviewId;
    }

    public void setReviewId(Reviews reviewId) {
        this.reviewId = reviewId;
    }

    public Users getSellerId() {
        return sellerId;
    }

    public void setSellerId(Users sellerId) {
        this.sellerId = sellerId;
    }

    public String getResponseText() {
        return responseText;
    }

    public void setResponseText(String responseText) {
        this.responseText = responseText;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "ReviewResponses{" + "responseId=" + responseId + ", reviewId=" + reviewId + ", sellerId=" + sellerId + ", responseText=" + responseText + ", createdAt=" + createdAt + '}';
    }

}
