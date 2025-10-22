package model.seller;

import java.sql.Timestamp;

public class Seller {
    private int sellerId;
    private long userId;
    private String fullName;
    private String email;
    private String phone;
    private String shopName;
    private String shopDescription;
    private String mainCategory;
    private String bankName;
    private String bankAccount;
    private String accountOwner;
    private String idCardFront;
    private String idCardBack;
    private String selfieWithId;
    private double depositAmount;
    private String depositStatus;
    private String depositProof;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // --- Getters & Setters ---
    public int getSellerId() { return sellerId; }
    public void setSellerId(int sellerId) { this.sellerId = sellerId; }

    public long getUserId() { return userId; }
    public void setUserId(long userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getShopName() { return shopName; }
    public void setShopName(String shopName) { this.shopName = shopName; }

    public String getShopDescription() { return shopDescription; }
    public void setShopDescription(String shopDescription) { this.shopDescription = shopDescription; }

    public String getMainCategory() { return mainCategory; }
    public void setMainCategory(String mainCategory) { this.mainCategory = mainCategory; }

    public String getBankName() { return bankName; }
    public void setBankName(String bankName) { this.bankName = bankName; }

    public String getBankAccount() { return bankAccount; }
    public void setBankAccount(String bankAccount) { this.bankAccount = bankAccount; }

    public String getAccountOwner() { return accountOwner; }
    public void setAccountOwner(String accountOwner) { this.accountOwner = accountOwner; }

    public String getIdCardFront() { return idCardFront; }
    public void setIdCardFront(String idCardFront) { this.idCardFront = idCardFront; }

    public String getIdCardBack() { return idCardBack; }
    public void setIdCardBack(String idCardBack) { this.idCardBack = idCardBack; }

    public String getSelfieWithId() { return selfieWithId; }
    public void setSelfieWithId(String selfieWithId) { this.selfieWithId = selfieWithId; }

    public double getDepositAmount() { return depositAmount; }
    public void setDepositAmount(double depositAmount) { this.depositAmount = depositAmount; }

    public String getDepositStatus() { return depositStatus; }
    public void setDepositStatus(String depositStatus) { this.depositStatus = depositStatus; }

    public String getDepositProof() { return depositProof; }
    public void setDepositProof(String depositProof) { this.depositProof = depositProof; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}
