<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="beans.Libro"%>
<%@page import="beans.Prestamo"%>
<%@page import="beans.Usuario"%>
<%@page import="dao.LibroDAO"%>
<%@page import="dao.PrestamoDAO"%>

<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");

    List<Libro> libros = (List<Libro>) request.getAttribute("libros");
    Map<Integer, Integer> prestamosActivosPorLibro =
            (Map<Integer, Integer>) request.getAttribute("prestamosActivosPorLibro");

    Integer librosRegistradosAttr = (Integer) request.getAttribute("librosRegistrados");
    Integer stockBajoAttr = (Integer) request.getAttribute("stockBajo");
    Integer prestamosActivosAttr = (Integer) request.getAttribute("prestamosActivos");
    Integer librosAgotadosAttr = (Integer) request.getAttribute("librosAgotados");

    // Respaldo por si se accede directamente a innovacion.jsp sin pasar por InnovacionServlet
    if (libros == null || librosRegistradosAttr == null) {
        LibroDAO libroDAO = new LibroDAO();
        PrestamoDAO prestamoDAO = new PrestamoDAO();
        libros = libroDAO.listar();
        List<Prestamo> prestamos = prestamoDAO.listar();

        prestamosActivosPorLibro = new HashMap<>();
        int calcPrestamosActivos = 0;
        for (Prestamo p : prestamos) {
            if (p.getEstado() != null && "PRESTADO".equalsIgnoreCase(p.getEstado().trim())) {
                calcPrestamosActivos++;
                int idLib = p.getIdLibro();
                prestamosActivosPorLibro.put(idLib, prestamosActivosPorLibro.getOrDefault(idLib, 0) + 1);
            }
        }

        int calcStockBajo = 0;
        int calcAgotados = 0;
        for (Libro l : libros) {
            if (l.getStock() == 0) {
                calcAgotados++;
            } else if (l.getStock() >= 1 && l.getStock() <= 2) {
                calcStockBajo++;
            }
        }

        librosRegistradosAttr = libros.size();
        stockBajoAttr = calcStockBajo;
        prestamosActivosAttr = calcPrestamosActivos;
        librosAgotadosAttr = calcAgotados;
    }

    int librosRegistrados = librosRegistradosAttr;
    int stockBajo = stockBajoAttr;
    int prestamosActivos = prestamosActivosAttr;
    int librosAgotados = librosAgotadosAttr;
