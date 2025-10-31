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

            // ✅ Hỗ trợ cả format test và SePay real
            // Description: ưu tiên "content" (SePay real), fallback "description"
            String description = data.has("content") 
                    ? data.get("content").getAsString() 
                    : (data.has("description") ? data.get("description").getAsString() : "");
            
            // Amount: ưu tiên "transferAmount" (SePay real), fallback "amount"
            double amount = data.has("transferAmount") 
                    ? data.get("transferAmount").getAsDouble() 
                    : (data.has("amount") ? data.get("amount").getAsDouble() : 0);
            
            // Transaction ID: ưu tiên "id" (SePay real), fallback "tran_id"
            String transactionId = data.has("id") 
                    ? data.get("id").getAsString() 
                    : (data.has("tran_id") ? data.get("tran_id").getAsString() : 
                      (data.has("tid") ? data.get("tid").getAsString() : "UNKNOWN"));

            // Bank: ưu tiên "gateway" (SePay real), fallback "bank_name"
            String bank = data.has("gateway") 
                    ? data.get("gateway").getAsString() 
                    : (data.has("bank_name") ? data.get("bank_name").getAsString() : "Unknown Bank");

            System.out.println("🔍 DEBUG - Description: " + description);
            System.out.println("🔍 DEBUG - Amount: " + amount);
            System.out.println("🔍 DEBUG - Transaction ID: " + transactionId);
            System.out.println("🔍 DEBUG - Bank: " + bank);

            WalletDAO walletDAO = new WalletDAO();
            int userId = walletDAO.findUserIdByDescription(description);
            
            System.out.println("🔍 DEBUG - Parsed User ID: " + userId);

            if (userId == -1) {
                System.out.println("⚠️ Không tìm thấy userId trong mô tả: " + description);
                System.out.println("⚠️ Format đúng phải là: TOPUP-{số}");
                response.getWriter().write("{\"success\": false, \"message\": \"Invalid description format. Expected: TOPUP-{number}\"}");
                return;
            }

            // Kiểm tra user tồn tại
            System.out.println("🔍 DEBUG - Checking if user exists...");
            
            // Kiểm tra wallet tồn tại
            System.out.println("🔍 DEBUG - Processing top up...");
            walletDAO.processTopUp(userId, amount, transactionId, bank);

            System.out.println("✅ Nạp tiền thành công: +" + amount + "đ cho user_id=" + userId);
            System.out.println("✅ Transaction ID: " + transactionId);
            response.getWriter().write("{\"success\": true, \"message\": \"Deposit success\", \"user_id\": " + userId + ", \"amount\": " + amount + "}");

        } catch (Exception e) {
            System.err.println("❌ ERROR in webhook: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("{\"success\": false, \"message\": \"Server error: " + e.getMessage() + "\"}");
        }
    }
}
