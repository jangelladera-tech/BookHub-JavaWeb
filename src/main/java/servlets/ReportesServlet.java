package servlets;

import beans.Categoria;
import beans.Libro;
import beans.Prestamo;
import beans.Usuario;
import dao.CategoriaDAO;
import dao.DonacionDAO;
import dao.LibroDAO;
import dao.PrestamoDAO;
import dao.UsuarioDAO;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ReportesServlet")
public class ReportesServlet extends HttpServlet {

    private LibroDAO libroDAO = new LibroDAO();
    private PrestamoDAO prestamoDAO = new PrestamoDAO();
    private UsuarioDAO usuarioDAO = new UsuarioDAO();
    private CategoriaDAO categoriaDAO = new CategoriaDAO();
    private DonacionDAO donacionDAO = new DonacionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Libro> libros = libroDAO.listar();
        List<Prestamo> prestamos = prestamoDAO.listar();
        List<Usuario> usuarios = usuarioDAO.listar();
        List<Categoria> categorias = categoriaDAO.listar();

        int totalLibros = libros.size();
        int totalEjemplares = 0;
        int librosAgotados = 0;
        int librosBajoStock = 0;

        for (Libro l : libros) {
            totalEjemplares += l.getStock();
            if (l.getStock() <= 0) {
                librosAgotados++;
            } else if (l.getStock() <= 2) {
                librosBajoStock++;
            }
        }

        int totalPrestamos = prestamos.size();
        int prestamosActivos = 0;
        int prestamosDevueltos = 0;
        for (Prestamo p : prestamos) {
            if ("PRESTADO".equalsIgnoreCase(p.getEstado())) {
                prestamosActivos++;
            } else if ("DEVUELTO".equalsIgnoreCase(p.getEstado())) {
                prestamosDevueltos++;
            }
        }

        int totalUsuarios = usuarios.size();
        int donacionesPendientes = donacionDAO.contarPendientes();

        // Distribución por categoría
        Map<String, Integer> librosPorCat = new HashMap<>();
        for (Libro l : libros) {
            String cat = l.getNombreCategoria() != null ? l.getNombreCategoria() : "General";
            librosPorCat.put(cat, librosPorCat.getOrDefault(cat, 0) + 1);
        }

        request.setAttribute("totalLibros", totalLibros);
        request.setAttribute("totalEjemplares", totalEjemplares);
        request.setAttribute("librosAgotados", librosAgotados);
        request.setAttribute("librosBajoStock", librosBajoStock);
        request.setAttribute("totalPrestamos", totalPrestamos);
        request.setAttribute("prestamosActivos", prestamosActivos);
        request.setAttribute("prestamosDevueltos", prestamosDevueltos);
        request.setAttribute("totalUsuarios", totalUsuarios);
        request.setAttribute("donacionesPendientes", donacionesPendientes);
        request.setAttribute("librosPorCat", librosPorCat);
        request.setAttribute("libros", libros);
        request.setAttribute("prestamos", prestamos);

        request.getRequestDispatcher("reportes.jsp").forward(request, response);
    }
}
