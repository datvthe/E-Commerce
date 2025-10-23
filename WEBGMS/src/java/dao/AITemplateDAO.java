package dao;

import model.chat.AITemplate;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AITemplateDAO extends DBConnection {

    /**
     * Get all active AI templates
     */
    public List<AITemplate> getAllActiveTemplates() {
        List<AITemplate> templates = new ArrayList<>();
        String sql = "SELECT * FROM ai_chat_templates WHERE is_active = TRUE ORDER BY priority DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                templates.add(mapTemplate(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return templates;
    }

    /**
     * Find matching template for a message
     */
    public AITemplate findMatchingTemplate(String messageContent) {
        List<AITemplate> templates = getAllActiveTemplates();
        String lowerMessage = messageContent.toLowerCase();
        
        for (AITemplate template : templates) {
            String[] keywords = template.getKeyword().split("\\|");
            for (String keyword : keywords) {
                if (lowerMessage.contains(keyword.trim().toLowerCase())) {
                    return template;
                }
            }
        }
        return null;
    }

    /**
     * Get template by ID
     */
    public AITemplate getTemplateById(Integer templateId) {
        String sql = "SELECT * FROM ai_chat_templates WHERE template_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, templateId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapTemplate(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Create new AI template
     */
    public AITemplate createTemplate(String keyword, String responseText, String templateType, int priority) {
        String sql = "INSERT INTO ai_chat_templates (keyword, response_text, template_type, priority, is_active, created_at) " +
                     "VALUES (?, ?, ?, ?, TRUE, NOW())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, keyword);
            ps.setString(2, responseText);
            ps.setString(3, templateType);
            ps.setInt(4, priority);
            
            int affected = ps.executeUpdate();
            if (affected > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    return getTemplateById(keys.getInt(1));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Update template
     */
    public boolean updateTemplate(Integer templateId, String keyword, String responseText, String templateType, int priority) {
        String sql = "UPDATE ai_chat_templates SET keyword = ?, response_text = ?, template_type = ?, " +
                     "priority = ?, updated_at = NOW() WHERE template_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, keyword);
            ps.setString(2, responseText);
            ps.setString(3, templateType);
            ps.setInt(4, priority);
            ps.setInt(5, templateId);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete template (soft delete)
     */
    public boolean deleteTemplate(Integer templateId) {
        String sql = "UPDATE ai_chat_templates SET is_active = FALSE, updated_at = NOW() WHERE template_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, templateId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Map ResultSet to AITemplate object
     */
    private AITemplate mapTemplate(ResultSet rs) throws SQLException {
        AITemplate template = new AITemplate();
        template.setTemplateId(rs.getInt("template_id"));
        template.setKeyword(rs.getString("keyword"));
        template.setResponseText(rs.getString("response_text"));
        template.setTemplateType(rs.getString("template_type"));
        template.setPriority(rs.getInt("priority"));
        template.setActive(rs.getBoolean("is_active"));
        template.setCreatedAt(rs.getTimestamp("created_at"));
        template.setUpdatedAt(rs.getTimestamp("updated_at"));
        return template;
    }
}
