package servlets;

import beans.Libro;
import dao.LibroDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/DetalleLibroServlet")
public class DetalleLibroServlet extends HttpServlet {

    private LibroDAO libroDAO = new LibroDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String parametroId = request.getParameter("id");

        if (parametroId == null) {
            response.sendRedirect("CatalogoServlet");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(parametroId);
        } catch (NumberFormatException e) {
            response.sendRedirect("CatalogoServlet");
            return;
        }

        Libro libroEncontrado = libroDAO.obtenerPorId(id);

        if (libroEncontrado == null) {
            response.sendRedirect("CatalogoServlet");
            return;
        }

        request.setAttribute("libro", libroEncontrado);

        request.getRequestDispatcher("detalleLibro.jsp")
                .forward(request, response);
    }
}
