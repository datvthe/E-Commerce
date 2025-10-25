<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lỗi - Gicungco</title>
    <style>
        body {
            font-family: "Poppins", sans-serif;
            background-color: #fff8f2;
            margin: 0;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
        }
        
        .error-container {
            text-align: center;
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            max-width: 500px;
        }
        
        .error-icon {
            font-size: 64px;
            color: #ff6600;
            margin-bottom: 20px;
        }
        
        .error-title {
            color: #333;
            font-size: 24px;
            margin-bottom: 15px;
        }
        
        .error-message {
            color: #666;
            font-size: 16px;
            margin-bottom: 30px;
        }
        
        .btn {
            background: #ff6600;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            display: inline-block;
            transition: background 0.3s;
        }
        
        .btn:hover {
            background: #e65c00;
            color: white;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">⚠️</div>
        <h1 class="error-title">Có lỗi xảy ra</h1>
        <p class="error-message">
            <c:choose>
                <c:when test="${not empty error}">
                    ${error}
                </c:when>
                <c:otherwise>
                    Đã xảy ra lỗi không mong muốn. Vui lòng thử lại sau.
                </c:otherwise>
            </c:choose>
        </p>
        <a href="${pageContext.request.contextPath}/seller/dashboard" class="btn">Quay về trang chủ</a>
    </div>
</body>
</html>
