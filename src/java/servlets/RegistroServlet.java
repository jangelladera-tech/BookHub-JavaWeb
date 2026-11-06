package servlets;

import beans.Usuario;
import dao.UsuarioDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/RegistroServlet")
public class RegistroServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("registro.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String nombre = request.getParameter("nombre");
        String correo = request.getParameter("correo");
        String password = request.getParameter("password");
        String confirmarPassword = request.getParameter("confirmarPassword");

        nombre = (nombre != null) ? nombre.trim() : "";
        correo = (correo != null) ? correo.trim() : "";
        password = (password != null) ? password.trim() : "";
        confirmarPassword = (confirmarPassword != null) ? confirmarPassword.trim() : "";

        // Validaciones básicas de entrada
        if (nombre.isEmpty() || correo.isEmpty() || password.isEmpty()) {
            request.setAttribute("error", "Todos los campos son obligatorios.");
            request.setAttribute("nombreIngresado", nombre);
            request.setAttribute("correoIngresado", correo);
            request.getRequestDispatcher("registro.jsp").forward(request, response);
            return;
        }

        if (password.length() < 4) {
            request.setAttribute("error", "La contraseña debe tener al menos 4 caracteres.");
            request.setAttribute("nombreIngresado", nombre);
            request.setAttribute("correoIngresado", correo);
            request.getRequestDispatcher("registro.jsp").forward(request, response);
            return;
        }

        if (!confirmarPassword.isEmpty() && !password.equals(confirmarPassword)) {
            request.setAttribute("error", "Las contraseñas ingresadas no coinciden.");
            request.setAttribute("nombreIngresado", nombre);
            request.setAttribute("correoIngresado", correo);
            request.getRequestDispatcher("registro.jsp").forward(request, response);
            return;
        }

        // Verificar si el correo ya existe
        for (Usuario usuario : usuarioDAO.listar()) {
            if (usuario.getCorreo().equalsIgnoreCase(correo)) {
                request.setAttribute("error", "El correo electrónico ya está registrado.");
                request.setAttribute("nombreIngresado", nombre);
                request.setAttribute("correoIngresado", correo);
                request.getRequestDispatcher("registro.jsp").forward(request, response);
                return;
            }
        }

        // Crear nuevo usuario lector
        Usuario nuevoUsuario = new Usuario();
        nuevoUsuario.setNombre(nombre);
        nuevoUsuario.setCorreo(correo);
        nuevoUsuario.setPassword(password);
        nuevoUsuario.setRol("USUARIO");
        nuevoUsuario.setEstado("ACTIVO");

        // Guardar usuario
        usuarioDAO.agregar(nuevoUsuario);

        // Volver al login indicando éxito
        response.sendRedirect("login.jsp?registro=exitoso");
    }
}
