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

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        /* EFECTO DE DESVANECIMIENTO AL HACER SCROLL */
        .navbar-scroll-fade {
            transition: opacity 0.35s ease, transform 0.35s ease;
        }
        .navbar-scroll-fade.navbar-hidden {
            opacity: 0 !important;
            pointer-events: none !important;
            transform: translateY(-10px);
        }

        /* ESTILOS DE LA VENTANA LATERAL (OFFCANVAS) Y BOTÓN HAMBURGUESA */
        .btn-sidebar-toggle {
            width: 42px;
            height: 42px;
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: #ffffff;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
            cursor: pointer;
        }
        .btn-sidebar-toggle:hover, .btn-sidebar-toggle:focus {
            background: rgba(255, 255, 255, 0.2);
            border-color: #ffffff;
            color: #ffffff;
            transform: scale(1.05);
        }
        .offcanvas-bookhub {
            width: 320px !important;
            background: #0f172a !important;
            color: #f8fafc;
            border-right: 1px solid #334155 !important;
        }
        .sidebar-menu-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 14px;
            border-radius: 10px;
            color: #e2e8f0;
            text-decoration: none;
            transition: all 0.2s ease;
            font-weight: 500;
        }
        .sidebar-menu-item:hover {
            background: rgba(255, 255, 255, 0.1);
            color: #ffffff;
            transform: translateX(4px);
        }
        .sidebar-menu-item.active {
            background: #2563eb;
            color: #ffffff;
            font-weight: 600;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.35);
        }
        .sidebar-menu-item .menu-icon {
            font-size: 1.25rem;
            width: 24px;
            text-align: center;
        }
        .sidebar-subtitle {
            font-size: 0.72rem;
            letter-spacing: 0.08em;
            color: #94a3b8;
            font-weight: 700;
            text-transform: uppercase;
        }
    </style>

</head>

<body class="bg-light">

<!-- VENTANA A LA MANO IZQUIERDA (SIDEBAR OFFCANVAS) -->
<div class="offcanvas offcanvas-start offcanvas-bookhub shadow-lg"
     tabindex="-1"
     id="sidebarBookHub"
     aria-labelledby="sidebarBookHubLabel">

    <div class="offcanvas-header border-bottom border-secondary border-opacity-25 pb-3">
        <div class="d-flex align-items-center gap-2">
            <span class="fs-3">📚</span>
            <div>
                <h5 class="offcanvas-title fw-bold text-white mb-0" id="sidebarBookHubLabel">BookHub</h5>
                <small class="text-white-50" style="font-size: 0.72rem;">Biblioteca Universitaria</small>
            </div>
        </div>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas" aria-label="Cerrar"></button>
    </div>

    <div class="offcanvas-body d-flex flex-column justify-content-between p-3">
        <div>
            <div class="p-3 mb-3 rounded-3 bg-secondary bg-opacity-25 border border-secondary border-opacity-25">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-person-circle fs-3 text-info"></i>
                    <div class="overflow-hidden">
                        <div class="fw-semibold text-white text-truncate"><%= usuario.getNombre() %></div>
                        <span class="badge <%= "ADMIN".equals(usuario.getRol()) ? "bg-danger" : "bg-primary" %>" style="font-size: 0.68rem;">
                            <%= usuario.getRol() %>
                        </span>
                    </div>
                </div>
            </div>

            <!-- APARTADOS PRINCIPALES -->
            <p class="sidebar-subtitle mb-2 px-2">Apartados Principales</p>
            <div class="d-flex flex-column gap-1 mb-4">
                <a href="index.jsp" class="sidebar-menu-item">
                    <i class="bi bi-house-door-fill menu-icon text-warning"></i>
                    <div class="flex-grow-1">
                        <div>Inicio</div>
                        <small class="text-white-50" style="font-size: 0.72rem;">Portal principal y novedades</small>
                    </div>
                </a>

                <a href="CatalogoServlet" class="sidebar-menu-item">
                    <i class="bi bi-journal-bookmark-fill menu-icon text-info"></i>
                    <div class="flex-grow-1">
                        <div>Catálogo</div>
                        <small class="text-white-50" style="font-size: 0.72rem;">Explorar libros y categorías</small>
                    </div>
                </a>

                <a href="InnovacionServlet" class="sidebar-menu-item">
                    <i class="bi bi-universal-access-circle menu-icon text-success"></i>
                    <div class="flex-grow-1">
                        <div>ODS 09: Accesibilidad</div>
                        <small class="text-white-50" style="font-size: 0.72rem;">Inclusión asistiva WCAG</small>
                    </div>
                </a>

                <a href="MisPrestamosServlet" class="sidebar-menu-item active">
                    <i class="bi bi-clock-history menu-icon text-warning"></i>
                    <div class="flex-grow-1">
                        <div>Mis Préstamos</div>
                        <small class="text-white-50" style="font-size: 0.72rem;">Libros prestados y fechas</small>
                    </div>
                </a>

                <a href="donar.jsp" class="sidebar-menu-item">
                    <i class="bi bi-gift-fill menu-icon text-danger"></i>
                    <div class="flex-grow-1">
                        <div>Donar Libros</div>
                        <small class="text-white-50" style="font-size: 0.72rem;">Dona libros a la biblioteca</small>
                    </div>
                </a>
            </div>

            <!-- ACCESOS RÁPIDOS -->
            <p class="sidebar-subtitle mb-2 px-2">Servicios</p>
            <div class="d-flex flex-column gap-2 mb-3">
                <a href="CatalogoServlet" class="btn btn-outline-light text-start d-flex align-items-center gap-2 py-2 px-3 rounded-3">
                    <i class="bi bi-search"></i> Explorar Catálogo
                </a>
                <a href="InnovacionServlet" class="btn btn-outline-info text-start d-flex align-items-center gap-2 py-2 px-3 rounded-3">
                    <i class="bi bi-universal-access"></i> Tecnologías ODS 09
                </a>
            </div>
        </div>

        <div class="pt-3 border-top border-secondary border-opacity-25 text-center text-white-50 small">
            <span>BookHub v2.0 • Inclusión Digital</span>
        </div>
    </div>
