# Admin Order Management System - Complete Flow Guide

## Overview
The order management system handles viewing, creating, updating status, and deleting orders. It consists of three main layers: **Controller**, **DAO (Data Access Object)**, and **Model**.

---

## Architecture Layers

### 1. **MODEL LAYER** - `Orders.java`
The data structure that represents an order.

```java
public class Orders {
    // Primary identifiers
    private Long orderId;              // Unique order ID (auto-increment)
    private String orderNumber;        // Human-readable (ORDER-YYYYMMDD-XXXXX)
    
    // Foreign keys
    private Long buyerId;              // User ID of buyer
    private Long sellerId;             // User ID of seller
    private Long productId;            // Product ID
    
    // Order content
    private Integer quantity;          // Number of items
    private BigDecimal unitPrice;      // Price per item
    private BigDecimal totalAmount;    // Total payment
    private String currency;           // Currency (VND)
    
    // Status tracking
    private String paymentMethod;      // Payment method (WALLET, GATEWAY)
    private String paymentStatus;      // PENDING, PAID, FAILED, REFUNDED
    private String orderStatus;        // PENDING, PROCESSING, COMPLETED, FAILED, CANCELED
    private String deliveryStatus;     // INSTANT (for digital goods)
    private String queueStatus;        // WAITING, PROCESSING, COMPLETED, FAILED
    
    // Timestamps
    private Timestamp createdAt;       // Order creation time
    private Timestamp updatedAt;       // Last update time
    private Timestamp processedAt;     // When order was fully processed
    
    // Joined data (for display)
    private Users buyer;               // Buyer details
    private Users seller;              // Seller details
    private Products product;          // Product details
}
```

**Status Flow:**
```
PENDING → PAID → PROCESSING → COMPLETED
   ↓        ↓         ↓            ↓
FAILED   REFUNDED   FAILED     SUCCESS
```

---

## 2. **CONTROLLER LAYER** - `AdminOrdersController.java`

### Routing Map
```
/admin/orders                    → GET  → List all orders (doGet)
/admin/orders/view?id=X         → GET  → View order detail
/admin/orders/create            → GET  → Show create form
/admin/orders/save              → POST → Save new order
/admin/orders/update-status     → POST → Update order status
/admin/orders/delete            → POST → Delete order
```

### Request Entry Point
```java
@WebServlet(urlPatterns = {
    "/admin/orders",
    "/admin/orders/view",
    "/admin/orders/create",
    "/admin/orders/save",
    "/admin/orders/update-status",
    "/admin/orders/delete"
})
public class AdminOrdersController extends HttpServlet
```

---

## 3. **MAIN CONTROLLER FUNCTIONS**

### **Function 1: `doGet()` - Fetch and Display Orders**

**Purpose:** Handle GET requests for displaying orders

**Flow:**

```java
protected void doGet(HttpServletRequest request, HttpServletResponse response) {
    // Step 1: Check if user is admin
    if (!rbac.isAdmin(request)) {
        response.sendRedirect("/home?error=access_denied");
        return;
    }
    
    String path = request.getServletPath();  // Get which endpoint is called
```

#### **Sub-Function 1.1: `/admin/orders` - List All Orders**

```java
if ("/admin/orders".equals(path)) {
    // Parse pagination
    String status = request.getParameter("status");        // Filter by status
    int page = Integer.parseInt(request.getParameter("page", "1"));
    int pageSize = 10;                                      // Orders per page
    
    // Fetch orders from database
    List<Orders> orders;
    if (status == null || status.isEmpty()) {
        orders = orderDAO.getAllOrders(null, page, pageSize);  // Get all
    } else {
        orders = orderDAO.getAllOrders(status, page, pageSize); // Filter by status
    }
    
    // Calculate pagination info
    int totalOrders = orderDAO.getOrderCount(status);
    int totalPages = (int) Math.ceil((double) totalOrders / pageSize);
    
    // Get flash messages from session (from previous POST)
    HttpSession sess = request.getSession(false);
    Object success = sess.getAttribute("flash_success");    // e.g., "Order updated successfully"
    Object error = sess.getAttribute("flash_error");        // e.g., "Failed to update order"
    
    // Set attributes for JSP to display
    request.setAttribute("orders", orders);
    request.setAttribute("currentPage", page);
    request.setAttribute("totalPages", totalPages);
    request.setAttribute("status", status);
    request.setAttribute("success", success);
    request.setAttribute("error", error);
    
    // Forward to JSP for rendering
    request.getRequestDispatcher("/views/admin/admin-orders.jsp").forward(request, response);
}
```

