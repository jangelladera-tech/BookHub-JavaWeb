package controlador;

import modelo.beans.Usuario;
import modelo.dao.UsuarioDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/UsuarioServlet", "/UsuariosServlet"})
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

        String idStr = request.getParameter("id") != null ? request.getParameter("id") : request.getParameter("idUsuario");

        if ("eliminar".equalsIgnoreCase(accion)) {
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    usuarioDAO.eliminar(id);
                } catch (NumberFormatException ignored) {}
            }
            response.sendRedirect("UsuarioServlet");
            return;

        } else if ("cambiarEstado".equalsIgnoreCase(accion)) {
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    String nuevoEstado = request.getParameter("estado");
                    usuarioDAO.cambiarEstado(id, nuevoEstado);
                } catch (NumberFormatException ignored) {}
            }
            response.sendRedirect("UsuarioServlet");
            return;

        } else if ("editar".equalsIgnoreCase(accion)) {
            Usuario usuarioEditar = null;
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    usuarioEditar = usuarioDAO.obtenerPorId(id);
                } catch (NumberFormatException ignored) {}
            }

            request.setAttribute("usuarioEditar", usuarioEditar);
            request.setAttribute("usuarios", usuarioDAO.listar());

            request.getRequestDispatcher("usuarios.jsp")
                    .forward(request, response);
            return;

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
        usuario.setNombre(nombre != null ? nombre.trim() : "");
        usuario.setCorreo(correo != null ? correo.trim() : "");
        usuario.setPassword(password != null ? password.trim() : "");
        usuario.setRol(rol != null ? rol.trim() : "USUARIO");
        usuario.setEstado(estado != null ? estado.trim() : "ACTIVO");

        String idStr = request.getParameter("id") != null ? request.getParameter("id") : request.getParameter("idUsuario");

        if ("actualizar".equalsIgnoreCase(accion)) {
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    usuario.setIdUsuario(id);
                    usuarioDAO.actualizar(usuario);
                } catch (NumberFormatException ignored) {}
            }
        } else {
            usuarioDAO.agregar(usuario);
        }

        response.sendRedirect("UsuarioServlet");
    }
}
