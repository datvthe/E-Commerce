package controller.seller;

import dao.SellerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

import model.user.Users;

@WebServlet("/seller/deposit")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 5 * 1024 * 1024, // 5MB
        maxRequestSize = 10 * 1024 * 1024) // 10MB
public class SellerDepositController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users user = (Users) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Nhận file biên lai chuyển khoản
        Part filePart = request.getPart("depositProof");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

        // Đường dẫn lưu file upload
        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "deposits";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        // Ghi file vào thư mục upload
        filePart.write(uploadPath + File.separator + fileName);

        // Lấy số tiền nộp từ form
        double amount = Double.parseDouble(request.getParameter("depositAmount"));

        // Cập nhật database
        SellerDAO dao = new SellerDAO();
        boolean success = dao.updateDeposit(user.getUser_id(), amount, fileName);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/views/seller/deposit-success.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/seller/deposit.jsp?error=fail");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu user truy cập trực tiếp, chuyển về form nộp tiền
        request.getRequestDispatcher("/views/seller/deposit.jsp").forward(request, response);
    }
}
