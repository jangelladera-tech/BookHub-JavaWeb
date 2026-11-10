package controlador;

import modelo.beans.Donacion;
import modelo.beans.Libro;
import modelo.dao.DonacionDAO;
import modelo.dao.LibroDAO;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/DonacionServlet")
public class DonacionServlet extends HttpServlet {

    private DonacionDAO donacionDAO = new DonacionDAO();
    private LibroDAO libroDAO = new LibroDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "formulario";
        }

        if ("aprobar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Donacion d = donacionDAO.obtenerPorId(id);
            if (d != null && !"APROBADO".equals(d.getEstadoRevision())) {
                donacionDAO.cambiarEstado(id, "APROBADO");
                // Incorporar automáticamente al catálogo de libros con stock = 1
                Libro nuevoLibro = new Libro(
                        0,
                        d.getTituloLibro(),
                        "DON-" + System.currentTimeMillis() % 1000000,
                        d.getAnio() > 0 ? d.getAnio() : 2024,
                        "Libro donado por " + d.getNombreDonante() + ". " + (d.getMotivoMensaje() != null ? d.getMotivoMensaje() : ""),
                        1,
                        1,
                        d.getAutor(),
                        1,
                        d.getCategoria(),
                        "img/portadas/default.svg"
                );
                libroDAO.agregar(nuevoLibro);
            }
            response.sendRedirect("DonacionesServlet?exito=aprobado");
            return;
        } else if ("rechazar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));
            donacionDAO.cambiarEstado(id, "RECHAZADO");
            response.sendRedirect("DonacionesServlet?exito=rechazado");
            return;
        }

        // Formulario público
        request.getRequestDispatcher("donar.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String titulo = request.getParameter("titulo");
        String autor = request.getParameter("autor");
        String categoria = request.getParameter("categoria");
        String anioStr = request.getParameter("anio");
        String estadoConservacion = request.getParameter("estadoConservacion");
        String nombreDonante = request.getParameter("nombreDonante");
        String correoDonante = request.getParameter("correoDonante");
        String telefonoDonante = request.getParameter("telefonoDonante");
        String motivo = request.getParameter("motivo");

        int anio = 2024;
        try {
            if (anioStr != null && !anioStr.trim().isEmpty()) {
                anio = Integer.parseInt(anioStr.trim());
            }
        } catch (NumberFormatException ignored) {
        }

        String fechaActual = LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));

        Donacion nueva = new Donacion(
                0,
                titulo != null ? titulo.trim() : "",
                autor != null ? autor.trim() : "Autor Donante",
                categoria != null ? categoria.trim() : "General",
                anio,
                estadoConservacion != null ? estadoConservacion : "BUENO",
                nombreDonante != null ? nombreDonante.trim() : "Donante Anónimo",
                correoDonante != null ? correoDonante.trim() : "",
                telefonoDonante != null ? telefonoDonante.trim() : "",
                motivo != null ? motivo.trim() : "",
                fechaActual,
                "PENDIENTE"
        );

        donacionDAO.registrar(nueva);
        response.sendRedirect("donar.jsp?exito=registrado");
    }
}
