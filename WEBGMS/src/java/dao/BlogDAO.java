package dao;

import model.blog.Blog;
import model.user.Users;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO cho Blog
 * - CRUD operations
 * - Moderation (approve/reject)
 * - Statistics
 */
public class BlogDAO {
    
    // ================================================
    // CREATE
    // ================================================
    
    /**
     * Tạo blog mới (DRAFT hoặc PENDING)
     */
    public Long createBlog(Blog blog) throws SQLException {
        String sql = "INSERT INTO blogs " +
                    "(user_id, title, slug, summary, content, featured_image, " +
                    "status, meta_title, meta_description, meta_keywords) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, blog.getUserId());
            ps.setString(2, blog.getTitle());
            ps.setString(3, blog.getSlug());
            ps.setString(4, blog.getSummary());
            ps.setString(5, blog.getContent());
            ps.setString(6, blog.getFeaturedImage());
            ps.setString(7, blog.getStatus());
            ps.setString(8, blog.getMetaTitle());
            ps.setString(9, blog.getMetaDescription());
            ps.setString(10, blog.getMetaKeywords());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getLong(1);
                    }
                }
            }
        }
        return null;
    }
    
    // ================================================
    // READ
    // ================================================
    
    /**
     * Lấy blog theo ID
     */
    public Blog getBlogById(Long blogId) throws SQLException {
        String sql = "SELECT b.*, " +
                    "u.full_name AS author_name, u.email AS author_email, " +
                    "m.full_name AS moderator_name " +
                    "FROM blogs b " +
                    "LEFT JOIN users u ON b.user_id = u.user_id " +
                    "LEFT JOIN users m ON b.moderator_id = m.user_id " +
                    "WHERE b.blog_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, blogId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractBlog(rs, true);
                }
            }
        }
        return null;
    }
    
    /**
     * Lấy blog theo slug (for public view)
     */
    public Blog getBlogBySlug(String slug) throws SQLException {
        String sql = "SELECT b.*, " +
                    "u.full_name AS author_name, u.email AS author_email " +
                    "FROM blogs b " +
                    "LEFT JOIN users u ON b.user_id = u.user_id " +
                    "WHERE b.slug = ? AND b.status = 'APPROVED'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, slug);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractBlog(rs, true);
                }
            }
        }
        return null;
    }
    
    /**
     * Lấy danh sách blog của user
     */
    public List<Blog> getBlogsByUserId(int userId, int page, int pageSize) throws SQLException {
        String sql = "SELECT b.*, u.full_name AS author_name " +
                    "FROM blogs b " +
                    "LEFT JOIN users u ON b.user_id = u.user_id " +
                    "WHERE b.user_id = ? " +
                    "ORDER BY b.created_at DESC " +
                    "LIMIT ? OFFSET ?";
        
        List<Blog> blogs = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, pageSize);
            ps.setInt(3, offset);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    blogs.add(extractBlog(rs, true));
                }
            }
        }
        return blogs;
    }
    
    /**
     * Lấy danh sách blog theo status
     */
    public List<Blog> getBlogsByStatus(String status, int page, int pageSize) throws SQLException {
        String sql = "SELECT b.*, u.full_name AS author_name, u.email AS author_email " +
                    "FROM blogs b " +
                    "LEFT JOIN users u ON b.user_id = u.user_id " +
                    "WHERE b.status = ? " +
                    "ORDER BY b.created_at DESC " +
                    "LIMIT ? OFFSET ?";
        
        List<Blog> blogs = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, pageSize);
            ps.setInt(3, offset);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    blogs.add(extractBlog(rs, true));
                }
            }
        }
        return blogs;
    }
    
    /**
     * Lấy blog mới nhất (approved) cho trang chủ
     */
    public List<Blog> getLatestApprovedBlogs(int limit) throws SQLException {
        String sql = "SELECT b.*, u.full_name AS author_name " +
                    "FROM blogs b " +
                    "LEFT JOIN users u ON b.user_id = u.user_id " +
                    "WHERE b.status = 'APPROVED' " +
                    "ORDER BY b.published_at DESC " +
                    "LIMIT ?";
        
        List<Blog> blogs = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    blogs.add(extractBlog(rs, true));
                }
            }
        }
        return blogs;
    }
    
    /**
     * Search blogs (title, summary, content)
     */
    public List<Blog> searchBlogs(String keyword, int page, int pageSize) throws SQLException {
        String sql = "SELECT b.*, u.full_name AS author_name " +
                    "FROM blogs b " +
                    "LEFT JOIN users u ON b.user_id = u.user_id " +
                    "WHERE b.status = 'APPROVED' " +
                    "AND (b.title LIKE ? OR b.summary LIKE ? OR b.content LIKE ?) " +
                    "ORDER BY b.published_at DESC " +
                    "LIMIT ? OFFSET ?";
        
        List<Blog> blogs = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String searchPattern = "%" + keyword + "%";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setInt(4, pageSize);
            ps.setInt(5, offset);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    blogs.add(extractBlog(rs, true));
                }
            }
        }
        return blogs;
    }
    
    // ================================================
    // UPDATE
    // ================================================
    
    /**
     * Cập nhật blog (chỉ owner và blog ở trạng thái DRAFT hoặc REJECTED)
     */
    public boolean updateBlog(Blog blog) throws SQLException {
        String sql = "UPDATE blogs SET " +
                    "title = ?, slug = ?, summary = ?, content = ?, " +
                    "featured_image = ?, meta_title = ?, meta_description = ?, " +
                    "meta_keywords = ?, status = ? " +
                    "WHERE blog_id = ? AND user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, blog.getTitle());
            ps.setString(2, blog.getSlug());
            ps.setString(3, blog.getSummary());
            ps.setString(4, blog.getContent());
            ps.setString(5, blog.getFeaturedImage());
            ps.setString(6, blog.getMetaTitle());
            ps.setString(7, blog.getMetaDescription());
            ps.setString(8, blog.getMetaKeywords());
            ps.setString(9, blog.getStatus());
            ps.setLong(10, blog.getBlogId());
            ps.setInt(11, blog.getUserId());
            
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Tăng view count
     */
    public void incrementViewCount(Long blogId) throws SQLException {
        String sql = "UPDATE blogs SET view_count = view_count + 1 WHERE blog_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, blogId);
            ps.executeUpdate();
        }
    }
    
    // ================================================
    // DELETE
    // ================================================
    
    /**
     * Xóa blog (chỉ owner và blog không phải APPROVED)
     */
    public boolean deleteBlog(Long blogId, int userId) throws SQLException {
        String sql = "DELETE FROM blogs " +
                    "WHERE blog_id = ? AND user_id = ? AND status != 'APPROVED'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, blogId);
            ps.setInt(2, userId);
            
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Admin xóa blog bất kỳ
     */
    public boolean deleteBlogByAdmin(Long blogId) throws SQLException {
        String sql = "DELETE FROM blogs WHERE blog_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, blogId);
            return ps.executeUpdate() > 0;
        }
    }
    
    // ================================================
    // MODERATION
    // ================================================
    
    /**
     * Phê duyệt blog (Admin only)
     */
    public boolean approveBlog(Long blogId, int moderatorId) throws SQLException {
        String sql = "CALL sp_approve_blog(?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {
            
            cs.setLong(1, blogId);
            cs.setInt(2, moderatorId);
            
            return cs.executeUpdate() > 0;
        }
    }
    
    /**
     * Từ chối blog (Admin only)
     */
    public boolean rejectBlog(Long blogId, int moderatorId, String reason) throws SQLException {
        String sql = "CALL sp_reject_blog(?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {
            
            cs.setLong(1, blogId);
            cs.setInt(2, moderatorId);
            cs.setString(3, reason);
            
            return cs.executeUpdate() > 0;
        }
    }
    
    // ================================================
    // COUNT & STATISTICS
    // ================================================
    
    /**
     * Đếm tổng số blog của user
     */
    public int countBlogsByUserId(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM blogs WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    /**
     * Đếm số blog theo status
     */
    public int countBlogsByStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM blogs WHERE status = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    /**
     * Check if slug exists
     */
    public boolean isSlugExists(String slug, Long excludeBlogId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM blogs WHERE slug = ? AND blog_id != ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, slug);
            ps.setLong(2, excludeBlogId == null ? 0 : excludeBlogId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }
    
    /**
     * Generate unique slug
     */
    public String generateUniqueSlug(String baseSlug, Long excludeBlogId) throws SQLException {
        String slug = baseSlug;
        int counter = 1;
        
        while (isSlugExists(slug, excludeBlogId)) {
            slug = baseSlug + "-" + counter;
            counter++;
        }
        
        return slug;
    }
    
    // ================================================
    // UTILITY
    // ================================================
    
    /**
     * Extract Blog from ResultSet
     */
    private Blog extractBlog(ResultSet rs, boolean includeAuthor) throws SQLException {
        Blog blog = new Blog();
        
        blog.setBlogId(rs.getLong("blog_id"));
        blog.setUserId(rs.getInt("user_id"));
        blog.setTitle(rs.getString("title"));
        blog.setSlug(rs.getString("slug"));
        blog.setSummary(rs.getString("summary"));
        blog.setContent(rs.getString("content"));
        blog.setFeaturedImage(rs.getString("featured_image"));
        blog.setStatus(rs.getString("status"));
        
        // Moderation fields
        blog.setModeratorId(rs.getObject("moderator_id", Integer.class));
        blog.setModerationNote(rs.getString("moderation_note"));
        blog.setModeratedAt(rs.getTimestamp("moderated_at"));
        
        // SEO fields
        blog.setMetaTitle(rs.getString("meta_title"));
        blog.setMetaDescription(rs.getString("meta_description"));
        blog.setMetaKeywords(rs.getString("meta_keywords"));
        
        // Statistics
        blog.setViewCount(rs.getInt("view_count"));
        blog.setLikeCount(rs.getInt("like_count"));
        blog.setCommentCount(rs.getInt("comment_count"));
        
        // Timestamps
        blog.setCreatedAt(rs.getTimestamp("created_at"));
        blog.setUpdatedAt(rs.getTimestamp("updated_at"));
        blog.setPublishedAt(rs.getTimestamp("published_at"));
        
        // Author info (if included)
        if (includeAuthor) {
            Users author = new Users();
            author.setUser_id(rs.getInt("user_id"));
            author.setFull_name(rs.getString("author_name"));
            try {
                author.setEmail(rs.getString("author_email"));
            } catch (SQLException ignored) {
                // Column might not exist in all queries
            }
            blog.setAuthor(author);
            
            // Moderator info (if exists)
            if (blog.getModeratorId() != null) {
                try {
                    Users moderator = new Users();
                    moderator.setUser_id(blog.getModeratorId());
                    moderator.setFull_name(rs.getString("moderator_name"));
                    blog.setModerator(moderator);
                } catch (SQLException ignored) {
                    // Column might not exist
                }
            }
        }
        
        return blog;
    }
}