**Database Call:** `OrderDAO.getAllOrders(status, page, pageSize)`

---

#### **Sub-Function 1.2: `/admin/orders/view?id=X` - View Single Order**

```java
if ("/admin/orders/view".equals(path)) {
    try {
        int orderId = Integer.parseInt(request.getParameter("id"));
        
        // Fetch order details
        Orders order = orderDAO.getOrderById(orderId);
        if (order == null) {
            response.sendRedirect("/admin/orders?error=Order not found");
            return;
        }
        
        // Fetch associated items
        List<OrderItems> items = orderDAO.getOrderItems(orderId);           // Physical products
        List<DigitalProduct> digitalItems = digitalProductDAO
            .getDigitalProductsByOrderId((long) orderId);                   // Digital products
        
        // Set attributes for display
        request.setAttribute("order", order);
        request.setAttribute("orderItems", items);
        request.setAttribute("digitalItems", digitalItems);
        
        // Forward to detail page
        request.getRequestDispatcher("/views/admin/admin-order-detail.jsp")
            .forward(request, response);
    } catch (Exception e) {
        response.sendRedirect("/admin/orders?error=Invalid ID");
    }
}
```

**Displays:**
- Order header (ID, status, total, dates)
- Buyer info (name, email)
- Seller info (name, email)
- Shipping details
- Order items table (physical products)
- Digital items table (digital products with code/serial/password)

---

#### **Sub-Function 1.3: `/admin/orders/create` - Show Create Form**

```java
if ("/admin/orders/create".equals(path)) {
    // Simply forward to the create form (form will submit via POST)
    request.getRequestDispatcher("/views/admin/admin-order-create.jsp")
        .forward(request, response);
}
```

---

### **Function 2: `doPost()` - Handle Modifications**

**Purpose:** Handle POST requests for creating, updating, and deleting orders

```java
protected void doPost(HttpServletRequest request, HttpServletResponse response) {
    // Step 1: Check admin access
    if (!rbac.isAdmin(request)) {
        response.sendRedirect("/home?error=access_denied");
        return;
    }
    
    String path = request.getServletPath();
```

---

#### **Sub-Function 2.1: `/admin/orders/update-status` - Update Order Status**

```java
if ("/admin/orders/update-status".equals(path)) {
    try {
        // Parse form data
        int orderId = Integer.parseInt(request.getParameter("order_id"));
        String newStatus = request.getParameter("status");  // paid, shipped, delivered, etc.
        
        // Call DAO to update
        boolean ok = orderDAO.updateOrderStatus(orderId, newStatus);
        
        if (ok) {
            // Notify buyer about status change
            Orders order = orderDAO.getOrderById(orderId);
            if (order != null && order.getBuyerId() != null) {
                String title = "Order Approved";
                String message = String.format("Order #%d approved. Status: %s", orderId, newStatus);
                
                // Send notification to buyer
                new NotificationService().sendNotificationToUser(
                    order.getBuyerId().intValue(), 
                    title, 
                    message, 
                    "order"
                );
            }
            
            // Store success message in session (for next page load)
            request.getSession().setAttribute("flash_success", 
                "Order #" + orderId + " updated successfully");
            
            // Redirect back to orders list
            response.sendRedirect("/admin/orders");
        } else {
            request.getSession().setAttribute("flash_error", 
                "Failed to update status");
            response.sendRedirect("/admin/orders");
        }
    } catch (Exception e) {
        request.getSession().setAttribute("flash_error", "Invalid data");
        response.sendRedirect("/admin/orders");
    }
}
```

