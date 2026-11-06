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
    <title>Panel de Innovación Bibliotecaria (ODS 09) - BOOKHUB</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>
        body {
            background-color: #f5f7fa;
        }

        .hero-innovacion {
            background: linear-gradient(135deg, #0d6efd, #084298);
            color: #ffffff;
            padding: 48px 0;
        }

        .kpi-card {
            border: 1px solid rgba(0, 0, 0, 0.06);
            border-radius: 12px;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            cursor: pointer;
        }

        .kpi-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 22px rgba(0, 0, 0, 0.1) !important;
        }

        .kpi-card.active-filter {
            outline: 2px solid #0d6efd;
        }

        .kpi-icon {
            width: 52px;
            height: 52px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
        }

        .portada-tabla {
            width: 42px;
            height: 58px;
            object-fit: cover;
            border-radius: 4px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.15);
        }
    </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg bg-dark navbar-dark">
    <div class="container">

        <a class="navbar-brand fw-bold" href="index.html">
            📚 BOOKHUB
        </a>

        <button class="navbar-toggler" type="button"
                data-bs-toggle="collapse"
                data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">

            <ul class="navbar-nav ms-auto align-items-lg-center">

                <li class="nav-item">
                    <a class="nav-link" href="index.html">
                        Inicio
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="CatalogoServlet">
                        Catálogo
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link active fw-semibold" href="InnovacionServlet">
                        ODS 09
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="MisPrestamosServlet">
                        Mis préstamos
                    </a>
                </li>

                <% if (usuarioSesion != null) { %>
                    <% if ("ADMIN".equals(usuarioSesion.getRol())) { %>
                        <li class="nav-item">
                            <a class="btn btn-outline-light btn-sm ms-lg-3 mt-2 mt-lg-0" href="dashboard.jsp">
                                Panel Admin
                            </a>
                        </li>
                    <% } else { %>
                        <li class="nav-item">
                            <a class="btn btn-outline-light btn-sm ms-lg-3 mt-2 mt-lg-0" href="usuario.jsp">
                                Mi cuenta (<%= usuarioSesion.getNombre() %>)
                            </a>
                        </li>
                    <% } %>
                    <li class="nav-item">
                        <a class="btn btn-danger btn-sm ms-lg-2 mt-2 mt-lg-0" href="LogoutServlet">
                            Cerrar sesión
                        </a>
                    </li>
                <% } else { %>
                    <li class="nav-item">
                        <a class="btn btn-outline-light ms-lg-3 mt-2 mt-lg-0" href="registro.jsp">
                            Registrarse
                        </a>
                    </li>

                    <li class="nav-item">
                        <a class="btn btn-primary ms-lg-2 mt-2 mt-lg-0" href="login.jsp">
                            Iniciar sesión
                        </a>
                    </li>
                <% } %>

            </ul>

        </div>
    </div>
</nav>


<!-- ENCABEZADO DEL PANEL DE INNOVACIÓN BIBLIOTECARIA (ODS 09) -->
<section class="hero-innovacion">
    <div class="container">
        <span class="badge bg-light text-primary fw-bold mb-2 px-3 py-2">
            ODS 09 · GESTIÓN BASADA EN DATOS
        </span>
        <h1 class="fw-bold mb-2">
            Panel de Innovación Bibliotecaria
        </h1>
        <p class="lead mb-0 opacity-90">
            Indicadores en tiempo real para mejorar la disponibilidad de los recursos bibliográficos mediante el uso de datos y apoyar la toma de decisiones en la biblioteca.
        </p>
    </div>
</section>


