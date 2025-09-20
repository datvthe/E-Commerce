/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.order;

import model.order.Orders;
import java.time.LocalDateTime;

public class Payments {

    private int paymentId;
    private Orders orderId;
    private String method;      // ENUM: Wallet, VNPay, PayPal, Stripe, COD
    private String status;      // ENUM: pending, success, failed
    private Long transactionId;
    private LocalDateTime paidAt;

    public Payments() {
    }

    public Payments(int paymentId, Orders orderId, String method, String status, Long transactionId, LocalDateTime paidAt) {
        this.paymentId = paymentId;
        this.orderId = orderId;
        this.method = method;
        this.status = status;
        this.transactionId = transactionId;
        this.paidAt = paidAt;
    }

    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public Orders getOrderId() {
        return orderId;
    }

    public void setOrderId(Orders orderId) {
        this.orderId = orderId;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Long getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }

    public LocalDateTime getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(LocalDateTime paidAt) {
        this.paidAt = paidAt;
    }

    @Override
    public String toString() {
        return "Payments{" + "paymentId=" + paymentId + ", orderId=" + orderId + ", method=" + method + ", status=" + status + ", transactionId=" + transactionId + ", paidAt=" + paidAt + '}';
    }

}
