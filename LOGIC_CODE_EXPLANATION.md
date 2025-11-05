# **GIẢI THÍCH CHI TIẾT LOGIC CODE: DASHBOARD, ĐƠN HÀNG, DANH MỤC, SẢN PHẨM**

---

## **1. BẢNG ĐIỀU KHIỂN (DASHBOARD)**

### **File:** `AdminDashboardController.java`

#### **Chức năng chính:**
Hiển thị tóm tắt toàn hệ thống với các số liệu thống kê chính.

#### **Quy trình code:**

```java
// Bước 1: Kiểm tra quyền truy cập admin
RoleBasedAccessControl rbac = new RoleBasedAccessControl();
if (!rbac.isAdmin(request)) {
    response.sendRedirect(request.getContextPath() + "/home?error=access_denied");
    return;
}
```

**Giải thích:**
- `RoleBasedAccessControl` = Lớp kiểm tra vai trò người dùng
- `rbac.isAdmin(request)` = Kiểm tra xem người dùng có vai trò admin không?
- Nếu **KHÔNG** phải admin → **Chuyển hướng** tới `/home?error=access_denied` (lỗi truy cập bị từ chối)
- Nếu **CÓ** phải admin → Tiếp tục

**Ví dụ:**
- User đăng nhập với vai trò "Khách hàng" → **KHÔNG** phải admin → **Chuyển hướng**
- User đăng nhập với vai trò "Admin" → **CÓ** phải admin → **Tiếp tục**

---

```java
// Bước 2: Tạo các DAO để truy cập cơ sở dữ liệu
dao.UsersDAO usersDAO = new dao.UsersDAO();
dao.ProductDAO productDAO = new dao.ProductDAO();
dao.OrderDAO orderDAO = new dao.OrderDAO();
dao.ProductCategoriesDAO cateDAO = new dao.ProductCategoriesDAO();
```

**Giải thích:**
- **DAO** = Data Access Object (Đối tượng truy cập dữ liệu)
- Tạo 4 DAO để truy cập các bảng khác nhau:
  - `UsersDAO` → Bảng Users (người dùng)
  - `ProductDAO` → Bảng Products (sản phẩm)
  - `OrderDAO` → Bảng Orders (đơn hàng)
  - `ProductCategoriesDAO` → Bảng ProductCategories (danh mục)

---

```java
// Bước 3: Lấy các số liệu từ cơ sở dữ liệu
int totalUsers = usersDAO.getTotalUsers();              // Tổng số người dùng
int totalProducts = productDAO.getTotalProductCount(); // Tổng số sản phẩm
int totalOrders = orderDAO.getTotalOrders();           // Tổng số đơn hàng
int ordersToday = orderDAO.getOrdersToday();           // Đơn hàng hôm nay
java.math.BigDecimal revenueToday = orderDAO.getRevenueTodayAll(); // Doanh thu hôm nay
int totalCategories = cateDAO.getTotalCategories();    // Tổng danh mục
```

**Giải thích chi tiết:**

| Biến | Hàm DAO | Kết quả | Ví dụ |
|------|---------|--------|--------|
| `totalUsers` | `getTotalUsers()` | SELECT COUNT(*) FROM users | 250 |
| `totalProducts` | `getTotalProductCount()` | SELECT COUNT(*) FROM products | 1500 |
| `totalOrders` | `getTotalOrders()` | SELECT COUNT(*) FROM orders | 3200 |
| `ordersToday` | `getOrdersToday()` | SELECT COUNT(*) FROM orders WHERE DATE(created_at) = TODAY() | 45 |
| `revenueToday` | `getRevenueTodayAll()` | SUM(total_amount) FROM orders WHERE DATE(created_at) = TODAY() | 50,000,000 VND |
| `totalCategories` | `getTotalCategories()` | SELECT COUNT(*) FROM product_categories | 25 |

---

```java
// Bước 4: Lấy dữ liệu chi tiết
java.util.List<model.user.Users> recentUsers = usersDAO.getRecentUsers(5);
java.util.List<model.order.Orders> recentOrders = orderDAO.getRecentOrders(5);
java.util.List<model.analytics.TopBuyerStats> topBuyers = orderDAO.getTopBuyersByOrders(5);
```

**Giải thích:**

```
getRecentUsers(5)
→ SELECT * FROM users ORDER BY created_at DESC LIMIT 5
→ Lấy 5 người dùng đăng ký gần đây nhất

getRecentOrders(5)
→ SELECT * FROM orders ORDER BY created_at DESC LIMIT 5
→ Lấy 5 đơn hàng tạo gần đây nhất

getTopBuyersByOrders(5)
→ SELECT user_id, COUNT(*) as order_count, SUM(total_amount) as total_spent
   FROM orders GROUP BY user_id ORDER BY order_count DESC LIMIT 5
→ Lấy 5 khách hàng có số lượng đơn hàng nhiều nhất
```

---

