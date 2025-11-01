# **Giải Thích Chi Tiết Hệ Thống Quản Trị Admin - Quy Trình Mã Nguồn**

## **1. BẢN ĐIỀU KHIỂN ADMIN (`AdminDashboardController`)**

**Mẫu URL:** `/admin/dashboard`

**Quy Trình:**
```
Yêu cầu → AdminDashboardController.doGet()
  ├─ Kiểm tra quyền truy cập Admin (RoleBasedAccessControl)
  │  └─ Nếu không phải admin → Chuyển hướng về home có lỗi
  │
  ├─ Khởi tạo các DAO (Data Access Objects)
  │  ├─ UsersDAO
  │  ├─ ProductDAO
  │  ├─ OrderDAO
  │  └─ ProductCategoriesDAO
  │
  ├─ Lấy Số Liệu
  │  ├─ totalUsers = getTotalUsers()
  │  ├─ totalProducts = getTotalProductCount()
  │  ├─ totalOrders = getTotalOrders()
  │  ├─ ordersToday = getOrdersToday()
  │  ├─ revenueToday = getRevenueTodayAll()
  │  └─ totalCategories = getTotalCategories()
  │
  ├─ Lấy Dữ Liệu Gần Đây (5 bản ghi)
  │  ├─ recentUsers (5 người dùng mới nhất)
  │  ├─ recentOrders (5 đơn hàng mới nhất)
  │  └─ adminCategories (10 danh mục hàng đầu)
  │
  ├─ Thiết Lập Các Thuộc Tính Yêu Cầu
  │  └─ Tất cả số liệu được truyền đến JSP
  │
  └─ Chuyển Tiếp Đến admin-dashboard.jsp
```

**Trách Nhiệm Chính:**
- Xác minh người dùng có vai trò admin
- Tổng hợp các chỉ số kinh doanh chính (người dùng, sản phẩm, đơn hàng, doanh thu)
- Thu thập dữ liệu hoạt động gần đây
- Trình bày tổng quan bảng điều khiển cho admin

**Mã Nguồn Chi Tiết:**
```java
public void doGet(HttpServletRequest request, HttpServletResponse response) {
    // 1. Kiểm tra quyền admin
    RoleBasedAccessControl rbac = new RoleBasedAccessControl();
    if (!rbac.isAdmin(request)) {
        response.sendRedirect(request.getContextPath() + "/home?error=access_denied");
        return;
    }
    
    // 2. Khởi tạo DAO
    UsersDAO usersDAO = new dao.UsersDAO();
    ProductDAO productDAO = new dao.ProductDAO();
    OrderDAO orderDAO = new dao.OrderDAO();
    ProductCategoriesDAO cateDAO = new dao.ProductCategoriesDAO();
    
    // 3. Lấy số liệu
    int totalUsers = usersDAO.getTotalUsers();
    int totalProducts = productDAO.getTotalProductCount();
    int totalOrders = orderDAO.getTotalOrders();
    int ordersToday = orderDAO.getOrdersToday();
    BigDecimal revenueToday = orderDAO.getRevenueTodayAll();
    int totalCategories = cateDAO.getTotalCategories();
    
    // 4. Lấy dữ liệu gần đây
    List<Users> recentUsers = usersDAO.getRecentUsers(5);
    List<Orders> recentOrders = orderDAO.getRecentOrders(5);
    List<ProductCategories> adminCategories = cateDAO.getAllCategories(1, 10);
    
    // 5. Gửi dữ liệu đến view
    request.setAttribute("totalUsers", totalUsers);
    request.setAttribute("totalProducts", totalProducts);
    request.setAttribute("totalOrders", totalOrders);
    request.setAttribute("ordersToday", ordersToday);
    request.setAttribute("revenueToday", revenueToday);
    request.setAttribute("recentUsers", recentUsers);
    request.setAttribute("recentOrders", recentOrders);
    request.setAttribute("totalCategories", totalCategories);
    request.setAttribute("adminCategories", adminCategories);
    
    // 6. Chuyển tiếp
    request.getRequestDispatcher("/views/admin/admin-dashboard.jsp").forward(request, response);
}
```

---

## **2. HOẠT ĐỘNG CRUD SẢN PHẨM (`AdminProductsController`)**

**Mẫu URL:** `/admin/products`, `/admin/products/edit`, `/admin/products/update`, `/admin/products/delete`, `/admin/products/change-status`

### **2.1 LIỆT KÊ SẢN PHẨM (GET `/admin/products`)**
```
Yêu cầu với bộ lọc (keyword, status, category, page)
  ├─ Phân Tích Phân Trang
  │  └─ page = 1 (mặc định), pageSize = 12
  │
  ├─ Áp Dụng Bộ Lọc
  │  ├─ productDAO.adminFilterProducts(page, pageSize, keyword, category, status)
  │  └─ productDAO.adminCountFilteredProducts(keyword, category, status)
  │
  ├─ Tính Toán Phân Trang
  │  └─ totalPages = ceil(tổngCount / pageSize)
  │
  ├─ Lấy Danh Mục
  │  └─ Cho dropdown bộ lọc
  │
  └─ Chuyển tiếp đến admin-products.jsp với:
     ├─ danh sách sản phẩm
     ├─ danh mục
     ├─ thông tin phân trang
     └─ tham số bộ lọc
```

