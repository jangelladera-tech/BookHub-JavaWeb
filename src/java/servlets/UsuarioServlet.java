package servlets;

import beans.Usuario;
import dao.UsuarioDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/UsuarioServlet")
public class UsuarioServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO = new UsuarioDAO();

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
            usuarioDAO.eliminar(id);
            response.sendRedirect("UsuarioServlet");

        } else if (accion.equals("editar")) {

            int id = Integer.parseInt(request.getParameter("id"));
            Usuario usuarioEditar = usuarioDAO.obtenerPorId(id);

            request.setAttribute("usuarioEditar", usuarioEditar);
            request.setAttribute("usuarios", usuarioDAO.listar());

            request.getRequestDispatcher("usuarios.jsp")
                    .forward(request, response);

        } else {

            request.setAttribute("usuarios", usuarioDAO.listar());

            request.getRequestDispatcher("usuarios.jsp")
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
        String correo = request.getParameter("correo");
        String password = request.getParameter("password");
        String rol = request.getParameter("rol");
        String estado = request.getParameter("estado");

        Usuario usuario = new Usuario();
        usuario.setNombre(nombre);
        usuario.setCorreo(correo);
        usuario.setPassword(password);
        usuario.setRol(rol);
        usuario.setEstado(estado);

        if ("actualizar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));
            usuario.setIdUsuario(id);
            usuarioDAO.actualizar(usuario);
        } else {
            usuarioDAO.agregar(usuario);
        }

        response.sendRedirect("UsuarioServlet");
    }
}
