<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="beans.Donacion"%>
<%@page import="beans.Usuario"%>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null || !"ADMIN".equals(usuario.getRol())) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Donacion> donaciones = (List<Donacion>) request.getAttribute("donaciones");
    if (donaciones == null) {
        response.sendRedirect("DonacionesServlet");
        return;
    }

    String exito = request.getParameter("exito");
    int pendientes = 0;
    int aprobadas = 0;
    int rechazadas = 0;
    for (Donacion d : donaciones) {
        if ("PENDIENTE".equalsIgnoreCase(d.getEstadoRevision())) pendientes++;
        else if ("APROBADO".equalsIgnoreCase(d.getEstadoRevision())) aprobadas++;
        else if ("RECHAZADO".equalsIgnoreCase(d.getEstadoRevision())) rechazadas++;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Donaciones - BOOKHUB ADMIN</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        .navbar-scroll-fade {
            transition: opacity 0.35s ease, transform 0.35s ease;
        }
        .navbar-scroll-fade.navbar-hidden {
            opacity: 0 !important;
            pointer-events: none !important;
            transform: translateY(-10px);
        }
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
                <a href="DonacionesServlet" class="sidebar-menu-item active"><i class="bi bi-gift-fill text-danger fs-5"></i> Donaciones de Libros</a>
                <a href="ReportesServlet" class="sidebar-menu-item"><i class="bi bi-graph-up-arrow text-info fs-5"></i> Reportes & Métricas</a>
                <a href="SancionesServlet" class="sidebar-menu-item"><i class="bi bi-exclamation-octagon-fill text-warning fs-5"></i> Sanciones & Mora</a>
            </div>
        </div>
        <div class="pt-3 border-top border-secondary border-opacity-25 text-center text-white-50 small">
            <span>BookHub v2.0 • Panel Administrativo</span>
        </div>
    </div>
</div>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm py-2 navbar-scroll-fade" id="mainNavbar">
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
            <a href="dashboard.jsp" class="btn btn-outline-light btn-sm"><i class="bi bi-speedometer2"></i> Panel</a>
            <a href="LogoutServlet" class="btn btn-outline-danger btn-sm"><i class="bi bi-box-arrow-left"></i> Salir</a>
        </div>
    </div>
</nav>

<div class="container-fluid px-4 py-4">
    <div class="d-flex align-items-center justify-content-between mb-4 flex-wrap gap-2">
        <div>
            <h2 class="fw-bold mb-1"><i class="bi bi-gift-fill text-danger"></i> Centro de Donaciones de Libros</h2>
            <p class="text-secondary small mb-0">Revisa, aprueba e incorpora automáticamente ejemplares donados por la comunidad universitaria.</p>
        </div>
        <a href="donar.jsp" target="_blank" class="btn btn-outline-primary btn-sm d-flex align-items-center gap-1">
            <i class="bi bi-box-arrow-up-right"></i> Ver Portal Público de Donaciones
        </a>
    </div>

    <% if ("aprobado".equals(exito)) { %>
        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i> Donación aprobada con éxito. El libro se ha incorporado automáticamente al catálogo de libros con stock = 1.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } else if ("rechazado".equals(exito)) { %>
        <div class="alert alert-secondary alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-x-circle-fill me-2"></i> La donación ha sido marcada como rechazada.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <!-- KPI CARDS -->
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="card border-0 shadow-sm p-3 border-start border-warning border-4">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <div class="text-secondary small fw-semibold">PENDIENTES DE REVISIÓN</div>
                        <h3 class="fw-bold mb-0 text-warning"><%= pendientes %></h3>
                    </div>
                    <i class="bi bi-clock-history fs-1 text-warning opacity-50"></i>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-0 shadow-sm p-3 border-start border-success border-4">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <div class="text-secondary small fw-semibold">DONACIONES INCORPORADAS</div>
                        <h3 class="fw-bold mb-0 text-success"><%= aprobadas %></h3>
                    </div>
                    <i class="bi bi-journal-check fs-1 text-success opacity-50"></i>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-0 shadow-sm p-3 border-start border-danger border-4">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <div class="text-secondary small fw-semibold">TOTAL REGISTRADAS</div>
                        <h3 class="fw-bold mb-0 text-dark"><%= donaciones.size() %></h3>
                    </div>
                    <i class="bi bi-archive fs-1 text-secondary opacity-50"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- TABLA DE DONACIONES -->
    <div class="card border-0 shadow-sm">
        <div class="card-header bg-white py-3 border-bottom">
            <h5 class="fw-bold mb-0">Solicitudes de Donación Recibidas</h5>
        </div>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light small">
                    <tr>
                        <th>ID</th>
                        <th>Obra y Autor</th>
                        <th>Categoría</th>
                        <th>Estado Físico</th>
                        <th>Donante y Contacto</th>
                        <th>Fecha</th>
                        <th>Estado</th>
                        <th class="text-end">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (donaciones.isEmpty()) { %>
                        <tr>
                            <td colspan="8" class="text-center py-5 text-secondary">No hay solicitudes de donaciones registradas.</td>
                        </tr>
                    <% } else { %>
                        <% for (Donacion d : donaciones) { %>
                            <tr>
                                <td><strong>#<%= d.getIdDonacion() %></strong></td>
                                <td>
                                    <div class="fw-bold"><%= d.getTituloLibro() %></div>
                                    <small class="text-muted"><%= d.getAutor() %> · Año <%= d.getAnio() %></small>
                                </td>
                                <td><span class="badge bg-light text-dark border"><%= d.getCategoria() %></span></td>
                                <td>
                                    <% if ("EXCELENTE".equals(d.getEstadoConservacion())) { %>
                                        <span class="badge bg-success-subtle text-success border border-success">Excelente</span>
                                    <% } else if ("BUENO".equals(d.getEstadoConservacion())) { %>
                                        <span class="badge bg-primary-subtle text-primary border border-primary">Bueno</span>
                                    <% } else { %>
                                        <span class="badge bg-secondary-subtle text-secondary border">Regular</span>
                                    <% } %>
                                </td>
                                <td>
                                    <div class="small fw-semibold"><%= d.getNombreDonante() %></div>
                                    <small class="text-muted"><%= d.getCorreoDonante() %></small>
                                </td>
                                <td class="small text-secondary"><%= d.getFechaSolicitud() %></td>
                                <td>
                                    <% if ("PENDIENTE".equals(d.getEstadoRevision())) { %>
                                        <span class="badge bg-warning text-dark"><i class="bi bi-hourglass-split"></i> Pendiente</span>
                                    <% } else if ("APROBADO".equals(d.getEstadoRevision())) { %>
                                        <span class="badge bg-success"><i class="bi bi-check-lg"></i> Incorporado</span>
                                    <% } else { %>
                                        <span class="badge bg-danger"><i class="bi bi-x-lg"></i> Rechazado</span>
                                    <% } %>
                                </td>
                                <td class="text-end">
                                    <% if ("PENDIENTE".equals(d.getEstadoRevision())) { %>
                                        <a href="DonacionServlet?accion=aprobar&id=<%= d.getIdDonacion() %>"
                                           class="btn btn-success btn-sm me-1"
                                           title="Aprobar e incorporar automáticamente al catálogo de libros"
                                           onclick="return confirm('¿Aprobar e incorporar esta donación directamente al catálogo de libros?');">
                                            <i class="bi bi-check-circle"></i> Aprobar
                                        </a>
                                        <a href="DonacionServlet?accion=rechazar&id=<%= d.getIdDonacion() %>"
                                           class="btn btn-outline-danger btn-sm"
                                           onclick="return confirm('¿Rechazar esta solicitud de donación?');">
                                            <i class="bi bi-x-circle"></i>
                                        </a>
                                    <% } else { %>
                                        <span class="text-muted small">Atendido</span>
                                    <% } %>
                                </td>
                            </tr>
                        <% } %>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
