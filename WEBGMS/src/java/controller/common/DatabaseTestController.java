package controller.common;

import dao.ProductDAO;
import dao.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * Test controller to check database status and products
 */
@WebServlet(name = "DatabaseTestController", urlPatterns = {"/test-db"})
public class DatabaseTestController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Database Test - Gicungco</title>");
            out.println("<style>");
            out.println("body { font-family: Arial, sans-serif; margin: 20px; }");
            out.println(".success { color: green; }");
            out.println(".error { color: red; }");
            out.println(".info { color: blue; }");
            out.println("table { border-collapse: collapse; width: 100%; margin: 20px 0; }");
            out.println("th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }");
            out.println("th { background-color: #f2f2f2; }");
            out.println("</style>");
            out.println("</head>");
            out.println("<body>");
            
            out.println("<h1>Database Test Results</h1>");
            
            // Test database connection
            out.println("<h2>1. Database Connection Test</h2>");
            try (Connection conn = DBConnection.getConnection()) {
                if (conn != null && !conn.isClosed()) {
                    out.println("<p class='success'>✅ Database connection successful!</p>");
                } else {
                    out.println("<p class='error'>❌ Database connection failed!</p>");
                }
            } catch (Exception e) {
                out.println("<p class='error'>❌ Database connection error: " + e.getMessage() + "</p>");
            }
            
            // Test products table
            out.println("<h2>2. Products Table Test</h2>");
            ProductDAO productDAO = new ProductDAO();
            
            boolean hasProducts = productDAO.hasProducts();
            int totalProducts = productDAO.getTotalProductCount();
            
            if (hasProducts) {
                out.println("<p class='success'>✅ Products table exists and has data!</p>");
                out.println("<p class='info'>📊 Total products: " + totalProducts + "</p>");
                
                // Show sample products
                out.println("<h3>Sample Products:</h3>");
                out.println("<table>");
                out.println("<tr><th>ID</th><th>Name</th><th>Price</th><th>Currency</th><th>Status</th></tr>");
                
                try (Connection conn = DBConnection.getConnection();
                     Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery("SELECT product_id, name, price, currency, status FROM Products WHERE deleted_at IS NULL LIMIT 10")) {
                    
                    while (rs.next()) {
                        out.println("<tr>");
                        out.println("<td>" + rs.getLong("product_id") + "</td>");
                        out.println("<td>" + rs.getString("name") + "</td>");
                        out.println("<td>" + rs.getBigDecimal("price") + "</td>");
                        out.println("<td>" + rs.getString("currency") + "</td>");
                        out.println("<td>" + rs.getString("status") + "</td>");
                        out.println("</tr>");
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='5' class='error'>Error loading products: " + e.getMessage() + "</td></tr>");
                }
                
                out.println("</table>");
                
            } else {
                out.println("<p class='error'>❌ No products found in database!</p>");
                out.println("<p class='info'>💡 You may need to run the SQL scripts to create sample data.</p>");
            }
            
            // Test categories table
            out.println("<h2>3. Categories Table Test</h2>");
            try (Connection conn = DBConnection.getConnection();
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as count FROM Product_Categories")) {
                
                if (rs.next()) {
                    int categoryCount = rs.getInt("count");
                    if (categoryCount > 0) {
                        out.println("<p class='success'>✅ Categories table exists and has " + categoryCount + " categories!</p>");
                    } else {
                        out.println("<p class='error'>❌ Categories table exists but is empty!</p>");
                    }
                }
            } catch (Exception e) {
                out.println("<p class='error'>❌ Categories table error: " + e.getMessage() + "</p>");
            }
            
            // Test users table
            out.println("<h2>4. Users Table Test</h2>");
            try (Connection conn = DBConnection.getConnection();
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as count FROM Users")) {
                
                if (rs.next()) {
                    int userCount = rs.getInt("count");
                    if (userCount > 0) {
                        out.println("<p class='success'>✅ Users table exists and has " + userCount + " users!</p>");
                    } else {
                        out.println("<p class='error'>❌ Users table exists but is empty!</p>");
                    }
                }
            } catch (Exception e) {
                out.println("<p class='error'>❌ Users table error: " + e.getMessage() + "</p>");
            }
            
            out.println("<h2>5. Recommendations</h2>");
            if (!hasProducts) {
                out.println("<div style='background-color: #fff3cd; padding: 15px; border: 1px solid #ffeaa7; border-radius: 5px;'>");
                out.println("<h3>🚀 To get started:</h3>");
                out.println("<ol>");
                out.println("<li>Run the SQL script: <code>missing_tables.sql</code></li>");
                out.println("<li>This will create sample products, categories, and other data</li>");
                out.println("<li>Then you can test the product detail page at: <a href='/WEBGMS/product/1'>/WEBGMS/product/1</a></li>");
                out.println("</ol>");
                out.println("</div>");
            } else {
                out.println("<div style='background-color: #d4edda; padding: 15px; border: 1px solid #c3e6cb; border-radius: 5px;'>");
                out.println("<h3>🎉 Database is ready!</h3>");
                out.println("<p>You can now test the application:</p>");
                out.println("<ul>");
                out.println("<li><a href='/WEBGMS/home'>Homepage</a></li>");
                out.println("<li><a href='/WEBGMS/product/1'>Product Detail (ID: 1)</a></li>");
                out.println("<li><a href='/WEBGMS/products'>Products List</a></li>");
                out.println("</ul>");
                out.println("</div>");
            }
            
            out.println("</body>");
            out.println("</html>");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
