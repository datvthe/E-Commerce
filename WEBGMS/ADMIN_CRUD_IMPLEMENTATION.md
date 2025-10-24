# Admin CRUD Implementation - Users & Categories

## Tổng quan
Đã triển khai đầy đủ chức năng CRUD (Create, Read, Update, Delete) cho quản lý người dùng và danh mục sản phẩm trong trang admin với giao diện đồng bộ với dashboard hiện có.

## Các tính năng đã triển khai

### 1. Quản lý người dùng (User Management)
**URL:** `/admin/users`

#### Chức năng:
- ✅ **Danh sách người dùng** với phân trang (10 items/trang)
- ✅ **Tìm kiếm** theo tên, email, số điện thoại
- ✅ **Lọc** theo trạng thái (active, inactive, banned) và vai trò (Admin, Manager, Seller, Customer)
- ✅ **Thêm người dùng mới** với validation email và số điện thoại
- ✅ **Chỉnh sửa thông tin** người dùng
- ✅ **Xóa người dùng** (soft delete - đánh dấu deleted_at)
- ✅ **Cập nhật trạng thái** người dùng

#### Files đã tạo:
- `src/java/controller/admin/AdminUserController.java` - Controller xử lý logic
- `web/views/admin/users-list.jsp` - Trang danh sách người dùng
- `web/views/admin/user-form.jsp` - Form thêm/sửa người dùng
- `src/java/dao/UsersDAO.java` - Đã bổ sung các method:
  - `getAllUsers(page, pageSize)` - Lấy danh sách có phân trang
  - `searchUsers(keyword, status, role, page, pageSize)` - Tìm kiếm và lọc
  - `countUsers(keyword, status, role)` - Đếm số lượng
  - `deleteUser(userId)` - Xóa người dùng
  - `updateUserStatus(userId, status)` - Cập nhật trạng thái

### 2. Quản lý danh mục (Category Management)
**URL:** `/admin/categories`

#### Chức năng:
- ✅ **Danh sách danh mục** với phân trang (10 items/trang)
- ✅ **Tìm kiếm** theo tên và mô tả
- ✅ **Lọc** theo trạng thái (active, inactive)
- ✅ **Thêm danh mục mới** với auto-generate slug từ tên
- ✅ **Chỉnh sửa danh mục**
- ✅ **Xóa danh mục** (hard delete)
- ✅ **Validation** tên danh mục không trùng lặp

#### Files đã tạo:
- `src/java/dao/CategoryDAO.java` - DAO mới với đầy đủ CRUD operations
- `src/java/controller/admin/AdminCategoryController.java` - Controller xử lý logic
- `web/views/admin/categories-list.jsp` - Trang danh sách danh mục
- `web/views/admin/category-form.jsp` - Form thêm/sửa danh mục

### 3. Giao diện Admin
- ✅ **Sidebar đã được cập nhật** với menu "Quản lý Admin" chứa:
  - Người dùng
  - Danh mục
- ✅ **Giao diện đồng bộ** với admin dashboard hiện có (PlainAdmin template)
- ✅ **Responsive design** tương thích mobile
- ✅ **Alert messages** cho thành công/lỗi
- ✅ **Pagination** với điều hướng trang
- ✅ **Status badges** với màu sắc phân biệt

## Cấu trúc Database

### Users Table
```sql
- user_id (PK)
- full_name
- email
- password_hash
- phone_number
- gender
- date_of_birth
- address
- avatar_url
- status (active, inactive, banned)
- email_verified
- default_role
- created_at
- updated_at
- deleted_at
```

### Product_Categories Table
```sql
- category_id (PK)
- parent_id (FK, nullable)
- name
- slug
- description
- status (active, inactive)
- created_at
- updated_at
```

## Các tính năng kỹ thuật

### Pagination
- Mỗi trang hiển thị 10 items
- Có nút Previous/Next và số trang
- Giữ nguyên filter khi chuyển trang

### Search & Filter
- Tìm kiếm real-time với LIKE query
- Filter kết hợp nhiều điều kiện
- Giữ nguyên giá trị search/filter sau khi submit

### Validation
- Email và số điện thoại không trùng lặp (Users)
- Tên danh mục không trùng lặp (Categories)
- Required fields validation
- Password minimum 6 characters

### Security
- Soft delete cho users (không xóa vĩnh viễn)
- Password hashing với PasswordUtil
- SQL injection prevention với PreparedStatement

## Cách sử dụng

### Truy cập trang quản lý:
1. **Người dùng:** `http://localhost:8080/WEBGMS/admin/users`
2. **Danh mục:** `http://localhost:8080/WEBGMS/admin/categories`

### Quyền truy cập:
- Chỉ admin có quyền truy cập các trang này
- Cần implement RoleBasedAccessFilter nếu chưa có

## Testing Checklist

### User Management
- [ ] Xem danh sách người dùng
- [ ] Tìm kiếm người dùng theo tên/email/SĐT
- [ ] Lọc theo trạng thái và vai trò
- [ ] Thêm người dùng mới
- [ ] Chỉnh sửa thông tin người dùng
- [ ] Xóa người dùng
- [ ] Phân trang hoạt động đúng

### Category Management
- [ ] Xem danh sách danh mục
- [ ] Tìm kiếm danh mục
- [ ] Lọc theo trạng thái
- [ ] Thêm danh mục mới (slug tự động)
- [ ] Chỉnh sửa danh mục
- [ ] Xóa danh mục
- [ ] Phân trang hoạt động đúng

## Notes
- Giao diện sử dụng PlainAdmin template với Bootstrap 5
- Icons sử dụng LineIcons
- Tất cả text đã được Việt hóa
- Form có validation phía client và server
- Có thông báo success/error sau mỗi thao tác
