<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="beans.Usuario"%>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if (!"USUARIO".equals(usuario.getRol())) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>BOOKHUB | Mi cuenta</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

</head>

<body class="bg-light">


<!-- NAVBAR -->

<nav class="navbar navbar-dark bg-dark">

    <div class="container">

        <a class="navbar-brand fw-bold"
           href="usuario.jsp">

            📚 BOOKHUB

        </a>


        <div class="d-flex align-items-center gap-2">

            <a href="InnovacionServlet"
               class="btn btn-outline-light btn-sm">
                ODS 09
            </a>

            <span class="text-white mx-2">

                Hola,
                <strong>
                    <%= usuario.getNombre() %>
                </strong>

            </span>


            <a href="LogoutServlet"
               class="btn btn-outline-light btn-sm">

                Cerrar sesión

            </a>

        </div>

    </div>

</nav>


<!-- CONTENIDO -->

<div class="container py-5">


    <!-- BIENVENIDA -->

    <div class="mb-5">

        <h1 class="fw-bold">

            ¡Bienvenido, <%= usuario.getNombre() %>! 👋

        </h1>

        <p class="text-muted">

            Encuentra libros, consulta su disponibilidad
            y gestiona tus préstamos.

        </p>

    </div>


    <!-- OPCIONES PRINCIPALES -->

    <div class="row g-4 mb-5">


        <!-- CATÁLOGO -->

        <div class="col-md-6">

            <div class="card shadow-sm h-100">

                <div class="card-body p-4">

                    <div class="display-5 mb-3">
                        📚
                    </div>

                    <h3 class="fw-bold">
                        Catálogo
                    </h3>

                    <p class="text-muted">

                        Explora todos los libros disponibles
                        en la biblioteca.

                    </p>

                    <a href="CatalogoServlet"
                       class="btn btn-primary">

                        Ver catálogo

                    </a>

                </div>

            </div>

        </div>


        <!-- MIS PRÉSTAMOS -->

        <div class="col-md-6">

            <div class="card shadow-sm h-100">

                <div class="card-body p-4">

                    <div class="display-5 mb-3">
                        📖
                    </div>

                    <h3 class="fw-bold">
                        Mis préstamos
                    </h3>

                    <p class="text-muted">

                        Consulta los libros que tienes
                        prestados y tu historial.

                    </p>

                    <a href="MisPrestamosServlet"
                       class="btn btn-primary">

                        Ver mis préstamos

                    </a>

                </div>

            </div>

        </div>

    </div>


    <!-- BÚSQUEDA -->

    <div class="card shadow-sm">

        <div class="card-body p-4">

            <h4 class="fw-bold mb-3">

                🔎 Buscar un libro

            </h4>

            <p class="text-muted">

                Busca rápidamente por título, autor o categoría.

            </p>


            <form action="CatalogoServlet"
                  method="get">

                <div class="input-group">

                    <input type="text"
                           name="busqueda"
                           class="form-control"
                           placeholder="Título, autor o categoría..."
                           required>

                    <button type="submit"
                            class="btn btn-primary">

                        Buscar

                    </button>

                </div>

            </form>

        </div>

    </div>


    <!-- INFORMACIÓN -->

    <div class="card shadow-sm mt-4">

        <div class="card-body p-4">

            <h5 class="fw-bold">

                ¿Cómo utilizar BOOKHUB?

            </h5>

            <p class="text-muted mb-0">

                1. Ingresa al catálogo y busca un libro.
                <br>
                2. Consulta sus detalles y disponibilidad.
                <br>
                3. Solicita el préstamo.
                <br>
                4. Revisa tus préstamos desde "Mis préstamos".

            </p>

        </div>

    </div>


</div>


<!-- FOOTER -->

<footer class="bg-dark text-white py-4 mt-5">

    <div class="container text-center">

        <p class="mb-1">

            <strong>BOOKHUB</strong>

        </p>

        <p class="mb-0">

            Sistema Web de Gestión de Biblioteca Universitaria

        </p>

    </div>

</footer>


</body>

</html>