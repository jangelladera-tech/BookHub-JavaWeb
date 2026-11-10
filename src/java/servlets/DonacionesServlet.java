package servlets;

import dao.DonacionDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/DonacionesServlet")
public class DonacionesServlet extends HttpServlet {

    private DonacionDAO donacionDAO = new DonacionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("donaciones", donacionDAO.listar());
        request.getRequestDispatcher("donaciones.jsp").forward(request, response);
    }
}
