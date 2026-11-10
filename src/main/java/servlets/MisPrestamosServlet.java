package servlets;

import beans.Prestamo;
import beans.Usuario;
import dao.PrestamoDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/MisPrestamosServlet")
public class MisPrestamosServlet extends HttpServlet {

    private PrestamoDAO prestamoDAO = new PrestamoDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Verificar si hay sesión
        if (session == null ||
                session.getAttribute("usuario") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        // Obtener usuario que inició sesión
        Usuario usuario =
                (Usuario) session.getAttribute("usuario");

        // Lista de préstamos del usuario
        List<Prestamo> misPrestamos =
                new ArrayList<>();

        for (Prestamo prestamo : prestamoDAO.listar()) {

            if (prestamo.getIdUsuario()
                    == usuario.getIdUsuario()) {

                misPrestamos.add(prestamo);
            }
        }

        request.setAttribute(
                "misPrestamos",
                misPrestamos
        );

        request.getRequestDispatcher(
                "misPrestamos.jsp"
        ).forward(request, response);
    }
}