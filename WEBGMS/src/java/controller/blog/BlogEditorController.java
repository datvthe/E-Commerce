package controller.blog;

import dao.BlogDAO;
import model.blog.Blog;
import model.user.Users;

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

/**
 * Controller tạo/sửa blog
 * - Tạo blog mới (DRAFT hoặc PENDING)
 * - Sửa blog (chỉ được sửa DRAFT hoặc REJECTED)
 * - Upload featured image
 * - Auto-generate slug from title
 */
@WebServlet("/user/blog-editor")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class BlogEditorController extends HttpServlet {
    
    private BlogDAO blogDAO = new BlogDAO();
    private static final String UPLOAD_DIR = "assets/img/blog";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        // Check login
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            String blogIdStr = request.getParameter("id");
            
            if (blogIdStr != null && !blogIdStr.isEmpty()) {
                // Edit mode
                Long blogId = Long.parseLong(blogIdStr);
                Blog blog = blogDAO.getBlogById(blogId);
                
                // Check ownership
                if (blog == null || blog.getUserId() != user.getUser_id()) {
                    response.sendRedirect(request.getContextPath() + "/user/my-blogs?error=not_found");
                    return;
                }
                
                // Check editable
                if (!blog.isEditable()) {
                    response.sendRedirect(request.getContextPath() + "/user/my-blogs?error=not_editable");
                    return;
                }
                
                request.setAttribute("blog", blog);
                request.setAttribute("mode", "edit");
            } else {
                // Create mode
                request.setAttribute("mode", "create");
            }
            
            request.getRequestDispatcher("/views/user/blog-editor.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/my-blogs?error=" + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        // Check login
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            String mode = request.getParameter("mode");
            String blogIdStr = request.getParameter("blogId");
            
            // Get form data
            String title = request.getParameter("title");
            String summary = request.getParameter("summary");
            String content = request.getParameter("content");
            String status = request.getParameter("status"); // DRAFT or PENDING
            String metaTitle = request.getParameter("metaTitle");
            String metaDescription = request.getParameter("metaDescription");
            String metaKeywords = request.getParameter("metaKeywords");
            
            // Validation
            if (title == null || title.trim().isEmpty()) {
                request.setAttribute("error", "Tiêu đề không được để trống");
                request.getRequestDispatcher("/views/user/blog-editor.jsp").forward(request, response);
                return;
            }
            
            if (content == null || content.trim().isEmpty()) {
                request.setAttribute("error", "Nội dung không được để trống");
                request.getRequestDispatcher("/views/user/blog-editor.jsp").forward(request, response);
                return;
            }
            
            // Generate slug
            String baseSlug = Blog.generateSlug(title);
            Long excludeBlogId = (blogIdStr != null && !blogIdStr.isEmpty()) ? Long.parseLong(blogIdStr) : null;
            String slug = blogDAO.generateUniqueSlug(baseSlug, excludeBlogId);
            
            // Handle file upload (featured image)
            String featuredImage = null;
            Part filePart = request.getPart("featuredImage");
            if (filePart != null && filePart.getSize() > 0) {
                featuredImage = uploadFile(filePart, request);
            } else if ("edit".equals(mode)) {
                // Keep existing image
                featuredImage = request.getParameter("existingImage");
            }
            
            if ("edit".equals(mode) && blogIdStr != null) {
                // UPDATE existing blog
                Long blogId = Long.parseLong(blogIdStr);
                Blog existingBlog = blogDAO.getBlogById(blogId);
                
                // Check ownership and editable
                if (existingBlog == null || existingBlog.getUserId() != user.getUser_id()) {
                    response.sendRedirect(request.getContextPath() + "/user/my-blogs?error=not_owner");
                    return;
                }
                
                if (!existingBlog.isEditable()) {
                    response.sendRedirect(request.getContextPath() + "/user/my-blogs?error=not_editable");
                    return;
                }
                
                // Update blog
                Blog blog = new Blog();
                blog.setBlogId(blogId);
                blog.setUserId(user.getUser_id());
                blog.setTitle(title);
                blog.setSlug(slug);
                blog.setSummary(summary);
                blog.setContent(content);
                blog.setFeaturedImage(featuredImage);
                blog.setStatus(status);
                blog.setMetaTitle(metaTitle);
                blog.setMetaDescription(metaDescription);
                blog.setMetaKeywords(metaKeywords);
                
                boolean success = blogDAO.updateBlog(blog);
                
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/user/my-blogs?success=updated");
                } else {
                    request.setAttribute("error", "Cập nhật blog thất bại");
                    request.getRequestDispatcher("/views/user/blog-editor.jsp").forward(request, response);
                }
                
            } else {
                // CREATE new blog
                Blog blog = new Blog();
                blog.setUserId(user.getUser_id());
                blog.setTitle(title);
                blog.setSlug(slug);
                blog.setSummary(summary);
                blog.setContent(content);
                blog.setFeaturedImage(featuredImage);
                blog.setStatus(status);
                blog.setMetaTitle(metaTitle);
                blog.setMetaDescription(metaDescription);
                blog.setMetaKeywords(metaKeywords);
                
                Long blogId = blogDAO.createBlog(blog);
                
                if (blogId != null) {
                    response.sendRedirect(request.getContextPath() + "/user/my-blogs?success=created");
                } else {
                    request.setAttribute("error", "Tạo blog thất bại");
                    request.getRequestDispatcher("/views/user/blog-editor.jsp").forward(request, response);
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("/views/user/blog-editor.jsp").forward(request, response);
        }
    }
    
    /**
     * Upload file and return file path
     */
    private String uploadFile(Part filePart, HttpServletRequest request) throws IOException {
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String timestamp = String.valueOf(System.currentTimeMillis());
        String newFileName = timestamp + "_" + fileName;
        
        // Get upload path
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadPath = applicationPath + File.separator + UPLOAD_DIR;
        
        // Create directory if not exists
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        // Save file
        String filePath = uploadPath + File.separator + newFileName;
        filePart.write(filePath);
        
        // Return relative path for database
        return "/" + UPLOAD_DIR + "/" + newFileName;
    }
}

