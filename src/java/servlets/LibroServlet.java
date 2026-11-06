package servlets;

import beans.Autor;
import beans.Categoria;
import beans.Libro;
import dao.AutorDAO;
import dao.CategoriaDAO;
import dao.LibroDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/LibroServlet")
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

        if (accion.equals("eliminar")) {

            int id = Integer.parseInt(request.getParameter("id"));
            libroDAO.eliminar(id);
            response.sendRedirect("LibroServlet");

        } else if (accion.equals("editar")) {

            int id = Integer.parseInt(request.getParameter("id"));
            Libro libroEditar = libroDAO.obtenerPorId(id);

            request.setAttribute("libroEditar", libroEditar);
            request.setAttribute("libros", libroDAO.listar());

            request.getRequestDispatcher("libros.jsp")
                    .forward(request, response);

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
        int anio = Integer.parseInt(request.getParameter("anio"));
        String descripcion = request.getParameter("descripcion");
        int stock = Integer.parseInt(request.getParameter("stock"));
        String imagenPortada = request.getParameter("imagenPortada");

        String idAutorStr = request.getParameter("idAutor");
        String idCategoriaStr = request.getParameter("idCategoria");

        Libro libro = new Libro();
        libro.setTitulo(titulo);
        libro.setIsbn(isbn);
        libro.setAnio(anio);
        libro.setDescripcion(descripcion);
        libro.setStock(stock);
        libro.setImagenPortada(imagenPortada);

        if (idAutorStr != null && !idAutorStr.isEmpty()) {
            int idAutor = Integer.parseInt(idAutorStr);
            Autor autor = autorDAO.obtenerPorId(idAutor);
            libro.setAutor(autor);
        }

        if (idCategoriaStr != null && !idCategoriaStr.isEmpty()) {
            int idCategoria = Integer.parseInt(idCategoriaStr);
            Categoria categoria = categoriaDAO.obtenerPorId(idCategoria);
            libro.setCategoria(categoria);
        }

        if ("actualizar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));
            libro.setIdLibro(id);
            libroDAO.actualizar(libro);
        } else {
            libroDAO.agregar(libro);
        }

        response.sendRedirect("LibroServlet");
    }
}
