# 🎮 LUỒNG MUA HÀNG TÀI NGUYÊN SỐ - INSTANT DELIVERY

## 🎯 TỔNG QUAN

Hệ thống bán **tài nguyên số** (thẻ cào, tài khoản game, serial key, v.v.) với:
- ✅ **Mua ngay** - Không cần giỏ hàng
- ✅ **Thanh toán ví ảo** - Nạp tiền nếu thiếu
- ✅ **Giao hàng tức thì** - Hiển thị mã/mật khẩu ngay
- ✅ **Queue system** - Xử lý đồng thời nhiều đơn

---

## 🚀 LUỒNG MUA HÀNG CHI TIẾT

### **BƯỚC 1: CHỌN SẢN PHẨM** 
**URL:** `/product/{slug}`

```
┌────────────────────────────────────┐
│  TRANG SẢN PHẨM                    │
├────────────────────────────────────┤
│  [Ảnh sản phẩm]                    │
│                                    │
│  Thẻ cào Viettel 100,000₫         │
│  Giá: 95,000₫                      │
│                                    │
│  Số lượng: [- 1 +]                 │
│                                    │
│  [⚡ MUA NGAY]  [❤️ Yêu thích]    │
└────────────────────────────────────┘
```

**User click "MUA NGAY":**
```javascript
function buyNow() {
    const quantity = document.getElementById('quantity').value;
    const productId = ${product.product_id};
    
    // Redirect trực tiếp đến checkout
    window.location.href = contextPath + '/checkout/instant?productId=' + productId + '&quantity=' + quantity;
}
```

---

### **BƯỚC 2: KIỂM TRA SỐ DƯ**
**URL:** `/checkout/instant`

**Backend Logic:**
```java
@WebServlet("/checkout/instant")
public class InstantCheckoutController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) {
        // 1. Get params
        long productId = Long.parseLong(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        Users user = (Users) request.getSession().getAttribute("user");
        
        // 2. Get product info
        ProductDAO productDAO = new ProductDAO();
        Products product = productDAO.getProductById(productId);
        
        // 3. Calculate total
        BigDecimal unitPrice = product.getPrice();
        BigDecimal total = unitPrice.multiply(BigDecimal.valueOf(quantity));
        
        // 4. Get wallet balance
        WalletDAO walletDAO = new WalletDAO();
        double balance = walletDAO.getBalance(user.getUser_id());
        
        // 5. Check balance
        if (balance < total.doubleValue()) {
            // Thiếu tiền → Chuyển đến trang nạp tiền
            request.setAttribute("requiredAmount", total);
            request.setAttribute("currentBalance", balance);
            request.setAttribute("shortfall", total.doubleValue() - balance);
            request.getRequestDispatcher("/views/common/wallet-deposit-required.jsp").forward(request, response);
            return;
        }
        
        // 6. Đủ tiền → Hiển thị trang xác nhận
        request.setAttribute("product", product);
        request.setAttribute("quantity", quantity);
        request.setAttribute("total", total);
        request.setAttribute("balance", balance);
        request.getRequestDispatcher("/views/user/checkout-instant.jsp").forward(request, response);
    }
}
```

---

### **BƯỚC 2A: THIẾU TIỀN → NẠP TIỀN**

**Trang: `wallet-deposit-required.jsp`**

```
┌────────────────────────────────────┐
│  ⚠️ SỐ DƯ KHÔNG ĐỦ                │
├────────────────────────────────────┤
│  Tổng đơn hàng:    95,000₫        │
│  Số dư hiện tại:   50,000₫        │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━       │
│  Cần nạp thêm:     45,000₫        │
├────────────────────────────────────┤
│  💡 Gợi ý: Nạp 100,000₫            │
│     để dư dùng cho lần sau         │
├────────────────────────────────────┤
│  [Nạp tiền ngay →]  [◄ Quay lại]  │
└────────────────────────────────────┘
```

**Sau khi nạp tiền xong:**
```javascript
// Webhook SePay tự động cộng tiền
// Redirect về checkout page
window.location.href = '/checkout/instant?productId=123&quantity=1';
```

---

### **BƯỚC 3: XÁC NHẬN & THANH TOÁN**

**Trang: `checkout-instant.jsp`**