**Mã Nguồn:**
```java
if ("/admin/products".equals(path)) {
    // Lấy tham số bộ lọc
    String keyword = request.getParameter("keyword");
    String status = request.getParameter("status");
    String category = request.getParameter("category_id");
    int page = 1;
    int pageSize = 12;
    
    try {
        String p = request.getParameter("page");
        if (p != null) page = Integer.parseInt(p);
    } catch (Exception ignore) {}
    
    // Lọc sản phẩm
    List<Products> list = productDAO.adminFilterProducts(page, pageSize, keyword, category, status);
    int total = productDAO.adminCountFilteredProducts(keyword, category, status);
    int totalPages = (int) Math.ceil((double) total / pageSize);
    
    // Lấy danh mục
    ProductCategoriesDAO cateDAO = new ProductCategoriesDAO();
    List<ProductCategories> categories = cateDAO.getAllCategories();
    
    // Gửi dữ liệu
    request.setAttribute("products", list);
    request.setAttribute("categories", categories);
    request.setAttribute("currentPage", page);
    request.setAttribute("totalPages", totalPages);
    request.setAttribute("totalProducts", total);
    request.setAttribute("keyword", keyword);
    request.setAttribute("status", status);
    request.setAttribute("categoryId", category);
    
    request.getRequestDispatcher("/views/admin/admin-products.jsp").forward(request, response);
}
```

### **2.2 BIỂU MẪU CHỈNH SỬA SẢN PHẨM (GET `/admin/products/edit`)**
```
Yêu cầu với id sản phẩm
  ├─ Xác Thực Sản Phẩm Tồn Tại
  │  └─ Nếu không tìm thấy → Chuyển hướng về /admin/products
  │
  ├─ Lấy Chi Tiết Sản Phẩm
  │  └─ productDAO.getProductById(id)
  │
  ├─ Lấy Danh Mục
  │  └─ Cho dropdown lựa chọn
  │
  └─ Chuyển tiếp đến admin-product-edit.jsp với:
     ├─ chi tiết sản phẩm
     └─ danh mục
```

**Mã Nguồn:**
```java
if ("/admin/products/edit".equals(path)) {
    long id = Long.parseLong(request.getParameter("id"));
    Products product = productDAO.getProductById(id);
    
    if (product == null) {
        response.sendRedirect(request.getContextPath() + "/admin/products");
        return;
    }
    
    ProductCategoriesDAO cateDAO = new ProductCategoriesDAO();
    List<ProductCategories> categories = cateDAO.getAllCategories();
    
    request.setAttribute("product", product);
    request.setAttribute("categories", categories);
    request.getRequestDispatcher("/views/admin/admin-product-edit.jsp")
        .forward(request, response);
}
```

### **2.3 CẬP NHẬT SẢN PHẨM (POST `/admin/products/update`)**
```
Yêu cầu với dữ liệu biểu mẫu
  ├─ Xác Thực Sản Phẩm Tồn Tại
  │  └─ existing = productDAO.getProductById(productId)
  │
  ├─ Trích Xuất Dữ Liệu Biểu Mẫu
  │  ├─ name (tên)
  │  ├─ description (mô tả)
  │  ├─ price (giá - BigDecimal)
  │  ├─ quantity (số lượng)
  │  ├─ category_id (id danh mục)
  │  ├─ status (trạng thái)
  │  └─ image (tùy chọn)
  │
  ├─ Cập Nhật Đối Tượng Sản Phẩm
  │  ├─ setName()
  │  ├─ setDescription()
  │  ├─ setPrice()
  │  ├─ setQuantity()
  │  ├─ setStatus()
  │  └─ setUpdated_at(dấu thời gian hiện tại)
  │
  ├─ Xử Lý Tải Lên Hình Ảnh (nếu được cung cấp)
  │  ├─ Xác Thực Định Dạng Hình Ảnh (.jpg, .jpeg, .png, .webp)
  │  │  └─ Nếu không hợp lệ → Trả lỗi
  │  │
  │  ├─ Tạo Thư Mục Tải Lên
  │  │  └─ /uploads/products/
  │  │
  │  ├─ Tạo Tên Tệp Duy Nhất
  │  │  └─ {dấu thời gian}_{tên tệp gốc}
  │  │
  │  ├─ Lưu Hình Ảnh Vào Đĩa
  │  │  └─ imagePart.write(uploadPath)
  │  │
  │  └─ Cập Nhật Hình Ảnh Sản Phẩm Trong Cơ Sở Dữ Liệu
  │     └─ ProductImageDAO.updatePrimaryImage(productId, imageUrl, description)
  │
  ├─ Lưu Sản Phẩm
  │  └─ productDAO.updateProduct(existing)
  │
  └─ Chuyển Hướng Đến /admin/products
     ├─ ?success=update (nếu thành công)
     └─ ?error=1 (nếu thất bại)
```

