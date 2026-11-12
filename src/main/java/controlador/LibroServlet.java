package controlador;

import modelo.beans.Autor;
import modelo.beans.Categoria;
import modelo.beans.Libro;
import modelo.dao.AutorDAO;
import modelo.dao.CategoriaDAO;
import modelo.dao.LibroDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/LibroServlet", "/LibrosServlet"})
public class LibroServlet extends HttpServlet {

    private LibroDAO libroDAO = new LibroDAO();
    private AutorDAO autorDAO = new AutorDAO();
    private CategoriaDAO categoriaDAO = new CategoriaDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "listar";
        }

        String idStr = request.getParameter("id") != null ? request.getParameter("id") : request.getParameter("idLibro");

        if ("eliminar".equalsIgnoreCase(accion)) {
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    libroDAO.eliminar(id);
                } catch (NumberFormatException ignored) {}
            }
            response.sendRedirect("LibroServlet");
            return;

        } else if ("ajustarStock".equalsIgnoreCase(accion)) {
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    int delta = 1;
                    String deltaStr = request.getParameter("delta");
                    if (deltaStr != null) {
                        delta = Integer.parseInt(deltaStr.trim());
                    }
                    libroDAO.ajustarStock(id, delta);
                } catch (NumberFormatException ignored) {}
            }
            response.sendRedirect("LibroServlet");
            return;

        } else if ("editar".equalsIgnoreCase(accion)) {
            Libro libroEditar = null;
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    libroEditar = libroDAO.obtenerPorId(id);
                } catch (NumberFormatException ignored) {}
            }

            request.setAttribute("libroEditar", libroEditar);
            request.setAttribute("libros", libroDAO.listar());

            request.getRequestDispatcher("libros.jsp")
                    .forward(request, response);
            return;

        } else {
            request.setAttribute("libros", libroDAO.listar());
            request.getRequestDispatcher("libros.jsp")
                    .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion");
        String titulo = request.getParameter("titulo");
        String isbn = request.getParameter("isbn");
        String anioStr = request.getParameter("anio");
        String descripcion = request.getParameter("descripcion");
        String stockStr = request.getParameter("stock");
        String imagenPortada = request.getParameter("imagenPortada");

        String idAutorStr = request.getParameter("idAutor");
        String idCategoriaStr = request.getParameter("idCategoria");

        int anio = 2024;
        int stock = 0;
        try {
            if (anioStr != null && !anioStr.trim().isEmpty()) {
                anio = Integer.parseInt(anioStr.trim());
            }
        } catch (NumberFormatException ignored) {}

        try {
            if (stockStr != null && !stockStr.trim().isEmpty()) {
                stock = Integer.parseInt(stockStr.trim());
            }
        } catch (NumberFormatException ignored) {}

        Libro libro = new Libro();
        libro.setTitulo(titulo != null ? titulo.trim() : "");
        libro.setIsbn(isbn != null ? isbn.trim() : "");
        libro.setAnio(anio);
        libro.setDescripcion(descripcion != null ? descripcion.trim() : "");
        libro.setStock(stock);
        libro.setImagenPortada(imagenPortada);

        if (idAutorStr != null && !idAutorStr.trim().isEmpty()) {
            try {
                int idAutor = Integer.parseInt(idAutorStr.trim());
                libro.setIdAutor(idAutor);
                Autor autor = autorDAO.obtenerPorId(idAutor);
                if (autor != null) {
                    libro.setAutor(autor);
                }
            } catch (NumberFormatException ignored) {}
        }

        if (idCategoriaStr != null && !idCategoriaStr.trim().isEmpty()) {
            try {
                int idCategoria = Integer.parseInt(idCategoriaStr.trim());
                libro.setIdCategoria(idCategoria);
                Categoria categoria = categoriaDAO.obtenerPorId(idCategoria);
                if (categoria != null) {
                    libro.setCategoria(categoria);
                }
            } catch (NumberFormatException ignored) {}
        }

        String idStr = request.getParameter("id") != null ? request.getParameter("id") : request.getParameter("idLibro");

        if ("actualizar".equalsIgnoreCase(accion)) {
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    libro.setIdLibro(id);
                    libroDAO.actualizar(libro);
                } catch (NumberFormatException ignored) {}
            }
        } else {
            libroDAO.agregar(libro);
        }

        response.sendRedirect("LibroServlet");
    }
}
