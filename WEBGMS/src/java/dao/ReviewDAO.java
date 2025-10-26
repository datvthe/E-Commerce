package dao;

import model.feedback.Reviews;
import model.product.Products;
import model.user.Users;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class for Reviews operations
 */
public class ReviewDAO extends DBConnection {

    /**
     * Get reviews by product ID
     */
    public List<Reviews> getReviewsByProductId(long productId, int page, int pageSize) {
        List<Reviews> reviews = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        String sql = "SELECT r.*, u.user_id, u.full_name, u.avatar_url "
                + "FROM Reviews r "
                + "JOIN Users u ON r.buyer_id = u.user_id "
                + "WHERE r.product_id = ? AND r.status = 'visible' "
                + "ORDER BY r.created_at DESC "
                + "LIMIT ? OFFSET ?";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, productId);
            ps.setInt(2, pageSize);
            ps.setInt(3, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Reviews review = new Reviews();
                    review.setReviewId(rs.getInt("review_id"));
                    
                    Products product = new Products();
                    product.setProduct_id(productId);
                    review.setProductId(product);
                    
                    Users buyer = new Users();
                    buyer.setUser_id(rs.getInt("user_id"));
                    buyer.setFull_name(rs.getString("full_name"));
                    buyer.setAvatar_url(rs.getString("avatar_url"));
                    review.setBuyerId(buyer);
                    
                    review.setRating(rs.getInt("rating"));
                    review.setComment(rs.getString("comment"));
                    review.setImages(rs.getString("images"));
                    review.setStatus(rs.getString("status"));
                    review.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    reviews.add(review);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return reviews;
    }

    /**
     * Add a new review
     */
    public boolean addReview(int productId, int buyerId, int rating, String comment, String images) {
        String sql = "INSERT INTO Reviews (product_id, buyer_id, rating, comment, images, status, created_at) "
                + "VALUES (?, ?, ?, ?, ?, 'visible', NOW())";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            ps.setInt(2, buyerId);
            ps.setInt(3, rating);
            ps.setString(4, comment);
            ps.setString(5, images);

            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                updateProductRating(productId);
                return true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update product average rating and total reviews
     */
    private void updateProductRating(int productId) {
        String sql = "UPDATE Products p SET "
                + "p.average_rating = (SELECT AVG(rating) FROM Reviews WHERE product_id = ? AND status = 'visible'), "
                + "p.total_reviews = (SELECT COUNT(*) FROM Reviews WHERE product_id = ? AND status = 'visible') "
                + "WHERE p.product_id = ?";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            ps.setInt(2, productId);
            ps.setInt(3, productId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Get rating distribution for a product
     */
    public int[] getRatingDistribution(long productId) {
        int[] distribution = new int[5]; // 0=1star, 1=2star, ..., 4=5star
        
        String sql = "SELECT rating, COUNT(*) as count FROM Reviews "
                + "WHERE product_id = ? AND status = 'visible' "
                + "GROUP BY rating";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int rating = rs.getInt("rating");
                    int count = rs.getInt("count");
                    if (rating >= 1 && rating <= 5) {
                        distribution[rating - 1] = count;
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return distribution;
    }

    // Admin moderation methods
    public List<Reviews> listAll(String status, int page, int pageSize) {
        List<Reviews> reviews = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        StringBuilder sql = new StringBuilder("SELECT r.*, u.user_id, u.full_name, u.avatar_url, p.product_id FROM Reviews r "
                + "JOIN Users u ON r.buyer_id = u.user_id JOIN Products p ON r.product_id = p.product_id WHERE 1=1");
        if (status != null && !status.isEmpty()) {
            sql.append(" AND r.status = ?");
        }
        sql.append(" ORDER BY r.created_at DESC LIMIT ? OFFSET ?");
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int i = 1;
            if (status != null && !status.isEmpty()) ps.setString(i++, status);
            ps.setInt(i++, pageSize);
            ps.setInt(i, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Reviews review = new Reviews();
                    review.setReviewId(rs.getInt("review_id"));
                    Products product = new Products();
                    product.setProduct_id(rs.getLong("product_id"));
                    review.setProductId(product);
                    Users buyer = new Users();
                    buyer.setUser_id(rs.getInt("user_id"));
                    buyer.setFull_name(rs.getString("full_name"));
                    buyer.setAvatar_url(rs.getString("avatar_url"));
                    review.setBuyerId(buyer);
                    review.setRating(rs.getInt("rating"));
                    review.setComment(rs.getString("comment"));
                    review.setImages(rs.getString("images"));
                    review.setStatus(rs.getString("status"));
                    review.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    reviews.add(review);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return reviews;
    }

    public boolean updateStatus(int reviewId, String status) {
        String sql = "UPDATE Reviews SET status=? WHERE review_id=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, reviewId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
}