```
┌────────────────────────────────────┐
│  🛒 XÁC NHẬN ĐƠN HÀNG              │
├────────────────────────────────────┤
│  [Ảnh] Thẻ cào Viettel 100K       │
│        95,000₫ x 1 = 95,000₫      │
├────────────────────────────────────┤
│  📊 CHI TIẾT THANH TOÁN            │
├────────────────────────────────────┤
│  Tạm tính:           95,000₫      │
│  Giảm giá:                 0₫      │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━       │
│  TỔNG CỘNG:          95,000₫      │
├────────────────────────────────────┤
│  💰 THANH TOÁN                     │
├────────────────────────────────────┤
│  ● Ví ảo Gicungco                 │
│    Số dư: 500,000₫                │
│    Sau TT: 405,000₫               │
├────────────────────────────────────┤
│  ☑️ Tôi đồng ý với điều khoản     │
├────────────────────────────────────┤
│  [✓ XÁC NHẬN THANH TOÁN]          │
└────────────────────────────────────┘
```

**Click "XÁC NHẬN":**
```javascript
function confirmPayment() {
    const productId = ${product.product_id};
    const quantity = ${quantity};
    
    // Show loading
    showLoading('Đang xử lý thanh toán...');
    
    fetch(contextPath + '/checkout/process', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({
            productId: productId,
            quantity: quantity,
            paymentMethod: 'WALLET'
        })
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'SUCCESS') {
            // Chuyển đến trang order success
            window.location.href = contextPath + '/order/success?orderId=' + data.orderId;
        } else if (data.status === 'INSUFFICIENT_BALANCE') {
            // Chuyển đến nạp tiền
            alert(data.message);
            window.location.href = contextPath + '/wallet';
        } else {
            alert('Lỗi: ' + data.message);
        }
    });
}
```

---

### **BƯỚC 4: XỬ LÝ THANH TOÁN (BACKEND)**

**Controller: `CheckoutProcessController.java`**

```java
@WebServlet("/checkout/process")
public class CheckoutProcessController extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
        // Parse JSON
        JsonObject json = parseJsonBody(request);
        long productId = json.get("productId").getAsLong();
        int quantity = json.get("quantity").getAsInt();
        Users user = (Users) request.getSession().getAttribute("user");
        
        // Call stored procedure
        Connection conn = DBConnection.getConnection();
        CallableStatement stmt = conn.prepareCall(
            "{CALL sp_process_instant_purchase(?, ?, ?, ?, ?, ?)}"
        );
        
        stmt.setLong(1, user.getUser_id());
        stmt.setLong(2, productId);
        stmt.setInt(3, quantity);
        stmt.registerOutParameter(4, Types.BIGINT); // order_id
        stmt.registerOutParameter(5, Types.VARCHAR); // status
        stmt.registerOutParameter(6, Types.VARCHAR); // message
        
        stmt.execute();
        
        long orderId = stmt.getLong(4);
        String status = stmt.getString(5);
        String message = stmt.getString(6);
        
        // Return JSON
        JsonObject result = new JsonObject();
        result.addProperty("status", status);
        result.addProperty("message", message);
        result.addProperty("orderId", orderId);
        
        response.getWriter().write(result.toString());
    }
}
```

---

### **BƯỚC 5: QUEUE XỬ LÝ TỰ ĐỘNG**

**Background Worker (chạy mỗi 5 giây):**

```java
@WebServlet(loadOnStartup = 1)
public class OrderQueueProcessor extends HttpServlet {
    
    private ScheduledExecutorService scheduler;
    
    @Override
    public void init() {
        // Tạo scheduler chạy mỗi 5 giây
        scheduler = Executors.newScheduledThreadPool(1);
        scheduler.scheduleAtFixedRate(() -> {
            processQueue();
        }, 0, 5, TimeUnit.SECONDS);
    }
    
    private void processQueue() {
        try {
            Connection conn = DBConnection.getConnection();
            
            // Lấy các order đang chờ
            String sql = "SELECT queue_id FROM order_queue " +
                        "WHERE status = 'WAITING' " +
                        "ORDER BY priority DESC, created_at ASC " +
                        "LIMIT 10";
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                long queueId = rs.getLong("queue_id");
                
                // Call procedure xử lý
                CallableStatement stmt = conn.prepareCall(
                    "{CALL sp_process_order_queue(?, ?, ?)}"
                );
                stmt.setLong(1, queueId);
                stmt.registerOutParameter(2, Types.VARCHAR);
                stmt.registerOutParameter(3, Types.VARCHAR);
                stmt.execute();
                
                String status = stmt.getString(2);
                String message = stmt.getString(3);
                
                System.out.println("[Queue] Processed queue #" + queueId + ": " + status);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    @Override
    public void destroy() {
        if (scheduler != null) {
            scheduler.shutdown();
        }
    }
}
```

