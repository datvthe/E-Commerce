package controller.admin;

import dao.WithdrawalRequestDAO;
import dao.WalletDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.withdrawal.WithdrawalRequest;
import service.RoleBasedAccessControl;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 * Controller xử lý yêu cầu rút tiền cho admin
 */
@WebServlet(name = "AdminWithdrawalController", urlPatterns = {"/admin/withdrawals"})
public class AdminWithdrawalController extends HttpServlet {
    
    private WithdrawalRequestDAO withdrawalDAO = new WithdrawalRequestDAO();
    private WalletDAO walletDAO = new WalletDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        RoleBasedAccessControl rbac = new RoleBasedAccessControl();
        
        // Check if user is admin
        if (!rbac.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/home?error=access_denied");
            return;
        }
        
        String action = request.getParameter("action");
        String status = request.getParameter("status");
        
        if ("detail".equals(action)) {
            showWithdrawalDetail(request, response);
        } else {
            showWithdrawalList(request, response, status);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        RoleBasedAccessControl rbac = new RoleBasedAccessControl();
        
        // Check if user is admin
        if (!rbac.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/home?error=access_denied");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("approve".equals(action)) {
            handleApproveWithdrawal(request, response);
        } else if ("reject".equals(action)) {
            handleRejectWithdrawal(request, response);
        } else if ("complete".equals(action)) {
            handleCompleteWithdrawal(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/withdrawals?error=invalid_action");
        }
    }
    
    /**
     * Hiển thị danh sách yêu cầu rút tiền
     */
    private void showWithdrawalList(HttpServletRequest request, HttpServletResponse response, String status)
            throws ServletException, IOException {
        
        List<WithdrawalRequest> withdrawalRequests;
        
        if (status != null && !status.isEmpty()) {
            withdrawalRequests = withdrawalDAO.getWithdrawalRequestsByStatus(status);
        } else {
            withdrawalRequests = withdrawalDAO.getAllWithdrawalRequests();
        }
        
        // Count by status
        int pendingCount = withdrawalDAO.countPendingRequests();
        
        request.setAttribute("withdrawalRequests", withdrawalRequests);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("currentFilter", status != null ? status : "all");
        
        request.getRequestDispatcher("/views/admin/admin-withdrawals.jsp").forward(request, response);
    }
    
    /**
     * Hiển thị chi tiết yêu cầu rút tiền
     */
    private void showWithdrawalDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String requestIdStr = request.getParameter("id");
        
        if (requestIdStr == null || requestIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/withdrawals?error=missing_id");
            return;
        }
        
        try {
            Long requestId = Long.parseLong(requestIdStr);
            WithdrawalRequest withdrawalRequest = withdrawalDAO.getWithdrawalRequestById(requestId);
            
            if (withdrawalRequest == null) {
                response.sendRedirect(request.getContextPath() + "/admin/withdrawals?error=not_found");
                return;
            }
            
            request.setAttribute("withdrawalRequest", withdrawalRequest);
            request.getRequestDispatcher("/views/admin/admin-withdrawal-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/withdrawals?error=invalid_id");
        }
    }
    
    /**
     * Xử lý phê duyệt yêu cầu rút tiền
     */
    private void handleApproveWithdrawal(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        HttpSession session = request.getSession();
        Long adminId = (Long) session.getAttribute("userId");
        
        String requestIdStr = request.getParameter("requestId");
        String adminNote = request.getParameter("adminNote");
        
        if (requestIdStr == null || requestIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/withdrawals?error=missing_id");
            return;
        }
        
        try {
            Long requestId = Long.parseLong(requestIdStr);
            
            // Update status to approved
            boolean success = withdrawalDAO.updateWithdrawalStatus(
                requestId, 
                "approved", 
                adminId, 
                adminNote != null ? adminNote : "Đã phê duyệt", 
                null
            );
            
            if (success) {
                // TODO: Send notification to seller
                response.sendRedirect(request.getContextPath() + 
                    "/admin/withdrawals?success=approved");
            } else {
                response.sendRedirect(request.getContextPath() + 
                    "/admin/withdrawals?error=approve_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + 
                "/admin/withdrawals?error=invalid_id");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + 
                "/admin/withdrawals?error=system_error");
        }
    }
    
    /**
     * Xử lý từ chối yêu cầu rút tiền
     */
    private void handleRejectWithdrawal(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        HttpSession session = request.getSession();
        Long adminId = (Long) session.getAttribute("userId");
        
        String requestIdStr = request.getParameter("requestId");
        String adminNote = request.getParameter("adminNote");
        
        if (requestIdStr == null || requestIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/withdrawals?error=missing_id");
            return;
        }
        
        if (adminNote == null || adminNote.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + 
                "/admin/withdrawals?error=missing_reject_reason");
            return;
        }
        
        try {
            Long requestId = Long.parseLong(requestIdStr);
            
            // Update status to rejected
            boolean success = withdrawalDAO.updateWithdrawalStatus(
                requestId, 
                "rejected", 
                adminId, 
                adminNote, 
                null
            );
            
            if (success) {
                // TODO: Send notification to seller
                response.sendRedirect(request.getContextPath() + 
                    "/admin/withdrawals?success=rejected");
            } else {
                response.sendRedirect(request.getContextPath() + 
                    "/admin/withdrawals?error=reject_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + 
                "/admin/withdrawals?error=invalid_id");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + 
                "/admin/withdrawals?error=system_error");
        }
    }
    
    /**
     * Xử lý hoàn thành chuyển tiền (sau khi đã chuyển khoản thành công)
     */
    private void handleCompleteWithdrawal(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        HttpSession session = request.getSession();
        Long adminId = (Long) session.getAttribute("userId");
        
        String requestIdStr = request.getParameter("requestId");
        String transactionRef = request.getParameter("transactionRef");
        String adminNote = request.getParameter("adminNote");
        
        if (requestIdStr == null || requestIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/withdrawals?error=missing_id");
            return;
        }
        
        if (transactionRef == null || transactionRef.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + 
                "/admin/withdrawals?error=missing_transaction_ref");
            return;
        }
        
        try {
            Long requestId = Long.parseLong(requestIdStr);
            
            // Get withdrawal request to get seller and amount info
            WithdrawalRequest withdrawalRequest = withdrawalDAO.getWithdrawalRequestById(requestId);
            
            if (withdrawalRequest == null) {
                response.sendRedirect(request.getContextPath() + 
                    "/admin/withdrawals?error=not_found");
                return;
            }
            
            // Update status to completed
            boolean success = withdrawalDAO.updateWithdrawalStatus(
                requestId, 
                "completed", 
                adminId, 
                adminNote != null ? adminNote : "Đã chuyển tiền thành công", 
                transactionRef
            );
            
            if (success) {
                // TODO: Deduct from seller's wallet
                // TODO: Send notification to seller
                response.sendRedirect(request.getContextPath() + 
                    "/admin/withdrawals?success=completed");
            } else {
                response.sendRedirect(request.getContextPath() + 
                    "/admin/withdrawals?error=complete_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + 
                "/admin/withdrawals?error=invalid_id");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + 
                "/admin/withdrawals?error=system_error");
        }
    }
}

