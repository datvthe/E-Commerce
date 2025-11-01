<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${mode == 'edit' ? 'Sửa blog' : 'Tạo blog mới'} - GiCungCo</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 2rem 0;
        }
        
        .editor-container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .editor-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            text-align: center;
        }
        
        .editor-body {
            padding: 2rem;
        }
        
        .form-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 0.5rem;
        }
        
        .form-control, .form-select {
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            padding: 0.75rem;
            transition: all 0.3s;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 0.75rem 2rem;
            font-weight: 600;
            border-radius: 8px;
            transition: transform 0.3s;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-secondary {
            background: #6c757d;
            border: none;
            padding: 0.75rem 2rem;
            font-weight: 600;
            border-radius: 8px;
        }
        
        .image-preview {
            max-width: 300px;
            max-height: 200px;
            border-radius: 8px;
            margin-top: 1rem;
            display: none;
        }
        
        .slug-preview {
            font-size: 0.875rem;
            color: #667eea;
            margin-top: 0.5rem;
            font-family: monospace;
        }
        
        .char-count {
            font-size: 0.875rem;
            color: #6c757d;
            text-align: right;
            margin-top: 0.25rem;
        }
        
        .section-divider {
            border-top: 2px dashed #e0e0e0;
            margin: 2rem 0;
        }
    </style>
</head>
<body>
    <div class="editor-container">
        <!-- Header -->
        <div class="editor-header">
            <h1 class="mb-0">
                <i class="fas fa-edit me-2"></i>
                ${mode == 'edit' ? 'Sửa Blog' : 'Tạo Blog Mới'}
            </h1>
            <p class="mb-0 mt-2" style="opacity: 0.9;">
                ${mode == 'edit' ? 'Chỉnh sửa nội dung blog của bạn' : 'Chia sẻ kiến thức và trải nghiệm của bạn'}
            </p>
        </div>
        
        <!-- Body -->
        <div class="editor-body">
            <!-- Error Message -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            
            <!-- Form -->
            <form action="${pageContext.request.contextPath}/user/blog-editor" 
                  method="post" 
                  enctype="multipart/form-data"
                  id="blogForm">
                
                <input type="hidden" name="mode" value="${mode}">
                <c:if test="${mode == 'edit'}">
                    <input type="hidden" name="blogId" value="${blog.blogId}">
                    <input type="hidden" name="existingImage" value="${blog.featuredImage}">
                </c:if>
                
                <!-- Basic Information -->
                <h4 class="mb-3"><i class="fas fa-info-circle me-2"></i>Thông tin cơ bản</h4>
                
                <!-- Title -->
                <div class="mb-3">
                    <label for="title" class="form-label">
                        Tiêu đề <span class="text-danger">*</span>
                    </label>
                    <input type="text" 
                           class="form-control" 
                           id="title" 
                           name="title" 
                           value="${blog.title}"
                           placeholder="Nhập tiêu đề blog..."
                           required
                           maxlength="255"
                           onkeyup="updateSlugPreview(); countChars('title', 255);">
                    <div class="slug-preview" id="slugPreview"></div>
                    <div class="char-count" id="titleCount">0 / 255</div>
                </div>
                
                <!-- Summary -->
                <div class="mb-3">
                    <label for="summary" class="form-label">
                        Tóm tắt <span class="text-muted">(Hiển thị trên card blog)</span>
                    </label>
                    <textarea class="form-control" 
                              id="summary" 
                              name="summary" 
                              rows="3"
                              placeholder="Viết tóm tắt ngắn gọn về blog..."
                              maxlength="500"
                              onkeyup="countChars('summary', 500);">${blog.summary}</textarea>
                    <div class="char-count" id="summaryCount">0 / 500</div>
                </div>
                
                <!-- Featured Image -->
                <div class="mb-3">
                    <label for="featuredImage" class="form-label">
                        Ảnh đại diện
                    </label>
                    <input type="file" 
                           class="form-control" 
                           id="featuredImage" 
                           name="featuredImage"
                           accept="image/*"
                           onchange="previewImage(event);">
                    <c:if test="${not empty blog.featuredImage}">
                        <img src="${pageContext.request.contextPath}${blog.featuredImage}" 
                             alt="Current Image" 
                             class="image-preview"
                             id="existingImage"
                             style="display: block;">
                    </c:if>
                    <img id="imagePreview" class="image-preview" alt="Preview">
                </div>
                
                <div class="section-divider"></div>
                
                <!-- Content -->
                <h4 class="mb-3"><i class="fas fa-file-alt me-2"></i>Nội dung</h4>
                
                <div class="mb-3">
                    <label for="content" class="form-label">
                        Nội dung blog <span class="text-danger">*</span>
                    </label>
                    <textarea id="content" name="content" required>${blog.content}</textarea>
                </div>
                
                <div class="section-divider"></div>
                
                <!-- SEO Settings (Optional) -->
                <div class="mb-3">
                    <button class="btn btn-link text-decoration-none" type="button" 
                            data-bs-toggle="collapse" data-bs-target="#seoSettings">
                        <i class="fas fa-search me-2"></i>Cài đặt SEO (Tùy chọn)
                        <i class="fas fa-chevron-down ms-2"></i>
                    </button>
                </div>
                
                <div class="collapse" id="seoSettings">
                    <div class="mb-3">
                        <label for="metaTitle" class="form-label">Meta Title</label>
                        <input type="text" class="form-control" id="metaTitle" name="metaTitle" 
                               value="${blog.metaTitle}" maxlength="255">
                    </div>
                    
                    <div class="mb-3">
                        <label for="metaDescription" class="form-label">Meta Description</label>
                        <textarea class="form-control" id="metaDescription" name="metaDescription" 
                                  rows="2" maxlength="500">${blog.metaDescription}</textarea>
                    </div>
                    
                    <div class="mb-3">
                        <label for="metaKeywords" class="form-label">
                            Meta Keywords <span class="text-muted">(Cách nhau bởi dấu phẩy)</span>
                        </label>
                        <input type="text" class="form-control" id="metaKeywords" name="metaKeywords" 
                               value="${blog.metaKeywords}" placeholder="gaming, technology, tips">
                    </div>
                </div>
                
                <div class="section-divider"></div>
                
                <!-- Actions -->
                <div class="d-flex justify-content-between align-items-center">
                    <a href="${pageContext.request.contextPath}/user/my-blogs" 
                       class="btn btn-secondary">
                        <i class="fas fa-times me-2"></i>Hủy
                    </a>
                    
                    <div>
                        <button type="submit" name="status" value="DRAFT" 
                                class="btn btn-outline-primary me-2">
                            <i class="fas fa-save me-2"></i>Lưu nháp
                        </button>
                        <button type="submit" name="status" value="PENDING" 
                                class="btn btn-primary">
                            <i class="fas fa-paper-plane me-2"></i>Gửi phê duyệt
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
    
    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- TinyMCE -->
    <script src="https://cdn.jsdelivr.net/npm/tinymce@6/tinymce.min.js" referrerpolicy="origin"></script>
    
    <script>
        // Initialize TinyMCE
        tinymce.init({
            selector: '#content',
            height: 500,
            menubar: true,
            plugins: [
                'advlist', 'autolink', 'lists', 'link', 'image', 'charmap', 'preview',
                'anchor', 'searchreplace', 'visualblocks', 'code', 'fullscreen',
                'insertdatetime', 'media', 'table', 'code', 'help', 'wordcount'
            ],
            toolbar: 'undo redo | blocks | ' +
                'bold italic forecolor | alignleft aligncenter ' +
                'alignright alignjustify | bullist numlist outdent indent | ' +
                'removeformat | link image | code | help',
            content_style: 'body { font-family:Helvetica,Arial,sans-serif; font-size:14px }',
            language: 'vi',
            branding: false,
            promotion: false,
            setup: function(editor) {
                editor.on('change', function() {
                    editor.save();
                });
            }
        });
        
        // Slug preview
        function updateSlugPreview() {
            const title = document.getElementById('title').value;
            const slug = generateSlug(title);
            const preview = document.getElementById('slugPreview');
            
            if (slug) {
                const baseUrl = '${pageContext.request.contextPath}/blog/';
                preview.textContent = 'URL: ' + baseUrl + slug;
                preview.style.display = 'block';
            } else {
                preview.style.display = 'none';
            }
        }
        
        // Generate slug from title
        function generateSlug(title) {
            if (!title) return '';
            
            return title.toLowerCase()
                .trim()
                .replace(/[àáạảãâầấậẩẫăằắặẳẵ]/g, 'a')
                .replace(/[èéẹẻẽêềếệểễ]/g, 'e')
                .replace(/[ìíịỉĩ]/g, 'i')
                .replace(/[òóọỏõôồốộổỗơờớợởỡ]/g, 'o')
                .replace(/[ùúụủũưừứựửữ]/g, 'u')
                .replace(/[ỳýỵỷỹ]/g, 'y')
                .replace(/[đ]/g, 'd')
                .replace(/[^a-z0-9\s-]/g, '')
                .replace(/\s+/g, '-')
                .replace(/-+/g, '-')
                .replace(/^-|-$/g, '');
        }
        
        // Character counter
        function countChars(fieldId, max) {
            const field = document.getElementById(fieldId);
            const counter = document.getElementById(fieldId + 'Count');
            const length = field.value.length;
            counter.textContent = length + ' / ' + max;
            
            if (length > max * 0.9) {
                counter.style.color = '#dc3545';
            } else {
                counter.style.color = '#6c757d';
            }
        }
        
        // Image preview
        function previewImage(event) {
            const preview = document.getElementById('imagePreview');
            const existingImage = document.getElementById('existingImage');
            const file = event.target.files[0];
            
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                    if (existingImage) {
                        existingImage.style.display = 'none';
                    }
                };
                reader.readAsDataURL(file);
            }
        }
        
        // Form validation
        document.getElementById('blogForm').addEventListener('submit', function(e) {
            // Trigger TinyMCE to save content to textarea
            if (tinymce && tinymce.get('content')) {
                tinymce.get('content').save();
            }
            
            const title = document.getElementById('title').value.trim();
            
            if (!title) {
                e.preventDefault();
                alert('Vui lòng nhập tiêu đề blog!');
                return false;
            }
            
            // Get TinyMCE content
            let content = '';
            if (tinymce && tinymce.get('content')) {
                content = tinymce.get('content').getContent();
            } else {
                content = document.getElementById('content').value;
            }
            
            if (!content || content.trim() === '' || content === '<p></p>' || content === '<p><br></p>') {
                e.preventDefault();
                alert('Vui lòng nhập nội dung blog!');
                return false;
            }
            
            // Allow form to submit
            return true;
        });
        
        // Initialize character counters
        window.addEventListener('load', function() {
            countChars('title', 255);
            countChars('summary', 500);
            updateSlugPreview();
        });
    </script>
</body>
</html>

