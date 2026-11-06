<%@page import="java.util.List"%>
<%@page import="beans.Categoria"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Gestión de Categorías - BOOKHUB</title>

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

        <h1>Gestión de Categorías</h1>

        <p class="text-muted">

            Administra las categorías de los libros.

        </p>

    </div>


    <!-- EDITAR -->

    <%

        Categoria categoriaEditar =
                (Categoria) request.getAttribute(
                        "categoriaEditar"
                );

        boolean editando =
                categoriaEditar != null;

    %>


    <!-- FORMULARIO -->

    <div class="card shadow-sm mb-5">

        <div class="card-header bg-primary text-white">

            <h5 class="mb-0">

                <%= editando
                        ? "Editar categoría"
                        : "Agregar nueva categoría" %>

            </h5>

        </div>


        <div class="card-body">

            <form action="CategoriaServlet"
                  method="POST">


                <% if (editando) { %>

                    <input type="hidden"
                           name="accion"
                           value="actualizar">

                    <input type="hidden"
                           name="id"
                           value="<%= categoriaEditar.getIdCategoria() %>">

                <% } %>


                <div class="row">


                    <!-- NOMBRE -->

                    <div class="col-md-6 mb-3">

                        <label class="form-label">

                            Nombre

                        </label>

                        <input type="text"
                               name="nombre"
                               class="form-control"
                               value="<%= editando
                                       ? categoriaEditar.getNombre()
                                       : "" %>"
                               required>

                    </div>


                    <!-- DESCRIPCIÓN -->

                    <div class="col-md-12 mb-3">

                        <label class="form-label">

                            Descripción

                        </label>

                        <textarea name="descripcion"
                                  class="form-control"
                                  rows="3"
                                  required><%= editando
                                          ? categoriaEditar.getDescripcion()
                                          : "" %></textarea>

                    </div>

                </div>


                <button type="submit"
                        class="btn btn-primary">

                    <%= editando
                            ? "Guardar cambios"
                            : "+ Agregar categoría" %>

                </button>


                <% if (editando) { %>

                    <a href="CategoriaServlet"
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

                Categorías registradas

            </h5>

        </div>


        <div class="card-body">

            <div class="table-responsive">

                <table class="table table-hover align-middle">

                    <thead class="table-dark">

                        <tr>

                            <th>ID</th>

                            <th>Nombre</th>

                            <th>Descripción</th>

                            <th>Acciones</th>

                        </tr>

                    </thead>


                    <tbody>

                        <%

                            List<Categoria> categorias =
                                    (List<Categoria>)
                                    request.getAttribute(
                                            "categorias"
                                    );

                            if (categorias != null
                                    && !categorias.isEmpty()) {

                                for (Categoria categoria :
                                        categorias) {

                        %>

                        <tr>

                            <td>

                                <%= categoria.getIdCategoria() %>

                            </td>

                            <td>

                                <strong>

                                    <%= categoria.getNombre() %>

                                </strong>

                            </td>

                            <td>

                                <%= categoria.getDescripcion() %>

                            </td>

                            <td>

                                <a href="CategoriaServlet?accion=editar&id=<%= categoria.getIdCategoria() %>"
                                   class="btn btn-sm btn-warning">

                                    Editar

                                </a>


                                <a href="CategoriaServlet?accion=eliminar&id=<%= categoria.getIdCategoria() %>"
                                   class="btn btn-sm btn-danger"
                                   onclick="return confirm('¿Deseas eliminar esta categoría?');">

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

                                No hay categorías registradas.

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