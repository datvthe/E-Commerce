package controller.chat;

import com.google.gson.JsonObject;
import dao.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user.Users;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/chat/delete-message")
public class DeleteMessageController extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        // Check authentication
        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        
        if (user == null) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("error", "Chưa đăng nhập");
            out.print(jsonResponse.toString());
            return;
        }
        
        try {
            // Read JSON body
            StringBuilder sb = new StringBuilder();
            try (BufferedReader reader = request.getReader()) {
                String line;
                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }
            }
            
            com.google.gson.JsonParser parser = new com.google.gson.JsonParser();
            JsonObject requestData = parser.parse(sb.toString()).getAsJsonObject();
            
            int messageId = requestData.get("messageId").getAsInt();
            
            // Verify message belongs to user
            String checkSql = "SELECT sender_id FROM chat_messages WHERE message_id = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(checkSql)) {
                
                ps.setInt(1, messageId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        int senderId = rs.getInt("sender_id");
                        if (senderId != user.getUser_id()) {
                            jsonResponse.addProperty("success", false);
                            jsonResponse.addProperty("error", "Bạn không có quyền xóa tin nhắn này");
                            out.print(jsonResponse.toString());
                            return;
                        }
                    } else {
                        jsonResponse.addProperty("success", false);
                        jsonResponse.addProperty("error", "Tin nhắn không tồn tại");
                        out.print(jsonResponse.toString());
                        return;
                    }
                }
            }
            
            // Soft delete: mark as deleted instead of actually deleting
            String deleteSql = "UPDATE chat_messages SET is_deleted = true, deleted_at = NOW() WHERE message_id = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(deleteSql)) {
                
                ps.setInt(1, messageId);
                
                int rowsAffected = ps.executeUpdate();
                
                if (rowsAffected > 0) {
                    jsonResponse.addProperty("success", true);
                    jsonResponse.addProperty("message", "Xóa tin nhắn thành công");
                } else {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("error", "Không thể xóa tin nhắn");
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("error", "Lỗi server: " + e.getMessage());
        }
        
        out.print(jsonResponse.toString());
    }
}

