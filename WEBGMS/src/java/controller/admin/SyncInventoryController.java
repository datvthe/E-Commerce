package controller.admin;

import dao.InventoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Admin tool để sync inventory từ digital_goods_codes
 * URL: /admin/sync-inventory
 * 
 * CÁCH DÙNG:
 * 1. Truy cập: http://localhost:8080/WEBGMS/admin/sync-inventory
 * 2. Xem kết quả sync
 */
@WebServlet(name = "SyncInventoryController", urlPatterns = {"/admin/sync-inventory"})
public class SyncInventoryController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        // TODO: Add admin authentication check
        // if (session.getAttribute("user") == null || !isAdmin) {
        //     response.sendRedirect("/login");
        //     return;
        // }
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Sync Inventory from Digital Goods Codes</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 40px; }");
        out.println("h1 { color: #333; }");
        out.println(".success { color: green; }");
        out.println(".error { color: red; }");
        out.println(".info { color: blue; }");
        out.println(".back-btn { display: inline-block; margin-top: 20px; padding: 10px 20px; background: #007bff; color: white; text-decoration: none; border-radius: 4px; }");
        out.println(".back-btn:hover { background: #0056b3; }");
        out.println("pre { background: #f4f4f4; padding: 15px; border-radius: 4px; overflow-x: auto; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        
        out.println("<h1>🔄 Sync Inventory from Digital Goods Codes</h1>");
        out.println("<hr>");
        
        try {
            long startTime = System.currentTimeMillis();
            
            out.println("<p class='info'>⏳ Starting sync process...</p>");
            out.flush(); // Flush để hiển thị ngay
            
            // Chạy sync
            InventoryDAO inventoryDAO = new InventoryDAO();
            inventoryDAO.syncInventoryFromDigitalCodes();
            
            long endTime = System.currentTimeMillis();
            long duration = endTime - startTime;
            
            out.println("<h2 class='success'>✅ Sync Completed Successfully!</h2>");
            out.println("<p>Time taken: " + duration + "ms</p>");
            
            // Hiển thị SQL để kiểm tra
            out.println("<h3>📊 Kiểm tra kết quả:</h3>");
            out.println("<pre>");
            out.println("-- Xem inventory sau khi sync");
            out.println("SELECT i.inventory_id, i.product_id, p.name, i.quantity, i.reserved_quantity, i.last_restocked_at");
            out.println("FROM inventory i");
            out.println("LEFT JOIN products p ON i.product_id = p.product_id");
            out.println("ORDER BY i.product_id;");
            out.println("");
            out.println("-- So sánh với digital_goods_codes");
            out.println("SELECT product_id, COUNT(*) as available_count");
            out.println("FROM digital_goods_codes");
            out.println("WHERE is_used = 0");
            out.println("GROUP BY product_id;");
            out.println("</pre>");
            
        } catch (Exception e) {
            out.println("<h2 class='error'>❌ Sync Failed!</h2>");
            out.println("<p>Error: " + e.getMessage() + "</p>");
            out.println("<pre>");
            e.printStackTrace(out);
            out.println("</pre>");
        }
        
        out.println("<a href='" + request.getContextPath() + "/admin/dashboard' class='back-btn'>← Back to Admin Dashboard</a>");
        out.println("<a href='" + request.getContextPath() + "/admin/sync-inventory' class='back-btn' style='background: #28a745; margin-left: 10px;'>🔄 Sync Again</a>");
        
        out.println("</body>");
        out.println("</html>");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