**Process:**
1. Extract `order_id` and new `status` from form
2. Call `OrderDAO.updateOrderStatus(orderId, status)`
3. If successful, send notification to buyer
4. Store success/error message in session as "flash message"
5. Redirect to order list (flash messages display on next load)

---

#### **Sub-Function 2.2: `/admin/orders/delete` - Delete Order**

```java
if ("/admin/orders/delete".equals(path)) {
    try {
        int orderId = Integer.parseInt(request.getParameter("id"));
        
        // Call DAO to delete
        boolean success = orderDAO.deleteOrder(orderId);
        
        if (success) {
            response.sendRedirect("/admin/orders?success=Order deleted");
        } else {
            response.sendRedirect("/admin/orders?error=Cannot delete order");
        }
    } catch (Exception e) {
        response.sendRedirect("/admin/orders?error=Invalid data");
    }
}
```

**Process:**
1. Extract order ID
2. Call `OrderDAO.deleteOrder(orderId)`
3. Redirect with success/error message in URL query string

---

#### **Sub-Function 2.3: `/admin/orders/save` - Create New Order**

```java
if ("/admin/orders/save".equals(path)) {
    try {
        // Parse form data
        int buyerId = Integer.parseInt(request.getParameter("buyer_id"));
        int sellerId = Integer.parseInt(request.getParameter("seller_id"));
        BigDecimal totalAmount = new BigDecimal(request.getParameter("total_amount"));
        String currency = request.getParameter("currency");
        String shippingAddress = request.getParameter("shipping_address");
        String shippingMethod = request.getParameter("shipping_method");
        String trackingNumber = request.getParameter("tracking_number");
        String status = request.getParameter("status");
        
        // Create Order object
        Orders order = new Orders();
        Users buyer = new Users(); 
        buyer.setUser_id(buyerId);
        order.setBuyer(buyer);
        
        Users seller = new Users();
        seller.setUser_id(sellerId);
        order.setSeller(seller);
        
        order.setTotalAmount(totalAmount);
        order.setCurrency(currency);
        order.setShippingAddress(shippingAddress);
        order.setShippingMethod(shippingMethod);
        order.setTrackingNumber(trackingNumber);
        order.setOrderStatus(status);
        
        // Save to database
        int newId = orderDAO.createOrder(order);
        
        if (newId > 0) {
            // Redirect to view newly created order
            response.sendRedirect("/admin/orders/view?id=" + newId + 
                "&success=Order created successfully");
        } else {
            response.sendRedirect("/admin/orders?error=Cannot create order");
        }
    } catch (Exception e) {
        response.sendRedirect("/admin/orders?error=Invalid data");
    }
}
```

**Process:**
1. Extract all form fields
2. Create `Orders` object and populate fields
3. Call `OrderDAO.createOrder(order)` → returns new order ID
4. If successful, redirect to order detail page
5. If failed, redirect to list page with error

---

## 4. **DATA ACCESS LAYER** - `OrderDAO.java`

### **DAO Function 1: `getAllOrders(status, page, pageSize)`**

```java
public List<Orders> getAllOrders(String status, int page, int pageSize) {
    List<Orders> orders = new ArrayList<>();
    
    // Build SQL query with optional status filter
    String sql = "SELECT * FROM orders";
    if (status != null && !status.isEmpty()) {
        sql += " WHERE order_status = ? OR status = ?";  // Check both new/legacy columns
    }
    sql += " ORDER BY created_at DESC";
    sql += " LIMIT ? OFFSET ?";
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        int paramIdx = 1;
        if (status != null && !status.isEmpty()) {
            ps.setString(paramIdx++, status);
            ps.setString(paramIdx++, status);
        }
        ps.setInt(paramIdx++, pageSize);
        ps.setInt(paramIdx++, (page - 1) * pageSize);  // Offset calculation
        
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                orders.add(extractOrderFromResultSet(rs));
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    
    return orders;
}
```

**SQL Generated:**
```sql
-- Without status filter
SELECT * FROM orders 
ORDER BY created_at DESC 
LIMIT 10 OFFSET 0;

-- With status filter (e.g., status='paid')
SELECT * FROM orders 
WHERE order_status = 'paid' OR status = 'paid'
ORDER BY created_at DESC 
LIMIT 10 OFFSET 10;
```