```java
// Bước 5: Gửi dữ liệu đến JSP để hiển thị
request.setAttribute("totalUsers", totalUsers);
request.setAttribute("totalProducts", totalProducts);
request.setAttribute("totalOrders", totalOrders);
request.setAttribute("ordersToday", ordersToday);
request.setAttribute("revenueToday", revenueToday);
request.setAttribute("recentUsers", recentUsers);
request.setAttribute("recentOrders", recentOrders);
request.setAttribute("topBuyers", topBuyers);

request.getRequestDispatcher("/views/admin/admin-dashboard.jsp")
    .forward(request, response);
```

**Giải thích:**
- `request.setAttribute()` = Gửi dữ liệu tới JSP
- `forward()` = Chuyển tiếp request tới trang JSP để hiển thị

**Dữ liệu được gửi:**
```
totalUsers = 250
totalProducts = 1500
totalOrders = 3200
ordersToday = 45
revenueToday = 50,000,000
recentUsers = [User1, User2, User3, User4, User5]
recentOrders = [Order1, Order2, Order3, Order4, Order5]
topBuyers = [Buyer1, Buyer2, Buyer3, Buyer4, Buyer5]
```

#### **Sơ đồ quy trình Dashboard:**

```
┌──────────────────────────────────────┐
│ 1. Admin truy cập /admin/dashboard   │
└────────────┬─────────────────────────┘
             ↓
┌──────────────────────────────────────┐
│ 2. Kiểm tra: Người dùng có phải      │
│    Admin không?                       │
└────────────┬─────────────────────────┘
             ├─ CÓ → Tiếp tục
             └─ KHÔNG → Chuyển hướng /home?error=access_denied
                        ↓
┌──────────────────────────────────────┐
│ 3. Tạo 4 DAO objects:                │
│    - UsersDAO                        │
│    - ProductDAO                      │
│    - OrderDAO                        │
│    - ProductCategoriesDAO            │
└────────────┬─────────────────────────┘
             ↓
┌──────────────────────────────────────┐
│ 4. Lấy dữ liệu tổng cộng từ DB:      │
│    - Tổng người dùng: 250            │
│    - Tổng sản phẩm: 1500             │
│    - Tổng đơn hàng: 3200             │
│    - Đơn hôm nay: 45                 │
│    - Doanh thu hôm nay: 50M VND      │
└────────────┬─────────────────────────┘
             ↓
┌──────────────────────────────────────┐
│ 5. Lấy dữ liệu chi tiết:             │
│    - 5 người dùng mới                │
│    - 5 đơn hàng mới                  │
│    - 5 khách hàng mua nhiều nhất     │
└────────────┬─────────────────────────┘
             ↓
┌──────────────────────────────────────┐
│ 6. Gửi tất cả dữ liệu đến JSP        │
│    admin-dashboard.jsp               │
└────────────┬─────────────────────────┘
             ↓
┌──────────────────────────────────────┐
│ 7. Hiển thị trên trang:              │
│    ✓ Thẻ thống kê (4 thẻ chính)      │
│    ✓ Bảng top 5 người mua            │
│    ✓ Bảng người dùng mới             │
│    ✓ Bảng đơn hàng gần đây           │
└──────────────────────────────────────┘
```

---

## **2. QUẢN LÝ DANH MỤC**

### **File:** `AdminCategoryController.java`

#### **Chức năng:** CRUD danh mục sản phẩm

---

### **A. LIỆT KÊ DANH MỤC (listCategories)**

```java
// Nhận tham số
String keyword = request.getParameter("keyword");   // Từ khóa tìm kiếm
String status = request.getParameter("status");     // Lọc trạng thái
String pageStr = request.getParameter("page");      // Số trang

// Xử lý số trang
int page = 1;
if (pageStr != null && !pageStr.isEmpty()) {
    try {
        page = Integer.parseInt(pageStr);
    } catch (NumberFormatException e) {
        page = 1;  // Mặc định trang 1 nếu lỗi
    }
}
```

**Ví dụ URL:**
```
/admin/categories?keyword=Điện thoại&status=active&page=2
```

**Kết quả:**
- `keyword` = "Điện thoại"
- `status` = "active"
- `page` = 2

---

```java
// Quyết định: Lọc hay hiển thị tất cả?
ProductCategoriesDAO categoryDAO = new ProductCategoriesDAO();
List<ProductCategories> categories;
int totalCategories;

if ((keyword != null && !keyword.trim().isEmpty()) || 
    (status != null && !"all".equals(status))) {
    // CÓ BỘ LỌC: Tìm kiếm
    categories = categoryDAO.searchCategories(keyword, status, page, PAGE_SIZE);
    totalCategories = categoryDAO.countCategories(keyword, status);
} else {
    // KHÔNG CÓ BỘ LỌC: Hiển thị tất cả
    categories = categoryDAO.getAllCategories(page, PAGE_SIZE);
    totalCategories = categoryDAO.getTotalCategories();
}
```

**Giải thích logic:**

| Điều kiện | Hành động | Truy vấn SQL |
|-----------|----------|-------------|
| keyword = "Điện thoại" | **CÓ BỌ LỌC** | SELECT * FROM product_categories WHERE name LIKE '%Điện thoại%' AND status = 'active' LIMIT 10 |
| status = "active" | **CÓ BỘ LỌC** | SELECT * FROM product_categories WHERE status = 'active' LIMIT 10 |
| keyword = "" + status = "all" | **KHÔNG LỌC** | SELECT * FROM product_categories LIMIT 10 |
| keyword = null + status = null | **KHÔNG LỌC** | SELECT * FROM product_categories LIMIT 10 |

