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

        /* BOTÓN DE 3 LÍNEAS (HAMBURGUESA) */
        .btn-sidebar-toggle {
            width: 42px;
            height: 42px;
            border-radius: 10px;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: #ffffff;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
            cursor: pointer;
        }
        .btn-sidebar-toggle:hover, .btn-sidebar-toggle:focus {
            background: rgba(255, 255, 255, 0.22);
            border-color: #ffffff;
            color: #ffffff;
            transform: scale(1.05);
        }

        /* VENTANA LATERAL (OFFCANVAS) */
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
                        <span class="badge bg-primary" style="font-size: 0.68rem;"><%= usuario.getRol() %></span>
                    </div>
                </div>
            </div>

            <!-- APARTADOS PRINCIPALES -->
            <p class="sidebar-subtitle mb-2 px-2">Apartados Principales</p>
            <div class="d-flex flex-column gap-1 mb-4">
                <a href="index.html" class="sidebar-menu-item">
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

                <a href="MisPrestamosServlet" class="sidebar-menu-item">
                    <i class="bi bi-clock-history menu-icon text-warning"></i>
                    <div class="flex-grow-1">
                        <div>Mis Préstamos</div>
                        <small class="text-white-50" style="font-size: 0.72rem;">Libros prestados y fechas</small>
                    </div>
                </a>
            </div>

            <!-- SERVICIOS -->
            <p class="sidebar-subtitle mb-2 px-2">Servicios</p>
            <div class="d-flex flex-column gap-2 mb-3">
                <a href="CatalogoServlet" class="btn btn-outline-light text-start d-flex align-items-center gap-2 py-2 px-3 rounded-3">
                    <i class="bi bi-search"></i> Explorar Catálogo
                </a>
                <a href="InnovacionServlet" class="btn btn-outline-info text-start d-flex align-items-center gap-2 py-2 px-3 rounded-3">
                    <i class="bi bi-universal-access"></i> Centro ODS 09
                </a>
            </div>
        </div>

        <div class="pt-3 border-top border-secondary border-opacity-25 text-center text-white-50 small">
            <span>BookHub v2.0 • Inclusión Digital</span>
        </div>
    </div>
</div>

<!-- NAVBAR CON BOTÓN DE TRES LÍNEAS (SE DESVANECE AL HACER SCROLL) -->
<nav class="navbar navbar-dark bg-dark sticky-top shadow-sm py-2 navbar-scroll-fade" id="mainNavbar">
    <div class="container-fluid px-3 px-lg-4">

        <div class="d-flex align-items-center gap-2">
            <button class="btn-sidebar-toggle"
                    type="button"
                    data-bs-toggle="offcanvas"
                    data-bs-target="#sidebarBookHub"
                    aria-controls="sidebarBookHub"
                    title="Abrir menú de apartados (Inicio, Catálogo, ODS 09, Mis préstamos)"
                    aria-label="Menú principal de 3 líneas">
                <i class="bi bi-list fs-3"></i>
            </button>

            <a class="navbar-brand fw-bold d-flex align-items-center gap-2 m-0" href="index.html">
                <span>BookHub</span>
            </a>
        </div>

        <!-- Lado derecho: EXCLUSIVAMENTE sesión -->
        <div class="d-flex align-items-center gap-2 ms-auto">
            <span class="text-white small d-none d-sm-inline">
                Hola, <strong><%= usuario.getNombre() %></strong>
            </span>

            <a href="LogoutServlet" class="btn btn-outline-danger btn-sm d-flex align-items-center gap-1">
                <i class="bi bi-box-arrow-left"></i> <span>Salir</span>
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

</body>

</html>