**Mã Nguồn:**
```java
if ("/admin/products/update".equals(path)) {
    try {
        long productId = Long.parseLong(request.getParameter("product_id"));
        Products existing = productDAO.getProductById(productId);
        if (existing == null) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }
        
        // Trích xuất dữ liệu
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        BigDecimal price = new BigDecimal(request.getParameter("price"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        int categoryId = Integer.parseInt(request.getParameter("category_id"));
        String status = request.getParameter("status");
        Part imagePart = request.getPart("image");
        
        // Cập nhật đối tượng
        existing.setName(name);
        existing.setDescription(description);
        existing.setPrice(price);
        existing.setQuantity(quantity);
        existing.setStatus(status);
        existing.setUpdated_at(new Timestamp(System.currentTimeMillis()));
        
        ProductCategories cate = new ProductCategories();
        cate.setCategory_id(categoryId);
        existing.setCategory_id(cate);
        
        // Xử lý hình ảnh
        if (imagePart != null && imagePart.getSize() > 0) {
            String lower = imagePart.getSubmittedFileName() == null ? "" 
                : imagePart.getSubmittedFileName().toLowerCase();
            
            // Kiểm tra định dạng
            if (!(lower.endsWith(".jpg") || lower.endsWith(".jpeg") 
                || lower.endsWith(".png") || lower.endsWith(".webp"))) {
                request.setAttribute("error", "Định dạng ảnh không hợp lệ");
                request.setAttribute("product", existing);
                request.getRequestDispatcher("/views/admin/admin-product-edit.jsp")
                    .forward(request, response);
                return;
            }
            
            // Tạo thư mục
            String uploadPath = request.getServletContext().getRealPath("") 
                + File.separator + "uploads" + File.separator + "products";
            new File(uploadPath).mkdirs();
            
            // Tạo tên tệp
            String fileName = System.currentTimeMillis() + "_" 
                + imagePart.getSubmittedFileName();
            imagePart.write(uploadPath + File.separator + fileName);
            
            // Lưu URL hình ảnh
            String imageUrl = request.getContextPath() + "/uploads/products/" + fileName;
            new ProductImageDAO().updatePrimaryImage(productId, imageUrl, 
                "Ảnh sản phẩm " + name);
        }
        
        // Cập nhật cơ sở dữ liệu
        boolean ok = productDAO.updateProduct(existing);
        response.sendRedirect(request.getContextPath() + "/admin/products" 
            + (ok ? "?success=update" : "?error=1"));
        return;
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect(request.getContextPath() + "/admin/products?error=1");
    }
}
```

### **2.4 XÓA SẢN PHẨM (POST `/admin/products/delete`)**
```
Yêu cầu với id sản phẩm
  ├─ Trích Xuất product_id
  │
  ├─ Thực Hiện Xóa Mềm
  │  └─ productDAO.softDeleteProduct(id)
  │     (đánh dấu là đã xóa, không xóa khỏi DB)
  │
  └─ Chuyển Hướng Đến /admin/products
     ├─ ?success=delete
     └─ ?error=1
```

**Mã Nguồn:**
```java
if ("/admin/products/delete".equals(path)) {
    try {
        long id = Long.parseLong(request.getParameter("id"));
        boolean ok = productDAO.softDeleteProduct(id);
        response.sendRedirect(request.getContextPath() + "/admin/products" 
            + (ok ? "?success=delete" : "?error=1"));
        return;
    } catch (Exception e) {
        response.sendRedirect(request.getContextPath() + "/admin/products?error=1");
        return;
    }
}
```

### **2.5 THAY ĐỔI TRẠNG THÁI (POST `/admin/products/change-status`)**
```
Yêu cầu với id sản phẩm và trạng thái mới
  ├─ Trích Xuất product_id và newStatus
  │
  ├─ Lấy Sản Phẩm
  │  └─ productDAO.getProductById(id)
  │
  ├─ Cập Nhật Trạng Thái
  │  ├─ product.setStatus(newStatus)
  │  ├─ product.setUpdated_at(dấu thời gian hiện tại)
  │  └─ productDAO.updateProduct(product)
  │
  └─ Chuyển Hướng Đến /admin/products?success=status
```

**Mã Nguồn:**
```java
if ("/admin/products/change-status".equals(path)) {
    long id = Long.parseLong(request.getParameter("id"));
    String newStatus = request.getParameter("status");
    
    Products p = productDAO.getProductById(id);
    if (p != null) {
        p.setStatus(newStatus);
        p.setUpdated_at(new Timestamp(System.currentTimeMillis()));
        productDAO.updateProduct(p);
    }
    
    response.sendRedirect(request.getContextPath() + "/admin/products?success=status");
}
```

---

## **3. QUẢN LÝ NGƯỜI DÙNG (`AdminUserController`)**

**Mẫu URL:** `/admin/users`

### **3.1 ĐỊNH TUYẾN DỰA TRÊN HÀNH ĐỘNG**
```
Yêu cầu với tham số ?action
  │
  ├─ action=list (mặc định)
  │  └─ listUsers()
  │
  ├─ action=create
  │  └─ showCreateForm()
  │
  ├─ action=edit
  │  └─ showEditForm()
  │
  └─ action=delete
     └─ deleteUser()
```

