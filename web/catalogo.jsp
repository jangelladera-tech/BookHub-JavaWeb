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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catálogo de Libros - BookHub</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

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

        /* CONTENEDOR Y VISUALIZACIÓN DE PORTADA EN EL CATÁLOGO */
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

        /* ESTILOS DE ACCESIBILIDAD */
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
            background-color: #0f172a !important;
            color: #e2e8f0 !important;
        }
        body.a11y-dark-mode .card,
        body.a11y-dark-mode .modal-content {
            background-color: #1e293b !important;
            color: #e2e8f0 !important;
            border-color: #334155 !important;
        }
        body.a11y-dark-mode .book-cover-wrapper {
            background-color: #0f172a !important;
            border-bottom-color: #334155 !important;
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
    </style>

</head>

<body>

<!-- NAVEGACIÓN -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">

    <div class="container">

        <a class="navbar-brand fw-bold" href="index.html">
            BookHub
        </a>

        <div class="d-flex align-items-center flex-wrap gap-2">

            <a href="index.html" class="btn btn-outline-light btn-sm">
                Inicio
            </a>

            <a href="InnovacionServlet" class="btn btn-outline-light btn-sm">
                ODS 9: Accesibilidad
            </a>

            <button type="button"
                    class="btn btn-primary btn-sm"
                    onclick="toggleA11yPanel()"
                    title="Opciones de accesibilidad visual y de lectura">
                Accesibilidad
            </button>

            <% if (usuarioSesion != null) { %>

                <% if ("ADMIN".equals(usuarioSesion.getRol())) { %>
                    <a href="dashboard.jsp" class="btn btn-light btn-sm">
                        Panel Admin
                    </a>
                <% } else { %>
                    <a href="usuario.jsp" class="btn btn-light btn-sm">
                        Mi cuenta (<%= usuarioSesion.getNombre() %>)
                    </a>
                    <a href="MisPrestamosServlet" class="btn btn-outline-light btn-sm">
                        Mis préstamos
                    </a>
                <% } %>

                <a href="LogoutServlet" class="btn btn-outline-danger btn-sm">
                    Cerrar sesión
                </a>

            <% } else { %>

                <a href="registro.jsp" class="btn btn-outline-light btn-sm">
                    Registrarse
                </a>

                <a href="login.jsp" class="btn btn-light btn-sm">
                    Iniciar sesión
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
                                            class="btn btn-outline-secondary btn-sm"
                                            onclick="leerLibroAudio('<%= tituloEsc %>', '<%= autorEsc %>', '<%= descEsc %>')"
                                            title="Escuchar descripción en voz alta">
                                        Escuchar descripción
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
                            <button type="button" class="btn btn-outline-secondary btn-sm" id="modalBtnAudio" onclick="escucharModalActual()">
                                Escuchar en voz alta
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


<!-- REGLA DE LECTURA VISUAL (DISLEXIA / SEGUIMIENTO) -->
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
<footer class="bg-dark text-white text-center py-4 mt-5">
    <div class="container">
        <p class="mb-1 fw-bold">BookHub</p>
        <p class="mb-0 small text-secondary">
            Sistema de Gestión de Biblioteca Universitaria · Cumplimiento de accesibilidad digital
        </p>
    </div>
</footer>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- SCRIPTS DE BÚSQUEDA, FILTROS Y ACCESIBILIDAD -->
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

    // GESTIÓN DE ACCESIBILIDAD (LOCALSTORAGE)
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

    document.addEventListener('DOMContentLoaded', cargarA11yPrefs);
</script>

</body>

</html>
