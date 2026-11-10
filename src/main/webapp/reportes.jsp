<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="beans.Libro"%>
<%@page import="beans.Prestamo"%>
<%@page import="beans.Usuario"%>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null || !"ADMIN".equals(usuario.getRol())) {
        response.sendRedirect("login.jsp");
        return;
    }

    Integer totalLibros = (Integer) request.getAttribute("totalLibros");
    if (totalLibros == null) {
        response.sendRedirect("ReportesServlet");
        return;
    }

    int totalEjemplares = (Integer) request.getAttribute("totalEjemplares");
    int librosAgotados = (Integer) request.getAttribute("librosAgotados");
    int librosBajoStock = (Integer) request.getAttribute("librosBajoStock");
    int totalPrestamos = (Integer) request.getAttribute("totalPrestamos");
    int prestamosActivos = (Integer) request.getAttribute("prestamosActivos");
    int prestamosDevueltos = (Integer) request.getAttribute("prestamosDevueltos");
    int totalUsuarios = (Integer) request.getAttribute("totalUsuarios");
    int donacionesPendientes = (Integer) request.getAttribute("donacionesPendientes");
    Map<String, Integer> librosPorCat = (Map<String, Integer>) request.getAttribute("librosPorCat");
    List<Libro> libros = (List<Libro>) request.getAttribute("libros");
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
    <title>Reportes y Métricas - BOOKHUB</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        /* BOTÓN DE 3 LÍNEAS (HAMBURGUESA) UNIFICADO */
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

        /* VENTANA LATERAL (OFFCANVAS) UNIFICADA */
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

<!-- OFFCANVAS ADMIN UNIFICADO -->
<div class="offcanvas offcanvas-start offcanvas-bookhub shadow-lg" tabindex="-1" id="sidebarBookHub" aria-labelledby="sidebarBookHubLabel">
    <div class="offcanvas-header border-bottom border-secondary border-opacity-25 pb-3">
        <div class="d-flex align-items-center gap-2">
            <img src="img/logo.svg" alt="BookHub Logo" width="36" height="36" class="d-inline-block">
            <div>
                <h5 class="offcanvas-title fw-bold text-white mb-0" id="sidebarBookHubLabel">BookHub</h5>
                <small class="text-white-50" style="font-size: 0.72rem;">Panel de Administración</small>
            </div>
        </div>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas" aria-label="Cerrar"></button>
    </div>

    <div class="offcanvas-body d-flex flex-column justify-content-between p-3">
        <div>
            <% if (usuario != null) { %>
            <div class="p-3 mb-3 rounded-3 bg-danger bg-opacity-10 border border-danger border-opacity-25">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-shield-lock-fill fs-3 text-danger"></i>
                    <div class="overflow-hidden">
                        <div class="fw-semibold text-white text-truncate"><%= usuario.getNombre() %></div>
                        <span class="badge bg-danger" style="font-size: 0.68rem;">ADMINISTRADOR</span>
                    </div>
                </div>
            </div>
            <% } %>

            <p class="sidebar-subtitle mb-2 px-2">Apartados Principales</p>
            <div class="d-flex flex-column gap-1 mb-3">
                <a href="index.jsp" class="sidebar-menu-item">
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
                <a href="donar.jsp" class="sidebar-menu-item">
                    <i class="bi bi-gift-fill menu-icon text-danger"></i>
                    <div class="flex-grow-1">
                        <div>Donar Libros</div>
                        <small class="text-white-50" style="font-size: 0.72rem;">Dona libros a la biblioteca</small>
                    </div>
                </a>
            </div>

            <p class="sidebar-subtitle mb-2 px-2">Gestión del Sistema</p>
            <div class="d-flex flex-column gap-1 mb-3">
                <a href="dashboard.jsp" class="sidebar-menu-item">
                    <i class="bi bi-speedometer2 menu-icon text-warning"></i>
                    <span>Dashboard</span>
                </a>
                <a href="LibroServlet" class="sidebar-menu-item">
                    <i class="bi bi-book-half menu-icon text-info"></i>
                    <span>Gestión de Libros</span>
                </a>
                <a href="CategoriaServlet" class="sidebar-menu-item">
                    <i class="bi bi-tags-fill menu-icon text-warning"></i>
                    <span>Gestión de Categorías</span>
                </a>
                <a href="AutorServlet" class="sidebar-menu-item">
                    <i class="bi bi-pen-fill menu-icon text-danger"></i>
                    <span>Gestión de Autores</span>
                </a>
                <a href="PrestamoServlet" class="sidebar-menu-item">
                    <i class="bi bi-card-checklist menu-icon text-primary"></i>
                    <span>Gestión de Préstamos</span>
                </a>
                <a href="UsuarioServlet" class="sidebar-menu-item">
                    <i class="bi bi-people-fill menu-icon text-success"></i>
                    <span>Gestión de Usuarios</span>
                </a>
                <a href="DonacionesServlet" class="sidebar-menu-item">
                    <i class="bi bi-gift-fill menu-icon text-danger"></i>
                    <span>Donaciones de Libros</span>
                </a>
                <a href="ReportesServlet" class="sidebar-menu-item active">
                    <i class="bi bi-graph-up-arrow menu-icon text-info"></i>
                    <span>Reportes y Métricas</span>
                </a>
                <a href="SancionesServlet" class="sidebar-menu-item">
                    <i class="bi bi-exclamation-octagon-fill menu-icon text-warning"></i>
                    <span>Sanciones y Mora</span>
                </a>
            </div>
        </div>
        <div class="pt-3 border-top border-secondary border-opacity-25 text-center text-white-50 small">
            <span>BookHub v2.0 • Panel Administrativo</span>
        </div>
    </div>
</div>

