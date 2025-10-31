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

    // Admin receiver (change if needed)
    private static final String ADMIN_EMAIL = "admin@example.com"; // fallback; will auto-resolve a real admin if not found
    
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
            
            // 6. Tạo cặp transaction ID (tránh trùng khóa PK)
            long baseTxn = System.currentTimeMillis();
            long withdrawTxnId = baseTxn;      // for buyer withdraw
            long adminDepositTxnId = baseTxn + 1; // for admin credit
            
            // 7. Trừ tiền ví user
            boolean walletUpdated = withdrawFromWallet(conn, user.getUser_id(), totalAmount.doubleValue(), withdrawTxnId, product.getName());
            
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
                unitPrice, totalAmount, String.valueOf(withdrawTxnId)
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
            
            // 10. Chuyển tiền vào ví ADMIN ngay khi thanh toán thành công
            int adminId = 0;
            try {
                dao.UsersDAO usersDAO = new dao.UsersDAO();
                model.user.Users admin = usersDAO.getUserByEmail(ADMIN_EMAIL);
                if (admin == null) admin = usersDAO.getAnyAdminUser();
                if (admin != null) adminId = admin.getUser_id();
            } catch (Exception ignore) {}

            if (adminId <= 0) {
                conn.rollback();
                jsonResponse.addProperty("status", "ERROR");
                jsonResponse.addProperty("message", "Không tìm thấy tài khoản ADMIN để nhận tiền");
                response.getWriter().write(new Gson().toJson(jsonResponse));
                return;
            }

            String adminNote = String.format(
                    "Nhận tiền từ %s (User #%d) mua '%s' x%d - Order #%d",
                    user.getFull_name()!=null?user.getFull_name():("User"), user.getUser_id(),
                    product.getName(), quantity, orderId);

            boolean credited = creditToWallet(conn, adminId, totalAmount.doubleValue(), adminDepositTxnId, adminNote);
            if (!credited) {
                conn.rollback();
                jsonResponse.addProperty("status", "ERROR");
                jsonResponse.addProperty("message", "Không thể cộng tiền cho ADMIN!");
                response.getWriter().write(new Gson().toJson(jsonResponse));
                return;
            }

            // Record transfer linking buyer and admin
            long fromWalletId = getOrCreateWalletId(conn, user.getUser_id());
            long toWalletId = getOrCreateWalletId(conn, adminId);
            insertWalletTransfer(conn, user.getUser_id(), adminId, fromWalletId, toWalletId,
                    totalAmount.doubleValue(), withdrawTxnId, adminDepositTxnId,
                    "Purchase order #" + orderId + " - " + product.getName());

            // Update order to PAID (legacy will map to 'paid') and mark queue COMPLETED
            orderDAO.updateOrderStatus(orderId, "PAID", "COMPLETED");
            
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

    /**
     * Cộng tiền vào ví (dùng chung cho ADMIN nhận tiền)
     */
    private boolean creditToWallet(Connection conn, int userId, double amount, long transactionId, String note) throws SQLException {
        // Ensure wallet exists and lock
        String sqlGet = "SELECT wallet_id, balance FROM wallets WHERE user_id = ? FOR UPDATE";
        Long walletId = null; double oldBalance = 0;
        try (PreparedStatement ps = conn.prepareStatement(sqlGet)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    walletId = rs.getLong("wallet_id");
                    oldBalance = rs.getDouble("balance");
                }
            }
        }
        if (walletId == null) {
            // create wallet
            try (PreparedStatement ps = conn.prepareStatement("INSERT INTO wallets (user_id, balance, currency) VALUES (?, 0, 'VND')", Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, userId);
                ps.executeUpdate();
                try (ResultSet ks = ps.getGeneratedKeys()) { if (ks.next()) walletId = ks.getLong(1); }
            }
            oldBalance = 0;
        }

        double newBalance = oldBalance + amount;
        try (PreparedStatement ps = conn.prepareStatement("UPDATE wallets SET balance = ? WHERE wallet_id = ?")) {
            ps.setDouble(1, newBalance);
            ps.setLong(2, walletId);
            ps.executeUpdate();
        }

        try (PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO transactions (transaction_id, user_id, type, amount, currency, status, note) VALUES (?, ?, 'DEPOSIT', ?, 'VND', 'success', ?)")) {
            ps.setLong(1, transactionId);
            ps.setInt(2, userId);
            ps.setDouble(3, amount);
            ps.setString(4, note);
            ps.executeUpdate();
        }
        return true;
    }

    // Helpers to record transfer linking buyer and admin
    private long getOrCreateWalletId(Connection conn, int userId) throws SQLException {
        String q = "SELECT wallet_id FROM wallets WHERE user_id = ? FOR UPDATE";
        try (PreparedStatement ps = conn.prepareStatement(q)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getLong(1);
            }
        }
        try (PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO wallets (user_id, balance, currency) VALUES (?,0,'VND')",
                Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
            try (ResultSet k = ps.getGeneratedKeys()) { if (k.next()) return k.getLong(1); }
        }
        throw new SQLException("Cannot create wallet for user " + userId);
    }

    private void insertWalletTransfer(Connection conn, int fromUserId, int toUserId,
                                      long fromWalletId, long toWalletId, double amount,
                                      long txFrom, long txTo, String description) throws SQLException {
        ensureWalletTransfersTable(conn);
        String sql = "INSERT INTO wallet_transfers (from_user_id, to_user_id, from_wallet_id, to_wallet_id, amount, fee, net_amount, status, transaction_id_from, transaction_id_to, description) " +
                     "VALUES (?, ?, ?, ?, ?, 0, ?, 'completed', ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fromUserId);
            ps.setInt(2, toUserId);
            ps.setLong(3, fromWalletId);
            ps.setLong(4, toWalletId);
            ps.setDouble(5, amount);
            ps.setDouble(6, amount);
            ps.setLong(7, txFrom);
            ps.setLong(8, txTo);
            ps.setString(9, description);
            ps.executeUpdate();
        }
    }

    private void ensureWalletTransfersTable(Connection conn) throws SQLException {
        String ddl = "CREATE TABLE IF NOT EXISTS wallet_transfers (" +
                "transfer_id BIGINT NOT NULL AUTO_INCREMENT, " +
                "from_user_id BIGINT NOT NULL, " +
                "to_user_id BIGINT NOT NULL, " +
                "from_wallet_id BIGINT NOT NULL, " +
                "to_wallet_id BIGINT NOT NULL, " +
                "amount DECIMAL(15,2) NOT NULL, " +
                "fee DECIMAL(15,2) DEFAULT 0.00, " +
                "net_amount DECIMAL(15,2) NOT NULL, " +
                "status VARCHAR(20) DEFAULT 'completed', " +
                "transaction_id_from BIGINT, " +
                "transaction_id_to BIGINT, " +
                "description TEXT, " +
                "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                "PRIMARY KEY (transfer_id), " +
                "INDEX idx_transfer_from (from_user_id), " +
                "INDEX idx_transfer_to (to_user_id), " +
                "INDEX idx_transfer_status (status), " +
                "INDEX idx_transfer_created (created_at) " +
                ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci";
        try (java.sql.Statement st = conn.createStatement()) { st.executeUpdate(ddl); }
    }
}

