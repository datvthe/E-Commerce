# 📊 HƯỚNG DẪN LÀM USE CASE DIAGRAM - HỆ THỐNG E-COMMERCE WEBGMS

## 1. PHÂN TÍCH CÁC ACTOR

### 1.1. Danh Sách Actors

Dựa vào code của bạn, hệ thống có **5 actors chính**:

```
┌─────────────────────────────────────────────────────────┐
│  ACTORS TRONG HỆ THỐNG                                  │
├─────────────────────────────────────────────────────────┤
│  1. Guest (Khách vãng lai)          - Chưa đăng nhập    │
│  2. Customer (Khách hàng)           - Role ID: 3        │
│  3. Seller (Người bán)              - Role ID: 2        │
│  4. Admin (Quản trị viên)           - Role ID: 1        │
│  5. Moderator (Người kiểm duyệt)    - Role ID: 4        │
└─────────────────────────────────────────────────────────┘
```

---

## 2. USE CASES CHO TỪNG ACTOR

### 2.1. 👤 GUEST (Khách vãng lai)

**Đặc điểm**: Chưa đăng nhập, chỉ xem thông tin cơ bản

**Use Cases**:
```
UC-G001: Xem danh sách sản phẩm
UC-G002: Tìm kiếm sản phẩm
UC-G003: Xem chi tiết sản phẩm
UC-G004: Xem danh mục sản phẩm
UC-G005: Đăng ký tài khoản
UC-G006: Đăng nhập
UC-G007: Quên mật khẩu
UC-G008: Xem thông tin về website
```

**Mô tả chi tiết**:

#### UC-G001: Xem danh sách sản phẩm
- **Actor**: Guest
- **Precondition**: Truy cập website
- **Main Flow**: 
  1. Guest truy cập trang chủ
  2. Hệ thống hiển thị danh sách sản phẩm
  3. Guest có thể lọc theo danh mục, giá, ...
- **Postcondition**: Danh sách sản phẩm được hiển thị

#### UC-G005: Đăng ký tài khoản
- **Actor**: Guest
- **Precondition**: Chưa có tài khoản
- **Main Flow**:
  1. Guest click "Đăng ký"
  2. Điền form: email, password, full name, phone
  3. Submit form
  4. Hệ thống validate và tạo tài khoản
  5. Chuyển sang Customer
- **Postcondition**: Tài khoản Customer được tạo

---

### 2.2. 🛒 CUSTOMER (Khách hàng)

**Đặc điểm**: Đã đăng nhập, có thể mua sắm

**Kế thừa từ Guest**: Tất cả use cases của Guest + Thêm:

**Use Cases riêng**:
```
UC-C001: Quản lý tài khoản cá nhân
UC-C002: Thêm sản phẩm vào giỏ hàng
UC-C003: Xem giỏ hàng
UC-C004: Đặt hàng
UC-C005: Thanh toán
UC-C006: Xem lịch sử đơn hàng
UC-C007: Theo dõi đơn hàng
UC-C008: Hủy đơn hàng
UC-C009: Đánh giá sản phẩm
UC-C010: Thêm vào wishlist
UC-C011: Xem wishlist
UC-C012: Chat với seller
UC-C013: Xem thông báo
UC-C014: Đổi mật khẩu
UC-C015: Cập nhật thông tin cá nhân
```

**Mô tả chi tiết một số UC quan trọng**:

#### UC-C002: Thêm sản phẩm vào giỏ hàng
- **Actor**: Customer
- **Precondition**: Đã đăng nhập, sản phẩm còn hàng
- **Main Flow**:
  1. Customer xem chi tiết sản phẩm
  2. Chọn số lượng
  3. Click "Thêm vào giỏ"
  4. Hệ thống thêm vào giỏ hàng
  5. Hiển thị thông báo thành công
- **Alternative Flow**: Hết hàng → Hiển thị "Sold out"
- **Postcondition**: Sản phẩm có trong giỏ hàng