%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ODS 9: Innovación y Accesibilidad - BookHub</title>

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

        .hero-innovacion {
            background: linear-gradient(135deg, #1e3a8a 0%, #1e40af 60%, #0369a1 100%);
            color: #ffffff;
            padding: 45px 0 55px;
        }

        .kpi-card {
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            background: #ffffff;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            cursor: pointer;
        }

        .kpi-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 18px rgba(0, 0, 0, 0.06);
        }

        .kpi-card.active-filter {
            border-color: #2563eb;
            background-color: #f8fafc;
        }

        .portada-tabla {
            width: 40px;
            height: 56px;
            object-fit: cover;
            border-radius: 4px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.12);
            display: block;
        }

        .lab-card {
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            background: #ffffff;
        }

        /* ACCESIBILIDAD */
        body.a11y-high-contrast {
            background-color: #000000 !important;
            color: #ffff00 !important;
        }

        body.a11y-high-contrast .card,
        body.a11y-high-contrast .navbar,
        body.a11y-high-contrast .table,
        body.a11y-high-contrast footer {
            background-color: #121212 !important;
            color: #ffffff !important;
            border-color: #ffff00 !important;
        }

        body.a11y-high-contrast a,
        body.a11y-high-contrast h1,
        body.a11y-high-contrast h2,
        body.a11y-high-contrast h3,
        body.a11y-high-contrast h4,
        body.a11y-high-contrast h5,
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

        body.a11y-dark-mode .card,
        body.a11y-dark-mode .table {
            background-color: #1e293b !important;
            color: #e2e8f0 !important;
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

<body>

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

                <a href="CatalogoServlet" class="sidebar-menu-item">
                    <i class="bi bi-journal-bookmark-fill menu-icon text-info"></i>
                    <div class="flex-grow-1">
                        <div>Catálogo</div>
                        <small class="text-white-50" style="font-size: 0.72rem;">Explorar libros y categorías</small>
                    </div>
                </a>

                <a href="InnovacionServlet" class="sidebar-menu-item active">
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
<nav class="navbar navbar-expand-lg bg-dark navbar-dark sticky-top shadow-sm py-2">
    <div class="container-fluid px-3 px-lg-4">

        <div class="d-flex align-items-center gap-2">
            <!-- Botón de tres líneas (Hamburguesa) que abre la ventana izquierda -->
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

        <div class="d-flex align-items-center flex-wrap gap-2 ms-auto">

            <ul class="navbar-nav d-none d-lg-flex flex-row gap-3 me-2">
                <li class="nav-item">
                    <a class="nav-link" href="index.html">Inicio</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="CatalogoServlet">Catálogo</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active fw-semibold" href="InnovacionServlet">ODS 9: Accesibilidad</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="MisPrestamosServlet">Mis préstamos</a>
                </li>
            </ul>

            <button class="btn btn-primary btn-sm d-flex align-items-center gap-1"
                    type="button"
                    onclick="toggleA11yPanel()">
                <i class="bi bi-eye"></i> <span class="d-none d-sm-inline">Accesibilidad</span>
            </button>

            <% if (usuarioSesion != null) { %>
                <% if ("ADMIN".equals(usuarioSesion.getRol())) { %>
                    <a class="btn btn-warning btn-sm d-none d-sm-inline-flex" href="dashboard.jsp">
                        Panel Admin
                    </a>
                <% } else { %>
                    <a class="btn btn-light btn-sm d-none d-sm-inline-flex" href="usuario.jsp">
                        Mi cuenta (<%= usuarioSesion.getNombre() %>)
                    </a>
                <% } %>
                <a class="btn btn-outline-danger btn-sm" href="LogoutServlet">
                    Salir
                </a>
            <% } else { %>
                <a class="btn btn-outline-light btn-sm d-none d-sm-inline-flex" href="registro.jsp">
                    Registrarse
                </a>
                <a class="btn btn-light btn-sm" href="login.jsp">
                    Iniciar sesión
                </a>
            <% } %>

        </div>
    </div>
</nav>


<!-- ENCABEZADO: ODS 9 INNOVACIÓN Y ACCESIBILIDAD -->
<section class="hero-innovacion">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-8">
                <span class="badge bg-light text-primary fw-semibold mb-2 px-3 py-1">
                    ODS 9 · Innovación, Infraestructura y Accesibilidad Universal
                </span>
                <h1 class="fw-bold mb-3">
                    Inclusión Tecnológica en la Biblioteca Universitaria
                </h1>
                <p class="lead mb-4 text-white-50">
                    Como parte de la modernización de infraestructura y servicios bibliotecarios, BookHub incorpora herramientas de asistencia para facilitar la consulta y lectura a personas con discapacidad visual, dificultades motoras o dislexia.
                </p>
                <div class="d-flex flex-wrap gap-2">
                    <button class="btn btn-light btn-sm px-3 py-2 fw-semibold" onclick="reproducirAudio('BookHub incorpora tecnologías de asistencia para la lectura y navegación accesible en la comunidad universitaria.')">
                        Escuchar presentación
                    </button>
                    <a href="#moduloPruebas" class="btn btn-outline-light btn-sm px-3 py-2">
                        Probar herramientas de asistencia
                    </a>
                    <a href="CatalogoServlet" class="btn btn-outline-light btn-sm px-3 py-2">
                        Ir al catálogo
                    </a>
                </div>
            </div>
            <div class="col-lg-4 text-start mt-4 mt-lg-0">
                <div class="bg-black bg-opacity-25 p-3 rounded-3 border border-white border-opacity-10 small">
                    <h6 class="fw-bold mb-2 text-white">Módulos adaptados en el sistema:</h6>
                    <ul class="list-unstyled mb-0 text-white-50">
                        <li class="mb-2">• <strong>Lector de texto por voz:</strong> Síntesis vocal de descripciones.</li>
                        <li class="mb-2">• <strong>Búsqueda por voz:</strong> Dictado para usuarios con movilidad reducida.</li>
                        <li class="mb-2">• <strong>Contraste visual:</strong> Modos de alto contraste y visión nocturna.</li>
                        <li class="mb-0">• <strong>Lectura asistida:</strong> Tipografía y regla visual para dislexia.</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</section>


<!-- CONTENIDO PRINCIPAL -->
<div class="container py-4">

    <!-- INDICADORES DEL SISTEMA -->
    <div class="row g-3 mb-4">

        <!-- 1. TOTAL DE LIBROS -->
        <div class="col-sm-6 col-xl-3">
            <div class="card kpi-card h-100 p-3" onclick="filtrarTabla('todos', this)">
                <div class="d-flex justify-content-between align-items-center mb-1">
                    <span class="small text-muted text-uppercase fw-semibold">Catálogo Total</span>
                    <span class="badge bg-light text-primary border">Activo</span>
                </div>
                <h3 class="fw-bold text-primary mb-1">
                    <%= librosRegistrados %>
                </h3>
                <p class="small text-muted mb-0">
                    Títulos registrados con soporte de lectura por voz.
                </p>
            </div>
        </div>

        <!-- 2. RECURSOS EN STOCK BAJO -->
        <div class="col-sm-6 col-xl-3">
            <div class="card kpi-card h-100 p-3" onclick="filtrarTabla('bajo', this)">
                <div class="d-flex justify-content-between align-items-center mb-1">
                    <span class="small text-muted text-uppercase fw-semibold">Stock Bajo</span>
                    <span class="badge bg-light text-warning border">1 a 2 ejem.</span>
                </div>
                <h3 class="fw-bold text-warning mb-1">
                    <%= stockBajo %>
                </h3>
                <p class="small text-muted mb-0">
                    Libros que requieren reposición preventiva de ejemplares.
                </p>
            </div>
        </div>

        <!-- 3. PRÉSTAMOS ACTIVOS -->
        <div class="col-sm-6 col-xl-3">
            <div class="card kpi-card h-100 p-3" onclick="filtrarTabla('prestados', this)">
                <div class="d-flex justify-content-between align-items-center mb-1">
                    <span class="small text-muted text-uppercase fw-semibold">En Préstamo</span>
                    <span class="badge bg-light text-info border">Circulación</span>
                </div>
                <h3 class="fw-bold text-info mb-1">
                    <%= prestamosActivos %>
                </h3>
                <p class="small text-muted mb-0">
                    Ejemplares físicos actualmente en manos de lectores.
                </p>
            </div>
        </div>

        <!-- 4. LIBROS AGOTADOS -->
        <div class="col-sm-6 col-xl-3">
            <div class="card kpi-card h-100 p-3" onclick="filtrarTabla('agotado', this)">
                <div class="d-flex justify-content-between align-items-center mb-1">
                    <span class="small text-muted text-uppercase fw-semibold">Agotados</span>
                    <span class="badge bg-light text-secondary border">0 disp.</span>
                </div>
                <h3 class="fw-bold text-secondary mb-1">
                    <%= librosAgotados %>
                </h3>
                <p class="small text-muted mb-0">
                    Sin ejemplares físicos (acceso mediante síntesis digital).
                </p>
            </div>
        </div>

    </div>


    <!-- MÓDULO DE PRUEBAS DE ACCESIBILIDAD -->
    <div id="moduloPruebas" class="card shadow-sm border-0 mb-4">
        <div class="card-header bg-white py-3 border-bottom">
            <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
                <div>
                    <h6 class="fw-bold mb-0 text-dark">
                        Módulo de Pruebas de Accesibilidad
                    </h6>
                    <small class="text-muted">
                        Demostración de las tecnologías de asistencia integradas en BookHub
                    </small>
                </div>
                <span class="badge bg-light text-secondary border">
                    HTML5 Web Speech API
                </span>
            </div>
        </div>

        <div class="card-body p-4">
            <div class="row g-4">

                <!-- 1. LECTOR DE TEXTO -->
                <div class="col-md-4">
                    <div class="p-3 border rounded-3 h-100 lab-card d-flex flex-column">
                        <h6 class="fw-bold mb-1">1. Lector de texto (TTS)</h6>
                        <p class="small text-muted">
                            Asistencia auditiva para personas con baja visión, debilidad visual o ceguera.
                        </p>

                        <div class="mb-2">
                            <label class="form-label small text-muted mb-1">Texto a sintetizar:</label>
                            <textarea id="labTtsTexto" class="form-control form-control-sm" rows="3">Cien años de soledad relata la historia de la familia Buendía en el pueblo mítico de Macondo.</textarea>
                        </div>

                        <div class="d-flex align-items-center gap-2 mb-3">
                            <label class="small text-muted">Velocidad:</label>
                            <select id="labTtsSpeed" class="form-select form-select-sm" style="width: auto;">
                                <option value="0.8">0.8x</option>
                                <option value="1.0" selected>1.0x</option>
                                <option value="1.2">1.2x</option>
                            </select>
                        </div>

                        <div class="mt-auto d-flex gap-2">
                            <button type="button" class="btn btn-primary btn-sm flex-grow-1" onclick="ejecutarLabTTS()">
                                Reproducir
                            </button>
                            <button type="button" class="btn btn-outline-secondary btn-sm" onclick="detenerVoz()">
                                Detener
                            </button>
                        </div>
                    </div>
                </div>

                <!-- 2. BÚSQUEDA POR VOZ -->
                <div class="col-md-4">
                    <div class="p-3 border rounded-3 h-100 lab-card d-flex flex-column" id="moduloDictado">
                        <h6 class="fw-bold mb-1">2. Búsqueda por voz (STT)</h6>
                        <p class="small text-muted">
                            Asistencia por voz para lectores con discapacidad motriz en extremidades superiores.
                        </p>

                        <div class="p-3 bg-light rounded-3 text-center mb-3">
                            <div id="sttEstado" class="small text-muted mb-2">
                                Haz clic en el botón y di el título o autor
                            </div>
                            <button type="button" id="btnSttLab" class="btn btn-outline-primary btn-sm px-3 py-2" onclick="toggleSttLab()">
                                Iniciar dictado
                            </button>
                            <div id="sttResultado" class="fw-semibold mt-2 text-primary small" style="min-height: 22px;">
                                ...
                            </div>
                        </div>

                        <div class="mt-auto">
                            <a id="btnIrACatalogoConVoz" href="CatalogoServlet" class="btn btn-outline-secondary btn-sm w-100">
                                Buscar resultado en el catálogo
                            </a>
                        </div>
                    </div>
                </div>

                <!-- 3. OPCIONES VISUALES -->
                <div class="col-md-4">
                    <div class="p-3 border rounded-3 h-100 lab-card d-flex flex-column">
                        <h6 class="fw-bold mb-1">3. Adaptaciones visuales</h6>
                        <p class="small text-muted">
                            Ajustes inmediatos de contraste y tipografía para baja visión y dificultades de lectura.
                        </p>

                        <div class="d-grid gap-2 mb-3">
                            <button type="button" class="btn btn-outline-dark btn-sm text-start" onclick="toggleHighContrast()">
                                Alto contraste (Fondo negro)
                            </button>
                            <button type="button" class="btn btn-outline-secondary btn-sm text-start" onclick="toggleDyslexiaMode()">
                                Tipografía para dislexia
                            </button>
                            <button type="button" class="btn btn-outline-secondary btn-sm text-start" onclick="toggleReadingRuler()">
                                Regla guía de lectura
                            </button>
                        </div>

                        <div class="mt-auto">
                            <button type="button" class="btn btn-link btn-sm text-danger text-decoration-none w-100 text-center" onclick="restablecerA11y()">
                                Restablecer ajustes
                            </button>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>


    <!-- TABLA DE RECURSOS DEL CATÁLOGO -->
    <div class="card shadow-sm border-0">
        <div class="card-header bg-white py-3 d-flex flex-wrap justify-content-between align-items-center gap-2 border-bottom">
            <div>
                <h6 class="fw-bold mb-0 text-dark">
                    Recursos Bibliográficos del Sistema
                </h6>
                <small class="text-muted">
                    Listado de libros y estado de disponibilidad en biblioteca
                </small>
            </div>

            <div class="d-flex flex-wrap gap-1">
                <button type="button" class="btn btn-sm btn-outline-primary active btn-filtro-tabla" id="btnTodos" onclick="filtrarTabla('todos', this)">
                    Todos (<%= librosRegistrados %>)
                </button>
                <button type="button" class="btn btn-sm btn-outline-warning text-dark btn-filtro-tabla" id="btnBajo" onclick="filtrarTabla('bajo', this)">
                    Stock bajo (<%= stockBajo %>)
                </button>
                <button type="button" class="btn btn-sm btn-outline-info text-dark btn-filtro-tabla" id="btnPrestados" onclick="filtrarTabla('prestados', this)">
                    En préstamo (<%= prestamosActivos %>)
                </button>
                <button type="button" class="btn btn-sm btn-outline-secondary btn-filtro-tabla" id="btnAgotado" onclick="filtrarTabla('agotado', this)">
                    Agotados (<%= librosAgotados %>)
                </button>
            </div>
        </div>

        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light small">
                        <tr>
                            <th class="ps-3">Título y Autor</th>
                            <th>Categoría</th>
                            <th class="text-center">Stock</th>
                            <th>Estado</th>
                            <th class="text-end pe-3">Acciones</th>
                        </tr>
                    </thead>
                    <tbody class="small">
                        <% if (libros != null && !libros.isEmpty()) {
                               for (Libro libro : libros) {
                                   int stock = libro.getStock();
                                   int activosLibro = (prestamosActivosPorLibro != null)
                                           ? prestamosActivosPorLibro.getOrDefault(libro.getIdLibro(), 0)
                                           : 0;

                                   String estadoFiltro;
                                   String badgeClase;
                                   String textoEstado;

                                   if (stock == 0) {
                                       estadoFiltro = "agotado";
                                       badgeClase = "bg-secondary";
                                       textoEstado = "Agotado";
                                   } else if (stock >= 1 && stock <= 2) {
                                       estadoFiltro = "bajo";
                                       badgeClase = "bg-warning text-dark";
                                       textoEstado = "Stock bajo (" + stock + ")";
                                   } else {
                                       estadoFiltro = "optimo";
                                       badgeClase = "bg-success";
                                       textoEstado = "Disponible (" + stock + ")";
                                   }

                                   String portadaTabla = libro.getImagenPortada();
                                   if (portadaTabla == null || portadaTabla.trim().isEmpty()) {
                                       portadaTabla = "img/portadas/default.svg";
                                   }

                                   String textoParaLeer = libro.getTitulo() + ". Autor: " + libro.getNombreAutor()
                                           + ". Categoría: " + libro.getNombreCategoria() + ". " + libro.getDescripcion();
                                   textoParaLeer = textoParaLeer.replace("\"", "").replace("'", "");
                        %>
                            <tr class="fila-recurso"
                                data-estado="<%= estadoFiltro %>"
                                data-prestamos="<%= activosLibro %>">
                                <td class="ps-3">
                                    <div class="d-flex align-items-center gap-2">
                                        <img src="<%= portadaTabla %>"
                                             alt="Portada"
                                             class="portada-tabla"
                                             onerror="this.onerror=null;this.src='img/portadas/default.svg';">
                                        <div>
                                            <div class="fw-bold"><%= libro.getTitulo() %></div>
                                            <div class="text-muted"><%= libro.getNombreAutor() %> · ISBN: <%= libro.getIsbn() %></div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <span class="badge bg-light text-dark border">
                                        <%= libro.getNombreCategoria() %>
                                    </span>
                                </td>
                                <td class="text-center fw-semibold">
                                    <%= stock %>
                                </td>
                                <td>
                                    <span class="badge <%= badgeClase %>">
                                        <%= textoEstado %>
                                    </span>
                                    <% if (activosLibro > 0) { %>
                                        <span class="badge bg-info text-dark ms-1">
                                            <%= activosLibro %> prestados
                                        </span>
                                    <% } %>
                                </td>
                                <td class="text-end pe-3">
                                    <div class="btn-group btn-group-sm">
                                        <button type="button"
                                                class="btn btn-outline-secondary"
                                                onclick="reproducirAudio('<%= textoParaLeer %>')"
                                                title="Escuchar información del libro">
                                            Escuchar
                                        </button>
                                        <a href="DetalleLibroServlet?id=<%= libro.getIdLibro() %>"
                                           class="btn btn-outline-primary"
                                           title="Ver detalles">
                                            Ficha
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        <%     }
                           } else { %>
                            <tr>
                                <td colspan="5" class="text-center py-4 text-muted">
                                    No hay libros registrados en el catálogo.
                                </td>
                            </tr>
                        <% } %>
                        <tr id="filaSinResultados" style="display: none;">
                            <td colspan="5" class="text-center py-4 text-muted">
                                No hay libros en este criterio actualmente.
                            </td>
                        </tr>
                    </tbody>
                </table>
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


<!-- PIE DE PÁGINA -->
<footer class="bg-dark text-white py-4 mt-5">
    <div class="container text-center">
        <p class="mb-1 fw-bold">BookHub</p>
        <p class="mb-0 small text-secondary">
            Sistema de Gestión de Biblioteca Universitaria · Proyecto académico ODS 9
        </p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
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
        detenerVoz();
    }

    document.addEventListener('mousemove', function(e) {
        const ruler = document.getElementById('a11yReadingRuler');
        if (ruler && a11yState.readingRuler) {
            ruler.style.top = e.clientY + 'px';
        }
    });

    // SÍNTESIS DE VOZ
    function reproducirAudio(texto, velocidad = 1.0) {
        if (!('speechSynthesis' in window)) {
            alert('Tu navegador no cuenta con soporte nativo de síntesis de voz.');
            return;
        }
        window.speechSynthesis.cancel();
        const utterance = new SpeechSynthesisUtterance(texto);
        utterance.lang = 'es-ES';
        utterance.rate = parseFloat(velocidad) || 1.0;
        window.speechSynthesis.speak(utterance);
    }

    function ejecutarLabTTS() {
        const texto = document.getElementById('labTtsTexto').value;
        const vel = document.getElementById('labTtsSpeed').value;
        reproducirAudio(texto, vel);
    }

    function detenerVoz() {
        if ('speechSynthesis' in window) {
            window.speechSynthesis.cancel();
        }
    }

    // RECONOCIMIENTO DE VOZ
    let recognition = null;
    let escuchando = false;

    function iniciarReconocimientoVoz() {
        const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
        if (!SpeechRecognition) return null;
        const rec = new SpeechRecognition();
        rec.lang = 'es-ES';
        rec.continuous = false;
        rec.interimResults = false;
        return rec;
    }

    function toggleSttLab() {
        if (!('SpeechRecognition' in window) && !('webkitSpeechRecognition' in window)) {
            document.getElementById('sttEstado').innerText = 'Navegador sin soporte de voz.';
            return;
        }

        if (!recognition) {
            recognition = iniciarReconocimientoVoz();
            if (!recognition) return;

            recognition.onstart = function() {
                escuchando = true;
                document.getElementById('sttEstado').innerText = 'Escuchando... Di el título a buscar';
                document.getElementById('btnSttLab').className = 'btn btn-danger btn-sm px-3 py-2';
                document.getElementById('btnSttLab').innerText = 'Detener';
            };

            recognition.onresult = function(event) {
                const transcript = event.results[0][0].transcript;
                document.getElementById('sttResultado').innerText = '"' + transcript + '"';
                document.getElementById('sttEstado').innerText = 'Texto reconocido:';
                const btnIr = document.getElementById('btnIrACatalogoConVoz');
                if (btnIr) {
                    btnIr.href = 'CatalogoServlet?busqueda=' + encodeURIComponent(transcript);
                }
            };

            recognition.onerror = function(event) {
                document.getElementById('sttEstado').innerText = 'No se detectó audio (' + event.error + ').';
            };

            recognition.onend = function() {
                escuchando = false;
                document.getElementById('btnSttLab').className = 'btn btn-outline-primary btn-sm px-3 py-2';
                document.getElementById('btnSttLab').innerText = 'Iniciar dictado';
            };
        }

        if (!escuchando) {
            try {
                recognition.start();
            } catch(e) {}
        } else {
            recognition.stop();
        }
    }

    // FILTROS DE TABLA
    function filtrarTabla(criterio, cardElemento) {
        const filas = document.querySelectorAll(".fila-recurso");
        const filaSinResultados = document.getElementById("filaSinResultados");
        let visibles = 0;

        document.querySelectorAll(".kpi-card, .btn-filtro-tabla").forEach(c => c.classList.remove("active-filter", "active"));
        if (cardElemento) {
            cardElemento.classList.add("active-filter", "active");
        }

        filas.forEach(fila => {
            const estado = fila.getAttribute("data-estado");
            const prestamos = parseInt(fila.getAttribute("data-prestamos") || "0", 10);
            let mostrar = false;

            if (criterio === "todos") {
                mostrar = true;
            } else if (criterio === "bajo") {
                mostrar = (estado === "bajo");
            } else if (criterio === "agotado") {
                mostrar = (estado === "agotado");
            } else if (criterio === "prestados") {
                mostrar = (prestamos > 0);
            }

            if (mostrar) {
                fila.style.display = "";
                visibles++;
            } else {
                fila.style.display = "none";
            }
        });

        if (filaSinResultados) {
            filaSinResultados.style.display = (visibles === 0) ? "" : "none";
        }
    }

    document.addEventListener('DOMContentLoaded', cargarA11yPrefs);
</script>

</body>
</html>