---

### **DAO Function 2: `getOrderById(orderId)`**

```java
public Orders getOrderById(Long orderId) {
    String sql = "SELECT o.*, " +
        "b.email as buyer_email, b.full_name as buyer_name, " +
        "s.email as seller_email, s.full_name as seller_name, " +
        "p.name as product_name, p.slug as product_slug " +
        "FROM orders o " +
        "LEFT JOIN users b ON o.buyer_id = b.user_id " +
        "LEFT JOIN users s ON o.seller_id = s.user_id " +
        "LEFT JOIN products p ON o.product_id = p.product_id " +
        "WHERE o.order_id = ?";
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setLong(1, orderId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return extractOrderFromResultSet(rs);  // Convert ResultSet to Order object
            }
        }
    } catch (SQLException e) {
        // Fallback for legacy schema without joins
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                "SELECT o.* FROM orders o WHERE o.order_id = ?")) {
            ps.setLong(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return extractOrderFromResultSet(rs);
            }
        }
    }
    return null;
}
```

**Joins Data:**
- `users b` → Buyer information (email, name)
- `users s` → Seller information (email, name)
- `products p` → Product information (name, slug)

---

### **DAO Function 3: `updateOrderStatus(orderId, newStatus)`**

```java
public boolean updateOrderStatus(Long orderId, String orderStatus) {
    String sql = "UPDATE orders SET order_status = ?, processed_at = NOW() WHERE order_id = ?";
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setString(1, orderStatus);
        ps.setLong(2, orderId);
        
        return ps.executeUpdate() > 0;  // Returns true if 1+ row updated
        
    } catch (SQLException e) {
        // Fallback for legacy schema with only 'status' column
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                "UPDATE orders SET status = ? WHERE order_id = ?")) {
            
            String legacyStatus = mapLegacyStatus(orderStatus);
            ps.setString(1, legacyStatus);
            ps.setLong(2, orderId);
            return ps.executeUpdate() > 0;
        }
    }
    return false;
}

// Map new status names to old schema values
private String mapLegacyStatus(String orderStatus) {
    switch (orderStatus.toUpperCase()) {
        case "COMPLETED": return "delivered";
        case "PROCESSING": return "pending";
        case "FAILED": return "cancelled";
        case "CANCELED": return "cancelled";
        case "REFUNDED": return "refunded";
        case "PAID": return "paid";
        default: return orderStatus.toLowerCase();
    }
}
```

**SQL Update:**
```sql
UPDATE orders 
SET order_status = 'paid', processed_at = NOW() 
WHERE order_id = 123;
```

---

### **DAO Function 4: `deleteOrder(orderId)`**

```java
public boolean deleteOrder(Long orderId) {
    String sql = "DELETE FROM orders WHERE order_id = ?";
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setLong(1, orderId);
        return ps.executeUpdate() > 0;  // Returns true if deleted
        
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}
```

**SQL Delete:**
```sql
DELETE FROM orders WHERE order_id = 123;
```

---

### **DAO Function 5: `createOrder(order)`**

```java
public int createOrder(Orders order) {
    String sql = "INSERT INTO orders " +
        "(buyer_id, seller_id, total_amount, currency, " +
        "shipping_address, shipping_method, tracking_number, " +
        "order_status, created_at) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())";
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
        
        ps.setInt(1, order.getBuyer().getUser_id());
        ps.setInt(2, order.getSeller().getUser_id());
        ps.setBigDecimal(3, order.getTotalAmount());
        ps.setString(4, order.getCurrency());
        ps.setString(5, order.getShippingAddress());
        ps.setString(6, order.getShippingMethod());
        ps.setString(7, order.getTrackingNumber());
        ps.setString(8, order.getOrderStatus());
        
        int affected = ps.executeUpdate();
        
        if (affected > 0) {
            // Retrieve the generated auto-increment ID
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);  // Return new order ID
                }
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return -1;  // Return -1 on failure
}
```