---

```java
// Tính tổng số trang
int PAGE_SIZE = 10;
int totalPages = (int) Math.ceil((double) totalCategories / PAGE_SIZE);

// Ví dụ:
// totalCategories = 25
// totalPages = ceil(25 / 10) = ceil(2.5) = 3 (3 trang)
```

---

```java
// Gửi dữ liệu đến JSP
request.setAttribute("categories", categories);
request.setAttribute("currentPage", page);
request.setAttribute("totalPages", totalPages);
request.setAttribute("totalCategories", totalCategories);
request.setAttribute("keyword", keyword);
request.setAttribute("status", status);

request.getRequestDispatcher("/views/admin/categories-list.jsp")
    .forward(request, response);
```

---

### **B. TẠO DANH MỤC (createCategory)**

```java
// Lấy dữ liệu từ form
String name = request.getParameter("name");             // Tên danh mục
String slug = request.getParameter("slug");             // URL slug
String description = request.getParameter("description"); // Mô tả
String status = request.getParameter("status");         // Trạng thái

// Kiểm tra tên đã tồn tại chưa
ProductCategoriesDAO categoryDAO = new ProductCategoriesDAO();
if (categoryDAO.isCategoryNameExists(name, null)) {
    // name = "Điện thoại" và đã tồn tại trong DB
    request.setAttribute("error", "Tên danh mục đã tồn tại");
    showCreateForm(request, response);
    return;
}
```

**Giải thích:**
- `isCategoryNameExists(name, null)` 
  - Kiểm tra: Có danh mục nào có tên = "Điện thoại" không?
  - Tham số `null` = Không loại trừ ID nào (vì tạo mới, không chỉnh sửa)
  - **Nếu CÓ:** Hiển thị lỗi → **Dừng**
  - **Nếu KHÔNG:** Tiếp tục tạo

---

```java
// Tạo object danh mục mới
ProductCategories category = new ProductCategories();
category.setName(name);              // Đặt tên
category.setSlug(slug);              // Đặt slug
category.setDescription(description); // Đặt mô tả
category.setStatus(status);          // Đặt trạng thái

// Lưu vào database
boolean success = categoryDAO.createCategory(category);

if (success) {
    // Tạo thành công
    request.getSession().setAttribute("success", "Tạo danh mục thành công");
    response.sendRedirect(request.getContextPath() + "/admin/categories");
    // Chuyển hướng tới danh sách danh mục, hiển thị thông báo thành công
} else {
    // Tạo thất bại
    request.setAttribute("error", "Tạo danh mục thất bại");
    showCreateForm(request, response);
    // Hiển thị lại form với lỗi
}
```

---

### **C. CẬP NHẬT DANH MỤC (updateCategory)**

```java
// Lấy ID danh mục từ form
String categoryIdStr = request.getParameter("categoryId");
long categoryId = Long.parseLong(categoryIdStr);  // Ví dụ: 5

// Lấy danh mục hiện tại từ DB
ProductCategoriesDAO categoryDAO = new ProductCategoriesDAO();
ProductCategories category = categoryDAO.getCategoryById(categoryId);

if (category == null) {
    // Danh mục không tồn tại → Chuyển hướng
    response.sendRedirect(request.getContextPath() + "/admin/categories");
    return;
}
```

---

```java
// Kiểm tra tên mới có xung đột không
String name = request.getParameter("name");
if (categoryDAO.isCategoryNameExists(name, categoryId)) {
    // isCategoryNameExists(name, categoryId)
    // Kiểm tra: Có danh mục khác (không phải categoryId) có tên "name" không?
    
    request.setAttribute("error", "Tên danh mục đã tồn tại");
    request.setAttribute("category", category);
    request.setAttribute("isEdit", true);
    request.getRequestDispatcher("/views/admin/category-form.jsp")
        .forward(request, response);
    return;
}
```

**Ví dụ:**
- ID = 5 (Danh mục "Điện thoại")
- Người dùng muốn đổi tên thành "Laptop"
- Kiểm tra: Có danh mục nào khác ID 5 có tên "Laptop" không?
  - **Nếu CÓ:** Hiển thị lỗi
  - **Nếu KHÔNG:** Tiếp tục

---

```java
// Cập nhật các thuộc tính
category.setName(name);
category.setSlug(request.getParameter("slug"));
category.setDescription(request.getParameter("description"));
category.setStatus(request.getParameter("status"));

// Lưu vào DB
boolean success = categoryDAO.updateCategory(category);

if (success) {
    request.getSession().setAttribute("success", "Cập nhật danh mục thành công");
    response.sendRedirect(request.getContextPath() + "/admin/categories");
} else {
    request.setAttribute("error", "Cập nhật danh mục thất bại");
    request.setAttribute("category", category);
    request.setAttribute("isEdit", true);
    request.getRequestDispatcher("/views/admin/category-form.jsp")
        .forward(request, response);
}
```

---

