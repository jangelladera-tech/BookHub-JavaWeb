package controlador;

import modelo.beans.Categoria;
import modelo.dao.CategoriaDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/CategoriaServlet", "/CategoriasServlet"})
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

        String idStr = request.getParameter("id") != null ? request.getParameter("id") : request.getParameter("idCategoria");

        if ("eliminar".equalsIgnoreCase(accion)) {
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    categoriaDAO.eliminar(id);
                } catch (NumberFormatException ignored) {}
            }
            response.sendRedirect("CategoriaServlet");
            return;

        } else if ("editar".equalsIgnoreCase(accion)) {
            Categoria categoriaEditar = null;
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    categoriaEditar = categoriaDAO.obtenerPorId(id);
                } catch (NumberFormatException ignored) {}
            }

            request.setAttribute("categoriaEditar", categoriaEditar);
            request.setAttribute("categorias", categoriaDAO.listar());

            request.getRequestDispatcher("categorias.jsp")
                    .forward(request, response);
            return;

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
        categoria.setNombre(nombre != null ? nombre.trim() : "");
        categoria.setDescripcion(descripcion != null ? descripcion.trim() : "");

        String idStr = request.getParameter("id") != null ? request.getParameter("id") : request.getParameter("idCategoria");

        if ("actualizar".equalsIgnoreCase(accion)) {
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    categoria.setIdCategoria(id);
                    categoriaDAO.actualizar(categoria);
                } catch (NumberFormatException ignored) {}
            }
        } else {
            categoriaDAO.agregar(categoria);
        }

        response.sendRedirect("CategoriaServlet");
    }
}
