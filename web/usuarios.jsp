<%@page import="java.util.List"%>
<%@page import="beans.Usuario"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Gestión de Usuarios - BOOKHUB</title>

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

        <h1>Gestión de Usuarios</h1>

        <p class="text-muted">

            Administra los usuarios registrados en BOOKHUB.

        </p>

    </div>


    <!-- DETERMINAR EDICIÓN -->

    <%

        Usuario usuarioEditar =
                (Usuario) request.getAttribute(
                        "usuarioEditar"
                );

        boolean editando =
                usuarioEditar != null;

    %>


    <!-- FORMULARIO -->

    <div class="card shadow-sm mb-5">

        <div class="card-header bg-primary text-white">

            <h5 class="mb-0">

                <%= editando
                        ? "Editar usuario"
                        : "Agregar nuevo usuario" %>

            </h5>

        </div>


        <div class="card-body">

            <form action="UsuarioServlet"
                  method="POST">


                <% if (editando) { %>

                    <input type="hidden"
                           name="accion"
                           value="actualizar">

                    <input type="hidden"
                           name="id"
                           value="<%= usuarioEditar.getIdUsuario() %>">

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
                                       ? usuarioEditar.getNombre()
                                       : "" %>"
                               required>

                    </div>


                    <!-- CORREO -->

                    <div class="col-md-6 mb-3">

                        <label class="form-label">

                            Correo electrónico

                        </label>

                        <input type="email"
                               name="correo"
                               class="form-control"
                               value="<%= editando
                                       ? usuarioEditar.getCorreo()
                                       : "" %>"
                               required>

                    </div>


                    <!-- CONTRASEÑA -->

                    <div class="col-md-6 mb-3">

                        <label class="form-label">

                            Contraseña

                        </label>

                        <input type="password"
                               name="password"
                               class="form-control"
                               value="<%= editando
                                       ? usuarioEditar.getPassword()
                                       : "" %>"
                               required>

                    </div>


                    <!-- ROL -->

                    <div class="col-md-3 mb-3">

                        <label class="form-label">

                            Rol

                        </label>

                        <select name="rol"
                                class="form-select"
                                required>

                            <option value="ADMIN"
                                <%= editando
                                    && "ADMIN".equals(
                                        usuarioEditar.getRol())
                                    ? "selected"
                                    : "" %>>

                                ADMIN

                            </option>

                            <option value="USUARIO"
                                <%= editando
                                    && "USUARIO".equals(
                                        usuarioEditar.getRol())
                                    ? "selected"
                                    : "" %>>

                                USUARIO

                            </option>

                        </select>

                    </div>


                    <!-- ESTADO -->

                    <div class="col-md-3 mb-3">

                        <label class="form-label">

                            Estado

                        </label>

                        <select name="estado"
                                class="form-select"
                                required>

                            <option value="ACTIVO"
                                <%= editando
                                    && "ACTIVO".equals(
                                        usuarioEditar.getEstado())
                                    ? "selected"
                                    : "" %>>

                                ACTIVO

                            </option>

                            <option value="INACTIVO"
                                <%= editando
                                    && "INACTIVO".equals(
                                        usuarioEditar.getEstado())
                                    ? "selected"
                                    : "" %>>

                                INACTIVO

                            </option>

                        </select>

                    </div>

                </div>


                <!-- BOTÓN -->

                <button type="submit"
                        class="btn btn-primary">

                    <%= editando
                            ? "Guardar cambios"
                            : "+ Agregar usuario" %>

                </button>


                <% if (editando) { %>

                    <a href="UsuarioServlet"
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

                Usuarios registrados

            </h5>

        </div>


        <div class="card-body">

            <div class="table-responsive">

                <table class="table table-hover align-middle">

                    <thead class="table-dark">

                        <tr>

                            <th>ID</th>

                            <th>Nombre</th>

                            <th>Correo</th>

                            <th>Rol</th>

                            <th>Estado</th>

                            <th>Acciones</th>

                        </tr>

                    </thead>


                    <tbody>

                        <%

                            List<Usuario> usuarios =
                                    (List<Usuario>)
                                    request.getAttribute(
                                            "usuarios"
                                    );

                            if (usuarios != null
                                    && !usuarios.isEmpty()) {

                                for (Usuario usuario :
                                        usuarios) {

                        %>

                        <tr>

                            <td>

                                <%= usuario.getIdUsuario() %>

                            </td>

                            <td>

                                <strong>

                                    <%= usuario.getNombre() %>

                                </strong>

                            </td>

                            <td>

                                <%= usuario.getCorreo() %>

                            </td>

                            <td>

                                <% if ("ADMIN".equals(
                                        usuario.getRol())) { %>

                                    <span class="badge bg-danger">

                                        ADMIN

                                    </span>

                                <% } else { %>

                                    <span class="badge bg-primary">

                                        USUARIO

                                    </span>

                                <% } %>

                            </td>

                            <td>

                                <% if ("ACTIVO".equals(
                                        usuario.getEstado())) { %>

                                    <span class="badge bg-success">

                                        ACTIVO

                                    </span>

                                <% } else { %>

                                    <span class="badge bg-secondary">

                                        INACTIVO

                                    </span>

                                <% } %>

                            </td>

                            <td>

                                <a href="UsuarioServlet?accion=editar&id=<%= usuario.getIdUsuario() %>"
                                   class="btn btn-sm btn-warning">

                                    Editar

                                </a>


                                <a href="UsuarioServlet?accion=eliminar&id=<%= usuario.getIdUsuario() %>"
                                   class="btn btn-sm btn-danger"
                                   onclick="return confirm('¿Deseas eliminar este usuario?');">

                                    Eliminar

                                </a>

                            </td>

                        </tr>

                        <%

                                }

                            } else {

                        %>

                        <tr>

                            <td colspan="6"
                                class="text-center text-muted">

                                No hay usuarios registrados.

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