#### UC-C004: Đặt hàng
- **Actor**: Customer
- **Precondition**: Có sản phẩm trong giỏ hàng
- **Main Flow**:
  1. Customer vào giỏ hàng
  2. Kiểm tra sản phẩm
  3. Nhập địa chỉ giao hàng
  4. Chọn phương thức thanh toán
  5. Xác nhận đặt hàng
  6. Hệ thống tạo đơn hàng
  7. Gửi email xác nhận
- **Postcondition**: Đơn hàng được tạo với status "pending"

#### UC-C009: Đánh giá sản phẩm
- **Actor**: Customer
- **Precondition**: Đã mua sản phẩm, đơn hàng "completed"
- **Main Flow**:
  1. Customer vào lịch sử đơn hàng
  2. Chọn sản phẩm đã mua
  3. Click "Đánh giá"
  4. Nhập rating (1-5 sao) và comment
  5. Submit
  6. Hệ thống lưu review
- **Postcondition**: Review được hiển thị trên sản phẩm

---

### 2.3. 🏪 SELLER (Người bán)

**Đặc điểm**: Có thể bán hàng, quản lý shop

**Kế thừa từ Customer**: Có thể mua hàng như Customer + Thêm:

**Use Cases riêng**:
```
UC-S001: Đăng ký làm seller
UC-S002: Quản lý thông tin shop
UC-S003: Thêm sản phẩm mới
UC-S004: Sửa thông tin sản phẩm
UC-S005: Xóa sản phẩm
UC-S006: Quản lý kho hàng (inventory)
UC-S007: Xem danh sách đơn hàng
UC-S008: Xác nhận đơn hàng
UC-S009: Cập nhật trạng thái đơn hàng
UC-S010: Hủy đơn hàng
UC-S011: Xem doanh thu
UC-S012: Xem thống kê bán hàng
UC-S013: Rút tiền về tài khoản
UC-S014: Trả lời đánh giá khách hàng
UC-S015: Chat với khách hàng
UC-S016: Xem thông báo
UC-S017: Quản lý khuyến mãi
UC-S018: Yêu cầu đóng shop
```

**Mô tả chi tiết một số UC quan trọng**:

#### UC-S001: Đăng ký làm seller
- **Actor**: Customer
- **Precondition**: Đã có tài khoản Customer
- **Main Flow**:
  1. Customer vào trang đăng ký seller
  2. Điền form:
     - Thông tin shop: tên, mô tả, danh mục
     - Thông tin ngân hàng
     - Số tiền cọc
  3. Submit form
  4. Hệ thống validate
  5. Tạo seller record với status "pending"
  6. Admin duyệt
  7. Status → "active"
- **Postcondition**: Seller được tạo, có thể bán hàng

#### UC-S003: Thêm sản phẩm mới
- **Actor**: Seller
- **Precondition**: Seller status = "active"
- **Main Flow**:
  1. Seller vào "Quản lý sản phẩm"
  2. Click "Thêm sản phẩm mới"
  3. Điền thông tin:
     - Tên, mô tả, giá, số lượng
     - Danh mục, thương hiệu
     - Upload ảnh
  4. Submit
  5. Hệ thống lưu sản phẩm
  6. Sản phẩm hiển thị trên shop
- **Postcondition**: Sản phẩm mới được tạo

#### UC-S008: Xác nhận đơn hàng
- **Actor**: Seller
- **Precondition**: Có đơn hàng mới (status = "pending")
- **Main Flow**:
  1. Seller xem danh sách đơn hàng
  2. Chọn đơn hàng cần xác nhận
  3. Kiểm tra thông tin
  4. Click "Xác nhận"
  5. Hệ thống cập nhật status → "confirmed"
  6. Gửi thông báo cho customer
- **Alternative Flow**: Hết hàng → Hủy đơn
- **Postcondition**: Đơn hàng được xác nhận

#### UC-S013: Rút tiền về tài khoản
- **Actor**: Seller
- **Precondition**: Có số dư trong ví
- **Main Flow**:
  1. Seller vào "Ví của tôi"
  2. Click "Rút tiền"
  3. Nhập số tiền cần rút
  4. Xác nhận thông tin ngân hàng
  5. Submit yêu cầu
  6. Admin duyệt
  7. Chuyển tiền
- **Postcondition**: Yêu cầu rút tiền được tạo

---

