package dao;

import model.product.ProductCategories;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO extends DBConnection {
    
    // Get all categories with pagination
    public List<ProductCategories> getAllCategories(int page, int pageSize) {
        List<ProductCategories> categories = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT * FROM Product_Categories ORDER BY created_at DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, pageSize);
            ps.setInt(2, offset);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                categories.add(mapResultSetToCategory(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }
    
    // Search categories with filter and pagination
    public List<ProductCategories> searchCategories(String keyword, String status, int page, int pageSize) {
        List<ProductCategories> categories = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        StringBuilder sql = new StringBuilder("SELECT * FROM Product_Categories WHERE 1=1");
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR description LIKE ?)");
        }
        if (status != null && !status.trim().isEmpty() && !status.equals("all")) {
            sql.append(" AND status = ?");
        }
        
        sql.append(" ORDER BY created_at DESC LIMIT ? OFFSET ?");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String searchPattern = "%" + keyword + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }
            if (status != null && !status.trim().isEmpty() && !status.equals("all")) {
                ps.setString(paramIndex++, status);
            }
            ps.setInt(paramIndex++, pageSize);
            ps.setInt(paramIndex++, offset);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                categories.add(mapResultSetToCategory(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }
    
    // Count total categories
    public int getTotalCategories() {
        String sql = "SELECT COUNT(*) FROM Product_Categories";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Count categories with filter
    public int countCategories(String keyword, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Product_Categories WHERE 1=1");
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR description LIKE ?)");
        }
        if (status != null && !status.trim().isEmpty() && !status.equals("all")) {
            sql.append(" AND status = ?");
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String searchPattern = "%" + keyword + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }
            if (status != null && !status.trim().isEmpty() && !status.equals("all")) {
                ps.setString(paramIndex++, status);
            }
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Get category by ID
    public ProductCategories getCategoryById(long categoryId) {
        String sql = "SELECT * FROM Product_Categories WHERE category_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, categoryId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToCategory(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Create new category
    public boolean createCategory(ProductCategories category) {
        String sql = "INSERT INTO Product_Categories (name, slug, description, status, created_at, updated_at) VALUES (?, ?, ?, ?, NOW(), NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, category.getName());
            ps.setString(2, category.getSlug());
            ps.setString(3, category.getDescription());
            ps.setString(4, category.getStatus());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Update category
    public boolean updateCategory(ProductCategories category) {
        String sql = "UPDATE Product_Categories SET name = ?, slug = ?, description = ?, status = ?, updated_at = NOW() WHERE category_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, category.getName());
            ps.setString(2, category.getSlug());
            ps.setString(3, category.getDescription());
            ps.setString(4, category.getStatus());
            ps.setLong(5, category.getCategory_id());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Delete category
    public boolean deleteCategory(long categoryId) {
        String sql = "DELETE FROM Product_Categories WHERE category_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, categoryId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Check if category name exists
    public boolean isCategoryNameExists(String name, Long excludeId) {
        String sql = excludeId == null 
            ? "SELECT COUNT(*) FROM Product_Categories WHERE name = ?"
            : "SELECT COUNT(*) FROM Product_Categories WHERE name = ? AND category_id != ?";
            
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, name);
            if (excludeId != null) {
                ps.setLong(2, excludeId);
            }
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Helper method to map ResultSet to ProductCategories
    private ProductCategories mapResultSetToCategory(ResultSet rs) throws SQLException {
        ProductCategories category = new ProductCategories();
        category.setCategory_id(rs.getLong("category_id"));
        category.setName(rs.getString("name"));
        category.setSlug(rs.getString("slug"));
        category.setDescription(rs.getString("description"));
        category.setStatus(rs.getString("status"));
        category.setCreated_at(rs.getTimestamp("created_at"));
        category.setUpdated_at(rs.getTimestamp("updated_at"));
        return category;
    }
}
