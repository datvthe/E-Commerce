# 📚 HƯỚNG DẪN CẬP NHẬT INVENTORY TỪ DIGITAL_GOODS_CODES

## 🎯 MỤC ĐÍCH
Đồng bộ số lượng sản phẩm digital từ bảng `digital_goods_codes` vào bảng `inventory` để:
- Tối ưu hiển thị số lượng trên UI (không cần COUNT mỗi lần)
- Quản lý inventory tập trung
- Hỗ trợ báo cáo và thống kê

---

## 🔧 CÀI ĐẶT BAN ĐẦU

### Bước 1: Chạy SQL Setup
```bash
# Mở MySQL Workbench hoặc command line
mysql -u root -p gicungco < sync-inventory-setup.sql
```

Hoặc copy/paste từ file `sync-inventory-setup.sql` vào MySQL Workbench.

**Điều này sẽ:**
- ✅ Tạo UNIQUE constraint cho `inventory.product_id`
- ✅ Tạo VIEW để kiểm tra sync status
- ✅ (Optional) Tạo TRIGGER tự động sync

### Bước 2: Build lại project
```bash
# Trong NetBeans
Clean and Build Project (Shift + F11)
```

---

## 🚀 CÁCH CẬP NHẬT INVENTORY

### 📌 **CÁCH 1: Qua Web Browser (Khuyến nghị cho lần đầu)**

1. Start Tomcat server
2. Mở browser:
   ```
   http://localhost:8080/WEBGMS/admin/sync-inventory
   ```
3. Xem kết quả trên màn hình

**Khi nào dùng:**
- Lần đầu setup
- Sync toàn bộ sau khi import codes mới
- Troubleshooting

---

### 📌 **CÁCH 2: Gọi từ Java Code**

#### A. Sync tất cả products
```java
// Trong bất kỳ servlet/controller nào
InventoryDAO inventoryDAO = new InventoryDAO();
inventoryDAO.syncInventoryFromDigitalCodes();
```

#### B. Sync 1 product cụ thể
```java
// Sau khi seller thêm codes mới cho product
InventoryDAO inventoryDAO = new InventoryDAO();
inventoryDAO.syncInventoryForProduct(productId);
```

**Ví dụ: Trong AddDigitalCodesController**
```java
@WebServlet("/seller/add-codes")
public class AddDigitalCodesController extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
        // ... code thêm codes vào digital_goods_codes ...
        
        long productId = Long.parseLong(request.getParameter("productId"));
        
        // Sync inventory ngay sau khi thêm
        InventoryDAO inventoryDAO = new InventoryDAO();
        inventoryDAO.syncInventoryForProduct(productId);
        
        response.sendRedirect("success.jsp");
    }
}
```

**Khi nào dùng:**
- Sau khi seller thêm codes mới
- Ngay sau khi order (cập nhật is_used = 1)
- Trong background job

---

### 📌 **CÁCH 3: Tự động với Database TRIGGER**

Nếu bạn đã chạy TRIGGER trong `sync-inventory-setup.sql`:

```sql
-- Inventory sẽ TỰ ĐỘNG update khi:
-- 1. INSERT code mới vào digital_goods_codes
INSERT INTO digital_goods_codes (...) VALUES (...);
-- → Inventory tự động +1

-- 2. UPDATE is_used = 1 (bán hàng)
UPDATE digital_goods_codes SET is_used = 1 WHERE code_id = ?;
-- → Inventory tự động -1
```

**Ưu điểm:**
- ✅ Luôn đồng bộ real-time
- ✅ Không cần gọi code

**Nhược điểm:**
- ❌ Logic ở DB, khó debug
- ❌ Có thể ảnh hưởng performance

**Xóa trigger nếu không muốn dùng:**
```sql
DROP TRIGGER IF EXISTS after_digital_code_update;
DROP TRIGGER IF EXISTS after_digital_code_insert;
```

---

### 📌 **CÁCH 4: Background Job (Khuyến nghị cho Production)**

Tạo scheduled task chạy mỗi 5-10 phút:

#### A. Dùng Java Timer (đơn giản)

**Tạo `InventorySyncScheduler.java`:**
```java
package service;

import dao.InventoryDAO;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.Timer;
import java.util.TimerTask;

@WebListener
public class InventorySyncScheduler implements ServletContextListener {
    
    private Timer timer;
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        timer = new Timer(true); // Daemon thread
        
        // Chạy mỗi 5 phút (300,000 ms)
        timer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                System.out.println("🔄 Auto-syncing inventory...");
                InventoryDAO dao = new InventoryDAO();
                dao.syncInventoryFromDigitalCodes();
            }
        }, 60000, 300000); // Delay 1 phút, lặp lại mỗi 5 phút
        
        System.out.println("✅ Inventory sync scheduler started");
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (timer != null) {
            timer.cancel();
            System.out.println("🛑 Inventory sync scheduler stopped");
        }
    }
}
```