### **D. XÓA DANH MỤC (deleteCategory)**

```java
// Lấy ID danh mục
String categoryIdStr = request.getParameter("id");
long categoryId = Long.parseLong(categoryIdStr);

// Xóa từ DB
ProductCategoriesDAO categoryDAO = new ProductCategoriesDAO();
boolean success = categoryDAO.deleteCategory(categoryId);

if (success) {
    request.getSession().setAttribute("success", "Xóa danh mục thành công");
} else {
    request.getSession().setAttribute("error", "Xóa danh mục thất bại");
}

// Chuyển hướng lại danh sách
response.sendRedirect(request.getContextPath() + "/admin/categories");
```

#### **Sơ đồ quy trình Danh mục:**

```
┌──────────────────────────────────────────┐
│ Admin truy cập: /admin/categories        │
│ ?keyword=Điện&status=active&page=2       │
└────────────┬─────────────────────────────┘
             ↓
┌──────────────────────────────────────────┐
│ LIỆT KÊ DANH MỤC:                        │
│ 1. Lấy tham số: keyword, status, page    │
│ 2. Kiểm tra có bộ lọc không?             │
│ 3. Nếu có → searchCategories()           │
│    Nếu không → getAllCategories()        │
│ 4. Tính tổng trang                       │
│ 5. Gửi dữ liệu đến JSP                   │
└────────────┬─────────────────────────────┘
             ↓
┌──────────────────────────────────────────┐
│ HIỂN THỊ:                                │
│ - Bảng danh mục                          │
│ - Phân trang                             │
│ - Các nút: Sửa, Xóa                      │
└────────────┬─────────────────────────────┘
             ↓
    ┌─────────┴─────────┐
    ↓                   ↓
┌──────────────┐   ┌──────────────┐
│ NHẤN "THÊM"  │   │ NHẤN "SỬA"    │
└──────┬───────┘   └──────┬───────┘
       ↓                   ↓
   FORM TẠO           FORM SỬA
   (trống)           (có dữ liệu)
```

---

## **3. QUẢN LÝ ĐƠN HÀNG**

### **File:** `AdminOrdersController.java`

#### **Chức năng:** Quản lý đơn hàng, cập nhật trạng thái, xóa

---

### **A. LIỆT KÊ ĐƠN HÀNG**

```java
// Kiểm tra quyền admin
if (!rbac.isAdmin(request)) {
    response.sendRedirect(request.getContextPath() + "/home?error=access_denied");
    return;
}

// Lấy tham số
String status = request.getParameter("status");   // Lọc trạng thái
int page = 1;
int pageSize = 10;  // Mỗi trang 10 đơn

// Xử lý số trang
try {
    String pageStr = request.getParameter("page");
    if (pageStr != null && !pageStr.trim().isEmpty()) {
        page = Integer.parseInt(pageStr);
    }
} catch (NumberFormatException ignored) {
    page = 1;  // Lỗi → mặc định trang 1
}
```

---

```java
// Quyết định: Lọc hay hiển thị tất cả?
List<Orders> orders;
int totalOrders;

boolean showAll = (status == null || status.trim().isEmpty() || "all".equalsIgnoreCase(status));

if (showAll) {
    // Hiển thị TẤT CẢ đơn hàng
    orders = orderDAO.getAllOrders(null, page, pageSize);
    totalOrders = orderDAO.getOrderCount(null);
    // SQL: SELECT * FROM orders LIMIT 10 OFFSET 0
} else {
    // Lọc theo trạng thái
    orders = orderDAO.getAllOrders(status, page, pageSize);
    totalOrders = orderDAO.getOrderCount(status);
    // SQL: SELECT * FROM orders WHERE order_status = 'paid' LIMIT 10
}

int totalPages = (int) Math.ceil((double) totalOrders / pageSize);
```

**Ví dụ:**

| URL | status | Hành động | SQL |
|-----|--------|----------|-----|
| `/admin/orders` | null | Hiển thị tất cả | SELECT * FROM orders |
| `/admin/orders?status=all` | "all" | Hiển thị tất cả | SELECT * FROM orders |
| `/admin/orders?status=paid` | "paid" | Lọc trạng thái paid | SELECT * FROM orders WHERE order_status = 'paid' |
| `/admin/orders?status=pending` | "pending" | Lọc trạng thái pending | SELECT * FROM orders WHERE order_status = 'pending' |

---

```java
// Xử lý flash messages (thông báo từ POST trước đó)
HttpSession sess = request.getSession(false);
if (sess != null) {
    Object fs = sess.getAttribute("flash_success");
    Object fe = sess.getAttribute("flash_error");
    
    if (fs != null) { 
        request.setAttribute("success", fs);      // Lấy thông báo thành công
        sess.removeAttribute("flash_success");    // Xóa khỏi session
    }
    if (fe != null) { 
        request.setAttribute("error", fe);        // Lấy thông báo lỗi
        sess.removeAttribute("flash_error");      // Xóa khỏi session
    }
}
```

**Ví dụ:**
- Admin cập nhật trạng thái đơn hàng → Lưu "flash_success" = "Cập nhật thành công"
- Chuyển hướng tới trang danh sách
- Trang danh sách lấy "flash_success" → Hiển thị thông báo xanh
- Xóa khỏi session để không hiển thị lại

