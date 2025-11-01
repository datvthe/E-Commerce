package controller.order;

import dao.ProductDAO;
import dao.WalletDAO;
import dao.DigitalGoodsCodeDAO;
import model.product.Products;
import model.user.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;

/**
 * InstantCheckoutController - Checkout nhanh cho digital goods
 * Kiểm tra số dư và hiển thị trang xác nhận thanh toán
 */
@WebServlet(name = "InstantCheckoutController", urlPatterns = {"/checkout/instant"})
public class InstantCheckoutController extends HttpServlet {
    
    private final ProductDAO productDAO = new ProductDAO();
    private final WalletDAO walletDAO = new WalletDAO();
    private final DigitalGoodsCodeDAO digitalGoodsDAO = new DigitalGoodsCodeDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        // Check login
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=checkout");
            return;
        }
        
        try {
            // 1. Lấy parameters
            String productIdStr = request.getParameter("productId");
            String quantityStr = request.getParameter("quantity");
            
            if (productIdStr == null || quantityStr == null) {
                request.setAttribute("error", "❌ Thiếu thông tin sản phẩm!");
                request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
                return;
            }
            
            long productId = Long.parseLong(productIdStr);
            int quantity = Integer.parseInt(quantityStr);
            
            // Validate quantity
            if (quantity <= 0 || quantity > 100) {
                request.setAttribute("error", "❌ Số lượng không hợp lệ (1-100)!");
                request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
                return;
            }
            
            // 2. Lấy thông tin sản phẩm
            Products product = productDAO.getProductById(productId);
            
            if (product == null) {
                request.setAttribute("error", "❌ Sản phẩm không tồn tại!");
                request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
                return;
            }
            
            // 3. ✨ Kiểm tra stock (COUNT từ digital_goods_codes)
            int availableStock = digitalGoodsDAO.countAvailableCodes(productId);
            
            System.out.println("🔍 Checking stock for product " + productId + ": " + availableStock + " codes available");
            
            if (availableStock < quantity) {
                request.setAttribute("error", "❌ Sản phẩm đã hết hàng! Còn lại: " + availableStock);
                request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
                return;
            }
            
            // 4. Tính tổng tiền
            BigDecimal unitPrice = product.getPrice();
            BigDecimal totalAmount = unitPrice.multiply(BigDecimal.valueOf(quantity));
            
            // 5. Lấy số dư ví
            double walletBalance = walletDAO.getBalance(user.getUser_id());
            BigDecimal balance = BigDecimal.valueOf(walletBalance);
            
            // 6. Kiểm tra số dư
            if (balance.compareTo(totalAmount) < 0) {
                // THIẾU TIỀN → Chuyển đến trang nạp tiền
                BigDecimal shortfall = totalAmount.subtract(balance);
                
                request.setAttribute("requiredAmount", totalAmount);
                request.setAttribute("currentBalance", balance);
                request.setAttribute("shortfall", shortfall);
                request.setAttribute("product", product);
                request.setAttribute("quantity", quantity);
                request.setAttribute("productId", productId);
                
                request.getRequestDispatcher("/views/user/wallet-deposit-required.jsp").forward(request, response);
                return;
            }
            
            // 7. ĐỦ TIỀN → Hiển thị trang xác nhận thanh toán
            BigDecimal balanceAfter = balance.subtract(totalAmount);
            
            request.setAttribute("product", product);
            request.setAttribute("quantity", quantity);
            request.setAttribute("unitPrice", unitPrice);
            request.setAttribute("totalAmount", totalAmount);
            request.setAttribute("currentBalance", balance);
            request.setAttribute("balanceAfter", balanceAfter);
            request.setAttribute("availableStock", availableStock);
            
            request.getRequestDispatcher("/views/user/checkout-instant.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "❌ Dữ liệu không hợp lệ!");
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "❌ Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
        }
    }
}