<!-- CONTENIDO PRINCIPAL -->
<div class="container py-5">

    <!-- LOS 4 CUADROS DE INDICADORES CONECTADOS AL CATÁLOGO Y LA BIBLIOTECA -->
    <div class="row g-4 mb-5">

        <!-- 1. LIBROS REGISTRADOS -->
        <div class="col-sm-6 col-xl-3">
            <div class="card kpi-card shadow-sm h-100 border-start border-primary border-4"
                 onclick="filtrarTabla('todos', this)">
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div>
                            <p class="text-muted small fw-bold text-uppercase mb-1">
                                Libros registrados
                            </p>
                            <h2 class="display-5 fw-bold text-primary mb-0">
                                <%= librosRegistrados %>
                            </h2>
                        </div>
                        <div class="kpi-icon bg-primary bg-opacity-10 text-primary">
                            📚
                        </div>
                    </div>
                    <p class="small text-muted mb-0">
                        Total de recursos bibliográficos registrados en el catálogo.
                    </p>
                </div>
            </div>
        </div>

        <!-- 2. STOCK BAJO (1 A 2 EJEMPLARES) -->
        <div class="col-sm-6 col-xl-3">
            <div class="card kpi-card shadow-sm h-100 border-start border-warning border-4"
                 onclick="filtrarTabla('bajo', this)">
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div>
                            <p class="text-muted small fw-bold text-uppercase mb-1">
                                Stock bajo
                            </p>
                            <h2 class="display-5 fw-bold text-warning mb-0">
                                <%= stockBajo %>
                            </h2>
                        </div>
                        <div class="kpi-icon bg-warning bg-opacity-10 text-warning">
                            ⚠️
                        </div>
                    </div>
                    <p class="small text-muted mb-0">
                        Libros con <strong>1 a 2 ejemplares</strong> disponibles que requieren reposición preventiva.
                    </p>
                </div>
            </div>
        </div>

        <!-- 3. PRÉSTAMOS ACTIVOS -->
        <div class="col-sm-6 col-xl-3">
            <div class="card kpi-card shadow-sm h-100 border-start border-info border-4"
                 onclick="filtrarTabla('prestados', this)">
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div>
                            <p class="text-muted small fw-bold text-uppercase mb-1">
                                Préstamos activos
                            </p>
                            <h2 class="display-5 fw-bold text-info mb-0">
                                <%= prestamosActivos %>
                            </h2>
                        </div>
                        <div class="kpi-icon bg-info bg-opacity-10 text-info">
                            📖
                        </div>
                    </div>
                    <p class="small text-muted mb-0">
                        Ejemplares prestados actualmente a los lectores de la biblioteca.
                    </p>
                </div>
            </div>
        </div>

        <!-- 4. LIBROS AGOTADOS (0 EJEMPLARES) -->
        <div class="col-sm-6 col-xl-3">
            <div class="card kpi-card shadow-sm h-100 border-start border-danger border-4"
                 onclick="filtrarTabla('agotado', this)">
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div>
                            <p class="text-muted small fw-bold text-uppercase mb-1">
                                Libros agotados
                            </p>
                            <h2 class="display-5 fw-bold text-danger mb-0">
                                <%= librosAgotados %>
                            </h2>
                        </div>
                        <div class="kpi-icon bg-danger bg-opacity-10 text-danger">
                            🚨
                        </div>
                    </div>
                    <p class="small text-muted mb-0">
                        Libros con <strong>0 ejemplares</strong> disponibles que requieren acción inmediata.
                    </p>
                </div>
            </div>
        </div>

    </div>


    <!-- TABLA DE APOYO A LA TOMA DE DECISIONES SOBRE LOS RECURSOS BIBLIOGRÁFICOS -->
    <div class="card shadow-sm border-0">
        <div class="card-header bg-white py-3 d-flex flex-wrap justify-content-between align-items-center gap-2">
            <div>
                <h5 class="fw-bold mb-1">
                    📈 Monitoreo de Disponibilidad para la Toma de Decisiones
                </h5>
                <p class="text-muted small mb-0">
                    Datos conectados en vivo con el catálogo y el registro de préstamos de la biblioteca. Haz clic en cualquiera de los 4 cuadros superiores o usa los filtros para analizar los recursos.
                </p>
            </div>

            <div class="d-flex flex-wrap gap-2">
                <button type="button" class="btn btn-sm btn-primary btn-filtro-tabla" id="btnTodos" onclick="filtrarTabla('todos', null)">
                    Todos (<%= librosRegistrados %>)
                </button>
                <button type="button" class="btn btn-sm btn-outline-warning text-dark btn-filtro-tabla" id="btnBajo" onclick="filtrarTabla('bajo', null)">
                    Stock bajo (<%= stockBajo %>)
                </button>
                <button type="button" class="btn btn-sm btn-outline-info text-dark btn-filtro-tabla" id="btnPrestados" onclick="filtrarTabla('prestados', null)">
                    Con préstamos activos
                </button>
                <button type="button" class="btn btn-sm btn-outline-danger btn-filtro-tabla" id="btnAgotado" onclick="filtrarTabla('agotado', null)">
                    Libros agotados (<%= librosAgotados %>)
                </button>
            </div>
        </div>

        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-4">Recurso Bibliográfico</th>
                            <th>Categoría</th>
                            <th class="text-center">Stock Actual</th>
                            <th class="text-center">Préstamos Activos</th>
                            <th>Estado de Disponibilidad</th>
                            <th>Recomendación para Toma de Decisiones</th>
                            <th class="text-end pe-4">Acción</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (libros != null && !libros.isEmpty()) {
                               for (Libro libro : libros) {
                                   int stock = libro.getStock();
                                   int activosLibro = (prestamosActivosPorLibro != null)
                                           ? prestamosActivosPorLibro.getOrDefault(libro.getIdLibro(), 0)
                                           : 0;

                                   String estadoFiltro;
                                   String badgeClase;
                                   String textoEstado;
                                   String recomendacion;

                                   if (stock == 0) {
                                       estadoFiltro = "agotado";
                                       badgeClase = "bg-danger";
                                       textoEstado = "Agotado (0 disp.)";
                                       recomendacion = "Prioridad alta: Adquirir nuevos ejemplares o dar seguimiento a devoluciones.";
                                   } else if (stock >= 1 && stock <= 2) {
                                       estadoFiltro = "bajo";
                                       badgeClase = "bg-warning text-dark";
                                       textoEstado = "Stock bajo (" + stock + " disp.)";
                                       recomendacion = "Prioridad media: Programar reposición preventiva (stock entre 1 y 2).";
                                   } else {
                                       estadoFiltro = "optimo";
                                       badgeClase = "bg-success";
                                       textoEstado = "Disponible (" + stock + " disp.)";
                                       if (activosLibro > 0) {
                                           recomendacion = "Recurso en circulación activa: Monitorear rotación de ejemplares.";
                                       } else {
                                           recomendacion = "Disponibilidad óptima para cubrir nuevas solicitudes de préstamo.";
                                       }
                                   }
                        %>
                            <tr class="fila-recurso"
                                data-estado="<%= estadoFiltro %>"
                                data-prestamos="<%= activosLibro %>">
                                <td class="ps-4">
                                    <div class="d-flex align-items-center gap-3">
                                        <img src="<%= libro.getImagenPortada() %>"
                                             alt="Portada"
                                             class="portada-tabla"
                                             onerror="this.onerror=null;this.src='img/portadas/default.svg';">
                                        <div>
                                            <div class="fw-bold"><%= libro.getTitulo() %></div>
                                            <div class="text-muted small"><%= libro.getNombreAutor() %> · ISBN: <%= libro.getIsbn() %></div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <span class="badge bg-secondary">
                                        <%= libro.getNombreCategoria() %>
                                    </span>
                                </td>
                                <td class="text-center fw-bold">
                                    <%= stock %>
                                </td>
                                <td class="text-center">
                                    <% if (activosLibro > 0) { %>
                                        <span class="badge bg-info text-dark">
                                            <%= activosLibro %> en préstamo
                                        </span>
                                    <% } else { %>
                                        <span class="text-muted small">0</span>
                                    <% } %>
                                </td>
                                <td>
                                    <span class="badge <%= badgeClase %>">
                                        <%= textoEstado %>
                                    </span>
                                </td>
                                <td class="small text-muted">
                                    <%= recomendacion %>
                                </td>
                                <td class="text-end pe-4">
                                    <a href="DetalleLibroServlet?id=<%= libro.getIdLibro() %>"
                                       class="btn btn-sm btn-outline-primary">
                                        Ver ficha
                                    </a>
                                </td>
                            </tr>
                        <%     }
                           } else { %>
                            <tr>
                                <td colspan="7" class="text-center py-4 text-muted">
                                    No hay libros registrados en el catálogo.
                                </td>
                            </tr>
                        <% } %>
                        <tr id="filaSinResultados" style="display: none;">
                            <td colspan="7" class="text-center py-4 text-muted">
                                No hay recursos bibliográficos en este indicador actualmente.
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div>


<!-- FOOTER -->
<footer class="bg-dark text-white py-4 mt-5">
    <div class="container text-center">
        <p class="mb-1">
            <strong>BOOKHUB</strong>
        </p>
        <p class="mb-0 small text-secondary">
            Sistema Web de Gestión de Biblioteca Universitaria · Panel de Innovación Bibliotecaria (ODS 09)
        </p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function filtrarTabla(criterio, cardElemento) {
        const filas = document.querySelectorAll(".fila-recurso");
        const filaSinResultados = document.getElementById("filaSinResultados");
        let visibles = 0;

        document.querySelectorAll(".kpi-card").forEach(c => c.classList.remove("active-filter"));
        if (cardElemento) {
            cardElemento.classList.add("active-filter");
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
</script>

</body>
</html>
