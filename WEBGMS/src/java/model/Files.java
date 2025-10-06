/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import model.user.Users;
import java.time.LocalDateTime;

public class Files {

    private int fileId;
    private Users userId;          
    private String fileName;      
    private String filePath;     
    private String fileType;      // ENUM: image, doc, video, other
    private Long size;            
    private LocalDateTime uploadedAt;

    public Files() {
    }

    public Files(int fileId, Users userId, String fileName, String filePath, String fileType, Long size, LocalDateTime uploadedAt) {
        this.fileId = fileId;
        this.userId = userId;
        this.fileName = fileName;
        this.filePath = filePath;
        this.fileType = fileType;
        this.size = size;
        this.uploadedAt = uploadedAt;
    }

    public int getFileId() {
        return fileId;
    }

    public void setFileId(int fileId) {
        this.fileId = fileId;
    }

    public Users getUserId() {
        return userId;
    }

    public void setUserId(Users userId) {
        this.userId = userId;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    public Long getSize() {
        return size;
    }

    public void setSize(Long size) {
        this.size = size;
    }

    public LocalDateTime getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(LocalDateTime uploadedAt) {
        this.uploadedAt = uploadedAt;
    }

    @Override
    public String toString() {
        return "Files{" + "fileId=" + fileId + ", userId=" + userId + ", fileName=" + fileName + ", filePath=" + filePath + ", fileType=" + fileType + ", size=" + size + ", uploadedAt=" + uploadedAt + '}';
    }

}
