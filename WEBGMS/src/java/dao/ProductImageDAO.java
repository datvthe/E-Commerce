package dao;

import model.product.ProductImages;
import model.product.Products;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class for Product Images operations
 */
public class ProductImageDAO extends DBConnection {

    /**
     * Get all images for a product
     */
    public List<ProductImages> getImagesByProductId(long productId) {
        List<ProductImages> images = new ArrayList<>();
        String sql = "SELECT * FROM Product_Images "
                + "WHERE product_id = ? "
                + "ORDER BY is_primary DESC, image_id ASC";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, productId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ProductImages image = new ProductImages();
                image.setImage_id(rs.getInt("image_id"));
                
                Products product = new Products();
                product.setProduct_id(productId);
                image.setProduct_id(product);
                
                image.setUrl(rs.getString("url"));
                image.setAlt_text(rs.getString("alt_text"));
                image.setIs_primary(rs.getBoolean("is_primary"));
                images.add(image);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return images;
    }

    /**
     * Get primary image for a product
     */
    public ProductImages getPrimaryImage(long productId) {
        ProductImages image = null;
        String sql = "SELECT * FROM Product_Images "
                + "WHERE product_id = ? AND is_primary = 1 "
                + "LIMIT 1";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, productId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                image = new ProductImages();
                image.setImage_id(rs.getInt("image_id"));
                
                Products product = new Products();
                product.setProduct_id(productId);
                image.setProduct_id(product);
                
                image.setUrl(rs.getString("url"));
                image.setAlt_text(rs.getString("alt_text"));
                image.setIs_primary(rs.getBoolean("is_primary"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return image;
    }
}