### 2.4. 👨‍💼 ADMIN (Quản trị viên)

**Đặc điểm**: Có toàn quyền quản lý hệ thống

**Use Cases**:
```
UC-A001: Quản lý người dùng
UC-A002: Duyệt đăng ký seller
UC-A003: Khóa/Mở khóa tài khoản
UC-A004: Quản lý danh mục sản phẩm
UC-A005: Quản lý tất cả sản phẩm
UC-A006: Xóa sản phẩm vi phạm
UC-A007: Quản lý tất cả đơn hàng
UC-A008: Xem thống kê tổng quan
UC-A009: Xem doanh thu toàn hệ thống
UC-A010: Quản lý thanh toán
UC-A011: Duyệt yêu cầu rút tiền
UC-A012: Quản lý khuyến mãi hệ thống
UC-A013: Quản lý banner/quảng cáo
UC-A014: Xem báo cáo
UC-A015: Duyệt yêu cầu đóng shop
UC-A016: Quản lý hoa hồng
UC-A017: Cấu hình hệ thống
UC-A018: Xem log hệ thống
UC-A019: Backup dữ liệu
```

**Mô tả chi tiết một số UC quan trọng**:

#### UC-A002: Duyệt đăng ký seller
- **Actor**: Admin
- **Precondition**: Có seller đăng ký (status = "pending")
- **Main Flow**:
  1. Admin xem danh sách seller chờ duyệt
  2. Chọn seller cần duyệt
  3. Xem thông tin chi tiết
  4. Kiểm tra:
     - Thông tin shop
     - Thông tin ngân hàng
     - Số tiền cọc
  5. Quyết định: Duyệt hoặc Từ chối
  6. Nếu duyệt: status → "active"
  7. Nếu từ chối: Ghi lý do
  8. Gửi thông báo cho seller
- **Postcondition**: Seller được duyệt hoặc từ chối

#### UC-A011: Duyệt yêu cầu rút tiền
- **Actor**: Admin
- **Precondition**: Có yêu cầu rút tiền (status = "pending")
- **Main Flow**:
  1. Admin xem danh sách yêu cầu rút tiền
  2. Chọn yêu cầu cần xử lý
  3. Kiểm tra:
     - Số dư ví seller
     - Thông tin ngân hàng
     - Số tiền yêu cầu
  4. Xác nhận chuyển tiền
  5. Cập nhật status → "completed"
  6. Trừ tiền trong ví seller
  7. Ghi log transaction
  8. Gửi thông báo
- **Postcondition**: Tiền được chuyển, yêu cầu hoàn tất

---

### 2.5. 🛡️ MODERATOR (Người kiểm duyệt)

**Đặc điểm**: Kiểm duyệt nội dung, xử lý report

**Use Cases**:
```
UC-M001: Kiểm duyệt sản phẩm mới
UC-M002: Xem danh sách báo cáo
UC-M003: Xử lý báo cáo vi phạm
UC-M004: Xóa sản phẩm vi phạm
UC-M005: Cảnh cáo seller
UC-M006: Kiểm duyệt đánh giá
UC-M007: Xóa đánh giá không phù hợp
UC-M008: Xem log hoạt động người dùng
UC-M009: Khóa tạm thời tài khoản vi phạm
```

---

## 3. USE CASE DIAGRAM - CÁCH VẼ

### 3.1. Công cụ vẽ

Có thể dùng:
- **Draw.io** (free, online)
- **Lucidchart** (online)
- **Visual Paradigm** (desktop)
- **PlantUML** (text-based)
- **StarUML** (desktop)

### 3.2. Ký hiệu cơ bản

```
┌─────────────────────────────────────────────────┐
│  KÝ HIỆU USE CASE DIAGRAM                       │
├─────────────────────────────────────────────────┤
│  👤 Actor        = Stick figure (người que)     │
│  ⭕ Use Case     = Oval (hình bầu dục)          │
│  ─────          = Association (đường liên kết)  │
│  <<include>>    = Include (bắt buộc thực hiện)  │
│  <<extend>>     = Extend (tùy chọn mở rộng)     │
│  ─────▷         = Generalization (kế thừa)      │
│  ┌──────┐       = System boundary (ranh giới)   │
└─────────────────────────────────────────────────┘
```

