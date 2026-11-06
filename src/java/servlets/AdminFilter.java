package servlets;

import beans.Usuario;
import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter(
    urlPatterns = {
        "/dashboard.jsp",
        "/LibroServlet",
        "/AutorServlet",
        "/CategoriaServlet",
        "/UsuarioServlet",
        "/PrestamoServlet"
    }
)
public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request,
                          ServletResponse response,
                          FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest =
                (HttpServletRequest) request;

        HttpServletResponse httpResponse =
                (HttpServletResponse) response;

        HttpSession session =
                httpRequest.getSession(false);

        // Verificar que exista una sesión
        if (session == null ||
                session.getAttribute("usuario") == null) {

            httpResponse.sendRedirect(
                    "login.jsp"
            );

            return;
        }

        // Obtener usuario de la sesión
        Usuario usuario =
                (Usuario) session.getAttribute("usuario");

        // Verificar que sea ADMIN
        if (!"ADMIN".equals(usuario.getRol())) {

            httpResponse.sendRedirect(
                    "CatalogoServlet"
            );

            return;
        }

        // Si es ADMIN, permitir el acceso
        chain.doFilter(
                request,
                response
        );
    }
}