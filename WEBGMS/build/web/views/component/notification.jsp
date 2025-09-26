<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${not empty requestScope.message or not empty requestScope.error}">
    <div id="popupMessage"
         class="popup-message"
         style="background-color: ${not empty requestScope.message ? '#d4edda' : '#f8d7da'};
         color: ${not empty requestScope.message ? '#155724' : '#721c24'};">
        <c:choose>
            <c:when test="${not empty requestScope.message}">✅ ${requestScope.message}</c:when>
            <c:when test="${not empty requestScope.error}">❌ ${requestScope.error}</c:when>
        </c:choose>
    </div>
</c:if>

<c:if test="${not empty sessionScope.message or not empty sessionScope.error}">
    <div id="popupMessage1"
         class="popup-message"
         style="background-color: ${not empty sessionScope.message ? '#d4edda' : '#f8d7da'};
         color: ${not empty sessionScope.message ? '#155724' : '#721c24'};">
        <c:choose>
            <c:when test="${not empty sessionScope.message}">✅ ${sessionScope.message}</c:when>
            <c:when test="${not empty sessionScope.error}">❌ ${sessionScope.error}</c:when>
        </c:choose>
    </div>
</c:if>

<style>
    .popup-message {
        position: fixed;
        top: 20px;
        right: 20px;
        max-width: 360px;
        padding: 12px 16px;
        border-radius: 8px;
        font-size: 15px;
        font-family: 'Segoe UI', sans-serif;
        box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        display: none;
        z-index: 9999;
    }
</style>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        ['popupMessage', 'popupMessage1'].forEach(function (id) {
            const popup = document.getElementById(id);
            if (popup) {
                popup.style.display = "block";
                popup.style.transition = "opacity 0.5s ease-in-out";

                setTimeout(() => {
                    popup.style.opacity = "0";
                    setTimeout(() => {
                        popup.style.display = "none";
                        // Clear message after hide
                        fetch('<c:url value="/clear-message" />', {method: 'POST'});
                    }, 500);
                }, 5000);
            }
        });
    });
</script>