### **3.2 LIỆT KÊ NGƯỜI DÙNG (GET với action=list)**
```
Trích Xuất Bộ Lọc
  ├─ keyword (tìm theo tên/email)
  ├─ status (hoạt động/không hoạt động/tất cả)
  ├─ role (admin/người bán/người mua/tất cả)
  └─ page (phân trang, mặc định=1)

Xác Định Loại Truy Vấn
  ├─ Nếu áp dụng bộ lọc
  │  ├─ users = userDAO.searchUsers(keyword, status, role, page, PAGE_SIZE)
  │  └─ totalUsers = userDAO.countUsers(keyword, status, role)
  │
  └─ Ngược lại (không có bộ lọc)
     ├─ users = userDAO.getAllUsers(page, PAGE_SIZE)
     └─ totalUsers = userDAO.getTotalUsers()

Tính Toán Phân Trang
  └─ totalPages = ceil(totalUsers / PAGE_SIZE)

Chuyển tiếp đến users-list.jsp với:
  ├─ danh sách người dùng
  ├─ thông tin phân trang
  ├─ tham số bộ lọc
  └─ tổng số
```

**Mã Nguồn:**
```java
private void listUsers(HttpServletRequest request, HttpServletResponse response) {
    String keyword = request.getParameter("keyword");
    String status = request.getParameter("status");
    String role = request.getParameter("role");
    String pageStr = request.getParameter("page");
    
    int page = 1;
    if (pageStr != null && !pageStr.isEmpty()) {
        try {
            page = Integer.parseInt(pageStr);
        } catch (NumberFormatException e) {
            page = 1;
        }
    }
    
    UsersDAO userDAO = new UsersDAO();
    List<Users> users;
    int totalUsers;
    
    // Kiểm tra nếu có bộ lọc
    if ((keyword != null && !keyword.trim().isEmpty()) || 
        (status != null && !status.equals("all")) || 
        (role != null && !role.equals("all"))) {
        users = userDAO.searchUsers(keyword, status, role, page, PAGE_SIZE);
        totalUsers = userDAO.countUsers(keyword, status, role);
    } else {
        users = userDAO.getAllUsers(page, PAGE_SIZE);
        totalUsers = userDAO.getTotalUsers();
    }
    
    int totalPages = (int) Math.ceil((double) totalUsers / PAGE_SIZE);
    
    // Gửi dữ liệu
    request.setAttribute("users", users);
    request.setAttribute("currentPage", page);
    request.setAttribute("totalPages", totalPages);
    request.setAttribute("totalUsers", totalUsers);
    request.setAttribute("keyword", keyword);
    request.setAttribute("status", status);
    request.setAttribute("role", role);
    
    request.getRequestDispatcher("/views/admin/users-list.jsp").forward(request, response);
}
```

### **3.3 BIỂU MẪU TẠO NGƯỜI DÙNG (GET với action=create)**
```
Lấy Tất Cả Vai Trò
  └─ RoleDAO.getAllRoles()

Chuyển tiếp đến user-form.jsp với:
  └─ danh sách vai trò
```

**Mã Nguồn:**
```java
private void showCreateForm(HttpServletRequest request, HttpServletResponse response) {
    RoleDAO roleDAO = new RoleDAO();
    List<Roles> roles = roleDAO.getAllRoles();
    request.setAttribute("roles", roles);
    request.getRequestDispatcher("/views/admin/user-form.jsp").forward(request, response);
}
```

### **3.4 TẠO NGƯỜI DÙNG (POST với action=create)**
```
Trích Xuất Dữ Liệu Biểu Mẫu
  ├─ fullName (họ tên)
  ├─ email
  ├─ password (mật khẩu)
  └─ phoneNumber (số điện thoại)

Xác Thực
  ├─ Kiểm tra email duy nhất
  │  └─ Nếu tồn tại → Hiển thị lỗi, trả lại biểu mẫu
  │
  └─ Kiểm tra số điện thoại duy nhất
     └─ Nếu tồn tại → Hiển thị lỗi, trả lại biểu mẫu

Tạo Người Dùng
  └─ user = userDAO.createUser(fullName, email, password, phoneNumber)

Gán Vai Trò
  └─ userDAO.assignDefaultUserRole(userId)
     (thường là: vai trò Người mua/Khách hàng)

Tin Nhắn Phiên & Chuyển Hướng
  ├─ Thiết lập thành công: "Tạo người dùng thành công"
  └─ Chuyển hướng đến /admin/users
```

**Mã Nguồn:**
```java
private void createUser(HttpServletRequest request, HttpServletResponse response) {
    String fullName = request.getParameter("fullName");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String phoneNumber = request.getParameter("phoneNumber");
    
    UsersDAO userDAO = new UsersDAO();
    
    // Kiểm tra email
    if (userDAO.isEmailExists(email)) {
        request.setAttribute("error", "Email đã tồn tại");
        showCreateForm(request, response);
        return;
    }
    
    // Kiểm tra số điện thoại
    if (userDAO.isPhoneExists(phoneNumber)) {
        request.setAttribute("error", "Số điện thoại đã tồn tại");
        showCreateForm(request, response);
        return;
    }
    
    // Tạo người dùng
    Users user = userDAO.createUser(fullName, email, password, phoneNumber);
    
    if (user != null) {
        userDAO.assignDefaultUserRole(user.getUser_id());
        request.getSession().setAttribute("success", "Tạo người dùng thành công");
        response.sendRedirect(request.getContextPath() + "/admin/users");
    } else {
        request.setAttribute("error", "Tạo người dùng thất bại");
        showCreateForm(request, response);
    }
}
```

