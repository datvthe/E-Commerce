/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.wallet;

import model.wallet.Wallets;
import model.order.Transactions;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class WalletHistory {

    private int historyId;
    private Wallets walletId;
    private Transactions transactionId;
    private BigDecimal amount;
    private BigDecimal balanceBefore;
    private BigDecimal balanceAfter;
    private String type;          // ENUM: deposit, withdraw, payment, refund
    private LocalDateTime createdAt;

    public WalletHistory() {
    }

    public WalletHistory(int historyId, Wallets walletId, Transactions transactionId, BigDecimal amount, BigDecimal balanceBefore, BigDecimal balanceAfter, String type, LocalDateTime createdAt) {
        this.historyId = historyId;
        this.walletId = walletId;
        this.transactionId = transactionId;
        this.amount = amount;
        this.balanceBefore = balanceBefore;
        this.balanceAfter = balanceAfter;
        this.type = type;
        this.createdAt = createdAt;
    }

    public int getHistoryId() {
        return historyId;
    }

    public void setHistoryId(int historyId) {
        this.historyId = historyId;
    }

    public Wallets getWalletId() {
        return walletId;
    }

    public void setWalletId(Wallets walletId) {
        this.walletId = walletId;
    }

    public Transactions getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(Transactions transactionId) {
        this.transactionId = transactionId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public BigDecimal getBalanceBefore() {
        return balanceBefore;
    }

    public void setBalanceBefore(BigDecimal balanceBefore) {
        this.balanceBefore = balanceBefore;
    }

    public BigDecimal getBalanceAfter() {
        return balanceAfter;
    }

    public void setBalanceAfter(BigDecimal balanceAfter) {
        this.balanceAfter = balanceAfter;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "WalletHistory{" + "historyId=" + historyId + ", walletId=" + walletId + ", transactionId=" + transactionId + ", amount=" + amount + ", balanceBefore=" + balanceBefore + ", balanceAfter=" + balanceAfter + ", type=" + type + ", createdAt=" + createdAt + '}';
    }

}
