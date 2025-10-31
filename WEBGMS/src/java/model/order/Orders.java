package model.order;

import model.user.Users;
import model.product.Products;
import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Orders Model - Digital Goods Orders
 */
public class Orders {
    
    // Order statuses
    public enum OrderStatus { PENDING, PROCESSING, COMPLETED, FAILED, CANCELED }
    public enum PaymentStatus { PENDING, PAID, FAILED, REFUNDED }
    public enum QueueStatus { WAITING, PROCESSING, COMPLETED, FAILED }
    
    private Long orderId;
    private String orderNumber;
    private Long buyerId;           // user_id của người mua
    private Long sellerId;          // user_id của người bán
    private Long productId;
    private Integer quantity;
    private BigDecimal unitPrice;
    private BigDecimal totalAmount;
    private String currency;
    private String paymentMethod;
    private String paymentStatus;
    private String orderStatus;
    private String deliveryStatus;
    private String transactionId;
    private String queueStatus;
    private Timestamp processedAt;
    private String shippingAddress;
    private String shippingMethod;
    private String trackingNumber;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Joined data
    private Users buyer;
    private Users seller;
    private Products product;

    // Constructors
    public Orders() {
    }

    public Orders(Long orderId, String orderNumber, Long buyerId, Long sellerId, 
                  Long productId, Integer quantity, BigDecimal unitPrice, 
                  BigDecimal totalAmount, String paymentMethod, String paymentStatus,
                  String orderStatus) {
        this.orderId = orderId;
        this.orderNumber = orderNumber;
        this.buyerId = buyerId;
        this.sellerId = sellerId;
        this.productId = productId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.totalAmount = totalAmount;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
        this.orderStatus = orderStatus;
    }

    // Getters and Setters
    public Long getOrderId() {
        return orderId;
    }

    public void setOrderId(Long orderId) {
        this.orderId = orderId;
    }

    public String getOrderNumber() {
        return orderNumber;
    }

    public void setOrderNumber(String orderNumber) {
        this.orderNumber = orderNumber;
    }

    public Long getBuyerId() {
        return buyerId;
    }

    public void setBuyerId(Long buyerId) {
        this.buyerId = buyerId;
    }

    public Long getSellerId() {
        return sellerId;
    }

    public void setSellerId(Long sellerId) {
        this.sellerId = sellerId;
    }

    public Long getProductId() {
        return productId;
    }

    public void setProductId(Long productId) {
        this.productId = productId;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

    public String getDeliveryStatus() {
        return deliveryStatus;
    }

    public void setDeliveryStatus(String deliveryStatus) {
        this.deliveryStatus = deliveryStatus;
    }

    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }

    public String getQueueStatus() {
        return queueStatus;
    }

    public void setQueueStatus(String queueStatus) {
        this.queueStatus = queueStatus;
    }

    public Timestamp getProcessedAt() {
        return processedAt;
    }

    public void setProcessedAt(Timestamp processedAt) {
        this.processedAt = processedAt;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public String getShippingMethod() {
        return shippingMethod;
    }

    public void setShippingMethod(String shippingMethod) {
        this.shippingMethod = shippingMethod;
    }

    public String getTrackingNumber() {
        return trackingNumber;
    }

    public void setTrackingNumber(String trackingNumber) {
        this.trackingNumber = trackingNumber;
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

    // Joined objects
    public Users getBuyer() {
        return buyer;
    }

    public void setBuyer(Users buyer) {
        this.buyer = buyer;
    }

    public Users getSeller() {
        return seller;
    }

    public void setSeller(Users seller) {
        this.seller = seller;
    }

    public Products getProduct() {
        return product;
    }

    public void setProduct(Products product) {
        this.product = product;
    }

    // ===== Compatibility helpers for legacy code (underscore style) =====
    // Getter aliases
    public Long getOrder_id() { return this.orderId; }
    public String getOrder_number() { return this.orderNumber; }
    public java.sql.Timestamp getCreated_at() { return this.createdAt; }
    public java.sql.Timestamp getUpdated_at() { return this.updatedAt; }
    public java.math.BigDecimal getTotal_amount() { return this.totalAmount; }
    public String getPayment_status() { return this.paymentStatus; }
    public String getOrder_status() { return this.orderStatus; }
    public String getDelivery_status() { return this.deliveryStatus; }
    public Users getSeller_id() { return this.seller; }
    public void setSeller_id(Users seller) { this.seller = seller; }
    public Users getBuyer_id() { return this.buyer; }
    public void setBuyer_id(Users buyer) { this.buyer = buyer; }
    // Setter aliases
    public void setTotal_amount(java.math.BigDecimal v) { this.totalAmount = v; }
    public void setShipping_address(String v) { this.shippingAddress = v; }
    public void setShipping_method(String v) { this.shippingMethod = v; }
    public void setTracking_number(String v) { this.trackingNumber = v; }
    // Getter aliases (underscore style)
    public String getShipping_address() { return this.shippingAddress; }
    public String getShipping_method() { return this.shippingMethod; }
    public String getTracking_number() { return this.trackingNumber; }
    public String getPayment_method() { return this.paymentMethod; }
    public String getQueue_status() { return this.queueStatus; }
    public String getTransaction_id() { return this.transactionId; }
    public String getStatus() { return this.orderStatus; }
    public void setStatus(String v) { this.orderStatus = v; }

    @Override
    public String toString() {
        return "Orders{" +
                "orderId=" + orderId +
                ", orderNumber='" + orderNumber + '\'' +
                ", buyerId=" + buyerId +
                ", sellerId=" + sellerId +
                ", productId=" + productId +
                ", quantity=" + quantity +
                ", totalAmount=" + totalAmount +
                ", paymentStatus='" + paymentStatus + '\'' +
                ", orderStatus='" + orderStatus + '\'' +
                ", queueStatus='" + queueStatus + '\'' +
                '}';
    }
}