<!-- NAVBAR UNIFICADO -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm py-2" id="mainNavbar">
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
                <img src="img/logo.svg" alt="BookHub Logo" width="32" height="32" class="d-inline-block">
                <span>BookHub</span>
                <span class="badge bg-danger" style="font-size: 0.65rem;">ADMIN</span>
            </a>
        </div>
        <div class="d-flex align-items-center gap-2 ms-auto">
            <a href="dashboard.jsp" class="btn btn-outline-warning btn-sm d-flex align-items-center gap-1">
                <i class="bi bi-speedometer2"></i> <span class="d-none d-sm-inline">Dashboard</span>
            </a>
            <button onclick="window.print()" class="btn btn-outline-info btn-sm d-flex align-items-center gap-1">
                <i class="bi bi-printer"></i> <span class="d-none d-sm-inline">Imprimir Reporte</span>
            </button>
            <% if (usuario != null) { %>
                <span class="text-white small d-none d-md-inline ms-1">
                    Admin: <strong><%= usuario.getNombre() %></strong>
                </span>
            <% } %>
            <a href="LogoutServlet" class="btn btn-outline-danger btn-sm d-flex align-items-center gap-1">
                <i class="bi bi-box-arrow-left"></i> <span>Salir</span>
            </a>
        </div>
    </div>
</nav>

<div class="container py-4">
    <!-- TÍTULO -->
    <div class="mb-4">
        <h1 class="fw-bold mb-1"><i class="bi bi-graph-up-arrow text-info me-2"></i>Reportes y Métricas del Sistema</h1>
        <p class="text-muted">Indicadores estadísticos del acervo bibliográfico, demanda de lectura y circulación de préstamos.</p>
    </div>

    <!-- TARJETAS DE INDICADORES PRINCIPALES -->
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="card shadow-sm text-center">
                <div class="card-body">
                    <h6 class="text-muted mb-1">Títulos Registrados</h6>
                    <h3 class="fw-bold text-primary mb-0"><%= totalLibros %></h3>
                    <small class="text-muted"><%= totalEjemplares %> ejemplares en total</small>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card shadow-sm text-center">
                <div class="card-body">
                    <h6 class="text-muted mb-1">Préstamos en Curso</h6>
                    <h3 class="fw-bold text-warning mb-0"><%= prestamosActivos %></h3>
                    <small class="text-muted"><%= totalPrestamos %> en histórico</small>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card shadow-sm text-center">
                <div class="card-body">
                    <h6 class="text-muted mb-1">Lectores Registrados</h6>
                    <h3 class="fw-bold text-success mb-0"><%= totalUsuarios %></h3>
                    <small class="text-muted">Cuentas habilitadas</small>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card shadow-sm text-center">
                <div class="card-body">
                    <h6 class="text-muted mb-1">Donaciones Pendientes</h6>
                    <h3 class="fw-bold text-danger mb-0"><%= donacionesPendientes %></h3>
                    <small class="text-muted"><a href="DonacionesServlet" class="text-decoration-none">Revisar solicitudes</a></small>
                </div>
            </div>
        </div>
    </div>

    <!-- DISTRIBUCIÓN POR CATEGORÍAS -->
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0">Distribución de Obras por Categoría</h5>
        </div>
        <div class="card-body">
            <div class="row g-3">
                <% if (librosPorCat != null && !librosPorCat.isEmpty()) {
                    for (Map.Entry<String, Integer> entry : librosPorCat.entrySet()) {
                        int porcentaje = totalLibros > 0 ? (entry.getValue() * 100 / totalLibros) : 0;
                %>
                    <div class="col-md-6">
                        <div class="d-flex justify-content-between small fw-bold mb-1">
                            <span><%= entry.getKey() %></span>
                            <span><%= entry.getValue() %> títulos (<%= porcentaje %>%)</span>
                        </div>
                        <div class="progress" style="height: 10px;">
                            <div class="progress-bar bg-primary" role="progressbar" style="width: <%= porcentaje %>%"></div>
                        </div>
                    </div>
                <%  }
                   } %>
            </div>
        </div>
    </div>

    <!-- ESTADO DE STOCK Y ALERTA DE REPOSICIÓN -->
    <div class="card shadow-sm mb-5">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0">Control de Existencias y Disponibilidad</h5>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Título de la Obra</th>
                            <th>Categoría</th>
                            <th>Stock Disponible</th>
                            <th>Estado de Existencias</th>
                            <th class="text-end">Acción</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (libros != null && !libros.isEmpty()) {
                            for (Libro l : libros) {
                                int stk = l.getStock();
                        %>
                            <tr>
                                <td>#<%= l.getIdLibro() %></td>
                                <td><strong><%= l.getTitulo() %></strong></td>
                                <td><span class="badge bg-light text-dark border"><%= l.getNombreCategoria() %></span></td>
                                <td><strong><%= stk %></strong></td>
                                <td>
                                    <% if (stk == 0) { %>
                                        <span class="badge bg-danger">Agotado</span>
                                    <% } else if (stk <= 2) { %>
                                        <span class="badge bg-warning text-dark">Stock Bajo</span>
                                    <% } else { %>
                                        <span class="badge bg-success">Disponible</span>
                                    <% } %>
                                </td>
                                <td class="text-end">
                                    <a href="LibroServlet?accion=ajustarStock&id=<%= l.getIdLibro() %>&delta=1" class="btn btn-sm btn-outline-primary">
                                        +1 Stock
                                    </a>
                                </td>
                            </tr>
                        <%  }
                           } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<footer class="bg-dark text-white text-center py-4 mt-5">
    <p class="mb-0">© 2026 BOOKHUB - Sistema de Gestión de Biblioteca Universitaria</p>
</footer>

<%@include file="a11y-panel.jsp"%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
