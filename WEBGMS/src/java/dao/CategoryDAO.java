package dao;

import model.Category;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * CategoryDAO - Data Access Object for Category operations
 */
public class CategoryDAO extends DBConnection {

    /**
     * Get all active categories
     */
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String query = "SELECT c.*, COUNT(p.product_id) as product_count " +
                      "FROM product_categories c " +
                      "LEFT JOIN products p ON c.category_id = p.category_id AND p.status = 'active' " +
                      "WHERE c.status = 'active' " +
                      "GROUP BY c.category_id " +
                      "ORDER BY c.name ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Category category = extractCategoryFromResultSet(rs);
                category.setProductCount(rs.getInt("product_count"));
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return categories;
    }

    /**
     * Get parent categories (top level)
     */
    public List<Category> getParentCategories() {
        List<Category> categories = new ArrayList<>();
        String query = "SELECT c.*, COUNT(p.product_id) as product_count " +
                      "FROM product_categories c " +
                      "LEFT JOIN products p ON c.category_id = p.category_id AND p.status = 'active' " +
                      "WHERE c.status = 'active' AND c.parent_id IS NULL " +
                      "GROUP BY c.category_id " +
                      "ORDER BY c.name ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Category category = extractCategoryFromResultSet(rs);
                category.setProductCount(rs.getInt("product_count"));
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return categories;
    }

    /**
     * Get subcategories by parent ID
     */
    public List<Category> getSubcategories(Long parentId) {
        List<Category> categories = new ArrayList<>();
        String query = "SELECT c.*, COUNT(p.product_id) as product_count " +
                      "FROM product_categories c " +
                      "LEFT JOIN products p ON c.category_id = p.category_id AND p.status = 'active' " +
                      "WHERE c.status = 'active' AND c.parent_id = ? " +
                      "GROUP BY c.category_id " +
                      "ORDER BY c.name ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setLong(1, parentId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Category category = extractCategoryFromResultSet(rs);
                category.setProductCount(rs.getInt("product_count"));
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return categories;
    }

    /**
     * Get category by ID
     */
    public Category getCategoryById(Long categoryId) {
        String query = "SELECT c.*, p.name as parent_name, COUNT(prod.product_id) as product_count " +
                      "FROM product_categories c " +
                      "LEFT JOIN product_categories p ON c.parent_id = p.category_id " +
                      "LEFT JOIN products prod ON c.category_id = prod.category_id AND prod.status = 'active' " +
                      "WHERE c.category_id = ? " +
                      "GROUP BY c.category_id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setLong(1, categoryId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Category category = extractCategoryFromResultSet(rs);
                category.setProductCount(rs.getInt("product_count"));
                category.setParentName(rs.getString("parent_name"));
                return category;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }

    /**
     * Get category by slug
     */
    public Category getCategoryBySlug(String slug) {
        String query = "SELECT c.*, p.name as parent_name, COUNT(prod.product_id) as product_count " +
                      "FROM product_categories c " +
                      "LEFT JOIN product_categories p ON c.parent_id = p.category_id " +
                      "LEFT JOIN products prod ON c.category_id = prod.category_id AND prod.status = 'active' " +
                      "WHERE c.slug = ? AND c.status = 'active' " +
                      "GROUP BY c.category_id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, slug);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Category category = extractCategoryFromResultSet(rs);
                category.setProductCount(rs.getInt("product_count"));
                category.setParentName(rs.getString("parent_name"));
                return category;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }

    /**
     * Extract Category object from ResultSet
     */
    private Category extractCategoryFromResultSet(ResultSet rs) throws SQLException {
        Category category = new Category();
        category.setCategoryId(rs.getLong("category_id"));
        category.setParentId(rs.getObject("parent_id") != null ? rs.getLong("parent_id") : null);
        category.setName(rs.getString("name"));
        category.setSlug(rs.getString("slug"));
        category.setDescription(rs.getString("description"));
        category.setStatus(rs.getString("status"));
        category.setCreatedAt(rs.getTimestamp("created_at"));
        category.setUpdatedAt(rs.getTimestamp("updated_at"));
        return category;
    }
<<<<<<< HEAD
}
=======

}
>>>>>>> adfffa2ca17758b7b0f2e7aa138910e53f368132
