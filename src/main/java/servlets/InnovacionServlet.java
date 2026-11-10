package servlets;

import beans.Libro;
import beans.Prestamo;
import dao.LibroDAO;
import dao.PrestamoDAO;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/InnovacionServlet")
public class InnovacionServlet extends HttpServlet {

    private final LibroDAO libroDAO = new LibroDAO();
    private final PrestamoDAO prestamoDAO = new PrestamoDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        List<Libro> libros = libroDAO.listar();
        List<Prestamo> prestamos = prestamoDAO.listar();

        int librosRegistrados = libros.size();
        int stockBajo = 0;
        int librosAgotados = 0;
        int prestamosActivos = 0;

        Map<Integer, Integer> prestamosActivosPorLibro = new HashMap<>();

        for (Prestamo prestamo : prestamos) {
            if (prestamo.getEstado() != null
                    && "PRESTADO".equalsIgnoreCase(prestamo.getEstado().trim())) {
                prestamosActivos++;
                int idLibro = prestamo.getIdLibro();
                prestamosActivosPorLibro.put(
                        idLibro,
                        prestamosActivosPorLibro.getOrDefault(idLibro, 0) + 1
                );
            }
        }

        for (Libro libro : libros) {
            int stock = libro.getStock();
            if (stock == 0) {
                librosAgotados++;
            } else if (stock >= 1 && stock <= 2) {
                stockBajo++;
            }
        }

        request.setAttribute("libros", libros);
        request.setAttribute("librosRegistrados", librosRegistrados);
        request.setAttribute("stockBajo", stockBajo);
        request.setAttribute("prestamosActivos", prestamosActivos);
        request.setAttribute("librosAgotados", librosAgotados);
        request.setAttribute("prestamosActivosPorLibro", prestamosActivosPorLibro);

        request.getRequestDispatcher("innovacion.jsp")
                .forward(request, response);
    }
}
