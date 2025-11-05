# **HƯỚNG DẪN: XỬ LÝ URL KHÔNG HỢP LỆ - TỰ ĐỘNG QUAY LẠI TRANG QUẢN LÝ**

## **📝 Vấn đề được giải quyết**

Khi người dùng nhập URL không hợp lệ (ví dụ: `page=-1`, `page=999`), hệ thống sẽ tự động chuyển hướng về trang quản lý mặc định.

---

## **✅ Các thay đổi đã thực hiện**

### **1. AdminCategoryController.java**

**Vị trí:** `/src/java/controller/admin/AdminCategoryController.java` - Phương thức `listCategories()`

**Thêm 2 kiểm tra:**

```java
private void listCategories(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    // ... (lấy tham số, xử lý page như cũ)
    
    // ✅ KIỂM TRA 1: Page < 1
    if (page < 1) {
        response.sendRedirect(request.getContextPath() + "/admin/categories");
        return;  // Dừng xử lý, quay lại trang quản lý
    }
    
    // ... (lấy dữ liệu từ DB như cũ)
    
    int totalPages = (int) Math.ceil((double) totalCategories / PAGE_SIZE);
    
    // ✅ KIỂM TRA 2: Page > totalPages
    if (totalPages > 0 && page > totalPages) {
        response.sendRedirect(request.getContextPath() + "/admin/categories");
        return;  // Dừng xử lý, quay lại trang quản lý
    }
    
    // ... (gửi dữ liệu tới JSP như cũ)
}
```

---

### **2. AdminProductsController.java**

**Vị trị:** `/src/java/controller/admin/AdminProductsController.java` - Phương thức `doGet()`

```java
if ("/admin/products".equals(path)) {
    // ... (lấy tham số)
    
    // ✅ KIỂM TRA 1: Page < 1
    if (page < 1) {
        response.sendRedirect(request.getContextPath() + "/admin/products");
        return;
    }
    
    // ... (lấy dữ liệu từ DB)
    
    int totalPages = (int)Math.ceil((double)total / pageSize);
    
    // ✅ KIỂM TRA 2: Page > totalPages
    if (totalPages > 0 && page > totalPages) {
        response.sendRedirect(request.getContextPath() + "/admin/products");
        return;
    }
    
    // ... (gửi dữ liệu tới JSP)
}
```

---

### **3. AdminOrdersController.java**

**Vị trị:** `/src/java/controller/admin/AdminOrdersController.java` - Phương thức `doGet()`

```java
if ("/admin/orders".equals(path)) {
    // ... (lấy tham số)
    
    // ✅ KIỂM TRA 1: Page < 1
    if (page < 1) {
        response.sendRedirect(request.getContextPath() + "/admin/orders");
        return;
    }
    
    // ... (lấy dữ liệu từ DB)
    
    int totalPages = (int) Math.ceil((double) totalOrders / pageSize);
    
    // ✅ KIỂM TRA 2: Page > totalPages
    if (totalPages > 0 && page > totalPages) {
        response.sendRedirect(request.getContextPath() + "/admin/orders");
        return;
    }
    
    // ... (xử lý dữ liệu, gửi tới JSP)
}
```

---

### **4. AdminUserController.java**

**Vị trị:** `/src/java/controller/admin/AdminUserController.java` - Phương thức `listUsers()`

✅ **Đã có sẵn**:
- Kiểm tra `page < 1` (dòng 93-96)
- Kiểm tra `page > totalPages` (dòng 116-119)

---

## **🎯 Cách hoạt động**

### **Kịch bản 1: Page < 1**

```
User nhập URL: /admin/categories?page=-1

→ Java xử lý:
  1. Lấy page = -1
  2. Kiểm tra: page < 1 ? → YES
  3. Gọi: response.sendRedirect("/admin/categories")
  4. Dừng xử lý (return)

→ Kết quả: 
  Tự động chuyển hướng tới /admin/categories (trang 1 mặc định)
  URL thay đổi: localhost:8082/WEBGMS/admin/categories
```

---

### **Kịch bản 2: Page > totalPages**

```
Database có 25 danh mục
→ totalPages = ceil(25 / 10) = 3 trang

User nhập URL: /admin/categories?page=999

→ Java xử lý:
  1. Lấy page = 999
  2. Kiểm tra: page < 1 ? → NO (vượt qua kiểm tra 1)
  3. Lấy dữ liệu từ DB
  4. Tính: totalPages = 3
  5. Kiểm tra: page > totalPages ? (999 > 3) → YES
  6. Gọi: response.sendRedirect("/admin/categories")
  7. Dừng xử lý (return)

→ Kết quả:
  Tự động chuyển hướng tới /admin/categories (trang 1)
  URL thay đổi: localhost:8082/WEBGMS/admin/categories
```

---

### **Kịch bản 3: Page hợp lệ**

```
Database có 25 danh mục → totalPages = 3

User nhập URL: /admin/categories?page=2

→ Java xử lý:
  1. Lấy page = 2
  2. Kiểm tra: page < 1 ? → NO
  3. Lấy dữ liệu từ DB, trang 2
  4. Tính: totalPages = 3
  5. Kiểm tra: page > totalPages ? (2 > 3) → NO
  6. Gửi dữ liệu tới JSP
  7. Hiển thị trang 2

→ Kết quả:
  ✓ Trang 2 được hiển thị bình thường
```

---

## **📋 URL Test Cases**

### **Test cho Danh mục:**

