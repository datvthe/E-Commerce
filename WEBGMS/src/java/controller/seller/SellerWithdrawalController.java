package controller.seller;

import dao.SellerDAO;
import dao.WithdrawalRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.seller.Seller;
import model.withdrawal.WithdrawalRequest;
import service.RoleBasedAccessControl;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 * Controller xử lý yêu cầu rút tiền của seller
 */
@WebServlet(name = "SellerWithdrawalController", urlPatterns = {"/seller/withdrawal"})
public class SellerWithdrawalController extends HttpServlet {
    
    private WithdrawalRequestDAO withdrawalDAO = new WithdrawalRequestDAO();
    private SellerDAO sellerDAO = new SellerDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        RoleBasedAccessControl rbac = new RoleBasedAccessControl();
        
        // Check if user can access seller features
        if (!rbac.canAccessSeller(request)) {
            response.sendRedirect(request.getContextPath() + "/home?error=access_denied");
            return;
        }
        
        HttpSession session = request.getSession();
        Long userIdLong = (Long) session.getAttribute("userId");
        int userId = userIdLong != null ? userIdLong.intValue() : 0;
        
        // Get seller info
        Seller seller = sellerDAO.getSellerByUserId(userId);
        if (seller == null) {
            response.sendRedirect(request.getContextPath() + "/home?error=seller_not_found");
            return;
        }
        
        long sellerId = seller.getSellerId();
        
        // Get wallet balance - using default for now
        BigDecimal availableBalance = BigDecimal.ZERO;
        
        // Get pending amount
        BigDecimal pendingAmount = withdrawalDAO.getPendingWithdrawalAmount(sellerId);
        
        // Get withdrawal history
        List<WithdrawalRequest> withdrawalHistory = withdrawalDAO.getWithdrawalRequestsBySeller(sellerId);
        
        // Get total withdrawn
        BigDecimal totalWithdrawn = withdrawalDAO.getTotalWithdrawnAmount(sellerId);
        
        // Calculate withdrawable amount
        BigDecimal withdrawableAmount = availableBalance.subtract(pendingAmount);
        if (withdrawableAmount.compareTo(BigDecimal.ZERO) < 0) {
            withdrawableAmount = BigDecimal.ZERO;
        }
        
        // Check if has active pending request
        boolean hasActivePending = withdrawalDAO.hasActivePendingRequest(sellerId);
        
        // Set attributes
        request.setAttribute("seller", seller);
        request.setAttribute("availableBalance", availableBalance);
        request.setAttribute("pendingAmount", pendingAmount);
        request.setAttribute("withdrawableAmount", withdrawableAmount);
        request.setAttribute("totalWithdrawn", totalWithdrawn);
        request.setAttribute("withdrawalHistory", withdrawalHistory);
        request.setAttribute("hasActivePending", hasActivePending);
        
        // Forward to JSP
        request.getRequestDispatcher("/views/seller/seller-withdrawal.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        RoleBasedAccessControl rbac = new RoleBasedAccessControl();
        
        // Check if user can access seller features
        if (!rbac.canAccessSeller(request)) {
            response.sendRedirect(request.getContextPath() + "/home?error=access_denied");
            return;
        }
        
        HttpSession session = request.getSession();
        Long userIdLong = (Long) session.getAttribute("userId");
        int userId = userIdLong != null ? userIdLong.intValue() : 0;
        
        // Get seller info
        Seller seller = sellerDAO.getSellerByUserId(userId);
        if (seller == null) {
            response.sendRedirect(request.getContextPath() + "/home?error=seller_not_found");
            return;
        }
        
        long sellerId = seller.getSellerId();
        
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            handleCreateWithdrawal(request, response, sellerId, userId);
        } else if ("cancel".equals(action)) {
            handleCancelWithdrawal(request, response, sellerId);
        } else {
            response.sendRedirect(request.getContextPath() + "/seller/withdrawal?error=invalid_action");
        }
    }
    
    /**
     * Xử lý tạo yêu cầu rút tiền mới
     */
    private void handleCreateWithdrawal(HttpServletRequest request, HttpServletResponse response, 
                                       long sellerId, int userId) throws IOException {
        try {
            // Check if has active pending request
            if (withdrawalDAO.hasActivePendingRequest(sellerId)) {
                response.sendRedirect(request.getContextPath() + 
                    "/seller/withdrawal?error=already_has_pending");
                return;
            }
            
            // Get form data
            String amountStr = request.getParameter("amount");
            String bankName = request.getParameter("bankName");
            String bankAccountNumber = request.getParameter("bankAccountNumber");
            String bankAccountName = request.getParameter("bankAccountName");
            String requestNote = request.getParameter("requestNote");
            
            // Validate
            if (amountStr == null || bankName == null || bankAccountNumber == null || 
                bankAccountName == null || amountStr.trim().isEmpty() || 
                bankName.trim().isEmpty() || bankAccountNumber.trim().isEmpty() || 
                bankAccountName.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + 
                    "/seller/withdrawal?error=missing_fields");
                return;
            }
            
            BigDecimal amount = new BigDecimal(amountStr);
            
            // Validate amount
            if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                response.sendRedirect(request.getContextPath() + 
                    "/seller/withdrawal?error=invalid_amount");
                return;
            }
            
            // Check minimum withdrawal (100,000 VND)
            BigDecimal minAmount = new BigDecimal("100000");
            if (amount.compareTo(minAmount) < 0) {
                response.sendRedirect(request.getContextPath() + 
                    "/seller/withdrawal?error=amount_too_low");
                return;
            }
            
            // Create withdrawal request
            WithdrawalRequest withdrawalRequest = new WithdrawalRequest();
            withdrawalRequest.setSellerId(sellerId);
            withdrawalRequest.setAmount(amount);
            withdrawalRequest.setBankName(bankName);
            withdrawalRequest.setBankAccountNumber(bankAccountNumber);
            withdrawalRequest.setBankAccountName(bankAccountName);
            withdrawalRequest.setRequestNote(requestNote);
            
            boolean success = withdrawalDAO.createWithdrawalRequest(withdrawalRequest);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + 
                    "/seller/withdrawal?success=request_created");
            } else {
                response.sendRedirect(request.getContextPath() + 
                    "/seller/withdrawal?error=create_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + 
                "/seller/withdrawal?error=invalid_amount_format");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + 
                "/seller/withdrawal?error=system_error");
        }
    }
    
    /**
     * Xử lý hủy yêu cầu rút tiền (chỉ cho pending)
     */
    private void handleCancelWithdrawal(HttpServletRequest request, HttpServletResponse response,
                                       long sellerId) throws IOException {
        try {
            String requestIdStr = request.getParameter("requestId");
            
            if (requestIdStr == null || requestIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + 
                    "/seller/withdrawal?error=missing_request_id");
                return;
            }
            
            Long requestId = Long.parseLong(requestIdStr);
            
            boolean success = withdrawalDAO.deleteWithdrawalRequest(requestId, sellerId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + 
                    "/seller/withdrawal?success=request_cancelled");
            } else {
                response.sendRedirect(request.getContextPath() + 
                    "/seller/withdrawal?error=cancel_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + 
                "/seller/withdrawal?error=invalid_request_id");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + 
                "/seller/withdrawal?error=system_error");
        }
    }
}
