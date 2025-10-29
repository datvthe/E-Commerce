package controller.order;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.*;
import model.order.DigitalProduct;
import model.product.Products;
import model.user.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.util.List;

/**
 * CheckoutProcessController - Xử lý thanh toán đơn hàng digital goods
 * Sử dụng TRANSACTION để đảm bảo tính toàn vẹn dữ liệu
 */
@WebServlet(name = "CheckoutProcessController", urlPatterns = {"/checkout/process"})
public class CheckoutProcessController extends HttpServlet {
    
    private final ProductDAO productDAO = new ProductDAO();
    private final WalletDAO walletDAO = new WalletDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final DigitalProductDAO digitalProductDAO = new DigitalProductDAO();
    private final OrderQueueDAO orderQueueDAO = new OrderQueueDAO();
    private final PendingTransactionDAO pendingTransactionDAO = new PendingTransactionDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        JsonObject jsonResponse = new JsonObject();
        
        // Check login
        if (user == null) {
            jsonResponse.addProperty("status", "ERROR");
            jsonResponse.addProperty("message", "Vui lòng đăng nhập!");
            response.getWriter().write(new Gson().toJson(jsonResponse));
            return;
        }
        
        Connection conn = null;
        
        try {
            // 1. Parse JSON request
            StringBuilder sb = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            
            JsonObject requestData = new Gson().fromJson(sb.toString(), JsonObject.class);
            long productId = requestData.get("productId").getAsLong();
            int quantity = requestData.get("quantity").getAsInt();
            
            // 2. Get product info
            Products product = productDAO.getProductById(productId);
            if (product == null) {
                jsonResponse.addProperty("status", "ERROR");
                jsonResponse.addProperty("message", "Sản phẩm không tồn tại!");
                response.getWriter().write(new Gson().toJson(jsonResponse));
                return;
            }
            
            // 3. Calculate total
            BigDecimal unitPrice = product.getPrice();
            BigDecimal totalAmount = unitPrice.multiply(BigDecimal.valueOf(quantity));
            Long sellerId = Long.valueOf(product.getSeller_id().getUser_id());
            
            // 4. Start TRANSACTION
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // 5. Kiểm tra và lock digital products
            List<DigitalProduct> availableProducts = digitalProductDAO.getAvailableProducts(productId, quantity, conn);
            
            if (availableProducts.size() < quantity) {
                conn.rollback();
                jsonResponse.addProperty("status", "OUT_OF_STOCK");
                jsonResponse.addProperty("message", "Sản phẩm đã hết hàng! Còn lại: " + availableProducts.size());
                response.getWriter().write(new Gson().toJson(jsonResponse));
                return;
            }
            
            // 6. Tạo transaction ID (dùng số thay vì string)
            long transactionId = System.currentTimeMillis();
            
            // 7. Trừ tiền ví user (sử dụng WalletDAO.processTopUp với số âm)
            // Hoặc tạo method withdraw riêng
            boolean walletUpdated = withdrawFromWallet(conn, user.getUser_id(), totalAmount.doubleValue(), transactionId, product.getName());
            
            if (!walletUpdated) {
                conn.rollback();
                jsonResponse.addProperty("status", "INSUFFICIENT_BALANCE");
                jsonResponse.addProperty("message", "Số dư không đủ hoặc có lỗi khi trừ tiền!");
                response.getWriter().write(new Gson().toJson(jsonResponse));
                return;
            }
            
            // 8. Tạo order
            Long orderId = orderDAO.createInstantOrder(
                Long.valueOf(user.getUser_id()), sellerId, productId, quantity,
                unitPrice, totalAmount, String.valueOf(transactionId)
            );
            
            if (orderId == null) {
                conn.rollback();
                jsonResponse.addProperty("status", "ERROR");
                jsonResponse.addProperty("message", "Không thể tạo đơn hàng!");
                response.getWriter().write(new Gson().toJson(jsonResponse));
                return;
            }
            
            // 9. Đánh dấu digital products là đã bán
            for (DigitalProduct dp : availableProducts) {
                digitalProductDAO.markAsSold(dp.getDigitalId(), Long.valueOf(user.getUser_id()), orderId, conn);
                digitalProductDAO.linkDigitalProductToOrder(orderId, dp.getDigitalId(), conn);
            }
            
            // 10. Tạo PENDING TRANSACTION (giữ tiền 7 ngày trước khi chuyển cho seller)
            int holdDays = 7; // Giữ tiền 7 ngày
            Long pendingId = pendingTransactionDAO.createPendingTransaction(
                conn, orderId, user.getUser_id(), product.getSeller_id().getUser_id(),
                totalAmount, holdDays, transactionId
            );
            
            if (pendingId == null) {
                conn.rollback();
                jsonResponse.addProperty("status", "ERROR");
                jsonResponse.addProperty("message", "Không thể tạo pending transaction!");
                response.getWriter().write(new Gson().toJson(jsonResponse));
                return;
            }
            
            // 11. Thêm vào queue (để background worker xử lý thêm nếu cần)
            orderQueueDAO.addToQueue(orderId, 10); // Priority = 10
            
            // 12. Cập nhật order status thành COMPLETED (vì đã giao hàng ngay)
            orderDAO.updateOrderStatus(orderId, "COMPLETED", "COMPLETED");
            
            // 13. COMMIT transaction
            conn.commit();
            
            // 13. Trả về success
            jsonResponse.addProperty("status", "SUCCESS");
            jsonResponse.addProperty("message", "Đặt hàng thành công!");
            jsonResponse.addProperty("orderId", orderId);
            
            response.getWriter().write(new Gson().toJson(jsonResponse));
            
        } catch (NumberFormatException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
            jsonResponse.addProperty("status", "ERROR");
            jsonResponse.addProperty("message", "Dữ liệu không hợp lệ!");
            response.getWriter().write(new Gson().toJson(jsonResponse));
            
        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
            e.printStackTrace();
            jsonResponse.addProperty("status", "ERROR");
            jsonResponse.addProperty("message", "Lỗi database: " + e.getMessage());
            response.getWriter().write(new Gson().toJson(jsonResponse));
            
        } catch (Exception e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
            e.printStackTrace();
            jsonResponse.addProperty("status", "ERROR");
            jsonResponse.addProperty("message", "Có lỗi xảy ra: " + e.getMessage());
            response.getWriter().write(new Gson().toJson(jsonResponse));
            
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    /**
     * Trừ tiền từ ví user
     */
    private boolean withdrawFromWallet(Connection conn, int userId, double amount, long transactionId, String description) throws SQLException {
        // Lấy wallet info
        String sqlGetWallet = "SELECT wallet_id, balance FROM wallets WHERE user_id = ? FOR UPDATE";
        long walletId = 0;
        double oldBalance = 0;
        
        try (PreparedStatement ps = conn.prepareStatement(sqlGetWallet)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    walletId = rs.getLong("wallet_id");
                    oldBalance = rs.getDouble("balance");
                } else {
                    return false; // Wallet không tồn tại
                }
            }
        }
        
        // Kiểm tra số dư
        if (oldBalance < amount) {
            return false; // Không đủ tiền
        }
        
        double newBalance = oldBalance - amount;
        
        // Update wallet
        String sqlUpdate = "UPDATE wallets SET balance = ? WHERE wallet_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
            ps.setDouble(1, newBalance);
            ps.setLong(2, walletId);
            ps.executeUpdate();
        }
        
        // Insert transaction (simplified - chỉ các cột cần thiết)
        // Dùng 'WITHDRAW' vì đây là trừ tiền (type ENUM chỉ có DEPOSIT, WITHDRAW, TRANSFER)
        String sqlTrans = "INSERT INTO transactions " +
                         "(transaction_id, user_id, type, amount, currency, status, note) " +
                         "VALUES (?, ?, 'WITHDRAW', ?, 'VND', 'success', ?)";
        
        try (PreparedStatement ps = conn.prepareStatement(sqlTrans)) {
            ps.setLong(1, transactionId);  // transaction_id là BIGINT
            ps.setInt(2, userId);
            ps.setDouble(3, amount);
            ps.setString(4, "Mua sản phẩm: " + description);
            ps.executeUpdate();
        }
        
        return true;
    }
}

