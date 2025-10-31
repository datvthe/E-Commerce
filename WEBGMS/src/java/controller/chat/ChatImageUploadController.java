package controller.chat;

import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.user.Users;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet(
    name = "ChatFileUploadServlet",
    urlPatterns = {"/chat/upload-file", "/chat/upload-image"}
)
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,        // 10MB
    maxRequestSize = 1024 * 1024 * 20      // 20MB
)
public class ChatImageUploadController extends HttpServlet {
    
    private static final String IMAGE_UPLOAD_DIR = "uploads/chat-images";
    private static final String FILE_UPLOAD_DIR = "uploads/chat-files";
    private static final long MAX_IMAGE_SIZE = 5 * 1024 * 1024;  // 5MB
    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024;   // 10MB
    
    @Override
    public void init() {
        System.out.println("======================================");
        System.out.println("ChatFileUploadServlet INITIALIZED");
        System.out.println("URL Patterns: /chat/upload-file, /chat/upload-image");
        System.out.println("Max Image Size: " + (MAX_IMAGE_SIZE / 1024 / 1024) + "MB");
        System.out.println("Max File Size: " + (MAX_FILE_SIZE / 1024 / 1024) + "MB");
        System.out.println("======================================");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("[ChatUpload] ========== FILE UPLOAD REQUEST ==========");
        System.out.println("[ChatUpload] Request URI: " + request.getRequestURI());
        System.out.println("[ChatUpload] Content Type: " + request.getContentType());
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        System.out.println("[ChatUpload] User session: " + (user != null ? user.getUser_id() : "null"));
        
        if (user == null) {
            System.err.println("[ChatUpload] ERROR: User not logged in");
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Please login first");
            return;
        }
        
        try {
            System.out.println("[ChatUpload] Starting file upload process...");
            // Get uploaded file (support both 'image' and 'file' parameter names)
            Part filePart = request.getPart("image");
            System.out.println("[ChatUpload] Checking 'image' part: " + (filePart != null ? "found" : "null"));
            
            if (filePart == null) {
                filePart = request.getPart("file");
                System.out.println("[ChatUpload] Checking 'file' part: " + (filePart != null ? "found" : "null"));
            }
            
            if (filePart == null || filePart.getSize() == 0) {
                System.err.println("[ChatUpload] ERROR: No file uploaded or file is empty");
                sendErrorResponse(response, "No file uploaded");
                return;
            }
            
            System.out.println("[ChatUpload] File part found! Size: " + filePart.getSize() + " bytes");
            
            // Get content type and determine if it's an image or file
            String contentType = filePart.getContentType();
            boolean isImage = contentType != null && contentType.startsWith("image/");
            
            // Validate file size based on type
            long maxSize = isImage ? MAX_IMAGE_SIZE : MAX_FILE_SIZE;
            if (filePart.getSize() > maxSize) {
                sendErrorResponse(response, "File size exceeds " + (maxSize / 1024 / 1024) + "MB limit");
                return;
            }
            
            // Get file extension
            String fileName = getFileName(filePart);
            String fileExtension = getFileExtension(fileName);
            if (fileExtension.isEmpty()) {
                fileExtension = isImage ? ".jpg" : ".dat"; // Default extension
            }
            
            // Generate unique filename
            String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
            
            // Choose upload directory based on file type
            String uploadDirName = isImage ? IMAGE_UPLOAD_DIR : FILE_UPLOAD_DIR;
            
            // Get upload directory path
            String applicationPath = getServletContext().getRealPath("");
            String uploadPath = applicationPath + File.separator + uploadDirName;
            
            // Create directory if it doesn't exist
            File uploadDirFile = new File(uploadPath);
            if (!uploadDirFile.exists()) {
                uploadDirFile.mkdirs();
            }
            
            // Save file
            String filePath = uploadPath + File.separator + uniqueFileName;
            System.out.println("[ChatUpload] Saving file to: " + filePath);
            filePart.write(filePath);
            System.out.println("[ChatUpload] File saved successfully!");
            
            // Generate URL
            String fileUrl = "/" + uploadDirName.replace("\\", "/") + "/" + uniqueFileName;
            System.out.println("[ChatUpload] File URL: " + fileUrl);
            
            // Send success response
            JsonObject jsonResponse = new JsonObject();
            jsonResponse.addProperty("success", true);
            jsonResponse.addProperty("imageUrl", fileUrl);  // Keep as imageUrl for backward compatibility
            jsonResponse.addProperty("fileUrl", fileUrl);
            jsonResponse.addProperty("fileName", uniqueFileName);
            jsonResponse.addProperty("fileType", isImage ? "image" : "file");
            
            System.out.println("[ChatUpload] Success response: " + jsonResponse.toString());
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print(jsonResponse.toString());
            out.flush();
            
            System.out.println("[ChatUpload] ========== UPLOAD COMPLETE ==========");
            
        } catch (Exception e) {
            System.err.println("[ChatUpload] EXCEPTION during upload:");
            e.printStackTrace();
            sendErrorResponse(response, "Upload failed: " + e.getMessage());
        }
    }
    
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        for (String token : contentDisposition.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return "";
    }
    
    private String getFileExtension(String fileName) {
        int lastIndexOf = fileName.lastIndexOf(".");
        if (lastIndexOf == -1) {
            return "";
        }
        return fileName.substring(lastIndexOf);
    }
    
    private void sendErrorResponse(HttpServletResponse response, String message) throws IOException {
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("success", false);
        jsonResponse.addProperty("error", message);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        PrintWriter out = response.getWriter();
        out.print(jsonResponse.toString());
        out.flush();
    }
}