---

```java
// Gửi dữ liệu đến JSP
request.setAttribute("orders", orders);
request.setAttribute("currentPage", page);
request.setAttribute("totalPages", totalPages);
request.setAttribute("totalOrders", totalOrders);
request.setAttribute("status", status);

request.getRequestDispatcher("/views/admin/admin-orders.jsp")
    .forward(request, response);
```

---

### **B. XEM CHI TIẾT ĐƠN HÀNG**

```java
// URL: /admin/orders/view?id=123

try {
    // Lấy ID đơn hàng
    int orderId = Integer.parseInt(request.getParameter("id"));
    
    // Lấy thông tin đơn hàng
    Orders order = orderDAO.getOrderById(orderId);
    
    if (order == null) {
        // Đơn không tồn tại
        response.sendRedirect(request.getContextPath() + 
            "/admin/orders?error=Đơn hàng không tồn tại");
        return;
    }
    
    // Lấy danh sách sản phẩm trong đơn
    List<OrderItems> items = orderDAO.getOrderItems(orderId);
    
    // Lấy sản phẩm kỹ thuật số (nếu có)
    List<DigitalProduct> digitalItems = 
        digitalProductDAO.getDigitalProductsByOrderId((long) orderId);
    
    // Gửi dữ liệu đến chi tiết trang
    request.setAttribute("order", order);
    request.setAttribute("orderItems", items);
    request.setAttribute("digitalItems", digitalItems);
    
    request.getRequestDispatcher("/views/admin/admin-order-detail.jsp")
        .forward(request, response);
        
} catch (Exception e) {
    response.sendRedirect(request.getContextPath() + 
        "/admin/orders?error=ID đơn hàng không hợp lệ");
}
```

**Ví dụ dữ liệu:**
```
order = {
  orderId: 123
  buyerId: 5 (Nguyễn Văn A)
  sellerId: 10 (Shop X)
  totalAmount: 500,000
  status: "paid"
  createdAt: "2025-01-05 10:30:00"
}

items = [
  {productId: 1, productName: "iPhone 15", quantity: 1, price: 400,000},
  {productId: 2, productName: "Ốp lưng", quantity: 2, price: 50,000}
]

digitalItems = [
  {productId: 100, productName: "Khóa học lập trình", code: "ABC123XYZ"}
]
```

---

### **C. CẬP NHẬT TRẠNG THÁI ĐƠN HÀNG**

```java
// URL: /admin/orders/update-status (POST)

try {
    int orderId = Integer.parseInt(request.getParameter("order_id"));
    String newStatus = request.getParameter("status");
    
    // Ví dụ: orderId = 123, newStatus = "paid"
    
    // Cập nhật trong DB
    boolean ok = orderDAO.updateOrderStatus(orderId, newStatus);
    
    if (ok) {
        // Cập nhật thành công
        
        // 1. Lấy thông tin đơn hàng
        Orders order = orderDAO.getOrderById(orderId);
        
        // 2. Gửi thông báo cho người mua
        if (order != null && order.getBuyerId() != null) {
            String title = "Đơn hàng đã được duyệt";
            String msg = String.format(
                "Đơn #%d đã được duyệt. Trạng thái: %s.",
                orderId, newStatus
            );
            new service.NotificationService()
                .sendNotificationToUser(
                    order.getBuyerId().intValue(),
                    title, msg, "order"
                );
        }
        
        // 3. Lưu thông báo vào session
        request.getSession().setAttribute(
            "flash_success",
            "Duyệt/Cập nhật đơn #" + orderId + " thành công"
        );
        
        // 4. Chuyển hướng lại danh sách
        response.sendRedirect(request.getContextPath() + "/admin/orders");
        
    } else {
        // Cập nhật thất bại
        request.getSession().setAttribute(
            "flash_error",
            "Có lỗi khi cập nhật trạng thái"
        );
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
    
} catch (Exception e) {
    request.getSession().setAttribute(
        "flash_error",
        "Dữ liệu không hợp lệ"
    );
    response.sendRedirect(request.getContextPath() + "/admin/orders");
}
```

**Quy trình chi tiết:**

```
1. Admin nhấn nút "Cập nhật" với status = "paid"
2. Gửi POST: /admin/orders/update-status?order_id=123&status=paid
3. Java:
   - Lấy orderId = 123
   - Lấy newStatus = "paid"
   - Cập nhật DB: UPDATE orders SET order_status = 'paid' WHERE order_id = 123
   - Nếu thành công:
     * Lấy thông tin người mua
     * Gửi notification: "Đơn #123 đã được duyệt. Trạng thái: paid"
     * Lưu success message
     * Chuyển hướng tới /admin/orders
   - JSP hiển thị: "Duyệt/Cập nhật đơn #123 thành công" (thông báo xanh)
```

---

### **D. XÓA ĐƠN HÀNG**

