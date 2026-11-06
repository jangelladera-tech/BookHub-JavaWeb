package servlets;

import dao.CategoriaDAO;
import dao.LibroDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/CatalogoServlet")
public class CatalogoServlet extends HttpServlet {

    private LibroDAO libroDAO = new LibroDAO();
    private CategoriaDAO categoriaDAO = new CategoriaDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String busqueda = request.getParameter("busqueda");
        String categoria = request.getParameter("categoria");

        request.setAttribute(
                "libros",
                libroDAO.buscar(busqueda, categoria)
        );
        request.setAttribute(
                "categorias",
                categoriaDAO.listar()
        );
        request.setAttribute(
                "busqueda",
                busqueda != null ? busqueda : ""
        );
        request.setAttribute(
                "categoriaSeleccionada",
                categoria != null ? categoria : ""
        );

        request.getRequestDispatcher("catalogo.jsp")
                .forward(request, response);
    }
}
