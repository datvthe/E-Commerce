<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Categories</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { padding: 20px; }
        .category-box { 
            border: 1px solid #ddd; 
            padding: 20px; 
            margin: 10px; 
            border-radius: 8px;
        }
        .category-box:hover { 
            background: #f8f9fa; 
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Categories</h1>
        
        <div class="row">
            <c:forEach var="category" items="${parentCategories}">
                <div class="col-md-4">
                    <div class="category-box">
                        <h3>${category.name}</h3>
                        <p>Products: ${category.productCount}</p>
                        <a href="${pageContext.request.contextPath}/products?category=${category.slug}" class="btn btn-primary">View</a>
                    </div>
                </div>
            </c:forEach>
        </div>
        
        <c:if test="${empty parentCategories}">
            <p>No categories found.</p>
        </c:if>
    </div>
</body>
</html>