### **3.5 BIỂU MẪU CHỈNH SỬA NGƯỜI DÙNG (GET với action=edit)**
```
Trích Xuất user_id từ tham số

Xác Thực Người Dùng Tồn Tại
  ├─ user = userDAO.getUserById(userId)
  └─ Nếu null → Chuyển hướng đến /admin/users

Lấy Vai Trò
  └─ RoleDAO.getAllRoles()

Chuyển tiếp đến user-form.jsp với:
  ├─ đối tượng người dùng
  ├─ danh sách vai trò
  └─ isEdit = true
```

**Mã Nguồn:**
```java
private void showEditForm(HttpServletRequest request, HttpServletResponse response) {
    String userIdStr = request.getParameter("id");
    if (userIdStr == null || userIdStr.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/admin/users");
        return;
    }
    
    int userId = Integer.parseInt(userIdStr);
    UsersDAO userDAO = new UsersDAO();
    Users user = userDAO.getUserById(userId);
    
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/admin/users");
        return;
    }
    
    RoleDAO roleDAO = new RoleDAO();
    List<Roles> roles = roleDAO.getAllRoles();
    
    request.setAttribute("user", user);
    request.setAttribute("roles", roles);
    request.setAttribute("isEdit", true);
    
    request.getRequestDispatcher("/views/admin/user-form.jsp").forward(request, response);
}
```

### **3.6 CẬP NHẬT NGƯỜI DÙNG (POST với action=update)**
```
Trích Xuất Dữ Liệu Biểu Mẫu
  ├─ userId
  ├─ fullName (họ tên)
  ├─ email
  ├─ phoneNumber (số điện thoại)
  ├─ address (địa chỉ)
  ├─ gender (giới tính)
  └─ status (trạng thái)

Lấy Người Dùng
  └─ user = userDAO.getUserById(userId)

Cập Nhật Đối Tượng
  ├─ setFull_name()
  ├─ setEmail()
  ├─ setPhone_number()
  ├─ setAddress()
  ├─ setGender()
  └─ setStatus()

Lưu Vào Cơ Sở Dữ Liệu
  └─ success = userDAO.updateUser(user)

Chuyển Hướng
  ├─ Nếu thành công → /admin/users với "Cập nhật thành công"
  └─ Ngược lại → Hiển thị lại biểu mẫu có lỗi
```

**Mã Nguồn:**
```java
private void updateUser(HttpServletRequest request, HttpServletResponse response) {
    String userIdStr = request.getParameter("userId");
    String fullName = request.getParameter("fullName");
    String email = request.getParameter("email");
    String phoneNumber = request.getParameter("phoneNumber");
    String address = request.getParameter("address");
    String gender = request.getParameter("gender");
    String status = request.getParameter("status");
    
    int userId = Integer.parseInt(userIdStr);
    UsersDAO userDAO = new UsersDAO();
    Users user = userDAO.getUserById(userId);
    
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/admin/users");
        return;
    }
    
    // Cập nhật các trường
    user.setFull_name(fullName);
    user.setEmail(email);
    user.setPhone_number(phoneNumber);
    user.setAddress(address);
    user.setGender(gender);
    user.setStatus(status);
    
    boolean success = userDAO.updateUser(user);
    
    if (success) {
        request.getSession().setAttribute("success", "Cập nhật người dùng thành công");
        response.sendRedirect(request.getContextPath() + "/admin/users");
    } else {
        request.setAttribute("error", "Cập nhật người dùng thất bại");
        showEditForm(request, response);
    }
}
```

### **3.7 XÓA NGƯỜI DÙNG (GET với action=delete)**
```
Trích Xuất user_id

Xóa Người Dùng
  └─ success = userDAO.deleteUser(userId)

Tin Nhắn Phiên & Chuyển Hướng
  ├─ Nếu thành công → "Xóa người dùng thành công"
  ├─ Nếu thất bại → "Xóa người dùng thất bại"
  └─ Chuyển hướng đến /admin/users
```

**Mã Nguồn:**
```java
private void deleteUser(HttpServletRequest request, HttpServletResponse response) {
    String userIdStr = request.getParameter("id");
    if (userIdStr == null || userIdStr.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/admin/users");
        return;
    }
    
    int userId = Integer.parseInt(userIdStr);
    UsersDAO userDAO = new UsersDAO();
    boolean success = userDAO.deleteUser(userId);
    
    if (success) {
        request.getSession().setAttribute("success", "Xóa người dùng thành công");
    } else {
        request.getSession().setAttribute("error", "Xóa người dùng thất bại");
    }
    
    response.sendRedirect(request.getContextPath() + "/admin/users");
}
```

