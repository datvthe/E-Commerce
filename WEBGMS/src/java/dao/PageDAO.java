package dao;

import model.cms.Page;
import model.user.Users;

import java.sql.*;

public class PageDAO extends DBConnection {

    public Page findBySlug(String slug) {
        String sql = "SELECT p.*, u.user_id, u.full_name FROM Pages p LEFT JOIN Users u ON p.updated_by = u.user_id WHERE p.slug=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, slug);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return mapRow(rs); }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public boolean upsert(Page p) {
        // Insert if not exists else update
        String sql = "INSERT INTO Pages(slug,title,content,status,updated_by,created_at,updated_at) VALUES(?,?,?,?,?,NOW(),NOW()) " +
                "ON DUPLICATE KEY UPDATE title=VALUES(title), content=VALUES(content), status=VALUES(status), updated_by=VALUES(updated_by), updated_at=NOW()";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getSlug());
            ps.setString(2, p.getTitle());
            ps.setString(3, p.getContent());
            ps.setString(4, p.getStatus());
            ps.setInt(5, p.getUpdatedBy() == null ? 0 : p.getUpdatedBy().getUser_id());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    private Page mapRow(ResultSet rs) throws SQLException {
        Page p = new Page();
        p.setId(rs.getInt("id"));
        p.setSlug(rs.getString("slug"));
        p.setTitle(rs.getString("title"));
        p.setContent(rs.getString("content"));
        p.setStatus(rs.getString("status"));
        Users u = new Users();
        int uid = rs.getInt("updated_by");
        if (!rs.wasNull()) u.setUser_id(uid);
        u.setFull_name(rs.getString("full_name"));
        p.setUpdatedBy(uid == 0 && rs.wasNull() ? null : u);
        Timestamp cAt = rs.getTimestamp("created_at");
        Timestamp uAt = rs.getTimestamp("updated_at");
        if (cAt != null) p.setCreatedAt(cAt.toLocalDateTime());
        if (uAt != null) p.setUpdatedAt(uAt.toLocalDateTime());
        return p;
    }
}