### 3.3. Mẫu Use Case Diagram cho GUEST

```
                     ┌────────────────────────────────────┐
                     │   E-Commerce System (WEBGMS)       │
                     │                                    │
                     │   ⭕ Xem danh sách sản phẩm        │
                     │                                    │
    👤 Guest ────────┼──⭕ Tìm kiếm sản phẩm              │
                     │                                    │
                     │   ⭕ Xem chi tiết sản phẩm         │
                     │                                    │
                     │   ⭕ Đăng ký tài khoản              │
                     │                                    │
                     │   ⭕ Đăng nhập                      │
                     │                                    │
                     └────────────────────────────────────┘
```

### 3.4. Mẫu Use Case Diagram cho CUSTOMER

```
                     ┌────────────────────────────────────┐
                     │   E-Commerce System                │
                     │                                    │
                     │   ⭕ Thêm vào giỏ hàng             │
                     │        │                           │
                     │        │ <<include>>               │
    Guest            │        ▼                           │
      △              │   ⭕ Xem chi tiết sản phẩm         │
      │              │                                    │
      │              │   ⭕ Đặt hàng ──────────────┐      │
  👤 Customer ───────┼──⭕ Thanh toán              │      │
                     │        │                   │      │
                     │        │ <<include>>       │      │
                     │        ▼                   │      │
                     │   ⭕ Chọn địa chỉ          │      │
                     │                            │      │
                     │   ⭕ Đánh giá sản phẩm ◄───┘      │
                     │                                    │
                     └────────────────────────────────────┘
```

### 3.5. Mẫu Use Case Diagram cho SELLER

```
                     ┌────────────────────────────────────┐
                     │   Seller Management System         │
                     │                                    │
                     │   ⭕ Đăng ký làm seller             │
                     │                                    │
                     │   ⭕ Thêm sản phẩm mới              │
                     │        │                           │
                     │        │ <<include>>               │
    Customer         │        ▼                           │
      △              │   ⭕ Upload ảnh sản phẩm           │
      │              │                                    │
  👤 Seller ─────────┼──⭕ Xác nhận đơn hàng              │
                     │                                    │
                     │   ⭕ Cập nhật trạng thái đơn hàng  │
                     │                                    │
                     │   ⭕ Rút tiền ──────────────┐      │
                     │                            │      │
                     │                            │      │
                     │   ⭕ Xem thống kê  ◄────────┘      │
                     │                                    │
                     └────────────────────────────────────┘
```

---

## 4. QUAN HỆ GIỮA CÁC ACTOR

### 4.1. Generalization (Kế thừa)

```
        Guest
          △
          │
          │ (kế thừa)
          │
      Customer
          △
          │
          │ (kế thừa)
          │
       Seller


      Admin ◄─────── Moderator (có một số quyền admin)
```

### 4.2. Giải thích

- **Customer** kế thừa tất cả use cases của **Guest**
- **Seller** kế thừa tất cả use cases của **Customer** (seller vẫn có thể mua hàng)
- **Admin** có tất cả quyền
- **Moderator** có một số quyền của Admin (kiểm duyệt, xử lý report)

---

## 5. QUAN HỆ GIỮA CÁC USE CASE

### 5.1. Include (Bao gồm - Bắt buộc)

Dùng khi một use case **BẮT BUỘC** phải thực hiện use case khác

**Ví dụ**:
```
⭕ Đặt hàng ──<<include>>──> ⭕ Đăng nhập
⭕ Thanh toán ──<<include>>──> ⭕ Xác nhận đơn hàng
⭕ Thêm sản phẩm ──<<include>>──> ⭕ Upload ảnh
```

### 5.2. Extend (Mở rộng - Tùy chọn)

Dùng khi một use case có thể **TÙY CHỌN** mở rộng thêm

**Ví dụ**:
```
⭕ Đặt hàng ◄──<<extend>>── ⭕ Áp dụng mã giảm giá
⭕ Xem sản phẩm ◄──<<extend>>── ⭕ Thêm vào wishlist
⭕ Thanh toán ◄──<<extend>>── ⭕ Sử dụng ví điện tử
```