**SQL Insert:**
```sql
INSERT INTO orders 
(buyer_id, seller_id, total_amount, currency, shipping_address, 
 shipping_method, tracking_number, order_status, created_at) 
VALUES (5, 3, 150000.00, 'VND', '123 Main St', 'Express', 'TRACK123', 'pending', NOW());
-- Returns: 42 (new order_id)
```

---

### **DAO Helper: `extractOrderFromResultSet(rs)`**

```java
private Orders extractOrderFromResultSet(ResultSet rs) throws SQLException {
    Orders order = new Orders();
    
    // Map columns to object properties
    order.setOrderId(rs.getLong("order_id"));
    order.setBuyerId(rs.getLong("buyer_id"));
    order.setSellerId(rs.getLong("seller_id"));
    order.setTotalAmount(rs.getBigDecimal("total_amount"));
    order.setCurrency(rs.getString("currency"));
    order.setOrderStatus(rs.getString("order_status"));  // Fallback to "status" if null
    order.setPaymentStatus(rs.getString("payment_status"));
    order.setCreatedAt(rs.getTimestamp("created_at"));
    
    // Map joined buyer data (if available)
    try {
        String buyerEmail = rs.getString("buyer_email");
        if (buyerEmail != null) {
            Users buyer = new Users();
            buyer.setUser_id((int) rs.getLong("buyer_id"));
            buyer.setEmail(buyerEmail);
            buyer.setFull_name(rs.getString("buyer_name"));
            order.setBuyer(buyer);
        }
    } catch (SQLException ignore) {}
    
    // Map joined seller data (if available)
    try {
        String sellerName = rs.getString("seller_name");
        if (sellerName != null) {
            Users seller = new Users();
            seller.setUser_id((int) rs.getLong("seller_id"));
            seller.setFull_name(sellerName);
            order.setSeller(seller);
        }
    } catch (SQLException ignore) {}
    
    return order;
}
```

**Purpose:** Convert raw database row into Java object with nested relationships

---

## 5. **VIEW LAYER** - JSP Pages

### **Page 1: `admin-orders.jsp` - Order List**

**Template Flow:**
```html
<table>
  <tr>
    <th>Order ID | Buyer | Seller | Amount | Payment Status | Order Status | Created | Actions</th>
  </tr>
  <% for each order %>
    <tr>
      <td>#${order.order_id}</td>
      <td>${order.buyer.full_name}</td>
      <td>${order.seller.full_name}</td>
      <td>${order.total_amount} ${order.currency}</td>
      <td><span class="status ${order.payment_status}">${order.payment_status}</span></td>
      <td><span class="status ${order.order_status}">${order.order_status}</span></td>
      <td>${order.created_at}</td>
      <td>
        <a href="/admin/orders/view?id=${order.order_id}">View</a>
        <button onclick="updateStatus(${order.order_id})">Update</button>
        <form action="/admin/orders/update-status" method="POST">
          <input name="order_id" value="${order.order_id}" hidden>
          <input name="status" value="COMPLETED" hidden>
          <button>Approve</button>
        </form>
        <form action="/admin/orders/delete" method="POST">
          <input name="id" value="${order.order_id}" hidden>
          <button>Delete</button>
        </form>
      </td>
    </tr>
  <% end %>
</table>

<!-- Pagination -->
<div class="pagination">
  <a href="/admin/orders?page=1">1</a>
  <a href="/admin/orders?page=2" class="current">2</a>
  <a href="/admin/orders?page=3">3</a>
</div>
```

---

### **Page 2: `admin-order-detail.jsp` - Order Detail**

**Displays:**
1. Order header (ID, status, total, dates)
2. Buyer info card
3. Seller info card
4. Shipping info card
5. Order items table (physical products)
6. Digital items table (digital products)
7. Update status modal (popup form)

---

## 6. **Complete Request-Response Cycle**

### **Example: Update Order Status**

