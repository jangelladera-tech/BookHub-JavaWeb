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
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reportes y Métricas - BOOKHUB ADMIN</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
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
            cursor: pointer;
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
            padding: 10px 14px;
            border-radius: 10px;
            color: #e2e8f0;
            text-decoration: none;
            font-weight: 500;
        }
        .sidebar-menu-item:hover {
            background: rgba(255, 255, 255, 0.1);
            color: #ffffff;
        }
        .sidebar-menu-item.active {
            background: #2563eb;
            color: #ffffff;
            font-weight: 600;
        }
        .sidebar-subtitle {
            font-size: 0.72rem;
            letter-spacing: 0.08em;
            color: #94a3b8;
            font-weight: 700;
            text-transform: uppercase;
        }
        .kpi-card {
            border-radius: 12px;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .kpi-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.08);
        }
        @media print {
            .no-print, nav, .offcanvas, .btn {
                display: none !important;
            }
        }
    </style>
</head>

<body class="bg-light">

<!-- OFFCANVAS ADMIN -->
<div class="offcanvas offcanvas-start offcanvas-bookhub shadow-lg" tabindex="-1" id="sidebarBookHub">
    <div class="offcanvas-header border-bottom border-secondary border-opacity-25 pb-3">
        <div class="d-flex align-items-center gap-2">
            <span class="fs-3">📚</span>
            <div>
                <h5 class="offcanvas-title fw-bold text-white mb-0">BookHub</h5>
                <small class="text-white-50" style="font-size: 0.72rem;">Panel de Administración</small>
            </div>
        </div>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas"></button>
    </div>

    <div class="offcanvas-body d-flex flex-column justify-content-between p-3">
        <div>
            <p class="sidebar-subtitle mb-2 px-2">Gestión del Sistema</p>
            <div class="d-flex flex-column gap-1 mb-3">
                <a href="dashboard.jsp" class="sidebar-menu-item"><i class="bi bi-speedometer2 text-warning fs-5"></i> Dashboard</a>
                <a href="LibrosServlet" class="sidebar-menu-item"><i class="bi bi-book-half text-info fs-5"></i> Libros</a>
                <a href="PrestamosServlet" class="sidebar-menu-item"><i class="bi bi-card-checklist text-primary fs-5"></i> Préstamos</a>
                <a href="UsuariosServlet" class="sidebar-menu-item"><i class="bi bi-people-fill text-success fs-5"></i> Usuarios</a>
                <a href="CategoriasServlet" class="sidebar-menu-item"><i class="bi bi-tags-fill text-warning fs-5"></i> Categorías</a>
                <a href="AutoresServlet" class="sidebar-menu-item"><i class="bi bi-pen-fill text-danger fs-5"></i> Autores</a>
            </div>

            <p class="sidebar-subtitle mb-2 px-2">Nuevos Módulos</p>
            <div class="d-flex flex-column gap-1 mb-3">
                <a href="DonacionesServlet" class="sidebar-menu-item"><i class="bi bi-gift-fill text-danger fs-5"></i> Donaciones de Libros</a>
                <a href="ReportesServlet" class="sidebar-menu-item active"><i class="bi bi-graph-up-arrow text-info fs-5"></i> Reportes & Métricas</a>
                <a href="SancionesServlet" class="sidebar-menu-item"><i class="bi bi-exclamation-octagon-fill text-warning fs-5"></i> Sanciones & Mora</a>
            </div>
        </div>
        <div class="pt-3 border-top border-secondary border-opacity-25 text-center text-white-50 small">
            <span>BookHub v2.0 • Panel Administrativo</span>
        </div>
    </div>
</div>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm py-2 no-print" id="mainNavbar">
    <div class="container-fluid px-3 px-lg-4">
        <div class="d-flex align-items-center gap-2">
            <button class="btn-sidebar-toggle" type="button" data-bs-toggle="offcanvas" data-bs-target="#sidebarBookHub">
                <i class="bi bi-list fs-3"></i>
            </button>
            <a class="navbar-brand fw-bold m-0" href="dashboard.jsp">
                <span>BookHub</span>
                <span class="badge bg-danger ms-1" style="font-size: 0.65rem;">ADMIN</span>
            </a>
        </div>

        <div class="d-flex align-items-center gap-2 ms-auto">
            <button class="btn btn-primary btn-sm d-flex align-items-center gap-1" onclick="window.print()">
                <i class="bi bi-printer"></i> Imprimir Reporte
            </button>
            <a href="LogoutServlet" class="btn btn-outline-danger btn-sm"><i class="bi bi-box-arrow-left"></i> Salir</a>
        </div>
    </div>
</nav>

