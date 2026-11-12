package controlador;

import modelo.beans.Autor;
import modelo.beans.Categoria;
import modelo.beans.Donacion;
import modelo.beans.Libro;
import modelo.dao.AutorDAO;
import modelo.dao.CategoriaDAO;
import modelo.dao.DonacionDAO;
import modelo.dao.LibroDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/DonacionesServlet", "/DonacionAdminServlet"})
public class DonacionesServlet extends HttpServlet {

    private DonacionDAO donacionDAO = new DonacionDAO();
    private LibroDAO libroDAO = new LibroDAO();
    private AutorDAO autorDAO = new AutorDAO();
    private CategoriaDAO categoriaDAO = new CategoriaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        String idStr = request.getParameter("id") != null
                ? request.getParameter("id")
                : request.getParameter("idDonacion");

        if (accion != null && idStr != null) {
            try {
                int id = Integer.parseInt(idStr.trim());
                if ("aprobar".equalsIgnoreCase(accion)) {
                    procesarAprobacion(id);
                    response.sendRedirect("DonacionesServlet?exito=aprobado");
                    return;
                } else if ("rechazar".equalsIgnoreCase(accion) || "desestimar".equalsIgnoreCase(accion)) {
                    donacionDAO.cambiarEstado(id, "RECHAZADO");
                    response.sendRedirect("DonacionesServlet?exito=rechazado");
                    return;
                }
            } catch (Exception e) {
                System.err.println("Error procesando acción de donación: " + e.getMessage());
                e.printStackTrace();
            }
        }

        request.setAttribute("donaciones", donacionDAO.listar());
        request.getRequestDispatcher("donaciones.jsp").forward(request, response);
    }

    private void procesarAprobacion(int idDonacion) {
        Donacion d = donacionDAO.obtenerPorId(idDonacion);
        if (d == null) {
            return;
        }

        // 1. Actualizar el estado de la donación a APROBADO en BD y memoria
        donacionDAO.cambiarEstado(idDonacion, "APROBADO");

        // 2. Comprobar si el libro ya existe en el catálogo para incrementar stock o registrar nuevo
        String tituloDonado = d.getTituloLibro() != null ? d.getTituloLibro().trim() : "Libro Donado";
        List<Libro> catalogo = libroDAO.listar();
        Libro existente = null;
        for (Libro l : catalogo) {
            if (l.getTitulo() != null && l.getTitulo().trim().equalsIgnoreCase(tituloDonado)) {
                existente = l;
                break;
            }
        }

        if (existente != null) {
            // Ya existe en catálogo: sumamos 1 al stock
            libroDAO.ajustarStock(existente.getIdLibro(), 1);
        } else {
            // Resolver o registrar Autor
            int idAutor = 1;
            String nombreAutor = (d.getAutor() != null && !d.getAutor().trim().isEmpty())
                    ? d.getAutor().trim() : "Autor Donante";
            for (Autor a : autorDAO.listar()) {
                if (a.getNombre() != null && a.getNombre().trim().equalsIgnoreCase(nombreAutor)) {
                    idAutor = a.getIdAutor();
                    nombreAutor = a.getNombre();
                    break;
                }
            }
            if (idAutor == 1 && !"Gabriel García Márquez".equalsIgnoreCase(nombreAutor)) {
                Autor nuevoAutor = new Autor(0, nombreAutor, "Donaciones");
                autorDAO.agregar(nuevoAutor);
                idAutor = nuevoAutor.getIdAutor() > 0 ? nuevoAutor.getIdAutor() : 1;
            }

            // Resolver o registrar Categoría
            int idCategoria = 1;
            String nombreCat = (d.getCategoria() != null && !d.getCategoria().trim().isEmpty())
                    ? d.getCategoria().trim() : "General";
            for (Categoria c : categoriaDAO.listar()) {
                if (c.getNombre() != null && c.getNombre().trim().equalsIgnoreCase(nombreCat)) {
                    idCategoria = c.getIdCategoria();
                    nombreCat = c.getNombre();
                    break;
                }
            }
            if (idCategoria == 1 && !"Literatura".equalsIgnoreCase(nombreCat)) {
                Categoria nuevaCat = new Categoria(0, nombreCat, "Donaciones de la comunidad");
                categoriaDAO.agregar(nuevaCat);
                idCategoria = nuevaCat.getIdCategoria() > 0 ? nuevaCat.getIdCategoria() : 1;
            }

            // Generar ISBN único para la donación
            String isbn = "DON-" + String.format("%06d", Math.abs(System.currentTimeMillis() % 1000000));
            int anio = d.getAnio() > 0 ? d.getAnio() : java.time.Year.now().getValue();
            String desc = "Libro donado por " + d.getNombreDonante()
                    + " (" + (d.getEstadoConservacion() != null ? d.getEstadoConservacion() : "BUENO") + "). "
                    + (d.getMotivoMensaje() != null ? d.getMotivoMensaje() : "");

            Libro nuevoLibro = new Libro(
                    0,
                    tituloDonado,
                    isbn,
                    anio,
                    desc,
                    1, // Stock inicial 1
                    idAutor,
                    nombreAutor,
                    idCategoria,
                    nombreCat,
                    "img/portadas/default.svg"
            );
            libroDAO.agregar(nuevoLibro);
        }
    }
}
