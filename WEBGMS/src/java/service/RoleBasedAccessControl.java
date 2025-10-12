package service;

import model.user.Users;
import model.user.UserRoles;
import model.user.Roles;
import dao.UsersDAO;
import dao.RoleDAO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/**
 * Role-Based Access Control Service
 * Manages permissions for different user roles: Admin, Seller, Manager, Customer, Guest
 */
public class RoleBasedAccessControl {
    
    // Role IDs (should match database)
    public static final int ROLE_ADMIN = 1;
    public static final int ROLE_SELLER = 2;
    public static final int ROLE_MANAGER = 3;
    public static final int ROLE_CUSTOMER = 4;
    public static final int ROLE_GUEST = 5;
    
    // Role Names
    public static final String ROLE_NAME_ADMIN = "admin";
    public static final String ROLE_NAME_SELLER = "seller";
    public static final String ROLE_NAME_MANAGER = "manager";
    public static final String ROLE_NAME_CUSTOMER = "customer";
    public static final String ROLE_NAME_GUEST = "guest";
    
    private UsersDAO usersDAO;
    private RoleDAO roleDAO;
    
    public RoleBasedAccessControl() {
        this.usersDAO = new UsersDAO();
        this.roleDAO = new RoleDAO();
    }
    
    /**
     * Get user's role from session
     */
    public UserRoles getUserRole(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        
        Users user = (Users) session.getAttribute("user");
        if (user == null) {
            return null;
        }
        
        return usersDAO.getRoleByUserId((int) user.getUser_id());
    }
    
    /**
     * Check if user has specific role
     */
    public boolean hasRole(HttpServletRequest request, int roleId) {
        UserRoles userRole = getUserRole(request);
        if (userRole == null) {
            return roleId == ROLE_GUEST; // Guest access for non-logged users
        }
        
        return userRole.getRole_id().getRole_id() == roleId;
    }
    
    /**
     * Check if user has any of the specified roles
     */
    public boolean hasAnyRole(HttpServletRequest request, int... roleIds) {
        UserRoles userRole = getUserRole(request);
        if (userRole == null) {
            // Check if guest role is in the list
            for (int roleId : roleIds) {
                if (roleId == ROLE_GUEST) {
                    return true;
                }
            }
            return false;
        }
        
        int userRoleId = userRole.getRole_id().getRole_id();
        for (int roleId : roleIds) {
            if (userRoleId == roleId) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Check if user is admin
     */
    public boolean isAdmin(HttpServletRequest request) {
        return hasRole(request, ROLE_ADMIN);
    }
    
    /**
     * Check if user is seller
     */
    public boolean isSeller(HttpServletRequest request) {
        return hasRole(request, ROLE_SELLER);
    }
    
    /**
     * Check if user is manager
     */
    public boolean isManager(HttpServletRequest request) {
        return hasRole(request, ROLE_MANAGER);
    }
    
    /**
     * Check if user is customer
     */
    public boolean isCustomer(HttpServletRequest request) {
        return hasRole(request, ROLE_CUSTOMER);
    }
    
    /**
     * Check if user is guest (not logged in)
     */
    public boolean isGuest(HttpServletRequest request) {
        return getUserRole(request) == null;
    }
    
    /**
     * Check if user is logged in (any role except guest)
     */
    public boolean isLoggedIn(HttpServletRequest request) {
        return getUserRole(request) != null;
    }
    
    /**
     * Check if user has admin or manager privileges
     */
    public boolean isAdminOrManager(HttpServletRequest request) {
        return hasAnyRole(request, ROLE_ADMIN, ROLE_MANAGER);
    }
    
    /**
     * Check if user has seller privileges
     */
    public boolean isSellerOrAdmin(HttpServletRequest request) {
        return hasAnyRole(request, ROLE_ADMIN, ROLE_SELLER);
    }
    
    /**
     * Get redirect path based on user role
     */
    public String getRedirectPathByRole(int roleId) {
        switch (roleId) {
            case ROLE_ADMIN:
                return "/admin/dashboard";
            case ROLE_SELLER:
                return "/seller/dashboard";
            case ROLE_MANAGER:
                return "/manager/dashboard";
            case ROLE_CUSTOMER:
                return "/home";
            case ROLE_GUEST:
            default:
                return "/home";
        }
    }
    
    /**
     * Get role name by ID
     */
    public String getRoleName(int roleId) {
        switch (roleId) {
            case ROLE_ADMIN:
                return ROLE_NAME_ADMIN;
            case ROLE_SELLER:
                return ROLE_NAME_SELLER;
            case ROLE_MANAGER:
                return ROLE_NAME_MANAGER;
            case ROLE_CUSTOMER:
                return ROLE_NAME_CUSTOMER;
            case ROLE_GUEST:
                return ROLE_NAME_GUEST;
            default:
                return "unknown";
        }
    }
    
    /**
     * Check if user can access admin features
     */
    public boolean canAccessAdmin(HttpServletRequest request) {
        return isAdmin(request);
    }
    
    /**
     * Check if user can access seller features
     */
    public boolean canAccessSeller(HttpServletRequest request) {
        return hasAnyRole(request, ROLE_ADMIN, ROLE_SELLER);
    }
    
    /**
     * Check if user can access manager features
     */
    public boolean canAccessManager(HttpServletRequest request) {
        return hasAnyRole(request, ROLE_ADMIN, ROLE_MANAGER);
    }
    
    /**
     * Check if user can access customer features
     */
    public boolean canAccessCustomer(HttpServletRequest request) {
        return hasAnyRole(request, ROLE_ADMIN, ROLE_MANAGER, ROLE_CUSTOMER);
    }
    
    /**
     * Check if user can view products
     */
    public boolean canViewProducts(HttpServletRequest request) {
        return true; // All users including guests can view products
    }
    
    /**
     * Check if user can add products
     */
    public boolean canAddProducts(HttpServletRequest request) {
        return hasAnyRole(request, ROLE_ADMIN, ROLE_SELLER);
    }
    
    /**
     * Check if user can edit products
     */
    public boolean canEditProducts(HttpServletRequest request) {
        return hasAnyRole(request, ROLE_ADMIN, ROLE_SELLER);
    }
    
    /**
     * Check if user can delete products
     */
    public boolean canDeleteProducts(HttpServletRequest request) {
        return hasAnyRole(request, ROLE_ADMIN, ROLE_SELLER);
    }
    
    /**
     * Check if user can manage users
     */
    public boolean canManageUsers(HttpServletRequest request) {
        return hasAnyRole(request, ROLE_ADMIN, ROLE_MANAGER);
    }
    
    /**
     * Check if user can view orders
     */
    public boolean canViewOrders(HttpServletRequest request) {
        return isLoggedIn(request);
    }
    
    /**
     * Check if user can manage orders
     */
    public boolean canManageOrders(HttpServletRequest request) {
        return hasAnyRole(request, ROLE_ADMIN, ROLE_MANAGER, ROLE_SELLER);
    }
}
