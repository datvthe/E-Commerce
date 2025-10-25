package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;

public class DBConnection {

<<<<<<< HEAD
    private static final String URL = "jdbc:mysql://localhost:3306/gicungco?zeroDateTimeBehavior=CONVERT_TO_NULL&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8";
=======
    private static final String URL = "jdbc:mysql://localhost:3306/gicungco?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC&zeroDateTimeBehavior=CONVERT_TO_NULL";
>>>>>>> adfffa2ca17758b7b0f2e7aa138910e53f368132
    private static final String USER = "root";
    private static final String PASSWORD = "123456";

    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Kết nối MySQL thành công!");
        } catch (ClassNotFoundException e) {
            System.out.println("Không tìm thấy Driver MySQL: " + e.getMessage());
        } catch (SQLException e) {
            System.out.println("Lỗi kết nối MySQL: " + e.getMessage());
            // Gợi ý thường gặp
            System.out.println("Gợi ý: kiểm tra allowPublicKeyRetrieval, useSSL, serverTimezone, user/password, và DB name (gicungco)");
        }
        return conn;
    }

    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                System.out.println("Đã đóng kết nối MySQL");
            } catch (SQLException e) {
                System.out.println("Lỗi đóng kết nối: " + e.getMessage());
            }
        }
    }

    public static void main(String[] args) {
        Connection conn = DBConnection.getConnection();

        if (conn != null) {
            try {
                String sql = "SELECT user_id, full_name, email FROM gicungco.users LIMIT 5";
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql);

                System.out.println("Kết quả từ bảng Users:");
                while (rs.next()) {
                    long id = rs.getLong("user_id");
                    String name = rs.getString("full_name");
                    String email = rs.getString("email");
                    System.out.println(id + " | " + name + " | " + email);
                }

                DBConnection.closeConnection(conn);

            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            System.out.println("Không thể kết nối đến MySQL.");
        }
    }
}