```java
// URL: /admin/orders/delete (POST)

try {
    int orderId = Integer.parseInt(request.getParameter("id"));
    
    // Xóa đơn hàng
    boolean success = orderDAO.deleteOrder(orderId);
    
    if (success) {
        response.sendRedirect(
            request.getContextPath() + "/admin/orders?success=Đã xóa đơn hàng"
        );
    } else {
        response.sendRedirect(
            request.getContextPath() + 
            "/admin/orders?error=Không thể xóa đơn hàng"
        );
    }
} catch (Exception e) {
    response.sendRedirect(
        request.getContextPath() + "/admin/orders?error=Dữ liệu không hợp lệ"
    );
}
```

---

## **4. QUẢN LÝ SẢN PHẨM**

### **File:** `AdminProductsController.java`

#### **Chức năng:** CRUD sản phẩm, upload ảnh

---

### **A. LIỆT KÊ SẢN PHẨM**

```java
// URL: /admin/products?keyword=iPhone&category_id=1&status=active&page=2

String path = request.getServletPath();
if ("/admin/products".equals(path)) {
    // Lấy tham số lọc
    String keyword = request.getParameter("keyword");           // Từ khóa
    String status = request.getParameter("status");             // Trạng thái
    String category = request.getParameter("category_id");      // Danh mục
    
    int page = 1;
    int pageSize = 12;  // Mỗi trang 12 sản phẩm
    
    try {
        String p = request.getParameter("page");
        if (p != null) page = Integer.parseInt(p);
    } catch (Exception ignore) {
        page = 1;
    }
    
    // Lấy sản phẩm từ DB với các bộ lọc
    List<Products> list = productDAO.adminFilterProducts(
        page, pageSize, keyword, category, status
    );
    // SQL: SELECT * FROM products 
    //      WHERE name LIKE '%iPhone%' 
    //      AND category_id = 1 
    //      AND status = 'active'
    //      LIMIT 12 OFFSET (page-1)*12
    
    // Đếm tổng sản phẩm
    int total = productDAO.adminCountFilteredProducts(keyword, category, status);
    
    // Tính tổng trang
    int totalPages = (int) Math.ceil((double) total / pageSize);
    
    // Lấy danh mục để hiển thị dropdown lọc
    ProductCategoriesDAO cateDAO = new ProductCategoriesDAO();
    List<ProductCategories> categories = cateDAO.getAllCategories();
    
    // Gửi dữ liệu đến JSP
    request.setAttribute("products", list);
    request.setAttribute("categories", categories);
    request.setAttribute("currentPage", page);
    request.setAttribute("totalPages", totalPages);
    request.setAttribute("totalProducts", total);
    request.setAttribute("keyword", keyword);
    request.setAttribute("status", status);
    request.setAttribute("categoryId", category);
    
    request.getRequestDispatcher("/views/admin/admin-products.jsp")
        .forward(request, response);
}
```

**Ví dụ bảng dữ liệu:**

| ID | Tên | Giá | Số lượng | Danh mục | Trạng thái |
|----|-----|-----|---------|----------|-----------|
| 1 | iPhone 15 | 400,000 | 50 | Điện thoại | active |
| 2 | Samsung S24 | 450,000 | 30 | Điện thoại | active |
| 3 | Ốp lưng | 50,000 | 200 | Phụ kiện | inactive |

---

### **B. TẠO SẢN PHẨM**

```java
// GET: /admin/products/create (Hiển thị form)
if ("/admin/products/create".equals(path)) {
    ProductCategoriesDAO cateDAO = new ProductCategoriesDAO();
    List<ProductCategories> categories = cateDAO.getAllCategories();
    
    request.setAttribute("categories", categories);
    request.getRequestDispatcher("/views/admin/admin-product-create.jsp")
        .forward(request, response);
    return;
}

// POST: /admin/products/create (Xử lý form)
if ("/admin/products/create".equals(path)) {
    try {
        // 1. Lấy dữ liệu từ form
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        BigDecimal price = new BigDecimal(request.getParameter("price"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        int categoryId = Integer.parseInt(request.getParameter("category_id"));
        String status = request.getParameter("status");
        Part imagePart = request.getPart("image");
        
        // 2. Lấy người bán (Admin hiện tại)
        Users current = (Users) request.getSession().getAttribute("user");
        if (current == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // 3. Tạo object sản phẩm
        Products p = new Products();
        p.setSeller_id(current);
        p.setName(name);
        p.setDescription(description);
        p.setPrice(price);
        p.setQuantity(quantity);
        p.setStatus(status);
        
        ProductCategories cate = new ProductCategories();
        cate.setCategory_id(categoryId);
        p.setCategory_id(cate);
        
        // 4. Lưu vào DB (trả về ID mới)
        long newId = productDAO.insertProductReturningId(p);
        // INSERT INTO products (...) VALUES (...) RETURNING id
        
        if (newId <= 0) {
            request.setAttribute("error", "Tạo sản phẩm thất bại");
            ProductCategoriesDAO cateDAO = new ProductCategoriesDAO();
            request.setAttribute("categories", cateDAO.getAllCategories());
            request.getRequestDispatcher("/views/admin/admin-product-create.jsp")
                .forward(request, response);
            return;
        }
        
        // 5. Xử lý upload ảnh
        if (imagePart != null && imagePart.getSize() > 0) {
            String fileName = imagePart.getSubmittedFileName();
            String lower = fileName.toLowerCase();
            
            // 5a. Kiểm tra định dạng ảnh
            if (!(lower.endsWith(".jpg") || lower.endsWith(".jpeg") || 
                  lower.endsWith(".png") || lower.endsWith(".webp"))) {
                request.setAttribute("error", "Định dạng ảnh không hợp lệ");
                ProductCategoriesDAO cateDAO = new ProductCategoriesDAO();
                request.setAttribute("categories", cateDAO.getAllCategories());
                request.getRequestDispatcher("/views/admin/admin-product-create.jsp")
                    .forward(request, response);
                return;
            }
            
            // 5b. Tạo đường dẫn lưu file
            String uploadPath = request.getServletContext().getRealPath("") + 
                               File.separator + "uploads" + 
                               File.separator + "products";
            new File(uploadPath).mkdirs();
            
            // 5c. Tạo tên file duy nhất
            String newFileName = System.currentTimeMillis() + "_" + fileName;
            // Ví dụ: 1704470400000_iphone15.jpg
            
            // 5d. Lưu file
            imagePart.write(uploadPath + File.separator + newFileName);
            
            // 5e. Tạo URL ảnh
            String imageUrl = request.getContextPath() + 
                            "/uploads/products/" + newFileName;
            // Ví dụ: /myapp/uploads/products/1704470400000_iphone15.jpg
            
            // 5f. Lưu thông tin ảnh vào DB
            new ProductImageDAO().updatePrimaryImage(
                newId,
                imageUrl,
                "Ảnh sản phẩm " + name
            );
        }
        
        // 6. Chuyển hướng về danh sách
        response.sendRedirect(request.getContextPath() + 
            "/admin/products?success=create");
        return;
        
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect(request.getContextPath() + 
            "/admin/products?error=1");
        return;
    }
}
```