```
[USER ACTION]
Admin clicks "Update Status" button on order #42

[FRONTEND]
Modal popup shows current status "pending"
Admin selects new status "paid" from dropdown
Admin clicks "Update" button

[FORM SUBMISSION]
POST /admin/orders/update-status
  order_id: 42
  status: paid

[CONTROLLER - doPost()]
1. Check rbac.isAdmin(request) → ✓ Admin
2. Parse: orderId=42, newStatus="paid"
3. Call: orderDAO.updateOrderStatus(42, "paid")

[DAO - updateOrderStatus()]
1. Execute: UPDATE orders SET order_status='paid' WHERE order_id=42
2. Database updates row
3. Return: true (success)

[CONTROLLER - continued]
4. success = true → fetch order details
5. Send notification to buyer
6. Store in session: flash_success = "Order #42 updated successfully"
7. Redirect: GET /admin/orders

[NEXT PAGE LOAD - doGet()]
1. Request: GET /admin/orders
2. Call: getAllOrders(null, 1, 10)
3. Fetch from DB: All orders with new status
4. Get from session: flash_success message
5. Set request attributes
6. Forward to JSP: admin-orders.jsp

[FRONTEND]
JSP renders:
- Success alert: "Order #42 updated successfully" (green)
- Table with updated order showing status "paid"
```

---

## 7. **Status Transitions**

```
┌─────────────┐
│   PENDING   │  (Order placed, awaiting payment)
└──────┬──────┘
       │ Payment received
       ▼
┌─────────────┐
│    PAID     │  (Payment confirmed)
└──────┬──────┘
       │ Admin ships order
       ▼
┌─────────────┐
│  SHIPPED    │  (In transit)
└──────┬──────┘
       │ Delivered to customer
       ▼
┌─────────────┐
│ DELIVERED   │  (Completed)
└─────────────┘

       ↓ (Can cancel anytime before delivery)
    CANCELED
    
       ↓ (Refund requested)
    REFUNDED
```

---

## 8. **Error Handling**

### **Controller Level:**
```java
try {
    // Parse input
    int orderId = Integer.parseInt(request.getParameter("order_id"));
} catch (NumberFormatException e) {
    // Invalid number format
    request.getSession().setAttribute("flash_error", "Invalid ID format");
    response.sendRedirect("/admin/orders");
    return;
}
```

### **DAO Level:**
```java
try {
    // Execute SQL
    return ps.executeUpdate() > 0;
} catch (SQLException e) {
    // SQL error occurred
    e.printStackTrace();
    return false;  // Fail gracefully
}
```

### **User Feedback:**
- Success messages → Green alert box
- Error messages → Red alert box
- Flash messages → Session-based (persist across redirects)

---

## 9. **Database Schema Used**

```sql
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    order_number VARCHAR(50) UNIQUE,           -- ORDER-20250102-12345
    buyer_id INT,                             -- Foreign key to users
    seller_id INT,                            -- Foreign key to users
    product_id INT,                           -- Foreign key to products
    quantity INT,
    unit_price DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    currency VARCHAR(3),                      -- VND, USD
    payment_method VARCHAR(50),               -- WALLET, GATEWAY
    payment_status VARCHAR(20),               -- PENDING, PAID, FAILED, REFUNDED
    order_status VARCHAR(20),                 -- PENDING, PROCESSING, COMPLETED, CANCELED
    delivery_status VARCHAR(20),              -- INSTANT (digital), STANDARD (physical)
    transaction_id VARCHAR(100),              -- Gateway transaction ID
    queue_status VARCHAR(20),                 -- WAITING, PROCESSING, COMPLETED, FAILED
    shipping_address TEXT,
    shipping_method VARCHAR(50),
    tracking_number VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    processed_at TIMESTAMP
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,                             -- Foreign key to orders
    product_id INT,                           -- Foreign key to products
    quantity INT,
    unit_price DECIMAL(10,2),
    total_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
```

---

## Summary

**Three-Layer Architecture:**
1. **Controller** → Route requests, validate input, handle business logic
2. **DAO** → Execute database operations, handle SQL errors, return data
3. **Model** → Data structure, getters/setters

**Admin Order Management Operations:**
- ✅ **List** orders with pagination and status filtering
- ✅ **View** order details with buyer/seller/items info
- ✅ **Create** new manual orders
- ✅ **Update** order status and notify buyer
- ✅ **Delete** orders from system

**Request Flow:**
User Action → Controller → DAO → Database → DAO → Controller → Session/Redirect → JSP Render

