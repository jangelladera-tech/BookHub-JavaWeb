<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="beans.Libro"%>
<%@page import="beans.Categoria"%>
<%@page import="beans.Usuario"%>

<%
    List<Libro> libros =
            (List<Libro>) request.getAttribute("libros");

    List<Categoria> categorias =
            (List<Categoria>) request.getAttribute("categorias");

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

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Catálogo Inclusivo - BOOKHUB (ODS 09)</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>
        :root {
            --a11y-font-scale: 1;
        }

        body {
            background-color: #f8f9fa;
            font-size: calc(1rem * var(--a11y-font-scale));
            transition: background-color 0.25s ease, color 0.25s ease;
        }

        .hero {
            background: linear-gradient(135deg, #0d6efd, #084298);
            color: white;
            padding: 45px 0;
        }

        .book-card {
            transition: transform 0.25s ease, box-shadow 0.25s ease;
            border: 1px solid rgba(0, 0, 0, 0.08);
            overflow: hidden;
            background: #ffffff;
        }

        .book-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 12px 24px rgba(13, 110, 253, 0.12) !important;
        }

        .book-cover-wrapper {
            position: relative;
            background: linear-gradient(180deg, #e9ecef 0%, #dee2e6 100%);
            height: 250px;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 14px;
            overflow: hidden;
            border-bottom: 1px solid rgba(0, 0, 0, 0.06);
        }

        .book-cover-img {
            max-height: 222px;
            width: auto;
            max-width: 100%;
            object-fit: contain;
            border-radius: 6px;
            box-shadow: 0 8px 18px rgba(0, 0, 0, 0.22);
            transition: transform 0.3s ease;
        }

        .book-card:hover .book-cover-img {
            transform: scale(1.05);
        }

        .stock-floating-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            z-index: 2;
        }

        .quick-view-btn {
            position: absolute;
            bottom: 10px;
            right: 10px;
            z-index: 2;
            opacity: 0.92;
            font-size: 0.78rem;
        }

        .badge-ods {
            background-color: #fd6925;
            color: #ffffff;
        }

        .chip-filtro {
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .chip-filtro.active {
            background-color: #0d6efd !important;
            color: #ffffff !important;
            border-color: #0d6efd !important;
        }

        /* ACCESIBILIDAD UNIVERSAL (ODS 09) */
        body.a11y-high-contrast {
            background-color: #000000 !important;
            color: #ffff00 !important;
        }
        body.a11y-high-contrast .card,
        body.a11y-high-contrast .modal-content,
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
            background-color: #1a1e24 !important;
            color: #e4e7eb !important;
        }
        body.a11y-dark-mode .card,
        body.a11y-dark-mode .modal-content {
            background-color: #242a33 !important;
            color: #e4e7eb !important;
            border-color: #343d4a !important;
        }
        body.a11y-dyslexia {
            font-family: 'OpenDyslexic', 'Comic Sans MS', sans-serif !important;
            letter-spacing: 0.06em !important;
            word-spacing: 0.12em !important;
            line-height: 1.8 !important;
        }
        body.a11y-highlight-focus *:focus {
            outline: 3px solid #ff9800 !important;
            outline-offset: 3px !important;
        }

        #a11yReadingRuler {
            display: none;
            position: fixed;
            left: 0;
            width: 100vw;
            height: 38px;
            background: rgba(253, 105, 37, 0.18);
            border-top: 2px dashed #fd6925;
            border-bottom: 2px dashed #fd6925;
            pointer-events: none;
            z-index: 99999;
            transform: translateY(-50%);
        }

        .a11y-float-btn {
            position: fixed;
            bottom: 25px;
            right: 25px;
            width: 58px;
            height: 58px;
            border-radius: 50%;
            background: #fd6925;
            color: #ffffff;
            border: 3px solid #ffffff;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.28);
            font-size: 1.6rem;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            z-index: 9999;
            transition: transform 0.2s ease;
        }
        .a11y-float-btn:hover {
            transform: scale(1.1);
        }
        .a11y-float-badge {
            position: absolute;
            top: -4px;
            right: -4px;
            background: #0d6efd;
            color: #ffffff;
            font-size: 0.65rem;
            font-weight: bold;
            padding: 2px 6px;
            border-radius: 10px;
            border: 1px solid #ffffff;
        }
        .a11y-panel {
            position: fixed;
            bottom: 95px;
            right: 25px;
            width: 340px;
            max-width: 90vw;
            background: #ffffff;
            border-radius: 16px;
            border: 1px solid rgba(0, 0, 0, 0.12);
            box-shadow: 0 16px 36px rgba(0, 0, 0, 0.22);
            z-index: 9999;
            overflow: hidden;
            display: none;
        }
        .a11y-panel-header {
            background: linear-gradient(135deg, #fd6925, #0d6efd);
            color: #ffffff;
            padding: 14px 18px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .a11y-panel-body {
            padding: 16px;
            max-height: 480px;
            overflow-y: auto;
        }
        .a11y-opt-title {
            font-size: 0.78rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #6c757d;
            margin-bottom: 6px;
        }
    </style>

</head>

<body>


<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary sticky-top">

    <div class="container">

        <a class="navbar-brand fw-bold"
           href="index.html">
            📚 BOOKHUB
        </a>

        <div class="d-flex align-items-center flex-wrap gap-2">

            <a href="index.html"
               class="btn btn-outline-light btn-sm">
                Inicio
            </a>

            <a href="InnovacionServlet"
               class="btn btn-outline-warning text-white fw-bold btn-sm">
                ♿ ODS 09: Inclusión
            </a>

            <button type="button"
                    class="btn btn-warning btn-sm fw-bold text-dark"
                    onclick="toggleA11yPanel()"
                    title="Herramientas de Accesibilidad Universal (ODS 09)">
                ♿ Accesibilidad
            </button>

            <% if (usuarioSesion != null) { %>

                <% if ("ADMIN".equals(usuarioSesion.getRol())) { %>
                    <a href="dashboard.jsp"
                       class="btn btn-light btn-sm">
                        Panel Admin
                    </a>
                <% } else { %>
                    <a href="usuario.jsp"
                       class="btn btn-light btn-sm">
                        Mi cuenta (<%= usuarioSesion.getNombre() %>)
                    </a>
                    <a href="MisPrestamosServlet"
                       class="btn btn-outline-light btn-sm">
                        Mis préstamos
                    </a>
                <% } %>

                <a href="LogoutServlet"
                   class="btn btn-dark btn-sm">
                    Cerrar sesión
                </a>

            <% } else { %>

                <a href="registro.jsp"
                   class="btn btn-outline-light btn-sm">
                    Registrarse
                </a>

                <a href="login.jsp"
                   class="btn btn-light btn-sm">
                    Iniciar sesión
                </a>

            <% } %>

        </div>

    </div>

</nav>


<!-- HERO -->
<section class="hero">

    <div class="container text-center">

        <div class="d-inline-flex align-items-center gap-2 bg-white bg-opacity-10 px-3 py-1 rounded-pill mb-2">
            <span class="badge bg-warning text-dark fw-bold">ODS 09</span>
            <small class="text-white">Catálogo equipado con audiolibro sintético y búsqueda por voz</small>
        </div>

        <h1 class="fw-bold">
            Catálogo de Libros Accesible
        </h1>

        <p class="lead mb-0">
            Explora títulos con narración por voz, consulta su disponibilidad y gestiona tus préstamos con autonomía.
        </p>

    </div>

</section>


<!-- CONTENIDO -->
<div class="container py-5">

    <!-- BUSCADOR CON DICTADO POR VOZ Y FILTROS -->
    <div class="card shadow-sm mb-4">

        <div class="card-body">

            <div class="d-flex flex-wrap justify-content-between align-items-center mb-3">
                <h5 class="fw-bold mb-0">
                    🔎 Buscar y filtrar libros
                </h5>
                <span class="badge bg-light text-dark border" id="contadorResultados">
                    Mostrando <%= totalLibros %> ejemplar(es)
                </span>
            </div>

            <form action="CatalogoServlet" method="get" class="row g-3">

                <div class="col-md-5">
                    <label class="form-label small text-muted mb-1">
                        Búsqueda por texto o voz (ODS 09)
                    </label>
                    <div class="input-group">
                        <input type="text"
                               id="buscador"
                               name="busqueda"
                               value="<%= busqueda %>"
                               class="form-control"
                               placeholder="Escribe o presiona el micrófono...">
                        <button class="btn btn-outline-warning text-dark fw-bold"
                                type="button"
                                id="btnVoiceSearch"
                                onclick="iniciarBusquedaPorVoz()"
                                title="Búsqueda manos libres por voz para personas con discapacidad motriz">
                            🎤 Dictar
                        </button>
                    </div>
                    <div id="voiceSearchStatus" class="small text-danger fw-semibold mt-1" style="display:none;"></div>
                </div>

                <div class="col-md-4">
                    <label class="form-label small text-muted mb-1">Categoría</label>
                    <select name="categoria"
                            id="filtroCategoria"
                            class="form-select">
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

                <div class="col-md-3 d-flex align-items-end gap-2">
                    <button type="submit" class="btn btn-primary w-100">
                        Aplicar filtro
                    </button>
                    <a href="CatalogoServlet" class="btn btn-outline-secondary">
                        Limpiar
                    </a>
                </div>

            </form>

            <!-- ETIQUETAS RÁPIDAS INTERACTIVAS -->
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-2 mt-3 pt-3 border-top">
                <div class="d-flex flex-wrap align-items-center gap-2">
                    <span class="small text-muted me-1">Filtros rápidos:</span>
                    <button type="button" class="btn btn-sm btn-outline-primary chip-filtro active" onclick="filtrarPorChip('', this)">
                        Todos
                    </button>
                    <button type="button" class="btn btn-sm btn-outline-success chip-filtro" onclick="filtrarPorChip('', this); probarVozTexto('Filtrando catálogo inclusivo con audiolibro activado')">
                        🎧 100% Con Audio
                    </button>
                    <button type="button" class="btn btn-sm btn-outline-primary chip-filtro" onclick="filtrarPorChip('novela', this)">
                        📖 Novela
                    </button>
                    <button type="button" class="btn btn-sm btn-outline-primary chip-filtro" onclick="filtrarPorChip('programación', this)">
                        💻 Programación
                    </button>
                </div>

                <div class="form-check form-switch mb-0">
                    <input class="form-check-input" type="checkbox" id="soloDisponibles" onchange="aplicarFiltrosInteractivos()">
                    <label class="form-check-label small text-muted" for="soloDisponibles">
                        Solo con stock disponible
                    </label>
                </div>
            </div>

        </div>

    </div>


    <!-- LISTA DE LIBROS -->
    <div class="row g-4" id="listaLibros">

        <% if (libros != null && !libros.isEmpty()) { %>

            <% for (Libro libro : libros) {
                   boolean esOds = libro.getNombreCategoria() != null
                           && libro.getNombreCategoria().toUpperCase().contains("ODS 09");
                   String portadaUrl = libro.getImagenPortada();
                   String tituloEsc = libro.getTitulo() != null ? libro.getTitulo().replace("\"", "&quot;").replace("'", "") : "";
                   String autorEsc = libro.getNombreAutor() != null ? libro.getNombreAutor().replace("\"", "&quot;").replace("'", "") : "";
                   String catEsc = libro.getNombreCategoria() != null ? libro.getNombreCategoria().replace("\"", "&quot;").replace("'", "") : "";
                   String descEsc = libro.getDescripcion() != null ? libro.getDescripcion().replace("\"", "&quot;").replace("'", "") : "";
            %>

                <div class="col-md-4 libro-item"
                     data-stock="<%= libro.getStock() %>"
                     data-categoria="<%= catEsc.toLowerCase() %>">

                    <div class="card book-card shadow-sm h-100">

                        <!-- PORTADA DEL LIBRO -->
                        <div class="book-cover-wrapper">
                            <% if (libro.getStock() > 0) { %>
                                <span class="badge bg-success stock-floating-badge shadow-sm">
                                    Disponible (<%= libro.getStock() %>)
                                </span>
                            <% } else { %>
                                <span class="badge bg-danger stock-floating-badge shadow-sm">
                                    No disponible
                                </span>
                            <% } %>

                            <a href="DetalleLibroServlet?id=<%= libro.getIdLibro() %>">
                                <img src="<%= portadaUrl %>"
                                     alt="Portada de <%= tituloEsc %>"
                                     class="book-cover-img"
                                     onerror="this.onerror=null;this.src='img/portadas/default.svg';">
                            </a>

                            <button type="button"
                                    class="btn btn-light btn-sm shadow-sm quick-view-btn"
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
                                👁️ Vista rápida
                            </button>
                        </div>

                        <div class="card-body d-flex flex-column">

                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <div>
                                    <span class="badge <%= esOds ? "badge-ods" : "bg-primary" %>">
                                        <%= libro.getNombreCategoria() %>
                                    </span>
                                    <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25" title="Recurso con audiolibro asistido (ODS 09)">
                                        🎧 Audio
                                    </span>
                                </div>
                                <span class="text-muted small">
                                    Año: <%= libro.getAnio() %>
                                </span>
                            </div>

                            <h5 class="card-title fw-bold">
                                <%= libro.getTitulo() %>
                            </h5>

                            <p class="mb-1 small">
                                <strong>Autor:</strong>
                                <%= libro.getNombreAutor() %>
                            </p>

                            <p class="text-muted small mb-2">
                                ISBN: <%= libro.getIsbn() %>
                            </p>

                            <p class="card-text text-muted small">
                                <%= libro.getDescripcion() %>
                            </p>

                            <div class="mt-auto pt-3">
                                <div class="d-grid gap-2">
                                    <button type="button"
                                            class="btn btn-outline-success btn-sm fw-semibold"
                                            onclick="leerLibroAudio('<%= tituloEsc %>', '<%= autorEsc %>', '<%= descEsc %>')"
                                            title="Escuchar descripción en voz alta para personas con discapacidad visual">
                                        🔊 Escuchar Libro (Audio)
                                    </button>

                                    <div class="d-flex gap-2">
                                        <a href="DetalleLibroServlet?id=<%= libro.getIdLibro() %>"
                                           class="btn btn-primary btn-sm flex-grow-1">
                                            Ver detalles
                                        </a>

                                        <% if (libro.getStock() > 0) { %>
                                            <a href="SolicitarPrestamoServlet?idLibro=<%= libro.getIdLibro() %>"
                                               class="btn btn-outline-primary btn-sm">
                                                Solicitar
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
                <div class="alert alert-info text-center">
                    No se encontraron libros con los criterios seleccionados.
                    <a href="CatalogoServlet" class="alert-link ms-2">Ver todo el catálogo</a>
                </div>
            </div>

        <% } %>

    </div>

</div>


<!-- MODAL DE VISTA RÁPIDA -->
<div class="modal fade" id="modalVistaRapida" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title fw-bold" id="modalTitulo">Detalle rápido del libro</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>
            <div class="modal-body p-4">
                <div class="row g-4 align-items-center">
                    <div class="col-md-4 text-center">
                        <img id="modalPortada"
                             src="img/portadas/default.svg"
                             alt="Portada"
                             class="img-fluid rounded shadow"
                             style="max-height: 260px;"
                             onerror="this.onerror=null;this.src='img/portadas/default.svg';">
                    </div>
                    <div class="col-md-8">
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <span class="badge bg-primary" id="modalCategoria"></span>
                            <span class="badge bg-success">🎧 Audiolibro ODS 09</span>
                        </div>
                        <h4 class="fw-bold mb-2" id="modalNombreLibro"></h4>
                        <p class="mb-1"><strong>Autor:</strong> <span id="modalAutor"></span></p>
                        <p class="mb-1 text-muted small"><strong>ISBN:</strong> <span id="modalIsbn"></span> · <strong>Año:</strong> <span id="modalAnio"></span></p>
                        <hr>
                        <p class="text-muted" id="modalDescripcion"></p>
                        <div class="mb-3" id="modalStockBadge"></div>
                        <div class="d-flex flex-wrap gap-2">
                            <button type="button" class="btn btn-success" id="modalBtnAudio" onclick="escucharModalActual()">
                                🔊 Escuchar en voz alta
                            </button>
                            <a id="modalBtnDetalle" href="#" class="btn btn-primary">Ver ficha completa</a>
                            <a id="modalBtnPrestamo" href="#" class="btn btn-outline-primary">Solicitar préstamo</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<!-- REGLA DE LECTURA VISUAL (TDAH / DISLEXIA) -->
<div id="a11yReadingRuler"></div>


<!-- WIDGET FLOTANTE DE ACCESIBILIDAD UNIVERSAL (ODS 09) -->
<div id="bookhubA11yWidget">
    <button class="a11y-float-btn"
            id="btnA11yToggle"
            type="button"
            onclick="toggleA11yPanel()"
            aria-label="Abrir panel de accesibilidad ODS 09"
            title="Herramientas de Accesibilidad Universal ODS 09">
        ♿
        <span class="a11y-float-badge">ODS 9</span>
    </button>

    <div class="a11y-panel shadow-lg" id="a11yPanel">
        <div class="a11y-panel-header">
            <div class="d-flex align-items-center gap-2">
                <span class="fs-5">♿</span>
                <div>
                    <h6 class="mb-0 fw-bold">Inclusión & Accesibilidad</h6>
                    <small class="opacity-75">ODS 09 · BookHub</small>
                </div>
            </div>
            <button type="button" class="btn-close btn-close-white" onclick="toggleA11yPanel()" aria-label="Cerrar"></button>
        </div>

        <div class="a11y-panel-body">
            <div class="mb-3">
                <div class="a11y-opt-title">🔠 Tamaño de texto</div>
                <div class="btn-group w-100">
                    <button type="button" class="btn btn-outline-secondary btn-sm" onclick="ajustarFuente(-0.1)">A -</button>
                    <button type="button" class="btn btn-outline-secondary btn-sm" onclick="ajustarFuente(0)">Normal</button>
                    <button type="button" class="btn btn-outline-secondary btn-sm" onclick="ajustarFuente(0.15)">A +</button>
                </div>
            </div>

            <div class="mb-3">
                <div class="a11y-opt-title">🌓 Visión y Contraste</div>
                <div class="d-grid gap-1">
                    <button type="button" class="btn btn-outline-dark btn-sm text-start" onclick="toggleHighContrast()">
                        🟡 <strong>Alto contraste</strong> (Baja visión)
                    </button>
                    <button type="button" class="btn btn-outline-dark btn-sm text-start" onclick="toggleDarkMode()">
                        🌑 <strong>Modo Oscuro suave</strong> (Fotofobia)
                    </button>
                    <button type="button" class="btn btn-outline-dark btn-sm text-start" onclick="toggleMonochrome()">
                        ⚪ <strong>Monocromático</strong> (Daltonismo)
                    </button>
                </div>
            </div>

            <div class="mb-3">
                <div class="a11y-opt-title">🧠 Neurodivergencia & Lectura</div>
                <div class="d-grid gap-1">
                    <button type="button" class="btn btn-outline-primary btn-sm text-start" onclick="toggleDyslexiaMode()">
                        📖 <strong>Fuente para Dislexia</strong>
                    </button>
                    <button type="button" class="btn btn-outline-primary btn-sm text-start" onclick="toggleReadingRuler()">
                        📏 <strong>Regla guía de lectura</strong>
                    </button>
                    <button type="button" class="btn btn-outline-secondary btn-sm text-start" onclick="toggleFocusHighlight()">
                        🎯 <strong>Resaltar foco del teclado (Tab)</strong>
                    </button>
                </div>
            </div>

            <div class="mb-3">
                <div class="a11y-opt-title">🗣️ Lector por Voz Asistido</div>
                <div class="d-grid gap-1">
                    <button type="button" class="btn btn-success btn-sm text-start" onclick="probarVozTexto('Catálogo de libros de BookHub. Tienes ' + librosItems.length + ' títulos disponibles para consultar.')">
                        🔊 <strong>Leer resumen del catálogo</strong>
                    </button>
                    <button type="button" class="btn btn-outline-danger btn-sm text-start" onclick="detenerVoz()">
                        ⏹️ Detener audio
                    </button>
                </div>
            </div>

            <div class="pt-2 text-center border-top">
                <button type="button" class="btn btn-link btn-sm text-danger text-decoration-none" onclick="restablecerA11y()">
                    ↺ Restablecer valores por defecto
                </button>
            </div>
        </div>
    </div>
</div>


<!-- FOOTER -->
<footer class="bg-dark text-white text-center py-4 mt-5">
    <p class="mb-0 small">
        © 2026 BOOKHUB - Biblioteca Universitaria Inclusiva · ODS 09 Tecnologías para la Discapacidad
    </p>
</footer>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- MOTOR ACCESIBLE: BÚSQUEDA POR VOZ, SÍNTESIS DE AUDIO Y MODOS VISUALES -->
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
        const texto = buscador.value.toLowerCase().trim();
        const requiereStock = soloDisponibles.checked;
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
            contadorResultados.textContent = "Mostrando " + visibles + " ejemplar(es)";
        }
    }

    if (buscador) {
        buscador.addEventListener("keyup", aplicarFiltrosInteractivos);
    }

    // VISTA RÁPIDA
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
            stockContainer.innerHTML = '<span class="badge bg-danger">No disponible</span>';
            btnPrestamo.style.display = "none";
        }

        const modal = new bootstrap.Modal(document.getElementById("modalVistaRapida"));
        modal.show();
    }

    function escucharModalActual() {
        leerLibroAudio(datosModalActual.titulo, datosModalActual.autor, datosModalActual.desc);
    }

    // SÍNTESIS DE VOZ
    function probarVozTexto(texto, velocidad = 1.0) {
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
        probarVozTexto(texto, 1.0);
    }

    function detenerVoz() {
        if ('speechSynthesis' in window) {
            window.speechSynthesis.cancel();
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
                statusBox.textContent = "Tu navegador no soporta búsqueda por voz (prueba en Chrome o Edge).";
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
                statusBox.textContent = "🔴 Escuchando... Di el título del libro o autor que deseas buscar.";
            }
            if (btnMic) {
                btnMic.classList.add("btn-danger");
                btnMic.classList.remove("btn-outline-warning");
            }
        };

        recognition.onresult = function (event) {
            const transcripcion = event.results[0][0].transcript;
            if (buscador) {
                buscador.value = transcripcion;
                aplicarFiltrosInteractivos();
            }
            if (statusBox) {
                statusBox.className = "small text-success fw-semibold mt-1";
                statusBox.textContent = '✅ Búsqueda por voz completada: "' + transcripcion + '"';
            }
            probarVozTexto('Buscando ' + transcripcion);
        };

        recognition.onerror = function (event) {
            if (statusBox) {
                statusBox.style.display = "block";
                statusBox.className = "small text-danger fw-semibold mt-1";
                statusBox.textContent = "⚠️ No se detectó audio (" + event.error + "). Intenta de nuevo.";
            }
        };

        recognition.onend = function () {
            if (btnMic) {
                btnMic.classList.remove("btn-danger");
                btnMic.classList.add("btn-outline-warning");
            }
        };

        try {
            recognition.start();
        } catch (e) {
            console.warn(e);
        }
    }

    // PREFERENCIAS DE ACCESIBILIDAD (LOCALSTORAGE)
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
            a11yState.fontScale = Math.min(1.4, Math.max(0.85, a11yState.fontScale + delta));
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

    document.addEventListener('DOMContentLoaded', cargarA11yPrefs);
</script>

</body>

</html>
