package controller.user;

import com.google.gson.Gson;
import dao.ProductDAO;
import model.product.Products;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.product.ProductCategories;

/**
 * Controller for Products Listing Page Handles product listing, filtering, and
 * search
 */
@WebServlet(name = "ProductsController", urlPatterns = {"/products"})
public class ProductsController extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pageParam = request.getParameter("page");
        String categoryParam = request.getParameter("category");
        String sortParam = request.getParameter("sort");
        String searchParam = request.getParameter("search");
        int pageSize = 12; // default page size
        String pageSizeParam = request.getParameter("pageSize");

        if (pageSizeParam != null && !pageSizeParam.isEmpty()) {
            try {
                int parsedPageSize = Integer.parseInt(pageSizeParam);
                if (parsedPageSize > 0 && parsedPageSize <= 100) {
                    pageSize = parsedPageSize;
                }
            } catch (NumberFormatException e) {
                System.err.println("Invalid pageSize param: " + pageSizeParam);
            }
        }

        System.out.println("page = " + pageParam);
        System.out.println("page size = " + pageSizeParam);
        System.out.println("category = " + categoryParam);
        System.out.println("sort = " + sortParam);
        System.out.println("search = " + searchParam);

        int page = 1;
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        if (categoryParam == null || categoryParam.trim().isEmpty()) {
            categoryParam = null;
        }
        if (sortParam == null || sortParam.trim().isEmpty()) {
            sortParam = null;
        }
        if (searchParam == null || searchParam.trim().isEmpty()) {
            searchParam = null;
        }

        List<Products> products = productDAO.filterProducts(page, pageSize,
                searchParam, categoryParam, sortParam);
        List<ProductCategories> categories = productDAO.getAllCategories();

        int totalProducts = productDAO.countFilteredProducts(searchParam, categoryParam);
        int totalPages = (int) Math.ceil((float) totalProducts / pageSize);
        System.out.println("total pages = " + totalPages);
        System.out.println("page limit = " + pageSize);

        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("category", categoryParam);
        request.setAttribute("sort", sortParam);
        request.setAttribute("search", searchParam);
        request.setAttribute("totalPages", totalPages);

        // Handle Ajax request, can't figure it out right now, might use later
//        if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
//            response.setContentType("application/json");
//            response.setCharacterEncoding("UTF-8");
//            String json = new Gson().toJson(products);
//            response.getWriter().write(json);
//            return;
//        }

        request.getRequestDispatcher("/views/user/products.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