**Quy trình chi tiết:**

```
1. Admin lấy form: GET /admin/products/create
   → Hiển thị form trống
   
2. Admin điền thông tin:
   - Tên: "iPhone 15"
   - Giá: "400000"
   - Số lượng: "50"
   - Danh mục: "1" (Điện thoại)
   - Trạng thái: "active"
   - Ảnh: iphone15.jpg
   
3. Admin submit form: POST /admin/products/create
   
4. Java xử lý:
   a) Lấy dữ liệu
   b) Tạo object Products
   c) INSERT vào DB
      → Trả về ID = 100
   d) Kiểm tra ảnh:
      - Có ảnh? → Có
      - Định dạng hợp lệ? → jpg → Hợp lệ
   e) Lưu ảnh:
      - Tạo thư mục: uploads/products/
      - Đổi tên: 1704470400000_iphone15.jpg
      - Lưu vào disk
      - Lưu URL vào DB
   f) Chuyển hướng: /admin/products?success=create
   
5. JSP hiển thị: "Tạo sản phẩm thành công" (thông báo xanh)
```

---

### **C. CẬP NHẬT SẢN PHẨM**

```java
// GET: /admin/products/edit?id=100 (Hiển thị form chỉnh sửa)
if ("/admin/products/edit".equals(path)) {
    long id = Long.parseLong(request.getParameter("id"));
    
    // Lấy sản phẩm từ DB
    Products product = productDAO.getProductById(id);
    
    if (product == null) {
        response.sendRedirect(request.getContextPath() + "/admin/products");
        return;
    }
    
    // Lấy danh mục
    ProductCategoriesDAO cateDAO = new ProductCategoriesDAO();
    List<ProductCategories> categories = cateDAO.getAllCategories();
    
    // Gửi dữ liệu đến form
    request.setAttribute("product", product);
    request.setAttribute("categories", categories);
    
    request.getRequestDispatcher("/views/admin/admin-product-edit.jsp")
        .forward(request, response);
}

// POST: /admin/products/update (Xử lý cập nhật)
if ("/admin/products/update".equals(path)) {
    try {
        // 1. Lấy ID sản phẩm
        long productId = Long.parseLong(request.getParameter("product_id"));
        
        // 2. Lấy sản phẩm hiện tại
        Products existing = productDAO.getProductById(productId);
        if (existing == null) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }
        
        // 3. Lấy dữ liệu mới từ form
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        BigDecimal price = new BigDecimal(request.getParameter("price"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        int categoryId = Integer.parseInt(request.getParameter("category_id"));
        String status = request.getParameter("status");
        
        // 4. Cập nhật object
        existing.setName(name);
        existing.setDescription(description);
        existing.setPrice(price);
        existing.setQuantity(quantity);
        existing.setStatus(status);
        existing.setUpdated_at(new Timestamp(System.currentTimeMillis()));
        
        ProductCategories cate = new ProductCategories();
        cate.setCategory_id(categoryId);
        existing.setCategory_id(cate);
        
        // 5. Cập nhật kho hàng (nếu không phải sản phẩm kỹ thuật số)
        try {
            DigitalProductDAO ddao = new DigitalProductDAO();
            int digitalCount = ddao.getAvailableStock(productId);
            
            if (digitalCount <= 0) {
                // Là sản phẩm vật lý → Cập nhật kho
                new InventoryDAO().upsertQuantity(productId, quantity);
            }
        } catch (Exception ignore) {}
        
        // 6. Xử lý upload ảnh mới (nếu có)
        Part imagePart = request.getPart("image");
        if (imagePart != null && imagePart.getSize() > 0) {
            // Kiểm tra định dạng
            String lower = imagePart.getSubmittedFileName().toLowerCase();
            if (!(lower.endsWith(".jpg") || lower.endsWith(".jpeg") || 
                  lower.endsWith(".png") || lower.endsWith(".webp"))) {
                request.setAttribute("error", "Định dạng ảnh không hợp lệ");
                request.setAttribute("product", existing);
                request.getRequestDispatcher("/views/admin/admin-product-edit.jsp")
                    .forward(request, response);
                return;
            }
            
            // Lưu ảnh (giống như tạo)
            String uploadPath = request.getServletContext().getRealPath("") + 
                               File.separator + "uploads" + 
                               File.separator + "products";
            new File(uploadPath).mkdirs();
            
            String fileName = System.currentTimeMillis() + "_" + 
                            imagePart.getSubmittedFileName();
            imagePart.write(uploadPath + File.separator + fileName);
            
            String imageUrl = request.getContextPath() + 
                            "/uploads/products/" + fileName;
            new ProductImageDAO().updatePrimaryImage(productId, imageUrl, 
                "Ảnh sản phẩm " + name);
        }
        
        // 7. Lưu vào DB
        boolean ok = productDAO.updateProduct(existing);
        
        // 8. Chuyển hướng
        response.sendRedirect(request.getContextPath() + 
            "/admin/products" + (ok ? "?success=update" : "?error=1"));
        return;
        
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect(request.getContextPath() + "/admin/products?error=1");
        return;
    }
}
```

