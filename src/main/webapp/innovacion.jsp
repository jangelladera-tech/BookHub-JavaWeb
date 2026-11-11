<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="modelo.beans.Libro"%>
<%@page import="modelo.beans.Prestamo"%>
<%@page import="modelo.beans.Usuario"%>
<%@page import="modelo.dao.LibroDAO"%>
<%@page import="modelo.dao.PrestamoDAO"%>

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
    <!-- Favicon / Logo oficial de la ventana y pestañas -->
    <link rel="icon" type="image/x-icon" href="favicon.ico">
    <link rel="shortcut icon" type="image/x-icon" href="favicon.ico">
    <link rel="icon" type="image/png" sizes="32x32" href="favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="favicon-16x16.png">
    <link rel="icon" type="image/svg+xml" href="img/logo.svg">
    <link rel="apple-touch-icon" href="favicon-180x180.png">

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ODS 9: Innovación y Accesibilidad - BookHub</title>

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

        /* Estilos globales de accesibilidad WCAG AAA provistos por a11y-panel.jsp */
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
                    <button class="btn-audio-detailed px-3 py-2" onclick="reproducirAudio('BookHub incorpora tecnologías de asistencia para la lectura y navegación accesible en la comunidad universitaria.')">
                        <i class="bi bi-volume-up-fill"></i> <span>Audio presentación</span>
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
                            <button type="button" class="btn btn-outline-dark btn-sm text-start" onclick="setTemaContraste('contrast')">
                                Alto contraste (Amarillo / Negro)
                            </button>
                            <button type="button" class="btn btn-outline-secondary btn-sm text-start" onclick="setTemaContraste('sepia')">
                                Sepia (Papel cálido)
                            </button>
                            <button type="button" class="btn btn-outline-secondary btn-sm text-start" onclick="toggleDyslexia()">
                                Tipografía para dislexia
                            </button>
                            <button type="button" class="btn btn-outline-secondary btn-sm text-start" onclick="toggleRuler()">
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
    // Accesibilidad global administrada por a11y-panel.jsp
</script>

</body>
</html>
