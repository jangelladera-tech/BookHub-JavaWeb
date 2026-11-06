<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="beans.Usuario"%>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if (!"ADMIN".equals(usuario.getRol())) {
        response.sendRedirect("CatalogoServlet");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Dashboard - BOOKHUB</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

</head>

<body class="bg-light">

<nav class="navbar navbar-dark bg-primary">

    <div class="container">

        <a class="navbar-brand fw-bold"
           href="dashboard.jsp">

            BOOKHUB

        </a>

        <div class="d-flex align-items-center gap-2">

            <a href="InnovacionServlet"
               class="btn btn-outline-light btn-sm">
                ODS 09
            </a>

            <span class="text-white mx-2">

                Hola, <%= usuario.getNombre() %>

            </span>

            <a href="LogoutServlet"
               class="btn btn-light btn-sm">

                Cerrar sesión

            </a>

        </div>

    </div>

</nav>


<div class="container py-5">

    <div class="mb-4">

        <h1 class="fw-bold">

            Panel de administración

        </h1>

        <p class="text-muted">

            Gestiona los recursos principales de BOOKHUB.

        </p>

    </div>


    <div class="row g-4">


        <!-- LIBROS -->

        <div class="col-md-6 col-lg-4">

            <div class="card shadow-sm h-100">

                <div class="card-body">

                    <h4 class="card-title">

                        📚 Libros

                    </h4>

                    <p class="card-text">

                        Gestiona el catálogo de libros.

                    </p>

                    <a href="LibroServlet"
                       class="btn btn-primary">

                        Gestionar libros

                    </a>

                </div>

            </div>

        </div>


        <!-- AUTORES -->

        <div class="col-md-6 col-lg-4">

            <div class="card shadow-sm h-100">

                <div class="card-body">

                    <h4 class="card-title">

                        ✍️ Autores

                    </h4>

                    <p class="card-text">

                        Gestiona los autores registrados.

                    </p>

                    <a href="AutorServlet"
                       class="btn btn-primary">

                        Gestionar autores

                    </a>

                </div>

            </div>

        </div>


        <!-- CATEGORÍAS -->

        <div class="col-md-6 col-lg-4">

            <div class="card shadow-sm h-100">

                <div class="card-body">

                    <h4 class="card-title">

                        🗂️ Categorías

                    </h4>

                    <p class="card-text">

                        Gestiona las categorías de libros.

                    </p>

                    <a href="CategoriaServlet"
                       class="btn btn-primary">

                        Gestionar categorías

                    </a>

                </div>

            </div>

        </div>


        <!-- USUARIOS -->

        <div class="col-md-6 col-lg-4">

            <div class="card shadow-sm h-100">

                <div class="card-body">

                    <h4 class="card-title">

                        👥 Usuarios

                    </h4>

                    <p class="card-text">

                        Gestiona los usuarios del sistema.

                    </p>

                    <a href="UsuarioServlet"
                       class="btn btn-primary">

                        Gestionar usuarios

                    </a>

                </div>

            </div>

        </div>


        <!-- PRÉSTAMOS -->

        <div class="col-md-6 col-lg-4">

            <div class="card shadow-sm h-100">

                <div class="card-body">

                    <h4 class="card-title">

                        📖 Préstamos

                    </h4>

                    <p class="card-text">

                        Gestiona los préstamos y devoluciones.

                    </p>

                    <a href="PrestamoServlet"
                       class="btn btn-primary">

                        Gestionar préstamos

                    </a>

                </div>

            </div>

        </div>


        <!-- CATÁLOGO -->

        <div class="col-md-6 col-lg-4">

            <div class="card shadow-sm h-100">

                <div class="card-body">

                    <h4 class="card-title">

                        🔎 Catálogo

                    </h4>

                    <p class="card-text">

                        Visualiza el catálogo público.

                    </p>

                    <a href="CatalogoServlet"
                       class="btn btn-outline-primary">

                        Ver catálogo

                    </a>

                </div>

            </div>

        </div>


    </div>

</div>


<footer class="bg-dark text-white text-center py-3 mt-5">

    <p class="mb-0">

        BOOKHUB - Sistema Web de Gestión de Biblioteca Universitaria

    </p>

</footer>


</body>

</html>