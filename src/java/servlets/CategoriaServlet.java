package servlets;

import beans.Categoria;
import dao.CategoriaDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/CategoriaServlet")
public class CategoriaServlet extends HttpServlet {

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
            categoriaDAO.eliminar(id);
            response.sendRedirect("CategoriaServlet");

        } else if (accion.equals("editar")) {

            int id = Integer.parseInt(request.getParameter("id"));
            Categoria categoriaEditar = categoriaDAO.obtenerPorId(id);

            request.setAttribute("categoriaEditar", categoriaEditar);
            request.setAttribute("categorias", categoriaDAO.listar());

            request.getRequestDispatcher("categorias.jsp")
                    .forward(request, response);

        } else {

            request.setAttribute("categorias", categoriaDAO.listar());

            request.getRequestDispatcher("categorias.jsp")
                    .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion");
        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");

        Categoria categoria = new Categoria();
        categoria.setNombre(nombre);
        categoria.setDescripcion(descripcion);

        if ("actualizar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));
            categoria.setIdCategoria(id);
            categoriaDAO.actualizar(categoria);
        } else {
            categoriaDAO.agregar(categoria);
        }

        response.sendRedirect("CategoriaServlet");
    }
}
