<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="modelo.beans.Libro"%>
<%@page import="modelo.beans.Categoria"%>
<%@page import="modelo.beans.Usuario"%>
<%@page import="modelo.dao.LibroDAO"%>
<%@page import="modelo.dao.CategoriaDAO"%>

<%
    List<Libro> libros =
            (List<Libro>) request.getAttribute("libros");

    List<Categoria> categorias =
            (List<Categoria>) request.getAttribute("categorias");

    if (libros == null || categorias == null) {
        LibroDAO ldao = new LibroDAO();
        CategoriaDAO cdao = new CategoriaDAO();
        if (libros == null) libros = ldao.listar();
        if (categorias == null) categorias = cdao.listar();
    }

    String busqueda =
            (String) request.getAttribute("busqueda");
    if (busqueda == null) {
        busqueda = "";
    }

    String categoriaSeleccionada =
            (String) request.getAttribute("categoriaSeleccionada");
    if (categoriaSeleccionada == null) {
        categoriaSeleccionada = "";
    }

    Usuario usuarioSesion =
            (Usuario) session.getAttribute("usuario");

    int totalLibros = (libros != null) ? libros.size() : 0;
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
    <title>Catálogo de Libros - BookHub</title>

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

        .navbar-brand {
            letter-spacing: 0.5px;
        }

        .hero {
            background: linear-gradient(135deg, #1e3a8a 0%, #2563eb 100%);
            color: #ffffff;
            padding: 40px 0;
        }

        .book-card {
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            overflow: hidden;
            background: #ffffff;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .book-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.08) !important;
        }

        /* CONTENEDOR Y PORTADA VISIBLE EN EL CATÁLOGO */
        .book-cover-wrapper {
            position: relative;
            background-color: #f1f5f9;
            height: 250px;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 12px;
            border-bottom: 1px solid #e2e8f0;
        }

        .book-cover-wrapper a.cover-link {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 160px;
            height: 224px;
            text-decoration: none;
        }

        .book-cover-img {
            width: 160px;
            height: 224px;
            max-width: 100%;
            object-fit: cover;
            border-radius: 6px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            display: block;
            transition: transform 0.25s ease;
        }

        .book-card:hover .book-cover-img {
            transform: scale(1.03);
        }

        .stock-floating-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            z-index: 2;
            font-size: 0.75rem;
            font-weight: 500;
        }

        .quick-view-btn {
            position: absolute;
            bottom: 10px;
            right: 10px;
            z-index: 2;
            font-size: 0.75rem;
            background: rgba(255, 255, 255, 0.95);
            border: 1px solid #cbd5e1;
        }

        .chip-filtro {
            font-size: 0.85rem;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .chip-filtro.active {
            background-color: #2563eb !important;
            color: #ffffff !important;
            border-color: #2563eb !important;
        }

        /* Estilos globales de accesibilidad WCAG AAA provistos por a11y-panel.jsp */
    
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
            padding: 6px 14px;
            font-size: 0.82rem;
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
            font-size: 0.95rem;
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
                <button class="btn btn-outline-light text-start d-flex align-items-center gap-2 py-2 px-3 rounded-3"
                        type="button"
                        onclick="iniciarDictadoVoz();">
                    <i class="bi bi-mic"></i> Búsqueda por Voz
                </button>
            </div>
        </div>

        <div class="pt-3 border-top border-secondary border-opacity-25 text-center text-white-50 small">
            <span>BookHub v2.0 • Inclusión Digital</span>
        </div>
    </div>
</div>

<!-- NAVEGACIÓN PRINCIPAL (SE DESVANECE AL HACER SCROLL) -->
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


<!-- ENCABEZADO -->
<section class="hero">

    <div class="container text-center">

        <h1 class="fw-bold mb-2">
            Catálogo de Libros
        </h1>

        <p class="lead mb-0 text-white-50">
            Consulta los títulos disponibles, escucha la síntesis de cada libro o solicita un préstamo.
        </p>

    </div>

</section>


<!-- CONTENIDO -->
<div class="container py-4">

    <!-- BUSCADOR CON DICTADO POR VOZ Y FILTROS -->
    <div class="card shadow-sm mb-4">

        <div class="card-body">

            <div class="d-flex flex-wrap justify-content-between align-items-center mb-3">
                <h6 class="fw-bold mb-0 text-secondary">
                    Búsqueda y Filtros
                </h6>
                <span class="badge bg-light text-dark border" id="contadorResultados">
                    <%= totalLibros %> ejemplares
                </span>
            </div>

            <form action="CatalogoServlet" method="get" class="row g-2 align-items-end">

                <div class="col-md-5">
                    <label class="form-label small text-muted mb-1">Título, autor o ISBN</label>
                    <div class="input-group">
                        <input type="text"
                               id="buscador"
                               name="busqueda"
                               value="<%= busqueda %>"
                               class="form-control"
                               placeholder="Escribe para buscar...">
                        <button class="btn btn-outline-secondary"
                                type="button"
                                id="btnVoiceSearch"
                                onclick="iniciarBusquedaPorVoz()"
                                title="Dictar búsqueda por voz">
                            Dictar
                        </button>
                    </div>
                    <div id="voiceSearchStatus" class="small text-muted mt-1" style="display:none;"></div>
                </div>

                <div class="col-md-4">
                    <label class="form-label small text-muted mb-1">Categoría</label>
                    <select name="categoria" id="filtroCategoria" class="form-select">
                        <option value="">Todas las categorías</option>
                        <% if (categorias != null) {
                                for (Categoria cat : categorias) {
                                    boolean sel = cat.getNombre().equalsIgnoreCase(categoriaSeleccionada);
                        %>
                            <option value="<%= cat.getNombre() %>" <%= sel ? "selected" : "" %>>
                                <%= cat.getNombre() %>
                            </option>
                        <%     }
                           } %>
                    </select>
                </div>

                <div class="col-md-3 d-flex gap-2">
                    <button type="submit" class="btn btn-primary flex-grow-1">
                        Buscar
                    </button>
                    <a href="CatalogoServlet" class="btn btn-outline-secondary">
                        Restablecer
                    </a>
                </div>

            </form>

            <!-- FILTROS RÁPIDOS -->
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-2 mt-3 pt-3 border-top">
                <div class="d-flex flex-wrap align-items-center gap-1">
                    <span class="small text-muted me-1">Filtrar:</span>
                    <button type="button" class="btn btn-sm btn-outline-primary chip-filtro active" onclick="filtrarPorChip('', this)">
                        Todos
                    </button>
                    <button type="button" class="btn btn-sm btn-outline-secondary chip-filtro" onclick="filtrarPorChip('novela', this)">
                        Novela
                    </button>
                    <button type="button" class="btn btn-sm btn-outline-secondary chip-filtro" onclick="filtrarPorChip('programación', this)">
                        Programación
                    </button>
                </div>

                <div class="form-check form-switch mb-0">
                    <input class="form-check-input" type="checkbox" id="soloDisponibles" onchange="aplicarFiltrosInteractivos()">
                    <label class="form-check-label small text-muted" for="soloDisponibles">
                        Solo con ejemplares disponibles
                    </label>
                </div>
            </div>

        </div>

    </div>


    <!-- LISTA DE LIBROS -->
    <div class="row g-4" id="listaLibros">

        <% if (libros != null && !libros.isEmpty()) { %>

            <% for (Libro libro : libros) {
                   String portadaUrl = libro.getImagenPortada();
                   if (portadaUrl == null || portadaUrl.trim().isEmpty()) {
                       portadaUrl = "img/portadas/default.svg";
                   }
                   String tituloEsc = libro.getTitulo() != null ? libro.getTitulo().replace("\"", "&quot;").replace("'", "") : "";
                   String autorEsc = libro.getNombreAutor() != null ? libro.getNombreAutor().replace("\"", "&quot;").replace("'", "") : "";
                   String catEsc = libro.getNombreCategoria() != null ? libro.getNombreCategoria().replace("\"", "&quot;").replace("'", "") : "";
                   String descEsc = libro.getDescripcion() != null ? libro.getDescripcion().replace("\"", "&quot;").replace("'", "") : "";
            %>

                <div class="col-md-4 libro-item"
                     data-stock="<%= libro.getStock() %>"
                     data-categoria="<%= catEsc.toLowerCase() %>">

                    <div class="card book-card h-100 shadow-sm">

                        <!-- PORTADA VISIBLE DEL LIBRO -->
                        <div class="book-cover-wrapper">
                            <% if (libro.getStock() > 0) { %>
                                <span class="badge bg-success stock-floating-badge shadow-sm">
                                    Disponible (<%= libro.getStock() %>)
                                </span>
                            <% } else { %>
                                <span class="badge bg-secondary stock-floating-badge shadow-sm">
                                    Agotado
                                </span>
                            <% } %>

                            <a href="DetalleLibroServlet?id=<%= libro.getIdLibro() %>" class="cover-link" title="Ver ficha de <%= tituloEsc %>">
                                <img src="<%= portadaUrl %>"
                                     alt="Portada de <%= tituloEsc %>"
                                     class="book-cover-img"
                                     onerror="this.onerror=null;this.src='img/portadas/default.svg';">
                            </a>

                            <button type="button"
                                    class="btn btn-sm quick-view-btn shadow-sm"
                                    data-id="<%= libro.getIdLibro() %>"
                                    data-titulo="<%= tituloEsc %>"
                                    data-autor="<%= autorEsc %>"
                                    data-categoria="<%= catEsc %>"
                                    data-isbn="<%= libro.getIsbn() %>"
                                    data-anio="<%= libro.getAnio() %>"
                                    data-stock="<%= libro.getStock() %>"
                                    data-descripcion="<%= descEsc %>"
                                    data-portada="<%= portadaUrl %>"
                                    onclick="abrirVistaRapida(this)">
                                Vista rápida
                            </button>
                        </div>

                        <div class="card-body d-flex flex-column p-3">

                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="badge bg-light text-dark border">
                                    <%= libro.getNombreCategoria() %>
                                </span>
                                <span class="text-muted small">
                                    <%= libro.getAnio() %>
                                </span>
                            </div>

                            <h6 class="card-title fw-bold mb-1">
                                <%= libro.getTitulo() %>
                            </h6>

                            <p class="text-muted small mb-1">
                                <%= libro.getNombreAutor() %>
                            </p>

                            <p class="card-text text-secondary small mb-3 lh-sm" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                <%= libro.getDescripcion() %>
                            </p>

                            <div class="mt-auto pt-2 border-top">
                                <div class="d-grid gap-2">
                                    <button type="button"
                                            class="btn-audio-detailed w-100"
                                            onclick="leerLibroAudio('<%= tituloEsc %>', '<%= autorEsc %>', '<%= descEsc %>')"
                                            title="Reproducir audio de <%= tituloEsc %>">
                                        <i class="bi bi-volume-up-fill"></i>
                                        <span>Audio</span>
                                    </button>

                                    <div class="d-flex gap-2">
                                        <a href="DetalleLibroServlet?id=<%= libro.getIdLibro() %>"
                                           class="btn btn-primary btn-sm flex-grow-1">
                                            Detalles
                                        </a>

                                        <% if (libro.getStock() > 0) { %>
                                            <a href="SolicitarPrestamoServlet?idLibro=<%= libro.getIdLibro() %>"
                                               class="btn btn-outline-primary btn-sm">
                                                Préstamo
                                            </a>
                                        <% } %>
                                    </div>
                                </div>
                            </div>

                        </div>

                    </div>

                </div>

            <% } %>

        <% } else { %>

            <div class="col-12">
                <div class="alert alert-light border text-center py-4">
                    No se encontraron libros con los criterios seleccionados.
                    <a href="CatalogoServlet" class="ms-2">Ver todo el catálogo</a>
                </div>
            </div>

        <% } %>

    </div>

</div>


<!-- MODAL DE VISTA RÁPIDA -->
<div class="modal fade" id="modalVistaRapida" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-light">
                <h6 class="modal-title fw-bold" id="modalTitulo">Vista rápida del libro</h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>
            <div class="modal-body p-4">
                <div class="row g-4 align-items-center">
                    <div class="col-md-4 text-center">
                        <img id="modalPortada"
                             src="img/portadas/default.svg"
                             alt="Portada"
                             class="rounded shadow-sm"
                             style="width: 170px; height: 238px; object-fit: cover;"
                             onerror="this.onerror=null;this.src='img/portadas/default.svg';">
                    </div>
                    <div class="col-md-8">
                        <span class="badge bg-secondary mb-2" id="modalCategoria"></span>
                        <h5 class="fw-bold mb-1" id="modalNombreLibro"></h5>
                        <p class="mb-1 text-muted">Autor: <span id="modalAutor" class="text-dark"></span></p>
                        <p class="mb-2 text-muted small">ISBN: <span id="modalIsbn"></span> · Año: <span id="modalAnio"></span></p>
                        <hr class="my-2">
                        <p class="text-secondary small mb-3" id="modalDescripcion"></p>
                        <div class="mb-3" id="modalStockBadge"></div>
                        <div class="d-flex flex-wrap gap-2">
                            <button type="button" class="btn-audio-detailed" id="modalBtnAudio" onclick="escucharModalActual()">
                                <i class="bi bi-volume-up-fill"></i>
                                <span>Audio</span>
                            </button>
                            <a id="modalBtnDetalle" href="#" class="btn btn-primary btn-sm">Ficha completa</a>
                            <a id="modalBtnPrestamo" href="#" class="btn btn-outline-primary btn-sm">Solicitar préstamo</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>





<!-- PIE DE PÁGINA -->
<footer class="bg-dark text-white text-center py-4 mt-5">
    <div class="container">
        <p class="mb-1 fw-bold">BookHub</p>
        <p class="mb-0 small text-secondary">
            Sistema de Gestión de Biblioteca Universitaria · Cumplimiento de accesibilidad digital
        </p>
    </div>
</footer>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- SCRIPTS DE BÚSQUEDA, FILTROS Y ACCESIBILIDAD SUITE -->
<script>
    const buscador = document.getElementById("buscador");
    const soloDisponibles = document.getElementById("soloDisponibles");
    const librosItems = document.querySelectorAll(".libro-item");
    const contadorResultados = document.getElementById("contadorResultados");
    let chipActivo = "";

    function filtrarPorChip(categoriaTexto, boton) {
        chipActivo = categoriaTexto.toLowerCase();
        document.querySelectorAll(".chip-filtro").forEach(btn => btn.classList.remove("active"));
        boton.classList.add("active");
        aplicarFiltrosInteractivos();
    }

    function aplicarFiltrosInteractivos() {
        const texto = buscador ? buscador.value.toLowerCase().trim() : "";
        const requiereStock = soloDisponibles ? soloDisponibles.checked : false;
        let visibles = 0;

        librosItems.forEach(function (libro) {
            const contenido = libro.textContent.toLowerCase();
            const stock = parseInt(libro.getAttribute("data-stock") || "0", 10);
            const coincideTexto = texto === "" || contenido.includes(texto);
            const coincideChip = chipActivo === "" || contenido.includes(chipActivo);
            const coincideStock = !requiereStock || stock > 0;

            if (coincideTexto && coincideChip && coincideStock) {
                libro.style.display = "block";
                visibles++;
            } else {
                libro.style.display = "none";
            }
        });

        if (contadorResultados) {
            contadorResultados.textContent = visibles + " ejemplares";
        }
    }

    if (buscador) {
        buscador.addEventListener("keyup", aplicarFiltrosInteractivos);
    }

    // MODAL VISTA RÁPIDA
    let datosModalActual = { titulo: '', autor: '', desc: '' };

    function abrirVistaRapida(btn) {
        const id = btn.getAttribute("data-id");
        const titulo = btn.getAttribute("data-titulo");
        const autor = btn.getAttribute("data-autor");
        const categoria = btn.getAttribute("data-categoria");
        const isbn = btn.getAttribute("data-isbn");
        const anio = btn.getAttribute("data-anio");
        const stock = parseInt(btn.getAttribute("data-stock") || "0", 10);
        const descripcion = btn.getAttribute("data-descripcion");
        const portada = btn.getAttribute("data-portada") || "img/portadas/default.svg";

        datosModalActual = { titulo, autor, desc: descripcion };

        document.getElementById("modalNombreLibro").textContent = titulo;
        document.getElementById("modalAutor").textContent = autor;
        document.getElementById("modalCategoria").textContent = categoria;
        document.getElementById("modalIsbn").textContent = isbn;
        document.getElementById("modalAnio").textContent = anio;
        document.getElementById("modalDescripcion").textContent = descripcion;
        document.getElementById("modalPortada").src = portada;

        const stockContainer = document.getElementById("modalStockBadge");
        const btnPrestamo = document.getElementById("modalBtnPrestamo");
        document.getElementById("modalBtnDetalle").href = "DetalleLibroServlet?id=" + id;

        if (stock > 0) {
            stockContainer.innerHTML = '<span class="badge bg-success">Disponible (' + stock + ' ejemplares)</span>';
            btnPrestamo.style.display = "inline-block";
            btnPrestamo.href = "SolicitarPrestamoServlet?idLibro=" + id;
        } else {
            stockContainer.innerHTML = '<span class="badge bg-secondary">Agotado</span>';
            btnPrestamo.style.display = "none";
        }

        const modal = new bootstrap.Modal(document.getElementById("modalVistaRapida"));
        modal.show();
    }

    function escucharModalActual() {
        leerLibroAudio(datosModalActual.titulo, datosModalActual.autor, datosModalActual.desc);
    }

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

    function leerLibroAudio(titulo, autor, descripcion) {
        const texto = "Título: " + titulo + ". Autor: " + autor + ". Sinopsis: " + descripcion;
        reproducirAudio(texto, 1.0);
    }

    function detenerVoz() {
        if ('speechSynthesis' in window) {
            window.speechSynthesis.cancel();
        }
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

    // BÚSQUEDA POR VOZ
    function iniciarBusquedaPorVoz() {
        const statusBox = document.getElementById("voiceSearchStatus");
        const btnMic = document.getElementById("btnVoiceSearch");
        const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;

        if (!SpeechRecognition) {
            if (statusBox) {
                statusBox.style.display = "block";
                statusBox.textContent = "Navegador sin soporte de reconocimiento de voz.";
            }
            return;
        }

        const recognition = new SpeechRecognition();
        recognition.lang = 'es-ES';
        recognition.continuous = false;
        recognition.interimResults = false;

        recognition.onstart = function () {
            if (statusBox) {
                statusBox.style.display = "block";
                statusBox.textContent = "Escuchando... Di el título o autor.";
            }
            if (btnMic) {
                btnMic.classList.add("btn-danger");
                btnMic.classList.remove("btn-outline-secondary");
                btnMic.textContent = "Escuchando...";
            }
        };

        recognition.onresult = function (event) {
            const transcripcion = event.results[0][0].transcript;
            if (buscador) {
                buscador.value = transcripcion;
                aplicarFiltrosInteractivos();
            }
            if (statusBox) {
                statusBox.textContent = 'Búsqueda: "' + transcripcion + '"';
            }
        };

        recognition.onerror = function (event) {
            if (statusBox) {
                statusBox.style.display = "block";
                statusBox.textContent = "No se detectó audio (" + event.error + ").";
            }
        };

        recognition.onend = function () {
            if (btnMic) {
                btnMic.classList.remove("btn-danger");
                btnMic.classList.add("btn-outline-secondary");
                btnMic.textContent = "Dictar";
            }
        };

        try {
            recognition.start();
        } catch (e) {
            console.warn(e);
        }
    }

    // Accesibilidad global administrada por a11y-panel.jsp
</script>

<%@include file="a11y-panel.jsp"%>
</body>

</html>