#### B. Dùng Quartz Scheduler (nâng cao)

1. Thêm dependency vào `pom.xml`:
```xml
<dependency>
    <groupId>org.quartz-scheduler</groupId>
    <artifactId>quartz</artifactId>
    <version>2.3.2</version>
</dependency>
```

2. Tạo Job:
```java
public class InventorySyncJob implements Job {
    @Override
    public void execute(JobExecutionContext context) {
        InventoryDAO dao = new InventoryDAO();
        dao.syncInventoryFromDigitalCodes();
    }
}
```

3. Schedule Job (trong Listener):
```java
JobDetail job = JobBuilder.newJob(InventorySyncJob.class).build();
Trigger trigger = TriggerBuilder.newTrigger()
    .withSchedule(SimpleScheduleBuilder.repeatMinutelyForever(5))
    .build();
scheduler.scheduleJob(job, trigger);
```

---

## 📊 KIỂM TRA SYNC STATUS

### Cách 1: Qua SQL
```sql
-- Xem tổng quan
SELECT * FROM v_inventory_sync_check;

-- Chi tiết 1 product
SELECT 
    i.product_id,
    p.name,
    i.quantity as inventory_qty,
    (SELECT COUNT(*) FROM digital_goods_codes 
     WHERE product_id = 1 AND is_used = 0) as actual_qty
FROM inventory i
JOIN products p ON i.product_id = p.product_id
WHERE i.product_id = 1;
```

### Cách 2: Qua Java Console
```java
// Code đã có sẵn log trong DAO
// Xem console khi chạy:
// ✓ Product 1: 5 codes
// ✓ Product 2: 3 codes
// ✅ Sync completed: 8 products synced, 0 failed
```

---

## 🔄 KHI NÀO CẦN SYNC?

| Sự kiện | Cách sync | Ưu tiên |
|---------|-----------|---------|
| **Lần đầu setup** | Cách 1 (Browser) | ⭐⭐⭐ |
| **Seller thêm codes** | Cách 2B (syncInventoryForProduct) | ⭐⭐⭐ |
| **User mua hàng** | Cách 2B hoặc Trigger | ⭐⭐ |
| **Import bulk codes** | Cách 1 hoặc 2A | ⭐⭐⭐ |
| **Maintenance định kỳ** | Cách 4 (Background) | ⭐⭐⭐ |

---

## 🐛 TROUBLESHOOTING

### Lỗi: "Duplicate entry for key 'PRIMARY'"
**Nguyên nhân:** Inventory đã có record cho product_id

**Giải pháp:**
```sql
-- Xóa inventory cũ và sync lại
TRUNCATE TABLE inventory;
```
Sau đó chạy sync lại.

---

### Lỗi: "ON DUPLICATE KEY UPDATE" không hoạt động
**Nguyên nhân:** Chưa có UNIQUE constraint

**Giải pháp:**
```sql
ALTER TABLE inventory ADD UNIQUE (product_id);
```

---

### Số lượng không khớp
**Kiểm tra:**
```sql
-- So sánh
SELECT * FROM v_inventory_sync_check WHERE sync_status LIKE '%OUT OF SYNC%';
```

**Sync lại:**
```java
inventoryDAO.syncInventoryFromDigitalCodes();
```

---

## ✅ CHECKLIST HOÀN THÀNH

- [ ] Đã chạy `sync-inventory-setup.sql`
- [ ] Đã build lại project
- [ ] Đã test sync qua browser: `/admin/sync-inventory`
- [ ] Đã kiểm tra kết quả bằng SQL: `SELECT * FROM v_inventory_sync_check`
- [ ] (Optional) Đã setup background job
- [ ] (Optional) Đã tạo trigger tự động

---

## 📞 HỖ TRỢ

Nếu gặp lỗi, kiểm tra:
1. Console log trong NetBeans
2. MySQL error log
3. View `v_inventory_sync_check`

**File liên quan:**
- `DigitalGoodsCodeDAO.java`
- `InventoryDAO.java`
- `SyncInventoryController.java`
- `ProductDetailController.java`
- `sync-inventory-setup.sql`

---

**Chúc bạn sync thành công! 🚀**

