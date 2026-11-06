<%@page import="java.util.List"%>
<%@page import="beans.Autor"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Gestión de Autores - BOOKHUB</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
              rel="stylesheet">

    </head>

    <body class="bg-light">

        <!-- NAVBAR -->

        <nav class="navbar navbar-dark bg-dark">

            <div class="container">

                <a class="navbar-brand fw-bold"
                   href="dashboard.jsp">

                    BOOKHUB

                </a>

                <a href="dashboard.jsp"
                   class="btn btn-outline-light">

                    Volver al Dashboard

                </a>

            </div>

        </nav>


        <!-- CONTENIDO -->

        <div class="container mt-5">

            <div class="mb-4">

                <h1>Gestión de Autores</h1>

                <p class="text-muted">

                    Administra los autores registrados
                    en la biblioteca.

                </p>

            </div>


            <!-- DETERMINAR EDICIÓN -->

            <%

                Autor autorEditar =
                        (Autor) request.getAttribute("autorEditar");

                boolean editando =
                        autorEditar != null;

            %>


            <!-- FORMULARIO -->

            <div class="card shadow-sm mb-5">

                <div class="card-header bg-primary text-white">

                    <h5 class="mb-0">

                        <%= editando
                                ? "Editar autor"
                                : "Agregar nuevo autor" %>

                    </h5>

                </div>


                <div class="card-body">

                    <form action="AutorServlet"
                          method="POST">


                        <% if (editando) { %>

                            <input type="hidden"
                                   name="accion"
                                   value="actualizar">

                            <input type="hidden"
                                   name="id"
                                   value="<%= autorEditar.getIdAutor() %>">

                        <% } %>


                        <div class="row">


                            <!-- NOMBRE -->

                            <div class="col-md-6 mb-3">

                                <label class="form-label">

                                    Nombre completo

                                </label>

                                <input type="text"
                                       name="nombre"
                                       class="form-control"
                                       value="<%= editando
                                               ? autorEditar.getNombre()
                                               : "" %>"
                                       required>

                            </div>


                            <!-- NACIONALIDAD -->

                            <div class="col-md-6 mb-3">

                                <label class="form-label">

                                    Nacionalidad

                                </label>

                                <input type="text"
                                       name="nacionalidad"
                                       class="form-control"
                                       value="<%= editando
                                               ? autorEditar.getNacionalidad()
                                               : "" %>"
                                       required>

                            </div>

                        </div>


                        <!-- BOTÓN -->

                        <button type="submit"
                                class="btn btn-primary">

                            <%= editando
                                    ? "Guardar cambios"
                                    : "+ Agregar autor" %>

                        </button>


                        <% if (editando) { %>

                            <a href="AutorServlet"
                               class="btn btn-secondary">

                                Cancelar

                            </a>

                        <% } %>

                    </form>

                </div>

            </div>


            <!-- TABLA -->

            <div class="card shadow-sm">

                <div class="card-header">

                    <h5 class="mb-0">

                        Autores registrados

                    </h5>

                </div>


                <div class="card-body">

                    <div class="table-responsive">

                        <table class="table table-hover align-middle">

                            <thead class="table-dark">

                                <tr>

                                    <th>ID</th>

                                    <th>Nombre</th>

                                    <th>Nacionalidad</th>

                                    <th>Acciones</th>

                                </tr>

                            </thead>


                            <tbody>

                                <%

                                    List<Autor> autores =
                                            (List<Autor>)
                                            request.getAttribute("autores");

                                    if (autores != null
                                            && !autores.isEmpty()) {

                                        for (Autor autor : autores) {

                                %>

                                <tr>

                                    <td>

                                        <%= autor.getIdAutor() %>

                                    </td>

                                    <td>

                                        <strong>

                                            <%= autor.getNombre() %>

                                        </strong>

                                    </td>

                                    <td>

                                        <%= autor.getNacionalidad() %>

                                    </td>

                                    <td>

                                        <!-- EDITAR -->

                                        <a href="AutorServlet?accion=editar&id=<%= autor.getIdAutor() %>"
                                           class="btn btn-sm btn-warning">

                                            Editar

                                        </a>


                                        <!-- ELIMINAR -->

                                        <a href="AutorServlet?accion=eliminar&id=<%= autor.getIdAutor() %>"
                                           class="btn btn-sm btn-danger"
                                           onclick="return confirm('¿Deseas eliminar este autor?');">

                                            Eliminar

                                        </a>

                                    </td>

                                </tr>

                                <%

                                        }

                                    } else {

                                %>

                                <tr>

                                    <td colspan="4"
                                        class="text-center text-muted">

                                        No hay autores registrados.

                                    </td>

                                </tr>

                                <%

                                    }

                                %>

                            </tbody>

                        </table>

                    </div>

                </div>

            </div>

        </div>


        <!-- FOOTER -->

        <footer class="text-center text-muted mt-5 mb-4">

            BOOKHUB © 2026 — Sistema de Gestión de Biblioteca

        </footer>

    </body>

</html>