<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="beans.Prestamo"%>
<%@page import="beans.Usuario"%>
<%@page import="beans.Libro"%>
<%@page import="dao.LibroDAO"%>

<%
    Usuario usuario =
            (Usuario) session.getAttribute("usuario");

    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Prestamo> misPrestamos =
            (List<Prestamo>) request.getAttribute("misPrestamos");

    LibroDAO libroDAO = new LibroDAO();
%>

<!DOCTYPE html>

<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Mis préstamos - BOOKHUB</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

</head>

<body class="bg-light">


<!-- NAVBAR -->

<nav class="navbar navbar-dark bg-primary">

    <div class="container">

        <a class="navbar-brand fw-bold"
           href="index.html">

            📚 BOOKHUB

        </a>

        <div>

            <a href="usuario.jsp"
               class="btn btn-outline-light btn-sm me-2">
                Mi cuenta
            </a>

            <a href="CatalogoServlet"
               class="btn btn-light btn-sm me-2">

                Catálogo

            </a>

            <a href="InnovacionServlet"
               class="btn btn-outline-light btn-sm me-2">
                ODS 09
            </a>

            <a href="LogoutServlet"
               class="btn btn-outline-light btn-sm">

                Cerrar sesión

            </a>

        </div>

    </div>

</nav>


<!-- CONTENIDO -->

<div class="container py-5">

    <div class="mb-4">

        <h1 class="fw-bold">

            Mis préstamos

        </h1>

        <p class="text-muted">

            Hola, <%= usuario.getNombre() %>.
            Aquí puedes consultar tus préstamos activos e historial.

        </p>

    </div>


    <div class="card shadow-sm">

        <div class="card-body">

            <% if (misPrestamos == null ||
                   misPrestamos.isEmpty()) { %>

                <div class="text-center py-5">

                    <h4>

                        No tienes préstamos registrados.

                    </h4>

                    <p class="text-muted">

                        Puedes explorar el catálogo y solicitar
                        un préstamo.

                    </p>

                    <a href="CatalogoServlet"
                       class="btn btn-primary">

                        Ver catálogo

                    </a>

                </div>

            <% } else { %>


                <div class="table-responsive">

                    <table class="table table-hover align-middle">

                        <thead class="table-primary">

                            <tr>

                                <th>ID</th>

                                <th>Libro</th>

                                <th>Fecha de préstamo</th>

                                <th>Fecha de devolución</th>

                                <th>Estado</th>

                            </tr>

                        </thead>

                        <tbody>

                            <% for (Prestamo prestamo :
                                    misPrestamos) {
                                   Libro lib = libroDAO.obtenerPorId(prestamo.getIdLibro());
                            %>

                                <tr>

                                    <td>
                                        <%= prestamo.getIdPrestamo() %>
                                    </td>

                                    <td>
                                        <strong>
                                            <%= lib != null ? lib.getTitulo() : ("Libro #" + prestamo.getIdLibro()) %>
                                        </strong>
                                    </td>

                                    <td>
                                        <%= prestamo.getFechaPrestamo() %>
                                    </td>

                                    <td>
                                        <%= prestamo.getFechaDevolucion() %>
                                    </td>

                                    <td>

                                        <% if ("PRESTADO".equals(
                                                prestamo.getEstado())) { %>

                                            <span class="badge bg-primary">
                                                PRESTADO
                                            </span>

                                        <% } else if ("DEVUELTO".equals(
                                                prestamo.getEstado())) { %>

                                            <span class="badge bg-success">
                                                DEVUELTO
                                            </span>

                                        <% } else { %>

                                            <span class="badge bg-secondary">
                                                <%= prestamo.getEstado() %>
                                            </span>

                                        <% } %>

                                    </td>

                                </tr>

                            <% } %>

                        </tbody>

                    </table>

                </div>


            <% } %>

        </div>

    </div>

</div>


<!-- FOOTER -->

<footer class="bg-dark text-white text-center py-3 mt-5">

    <p class="mb-0">

        BOOKHUB - Sistema Web de Gestión de Biblioteca Universitaria

    </p>

</footer>


</body>

</html>