### **3.8 CẬP NHẬT TRẠNG THÁI NGƯỜI DÙNG (POST với action=updateStatus)**
```
Trích Xuất Tham Số
  ├─ userId
  └─ newStatus (trạng thái mới)

Cập Nhật Trạng Thái
  └─ success = userDAO.updateUserStatus(userId, newStatus)

Tin Nhắn Phiên & Chuyển Hướng
  ├─ Nếu thành công → "Cập nhật trạng thái thành công"
  ├─ Nếu thất bại → "Cập nhật trạng thái thất bại"
  └─ Chuyển hướng đến /admin/users
```

**Mã Nguồn:**
```java
private void updateUserStatus(HttpServletRequest request, HttpServletResponse response) {
    String userIdStr = request.getParameter("userId");
    String status = request.getParameter("status");
    
    int userId = Integer.parseInt(userIdStr);
    UsersDAO userDAO = new UsersDAO();
    boolean success = userDAO.updateUserStatus(userId, status);
    
    if (success) {
        request.getSession().setAttribute("success", "Cập nhật trạng thái thành công");
    } else {
        request.getSession().setAttribute("error", "Cập nhật trạng thái thất bại");
    }
    
    response.sendRedirect(request.getContextPath() + "/admin/users");
}
```

---

## **4. QUẢN LÝ DANH MỤC (`AdminCategoryController`)**

**Mẫu URL:** `/admin/categories`

### **4.1 ĐỊNH TUYẾN DỰA TRÊN HÀNH ĐỘNG (Cấu Trúc Tương Tự Như Người Dùng)**
```
action=list (mặc định) → listCategories()
action=create → showCreateForm()
action=edit → showEditForm()
action=delete → deleteCategory()
```

### **4.2 LIỆT KÊ DANH MỤC (GET với action=list)**
```
Trích Xuất Bộ Lọc
  ├─ keyword (tìm theo tên)
  ├─ status (hoạt động/không hoạt động/tất cả)
  └─ page (mặc định=1)

Xác Định Loại Truy Vấn
  ├─ Nếu áp dụng bộ lọc
  │  ├─ categories = categoryDAO.searchCategories(keyword, status, page, PAGE_SIZE)
  │  └─ totalCategories = categoryDAO.countCategories(keyword, status)
  │
  └─ Ngược lại
     ├─ categories = categoryDAO.getAllCategories(page, PAGE_SIZE)
     └─ totalCategories = categoryDAO.getTotalCategories()

Tính Toán Phân Trang
  └─ totalPages = ceil(totalCategories / PAGE_SIZE)

Chuyển tiếp đến categories-list.jsp
```

**Mã Nguồn:**
```java
private void listCategories(HttpServletRequest request, HttpServletResponse response) {
    String keyword = request.getParameter("keyword");
    String status = request.getParameter("status");
    String pageStr = request.getParameter("page");
    
    int page = 1;
    if (pageStr != null && !pageStr.isEmpty()) {
        try {
            page = Integer.parseInt(pageStr);
        } catch (NumberFormatException e) {
            page = 1;
        }
    }
    
    ProductCategoriesDAO categoryDAO = new ProductCategoriesDAO();
    List<ProductCategories> categories;
    int totalCategories;
    
    if ((keyword != null && !keyword.trim().isEmpty()) || 
        (status != null && !"all".equals(status))) {
        categories = categoryDAO.searchCategories(keyword, status, page, PAGE_SIZE);
        totalCategories = categoryDAO.countCategories(keyword, status);
    } else {
        categories = categoryDAO.getAllCategories(page, PAGE_SIZE);
        totalCategories = categoryDAO.getTotalCategories();
    }
    
    int totalPages = (int) Math.ceil((double) totalCategories / PAGE_SIZE);
    
    request.setAttribute("categories", categories);
    request.setAttribute("currentPage", page);
    request.setAttribute("totalPages", totalPages);
    request.setAttribute("totalCategories", totalCategories);
    request.setAttribute("keyword", keyword);
    request.setAttribute("status", status);
    
    request.getRequestDispatcher("/views/admin/categories-list.jsp")
        .forward(request, response);
}
```

### **4.3 BIỂU MẪU TẠO DANH MỤC (GET với action=create)**
```
Chuyển tiếp đến category-form.jsp
(không cần dữ liệu cho biểu mẫu trống)
```

**Mã Nguồn:**
```java
private void showCreateForm(HttpServletRequest request, HttpServletResponse response) {
    request.getRequestDispatcher("/views/admin/category-form.jsp")
        .forward(request, response);
}
```

### **4.4 TẠO DANH MỤC (POST với action=create)**
```
Trích Xuất Dữ Liệu Biểu Mẫu
  ├─ name (tên)
  ├─ slug
  ├─ description (mô tả)
  └─ status (trạng thái)

Xác Thực Tính Duy Nhất
  └─ Nếu categoryDAO.isCategoryNameExists(name, null)
     └─ Trả lỗi: "Tên danh mục đã tồn tại"

Tạo Đối Tượng & Lưu
  ├─ category = new ProductCategories()
  ├─ setName(), setSlug(), setDescription(), setStatus()
  └─ success = categoryDAO.createCategory(category)

Chuyển Hướng
  ├─ Nếu thành công → /admin/categories với "Tạo danh mục thành công"
  └─ Ngược lại → Hiển thị lại biểu mẫu có lỗi
```

