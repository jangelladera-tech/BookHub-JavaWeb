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
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/DonacionServlet")
public class DonacionServlet extends HttpServlet {

    private DonacionDAO donacionDAO = new DonacionDAO();
    private LibroDAO libroDAO = new LibroDAO();
    private AutorDAO autorDAO = new AutorDAO();
    private CategoriaDAO categoriaDAO = new CategoriaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "formulario";
        }

        if ("aprobar".equalsIgnoreCase(accion)) {
            String idStr = request.getParameter("id") != null
                    ? request.getParameter("id")
                    : request.getParameter("idDonacion");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    procesarAprobacion(id);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            response.sendRedirect("DonacionesServlet?exito=aprobado");
            return;
        } else if ("rechazar".equalsIgnoreCase(accion) || "desestimar".equalsIgnoreCase(accion)) {
            String idStr = request.getParameter("id") != null
                    ? request.getParameter("id")
                    : request.getParameter("idDonacion");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    donacionDAO.cambiarEstado(id, "RECHAZADO");
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            response.sendRedirect("DonacionesServlet?exito=rechazado");
            return;
        }

        // Formulario público
        request.getRequestDispatcher("donar.jsp").forward(request, response);
    }

    private void procesarAprobacion(int idDonacion) {
        Donacion d = donacionDAO.obtenerPorId(idDonacion);
        if (d == null) {
            return;
        }

        donacionDAO.cambiarEstado(idDonacion, "APROBADO");

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
            libroDAO.ajustarStock(existente.getIdLibro(), 1);
        } else {
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
                    1,
                    idAutor,
                    nombreAutor,
                    idCategoria,
                    nombreCat,
                    "img/portadas/default.svg"
            );
            libroDAO.agregar(nuevoLibro);
        }
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

        int anio = LocalDate.now().getYear();
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
