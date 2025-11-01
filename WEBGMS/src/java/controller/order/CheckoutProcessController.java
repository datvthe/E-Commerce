package controller.order;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.*;
import model.order.DigitalGoodsCode;
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
import java.util.ArrayList;
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
    private final DigitalGoodsCodeDAO digitalGoodsDAO = new DigitalGoodsCodeDAO();
    private final OrderQueueDAO orderQueueDAO = new OrderQueueDAO();
    private final PendingTransactionDAO pendingTransactionDAO = new PendingTransactionDAO();
    private final InventoryDAO inventoryDAO = new InventoryDAO();
    
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
            
            System.out.println("═══════════════════════════════════════════════");
            System.out.println("🛒 CHECKOUT: 1 ORDER = 1 CODE DUY NHẤT");
            System.out.println("   User muốn: " + quantity + " codes");
            System.out.println("   → Tạo: " + quantity + " orders riêng biệt");
            System.out.println("═══════════════════════════════════════════════");
            
            // 5. ✨ Kiểm tra và lock digital codes
            List<DigitalGoodsCode> availableCodes = digitalGoodsDAO.getAvailableCodesWithLock(productId, quantity, conn);
            
            if (availableCodes.size() < quantity) {
                conn.rollback();
                System.err.println("❌ Out of stock! Requested: " + quantity + ", Available: " + availableCodes.size());
                jsonResponse.addProperty("status", "OUT_OF_STOCK");
                jsonResponse.addProperty("message", "Sản phẩm đã hết hàng! Còn lại: " + availableCodes.size());
                response.getWriter().write(new Gson().toJson(jsonResponse));
                return;
            }
            
            // 6. Tạo transaction ID
            long transactionId = System.currentTimeMillis();
            
            // 7. Trừ tiền ví user (TỔNG TIỀN cho tất cả codes)
            boolean walletUpdated = withdrawFromWallet(conn, user.getUser_id(), totalAmount.doubleValue(), transactionId, product.getName());
            
            if (!walletUpdated) {
                conn.rollback();
                jsonResponse.addProperty("status", "INSUFFICIENT_BALANCE");
                jsonResponse.addProperty("message", "Số dư không đủ hoặc có lỗi khi trừ tiền!");
                response.getWriter().write(new Gson().toJson(jsonResponse));
                return;
            }
            
            // 8. ✨ TẠO NHIỀU ORDERS (1 order per code)
            List<Long> createdOrderIds = new ArrayList<>();
            
            for (int i = 0; i < availableCodes.size(); i++) {
                DigitalGoodsCode code = availableCodes.get(i);
                
                // 8a. Tạo 1 order cho 1 code
                Long orderId = orderDAO.createInstantOrder(
                    Long.valueOf(user.getUser_id()), 
                    sellerId, 
                    unitPrice,  // Giá 1 code
                    String.valueOf(transactionId + i), // Unique transaction ID
                    conn
                );
                
                if (orderId == null) {
                    conn.rollback();
                    jsonResponse.addProperty("status", "ERROR");
                    jsonResponse.addProperty("message", "Không thể tạo đơn hàng!");
                    response.getWriter().write(new Gson().toJson(jsonResponse));
                    return;
                }
                
                // 8b. Insert vào order_items (link order với product và code)
                orderDAO.insertOrderItem(orderId, code.getCodeId(), productId, unitPrice, conn);
                
                // 8c. Đánh dấu code đã sử dụng
                boolean marked = digitalGoodsDAO.markCodeAsUsed(code.getCodeId(), Long.valueOf(user.getUser_id()), conn);
                if (!marked) {
                    conn.rollback();
                    jsonResponse.addProperty("status", "ERROR");
                    jsonResponse.addProperty("message", "Không thể cập nhật mã digital!");
                    response.getWriter().write(new Gson().toJson(jsonResponse));
                    return;
                }
                
                createdOrderIds.add(orderId);
                System.out.println("  ✓ Order " + (i+1) + "/" + quantity + ": ID=" + orderId + ", Code=" + code.getCodeId());
            }
            
            // 9. Tạo PENDING TRANSACTION (cho tổng tiền)
            int holdDays = 7;
            Long pendingId = pendingTransactionDAO.createPendingTransaction(
                conn, createdOrderIds.get(0), // Dùng order đầu tiên làm reference
                user.getUser_id(), 
                product.getSeller_id().getUser_id(),
                totalAmount, holdDays, transactionId
            );
            
            if (pendingId == null) {
                conn.rollback();
                jsonResponse.addProperty("status", "ERROR");
                jsonResponse.addProperty("message", "Không thể tạo pending transaction!");
                response.getWriter().write(new Gson().toJson(jsonResponse));
                return;
            }
            
            // 10. COMMIT transaction
            conn.commit();
            
            System.out.println("✅ Committed " + createdOrderIds.size() + " orders successfully!");
            
            // 11. ✨ Sync inventory SAU khi commit
            try {
                inventoryDAO.syncInventoryForProduct(productId);
            } catch (Exception e) {
                System.err.println("⚠️ Failed to sync inventory: " + e.getMessage());
            }
            
            // 12. Trả về success với danh sách order IDs
            jsonResponse.addProperty("status", "SUCCESS");
            jsonResponse.addProperty("message", "Đặt hàng thành công! Đã tạo " + createdOrderIds.size() + " đơn hàng");
            jsonResponse.addProperty("orderId", createdOrderIds.get(0)); // Order đầu tiên
            jsonResponse.addProperty("totalOrders", createdOrderIds.size());
            
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

