package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.cms.Page;
import model.user.Users;
import service.RoleBasedAccessControl;

import java.io.IOException;

@WebServlet(name = "AdminPageController", urlPatterns = {"/admin/cms/pages"})
public class AdminPageController extends HttpServlet {

    private final RoleBasedAccessControl rbac = new RoleBasedAccessControl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!rbac.isAdmin(request)) { response.sendRedirect(request.getContextPath()+"/home?error=access_denied"); return; }
        String slug = param(request, "slug", "about"); // default to about page
        Page page = new dao.PageDAO().findBySlug(slug);
        if (page == null) {
            page = new Page();
            page.setSlug(slug);
            page.setTitle(capitalize(slug.replace('-', ' ')));
            page.setStatus("draft");
        }
        request.setAttribute("pageData", page);
        request.getRequestDispatcher("/views/admin/cms-page-form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!rbac.isAdmin(request)) { response.sendRedirect(request.getContextPath()+"/home?error=access_denied"); return; }
        request.setCharacterEncoding("UTF-8");
        String slug = param(request, "slug", "about");
        String title = param(request, "title", "");
        String content = param(request, "content", "");
        String status = param(request, "status", "draft");
        HttpSession session = request.getSession(false);
        Users current = (Users) (session != null ? session.getAttribute("user") : null);

        Page page = new Page();
        page.setSlug(slug);
        page.setTitle(title);
        page.setContent(content);
        page.setStatus(status);
        page.setUpdatedBy(current);

        boolean ok = new dao.PageDAO().upsert(page);
        if (ok) {
            response.sendRedirect(request.getContextPath()+"/admin/cms/pages?slug="+slug+"&saved=1");
        } else {
            request.setAttribute("error", "Failed to save page");
            request.setAttribute("pageData", page);
            request.getRequestDispatcher("/views/admin/cms-page-form.jsp").forward(request, response);
        }
    }

    private String param(HttpServletRequest r, String k, String d) { String v = r.getParameter(k); return v==null?d:v; }
    private String capitalize(String s) { if (s==null||s.isEmpty()) return s; return s.substring(0,1).toUpperCase()+s.substring(1); }
}
