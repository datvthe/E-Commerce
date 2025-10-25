package controller.admin;

import dao.UsersDAO;
import dao.RoleDAO;
import model.user.Users;
import model.user.Roles;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminUserController", urlPatterns = {"/admin/users"})
public class AdminUserController extends HttpServlet {
    
    private static final int PAGE_SIZE = 10;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                listUsers(request, response);
                break;
            case "create":
                showCreateForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteUser(request, response);
                break;
            default:
                listUsers(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "create":
                createUser(request, response);
                break;
            case "update":
                updateUser(request, response);
                break;
            case "updateStatus":
                updateUserStatus(request, response);
                break;
            default:
                listUsers(request, response);
                break;
        }
    }
    
    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");
        String role = request.getParameter("role");
        String pageStr = request.getParameter("page");
        
        int page = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        UsersDAO userDAO = new UsersDAO();
        List<Users> users;
        int totalUsers;
        
        if ((keyword != null && !keyword.trim().isEmpty()) || 
            (status != null && !status.equals("all")) || 
            (role != null && !role.equals("all"))) {
            users = userDAO.searchUsers(keyword, status, role, page, PAGE_SIZE);
            totalUsers = userDAO.countUsers(keyword, status, role);
        } else {
            users = userDAO.getAllUsers(page, PAGE_SIZE);
            totalUsers = userDAO.getTotalUsers();
        }
        
        int totalPages = (int) Math.ceil((double) totalUsers / PAGE_SIZE);
        
        request.setAttribute("users", users);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);
        request.setAttribute("role", role);
        
        request.getRequestDispatcher("/views/admin/users-list.jsp").forward(request, response);
    }
    
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        RoleDAO roleDAO = new RoleDAO();
        List<Roles> roles = roleDAO.getAllRoles();
        request.setAttribute("roles", roles);
        
        request.getRequestDispatcher("/views/admin/user-form.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String userIdStr = request.getParameter("id");
        if (userIdStr == null || userIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }
        
        int userId = Integer.parseInt(userIdStr);
        UsersDAO userDAO = new UsersDAO();
        Users user = userDAO.getUserById(userId);
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }
        
        RoleDAO roleDAO = new RoleDAO();
        List<Roles> roles = roleDAO.getAllRoles();
        
        request.setAttribute("user", user);
        request.setAttribute("roles", roles);
        request.setAttribute("isEdit", true);
        
        request.getRequestDispatcher("/views/admin/user-form.jsp").forward(request, response);
    }
    
    private void createUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phoneNumber = request.getParameter("phoneNumber");
        
        UsersDAO userDAO = new UsersDAO();
        
        if (userDAO.isEmailExists(email)) {
            request.setAttribute("error", "Email đã tồn tại");
            showCreateForm(request, response);
            return;
        }
        
        if (userDAO.isPhoneExists(phoneNumber)) {
            request.setAttribute("error", "Số điện thoại đã tồn tại");
            showCreateForm(request, response);
            return;
        }
        
        Users user = userDAO.createUser(fullName, email, password, phoneNumber);
        
        if (user != null) {
            userDAO.assignDefaultUserRole(user.getUser_id());
            request.getSession().setAttribute("success", "Tạo người dùng thành công");
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } else {
            request.setAttribute("error", "Tạo người dùng thất bại");
            showCreateForm(request, response);
        }
    }
    
    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String userIdStr = request.getParameter("userId");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String address = request.getParameter("address");
        String gender = request.getParameter("gender");
        String status = request.getParameter("status");
        
        int userId = Integer.parseInt(userIdStr);
        UsersDAO userDAO = new UsersDAO();
        Users user = userDAO.getUserById(userId);
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }
        
        user.setFull_name(fullName);
        user.setEmail(email);
        user.setPhone_number(phoneNumber);
        user.setAddress(address);
        user.setGender(gender);
        user.setStatus(status);
        
        boolean success = userDAO.updateUser(user);
        
        if (success) {
            request.getSession().setAttribute("success", "Cập nhật người dùng thành công");
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } else {
            request.setAttribute("error", "Cập nhật người dùng thất bại");
            showEditForm(request, response);
        }
    }
    
    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String userIdStr = request.getParameter("id");
        if (userIdStr == null || userIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }
        
        int userId = Integer.parseInt(userIdStr);
        UsersDAO userDAO = new UsersDAO();
        boolean success = userDAO.deleteUser(userId);
        
        if (success) {
            request.getSession().setAttribute("success", "Xóa người dùng thành công");
        } else {
            request.getSession().setAttribute("error", "Xóa người dùng thất bại");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
    
    private void updateUserStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String userIdStr = request.getParameter("userId");
        String status = request.getParameter("status");
        
        int userId = Integer.parseInt(userIdStr);
        UsersDAO userDAO = new UsersDAO();
        boolean success = userDAO.updateUserStatus(userId, status);
        
        if (success) {
            request.getSession().setAttribute("success", "Cập nhật trạng thái thành công");
        } else {
            request.getSession().setAttribute("error", "Cập nhật trạng thái thất bại");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}
