/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.moderation;

import java.time.LocalDateTime;

public class Reports {

    private int reportId;
    private String reportType;   // ENUM: sales, revenue, fraud, user_growth, inventory
    private String content;      
    private String generatedBy;  // ENUM: system, admin
    private LocalDateTime generatedAt;

    public Reports() {
    }

    public Reports(int reportId, String reportType, String content, String generatedBy, LocalDateTime generatedAt) {
        this.reportId = reportId;
        this.reportType = reportType;
        this.content = content;
        this.generatedBy = generatedBy;
        this.generatedAt = generatedAt;
    }

    public int getReportId() {
        return reportId;
    }

    public void setReportId(int reportId) {
        this.reportId = reportId;
    }

    public String getReportType() {
        return reportType;
    }

    public void setReportType(String reportType) {
        this.reportType = reportType;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getGeneratedBy() {
        return generatedBy;
    }

    public void setGeneratedBy(String generatedBy) {
        this.generatedBy = generatedBy;
    }

    public LocalDateTime getGeneratedAt() {
        return generatedAt;
    }

    public void setGeneratedAt(LocalDateTime generatedAt) {
        this.generatedAt = generatedAt;
    }

    @Override
    public String toString() {
        return "Reports{" + "reportId=" + reportId + ", reportType=" + reportType + ", content=" + content + ", generatedBy=" + generatedBy + ", generatedAt=" + generatedAt + '}';
    }

}
