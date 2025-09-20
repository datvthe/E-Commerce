/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.wallet;

import model.user.Users;
import java.math.BigDecimal;

public class Wallets {

    private int walletId;
    private Users userId;
    private BigDecimal balance;
    private String currency;

    public Wallets() {
    }

    public Wallets(int walletId, Users userId, BigDecimal balance, String currency) {
        this.walletId = walletId;
        this.userId = userId;
        this.balance = balance;
        this.currency = currency;
    }

    public int getWalletId() {
        return walletId;
    }

    public void setWalletId(int walletId) {
        this.walletId = walletId;
    }

    public Users getUserId() {
        return userId;
    }

    public void setUserId(Users userId) {
        this.userId = userId;
    }

    public BigDecimal getBalance() {
        return balance;
    }

    public void setBalance(BigDecimal balance) {
        this.balance = balance;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    @Override
    public String toString() {
        return "Wallets{" + "walletId=" + walletId + ", userId=" + userId + ", balance=" + balance + ", currency=" + currency + '}';
    }

}