**Mã Nguồn:**
```java
private void createCategory(HttpServletRequest request, HttpServletResponse response) {
    String name = request.getParameter("name");
    String slug = request.getParameter("slug");
    String description = request.getParameter("description");
    String status = request.getParameter("status");
    
    ProductCategoriesDAO categoryDAO = new ProductCategoriesDAO();
    
    // Kiểm tra tên duy nhất
    if (categoryDAO.isCategoryNameExists(name, null)) {
        request.setAttribute("error", "Tên danh mục đã tồn tại");
        showCreateForm(request, response);
        return;
    }
    
    // Tạo danh mục
    ProductCategories category = new ProductCategories();
    category.setName(name);
    category.setSlug(slug);
    category.setDescription(description);
    category.setStatus(status);
    
    boolean success = categoryDAO.createCategory(category);
    
    if (success) {
        request.getSession().setAttribute("success", "Tạo danh mục thành công");
        response.sendRedirect(request.getContextPath() + "/admin/categories");
    } else {
        request.setAttribute("error", "Tạo danh mục thất bại");
        showCreateForm(request, response);
    }
}
```

### **4.5 BIỂU MẪU CHỈNH SỬA DANH MỤC (GET với action=edit)**
```
Trích Xuất category_id

Xác Thực Danh Mục Tồn Tại
  ├─ category = categoryDAO.getCategoryById(categoryId)
  └─ Nếu null → Chuyển hướng đến /admin/categories

Chuyển tiếp đến category-form.jsp với:
  ├─ đối tượng danh mục
  └─ isEdit = true
```

**Mã Nguồn:**
```java
private void showEditForm(HttpServletRequest request, HttpServletResponse response) {
    String categoryIdStr = request.getParameter("id");
    if (categoryIdStr == null || categoryIdStr.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/admin/categories");
        return;
    }
    
    long categoryId = Long.parseLong(categoryIdStr);
    ProductCategoriesDAO categoryDAO = new ProductCategoriesDAO();
    ProductCategories category = categoryDAO.getCategoryById(categoryId);
    
    if (category == null) {
        response.sendRedirect(request.getContextPath() + "/admin/categories");
        return;
    }
    
    request.setAttribute("category", category);
    request.setAttribute("isEdit", true);
    
    request.getRequestDispatcher("/views/admin/category-form.jsp")
        .forward(request, response);
}
```

### **4.6 CẬP NHẬT DANH MỤC (POST với action=update)**
```
Trích Xuất Dữ Liệu Biểu Mẫu
  ├─ categoryId
  ├─ name (tên)
  ├─ slug
  ├─ description (mô tả)
  └─ status (trạng thái)

Lấy & Xác Thực
  └─ category = categoryDAO.getCategoryById(categoryId)

Kiểm Tra Tính Duy Nhất
  └─ Nếu categoryDAO.isCategoryNameExists(name, categoryId)
     └─ Trả lỗi (loại trừ danh mục hiện tại khỏi kiểm tra)

Cập Nhật & Lưu
  ├─ setName(), setSlug(), setDescription(), setStatus()
  └─ success = categoryDAO.updateCategory(category)

Chuyển Hướng
  ├─ Nếu thành công → /admin/categories với "Cập nhật thành công"
  └─ Ngược lại → Hiển thị lại biểu mẫu có lỗi
```

**Mã Nguồn:**
```java
private void updateCategory(HttpServletRequest request, HttpServletResponse response) {
    String categoryIdStr = request.getParameter("categoryId");
    String name = request.getParameter("name");
    String slug = request.getParameter("slug");
    String description = request.getParameter("description");
    String status = request.getParameter("status");
    
    long categoryId = Long.parseLong(categoryIdStr);
    ProductCategoriesDAO categoryDAO = new ProductCategoriesDAO();
    ProductCategories category = categoryDAO.getCategoryById(categoryId);
    
    if (category == null) {
        response.sendRedirect(request.getContextPath() + "/admin/categories");
        return;
    }
    
    // Kiểm tra tên duy nhất
    if (categoryDAO.isCategoryNameExists(name, categoryId)) {
        request.setAttribute("error", "Tên danh mục đã tồn tại");
        request.setAttribute("category", category);
        request.setAttribute("isEdit", true);
        request.getRequestDispatcher("/views/admin/category-form.jsp")
            .forward(request, response);
        return;
    }
    
    // Cập nhật
    category.setName(name);
    category.setSlug(slug);
    category.setDescription(description);
    category.setStatus(status);
    
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
}
```

### **4.7 XÓA DANH MỤC (GET với action=delete)**
```
Trích Xuất category_id

Xóa
  └─ success = categoryDAO.deleteCategory(categoryId)

Chuyển Hướng
  ├─ Nếu thành công → "Xóa danh mục thành công"
  ├─ Nếu thất bại → "Xóa danh mục thất bại"
  └─ Chuyển hướng đến /admin/categories
```

