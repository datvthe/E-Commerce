# 📝 BLOG SYSTEM - THIẾT KẾ CHI TIẾT

## 🎯 MỤC TIÊU
Xây dựng hệ thống blog với workflow phê duyệt (moderation) cho phép:
- Customer/Seller có thể tạo, sửa, xóa blog
- Admin phê duyệt/từ chối blog
- Hiển thị blog mới nhất trên trang chủ
- Trang blog riêng biệt để quản lý và xem blog

---

## 📊 DATABASE SCHEMA

### 1. Bảng `blogs`
```sql
CREATE TABLE blogs (
  blog_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  title VARCHAR(255) NOT NULL,
  slug VARCHAR(255) UNIQUE NOT NULL,
  summary TEXT,
  content LONGTEXT NOT NULL,
  featured_image VARCHAR(500),
  
  -- Moderation fields
  status ENUM('DRAFT', 'PENDING', 'APPROVED', 'REJECTED') DEFAULT 'DRAFT',
  moderator_id INT,
  moderation_note TEXT,
  moderated_at TIMESTAMP NULL,
  
  -- SEO fields
  meta_title VARCHAR(255),
  meta_description TEXT,
  meta_keywords VARCHAR(500),
  
  -- Stats
  view_count INT DEFAULT 0,
  like_count INT DEFAULT 0,
  comment_count INT DEFAULT 0,
  
  -- Timestamps
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  published_at TIMESTAMP NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (moderator_id) REFERENCES users(user_id) ON DELETE SET NULL,
  
  INDEX idx_user (user_id),
  INDEX idx_status (status),
  INDEX idx_slug (slug),
  INDEX idx_created (created_at DESC),
  INDEX idx_published (published_at DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### 2. Bảng `blog_images`
```sql
CREATE TABLE blog_images (
  image_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  blog_id BIGINT NOT NULL,
  image_url VARCHAR(500) NOT NULL,
  caption TEXT,
  display_order INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (blog_id) REFERENCES blogs(blog_id) ON DELETE CASCADE,
  INDEX idx_blog (blog_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### 3. Bảng `blog_comments`
```sql
CREATE TABLE blog_comments (
  comment_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  blog_id BIGINT NOT NULL,
  user_id INT NOT NULL,
  parent_comment_id BIGINT NULL,
  content TEXT NOT NULL,
  status ENUM('PENDING', 'APPROVED', 'SPAM') DEFAULT 'APPROVED',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  FOREIGN KEY (blog_id) REFERENCES blogs(blog_id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (parent_comment_id) REFERENCES blog_comments(comment_id) ON DELETE CASCADE,
  
  INDEX idx_blog (blog_id),
  INDEX idx_user (user_id),
  INDEX idx_parent (parent_comment_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### 4. Bảng `blog_likes`
```sql
CREATE TABLE blog_likes (
  like_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  blog_id BIGINT NOT NULL,
  user_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (blog_id) REFERENCES blogs(blog_id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  
  UNIQUE KEY unique_like (blog_id, user_id),
  INDEX idx_blog (blog_id),
  INDEX idx_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### 5. Bảng `blog_notifications`
```sql
CREATE TABLE blog_notifications (
  notification_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  blog_id BIGINT NOT NULL,
  user_id INT NOT NULL,
  type ENUM('APPROVED', 'REJECTED', 'COMMENT', 'LIKE') NOT NULL,
  title VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (blog_id) REFERENCES blogs(blog_id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  
  INDEX idx_user_read (user_id, is_read),
  INDEX idx_created (created_at DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

## 🔄 WORKFLOW

### **1. User/Seller tạo blog:**
```
1. Vào "My Blogs" page
2. Click "Tạo blog mới"
3. Nhập: Title, Summary, Content (Rich Text Editor), Featured Image
4. Lưu nháp (DRAFT) hoặc Gửi phê duyệt (PENDING)
5. Nếu gửi phê duyệt → Tạo notification cho Admin
```

### **2. Admin phê duyệt:**
```
1. Vào Admin Dashboard → Blog Moderation tab
2. Xem danh sách blog PENDING
3. Xem chi tiết blog
4. Chọn:
   - APPROVE → status = APPROVED, published_at = NOW()
   - REJECT → status = REJECTED, nhập lý do
5. Tạo notification cho người đăng
```

### **3. Hiển thị trên trang chủ:**
```
1. Query: SELECT * FROM blogs WHERE status = 'APPROVED' 
   ORDER BY published_at DESC LIMIT 3
2. Hiển thị ở section giữa Featured Products và Footer
3. Mỗi blog card có: Featured Image, Title, Summary, Author, Date
```

---

## 🎨 UI/UX DESIGN

### **1. User Blog Management Page (`/user/my-blogs`)**
```
┌─────────────────────────────────────────────┐
│  My Blogs                    [+ Tạo Blog]   │
├─────────────────────────────────────────────┤
│  [All] [Draft] [Pending] [Approved] [Rejected]
├─────────────────────────────────────────────┤
│  ┌──────────────────────────────────────┐  │
│  │ 📝 Title of Blog 1      [Edit] [Del] │  │
│  │ Status: PENDING                       │  │
│  │ Views: 123 | Likes: 45 | Date: ...   │  │
│  └──────────────────────────────────────┘  │
├─────────────────────────────────────────────┤
│  Pagination: [1] [2] [3] ...                │
└─────────────────────────────────────────────┘
```

### **2. Blog Editor Page (`/user/blog-editor`)**
```
┌─────────────────────────────────────────────┐
│  Create/Edit Blog                           │
├─────────────────────────────────────────────┤
│  Title: [________________________]          │
│  Slug:  [________________________]          │
│  Summary: [____________________]            │
│  Featured Image: [Choose File] [Preview]   │
├─────────────────────────────────────────────┤
│  Content: (Rich Text Editor - TinyMCE)     │
│  ┌──────────────────────────────────────┐  │
│  │ B I U | H1 H2 | 🔗 🖼️ | Code |      │  │
│  │                                       │  │
│  │  Write your blog content here...     │  │
│  │                                       │  │
│  └──────────────────────────────────────┘  │
├─────────────────────────────────────────────┤
│  [Save Draft] [Submit for Review] [Cancel] │
└─────────────────────────────────────────────┘
```

### **3. Admin Moderation Page (`/admin/blog-moderation`)**
```
┌─────────────────────────────────────────────┐
│  Blog Moderation                            │
├─────────────────────────────────────────────┤
│  [Pending: 5] [Approved: 120] [Rejected: 8]│
├─────────────────────────────────────────────┤
│  ┌──────────────────────────────────────┐  │
│  │ 📝 Title of Blog                     │  │
│  │ By: John Doe | Date: 2025-10-29     │  │
│  │ [View Details] [Approve] [Reject]   │  │
│  └──────────────────────────────────────┘  │
├─────────────────────────────────────────────┤
│  Modal: Reject Reason                       │
│  ┌──────────────────────────────────────┐  │
│  │ Reason: [________________________]   │  │
│  │ [Confirm] [Cancel]                   │  │
│  └──────────────────────────────────────┘  │
└─────────────────────────────────────────────┘
```

### **4. Public Blog View Page (`/blog/{slug}`)**
```
┌─────────────────────────────────────────────┐
│  [Featured Image]                           │
├─────────────────────────────────────────────┤
│  # Title of Blog                            │
│  By: John Doe | Date: Oct 29, 2025         │
│  👁️ 1,234 views | 💬 45 comments | ❤️ 123  │
├─────────────────────────────────────────────┤
│  Blog content here...                       │
│                                             │
│  Lorem ipsum dolor sit amet...              │
├─────────────────────────────────────────────┤
│  💬 Comments (45)                           │
│  ┌──────────────────────────────────────┐  │
│  │ John Doe: Great article!             │  │
│  │ [Reply] [Like]                       │  │
│  └──────────────────────────────────────┘  │
└─────────────────────────────────────────────┘
```

### **5. Blog Section on Home Page**
```
┌─────────────────────────────────────────────┐
│  📝 Latest Blog Posts                       │
├─────────────────────────────────────────────┤
│  [Image]  [Image]  [Image]                  │
│  Title 1  Title 2  Title 3                  │
│  Summary  Summary  Summary                  │
│  [Read]   [Read]   [Read]                   │
├─────────────────────────────────────────────┤
│  [View All Blogs →]                         │
└─────────────────────────────────────────────┘
```

---

## 🛠️ TECHNICAL IMPLEMENTATION

### **Java Classes:**

1. **Model:**
   - `Blog.java` - Blog entity
   - `BlogImage.java` - Blog images
   - `BlogComment.java` - Comments
   - `BlogLike.java` - Likes
   - `BlogNotification.java` - Notifications

2. **DAO:**
   - `BlogDAO.java` - CRUD operations
   - `BlogImageDAO.java` - Image management
   - `BlogCommentDAO.java` - Comment management
   - `BlogNotificationDAO.java` - Notification management

3. **Controllers:**
   - `UserBlogController.java` - User blog management
   - `BlogEditorController.java` - Create/Edit blog
   - `AdminBlogModerationController.java` - Admin moderation
   - `PublicBlogViewController.java` - Public blog view
   - `BlogListController.java` - List all approved blogs

### **JSP Pages:**

1. **User:**
   - `user/my-blogs.jsp` - User blog management
   - `user/blog-editor.jsp` - Create/Edit blog

2. **Admin:**
   - `admin/blog-moderation.jsp` - Moderation dashboard

3. **Public:**
   - `common/blog-detail.jsp` - View single blog
   - `common/blog-list.jsp` - List all blogs

4. **Components:**
   - `component/blog-card.jsp` - Reusable blog card
   - `component/blog-section.jsp` - Home page blog section

### **JavaScript:**

1. `blog-editor.js` - Rich text editor (TinyMCE)
2. `blog-moderation.js` - Admin moderation AJAX
3. `blog-comments.js` - Comment system
4. `blog-likes.js` - Like functionality

---

## 🔐 SECURITY & VALIDATION

### **Permissions:**
```
- CREATE: Customer, Seller
- EDIT: Owner only (if DRAFT or REJECTED)
- DELETE: Owner only
- MODERATE: Admin only
- VIEW APPROVED: Everyone
- VIEW PENDING: Admin only
```

### **Validation:**
```
- Title: 10-255 characters, required
- Slug: Auto-generate from title, unique, URL-safe
- Summary: 50-500 characters
- Content: Required, min 100 characters
- Featured Image: Optional, max 5MB, jpg/png/webp
- XSS Protection: Sanitize HTML in content
- SQL Injection: Use PreparedStatement
```

---

## 📊 NOTIFICATION TYPES

### **1. Blog Approved:**
```
Title: "Blog của bạn đã được phê duyệt! 🎉"
Message: "Blog '{title}' đã được phê duyệt và đang hiển thị công khai."
```

### **2. Blog Rejected:**
```
Title: "Blog của bạn bị từ chối ❌"
Message: "Blog '{title}' đã bị từ chối. Lý do: {reason}"
```

### **3. New Comment:**
```
Title: "Bình luận mới trên blog của bạn 💬"
Message: "{user} đã bình luận: {comment}"
```

### **4. New Like:**
```
Title: "Ai đó thích blog của bạn ❤️"
Message: "Blog '{title}' đã nhận được {count} lượt thích"
```

---

## 🚀 FEATURES

### **Phase 1: Core Functionality**
- [x] Database schema
- [ ] Model classes
- [ ] DAO classes
- [ ] User blog management (CRUD)
- [ ] Admin moderation
- [ ] Notification system
- [ ] Home page integration

### **Phase 2: Enhanced Features**
- [ ] Rich text editor (TinyMCE)
- [ ] Image upload & management
- [ ] Comment system
- [ ] Like system
- [ ] Blog statistics

### **Phase 3: Advanced Features**
- [ ] Blog categories/tags
- [ ] Blog search & filter
- [ ] SEO optimization
- [ ] Share to social media
- [ ] Email notifications

---

## 📝 NOTES

1. **Slug Generation:**
   - Auto-generate from title: "My Blog Title" → "my-blog-title"
   - Add unique suffix if duplicate: "my-blog-title-1"

2. **Image Storage:**
   - Store in: `web/assets/img/blog/`
   - Format: `{blog_id}_{timestamp}_{filename}`

3. **Rich Text Editor:**
   - Use TinyMCE (open-source, feature-rich)
   - CDN: https://cdn.tiny.cloud/1/no-api-key/tinymce/6/tinymce.min.js

4. **Performance:**
   - Cache approved blogs (5 min)
   - Pagination: 10 blogs per page
   - Lazy load images

---

**Created:** 2025-10-29  
**Author:** AI Assistant  
**Version:** 1.0

