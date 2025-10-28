/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.common;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.ProductCategoriesDAO;
import dao.CategoryDAO;
import model.product.ProductCategories;
import model.Category;

@WebServlet(name = "HomeController", urlPatterns = {"/home"})
public class CommonHomeController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet HomeController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet HomeController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Load categories from both legacy and admin-managed tables
        ProductCategoriesDAO productCategoriesDAO = new ProductCategoriesDAO();
        CategoryDAO legacyDAO = new CategoryDAO();
        try {
            // Ensure default featured categories exist
            productCategoriesDAO.ensureDefaultDigitalCategories();

            List<Category> pinnedCategories = legacyDAO.getParentCategories();
            request.setAttribute("pinnedCategories", pinnedCategories);

            List<ProductCategories> allAdminCats = productCategoriesDAO.getAllCategories();
            // Filter out names already present in legacy list (case-insensitive)
            Set<String> legacyNames = new HashSet<>();
            for (Category c : pinnedCategories) {
                if (c.getName() != null) legacyNames.add(c.getName().trim().toLowerCase());
            }
            List<ProductCategories> extraCategories = new ArrayList<>();
            for (ProductCategories c : allAdminCats) {
                String name = c.getName();
                if (name == null) continue;
                String key = name.trim().toLowerCase();
                if (!legacyNames.contains(key)) extraCategories.add(c);
            }
            request.setAttribute("extraCategories", extraCategories);
            // For places that expect "categories", provide the full combined list
            List<Object> combined = new ArrayList<>();
            combined.addAll(pinnedCategories);
            combined.addAll(extraCategories);
            request.setAttribute("categories", combined);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("views/common/home.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
