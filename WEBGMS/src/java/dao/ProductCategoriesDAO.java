package dao;

import java.sql.*;
import java.util.*;
import model.product.ProductCategories;

public class ProductCategoriesDAO extends DBConnection {

    // ========== Public APIs used by controllers ==========

    // List with pagination (admin)
    public List<ProductCategories> getAllCategories(int page, int pageSize) {
        List<ProductCategories> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT * FROM product_categories ORDER BY created_at DESC LIMIT ? OFFSET ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pageSize);
            ps.setInt(2, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Count all
    public int getTotalCategories() {
        String sql = "SELECT COUNT(*) FROM product_categories";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Search with filters + pagination
    public List<ProductCategories> searchCategories(String keyword, String status, int page, int pageSize) {
        List<ProductCategories> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        StringBuilder sql = new StringBuilder("SELECT * FROM product_categories WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR description LIKE ?)");
            String k = "%" + keyword.trim() + "%";
            params.add(k); params.add(k);
        }
        if (status != null && !status.trim().isEmpty() && !"all".equalsIgnoreCase(status)) {
            sql.append(" AND status = ?");
            params.add(status);
        }
        sql.append(" ORDER BY created_at DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add(offset);

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Object p : params) {
                if (p instanceof String) ps.setString(idx++, (String) p);
                else if (p instanceof Integer) ps.setInt(idx++, (Integer) p);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Count with filters
    public int countCategories(String keyword, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM product_categories WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR description LIKE ?)");
            String k = "%" + keyword.trim() + "%";
            params.add(k); params.add(k);
        }
        if (status != null && !status.trim().isEmpty() && !"all".equalsIgnoreCase(status)) {
            sql.append(" AND status = ?");
            params.add(status);
        }
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Object p : params) {
                if (p instanceof String) ps.setString(idx++, (String) p);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public ProductCategories getCategoryById(long id) {
        String sql = "SELECT * FROM product_categories WHERE category_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean isCategoryNameExists(String name, Long excludeId) {
        StringBuilder sql = new StringBuilder("SELECT 1 FROM product_categories WHERE name = ?");
        if (excludeId != null) sql.append(" AND category_id <> ?");
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setString(1, name);
            if (excludeId != null) ps.setLong(2, excludeId);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean createCategory(ProductCategories c) {
        String sql = "INSERT INTO product_categories(name, slug, description, status, created_at) VALUES(?, ?, ?, ?, CURRENT_TIMESTAMP)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getName());
            ps.setString(2, c.getSlug());
            ps.setString(3, c.getDescription());
            ps.setString(4, c.getStatus() == null ? "active" : c.getStatus());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateCategory(ProductCategories c) {
        String sql = "UPDATE product_categories SET name = ?, slug = ?, description = ?, status = ?, updated_at = CURRENT_TIMESTAMP WHERE category_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getName());
            ps.setString(2, c.getSlug());
            ps.setString(3, c.getDescription());
            ps.setString(4, c.getStatus());
            ps.setLong(5, c.getCategory_id());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteCategory(long id) {
        String sql = "DELETE FROM product_categories WHERE category_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ========== Backward-compatible/simple helpers ==========

    // List without pagination (used in some places like seller add form)
    public List<ProductCategories> getAllCategories() {
        List<ProductCategories> list = new ArrayList<>();
        String sql = "SELECT * FROM product_categories ORDER BY name";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean existsByName(String name) { // old API
        String sql = "SELECT 1 FROM product_categories WHERE name = ? LIMIT 1";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean insertCategory(String name, String slug, String description) { // old API
        String sql = "INSERT INTO product_categories(name, slug, description, status, created_at) VALUES(?, ?, ?, 'active', CURRENT_TIMESTAMP)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, slug);
            ps.setString(3, description);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void ensureDefaultDigitalCategories() {
        String[] defaults = new String[]{
                // Legacy home featured categories
                "Học tập",
                "Xem phim",
                "Phần mềm",
                "Tài liệu",
                "Thẻ cào",
                "Tài khoản Game",
                // Popular digital items
                "Tài khoản Netflix",
                "Tài khoản ChatGPT",
                "Tài khoản Spotify",
                "Tài khoản YouTube Premium",
                "Mã phần mềm/License",
                "Thẻ cào Viettel",
                "Thẻ cào VinaPhone",
                "Thẻ cào MobiFone"
        };

        for (String name : defaults) {
            if (!existsByName(name)) {
                insertCategory(name, slugify(name), null);
            }
        }
    }

    private ProductCategories map(ResultSet rs) throws SQLException {
        ProductCategories c = new ProductCategories();
        c.setCategory_id(rs.getLong("category_id"));
        c.setName(rs.getString("name"));
        c.setDescription(rs.getString("description"));
        c.setSlug(rs.getString("slug"));
        c.setStatus(rs.getString("status"));
        c.setCreated_at(rs.getTimestamp("created_at"));
        c.setUpdated_at(rs.getTimestamp("updated_at"));
        return c;
    }

    private String slugify(String input) {
        if (input == null) return null;
        String s = java.text.Normalizer.normalize(input, java.text.Normalizer.Form.NFD)
                .replaceAll("[\\p{InCombiningDiacriticalMarks}]", "");
        s = s.toLowerCase().replaceAll("[^a-z0-9]+", "-").replaceAll("(^-|-$)", "");
        return s;
    }
}
