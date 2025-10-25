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
            try (ResultSet rs = ps.executeQuery()) {
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
            try (ResultSet rs = ps.executeQuery()) {
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
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return image;
    }

    public boolean insertProductImage(ProductImages img) {
        String sql = "INSERT INTO product_images (product_id, url, alt_text, is_primary) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, img.getProduct_id().getProduct_id());
            // ID sản phẩm
            ps.setString(2, img.getUrl());           // Đường dẫn ảnh
            ps.setString(3, img.getAlt_text());      // Mô tả alt text
            ps.setBoolean(4, img.isIs_primary());    // Ảnh chính hay phụ

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update primary image for a product
     */
    public boolean updatePrimaryImage(long productId, String imageUrl, String altText) {
        String sql = "UPDATE product_images SET is_primary = 0 WHERE product_id = ?";
        String insertSql = "INSERT INTO product_images (product_id, url, alt_text, is_primary) VALUES (?, ?, ?, 1)";
        
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            
            try (PreparedStatement ps1 = conn.prepareStatement(sql);
                 PreparedStatement ps2 = conn.prepareStatement(insertSql)) {
                
                // Set all existing images as non-primary
                ps1.setLong(1, productId);
                ps1.executeUpdate();
                
                // Insert new primary image
                ps2.setLong(1, productId);
                ps2.setString(2, imageUrl);
                ps2.setString(3, altText);
                ps2.executeUpdate();
                
                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                throw e;
            }
        } catch (Exception e) {
            System.err.println("Error updating primary image: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete image by ID
     */
    public boolean deleteImage(int imageId) {
        String sql = "DELETE FROM product_images WHERE image_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, imageId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error deleting image: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete all images for a product
     */
    public boolean deleteImagesByProductId(long productId) {
        String sql = "DELETE FROM product_images WHERE product_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, productId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error deleting images by product ID: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

}