package controller.admin;

import dao.ReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.RoleBasedAccessControl;

import java.io.IOException;

@WebServlet(name = "AdminReviewController", urlPatterns = {"/admin/cms/reviews"})
public class AdminReviewController extends HttpServlet {

    private final ReviewDAO reviewDAO = new ReviewDAO();
    private final RoleBasedAccessControl rbac = new RoleBasedAccessControl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!rbac.isAdminOrModerator(request)) { response.sendRedirect(request.getContextPath()+"/home?error=access_denied"); return; }
        String status = request.getParameter("status"); // visible/hidden
        int page = parseInt(request.getParameter("page"), 1);
        int pageSize = parseInt(request.getParameter("pageSize"), 20);
        request.setAttribute("reviews", reviewDAO.listAll(status, page, pageSize));
        request.getRequestDispatcher("/views/admin/cms-reviews.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!rbac.isAdminOrModerator(request)) { response.sendRedirect(request.getContextPath()+"/home?error=access_denied"); return; }
        String action = request.getParameter("action");
        int id = parseInt(request.getParameter("id"), 0);
        if ("show".equals(action)) {
            reviewDAO.updateStatus(id, "visible");
        } else if ("hide".equals(action)) {
            reviewDAO.updateStatus(id, "hidden");
        }
        response.sendRedirect(request.getContextPath()+"/admin/cms/reviews");
    }

    private int parseInt(String s, int d) { try { return Integer.parseInt(s); } catch (Exception e) { return d; } }
}
