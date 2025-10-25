package controller.wallet;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.WalletDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;

/**
 * ✅ Controller nhận Webhook từ SePay khi có giao dịch vào tài khoản - Khi SePay
 * gọi đến URL này (POST) - Server sẽ parse JSON, kiểm tra mô tả (VD: TOPUP-5) -
 * Tự động cộng tiền + lưu log giao dịch
 */
@WebServlet("/sepay/webhook")
public class SepayWebhookController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Đặt type trả về là JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Đọc dữ liệu JSON mà SePay gửi
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }

        String json = sb.toString();
        System.out.println("📩 Webhook nhận được từ SePay: " + json);

        try {
            // Parse JSON
            Gson gson = new Gson();
            JsonObject data = gson.fromJson(json, JsonObject.class);

            String description = data.has("description") ? data.get("description").getAsString() : "";
            double amount = data.has("amount") ? data.get("amount").getAsDouble() : 0;
            String transactionId = data.has("tran_id")
                    ? data.get("tran_id").getAsString()
                    : (data.has("tid") ? data.get("tid").getAsString() : "UNKNOWN");

            String bank = data.has("bank_name") ? data.get("bank_name").getAsString() : "Unknown Bank";

            WalletDAO walletDAO = new WalletDAO();
            int userId = walletDAO.findUserIdByDescription(description);

            if (userId == -1) {
                System.out.println("⚠️ Không tìm thấy userId trong mô tả: " + description);
                response.getWriter().write("{\"success\": false, \"message\": \"Invalid description\"}");
                return;
            }

            // Kiểm tra trùng giao dịch
            walletDAO.processTopUp(userId, amount, transactionId, bank);

            System.out.println("✅ Nạp tiền thành công: +" + amount + "đ cho user_id=" + userId);
            response.getWriter().write("{\"success\": true, \"message\": \"Deposit success\"}");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("{\"success\": false, \"message\": \"Server error: " + e.getMessage() + "\"}");
        }
    }
}
