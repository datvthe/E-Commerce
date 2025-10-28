package controller.user;

import dao.PostDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.cms.Post;

@WebServlet(name = "BlogController", urlPatterns = {"/blog", "/blog/detail"})
public class BlogController extends HttpServlet {

    private final PostDAO postDAO = new PostDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/blog".equals(path)) {
            String q = request.getParameter("q");
            String type = request.getParameter("type"); // news/tutorial/blog
            int page = parseInt(request.getParameter("page"), 1);
            int pageSize = 10;
            List<Post> posts = postDAO.list(type, "published", q, page, pageSize);
            request.setAttribute("posts", posts);
            request.setAttribute("q", q);
            request.setAttribute("type", type);
            request.getRequestDispatcher("/views/user/blog-list.jsp").forward(request, response);
            return;
        }
        if ("/blog/detail".equals(path)) {
            int id = parseInt(request.getParameter("id"), 0);
            Post post = postDAO.findById(id);
            if (post == null || (post.getStatus()!=null && !post.getStatus().equals("published"))) {
                response.sendRedirect(request.getContextPath()+"/blog");
                return;
            }
            request.setAttribute("post", post);
            request.getRequestDispatcher("/views/user/blog-detail.jsp").forward(request, response);
        }
    }

    private int parseInt(String s, int def) { try { return Integer.parseInt(s); } catch (Exception e) { return def; } }
}