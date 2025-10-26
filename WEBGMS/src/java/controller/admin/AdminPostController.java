package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.cms.Post;
import model.user.Users;
import service.RoleBasedAccessControl;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminPostController", urlPatterns = {"/admin/cms/posts"})
public class AdminPostController extends HttpServlet {

    private final RoleBasedAccessControl rbac = new RoleBasedAccessControl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!rbac.isAdmin(request)) { response.sendRedirect(request.getContextPath()+"/home?error=access_denied"); return; }
        String action = request.getParameter("action");
        if (action == null || action.equals("list")) {
            String type = request.getParameter("type");
            String status = request.getParameter("status");
            String q = request.getParameter("q");
            int page = parseInt(request.getParameter("page"), 1);
            int pageSize = parseInt(request.getParameter("pageSize"), 20);
            List<Post> posts = new dao.PostDAO().list(type, status, q, page, pageSize);
            request.setAttribute("posts", posts);
            request.getRequestDispatcher("/views/admin/cms-posts.jsp").forward(request, response);
        } else if (action.equals("create")) {
            request.setAttribute("mode", "create");
            request.getRequestDispatcher("/views/admin/cms-post-form.jsp").forward(request, response);
        } else if (action.equals("edit")) {
            int id = parseInt(request.getParameter("id"), 0);
            Post p = new dao.PostDAO().findById(id);
            request.setAttribute("post", p);
            request.setAttribute("mode", "edit");
            request.getRequestDispatcher("/views/admin/cms-post-form.jsp").forward(request, response);
        } else if (action.equals("delete")) {
            int id = parseInt(request.getParameter("id"), 0);
            new dao.PostDAO().delete(id);
            response.sendRedirect(request.getContextPath()+"/admin/cms/posts");
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!rbac.isAdmin(request)) { response.sendRedirect(request.getContextPath()+"/home?error=access_denied"); return; }
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        Users current = (Users) (session != null ? session.getAttribute("user") : null);
        if (current == null) { response.sendRedirect(request.getContextPath()+"/home?error=login_required"); return; }

        if ("save".equals(action)) {
            int id = parseInt(request.getParameter("id"), 0);
            String type = nv(request.getParameter("type"));
            String title = nv(request.getParameter("title"));
            String slug = nv(request.getParameter("slug"));
            String excerpt = nv(request.getParameter("excerpt"));
            String content = nv(request.getParameter("content"));
            String status = nv(request.getParameter("status"));

            Post p = new Post();
            p.setId(id);
            p.setType(type);
            p.setTitle(title);
            p.setSlug(slug);
            p.setExcerpt(excerpt);
            p.setContent(content);
            p.setStatus(status);
            p.setAuthor(current);

            boolean ok = (id == 0) ? new dao.PostDAO().create(p) : new dao.PostDAO().update(p);
            if (ok) {
                response.sendRedirect(request.getContextPath()+"/admin/cms/posts");
            } else {
                request.setAttribute("error", "Failed to save post");
                request.setAttribute("post", p);
                request.getRequestDispatcher("/views/admin/cms-post-form.jsp").forward(request, response);
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    private int parseInt(String s, int def) { try { return Integer.parseInt(s); } catch (Exception e) { return def; } }
    private String nv(String s) { return s == null ? "" : s.trim(); }
}