---

### **BƯỚC 6: HIỂN THỊ SẢN PHẨM NGAY**

**URL:** `/order/success?orderId=123`

**Trang: `order-success.jsp`**

```
┌────────────────────────────────────┐
│  ✅ ĐẶT HÀNG THÀNH CÔNG!           │
├────────────────────────────────────┤
│  Mã đơn hàng: #ORDER-20251029-001 │
│  Trạng thái: Đã giao hàng          │
├────────────────────────────────────┤
│  📦 SẢN PHẨM CỦA BẠN               │
├────────────────────────────────────┤
│  🎫 Thẻ cào Viettel 100K (x1)     │
│                                    │
│  ┌──────────────────────────────┐ │
│  │ MÃ THẺ:     1234567890123   │ │
│  │ SERIAL:     9876543210       │ │
│  │ HẠN SỬ DỤNG: 29/10/2026     │ │
│  │                              │ │
│  │ [📋 Copy mã]  [💾 Tải về]   │ │
│  └──────────────────────────────┘ │
├────────────────────────────────────┤
│  💰 THANH TOÁN                     │
├────────────────────────────────────┤
│  Tổng tiền:      95,000₫          │
│  Phương thức: Ví ảo Gicungco      │
│  Số dư còn lại:  405,000₫         │
├────────────────────────────────────┤
│  [Xem đơn hàng]  [Tiếp tục mua]   │
└────────────────────────────────────┘
```

**Backend:**
```java
@WebServlet("/order/success")
public class OrderSuccessController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) {
        long orderId = Long.parseLong(request.getParameter("orderId"));
        
        // Get order with digital items
        String sql = "SELECT o.*, " +
                    "dp.code, dp.password, dp.serial, dp.expires_at " +
                    "FROM orders o " +
                    "JOIN order_digital_items odi ON o.order_id = odi.order_id " +
                    "JOIN digital_products dp ON odi.digital_id = dp.digital_id " +
                    "WHERE o.order_id = ?";
        
        // Load data
        List<DigitalItem> items = ...;
        
        request.setAttribute("order", order);
        request.setAttribute("digitalItems", items);
        request.getRequestDispatcher("/views/user/order-success.jsp").forward(request, response);
    }
}
```

---

## 📊 **DATABASE SCHEMA**

### **Quan hệ giữa các bảng:**

```
users (người mua/bán)
  ↓
wallets (ví ảo)
  ↓
transactions (giao dịch)

products (sản phẩm)
  ↓
digital_products (kho mã thẻ/tài khoản)
  ↓
orders (đơn hàng)
  ↓
order_digital_items (sản phẩm đã giao)
  ↓
order_queue (hàng đợi xử lý)
```

---

## 🔄 **QUEUE PROCESSING**

### **Tại sao cần Queue?**

1. **Xử lý đồng thời:** Nhiều user mua cùng lúc
2. **Tránh race condition:** 2 user mua cùng 1 mã
3. **Retry mechanism:** Tự động thử lại nếu lỗi
4. **Priority:** Ưu tiên đơn hàng VIP/lớn

### **Queue States:**

```
WAITING      → Đang chờ xử lý
    ↓
PROCESSING   → Đang gán mã/tài khoản
    ↓
COMPLETED    → Đã giao hàng thành công
    
FAILED       → Lỗi (hết hàng, lỗi hệ thống)
```

### **Cách thức hoạt động:**

