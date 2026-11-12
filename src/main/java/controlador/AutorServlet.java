package controlador;

import modelo.beans.Autor;
import modelo.dao.AutorDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/AutorServlet", "/AutoresServlet"})
public class AutorServlet extends HttpServlet {

    private AutorDAO autorDAO = new AutorDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "listar";
        }

        String idStr = request.getParameter("id") != null ? request.getParameter("id") : request.getParameter("idAutor");

        if ("eliminar".equalsIgnoreCase(accion)) {
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    autorDAO.eliminar(id);
                } catch (NumberFormatException ignored) {}
            }
            response.sendRedirect("AutorServlet");
            return;

        } else if ("editar".equalsIgnoreCase(accion)) {
            Autor autorEditar = null;
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    autorEditar = autorDAO.obtenerPorId(id);
                } catch (NumberFormatException ignored) {}
            }

            request.setAttribute("autorEditar", autorEditar);
            request.setAttribute("autores", autorDAO.listar());

            request.getRequestDispatcher("autores.jsp")
                    .forward(request, response);
            return;

        } else {
            request.setAttribute("autores", autorDAO.listar());
            request.getRequestDispatcher("autores.jsp")
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
        String nacionalidad = request.getParameter("nacionalidad");

        Autor autor = new Autor();
        autor.setNombre(nombre != null ? nombre.trim() : "");
        autor.setNacionalidad(nacionalidad != null ? nacionalidad.trim() : "");

        String idStr = request.getParameter("id") != null ? request.getParameter("id") : request.getParameter("idAutor");

        if ("actualizar".equalsIgnoreCase(accion)) {
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    autor.setIdAutor(id);
                    autorDAO.actualizar(autor);
                } catch (NumberFormatException ignored) {}
            }
        } else {
            autorDAO.agregar(autor);
        }

        response.sendRedirect("AutorServlet");
    }
}
