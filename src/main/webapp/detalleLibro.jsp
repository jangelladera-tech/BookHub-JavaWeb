<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="beans.Libro"%>
<%@page import="beans.Usuario"%>

<%
    Libro libro = (Libro) request.getAttribute("libro");
    if (libro == null) {
        response.sendRedirect("CatalogoServlet");
        return;
    }

    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
    String error = request.getParameter("error");
    String exito = request.getParameter("exito");
    String descLimpia = (libro.getDescripcion() != null) ? libro.getDescripcion().replace("\"", "&quot;").replace("'", "") : "";
    String titLimpio = (libro.getTitulo() != null) ? libro.getTitulo().replace("\"", "&quot;").replace("'", "") : "";
    String autLimpio = (libro.getNombreAutor() != null) ? libro.getNombreAutor().replace("\"", "&quot;").replace("'", "") : "";
    String portadaUrl = libro.getImagenPortada();
    if (portadaUrl == null || portadaUrl.trim().isEmpty()) {
        portadaUrl = "img/portadas/default.svg";
    }
%>

<!DOCTYPE html>
<html lang="es">

<head>
    <!-- Favicon / Logo de pestaña del navegador -->
    <link rel="icon" type="image/svg+xml" href="img/logo.svg">
    <link rel="alternate icon" type="image/x-icon" href="favicon.ico">
    <link rel="apple-touch-icon" href="img/logo.svg">


    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= libro.getTitulo() %> - BookHub</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        :root {
            --a11y-font-scale: 1;
            --a11y-line-height: 1.5;
        }

        body {
            background-color: #f8fafc;
            color: #1e293b;
            font-size: calc(1rem * var(--a11y-font-scale));
            line-height: var(--a11y-line-height);
            transition: background-color 0.2s ease, color 0.2s ease;
        }

        .detalle-portada-box {
            background-color: #f1f5f9;
            border-radius: 8px;
            padding: 16px;
            text-align: center;
            border: 1px solid #e2e8f0;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .detalle-portada-img {
            width: 200px;
            height: 280px;
            max-width: 100%;
            object-fit: cover;
            border-radius: 6px;
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.16);
            display: block;
        }

        .audio-player-card {
            background-color: #f8fafc;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            padding: 14px 16px;
        }

        /* ========================================================
           SISTEMA DE CONTRASTE CALIBRADO WCAG AAA (SIN TEXTO PERDIDO)
           ======================================================== */

        /* 1. MODO SEPIA */
        body.a11y-theme-sepia {
            background-color: #fbf0d9 !important;
            color: #3d2b1f !important;
        }
        body.a11y-theme-sepia .card,
        body.a11y-theme-sepia .navbar,
        body.a11y-theme-sepia footer,
        body.a11y-theme-sepia .detalle-portada-box,
        body.a11y-theme-sepia .audio-player-card {
            background: #f4e6c0 !important;
            background-color: #f4e6c0 !important;
            color: #3d2b1f !important;
            border-color: #dfcca4 !important;
        }
        body.a11y-theme-sepia h1,
        body.a11y-theme-sepia h2,
        body.a11y-theme-sepia h3,
        body.a11y-theme-sepia h4,
        body.a11y-theme-sepia h5,
        body.a11y-theme-sepia h6,
        body.a11y-theme-sepia strong,
        body.a11y-theme-sepia th {
            color: #261a12 !important;
        }
        body.a11y-theme-sepia .text-muted,
        body.a11y-theme-sepia .text-secondary,
        body.a11y-theme-sepia .text-dark,
        body.a11y-theme-sepia .text-white-50 {
            color: #5c4331 !important;
        }
        body.a11y-theme-sepia .form-control,
        body.a11y-theme-sepia .form-select {
            background-color: #fbf0d9 !important;
            color: #3d2b1f !important;
            border-color: #bfa67c !important;
        }
        body.a11y-theme-sepia a {
            color: #8b3a00 !important;
        }
        body.a11y-theme-sepia .btn-primary {
            background-color: #8b3a00 !important;
            border-color: #8b3a00 !important;
            color: #ffffff !important;
        }
        body.a11y-theme-sepia .btn-outline-primary,
        body.a11y-theme-sepia .btn-outline-secondary {
            border-color: #8b3a00 !important;
            color: #8b3a00 !important;
            background-color: transparent !important;
        }
        body.a11y-theme-sepia .badge {
            background-color: #dfcca4 !important;
            color: #3d2b1f !important;
            border: 1px solid #bfa67c !important;
        }

        /* 2. MODO NOCHE / PIZARRA */
        body.a11y-theme-dark {
            background-color: #0f172a !important;
            color: #f8fafc !important;
        }
        body.a11y-theme-dark .card,
        body.a11y-theme-dark .navbar,
        body.a11y-theme-dark footer,
        body.a11y-theme-dark .detalle-portada-box,
        body.a11y-theme-dark .audio-player-card {
            background: #1e293b !important;
            background-color: #1e293b !important;
            color: #f8fafc !important;
            border-color: #334155 !important;
        }
        body.a11y-theme-dark h1,
        body.a11y-theme-dark h2,
        body.a11y-theme-dark h3,
        body.a11y-theme-dark h4,
        body.a11y-theme-dark h5,
        body.a11y-theme-dark h6,
        body.a11y-theme-dark strong,
        body.a11y-theme-dark th {
            color: #ffffff !important;
        }
        body.a11y-theme-dark .text-muted,
        body.a11y-theme-dark .text-secondary,
        body.a11y-theme-dark .text-dark,
        body.a11y-theme-dark .text-white-50 {
            color: #cbd5e1 !important;
        }
        body.a11y-theme-dark .form-control,
        body.a11y-theme-dark .form-select {
            background-color: #0f172a !important;
            color: #f8fafc !important;
            border-color: #475569 !important;
        }
        body.a11y-theme-dark a {
            color: #60a5fa !important;
        }
        body.a11y-theme-dark .btn-primary {
            background-color: #2563eb !important;
            border-color: #2563eb !important;
            color: #ffffff !important;
        }
        body.a11y-theme-dark .btn-outline-primary,
        body.a11y-theme-dark .btn-outline-secondary {
            border-color: #94a3b8 !important;
            color: #f1f5f9 !important;
            background-color: transparent !important;
        }
        body.a11y-theme-dark .badge {
            background-color: #334155 !important;
            color: #f8fafc !important;
            border: 1px solid #475569 !important;
        }

        /* 3. ALTO CONTRASTE PURO WCAG AAA */
        body.a11y-theme-contrast {
            background-color: #000000 !important;
            color: #ffffff !important;
        }
        body.a11y-theme-contrast .card,
        body.a11y-theme-contrast .navbar,
        body.a11y-theme-contrast footer,
        body.a11y-theme-contrast .detalle-portada-box,
        body.a11y-theme-contrast .audio-player-card {
            background: #0a0a0a !important;
            background-color: #0a0a0a !important;
            color: #ffffff !important;
            border: 2px solid #facc15 !important;
        }
        body.a11y-theme-contrast h1,
        body.a11y-theme-contrast h2,
        body.a11y-theme-contrast h3,
        body.a11y-theme-contrast h4,
        body.a11y-theme-contrast h5,
        body.a11y-theme-contrast h6,
        body.a11y-theme-contrast strong,
        body.a11y-theme-contrast th {
            color: #facc15 !important;
        }
        body.a11y-theme-contrast p,
        body.a11y-theme-contrast span,
        body.a11y-theme-contrast td,
        body.a11y-theme-contrast div {
            color: #ffffff !important;
        }
        body.a11y-theme-contrast .text-muted,
        body.a11y-theme-contrast .text-secondary,
        body.a11y-theme-contrast .text-dark,
        body.a11y-theme-contrast .text-white-50 {
            color: #ffffff !important;
            font-weight: 500 !important;
        }
        body.a11y-theme-contrast .form-control,
        body.a11y-theme-contrast .form-select {
            background-color: #000000 !important;
            color: #facc15 !important;
            border: 2px solid #facc15 !important;
        }
        body.a11y-theme-contrast a {
            color: #38bdf8 !important;
            text-decoration: underline !important;
        }
        body.a11y-theme-contrast .btn-primary {
            background-color: #facc15 !important;
            border-color: #facc15 !important;
            color: #000000 !important;
            font-weight: bold !important;
        }
        body.a11y-theme-contrast .btn-outline-primary,
        body.a11y-theme-contrast .btn-outline-secondary {
            border: 2px solid #facc15 !important;
            color: #facc15 !important;
            background-color: #000000 !important;
            font-weight: 600 !important;
        }
        body.a11y-theme-contrast .badge {
            background-color: #000000 !important;
            color: #facc15 !important;
            border: 1px solid #facc15 !important;
        }

        /* DISLEXIA Y SUBRAYADO */
        body.a11y-dyslexia {
            font-family: 'OpenDyslexic', 'Segoe UI', Arial, sans-serif !important;
            letter-spacing: 0.08em !important;
            word-spacing: 0.15em !important;
            line-height: 1.8 !important;
        }

        body.a11y-underline-links a,
        body.a11y-underline-links button {
            text-decoration: underline !important;
            text-underline-offset: 3px !important;
        }

        /* MÁSCARA GUÍA DE LECTURA (TDAH / ENFOQUE) */
        #a11yReadingRuler {
            display: none;
            position: fixed;
            left: 0;
            width: 100vw;
            height: 48px;
            background: rgba(37, 99, 235, 0.15);
            border-top: 2px solid #2563eb;
            border-bottom: 2px solid #2563eb;
            box-shadow: 0 0 0 9999px rgba(0, 0, 0, 0.35);
            pointer-events: none;
            z-index: 99999;
            transform: translateY(-50%);
        }

        /* BOTÓN FLOTANTE PARA ESCUCHAR TEXTO SELECCIONADO */
        #a11yBtnAudioSel {
            display: none;
            position: absolute;
            z-index: 100000;
            background: #1e3a8a;
            color: #ffffff;
            border: 1px solid #ffffff;
            border-radius: 20px;
            padding: 4px 12px;
            font-size: 0.8rem;
            font-weight: 600;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.25);
            cursor: pointer;
        }
        #a11yBtnAudioSel:hover {
            background: #2563eb;
        }

        /* BOTÓN Y PANEL LATERAL */
        .a11y-float-btn {
            position: fixed;
            bottom: 24px;
            right: 24px;
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: #1e3a8a;
            color: #ffffff;
            border: 2px solid #ffffff;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            z-index: 9999;
            font-weight: bold;
            font-size: 1.15rem;
            transition: transform 0.2s ease, background 0.2s ease;
        }
        .a11y-float-btn:hover {
            transform: scale(1.08);
            background: #2563eb;
        }

        .a11y-panel {
            position: fixed;
            top: 0;
            right: 0;
            bottom: 0;
            width: 340px;
            max-width: 90vw;
            background: #ffffff;
            border-left: 1px solid #cbd5e1;
            box-shadow: -8px 0 24px rgba(0, 0, 0, 0.15);
            z-index: 10000;
            overflow-y: auto;
            display: none;
            animation: slideInRight 0.25s ease-out;
        }
        @keyframes slideInRight {
            from { transform: translateX(100%); }
            to { transform: translateX(0); }
        }

        .a11y-panel-header {
            background: #1e3a8a;
            color: #ffffff;
            padding: 16px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .a11y-panel-body {
            padding: 18px 20px;
        }
        .a11y-section-title {
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            color: #64748b;
            margin-bottom: 8px;
            margin-top: 14px;
        }

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

        /* BOTÓN DE AUDIO ULTRA DETALLADO */
        .btn-audio-detailed {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            padding: 7px 16px;
            font-size: 0.85rem;
            font-weight: 600;
            letter-spacing: 0.3px;
            border-radius: 50px;
            background: linear-gradient(135deg, #1e3a8a 0%, #2563eb 100%);
            color: #ffffff !important;
            border: 1px solid rgba(255, 255, 255, 0.25);
            box-shadow: 0 2px 6px rgba(37, 99, 235, 0.25), inset 0 1px 0 rgba(255, 255, 255, 0.2);
            transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
            text-decoration: none;
            cursor: pointer;
        }
        .btn-audio-detailed:hover {
            background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.45);
            transform: translateY(-2px);
            color: #ffffff !important;
        }
        .btn-audio-detailed:active {
            transform: translateY(0);
        }
        .btn-audio-detailed i {
            font-size: 1rem;
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
                <img src="img/logo.svg" alt="BookHub Logo" width="36" height="36" class="d-inline-block">
                <div>
                    <h5 class="offcanvas-title fw-bold text-white mb-0" id="sidebarBookHubLabel">BookHub</h5>
                    <small class="text-white-50" style="font-size: 0.72rem;">Biblioteca Universitaria</small>
                </div>
            </div>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas" aria-label="Cerrar"></button>
        </div>

        <div class="offcanvas-body d-flex flex-column justify-content-between p-3">
            <div>
                <% if (usuarioSesion != null) { %>
                    <div class="p-3 mb-3 rounded-3 bg-secondary bg-opacity-25 border border-secondary border-opacity-25">
                        <div class="d-flex align-items-center gap-2">
                            <i class="bi bi-person-circle fs-3 text-info"></i>
                            <div class="overflow-hidden">
                                <div class="fw-semibold text-white text-truncate"><%= usuarioSesion.getNombre() %></div>
                                <span class="badge <%= "ADMIN".equals(usuarioSesion.getRol()) ? "bg-danger" : "bg-primary" %>" style="font-size: 0.68rem;">
                                    <%= usuarioSesion.getRol() %>
                                </span>
                            </div>
                        </div>
                    </div>
                <% } %>

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

                    <a href="CatalogoServlet" class="sidebar-menu-item active">
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

                    <a href="donar.jsp" class="sidebar-menu-item">
                        <i class="bi bi-gift-fill menu-icon text-danger"></i>
                        <div class="flex-grow-1">
                            <div>Donar Libros</div>
                            <small class="text-white-50" style="font-size: 0.72rem;">Dona libros a la biblioteca</small>
                        </div>
                    </a>
                </div>

                <!-- HERRAMIENTAS Y ACCESIBILIDAD -->
                <p class="sidebar-subtitle mb-2 px-2">Herramientas & Inclusión</p>
                <div class="d-flex flex-column gap-2 mb-3">
                    <button class="btn btn-outline-info text-start d-flex align-items-center gap-2 py-2 px-3 rounded-3"
                            type="button"
                            onclick="toggleA11yPanel()">
                        <i class="bi bi-eye"></i> Panel Accesibilidad (WCAG)
                    </button>
                    <a href="CatalogoServlet" class="btn btn-outline-light text-start d-flex align-items-center gap-2 py-2 px-3 rounded-3">
                        <i class="bi bi-mic"></i> Búsqueda por Voz
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

            <!-- Lado izquierdo: Botón de tres líneas + Logo -->
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

                <a class="navbar-brand fw-bold d-flex align-items-center gap-2 m-0" href="index.jsp">
                    <img src="img/logo.svg" alt="BookHub Logo" width="34" height="34" class="d-inline-block">
                    <span>BookHub</span>
                </a>
            </div>

            <!-- Lado derecho: EXCLUSIVAMENTE Iniciar Sesión / Registrarse (o Perfil / Salir) -->
            <div class="d-flex align-items-center gap-2 ms-auto">
                <% if (usuarioSesion != null) { %>
                    <% if ("ADMIN".equals(usuarioSesion.getRol())) { %>
                        <a href="dashboard.jsp" class="btn btn-warning btn-sm d-flex align-items-center gap-1">
                            <i class="bi bi-speedometer2"></i> <span class="d-none d-sm-inline">Panel Admin</span>
                        </a>
                    <% } else { %>
                        <a href="usuario.jsp" class="btn btn-light btn-sm d-flex align-items-center gap-1">
                            <i class="bi bi-person-circle"></i> <span class="d-none d-sm-inline"><%= usuarioSesion.getNombre() %></span>
                        </a>
                    <% } %>
                    <a href="LogoutServlet" class="btn btn-outline-danger btn-sm d-flex align-items-center gap-1">
                        <i class="bi bi-box-arrow-left"></i> <span>Salir</span>
                    </a>
                <% } else { %>
                    <a href="login.jsp" class="btn btn-light btn-sm d-flex align-items-center gap-1">
                        <i class="bi bi-box-arrow-in-right"></i> <span>Iniciar sesión</span>
                    </a>
                    <a href="registro.jsp" class="btn btn-outline-light btn-sm d-flex align-items-center gap-1">
                        <i class="bi bi-person-plus"></i> <span>Registrarse</span>
                    </a>
                <% } %>
            </div>

        </div>

    </nav>


    <div class="container py-4">

        <div class="row justify-content-center">

            <div class="col-lg-9">

                <% if ("prestado".equals(exito)) { %>
                    <div class="alert alert-success">
                        <strong>Préstamo registrado.</strong> Tienes 7 días para la devolución. Puedes consultarlo en <a href="MisPrestamosServlet" class="alert-link">Mis préstamos</a>.
                    </div>
                <% } else if ("yaPrestado".equals(error)) { %>
                    <div class="alert alert-warning">
                        Ya cuentas con un préstamo activo de este libro. Revisa <a href="MisPrestamosServlet" class="alert-link">Mis préstamos</a>.
                    </div>
                <% } else if ("sinStock".equals(error)) { %>
                    <div class="alert alert-secondary">
                        No hay ejemplares disponibles en este momento.
                    </div>
                <% } %>

                <div class="card shadow-sm border-0">

                    <div class="card-body p-4">

                        <div class="row g-4 align-items-start">

                            <!-- PORTADA -->
                            <div class="col-md-4 text-center">
                                <div class="detalle-portada-box">
                                    <img src="<%= portadaUrl %>"
                                         alt="Portada de <%= libro.getTitulo() %>"
                                         class="detalle-portada-img"
                                         onerror="this.onerror=null;this.src='img/portadas/default.svg';">
                                </div>
                            </div>

                            <!-- DATOS DEL LIBRO -->
                            <div class="col-md-8">

                                <div class="mb-2">
                                    <span class="badge bg-secondary">
                                        <%= libro.getNombreCategoria() %>
                                    </span>
                                    <span class="text-muted small ms-2">
                                        Año <%= libro.getAnio() %>
                                    </span>
                                </div>

                                <h3 class="fw-bold mb-1">
                                    <%= libro.getTitulo() %>
                                </h3>

                                <p class="text-muted mb-3">
                                    Por <%= libro.getNombreAutor() %>
                                </p>

                                <!-- REPRODUCTOR DE TEXTO ACCESIBLE -->
                                <div class="audio-player-card mb-3">
                                    <div class="d-flex align-items-center justify-content-between mb-2">
                                        <div>
                                            <div class="fw-bold small text-dark">Lector por voz (Accesibilidad)</div>
                                            <small class="text-muted" style="font-size: 0.78rem;">Síntesis de voz para personas con baja visión o ceguera</small>
                                        </div>
                                        <div id="statusAudio" class="badge bg-light text-secondary border">Listo</div>
                                    </div>

                                    <div class="d-flex align-items-center gap-2 flex-wrap">
                                        <button type="button" class="btn-audio-detailed" id="btnPlayAudio" onclick="reproducirAudioLibro()">
                                            <i class="bi bi-volume-up-fill"></i> <span>Audio</span>
                                        </button>
                                        <button type="button" class="btn btn-outline-secondary btn-sm" id="btnPauseAudio" onclick="pausarAudioLibro()" style="display:none;">
                                            Pausar
                                        </button>
                                        <button type="button" class="btn btn-outline-danger btn-sm" id="btnStopAudio" onclick="detenerAudioLibro()" style="display:none;">
                                            Detener
                                        </button>

                                        <div class="ms-auto d-flex align-items-center gap-1">
                                            <small class="text-muted" style="font-size: 0.78rem;">Velocidad:</small>
                                            <select id="audioSpeed" class="form-select form-select-sm" style="width: auto;" onchange="cambiarVelocidadAudio()">
                                                <option value="0.8">0.8x</option>
                                                <option value="1.0" selected>1.0x</option>
                                                <option value="1.2">1.2x</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <table class="table table-sm table-borderless mb-3 small">
                                    <tbody>
                                        <tr>
                                            <th class="text-muted" style="width: 130px;">ISBN:</th>
                                            <td><%= libro.getIsbn() %></td>
                                        </tr>
                                        <tr>
                                            <th class="text-muted">Categoría:</th>
                                            <td><%= libro.getNombreCategoria() %></td>
                                        </tr>
                                        <tr>
                                            <th class="text-muted">Disponibilidad:</th>
                                            <td>
                                                <% if (libro.getStock() > 0) { %>
                                                    <span class="badge bg-success">Disponible</span>
                                                    <span class="ms-1 text-muted"><%= libro.getStock() %> ejemplares</span>
                                                <% } else { %>
                                                    <span class="badge bg-secondary">Agotado</span>
                                                <% } %>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>

                                <div class="mb-4">
                                    <h6 class="fw-bold text-muted small text-uppercase">Sinopsis</h6>
                                    <p class="text-secondary small lh-base mb-0" id="textoDescripcion">
                                        <%= libro.getDescripcion() %>
                                    </p>
                                </div>

                                <div class="d-flex flex-wrap gap-2 pt-2 border-top">
                                    <% if (libro.getStock() > 0) { %>
                                        <a href="SolicitarPrestamoServlet?idLibro=<%= libro.getIdLibro() %>"
                                           class="btn btn-primary btn-sm px-4">
                                            Solicitar préstamo
                                        </a>
                                    <% } else { %>
                                        <button class="btn btn-secondary btn-sm" disabled>
                                            Sin stock disponible
                                        </button>
                                    <% } %>

                                    <a href="CatalogoServlet" class="btn btn-outline-secondary btn-sm">
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


    <!-- MÁSCARA GUÍA DE LECTURA VISUAL (TDAH / ENFOQUE) -->
    <div id="a11yReadingRuler"></div>

    <!-- MINI BOTÓN FLOTANTE PARA ESCUCHAR TEXTO SELECCIONADO -->
    <button id="a11yBtnAudioSel" type="button" onclick="leerTextoSeleccionado()">
        Escuchar selección
    </button>


    <!-- BOTÓN Y PANEL LATERAL DE ACCESIBILIDAD -->
    <button class="a11y-float-btn"
            id="btnA11yToggle"
            type="button"
            onclick="toggleA11yPanel()"
            aria-label="Abrir opciones de accesibilidad"
            title="Opciones de accesibilidad">
        A
    </button>

    <div class="a11y-panel" id="a11yPanel">
        <div class="a11y-panel-header">
            <div>
                <h6 class="mb-0 fw-bold">Accesibilidad y Lectura</h6>
                <small class="text-white-50">Configuración personalizada (ODS 9)</small>
            </div>
            <button type="button" class="btn-close btn-close-white" onclick="toggleA11yPanel()" aria-label="Cerrar"></button>
        </div>

        <div class="a11y-panel-body">
            <!-- 1. TAMAÑO DE TEXTO GRADUAL -->
            <div class="a11y-section-title">Tamaño de Texto</div>
            <div class="btn-group w-100" role="group">
                <button type="button" class="btn btn-outline-secondary btn-sm" id="btnFont100" onclick="setEscalaFuente(1.0)">100%</button>
                <button type="button" class="btn btn-outline-secondary btn-sm" id="btnFont115" onclick="setEscalaFuente(1.15)">115%</button>
                <button type="button" class="btn btn-outline-secondary btn-sm" id="btnFont130" onclick="setEscalaFuente(1.30)">130%</button>
                <button type="button" class="btn btn-outline-secondary btn-sm" id="btnFont145" onclick="setEscalaFuente(1.45)">145%</button>
            </div>

            <!-- 2. CONTRASTE VISUAL CALIBRADO (SIN TEXTO PERDIDO) -->
            <div class="a11y-section-title">Contraste Visual</div>
            <div class="d-grid gap-1">
                <button type="button" class="btn btn-outline-secondary btn-sm text-start" id="btnThemeDefault" onclick="setTemaContraste('default')">
                    Estándar (Fondo blanco)
                </button>
                <button type="button" class="btn btn-outline-secondary btn-sm text-start" id="btnThemeSepia" onclick="setTemaContraste('sepia')">
                    Sepia (Papel cálido / Menor fatiga)
                </button>
                <button type="button" class="btn btn-outline-secondary btn-sm text-start" id="btnThemeDark" onclick="setTemaContraste('dark')">
                    Modo Noche (Pizarra oscura)
                </button>
                <button type="button" class="btn btn-outline-secondary btn-sm text-start" id="btnThemeContrast" onclick="setTemaContraste('contrast')">
                    Alto Contraste (Amarillo / Negro WCAG AAA)
                </button>
            </div>

            <!-- 3. HERRAMIENTAS DE APOYO -->
            <div class="a11y-section-title">Apoyo de Lectura</div>
            <div class="d-grid gap-1">
                <button type="button" class="btn btn-outline-primary btn-sm text-start" id="btnToggleDyslexia" onclick="toggleDyslexia()">
                    Tipografía de fácil lectura (Dislexia)
                </button>
                <button type="button" class="btn btn-outline-primary btn-sm text-start" id="btnToggleRuler" onclick="toggleRuler()">
                    Máscara guía de lectura (TDAH)
                </button>
                <button type="button" class="btn btn-outline-primary btn-sm text-start" id="btnToggleUnderline" onclick="toggleUnderlineLinks()">
                    Subrayar enlaces interactivos
                </button>
            </div>

            <div class="pt-3 mt-3 border-top text-center">
                <button type="button" class="btn btn-link btn-sm text-danger text-decoration-none" onclick="restablecerA11y()">
                    Restablecer ajustes por defecto
                </button>
            </div>
        </div>
    </div>


    <footer class="bg-dark text-white text-center py-4 mt-5">
        <div class="container">
            <p class="mb-1 fw-bold">BookHub</p>
            <p class="mb-0 small text-secondary">
                Sistema de Gestión de Biblioteca Universitaria
            </p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- SCRIPTS DE AUDIO Y ACCESIBILIDAD SUITE -->
    <script>
        const textoCompletoLibro = "Título: <%= titLimpio %>. Autor: <%= autLimpio %>. Año: <%= libro.getAnio() %>. <%= descLimpia %>";
        let audioPausado = false;

        function reproducirAudioLibro() {
            if (!('speechSynthesis' in window)) {
                alert('Tu navegador no cuenta con soporte para reproducción por voz.');
                return;
            }

            if (audioPausado && window.speechSynthesis.paused) {
                window.speechSynthesis.resume();
                audioPausado = false;
                actualizarUIReinicio();
                return;
            }

            window.speechSynthesis.cancel();
            const vel = parseFloat(document.getElementById('audioSpeed').value) || 1.0;
            const utterance = new SpeechSynthesisUtterance(textoCompletoLibro);
            utterance.lang = 'es-ES';
            utterance.rate = vel;

            utterance.onstart = function() {
                actualizarUIReinicio();
            };

            utterance.onend = function() {
                actualizarUIDetenido();
            };

            utterance.onerror = function() {
                actualizarUIDetenido();
            };

            window.speechSynthesis.speak(utterance);
        }

        function pausarAudioLibro() {
            if ('speechSynthesis' in window) {
                if (window.speechSynthesis.speaking && !window.speechSynthesis.paused) {
                    window.speechSynthesis.pause();
                    audioPausado = true;
                    document.getElementById('btnPauseAudio').textContent = 'Reanudar';
                    document.getElementById('statusAudio').textContent = 'Pausado';
                } else if (window.speechSynthesis.paused) {
                    window.speechSynthesis.resume();
                    audioPausado = false;
                    document.getElementById('btnPauseAudio').textContent = 'Pausar';
                    document.getElementById('statusAudio').textContent = 'Reproduciendo';
                }
            }
        }

        function detenerAudioLibro() {
            if ('speechSynthesis' in window) {
                window.speechSynthesis.cancel();
                audioPausado = false;
                actualizarUIDetenido();
            }
        }

        function cambiarVelocidadAudio() {
            if (window.speechSynthesis.speaking) {
                reproducirAudioLibro();
            }
        }

        function actualizarUIReinicio() {
            document.getElementById('btnPlayAudio').style.display = 'none';
            document.getElementById('btnPauseAudio').style.display = 'inline-block';
            document.getElementById('btnPauseAudio').textContent = 'Pausar';
            document.getElementById('btnStopAudio').style.display = 'inline-block';
            document.getElementById('statusAudio').textContent = 'Reproduciendo';
            document.getElementById('statusAudio').className = 'badge bg-success';
        }

        function actualizarUIDetenido() {
            document.getElementById('btnPlayAudio').style.display = 'inline-block';
            document.getElementById('btnPauseAudio').style.display = 'none';
            document.getElementById('btnStopAudio').style.display = 'none';
            document.getElementById('statusAudio').textContent = 'Listo';
            document.getElementById('statusAudio').className = 'badge bg-light text-secondary border';
            audioPausado = false;
        }

        // REPRODUCIR CUALQUIER TEXTO
        function reproducirAudio(texto) {
            if (!('speechSynthesis' in window)) return;
            window.speechSynthesis.cancel();
            const utterance = new SpeechSynthesisUtterance(texto);
            utterance.lang = 'es-ES';
            utterance.rate = 1.0;
            window.speechSynthesis.speak(utterance);
        }

        // ESCUCHAR TEXTO SELECCIONADO
        document.addEventListener('mouseup', function(e) {
            const sel = window.getSelection().toString().trim();
            const btn = document.getElementById('a11yBtnAudioSel');
            if (btn) {
                if (sel.length >= 3) {
                    btn.style.display = 'block';
                    btn.style.top = (e.pageY + 12) + 'px';
                    btn.style.left = Math.min(window.innerWidth - 180, e.pageX) + 'px';
                    btn.setAttribute('data-texto', sel);
                } else {
                    btn.style.display = 'none';
                }
            }
        });

        function leerTextoSeleccionado() {
            const btn = document.getElementById('a11yBtnAudioSel');
            if (btn) {
                const texto = btn.getAttribute('data-texto');
                if (texto) {
                    reproducirAudio(texto);
                    btn.style.display = 'none';
                }
            }
        }

        // ACCESIBILIDAD SUITE
        let a11yState = {
            scale: 1.0,
            theme: 'default',
            dyslexia: false,
            ruler: false,
            underline: false
        };

        function cargarA11yPrefs() {
            try {
                const guardado = localStorage.getItem('bookhub_a11y_suite');
                if (guardado) {
                    a11yState = Object.assign(a11yState, JSON.parse(guardado));
                }
            } catch (e) {}
            aplicarA11yState();
        }

        function guardarA11yPrefs() {
            try {
                localStorage.setItem('bookhub_a11y_suite', JSON.stringify(a11yState));
            } catch (e) {}
        }

        function aplicarA11yState() {
            document.documentElement.style.setProperty('--a11y-font-scale', a11yState.scale);
            const lh = a11yState.scale >= 1.3 ? 1.75 : (a11yState.scale >= 1.15 ? 1.65 : 1.5);
            document.documentElement.style.setProperty('--a11y-line-height', lh);

            document.body.classList.remove('a11y-theme-sepia', 'a11y-theme-dark', 'a11y-theme-contrast');
            if (a11yState.theme === 'sepia') document.body.classList.add('a11y-theme-sepia');
            else if (a11yState.theme === 'dark') document.body.classList.add('a11y-theme-dark');
            else if (a11yState.theme === 'contrast') document.body.classList.add('a11y-theme-contrast');

            document.body.classList.toggle('a11y-dyslexia', !!a11yState.dyslexia);
            document.body.classList.toggle('a11y-underline-links', !!a11yState.underline);

            const ruler = document.getElementById('a11yReadingRuler');
            if (ruler) {
                ruler.style.display = a11yState.ruler ? 'block' : 'none';
            }

            actualizarUIBotonesPanel();
        }

        function actualizarUIBotonesPanel() {
            [1.0, 1.15, 1.30, 1.45].forEach(s => {
                const id = 'btnFont' + Math.round(s * 100);
                const btn = document.getElementById(id);
                if (btn) {
                    if (Math.abs(a11yState.scale - s) < 0.05) {
                        btn.classList.add('btn-primary');
                        btn.classList.remove('btn-outline-secondary');
                    } else {
                        btn.classList.remove('btn-primary');
                        btn.classList.add('btn-outline-secondary');
                    }
                }
            });

            const temas = {
                'default': 'btnThemeDefault',
                'sepia': 'btnThemeSepia',
                'dark': 'btnThemeDark',
                'contrast': 'btnThemeContrast'
            };
            for (const [key, id] of Object.entries(temas)) {
                const btn = document.getElementById(id);
                if (btn) {
                    if (a11yState.theme === key) {
                        btn.classList.add('btn-dark');
                        btn.classList.remove('btn-outline-secondary');
                    } else {
                        btn.classList.remove('btn-dark');
                        btn.classList.add('btn-outline-secondary');
                    }
                }
            }

            const btnDys = document.getElementById('btnToggleDyslexia');
            if (btnDys) btnDys.classList.toggle('active', !!a11yState.dyslexia);

            const btnRul = document.getElementById('btnToggleRuler');
            if (btnRul) btnRul.classList.toggle('active', !!a11yState.ruler);

            const btnUnd = document.getElementById('btnToggleUnderline');
            if (btnUnd) btnUnd.classList.toggle('active', !!a11yState.underline);
        }

        function setEscalaFuente(escala) {
            a11yState.scale = escala;
            aplicarA11yState();
            guardarA11yPrefs();
        }

        function setTemaContraste(tema) {
            a11yState.theme = tema;
            aplicarA11yState();
            guardarA11yPrefs();
        }

        function toggleDyslexia() {
            a11yState.dyslexia = !a11yState.dyslexia;
            aplicarA11yState();
            guardarA11yPrefs();
        }

        function toggleRuler() {
            a11yState.ruler = !a11yState.ruler;
            aplicarA11yState();
            guardarA11yPrefs();
        }

        function toggleUnderlineLinks() {
            a11yState.underline = !a11yState.underline;
            aplicarA11yState();
            guardarA11yPrefs();
        }

        function restablecerA11y() {
            a11yState = {
                scale: 1.0,
                theme: 'default',
                dyslexia: false,
                ruler: false,
                underline: false
            };
            aplicarA11yState();
            guardarA11yPrefs();
            detenerAudioLibro();
        }

        function toggleA11yPanel() {
            const panel = document.getElementById('a11yPanel');
            if (panel) {
                panel.style.display = (panel.style.display === 'block') ? 'none' : 'block';
            }
        }

        document.addEventListener('mousemove', function(e) {
            const ruler = document.getElementById('a11yReadingRuler');
            if (ruler && a11yState.ruler) {
                ruler.style.top = e.clientY + 'px';
            }
        });

        // DESVANECIMIENTO SUAVE DE LA BARRA SUPERIOR AL HACER SCROLL
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

        document.addEventListener('DOMContentLoaded', cargarA11yPrefs);
    </script>

</body>

</html>
