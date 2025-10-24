package dao;

import model.cms.Post;
import model.user.Users;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PostDAO extends DBConnection {

    public List<Post> list(String type, String status, String q, int page, int pageSize) {
        List<Post> out = new ArrayList<>();
        int offset = (Math.max(page,1)-1) * Math.max(pageSize,10);
        StringBuilder sql = new StringBuilder("SELECT p.*, u.user_id, u.full_name FROM Posts p JOIN Users u ON p.author_id = u.user_id WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (type != null && !type.isEmpty()) { sql.append(" AND p.type = ?"); params.add(type); }
        if (status != null && !status.isEmpty()) { sql.append(" AND p.status = ?"); params.add(status); }
        if (q != null && !q.isEmpty()) { sql.append(" AND (p.title LIKE ? OR p.excerpt LIKE ?)"); params.add("%"+q+"%"); params.add("%"+q+"%"); }
        sql.append(" ORDER BY p.created_at DESC LIMIT ? OFFSET ?");
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int i=1; for (Object pObj: params) { ps.setObject(i++, pObj);} 
            ps.setInt(i++, Math.max(pageSize,10));
            ps.setInt(i, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) out.add(mapRow(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return out;
    }

    public Post findById(int id) {
        String sql = "SELECT p.*, u.user_id, u.full_name FROM Posts p JOIN Users u ON p.author_id = u.user_id WHERE p.id=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return mapRow(rs);} 
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public boolean create(Post p) {
        String sql = "INSERT INTO Posts(type,title,slug,excerpt,content,status,author_id,created_at,updated_at) VALUES(?,?,?,?,?,?,?,NOW(),NOW())";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, p.getType());
            ps.setString(2, p.getTitle());
            ps.setString(3, p.getSlug());
            ps.setString(4, p.getExcerpt());
            ps.setString(5, p.getContent());
            ps.setString(6, p.getStatus());
            ps.setInt(7, p.getAuthor().getUser_id());
            int rows = ps.executeUpdate();
            if (rows>0) {
                try (ResultSet keys = ps.getGeneratedKeys()) { if (keys.next()) p.setId(keys.getInt(1)); }
                return true;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean update(Post p) {
        String sql = "UPDATE Posts SET type=?, title=?, slug=?, excerpt=?, content=?, status=?, author_id=?, updated_at=NOW() WHERE id=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getType());
            ps.setString(2, p.getTitle());
            ps.setString(3, p.getSlug());
            ps.setString(4, p.getExcerpt());
            ps.setString(5, p.getContent());
            ps.setString(6, p.getStatus());
            ps.setInt(7, p.getAuthor().getUser_id());
            ps.setInt(8, p.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM Posts WHERE id=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    private Post mapRow(ResultSet rs) throws SQLException {
        Post p = new Post();
        p.setId(rs.getInt("id"));
        p.setType(rs.getString("type"));
        p.setTitle(rs.getString("title"));
        p.setSlug(rs.getString("slug"));
        p.setExcerpt(rs.getString("excerpt"));
        p.setContent(rs.getString("content"));
        p.setStatus(rs.getString("status"));
        Users u = new Users();
        u.setUser_id(rs.getInt("author_id"));
        u.setFull_name(rs.getString("full_name"));
        p.setAuthor(u);
        Timestamp cAt = rs.getTimestamp("created_at");
        Timestamp uAt = rs.getTimestamp("updated_at");
        if (cAt != null) p.setCreatedAt(cAt.toLocalDateTime());
        if (uAt != null) p.setUpdatedAt(uAt.toLocalDateTime());
        return p;
    }
}
