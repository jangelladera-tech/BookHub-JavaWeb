package controlador;

import modelo.beans.Libro;
import modelo.beans.Prestamo;
import modelo.beans.Usuario;
import modelo.dao.LibroDAO;
import modelo.dao.PrestamoDAO;
import modelo.dao.UsuarioDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/SancionesServlet")
public class SancionesServlet extends HttpServlet {

    private PrestamoDAO prestamoDAO = new PrestamoDAO();
    private UsuarioDAO usuarioDAO = new UsuarioDAO();
    private LibroDAO libroDAO = new LibroDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if ("regularizar".equals(accion)) {
            String idStr = request.getParameter("id") != null
                    ? request.getParameter("id")
                    : request.getParameter("idPrestamo");
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    int idPrestamo = Integer.parseInt(idStr.trim());
                    Prestamo p = prestamoDAO.obtenerPorId(idPrestamo);
                    if (p != null) {
                        p.setEstado("DEVUELTO");
                        prestamoDAO.actualizar(p);
                        libroDAO.ajustarStock(p.getIdLibro(), 1);
                    }
                } catch (NumberFormatException ignored) {}
            }
            response.sendRedirect("SancionesServlet?exito=regularizado");
            return;
        }

        List<Prestamo> prestamosMorosos = prestamoDAO.listarMorosos();
        if (prestamosMorosos == null) {
            prestamosMorosos = new ArrayList<>();
        }

        request.setAttribute("prestamosMorosos", prestamosMorosos);
        request.setAttribute("usuarioDAO", usuarioDAO);
        request.setAttribute("libroDAO", libroDAO);

        request.getRequestDispatcher("sanciones.jsp").forward(request, response);
    }
}
