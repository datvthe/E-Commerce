# **HƯỚNG DẪN QUẢN LÝ ROLE NGƯỜI DÙNG**

## **📝 Những thay đổi đã thực hiện**

### **1. File JSP - user-form.jsp**
**Vị trí:** `/views/admin/user-form.jsp` - Dòng 100-124

**Thêm mục chọn Role:**
```html
<!-- KHI CHỈNH SỬA NGƯỜI DÙNG (isEdit = true) -->
<div class="select-style-1 mb-20">
    <label>Vai trò <span class="text-danger">*</span></label>
    <select name="role" class="form-select" required>
        <option value="">Chọn vai trò</option>
        <c:forEach var="r" items="${roles}">
            <option value="${r.role_id}" 
                <c:forEach var="userRole" items="${userRoles}">
                    ${userRole.role_id == r.role_id ? 'selected' : ''}
                </c:forEach>
            >${r.name}</option>
        </c:forEach>
    </select>
    <small class="text-muted">Các vai trò: Admin, Manager, Seller, Customer</small>
</div>
```

**Giải thích:**
- Hiển thị dropdown để chọn role
- Lặp qua `${roles}` - tất cả roles từ database
- Kiểm tra `${userRoles}` - role hiện tại của người dùng
- Nếu khớp → `selected` (đánh dấu)
- Các role có sẵn: Admin, Manager, Seller, Customer

---

### **2. File JSP - users-list.jsp**
**Vị trí:** `/views/admin/users-list.jsp` - Dòng 111-160

**a) Thêm cột "Vai trò" vào bảng (Dòng 117):**
```html
<th><h6>Vai trò</h6></th>
```

**b) Hiển thị Role với màu sắc khác nhau (Dòng 145-159):**
```html
<td>
    <c:choose>
        <c:when test="${user.default_role == 'admin' || user.default_role == 'Admin'}">
            <span class="status-btn" style="background: #dc3545; color: white;">
                Quản trị viên
            </span>
        </c:when>
        <c:when test="${user.default_role == 'manager' || user.default_role == 'Manager'}">
            <span class="status-btn" style="background: #fd7e14; color: white;">
                Quản lý
            </span>
        </c:when>
        <c:when test="${user.default_role == 'seller' || user.default_role == 'Seller'}">
            <span class="status-btn" style="background: #0dcaf0; color: white;">
                Người bán
            </span>
        </c:when>
        <c:otherwise>
            <span class="status-btn success-btn">Khách hàng</span>
        </c:otherwise>
    </c:choose>
</td>
```

