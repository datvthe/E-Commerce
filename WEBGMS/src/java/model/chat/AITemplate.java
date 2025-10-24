package model.chat;

import java.sql.Timestamp;

public class AITemplate {
    private Integer templateId;
    private String keyword;
    private String responseText;
    private String templateType; // greeting, faq, product_info, order_status, general
    private int priority;
    private boolean isActive;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public AITemplate() {
    }

    public AITemplate(Integer templateId, String keyword, String responseText, String templateType, 
                     int priority, boolean isActive, Timestamp createdAt, Timestamp updatedAt) {
        this.templateId = templateId;
        this.keyword = keyword;
        this.responseText = responseText;
        this.templateType = templateType;
        this.priority = priority;
        this.isActive = isActive;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
    public Integer getTemplateId() {
        return templateId;
    }

    public void setTemplateId(Integer templateId) {
        this.templateId = templateId;
    }

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public String getResponseText() {
        return responseText;
    }

    public void setResponseText(String responseText) {
        this.responseText = responseText;
    }

    public String getTemplateType() {
        return templateType;
    }

    public void setTemplateType(String templateType) {
        this.templateType = templateType;
    }

    public int getPriority() {
        return priority;
    }

    public void setPriority(int priority) {
        this.priority = priority;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "AITemplate{" +
                "templateId=" + templateId +
                ", keyword='" + keyword + '\'' +
                ", responseText='" + responseText + '\'' +
                ", templateType='" + templateType + '\'' +
                ", priority=" + priority +
                ", isActive=" + isActive +
                '}';
    }
}
