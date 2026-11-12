package controlador;

import modelo.beans.Libro;
import modelo.beans.Prestamo;
import modelo.dao.LibroDAO;
import modelo.dao.PrestamoDAO;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/PrestamoServlet", "/PrestamosServlet"})
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

        String idStr = request.getParameter("id") != null ? request.getParameter("id") : request.getParameter("idPrestamo");

        if ("eliminar".equalsIgnoreCase(accion)) {
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    prestamoDAO.eliminar(id);
                } catch (NumberFormatException ignored) {}
            }
            response.sendRedirect("PrestamoServlet");
            return;

        } else if ("devolver".equalsIgnoreCase(accion)) {
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    Prestamo p = prestamoDAO.obtenerPorId(id);
                    if (p != null && !"DEVUELTO".equalsIgnoreCase(p.getEstado())) {
                        p.setEstado("DEVUELTO");
                        prestamoDAO.actualizar(p);
                        libroDAO.ajustarStock(p.getIdLibro(), 1);
                    }
                } catch (NumberFormatException ignored) {}
            }
            response.sendRedirect("PrestamoServlet");
            return;

        } else if ("renovar".equalsIgnoreCase(accion)) {
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    Prestamo p = prestamoDAO.obtenerPorId(id);
                    if (p != null) {
                        try {
                            DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                            LocalDate base = LocalDate.now();
                            if (p.getFechaDevolucion() != null && !p.getFechaDevolucion().trim().isEmpty()) {
                                try {
                                    base = LocalDate.parse(p.getFechaDevolucion().trim(), fmt);
                                } catch (Exception ignored) {}
                            }
                            p.setFechaDevolucion(base.plusDays(7).format(fmt));
                        } catch (Exception e) {
                            p.setFechaDevolucion("20/11/2026");
                        }
                        p.setEstado("PRESTADO");
                        prestamoDAO.actualizar(p);
                    }
                } catch (NumberFormatException ignored) {}
            }
            response.sendRedirect("PrestamoServlet");
            return;

        } else if ("editar".equalsIgnoreCase(accion)) {
            Prestamo prestamoEditar = null;
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    prestamoEditar = prestamoDAO.obtenerPorId(id);
                } catch (NumberFormatException ignored) {}
            }

            request.setAttribute("prestamoEditar", prestamoEditar);
            request.setAttribute("prestamos", prestamoDAO.listar());

            request.getRequestDispatcher("prestamos.jsp")
                    .forward(request, response);
            return;

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
        String idUsuarioStr = request.getParameter("idUsuario");
        String idLibroStr = request.getParameter("idLibro");
        String fechaPrestamo = request.getParameter("fechaPrestamo");
        String fechaDevolucion = request.getParameter("fechaDevolucion");
        String estado = request.getParameter("estado");

        int idUsuario = 1;
        int idLibro = 1;
        try {
            if (idUsuarioStr != null && !idUsuarioStr.trim().isEmpty()) {
                idUsuario = Integer.parseInt(idUsuarioStr.trim());
            }
        } catch (NumberFormatException ignored) {}

        try {
            if (idLibroStr != null && !idLibroStr.trim().isEmpty()) {
                idLibro = Integer.parseInt(idLibroStr.trim());
            }
        } catch (NumberFormatException ignored) {}

        // ==========================================
        // ACTUALIZAR PRÉSTAMO
        // ==========================================
        if ("actualizar".equalsIgnoreCase(accion)) {
            String idStr = request.getParameter("id") != null ? request.getParameter("id") : request.getParameter("idPrestamo");
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    Prestamo prestamoAnterior = prestamoDAO.obtenerPorId(id);

                    Prestamo prestamoActualizado = new Prestamo();
                    prestamoActualizado.setIdPrestamo(id);
                    prestamoActualizado.setIdUsuario(idUsuario);
                    prestamoActualizado.setIdLibro(idLibro);
                    prestamoActualizado.setFechaPrestamo(fechaPrestamo);
                    prestamoActualizado.setFechaDevolucion(fechaDevolucion);
                    prestamoActualizado.setEstado(estado != null ? estado : "PRESTADO");

                    // CONTROL DE STOCK
                    if (prestamoAnterior != null) {
                        String estadoAnterior = prestamoAnterior.getEstado();
                        Libro libro = libroDAO.obtenerPorId(idLibro);

                        if (libro != null) {
                            // De PRESTADO -> DEVUELTO
                            if ("PRESTADO".equalsIgnoreCase(estadoAnterior) && "DEVUELTO".equalsIgnoreCase(estado)) {
                                libro.setStock(libro.getStock() + 1);
                                libroDAO.actualizar(libro);
                            }
                            // De DEVUELTO -> PRESTADO
                            if ("DEVUELTO".equalsIgnoreCase(estadoAnterior) && "PRESTADO".equalsIgnoreCase(estado) && libro.getStock() > 0) {
                                libro.setStock(libro.getStock() - 1);
                                libroDAO.actualizar(libro);
                            }
                        }
                    }

                    prestamoDAO.actualizar(prestamoActualizado);
                } catch (NumberFormatException e) {
                    System.err.println("Error parseando ID en PrestamoServlet.doPost: " + e.getMessage());
                }
            }

        } else {
            // ==========================================
            // CREAR NUEVO PRÉSTAMO
            // ==========================================
            Prestamo prestamo = new Prestamo();
            prestamo.setIdUsuario(idUsuario);
            prestamo.setIdLibro(idLibro);
            prestamo.setFechaPrestamo(fechaPrestamo);
            prestamo.setFechaDevolucion(fechaDevolucion);
            prestamo.setEstado(estado != null ? estado : "PRESTADO");

            prestamoDAO.agregar(prestamo);

            if ("PRESTADO".equalsIgnoreCase(estado)) {
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
