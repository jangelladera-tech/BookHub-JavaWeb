package servlets;

import beans.Libro;
import beans.Prestamo;
import dao.LibroDAO;
import dao.PrestamoDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/PrestamoServlet")
public class PrestamoServlet extends HttpServlet {

    private PrestamoDAO prestamoDAO = new PrestamoDAO();
    private LibroDAO libroDAO = new LibroDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if (accion == null) {
            accion = "listar";
        }

        if (accion.equals("eliminar")) {

            int id = Integer.parseInt(request.getParameter("id"));
            prestamoDAO.eliminar(id);
            response.sendRedirect("PrestamoServlet");

        } else if (accion.equals("editar")) {

            int id = Integer.parseInt(request.getParameter("id"));
            Prestamo prestamoEditar = prestamoDAO.obtenerPorId(id);

            request.setAttribute("prestamoEditar", prestamoEditar);
            request.setAttribute("prestamos", prestamoDAO.listar());

            request.getRequestDispatcher("prestamos.jsp")
                    .forward(request, response);

        } else {

            request.setAttribute("prestamos", prestamoDAO.listar());

            request.getRequestDispatcher("prestamos.jsp")
                    .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion");

        int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
        int idLibro = Integer.parseInt(request.getParameter("idLibro"));
        String fechaPrestamo = request.getParameter("fechaPrestamo");
        String fechaDevolucion = request.getParameter("fechaDevolucion");
        String estado = request.getParameter("estado");

        // ==========================================
        // ACTUALIZAR PRÉSTAMO
        // ==========================================

        if ("actualizar".equals(accion)) {

            int id = Integer.parseInt(request.getParameter("id"));
            Prestamo prestamoAnterior = prestamoDAO.obtenerPorId(id);

            Prestamo prestamoActualizado = new Prestamo();
            prestamoActualizado.setIdPrestamo(id);
            prestamoActualizado.setIdUsuario(idUsuario);
            prestamoActualizado.setIdLibro(idLibro);
            prestamoActualizado.setFechaPrestamo(fechaPrestamo);
            prestamoActualizado.setFechaDevolucion(fechaDevolucion);
            prestamoActualizado.setEstado(estado);

            // ==========================================
            // CONTROL DE STOCK
            // ==========================================

            if (prestamoAnterior != null) {
                String estadoAnterior = prestamoAnterior.getEstado();
                Libro libro = libroDAO.obtenerPorId(idLibro);

                if (libro != null) {
                    // De PRESTADO -> DEVUELTO
                    if ("PRESTADO".equals(estadoAnterior) && "DEVUELTO".equals(estado)) {
                        libro.setStock(libro.getStock() + 1);
                        libroDAO.actualizar(libro);
                    }
                    // De DEVUELTO -> PRESTADO
                    if ("DEVUELTO".equals(estadoAnterior) && "PRESTADO".equals(estado) && libro.getStock() > 0) {
                        libro.setStock(libro.getStock() - 1);
                        libroDAO.actualizar(libro);
                    }
                }
            }

            prestamoDAO.actualizar(prestamoActualizado);

        } else {

            // ==========================================
            // CREAR NUEVO PRÉSTAMO
            // ==========================================

            Prestamo prestamo = new Prestamo();
            prestamo.setIdUsuario(idUsuario);
            prestamo.setIdLibro(idLibro);
            prestamo.setFechaPrestamo(fechaPrestamo);
            prestamo.setFechaDevolucion(fechaDevolucion);
            prestamo.setEstado(estado);

            prestamoDAO.agregar(prestamo);

            if ("PRESTADO".equals(estado)) {
                Libro libro = libroDAO.obtenerPorId(idLibro);
                if (libro != null && libro.getStock() > 0) {
                    libro.setStock(libro.getStock() - 1);
                    libroDAO.actualizar(libro);
                }
            }
        }

        response.sendRedirect("PrestamoServlet");
    }
}
