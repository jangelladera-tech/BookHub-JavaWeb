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

    <title>Catálogo - BOOKHUB</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>

        body {
            background-color: #f8f9fa;
        }

        .hero {
            background: linear-gradient(135deg, #0d6efd, #084298);
            color: white;
            padding: 50px 0;
        }

        .book-card {
            transition: transform 0.25s ease, box-shadow 0.25s ease;
            border: 1px solid rgba(0, 0, 0, 0.08);
            overflow: hidden;
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

        .ods-banner {
            border-left: 5px solid #fd6925;
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

    </style>

</head>

<body>


<!-- NAVBAR -->

<nav class="navbar navbar-dark bg-primary">

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
               class="btn btn-outline-light btn-sm">
                ODS 09
            </a>

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

        <h1 class="fw-bold">
            Catálogo de libros
        </h1>

        <p class="lead mb-0">
            Encuentra los libros disponibles en BOOKHUB y filtra por autor o categoría
        </p>

    </div>

</section>


<!-- CONTENIDO -->

<div class="container py-5">


    <!-- BUSCADOR Y FILTROS -->

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
                    <label class="form-label small text-muted mb-1">Búsqueda por título, autor o ISBN</label>
                    <input type="text"
                           id="buscador"
                           name="busqueda"
                           value="<%= busqueda %>"
                           class="form-control"
                           placeholder="Escribe título, autor o ISBN...">
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


    <!-- LIBROS -->

    <div class="row g-4"
         id="listaLibros">


        <% if (libros != null && !libros.isEmpty()) { %>


            <% for (Libro libro : libros) {
                   boolean esOds = libro.getNombreCategoria() != null
                           && libro.getNombreCategoria().toUpperCase().contains("ODS 09");
                   String portadaUrl = libro.getImagenPortada();
                   String tituloEsc = libro.getTitulo() != null ? libro.getTitulo().replace("\"", "&quot;") : "";
                   String autorEsc = libro.getNombreAutor() != null ? libro.getNombreAutor().replace("\"", "&quot;") : "";
                   String catEsc = libro.getNombreCategoria() != null ? libro.getNombreCategoria().replace("\"", "&quot;") : "";
                   String descEsc = libro.getDescripcion() != null ? libro.getDescripcion().replace("\"", "&quot;") : "";
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

                                <span class="badge <%= esOds ? "badge-ods" : "bg-primary" %>">
                                    <%= libro.getNombreCategoria() %>
                                </span>

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

                                    <a href="DetalleLibroServlet?id=<%= libro.getIdLibro() %>"
                                       class="btn btn-primary btn-sm">
                                        Ver detalles
                                    </a>

                                    <% if (libro.getStock() > 0) { %>
                                        <a href="SolicitarPrestamoServlet?idLibro=<%= libro.getIdLibro() %>"
                                           class="btn btn-outline-primary btn-sm">
                                            Solicitar préstamo
                                        </a>
                                    <% } %>

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
                        <span class="badge bg-primary mb-2" id="modalCategoria"></span>
                        <h4 class="fw-bold mb-2" id="modalNombreLibro"></h4>
                        <p class="mb-1"><strong>Autor:</strong> <span id="modalAutor"></span></p>
                        <p class="mb-1 text-muted small"><strong>ISBN:</strong> <span id="modalIsbn"></span> · <strong>Año:</strong> <span id="modalAnio"></span></p>
                        <hr>
                        <p class="text-muted" id="modalDescripcion"></p>
                        <div class="mb-3" id="modalStockBadge"></div>
                        <div class="d-flex gap-2">
                            <a id="modalBtnDetalle" href="#" class="btn btn-primary">Ver ficha completa</a>
                            <a id="modalBtnPrestamo" href="#" class="btn btn-outline-primary">Solicitar préstamo</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<!-- FOOTER -->

<footer class="bg-dark text-white text-center py-4 mt-5">

    <p class="mb-0">
        © 2026 BOOKHUB - Sistema de Gestión de Biblioteca Universitaria
    </p>

</footer>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- BUSCADOR Y FILTROS INTERACTIVOS EN TIEMPO REAL -->

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

    buscador.addEventListener("keyup", aplicarFiltrosInteractivos);

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

</script>


</body>

</html>
