/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.moderation;

import java.time.LocalDateTime;

public class ModerationQueue {

    private int queueId;
    private String itemType;       // ENUM: product, promotion, order, review
    private Long itemId;
    private int submittedBy;
    private String status;         // ENUM: pending, approved, rejected, flagged
    private int reviewedBy;
    private String reviewNotes;   
    private LocalDateTime createdAt;
    private LocalDateTime reviewedAt;

    public ModerationQueue() {
    }

    public ModerationQueue(int queueId, String itemType, Long itemId, int submittedBy, String status, int reviewedBy, String reviewNotes, LocalDateTime createdAt, LocalDateTime reviewedAt) {
        this.queueId = queueId;
        this.itemType = itemType;
        this.itemId = itemId;
        this.submittedBy = submittedBy;
        this.status = status;
        this.reviewedBy = reviewedBy;
        this.reviewNotes = reviewNotes;
        this.createdAt = createdAt;
        this.reviewedAt = reviewedAt;
    }

    public int getQueueId() {
        return queueId;
    }

    public void setQueueId(int queueId) {
        this.queueId = queueId;
    }

    public String getItemType() {
        return itemType;
    }

    public void setItemType(String itemType) {
        this.itemType = itemType;
    }

    public Long getItemId() {
        return itemId;
    }

    public void setItemId(Long itemId) {
        this.itemId = itemId;
    }

    public int getSubmittedBy() {
        return submittedBy;
    }

    public void setSubmittedBy(int submittedBy) {
        this.submittedBy = submittedBy;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getReviewedBy() {
        return reviewedBy;
    }

    public void setReviewedBy(int reviewedBy) {
        this.reviewedBy = reviewedBy;
    }

    public String getReviewNotes() {
        return reviewNotes;
    }

    public void setReviewNotes(String reviewNotes) {
        this.reviewNotes = reviewNotes;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getReviewedAt() {
        return reviewedAt;
    }

    public void setReviewedAt(LocalDateTime reviewedAt) {
        this.reviewedAt = reviewedAt;
    }

    @Override
    public String toString() {
        return "ModerationQueue{" + "queueId=" + queueId + ", itemType=" + itemType + ", itemId=" + itemId + ", submittedBy=" + submittedBy + ", status=" + status + ", reviewedBy=" + reviewedBy + ", reviewNotes=" + reviewNotes + ", createdAt=" + createdAt + ", reviewedAt=" + reviewedAt + '}';
    }

}
