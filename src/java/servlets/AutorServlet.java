package servlets;

import beans.Autor;
import dao.AutorDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AutorServlet")
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

        if (accion.equals("eliminar")) {

            int id = Integer.parseInt(request.getParameter("id"));
            autorDAO.eliminar(id);
            response.sendRedirect("AutorServlet");

        } else if (accion.equals("editar")) {

            int id = Integer.parseInt(request.getParameter("id"));
            Autor autorEditar = autorDAO.obtenerPorId(id);

            request.setAttribute("autorEditar", autorEditar);
            request.setAttribute("autores", autorDAO.listar());

            request.getRequestDispatcher("autores.jsp")
                    .forward(request, response);

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
        autor.setNombre(nombre);
        autor.setNacionalidad(nacionalidad);

        if ("actualizar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));
            autor.setIdAutor(id);
            autorDAO.actualizar(autor);
        } else {
            autorDAO.agregar(autor);
        }

        response.sendRedirect("AutorServlet");
    }
}