| URL | Kết quả | Giải thích |
|-----|---------|-----------|
| `/admin/categories` | ✓ Trang 1 | Mặc định |
| `/admin/categories?page=1` | ✓ Trang 1 | Hợp lệ |
| `/admin/categories?page=2` | ✓ Trang 2 | Hợp lệ |
| `/admin/categories?page=0` | 🔄 Redirect | page < 1 |
| `/admin/categories?page=-1` | 🔄 Redirect | page < 1 |
| `/admin/categories?page=999` | 🔄 Redirect | page > totalPages |
| `/admin/categories?page=abc` | ✓ Trang 1 | NumberFormatException → page = 1 |

---

### **Test cho Sản phẩm:**

| URL | Kết quả | Giải thích |
|-----|---------|-----------|
| `/admin/products` | ✓ Trang 1 | Mặc định |
| `/admin/products?page=-5` | 🔄 Redirect | page < 1 |
| `/admin/products?page=500` | 🔄 Redirect | page > totalPages |
| `/admin/products?page=abc` | ✓ Trang 1 | NumberFormatException → page = 1 |

---

### **Test cho Đơn hàng:**

| URL | Kết quả | Giải thích |
|-----|---------|-----------|
| `/admin/orders` | ✓ Trang 1 | Mặc định |
| `/admin/orders?page=-2` | 🔄 Redirect | page < 1 |
| `/admin/orders?page=1000` | 🔄 Redirect | page > totalPages |

---

### **Test cho Người dùng:**

| URL | Kết quả | Giải thích |
|-----|---------|-----------|
| `/admin/users` | ✓ Trang 1 | Mặc định |
| `/admin/users?page=-10` | 🔄 Redirect | page < 1 |
| `/admin/users?page=999` | 🔄 Redirect | page > totalPages |

---

## **⚙️ Quy trình trong Controller**

```
1. Lấy page từ URL
   ↓
2. Chuyển đổi sang int (nếu lỗi → page = 1)
   ↓
3. ✅ KIỂM TRA 1: page < 1?
   ├─ YES → Redirect tới trang mặc định → DỪNG
   └─ NO → Tiếp tục
   ↓
4. Lấy dữ liệu từ DB
   ↓
5. Tính totalPages
   ↓
6. ✅ KIỂM TRA 2: page > totalPages?
   ├─ YES → Redirect tới trang mặc định → DỪNG
   └─ NO → Tiếp tục
   ↓
7. Gửi dữ liệu tới JSP
   ↓
8. Hiển thị trang
```

---

## **🔍 Code Pattern**

Tất cả 4 controller đều sử dụng cùng pattern:

```java
// KIỂM TRA 1: Page < 1
if (page < 1) {
    response.sendRedirect(request.getContextPath() + "/admin/{resource}");
    return;
}

// ... lấy dữ liệu từ DB ...
int totalPages = Math.ceil(total / pageSize);

// KIỂM TRA 2: Page > totalPages
if (totalPages > 0 && page > totalPages) {
    response.sendRedirect(request.getContextPath() + "/admin/{resource}");
    return;
}

// ... gửi dữ liệu tới JSP ...
```

Thay `{resource}` bằng: `categories`, `products`, `orders`, hoặc `users`

---

## **✅ Lợi ích**

✓ **Ngăn chặn lỗi:** Không hiển thị trang trống hoặc lỗi
✓ **User-friendly:** Tự động quay về trang hợp lệ
✓ **Bảo mật:** Không tiết lộ thông tin hệ thống thông qua URL không hợp lệ
✓ **Consistent:** Cùng cách xử lý cho tất cả các module quản lý

---

## **🐛 Debugging**

Nếu redirect không hoạt động:

1. **Kiểm tra logic:**
   ```java
   if (page < 1)  // Nên là < chứ không phải <=
   if (totalPages > 0 && page > totalPages)  // Cần kiểm tra totalPages > 0
   ```

2. **Kiểm tra URL:**
   - Verify `request.getContextPath()` đúng
   - Verify endpoint `/admin/categories`, `/admin/products`, v.v.

3. **Kiểm tra return:**
   - Phải có `return;` sau `sendRedirect()` để dừng xử lý

---

## **📊 Diagram**

```
┌─────────────────────────────────┐
│ User nhập URL                    │
│ /admin/categories?page=-1        │
└────────────┬────────────────────┘
             ↓
┌─────────────────────────────────┐
│ Controller: listCategories()     │
│ - Lấy page = -1                 │
└────────────┬────────────────────┘
             ↓
┌─────────────────────────────────┐
│ ✅ KIỂM TRA 1: page < 1?        │
│ -1 < 1 ? → YES                  │
└────────────┬────────────────────┘
             ↓
┌─────────────────────────────────┐
│ response.sendRedirect()         │
│ /admin/categories               │
└────────────┬────────────────────┘
             ↓
┌─────────────────────────────────┐
│ return (DỪNG)                   │
└────────────┬────────────────────┘
             ↓
┌─────────────────────────────────┐
│ Browser chuyển hướng             │
│ URL: localhost:8082/WEBGMS/     │
│      admin/categories           │
└────────────┬────────────────────┘
             ↓
┌─────────────────────────────────┐
│ Hiển thị trang 1 (mặc định)     │
│ ✓ Danh sách danh mục            │
└─────────────────────────────────┘
```

---

Bây giờ tất cả các module quản lý đều được bảo vệ khỏi URL không hợp lệ! 🎉