</div>


<!-- NAVBAR CON BOTÓN DE TRES LÍNEAS (SE DESVANECE AL HACER SCROLL) -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm py-2 navbar-scroll-fade" id="mainNavbar">
    <div class="container-fluid px-3 px-lg-4">

        <div class="d-flex align-items-center gap-2">
            <!-- Botón de tres líneas (Hamburguesa) que abre la ventana izquierda -->
            <button class="btn-sidebar-toggle"
                    type="button"
                    data-bs-toggle="offcanvas"
                    data-bs-target="#sidebarBookHub"
                    aria-controls="sidebarBookHub"
                    title="Abrir menú de apartados (Inicio, Catálogo, ODS 09, Mis préstamos)"
                    aria-label="Abrir menú de navegación">
                <i class="bi bi-list fs-3"></i>
            </button>

            <a class="navbar-brand fw-bold d-flex align-items-center gap-2 m-0" href="index.jsp">
                <span>BookHub</span>
            </a>
        </div>

        <!-- Lado derecho: Exclusivamente sesión -->
        <div class="d-flex align-items-center gap-2 ms-auto">
            <a href="usuario.jsp" class="btn btn-light btn-sm d-flex align-items-center gap-1">
                <i class="bi bi-person-circle"></i> <span>Mi cuenta</span>
            </a>

            <a href="LogoutServlet" class="btn btn-outline-danger btn-sm d-flex align-items-center gap-1">
                <i class="bi bi-box-arrow-left"></i> <span>Salir</span>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    window.addEventListener('scroll', function() {
        const navbar = document.getElementById('mainNavbar');
        if (!navbar) return;
        const currentScrollY = window.pageYOffset || document.documentElement.scrollTop;
        if (currentScrollY > 70) {
            navbar.classList.add('navbar-hidden');
        } else {
            navbar.classList.remove('navbar-hidden');
        }
    }, { passive: true });
</script>

<%@include file="a11y-panel.jsp"%>

</body>

</html>
