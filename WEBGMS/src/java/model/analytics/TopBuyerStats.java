package model.analytics;

import java.math.BigDecimal;

public class TopBuyerStats {
    private int userId;
    private String fullName;
    private String email;
    private int orders;
    private BigDecimal totalAmount;

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public int getOrders() { return orders; }
    public void setOrders(int orders) { this.orders = orders; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
}
