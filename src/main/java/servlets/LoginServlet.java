package servlets;

import beans.Usuario;
import dao.UsuarioDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String correo = request.getParameter("correo");
        String password = request.getParameter("password");

        if (correo == null || correo.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Por favor ingresa tu correo y contraseña.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        Usuario usuarioEncontrado = usuarioDAO.autenticar(correo, password);

        if (usuarioEncontrado != null) {
            if (!"ACTIVO".equalsIgnoreCase(usuarioEncontrado.getEstado())) {
                request.setAttribute("error", "Tu cuenta se encuentra inactiva. Contacta al administrador.");
                request.setAttribute("correoIngresado", correo.trim());
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuarioEncontrado);

            // ADMIN
            if ("ADMIN".equalsIgnoreCase(usuarioEncontrado.getRol())) {
                response.sendRedirect("dashboard.jsp");
            // USUARIO NORMAL (LECTOR)
            } else {
                response.sendRedirect("usuario.jsp");
            }

        } else {
            request.setAttribute("error", "Correo o contraseña incorrectos. Verifica tus credenciales.");
            request.setAttribute("correoIngresado", correo.trim());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
