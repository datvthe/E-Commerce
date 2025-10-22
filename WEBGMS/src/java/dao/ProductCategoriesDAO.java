package dao;

import java.sql.*;
import java.util.*;
import model.product.ProductCategories;

public class ProductCategoriesDAO extends DBConnection {

    public List<ProductCategories> getAllCategories() {
        List<ProductCategories> list = new ArrayList<>();
        String sql = "SELECT * FROM product_categories ORDER BY name";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ProductCategories c = new ProductCategories();
                c.setCategory_id(rs.getInt("category_id"));
                c.setName(rs.getString("name"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean existsByName(String name) {
        String sql = "SELECT 1 FROM product_categories WHERE name = ? LIMIT 1";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean insertCategory(String name, String slug, String description) {
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

    private String slugify(String input) {
        if (input == null) return null;
        String s = java.text.Normalizer.normalize(input, java.text.Normalizer.Form.NFD)
                .replaceAll("[\\p{InCombiningDiacriticalMarks}]", "");
        s = s.toLowerCase().replaceAll("[^a-z0-9]+", "-").replaceAll("(^-|-$)", "");
        return s;
    }
}
