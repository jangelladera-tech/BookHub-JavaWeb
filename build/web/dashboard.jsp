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
            padding: 11px 14px;
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
                <small class="text-white-50" style="font-size: 0.72rem;">Panel de Administración</small>
            </div>
        </div>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas" aria-label="Cerrar"></button>
    </div>

    <div class="offcanvas-body d-flex flex-column justify-content-between p-3">
        <div>
            <div class="p-3 mb-3 rounded-3 bg-danger bg-opacity-10 border border-danger border-opacity-25">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-shield-lock-fill fs-3 text-danger"></i>
                    <div class="overflow-hidden">
                        <div class="fw-semibold text-white text-truncate"><%= usuario.getNombre() %></div>
                        <span class="badge bg-danger" style="font-size: 0.68rem;">ADMINISTRADOR</span>
                    </div>
                </div>
            </div>

            <!-- APARTADOS PRINCIPALES -->
            <p class="sidebar-subtitle mb-2 px-2">Apartados Principales</p>
            <div class="d-flex flex-column gap-1 mb-3">
                <a href="index.html" class="sidebar-menu-item">
                    <i class="bi bi-house-door-fill menu-icon text-warning"></i>
                    <div class="flex-grow-1">
                        <div>Inicio</div>
                        <small class="text-white-50" style="font-size: 0.72rem;">Portal de lectura</small>
                    </div>
                </a>

                <a href="CatalogoServlet" class="sidebar-menu-item">
                    <i class="bi bi-journal-bookmark-fill menu-icon text-info"></i>
                    <div class="flex-grow-1">
                        <div>Catálogo</div>
                        <small class="text-white-50" style="font-size: 0.72rem;">Vista pública de libros</small>
                    </div>
                </a>

                <a href="InnovacionServlet" class="sidebar-menu-item">
                    <i class="bi bi-universal-access-circle menu-icon text-success"></i>
                    <div class="flex-grow-1">
                        <div>ODS 09: Accesibilidad</div>
                        <small class="text-white-50" style="font-size: 0.72rem;">Inclusión asistiva WCAG</small>
                    </div>
                </a>
            </div>

            <!-- MÓDULOS DE ADMINISTRACIÓN -->
            <p class="sidebar-subtitle mb-2 px-2">Gestión del Sistema</p>
            <div class="d-flex flex-column gap-1 mb-3">
                <a href="dashboard.jsp" class="sidebar-menu-item active">
                    <i class="bi bi-speedometer2 menu-icon text-warning"></i>
                    <span>Dashboard</span>
                </a>
                <a href="LibrosServlet" class="sidebar-menu-item">
                    <i class="bi bi-book-half menu-icon text-info"></i>
                    <span>Gestión de Libros</span>
                </a>
                <a href="PrestamosServlet" class="sidebar-menu-item">
                    <i class="bi bi-card-checklist menu-icon text-primary"></i>
                    <span>Gestión de Préstamos</span>
                </a>
                <a href="UsuariosServlet" class="sidebar-menu-item">
                    <i class="bi bi-people-fill menu-icon text-success"></i>
                    <span>Gestión de Usuarios</span>
                </a>
                <a href="CategoriasServlet" class="sidebar-menu-item">
                    <i class="bi bi-tags-fill menu-icon text-warning"></i>
                    <span>Categorías</span>
                </a>
                <a href="AutoresServlet" class="sidebar-menu-item">
                    <i class="bi bi-pen-fill menu-icon text-danger"></i>
                    <span>Autores</span>
                </a>
            </div>

            <!-- NUEVOS MÓDULOS -->
            <p class="sidebar-subtitle mb-2 px-2">Nuevos Módulos</p>
            <div class="d-flex flex-column gap-1 mb-3">
                <a href="DonacionesServlet" class="sidebar-menu-item">
                    <i class="bi bi-gift-fill menu-icon text-danger"></i>
                    <span>Donaciones de Libros</span>
                </a>
                <a href="ReportesServlet" class="sidebar-menu-item">
                    <i class="bi bi-graph-up-arrow menu-icon text-info"></i>
                    <span>Reportes & Métricas</span>
                </a>
                <a href="SancionesServlet" class="sidebar-menu-item">
                    <i class="bi bi-exclamation-octagon-fill menu-icon text-warning"></i>
                    <span>Sanciones & Mora</span>
                </a>
            </div>
        </div>

        <div class="pt-3 border-top border-secondary border-opacity-25 text-center text-white-50 small">
            <span>BookHub v2.0 • Panel Administrativo</span>
        </div>
    </div>
</div>

<!-- NAVBAR CON BOTÓN DE TRES LÍNEAS (SE DESVANECE AL HACER SCROLL) -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm py-2 navbar-scroll-fade" id="mainNavbar">
    <div class="container-fluid px-3 px-lg-4">

        <div class="d-flex align-items-center gap-2">
            <button class="btn-sidebar-toggle"
                    type="button"
                    data-bs-toggle="offcanvas"
                    data-bs-target="#sidebarBookHub"
                    aria-controls="sidebarBookHub"
                    title="Abrir menú de apartados y gestión"
                    aria-label="Menú principal de 3 líneas">
                <i class="bi bi-list fs-3"></i>
            </button>

            <a class="navbar-brand fw-bold d-flex align-items-center gap-2 m-0" href="dashboard.jsp">
                <span>BookHub</span>
                <span class="badge bg-danger" style="font-size: 0.65rem;">ADMIN</span>
            </a>
        </div>

        <!-- Lado derecho: EXCLUSIVAMENTE sesión -->
        <div class="d-flex align-items-center gap-2 ms-auto">
            <span class="text-white small d-none d-sm-inline">
                Admin: <strong><%= usuario.getNombre() %></strong>
            </span>

            <a href="LogoutServlet" class="btn btn-outline-danger btn-sm d-flex align-items-center gap-1">
                <i class="bi bi-box-arrow-left"></i> <span>Salir</span>
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

        <!-- 1. DONACIONES DE LIBROS -->
        <div class="col-md-6 col-lg-4">
            <div class="card shadow-sm h-100 border-start border-danger border-4">
                <div class="card-body">
                    <h4 class="card-title text-danger">
                        🎁 Donaciones
                    </h4>
                    <p class="card-text">
                        Revisa solicitudes de libros donados e incorpóralos al catálogo con 1 clic.
                    </p>
                    <a href="DonacionesServlet" class="btn btn-danger">
                        Gestionar donaciones
                    </a>
                </div>
            </div>
        </div>

        <!-- 2. REPORTES Y MÉTRICAS -->
        <div class="col-md-6 col-lg-4">
            <div class="card shadow-sm h-100 border-start border-info border-4">
                <div class="card-body">
                    <h4 class="card-title text-info">
                        📊 Reportes & KPIs
                    </h4>
                    <p class="card-text">
                        Métricas de acervo, préstamos del mes, categorías y alertas de stock crítico.
                    </p>
                    <a href="ReportesServlet" class="btn btn-info text-white">
                        Ver métricas y reportes
                    </a>
                </div>
            </div>
        </div>

        <!-- 3. SANCIONES Y MORA -->
        <div class="col-md-6 col-lg-4">
            <div class="card shadow-sm h-100 border-start border-warning border-4">
                <div class="card-body">
                    <h4 class="card-title text-warning">
                        ⚠️ Sanciones & Mora
                    </h4>
                    <p class="card-text">
                        Monitorea préstamos con fecha vencida y regulariza devoluciones atrasadas.
                    </p>
                    <a href="SancionesServlet" class="btn btn-warning text-dark">
                        Controlar sanciones
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