---

### **D. XÓA SẢN PHẨM**

```java
// POST: /admin/products/delete

try {
    long id = Long.parseLong(request.getParameter("id"));
    
    // Xóa mềm (soft delete - chỉ đánh dấu là xóa)
    boolean ok = productDAO.softDeleteProduct(id);
    // UPDATE products SET deleted_at = NOW() WHERE product_id = id
    
    response.sendRedirect(request.getContextPath() + 
        "/admin/products" + (ok ? "?success=delete" : "?error=1"));
    
} catch (Exception e) {
    response.sendRedirect(request.getContextPath() + "/admin/products?error=1");
}
```

---

### **E. THAY ĐỔI TRẠNG THÁI SẢN PHẨM**

```java
// POST: /admin/products/change-status

long id = Long.parseLong(request.getParameter("id"));
String newStatus = request.getParameter("status");

// Lấy sản phẩm
Products p = productDAO.getProductById(id);

if (p != null) {
    // Cập nhật trạng thái
    p.setStatus(newStatus);
    p.setUpdated_at(new Timestamp(System.currentTimeMillis()));
    
    // Lưu vào DB
    productDAO.updateProduct(p);
}

// Chuyển hướng
response.sendRedirect(request.getContextPath() + 
    "/admin/products?success=status");
```

#### **Sơ đồ quy trình Sản phẩm:**

```
┌──────────────────────────────────────────┐
│ Admin truy cập: /admin/products          │
│ ?keyword=iPhone&category_id=1&page=1    │
└────────────┬─────────────────────────────┘
             ↓
┌──────────────────────────────────────────┐
│ LIỆT KÊ SẢN PHẨM:                        │
│ 1. Lấy tham số lọc                       │
│ 2. adminFilterProducts() từ DB           │
│ 3. Tính tổng trang                       │
│ 4. Gửi dữ liệu đến JSP                   │
└────────────┬─────────────────────────────┘
             ↓
    ┌────────┴─────────┬──────────┬─────────┐
    ↓                  ↓          ↓         ↓
 THÊM MỚI         CHỈNH SỬA   XÓA    THAY ĐỔI
                                      TRẠNG THÁI
    ↓                  ↓          ↓         ↓
  FORM (1)        FORM (2)    DELETE   UPDATE
  (trống)       (có dữ liệu)  SOFT     STATUS
    ↓                  ↓          ↓         ↓
 UPLOAD          UPLOAD       MARK      UPDATE
 ẢNH              ẢNH MỚI    AS DEL     DB
    ↓                  ↓          ↓         ↓
 INSERT          UPDATE       REDIRECT  REDIRECT
 DB              DB
    ↓                  ↓
 REDIRECT        REDIRECT
```

---

## **TÓM LƯỢC**

| Module | Điểm chính | Điểm khó hiểu |
|--------|-----------|--------------|
| **Dashboard** | Lấy tất cả metrics từ DB | Tính toán TopBuyers |
| **Danh mục** | CRUD đơn giản | Kiểm tra trùng tên |
| **Đơn hàng** | Flash messages, Notifications | Xử lý POST-Redirect |
| **Sản phẩm** | Upload ảnh, Soft delete | File handling, MultipartConfig |

---

Bạn hiểu rõ chưa? Cần giải thích thêm phần nào không? 😊