**Giải thích:**
- Hiển thị role với màu sắc phân biệt:
  - **Admin** → Đỏ (#dc3545)
  - **Manager** → Cam (#fd7e14)
  - **Seller** → Xanh nhạt (#0dcaf0)
  - **Customer** → Xanh lá (success-btn)

---

### **3. Controller - AdminUserController.java**

#### **A. showEditForm() - Dòng 142-168**

**Thêm lấy userRoles:**
```java
RoleDAO roleDAO = new RoleDAO();
List<Roles> roles = roleDAO.getAllRoles();
List<Roles> userRoles = roleDAO.getRolesByUserId(userId);  // ← THÊM DÒng này

request.setAttribute("user", user);
request.setAttribute("roles", roles);
request.setAttribute("userRoles", userRoles);  // ← THÊM DÒNG này
request.setAttribute("isEdit", true);
```

**Chức năng:**
- `getRolesByUserId(userId)` → Lấy role hiện tại của người dùng từ DB
- Truyền `userRoles` tới JSP để `selected` role đúng

---

#### **B. createUser() - Dòng 170-218**

**Thêm xử lý Role khi tạo:**
```java
if (user != null) {
    // Lấy role từ form (nếu admin chỉ định)
    String roleStr = request.getParameter("role");
    
    if (roleStr != null && !roleStr.isEmpty()) {
        try {
            int roleId = Integer.parseInt(roleStr);
            RoleDAO roleDAO = new RoleDAO();
            roleDAO.assignRoleToUser(user.getUser_id(), roleId);
        } catch (NumberFormatException e) {
            // Nếu không hợp lệ, gán role mặc định
            userDAO.assignDefaultUserRole(user.getUser_id());
        }
    } else {
        // Nếu không chọn role, gán role mặc định (Customer)
        userDAO.assignDefaultUserRole(user.getUser_id());
    }
    
    request.getSession().setAttribute("success", "Tạo người dùng thành công");
    response.sendRedirect(request.getContextPath() + "/admin/users");
}
```

**Quy trình:**
1. Lấy `roleStr` từ form (id của role được chọn)
2. Nếu `roleStr` không trống:
   - Chuyển thành `int roleId`
   - Gọi `assignRoleToUser(userId, roleId)` → gán role
   - Nếu lỗi → gán role mặc định
3. Nếu không chọn role → gán role mặc định (Customer)

---

#### **C. updateUser() - Dòng 204-266**

**Thêm xử lý Role khi cập nhật:**
```java
private void updateUser(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    String userIdStr = request.getParameter("userId");
    String fullName = request.getParameter("fullName");
    // ... các trường khác ...
    String roleStr = request.getParameter("role");  // ← THÊM DÒNG này
    
    int userId = Integer.parseInt(userIdStr);
    UsersDAO userDAO = new UsersDAO();
    Users user = userDAO.getUserById(userId);
    
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/admin/users");
        return;
    }
    
    // Cập nhật các trường
    user.setFull_name(fullName);
    // ... các trường khác ...
    
    boolean success = userDAO.updateUser(user);
    
    // Cập nhật role nếu admin chỉ định
    if (success && roleStr != null && !roleStr.isEmpty()) {  // ← THÊM BLOCK này
        try {
            int roleId = Integer.parseInt(roleStr);
            RoleDAO roleDAO = new RoleDAO();
            
            // Xóa tất cả role cũ
            roleDAO.removeAllRolesFromUser(userId);
            
            // Gán role mới
            roleDAO.assignRoleToUser(userId, roleId);
        } catch (NumberFormatException e) {
            // Nếu role không hợp lệ, bỏ qua
        }
    }
    
    if (success) {
        request.getSession().setAttribute("success", "Cập nhật người dùng thành công");
        response.sendRedirect(request.getContextPath() + "/admin/users");
    } else {
        request.setAttribute("error", "Cập nhật người dùng thất bại");
        showEditForm(request, response);
    }
}
```

**Quy trình:**
1. Cập nhật thông tin người dùng
2. Nếu cập nhật thành công AND roleStr không trống:
   - Xóa tất cả role cũ của người dùng
   - Gán role mới từ form
3. Redirect với thông báo thành công

---

## **🔍 Các method DAO cần có**

### **RoleDAO:**

```java
// Lấy tất cả role của người dùng
public List<Roles> getRolesByUserId(int userId) {
    // SELECT r.* FROM roles r
    // JOIN user_roles ur ON r.role_id = ur.role_id
    // WHERE ur.user_id = userId
}

// Gán role cho người dùng
public void assignRoleToUser(int userId, int roleId) {
    // INSERT INTO user_roles (user_id, role_id) VALUES (userId, roleId)
}

// Xóa tất cả role của người dùng
public void removeAllRolesFromUser(int userId) {
    // DELETE FROM user_roles WHERE user_id = userId
}
```

---

## **📊 Flow Diagram**

### **Khi tạo người dùng mới:**
```
1. Admin lấy form: GET /admin/users?action=create
   → Hiển thị form trống
   → Danh sách roles: Admin, Manager, Seller, Customer

2. Admin điền form + chọn role (ví dụ: Seller)
   → Submit: POST /admin/users?action=create

3. Java xử lý:
   a) Lấy dữ liệu (name, email, phone, role)
   b) Tạo user mới trong DB
      → Trả về user.user_id = 50
   c) Lấy role từ form (role = "3" → Seller)
   d) Gán role:
      INSERT INTO user_roles (user_id, role_id) VALUES (50, 3)
   e) Redirect: /admin/users?success
   
4. JSP hiển thị: "Tạo người dùng thành công"
   → Bảng danh sách cập nhật, hiển thị: User #50 - Người bán
```

### **Khi chỉnh sửa người dùng:**
```
1. Admin nhấn nút "Sửa" trên user (ID = 50)
   → GET /admin/users?action=edit&id=50

2. Java xử lý:
   a) Lấy user từ DB (ID = 50)
   b) Lấy roles hiện tại của user:
      SELECT r.role_id FROM roles r
      JOIN user_roles ur ON r.role_id = ur.role_id
      WHERE ur.user_id = 50
      → Kết quả: role_id = 3 (Seller)
   c) Lấy tất cả roles (để hiển thị dropdown)
   d) Gửi tới JSP:
      - user = {...}
      - roles = [1=Admin, 2=Manager, 3=Seller, 4=Customer]
      - userRoles = [3] (Seller được selected)

3. JSP hiển thị form:
   - Dropdown role hiển thị "Seller" được chọn (selected)

4. Admin thay đổi role từ "Seller" thành "Admin"
   → Submit: POST /admin/users?action=update

5. Java xử lý:
   a) Cập nhật user info
   b) Xóa role cũ:
      DELETE FROM user_roles WHERE user_id = 50
   c) Gán role mới:
      INSERT INTO user_roles (user_id, role_id) VALUES (50, 1)
   d) Redirect: /admin/users?success

6. JSP hiển thị: "Cập nhật người dùng thành công"
   → Bảng danh sách cập nhật, hiển thị: User #50 - Quản trị viên
```

---

## **⚙️ Cách sử dụng**

### **1. Tạo người dùng mới với role Seller:**
- Vào `/admin/users`
- Nhấn "Thêm người dùng"
- Điền form (tên, email, mật khẩu, số điện thoại)
- **Chọn vai trò: "Seller"** (dropdown)
- Nhấn "Tạo mới"
- ✓ Người dùng được tạo với role Seller

### **2. Thay đổi role của người dùng:**
- Vào `/admin/users`
- Nhấn nút "Sửa" (biểu tượng bút)
- Đổi "Vai trò" từ "Customer" → "Admin"
- Nhấn "Cập nhật"
- ✓ Role được cập nhật, danh sách hiển thị role mới

### **3. Lọc theo role:**
- Vào `/admin/users`
- Chọn "Vai trò" = "Seller"
- Nhấn "Tìm kiếm"
- ✓ Chỉ hiển thị những người dùng có role Seller

---

## **🎨 Màu sắc Role**

| Role | Màu | Hex Code | Mô tả |
|------|-----|----------|-------|
| **Admin** | Đỏ | #dc3545 | Quản trị viên toàn hệ thống |
| **Manager** | Cam | #fd7e14 | Quản lý hệ thống |
| **Seller** | Xanh nhạt | #0dcaf0 | Người bán sản phẩm |
| **Customer** | Xanh lá | (success) | Khách hàng bình thường |

---

## **✅ Checklist kiểm tra**

- [ ] Cập nhật `user-form.jsp` - thêm dropdown role
- [ ] Cập nhật `users-list.jsp` - thêm cột vai trò, hiển thị màu
- [ ] Cập nhật `AdminUserController.java`:
  - [ ] `showEditForm()` - thêm `getRolesByUserId()`
  - [ ] `createUser()` - thêm xử lý role
  - [ ] `updateUser()` - thêm xử lý role
- [ ] Kiểm tra RoleDAO có methods:
  - [ ] `getRolesByUserId(int userId)`
  - [ ] `assignRoleToUser(int userId, int roleId)`
  - [ ] `removeAllRolesFromUser(int userId)`
- [ ] Test tạo user với role khác nhau
- [ ] Test thay đổi role
- [ ] Test lọc theo role

---

## **🐛 Troubleshooting**

**Vấn đề 1:** Dropdown role không hiển thị
- **Giải pháp:** Kiểm tra `roles` được gửi từ Controller
  ```java
  request.setAttribute("roles", roles);  // Phải có
  ```

**Vấn đề 2:** Role không được chọn/selected trong form chỉnh sửa
- **Giải pháp:** Kiểm tra `userRoles` có được gửi không
  ```java
  request.setAttribute("userRoles", userRoles);  // Phải có
  ```

**Vấn đề 3:** Cột "Vai trò" không hiển thị trong danh sách
- **Giải pháp:** Kiểm tra `default_role` trong database
  ```sql
  SELECT default_role FROM users;
  ```

**Vấn đề 4:** Role không cập nhật khi save
- **Giải pháp:** Kiểm tra RoleDAO methods có tồn tại:
  - `assignRoleToUser()`
  - `removeAllRolesFromUser()`

---

Bạn đã hoàn tất việc thêm quản lý role! 🎉
