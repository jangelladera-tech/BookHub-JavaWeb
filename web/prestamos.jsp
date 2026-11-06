<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="beans.Prestamo"%>
<%@page import="beans.Usuario"%>
<%@page import="beans.Libro"%>
<%@page import="dao.UsuarioDAO"%>
<%@page import="dao.LibroDAO"%>

<%
    List<Prestamo> prestamos =
            (List<Prestamo>) request.getAttribute("prestamos");

    Prestamo prestamoEditar =
            (Prestamo) request.getAttribute("prestamoEditar");

    boolean editar = prestamoEditar != null;

    UsuarioDAO usuarioDAO = new UsuarioDAO();
    LibroDAO libroDAO = new LibroDAO();

    List<Usuario> usuarios = usuarioDAO.listar();
    List<Libro> libros = libroDAO.listar();
%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Préstamos - BOOKHUB</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

</head>

<body class="bg-light">

<nav class="navbar navbar-dark bg-primary">

    <div class="container">

        <a class="navbar-brand fw-bold" href="dashboard.jsp">
            BOOKHUB
        </a>

        <a href="dashboard.jsp"
           class="btn btn-light btn-sm">
            Volver al dashboard
        </a>

    </div>

</nav>


<div class="container py-5">

    <div class="d-flex justify-content-between align-items-center mb-4">

        <div>

            <h2 class="fw-bold">
                Gestión de préstamos
            </h2>

            <p class="text-muted">
                Administra los préstamos y devoluciones de libros.
            </p>

        </div>

    </div>


    <!-- FORMULARIO -->

    <div class="card shadow-sm mb-4">

        <div class="card-body">

            <h5 class="card-title mb-4">

                <%= editar
                        ? "Editar préstamo"
                        : "Registrar préstamo" %>

            </h5>


            <form action="PrestamoServlet" method="POST">

                <% if (editar) { %>

                    <input type="hidden"
                           name="accion"
                           value="actualizar">

                    <input type="hidden"
                           name="id"
                           value="<%= prestamoEditar.getIdPrestamo() %>">

                <% } else { %>

                    <input type="hidden"
                           name="accion"
                           value="agregar">

                <% } %>


                <div class="row g-3">


                    <div class="col-md-6">

                        <label class="form-label">
                            Usuario / Lector
                        </label>

                        <select class="form-select"
                                name="idUsuario"
                                required>
                            <% for (Usuario u : usuarios) {
                                   boolean sel = editar && prestamoEditar.getIdUsuario() == u.getIdUsuario();
                            %>
                                <option value="<%= u.getIdUsuario() %>" <%= sel ? "selected" : "" %>>
                                    #<%= u.getIdUsuario() %> - <%= u.getNombre() %> (<%= u.getCorreo() %>)
                                </option>
                            <% } %>
                        </select>

                    </div>


                    <div class="col-md-6">

                        <label class="form-label">
                            Libro
                        </label>

                        <select class="form-select"
                                name="idLibro"
                                required>
                            <% for (Libro l : libros) {
                                   boolean sel = editar && prestamoEditar.getIdLibro() == l.getIdLibro();
                            %>
                                <option value="<%= l.getIdLibro() %>" <%= sel ? "selected" : "" %>>
                                    #<%= l.getIdLibro() %> - <%= l.getTitulo() %> (Stock: <%= l.getStock() %>)
                                </option>
                            <% } %>
                        </select>

                    </div>


                    <div class="col-md-4">

                        <label class="form-label">
                            Fecha de préstamo
                        </label>

                        <input type="text"
                               class="form-control"
                               name="fechaPrestamo"
                               placeholder="DD/MM/AAAA"
                               required
                               value="<%= editar
                                       ? prestamoEditar.getFechaPrestamo()
                                       : "" %>">

                    </div>


                    <div class="col-md-4">

                        <label class="form-label">
                            Fecha de devolución
                        </label>

                        <input type="text"
                               class="form-control"
                               name="fechaDevolucion"
                               placeholder="DD/MM/AAAA"
                               required
                               value="<%= editar
                                       ? prestamoEditar.getFechaDevolucion()
                                       : "" %>">

                    </div>


                    <div class="col-md-4">

                        <label class="form-label">
                            Estado
                        </label>

                        <select class="form-select"
                                name="estado"
                                required>

                            <option value="PRESTADO"
                                <%= editar && "PRESTADO".equals(
                                        prestamoEditar.getEstado())
                                    ? "selected"
                                    : "" %>>
                                PRESTADO
                            </option>

                            <option value="DEVUELTO"
                                <%= editar && "DEVUELTO".equals(
                                        prestamoEditar.getEstado())
                                    ? "selected"
                                    : "" %>>
                                DEVUELTO
                            </option>

                        </select>

                    </div>


                </div>


                <div class="mt-4">

                    <button type="submit"
                            class="btn btn-primary">

                        <%= editar
                                ? "Guardar cambios"
                                : "Registrar préstamo" %>

                    </button>

                    <% if (editar) { %>

                        <a href="PrestamoServlet"
                           class="btn btn-secondary">
                            Cancelar
                        </a>

                    <% } %>

                </div>

            </form>

        </div>

    </div>


    <!-- TABLA -->

    <div class="card shadow-sm">

        <div class="card-body">

            <h5 class="card-title mb-4">
                Lista de préstamos
            </h5>


            <div class="table-responsive">

                <table class="table table-hover align-middle">

                    <thead class="table-primary">

                        <tr>

                            <th>ID</th>
                            <th>Usuario</th>
                            <th>Libro</th>
                            <th>Fecha préstamo</th>
                            <th>Fecha devolución</th>
                            <th>Estado</th>
                            <th>Acciones</th>

                        </tr>

                    </thead>


                    <tbody>

                    <% if (prestamos != null &&
                           !prestamos.isEmpty()) { %>


                        <% for (Prestamo prestamo : prestamos) {
                               Usuario u = usuarioDAO.obtenerPorId(prestamo.getIdUsuario());
                               Libro l = libroDAO.obtenerPorId(prestamo.getIdLibro());
                        %>

                            <tr>

                                <td>
                                    <%= prestamo.getIdPrestamo() %>
                                </td>

                                <td>
                                    <%= u != null ? u.getNombre() : ("Usuario #" + prestamo.getIdUsuario()) %>
                                </td>

                                <td>
                                    <%= l != null ? l.getTitulo() : ("Libro #" + prestamo.getIdLibro()) %>
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

                                        <span class="badge bg-warning text-dark">
                                            PRESTADO
                                        </span>

                                    <% } else { %>

                                        <span class="badge bg-success">
                                            DEVUELTO
                                        </span>

                                    <% } %>

                                </td>

                                <td>

                                    <a href="PrestamoServlet?accion=editar&id=<%= prestamo.getIdPrestamo() %>"
                                       class="btn btn-sm btn-outline-primary">
                                        Editar
                                    </a>


                                    <a href="PrestamoServlet?accion=eliminar&id=<%= prestamo.getIdPrestamo() %>"
                                       class="btn btn-sm btn-outline-danger"
                                       onclick="return confirm('¿Eliminar este préstamo?');">
                                        Eliminar
                                    </a>

                                </td>

                            </tr>

                        <% } %>


                    <% } else { %>

                        <tr>

                            <td colspan="7"
                                class="text-center text-muted">
                                No hay préstamos registrados.
                            </td>

                        </tr>

                    <% } %>

                    </tbody>

                </table>

            </div>

        </div>

    </div>

</div>


<footer class="bg-dark text-white text-center py-4 mt-5">

    <p class="mb-0">
        © 2026 BOOKHUB - Sistema de Gestión de Biblioteca Universitaria
    </p>

</footer>


</body>

</html>
