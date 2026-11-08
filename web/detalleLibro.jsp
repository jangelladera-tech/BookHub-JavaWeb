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

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= libro.getTitulo() %> - BookHub</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        :root {
            --a11y-font-scale: 1;
        }

        body {
            background-color: #f8fafc;
            color: #1e293b;
            font-size: calc(1rem * var(--a11y-font-scale));
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

        /* ACCESIBILIDAD */
        body.a11y-high-contrast {
            background-color: #000000 !important;
            color: #ffff00 !important;
        }
        body.a11y-high-contrast .card,
        body.a11y-high-contrast .navbar,
        body.a11y-high-contrast footer {
            background-color: #121212 !important;
            color: #ffffff !important;
            border-color: #ffff00 !important;
        }
        body.a11y-high-contrast a,
        body.a11y-high-contrast h1,
        body.a11y-high-contrast h2,
        body.a11y-high-contrast h3,
        body.a11y-high-contrast strong {
            color: #ffff00 !important;
        }
        body.a11y-high-contrast .btn-primary {
            background-color: #ffff00 !important;
            color: #000000 !important;
            border-color: #ffff00 !important;
            font-weight: bold;
        }
        body.a11y-monochrome {
            filter: grayscale(100%) !important;
        }
        body.a11y-dark-mode {
            background-color: #0f172a !important;
            color: #e2e8f0 !important;
        }
        body.a11y-dark-mode .card {
            background-color: #1e293b !important;
            color: #e2e8f0 !important;
            border-color: #334155 !important;
        }
        body.a11y-dark-mode .detalle-portada-box,
        body.a11y-dark-mode .audio-player-card {
            background-color: #0f172a !important;
            border-color: #334155 !important;
        }
        body.a11y-dyslexia {
            font-family: 'OpenDyslexic', 'Segoe UI', Arial, sans-serif !important;
            letter-spacing: 0.05em !important;
            word-spacing: 0.1em !important;
            line-height: 1.75 !important;
        }
        body.a11y-highlight-focus *:focus {
            outline: 3px solid #2563eb !important;
            outline-offset: 2px !important;
        }

        #a11yReadingRuler {
            display: none;
            position: fixed;
            left: 0;
            width: 100vw;
            height: 36px;
            background: rgba(37, 99, 235, 0.12);
            border-top: 1px solid #2563eb;
            border-bottom: 1px solid #2563eb;
            pointer-events: none;
            z-index: 99999;
            transform: translateY(-50%);
        }

        .a11y-float-btn {
            position: fixed;
            bottom: 24px;
            right: 24px;
            width: 50px;
            height: 50px;
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
            font-size: 1.25rem;
            transition: transform 0.2s ease, background 0.2s ease;
        }
        .a11y-float-btn:hover {
            transform: scale(1.08);
            background: #2563eb;
        }
        .a11y-panel {
            position: fixed;
            bottom: 84px;
            right: 24px;
            width: 320px;
            max-width: 90vw;
            background: #ffffff;
            border-radius: 12px;
            border: 1px solid #cbd5e1;
            box-shadow: 0 12px 28px rgba(0, 0, 0, 0.15);
            z-index: 9999;
            overflow: hidden;
            display: none;
        }
        .a11y-panel-header {
            background: #1e3a8a;
            color: #ffffff;
            padding: 12px 16px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .a11y-panel-body {
            padding: 14px;
            max-height: 440px;
            overflow-y: auto;
        }
        .a11y-opt-title {
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #64748b;
            margin-bottom: 6px;
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
                    <a href="index.html" class="sidebar-menu-item">
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

            <!-- PIE DE VENTANA: ACCESO A CUENTA -->
            <div class="pt-3 border-top border-secondary border-opacity-25">
                <% if (usuarioSesion != null) { %>
                    <div class="d-grid gap-2">
                        <% if ("ADMIN".equals(usuarioSesion.getRol())) { %>
                            <a href="dashboard.jsp" class="btn btn-warning fw-semibold d-flex align-items-center justify-content-center gap-2 py-2">
                                <i class="bi bi-speedometer2"></i> Panel de Administración
                            </a>
                        <% } else { %>
                            <a href="usuario.jsp" class="btn btn-primary fw-semibold d-flex align-items-center justify-content-center gap-2 py-2">
                                <i class="bi bi-person-gear"></i> Mi Cuenta
                            </a>
                        <% } %>
                        <a href="LogoutServlet" class="btn btn-outline-danger btn-sm d-flex align-items-center justify-content-center gap-1">
                            <i class="bi bi-box-arrow-left"></i> Cerrar Sesión
                        </a>
                    </div>
                <% } else { %>
                    <div class="d-grid gap-2">
                        <a href="login.jsp" class="btn btn-primary fw-semibold d-flex align-items-center justify-content-center gap-2 py-2">
                            <i class="bi bi-box-arrow-in-right"></i> Iniciar Sesión
                        </a>
                        <a href="registro.jsp" class="btn btn-outline-light btn-sm d-flex align-items-center justify-content-center gap-1">
                            <i class="bi bi-person-plus"></i> Registrarse como Lector
                        </a>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <!-- NAVBAR CON BOTÓN DE TRES LÍNEAS -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm py-2">

        <div class="container-fluid px-3 px-lg-4">

            <div class="d-flex align-items-center gap-2">
                <!-- Botón de tres líneas (Hamburguesa) que abre la ventana a la izquierda -->
                <button class="btn-sidebar-toggle"
                        type="button"
                        data-bs-toggle="offcanvas"
                        data-bs-target="#sidebarBookHub"
                        aria-controls="sidebarBookHub"
                        title="Abrir menú lateral (Inicio, Catálogo, ODS 09, Mis préstamos)"
                        aria-label="Abrir menú de navegación">
                    <i class="bi bi-list fs-3"></i>
                </button>

                <a class="navbar-brand fw-bold d-flex align-items-center gap-2 m-0" href="index.html">
                    <span>BookHub</span>
                </a>
            </div>

            <div class="d-flex align-items-center gap-2 ms-auto">
                <a href="InnovacionServlet" class="btn btn-outline-info btn-sm d-none d-sm-inline-flex align-items-center gap-1">
                    <i class="bi bi-universal-access"></i> ODS 9
                </a>
                <button type="button" class="btn btn-primary btn-sm d-flex align-items-center gap-1" onclick="toggleA11yPanel()">
                    <i class="bi bi-eye"></i> <span class="d-none d-sm-inline">Accesibilidad</span>
                </button>
                <a href="MisPrestamosServlet" class="btn btn-outline-light btn-sm d-none d-md-inline-flex">
                    Mis préstamos
                </a>
                <a href="CatalogoServlet" class="btn btn-light btn-sm d-flex align-items-center gap-1">
                    <i class="bi bi-arrow-left"></i> Catálogo
                </a>
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
                                        <button type="button" class="btn btn-primary btn-sm" id="btnPlayAudio" onclick="reproducirAudioLibro()">
                                            Escuchar descripción
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


    <!-- REGLA DE LECTURA VISUAL -->
    <div id="a11yReadingRuler"></div>


    <!-- PANEL FLOTANTE DE ACCESIBILIDAD -->
    <div id="bookhubA11yWidget">
        <button class="a11y-float-btn"
                id="btnA11yToggle"
                type="button"
                onclick="toggleA11yPanel()"
                aria-label="Abrir panel de accesibilidad"
                title="Herramientas de accesibilidad">
            A
        </button>

        <div class="a11y-panel shadow-sm" id="a11yPanel">
            <div class="a11y-panel-header">
                <div>
                    <h6 class="mb-0 fw-bold">Accesibilidad</h6>
                    <small class="text-white-50">Ajustes visuales y de lectura</small>
                </div>
                <button type="button" class="btn-close btn-close-white" onclick="toggleA11yPanel()" aria-label="Cerrar"></button>
            </div>

            <div class="a11y-panel-body">
                <div class="mb-3">
                    <div class="a11y-opt-title">Tamaño de letra</div>
                    <div class="btn-group w-100">
                        <button type="button" class="btn btn-outline-secondary btn-sm" onclick="ajustarFuente(-0.1)">Reducir</button>
                        <button type="button" class="btn btn-outline-secondary btn-sm" onclick="ajustarFuente(0)">Normal</button>
                        <button type="button" class="btn btn-outline-secondary btn-sm" onclick="ajustarFuente(0.15)">Aumentar</button>
                    </div>
                </div>

                <div class="mb-3">
                    <div class="a11y-opt-title">Contraste visual</div>
                    <div class="d-grid gap-1">
                        <button type="button" class="btn btn-outline-dark btn-sm text-start" onclick="toggleHighContrast()">
                            Alto contraste (Fondo negro)
                        </button>
                        <button type="button" class="btn btn-outline-dark btn-sm text-start" onclick="toggleDarkMode()">
                            Modo oscuro suave
                        </button>
                        <button type="button" class="btn btn-outline-dark btn-sm text-start" onclick="toggleMonochrome()">
                            Escala de grises
                        </button>
                    </div>
                </div>

                <div class="mb-3">
                    <div class="a11y-opt-title">Apoyo de lectura</div>
                    <div class="d-grid gap-1">
                        <button type="button" class="btn btn-outline-primary btn-sm text-start" onclick="toggleDyslexiaMode()">
                            Fuente de lectura accesible
                        </button>
                        <button type="button" class="btn btn-outline-primary btn-sm text-start" onclick="toggleReadingRuler()">
                            Regla guía de lectura
                        </button>
                        <button type="button" class="btn btn-outline-secondary btn-sm text-start" onclick="toggleFocusHighlight()">
                            Resaltar navegación por teclado
                        </button>
                    </div>
                </div>

                <div class="pt-2 text-center border-top">
                    <button type="button" class="btn btn-link btn-sm text-danger text-decoration-none" onclick="restablecerA11y()">
                        Restablecer ajustes
                    </button>
                </div>
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

    <!-- SCRIPTS DE AUDIO Y ACCESIBILIDAD -->
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

        // ACCESIBILIDAD
        let a11yState = {
            fontScale: 1,
            highContrast: false,
            darkMode: false,
            monochrome: false,
            dyslexia: false,
            readingRuler: false,
            focusHighlight: false
        };

        function cargarA11yPrefs() {
            try {
                const guardado = localStorage.getItem('bookhub_a11y_prefs');
                if (guardado) {
                    a11yState = Object.assign(a11yState, JSON.parse(guardado));
                    aplicarA11yState();
                }
            } catch (e) {}
        }

        function guardarA11yPrefs() {
            try {
                localStorage.setItem('bookhub_a11y_prefs', JSON.stringify(a11yState));
            } catch (e) {}
        }

        function aplicarA11yState() {
            document.documentElement.style.setProperty('--a11y-font-scale', a11yState.fontScale);
            document.body.classList.toggle('a11y-high-contrast', !!a11yState.highContrast);
            document.body.classList.toggle('a11y-dark-mode', !!a11yState.darkMode);
            document.body.classList.toggle('a11y-monochrome', !!a11yState.monochrome);
            document.body.classList.toggle('a11y-dyslexia', !!a11yState.dyslexia);
            document.body.classList.toggle('a11y-highlight-focus', !!a11yState.focusHighlight);

            const ruler = document.getElementById('a11yReadingRuler');
            if (ruler) {
                ruler.style.display = a11yState.readingRuler ? 'block' : 'none';
            }
        }

        function toggleA11yPanel() {
            const panel = document.getElementById('a11yPanel');
            if (panel) {
                panel.style.display = (panel.style.display === 'block') ? 'none' : 'block';
            }
        }

        function ajustarFuente(delta) {
            if (delta === 0) {
                a11yState.fontScale = 1;
            } else {
                a11yState.fontScale = Math.min(1.3, Math.max(0.85, a11yState.fontScale + delta));
            }
            aplicarA11yState();
            guardarA11yPrefs();
        }

        function toggleHighContrast() {
            a11yState.highContrast = !a11yState.highContrast;
            if (a11yState.highContrast) a11yState.darkMode = false;
            aplicarA11yState();
            guardarA11yPrefs();
        }

        function toggleDarkMode() {
            a11yState.darkMode = !a11yState.darkMode;
            if (a11yState.darkMode) a11yState.highContrast = false;
            aplicarA11yState();
            guardarA11yPrefs();
        }

        function toggleMonochrome() {
            a11yState.monochrome = !a11yState.monochrome;
            aplicarA11yState();
            guardarA11yPrefs();
        }

        function toggleDyslexiaMode() {
            a11yState.dyslexia = !a11yState.dyslexia;
            aplicarA11yState();
            guardarA11yPrefs();
        }

        function toggleReadingRuler() {
            a11yState.readingRuler = !a11yState.readingRuler;
            aplicarA11yState();
            guardarA11yPrefs();
        }

        function toggleFocusHighlight() {
            a11yState.focusHighlight = !a11yState.focusHighlight;
            aplicarA11yState();
            guardarA11yPrefs();
        }

        function restablecerA11y() {
            a11yState = {
                fontScale: 1,
                highContrast: false,
                darkMode: false,
                monochrome: false,
                dyslexia: false,
                readingRuler: false,
                focusHighlight: false
            };
            aplicarA11yState();
            guardarA11yPrefs();
            detenerAudioLibro();
        }

        document.addEventListener('mousemove', function(e) {
            const ruler = document.getElementById('a11yReadingRuler');
            if (ruler && a11yState.readingRuler) {
                ruler.style.top = e.clientY + 'px';
            }
        });

        document.addEventListener('DOMContentLoaded', cargarA11yPrefs);
    </script>

</body>

</html>