```java
// Background worker chạy mỗi 5 giây
while (true) {
    // 1. Lấy 10 orders đầu tiên trong queue
    List<QueueItem> items = queueDAO.getWaitingItems(10);
    
    for (QueueItem item : items) {
        // 2. Xử lý từng order
        processOrder(item.getOrderId());
        
        // 3. Gán digital products
        assignDigitalProducts(item.getOrderId());
        
        // 4. Cập nhật trạng thái
        queueDAO.markCompleted(item.getQueueId());
    }
    
    Thread.sleep(5000); // Chờ 5 giây
}
```

---

## 💡 **FEATURES ĐẶC BIỆT**

### **1. Auto Refund (nếu hết hàng):**

```java
if (availableStock < quantity) {
    // Hoàn tiền tự động
    walletDAO.deposit(userId, totalAmount, "REFUND-" + orderNumber);
    
    // Cập nhật order
    orderDAO.updateStatus(orderId, "CANCELED");
    
    // Thông báo
    notificationDAO.create(userId, "Đơn hàng đã được hoàn tiền do hết hàng");
}
```

### **2. Instant Notification:**

```java
// Sau khi giao hàng
WebSocketSession session = getUserWebSocket(userId);
if (session != null) {
    session.sendMessage(new TextMessage(
        "{\"type\":\"ORDER_COMPLETED\",\"orderId\":" + orderId + "}"
    ));
}

// Email
emailService.sendOrderCompletedEmail(user, order, digitalItems);
```

### **3. Download Order as File:**

```java
@WebServlet("/order/download")
public class OrderDownloadController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) {
        long orderId = Long.parseLong(request.getParameter("orderId"));
        
        // Get digital items
        List<DigitalProduct> items = digitalProductDAO.getByOrderId(orderId);
        
        // Generate text file
        StringBuilder content = new StringBuilder();
        content.append("=".repeat(50)).append("\n");
        content.append("ĐƠN HÀNG: #ORDER-").append(orderId).append("\n");
        content.append("=".repeat(50)).append("\n\n");
        
        for (DigitalProduct item : items) {
            content.append("MÃ: ").append(item.getCode()).append("\n");
            if (item.getSerial() != null) {
                content.append("SERIAL: ").append(item.getSerial()).append("\n");
            }
            if (item.getPassword() != null) {
                content.append("MẬT KHẨU: ").append(item.getPassword()).append("\n");
            }
            content.append("\n");
        }
        
        // Download
        response.setContentType("text/plain");
        response.setHeader("Content-Disposition", 
            "attachment; filename=ORDER-" + orderId + ".txt");
        response.getWriter().write(content.toString());
    }
}
```

---

## 🎨 **UI COMPONENTS CẦN TẠO**

### **Files cần tạo:**

1. ✅ `InstantCheckoutController.java` - Xử lý checkout instant
2. ✅ `CheckoutProcessController.java` - Xử lý thanh toán
3. ✅ `OrderSuccessController.java` - Hiển thị kết quả
4. ✅ `OrderQueueProcessor.java` - Background worker
5. ✅ `checkout-instant.jsp` - Trang xác nhận
6. ✅ `order-success.jsp` - Trang hiển thị mã/tài khoản
7. ✅ `wallet-deposit-required.jsp` - Trang thiếu tiền
8. ✅ `my-orders.jsp` - Lịch sử đơn hàng

### **JavaScript:**
- ✅ `checkout.js` - Xử lý thanh toán
- ✅ `order-queue.js` - Polling queue status

---

## 🚀 **ROADMAP IMPLEMENT**

### **Phase 1: Core (1-2 ngày)**
- [x] Database tables
- [ ] InstantCheckoutController
- [ ] CheckoutProcessController  
- [ ] OrderSuccessController
- [ ] checkout-instant.jsp
- [ ] order-success.jsp

### **Phase 2: Queue (1 ngày)**
- [ ] OrderQueueProcessor
- [ ] Background worker
- [ ] Queue monitoring

### **Phase 3: Extras (1 ngày)**
- [ ] Wallet deposit required page
- [ ] My orders page
- [ ] Download order file
- [ ] Email notifications

---

## ✅ **HOÀN TẤT!**

Đây là luồng **ĐƠN GIẢN, NHANH, HIỆU QUẢ** cho digital goods!

**Bạn muốn tôi bắt đầu implement ngay không?** 🚀