**Mã Nguồn:**
```java
private void deleteCategory(HttpServletRequest request, HttpServletResponse response) {
    String categoryIdStr = request.getParameter("id");
    if (categoryIdStr == null || categoryIdStr.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/admin/categories");
        return;
    }
    
    long categoryId = Long.parseLong(categoryIdStr);
    ProductCategoriesDAO categoryDAO = new ProductCategoriesDAO();
    boolean success = categoryDAO.deleteCategory(categoryId);
    
    if (success) {
        request.getSession().setAttribute("success", "Xóa danh mục thành công");
    } else {
        request.getSession().setAttribute("error", "Xóa danh mục thất bại");
    }
    
    response.sendRedirect(request.getContextPath() + "/admin/categories");
}
```

---

## **5. GIAO DIỆN BẢN ĐIỀU KHIỂN (`admin-dashboard.jsp`)**

**Cấu Trúc:**
```html
Bố Cục Trang
├─ Thanh Bên (Điều Hướng)
├─ Tiêu Đề (Tiêu đề admin)
│
└─ Nội Dung Chính
   ├─ Tiêu Đề & Bánh Mì Tẩm Gia Vị
   │
   ├─ Hộp Cảnh Báo
   │  └─ "Chào mừng bạn..."
   │
   ├─ Số Liệu Chính (4 thẻ)
   │  ├─ Tổng Người Dùng
   │  ├─ Tổng Sản Phẩm
   │  ├─ Tổng Đơn Hàng
   │  └─ Doanh Thu Hôm Nay
   │
   ├─ Hoạt Động Gần Đây (2 cột)
   │  ├─ Người Dùng Gần Đây (bảng)
   │  │  └─ Lặp qua recentUsers
   │  │
   │  └─ Đơn Hàng Gần Đây (bảng)
   │     └─ Lặp qua recentOrders
   │        └─ Huy hiệu trạng thái (thành công/cảnh báo)
   │
   └─ Ảnh Chụp Danh Mục
      ├─ Số đếm tổng danh mục
      ├─ Nút Hành Động
      │  ├─ Quản Lý Danh Mục
      │  └─ Thêm Danh Mục
      │
      └─ Bảng Danh Mục
         └─ Lặp qua adminCategories
```

---

## **6. TÓM TẮT QUY TRÌNH DỮ LIỆU**

**Yêu Cầu Người Dùng → Bộ Điều Khiển → DAO → Cơ Sở Dữ Liệu → Mô Hình → Giao Diện**

### **Ví Dụ: Quy Trình Cập Nhật Sản Phẩm**
```
1. Admin điền biểu mẫu & gửi
   ↓
2. AdminProductsController.doPost(/admin/products/update)
   ↓
3. Trích xuất & xác thực dữ liệu
   ↓
4. Tạo/Cập nhật đối tượng Products
   ↓
5. Xử lý tải lên hình ảnh (nếu có)
   ↓
6. Gọi ProductDAO.updateProduct(product)
   ↓
7. DAO thực thi SQL UPDATE
   ↓
8. Chuyển hướng đến /admin/products
   ↓
9. Giao diện danh sách hiển thị các sản phẩm đã cập nhật
```

---

## **7. CÁC MẪU THIẾT KẾ CHÍNH**

### **Mẫu Tham Số Hành Động (Action Parameter Pattern):**
- Sử dụng một servlet cho nhiều hoạt động
- Định tuyến thông qua `?action=create|edit|list|delete`
- Giảm số lượng servlet

### **Mẫu DAO (DAO Pattern):**
- Tách biệt logic cơ sở dữ liệu khỏi bộ điều khiển
- Mỗi thực thể có DAO dành riêng (ProductDAO, UserDAO, v.v.)
- Tái sử dụng được trên nhiều bộ điều khiển

### **Phân Trang (Pagination):**
- Tất cả các trang danh sách hỗ trợ phân trang
- Kích thước trang mặc định khác nhau (Sản phẩm: 12, Người dùng/Danh mục: 10)
- Tính toán tổng số trang ở phía máy chủ

### **Xác Thực (Validation):**
- Kiểm tra tính duy nhất trước khi tạo
- Xác thực định dạng tệp cho tải lên
- Kiểm tra sự tồn tại của người dùng trước khi chỉnh sửa

### **Bảo Mật (Security):**
- Kiểm tra kiểm soát quyền truy cập admin trong bảng điều khiển
- Kiểm soát truy cập dựa trên vai trò thông qua RoleBasedAccessControl

---

## **8. BẢNG TÓMLƯỢC CÁC ENDPOINT**

| Endpoint | Phương Thức | Hành Động | Mô Tả |
|----------|-----------|----------|-------|
| `/admin/dashboard` | GET | - | Xem bảng điều khiển |
| `/admin/products` | GET | - | Liệt kê sản phẩm |
| `/admin/products/edit` | GET | - | Hiển thị biểu mẫu chỉnh sửa |
| `/admin/products/update` | POST | update | Cập nhật sản phẩm |
| `/admin/products/delete` | POST | delete | Xóa sản phẩm |
| `/admin/products/change-status` | POST | - | Thay đổi trạng thái |
| `/admin/users` | GET/POST | list/create/edit/update/delete | Quản lý người dùng |
| `/admin/categories` | GET/POST | list/create/edit/update/delete | Quản lý danh mục |

Đây là hệ thống quản lý toàn diện với tất cả các hoạt động CRUD cho Sản phẩm, Người dùng và Danh mục!