---

## 6. TEMPLATE MÔ TẢ CHI TIẾT USE CASE

Cho mỗi use case quan trọng, nên viết mô tả chi tiết:

```markdown
### UC-XXX: [Tên Use Case]

**ID**: UC-XXX
**Name**: [Tên đầy đủ]
**Actor**: [Actor chính]
**Description**: [Mô tả ngắn gọn]

**Preconditions**:
- Điều kiện 1
- Điều kiện 2

**Main Flow**:
1. Actor làm gì
2. Hệ thống phản hồi
3. ...
4. Use case kết thúc

**Alternative Flows**:
- **Alt 1**: Nếu X xảy ra
  1. Step 1
  2. Step 2
  
- **Alt 2**: Nếu Y xảy ra
  1. Step 1
  2. Step 2

**Exception Flows**:
- **Exc 1**: Lỗi Z
  1. Hiển thị thông báo lỗi
  2. Quay về bước N

**Postconditions**:
- Kết quả sau khi use case thành công

**Special Requirements**:
- Yêu cầu đặc biệt (performance, security, ...)

**Notes**:
- Ghi chú thêm
```

---

## 7. HƯỚNG DẪN VẼ TỪNG BƯỚC

### Bước 1: Xác định actors

Liệt kê tất cả các loại người dùng/hệ thống tương tác

### Bước 2: Xác định use cases chính

Cho mỗi actor, liệt kê các chức năng chính họ thực hiện

### Bước 3: Vẽ system boundary

Vẽ hình chữ nhật bao quanh tất cả use cases

### Bước 4: Đặt actors bên ngoài boundary

Actors ở bên ngoài, kết nối với use cases bên trong

### Bước 5: Vẽ các use cases

Mỗi use case là một oval với tên bên trong

### Bước 6: Kết nối actors với use cases

Dùng đường thẳng nối actor với use case

### Bước 7: Thêm quan hệ include/extend

Nếu có use case phụ thuộc nhau

### Bước 8: Thêm generalization

Nếu có actors kế thừa nhau

---

## 8. LƯU Ý KHI VẼ

✅ **NÊN**:
- Đặt tên use case bắt đầu bằng động từ
- Ngắn gọn, súc tích (3-5 từ)
- Mô tả chức năng, không mô tả cách làm
- Nhóm use cases liên quan gần nhau
- Actors bên trái hoặc phải boundary

❌ **KHÔNG NÊN**:
- Use case quá chung chung (VD: "Quản lý hệ thống")
- Use case quá chi tiết (VD: "Click button submit")
- Vẽ quá nhiều quan hệ phức tạp
- Actors bên trong boundary
- Include/Extend lạm dụng quá nhiều

---

## 9. MẪU USE CASE DIAGRAM TỔNG QUAN HỆ THỐNG

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    E-COMMERCE SYSTEM (WEBGMS)                               │
│                                                                             │
│  Guest                           Customer                    Seller        │
│  👤 ────→ Xem sản phẩm           👤 ────→ Mua hàng          👤 ────→ Bán  │
│    │                               △                         △             │
│    │                               │                         │             │
│    └───→ Đăng ký ─────────────────┘                         │             │
│                                    │                         │             │
│                                    └─ Đăng ký seller ────────┘             │
│                                                                             │
│                                                                             │
│  Admin                          Moderator                                  │
│  👤 ────→ Quản lý toàn bộ       👤 ────→ Kiểm duyệt                       │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 10. CHECKLIST HOÀN THÀNH

- [ ] Đã xác định đầy đủ actors
- [ ] Đã liệt kê use cases cho từng actor
- [ ] Đã vẽ use case diagram tổng quan
- [ ] Đã vẽ diagram chi tiết cho từng actor
- [ ] Đã mô tả chi tiết các use case quan trọng
- [ ] Đã xác định quan hệ include/extend
- [ ] Đã xác định quan hệ kế thừa giữa actors
- [ ] Đã review và chỉnh sửa

---

**Tạo bởi**: AI Assistant  
**Ngày**: 2025-10-29  
**Hệ thống**: E-Commerce WEBGMS