<div class="container-fluid px-4 py-4">
    <div class="d-flex align-items-center justify-content-between mb-4 flex-wrap gap-2">
        <div>
            <h2 class="fw-bold mb-1"><i class="bi bi-graph-up-arrow text-primary"></i> Reportes y Métricas Ejecutivas</h2>
            <p class="text-secondary small mb-0">Monitoreo de inventario bibliográfico, tasa de préstamos, rotación de ejemplares y áreas de conocimiento.</p>
        </div>
    </div>

    <!-- TARJETAS KPI -->
    <div class="row g-3 mb-4">
        <div class="col-sm-6 col-lg-3">
            <div class="card border-0 shadow-sm p-3 kpi-card border-start border-primary border-4 bg-white">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <div class="text-secondary small fw-bold">TÍTULOS CATALOGADOS</div>
                        <h2 class="fw-bold mb-0 text-primary"><%= totalLibros %></h2>
                        <small class="text-muted"><%= totalEjemplares %> ejemplares en inventario</small>
                    </div>
                    <i class="bi bi-bookshelf fs-1 text-primary opacity-50"></i>
                </div>
            </div>
        </div>

        <div class="col-sm-6 col-lg-3">
            <div class="card border-0 shadow-sm p-3 kpi-card border-start border-success border-4 bg-white">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <div class="text-secondary small fw-bold">PRÉSTAMOS ACTIVOS</div>
                        <h2 class="fw-bold mb-0 text-success"><%= prestamosActivos %></h2>
                        <small class="text-muted"><%= prestamosDevueltos %> devueltos a tiempo</small>
                    </div>
                    <i class="bi bi-card-checklist fs-1 text-success opacity-50"></i>
                </div>
            </div>
        </div>

        <div class="col-sm-6 col-lg-3">
            <div class="card border-0 shadow-sm p-3 kpi-card border-start border-warning border-4 bg-white">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <div class="text-secondary small fw-bold">STOCK BAJO / AGOTADO</div>
                        <h2 class="fw-bold mb-0 text-warning"><%= librosBajoStock + librosAgotados %></h2>
                        <small class="text-danger fw-semibold"><%= librosAgotados %> totalmente agotados</small>
                    </div>
                    <i class="bi bi-exclamation-triangle fs-1 text-warning opacity-50"></i>
                </div>
            </div>
        </div>

        <div class="col-sm-6 col-lg-3">
            <div class="card border-0 shadow-sm p-3 kpi-card border-start border-info border-4 bg-white">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <div class="text-secondary small fw-bold">LECTORES & DONACIONES</div>
                        <h2 class="fw-bold mb-0 text-info"><%= totalUsuarios %></h2>
                        <small class="text-muted"><%= donacionesPendientes %> donaciones por revisar</small>
                    </div>
                    <i class="bi bi-people fs-1 text-info opacity-50"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- DISTRIBUCIÓN POR CATEGORÍAS -->
    <div class="row g-4 mb-4">
        <div class="col-lg-5">
            <div class="card border-0 shadow-sm h-100 p-4 bg-white">
                <h5 class="fw-bold mb-3 d-flex align-items-center gap-2">
                    <i class="bi bi-pie-chart-fill text-primary"></i> Acervo por Categoría
                </h5>
                <div class="d-flex flex-column gap-3">
                    <% if (librosPorCat != null) { %>
                        <% for (Map.Entry<String, Integer> entry : librosPorCat.entrySet()) {
                            int pct = (int) Math.round((entry.getValue() * 100.0) / totalLibros);
                        %>
                            <div>
                                <div class="d-flex justify-content-between small fw-semibold mb-1">
                                    <span><%= entry.getKey() %></span>
                                    <span><%= entry.getValue() %> libros (<%= pct %>%)</span>
                                </div>
                                <div class="progress" style="height: 8px;">
                                    <div class="progress-bar bg-primary" style="width: <%= pct %>%;"></div>
                                </div>
                            </div>
                        <% } %>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- ALERTAS DE REPOSICIÓN DE STOCK -->
        <div class="col-lg-7">
            <div class="card border-0 shadow-sm h-100 p-4 bg-white">
                <h5 class="fw-bold mb-3 d-flex align-items-center gap-2 text-warning">
                    <i class="bi bi-bell-fill"></i> Alertas de Inventario Crítico
                </h5>
                <div class="table-responsive">
                    <table class="table table-sm align-middle mb-0">
                        <thead class="table-light small">
                            <tr>
                                <th>Libro</th>
                                <th>Categoría</th>
                                <th>Stock Actual</th>
                                <th>Estado</th>
                                <th class="text-end">Acción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% int alertas = 0;
                               for (Libro l : libros) {
                                   if (l.getStock() <= 2) {
                                       alertas++;
                            %>
                                <tr>
                                    <td>
                                        <div class="fw-semibold small"><%= l.getTitulo() %></div>
                                        <small class="text-muted"><%= l.getNombreAutor() %></small>
                                    </td>
                                    <td class="small text-secondary"><%= l.getNombreCategoria() %></td>
                                    <td><strong class="<%= l.getStock() == 0 ? "text-danger" : "text-warning" %>"><%= l.getStock() %> ejemp.</strong></td>
                                    <td>
                                        <% if (l.getStock() == 0) { %>
                                            <span class="badge bg-danger">Agotado</span>
                                        <% } else { %>
                                            <span class="badge bg-warning text-dark">Stock Crítico</span>
                                        <% } %>
                                    </td>
                                    <td class="text-end">
                                        <a href="LibroServlet?accion=ajustarStock&id=<%= l.getIdLibro() %>&delta=5" class="btn btn-outline-success btn-sm py-0" title="Reabastecer +5">+5 stock</a>
                                    </td>
                                </tr>
                            <%     }
                               }
                               if (alertas == 0) {
                            %>
                                <tr>
                                    <td colspan="5" class="text-center text-success py-3">Todos los libros cuentan con stock suficiente.</td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
