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
            int quantity = 1; // ✅ Fixed: Always 1 product per purchase
            
            // 2. Get product info
            Products product = productDAO.getProductById(productId);
            if (product == null) {
                jsonResponse.addProperty("status", "ERROR");
                jsonResponse.addProperty("message", "Sản phẩm không tồn tại!");
                response.getWriter().write(new Gson().toJson(jsonResponse));
                return;
            }
            
            // 3. Calculate total (quantity = 1)
            BigDecimal unitPrice = product.getPrice();
            BigDecimal totalAmount = unitPrice; // ✅ No need to multiply
            Long sellerId = Long.valueOf(product.getSeller_id().getUser_id());
            
            // 4. Start TRANSACTION
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            System.out.println("═══════════════════════════════════════════════");
            System.out.println("🛒 CHECKOUT FLOW:");
            System.out.println("   1. Tạo PENDING order");
            System.out.println("   2. Trừ tiền ví");
            System.out.println("   3. Update sang PAID");
            System.out.println("   4. Background job sẽ giao code");
            System.out.println("   Quantity: 1 (fixed)");
            System.out.println("═══════════════════════════════════════════════");
            
            // 5. ✨ BƯỚC 1: TẠO 1 PENDING ORDER (quantity = 1)
            Long pendingOrderId = orderDAO.createPendingOrder(
                Long.valueOf(user.getUser_id()), 
                sellerId, 
                productId,
                1, // Always 1 code per order
                unitPrice, // Price for 1 code
                conn
            );
            
            if (pendingOrderId == null) {
                conn.rollback();
                jsonResponse.addProperty("status", "ERROR");
                jsonResponse.addProperty("message", "Không thể tạo đơn hàng!");
                response.getWriter().write(new Gson().toJson(jsonResponse));
                return;
            }
            
            // Insert order_item
            orderDAO.insertOrderItem(pendingOrderId, null, productId, unitPrice, conn);
            
            System.out.println("  ✓ Created PENDING order ID: " + pendingOrderId);
            
            // 6. Tạo transaction ID
            long transactionId = System.currentTimeMillis();
            
            // 7. ✨ BƯỚC 2: TRỪ TIỀN VÍ
            boolean walletUpdated = withdrawFromWallet(conn, user.getUser_id(), totalAmount.doubleValue(), transactionId, product.getName());
            
            if (!walletUpdated) {
                conn.rollback();
                jsonResponse.addProperty("status", "INSUFFICIENT_BALANCE");
                jsonResponse.addProperty("message", "Số dư không đủ hoặc có lỗi khi trừ tiền!");
                response.getWriter().write(new Gson().toJson(jsonResponse));
                return;
            }
            
            System.out.println("  ✓ Wallet deducted: " + totalAmount + " VND");
            
            // 8. ✨ BƯỚC 3: UPDATE ORDER SANG PAID
            boolean updated = orderDAO.updateOrderToPaid(pendingOrderId, String.valueOf(transactionId), conn);
            
            if (!updated) {
                conn.rollback();
                jsonResponse.addProperty("status", "ERROR");
                jsonResponse.addProperty("message", "Không thể cập nhật trạng thái đơn hàng!");
                response.getWriter().write(new Gson().toJson(jsonResponse));
                return;
            }
            
            System.out.println("  ✓ Updated order to PAID: " + pendingOrderId);
            
            // 9. ✨ NOTE: KHÔNG gán code ở đây nữa
            //    Background job (OrderQueueProcessor) sẽ tự động:
            //    - Kiểm tra code available
            //    - Gán code cho order
            //    - Update status = 'delivered'
            //    - Hoặc refund nếu hết code
            
            // 10. Tạo PENDING TRANSACTION
            int holdDays = 7;
            Long pendingId = pendingTransactionDAO.createPendingTransaction(
                conn, pendingOrderId, // Use created order ID
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
            
            // 11. COMMIT transaction
            conn.commit();
            
            System.out.println("✅ CHECKOUT FLOW: Committed 1 PAID order!");
            System.out.println("   → Order ID: " + pendingOrderId);
            System.out.println("   → Order sẽ được xử lý bởi background job");
            System.out.println("   → User sẽ nhận code trong vài giây");
            
            // 12. ✨ Sync inventory SAU khi commit
            try {
                inventoryDAO.syncInventoryForProduct(productId);
            } catch (Exception e) {
                System.err.println("⚠️ Failed to sync inventory: " + e.getMessage());
            }
            
            // 13. ✨ Trả về success
            jsonResponse.addProperty("status", "SUCCESS");
            jsonResponse.addProperty("message", "Thanh toán thành công! Đơn hàng đang được xử lý...");
            jsonResponse.addProperty("orderId", pendingOrderId);
            jsonResponse.addProperty("processing", true); // Flag để UI biết đơn đang xử lý
            
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

