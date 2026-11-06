<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="beans.Libro"%>

<%
    Libro libro = (Libro) request.getAttribute("libro");
    if (libro == null) {
        response.sendRedirect("CatalogoServlet");
        return;
    }

    String error = request.getParameter("error");
    String exito = request.getParameter("exito");
    boolean esOds = libro.getNombreCategoria() != null
            && libro.getNombreCategoria().toUpperCase().contains("ODS 09");
%>

<!DOCTYPE html>
<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title><%= libro.getTitulo()%> - BOOKHUB</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
              rel="stylesheet">

        <style>
            .badge-ods {
                background-color: #fd6925;
                color: #ffffff;
            }
            .detalle-portada-box {
                background: linear-gradient(180deg, #f8f9fa 0%, #e9ecef 100%);
                border-radius: 10px;
                padding: 20px;
                text-align: center;
                border: 1px solid rgba(0, 0, 0, 0.08);
            }
            .detalle-portada-img {
                max-height: 320px;
                width: auto;
                max-width: 100%;
                border-radius: 8px;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.22);
            }
        </style>

    </head>

    <body class="bg-light">

        <nav class="navbar navbar-dark bg-primary">

            <div class="container">

                <a class="navbar-brand fw-bold"
                   href="index.html">
                    📚 BOOKHUB
                </a>

                <div class="d-flex gap-2">
                    <a href="InnovacionServlet"
                       class="btn btn-outline-light btn-sm">
                        ODS 09
                    </a>
                    <a href="MisPrestamosServlet"
                       class="btn btn-outline-light btn-sm">
                        Mis préstamos
                    </a>
                    <a href="CatalogoServlet"
                       class="btn btn-light btn-sm">
                        ← Volver al catálogo
                    </a>
                </div>

            </div>

        </nav>


        <div class="container py-5">

            <div class="row justify-content-center">

                <div class="col-md-9">

                    <% if ("prestado".equals(exito)) { %>
                        <div class="alert alert-success">
                            ✅ <strong>¡Préstamo registrado exitosamente!</strong> Tienes 7 días para devolver el ejemplar. Puedes consultarlo en <a href="MisPrestamosServlet" class="alert-link">Mis préstamos</a>.
                        </div>
                    <% } else if ("yaPrestado".equals(error)) { %>
                        <div class="alert alert-warning">
                            ⚠️ Ya tienes un préstamo activo de este libro. Revisa <a href="MisPrestamosServlet" class="alert-link">Mis préstamos</a>.
                        </div>
                    <% } else if ("sinStock".equals(error)) { %>
                        <div class="alert alert-danger">
                            ❌ Lo sentimos, este libro no cuenta con ejemplares disponibles en este momento.
                        </div>
                    <% } %>

                    <div class="card shadow-sm">

                        <div class="card-body p-4 p-md-5">

                            <div class="row g-4 align-items-start">

                                <!-- COLUMNA PORTADA -->
                                <div class="col-md-4">
                                    <div class="detalle-portada-box">
                                        <img src="<%= libro.getImagenPortada() %>"
                                             alt="Portada de <%= libro.getTitulo() %>"
                                             class="detalle-portada-img"
                                             onerror="this.onerror=null;this.src='img/portadas/default.svg';">
                                    </div>
                                </div>

                                <!-- COLUMNA INFORMACIÓN -->
                                <div class="col-md-8">

                                    <span class="badge <%= esOds ? "badge-ods" : "bg-primary" %> mb-3">
                                        <%= libro.getNombreCategoria() %>
                                    </span>

                                    <h2 class="fw-bold mb-3">
                                        <%= libro.getTitulo()%>
                                    </h2>

                                    <hr>

                                    <div class="row mb-3">

                                        <div class="col-md-4 fw-bold">
                                            Autor
                                        </div>

                                        <div class="col-md-8">
                                            <%= libro.getNombreAutor() %>
                                        </div>

                                    </div>

                                    <div class="row mb-3">

                                        <div class="col-md-4 fw-bold">
                                            Categoría
                                        </div>

                                        <div class="col-md-8">
                                            <%= libro.getNombreCategoria() %>
                                        </div>

                                    </div>

                                    <div class="row mb-3">

                                        <div class="col-md-4 fw-bold">
                                            ISBN
                                        </div>

                                        <div class="col-md-8">
                                            <%= libro.getIsbn()%>
                                        </div>

                                    </div>

                                    <div class="row mb-3">

                                        <div class="col-md-4 fw-bold">
                                            Año de publicación
                                        </div>

                                        <div class="col-md-8">
                                            <%= libro.getAnio()%>
                                        </div>

                                    </div>

                                    <div class="row mb-3">

                                        <div class="col-md-4 fw-bold">
                                            Descripción
                                        </div>

                                        <div class="col-md-8">
                                            <%= libro.getDescripcion()%>
                                        </div>

                                    </div>

                                    <div class="row mb-4">

                                        <div class="col-md-4 fw-bold">
                                            Disponibilidad
                                        </div>

                                        <div class="col-md-8">

                                            <% if (libro.getStock() > 0) {%>

                                            <span class="badge bg-success">
                                                Disponible
                                            </span>

                                            <span class="ms-2">
                                                <%= libro.getStock()%> ejemplares
                                            </span>

                                            <% } else { %>

                                            <span class="badge bg-danger">
                                                No disponible
                                            </span>

                                            <% } %>

                                        </div>

                                    </div>


                                    <div class="d-flex gap-2">
                                        <% if (libro.getStock() > 0) { %>

                                        <a href="SolicitarPrestamoServlet?idLibro=<%= libro.getIdLibro() %>"
                                           class="btn btn-primary">
                                            Solicitar préstamo
                                        </a>

                                        <% } else { %>

                                        <button class="btn btn-secondary"
                                                disabled>
                                            Libro no disponible
                                        </button>

                                        <% } %>

                                        <a href="CatalogoServlet"
                                           class="btn btn-outline-secondary">
                                            Volver al catálogo
                                        </a>
                                    </div>

                                </div>

                            </div>

                        </div>

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
