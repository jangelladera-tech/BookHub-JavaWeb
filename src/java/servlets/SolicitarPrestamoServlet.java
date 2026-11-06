package servlets;

import beans.Libro;
import beans.Prestamo;
import beans.Usuario;
import dao.LibroDAO;
import dao.PrestamoDAO;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/SolicitarPrestamoServlet")
public class SolicitarPrestamoServlet extends HttpServlet {

    private LibroDAO libroDAO = new LibroDAO();
    private PrestamoDAO prestamoDAO = new PrestamoDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // ==========================================
        // VERIFICAR SESIÓN
        // ==========================================

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // ==========================================
        // OBTENER USUARIO
        // ==========================================

        Usuario usuario = (Usuario) session.getAttribute("usuario");

        // ==========================================
        // OBTENER ID DEL LIBRO
        // ==========================================

        String parametroId = request.getParameter("idLibro");

        if (parametroId == null) {
            response.sendRedirect("CatalogoServlet");
            return;
        }

        int idLibro;
        try {
            idLibro = Integer.parseInt(parametroId);
        } catch (NumberFormatException e) {
            response.sendRedirect("CatalogoServlet");
            return;
        }

        // ==========================================
        // BUSCAR LIBRO
        // ==========================================

        Libro libroEncontrado = libroDAO.obtenerPorId(idLibro);

        if (libroEncontrado == null) {
            response.sendRedirect("CatalogoServlet");
            return;
        }

        // ==========================================
        // VERIFICAR STOCK
        // ==========================================

        if (libroEncontrado.getStock() <= 0) {
            response.sendRedirect("DetalleLibroServlet?id=" + idLibro + "&error=sinStock");
            return;
        }

        // ==========================================
        // VERIFICAR SI YA TIENE ESTE LIBRO
        // ==========================================

        for (Prestamo prestamo : prestamoDAO.listar()) {
            if (prestamo.getIdUsuario() == usuario.getIdUsuario()
                    && prestamo.getIdLibro() == idLibro
                    && "PRESTADO".equals(prestamo.getEstado())) {

                response.sendRedirect(
                        "DetalleLibroServlet?id="
                        + idLibro
                        + "&error=yaPrestado"
                );
                return;
            }
        }

        // ==========================================
        // CALCULAR FECHAS
        // ==========================================

        LocalDate fechaActual = LocalDate.now();
        LocalDate fechaDevolucion = fechaActual.plusDays(7);

        DateTimeFormatter formato = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        String fechaPrestamo = fechaActual.format(formato);
        String fechaDevolucionTexto = fechaDevolucion.format(formato);

        // ==========================================
        // CREAR PRÉSTAMO
        // ==========================================

        Prestamo prestamo = new Prestamo();
        prestamo.setIdUsuario(usuario.getIdUsuario());
        prestamo.setIdLibro(idLibro);
        prestamo.setFechaPrestamo(fechaPrestamo);
        prestamo.setFechaDevolucion(fechaDevolucionTexto);
        prestamo.setEstado("PRESTADO");

        prestamoDAO.agregar(prestamo);

        // ==========================================
        // REDUCIR STOCK
        // ==========================================

        libroEncontrado.setStock(libroEncontrado.getStock() - 1);
        libroDAO.actualizar(libroEncontrado);

        // ==========================================
        // REDIRIGIR CON MENSAJE DE ÉXITO
        // ==========================================

        response.sendRedirect("DetalleLibroServlet?id=" + idLibro + "&exito=prestado");
    }
}
