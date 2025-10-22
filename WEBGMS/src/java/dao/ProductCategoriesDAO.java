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
}
