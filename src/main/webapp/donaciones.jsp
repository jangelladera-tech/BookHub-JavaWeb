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
        dao.DonacionDAO ddao = new dao.DonacionDAO();
        donaciones = ddao.listar();
    }

    String exito = request.getParameter("exito");
    int pendientes = 0;
    int aprobadas = 0;
    int rechazadas = 0;
    if (donaciones != null) {
        for (Donacion d : donaciones) {
            if ("PENDIENTE".equalsIgnoreCase(d.getEstadoRevision())) pendientes++;
            else if ("APROBADO".equalsIgnoreCase(d.getEstadoRevision())) aprobadas++;
            else if ("RECHAZADO".equalsIgnoreCase(d.getEstadoRevision())) rechazadas++;
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Donaciones - BOOKHUB</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
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
            <p class="sidebar-subtitle mb-2 px-2">Apartados Principales</p>
            <div class="d-flex flex-column gap-1 mb-3">
                <a href="index.jsp" class="sidebar-menu-item"><i class="bi bi-house-door-fill text-warning fs-5"></i> Inicio</a>
                <a href="CatalogoServlet" class="sidebar-menu-item"><i class="bi bi-journal-bookmark-fill text-info fs-5"></i> Catálogo</a>
                <a href="InnovacionServlet" class="sidebar-menu-item"><i class="bi bi-universal-access-circle text-success fs-5"></i> ODS 09: Accesibilidad</a>
                <a href="donar.jsp" class="sidebar-menu-item"><i class="bi bi-gift-fill text-danger fs-5"></i> Donar Libros</a>
            </div>

            <p class="sidebar-subtitle mb-2 px-2">Gestión del Sistema</p>
            <div class="d-flex flex-column gap-1 mb-3">
                <a href="dashboard.jsp" class="sidebar-menu-item"><i class="bi bi-speedometer2 text-warning fs-5"></i> Dashboard</a>
                <a href="LibroServlet" class="sidebar-menu-item"><i class="bi bi-book-half text-info fs-5"></i> Gestión de Libros</a>
                <a href="CategoriaServlet" class="sidebar-menu-item"><i class="bi bi-tags-fill text-warning fs-5"></i> Gestión de Categorías</a>
                <a href="AutorServlet" class="sidebar-menu-item"><i class="bi bi-pen-fill text-danger fs-5"></i> Gestión de Autores</a>
                <a href="PrestamoServlet" class="sidebar-menu-item"><i class="bi bi-card-checklist text-primary fs-5"></i> Gestión de Préstamos</a>
                <a href="UsuarioServlet" class="sidebar-menu-item"><i class="bi bi-people-fill text-success fs-5"></i> Gestión de Usuarios</a>
                <a href="DonacionesServlet" class="sidebar-menu-item active"><i class="bi bi-gift-fill text-danger fs-5"></i> Donaciones de Libros</a>
                <a href="ReportesServlet" class="sidebar-menu-item"><i class="bi bi-graph-up-arrow text-info fs-5"></i> Reportes y Métricas</a>
                <a href="SancionesServlet" class="sidebar-menu-item"><i class="bi bi-exclamation-octagon-fill text-warning fs-5"></i> Sanciones y Mora</a>
            </div>
        </div>
        <div class="pt-3 border-top border-secondary border-opacity-25 text-center text-white-50 small">
            <span>BookHub v2.0 • Panel Administrativo</span>
        </div>
    </div>
</div>

<!-- NAVBAR -->
<nav class="navbar navbar-dark bg-dark">
    <div class="container">
        <div class="d-flex align-items-center gap-2">
            <button class="btn btn-outline-light btn-sm" type="button" data-bs-toggle="offcanvas" data-bs-target="#sidebarBookHub">
                <i class="bi bi-list fs-5"></i>
            </button>
            <a class="navbar-brand fw-bold mb-0" href="dashboard.jsp">BOOKHUB</a>
        </div>
        <div class="d-flex gap-2">
            <a href="donar.jsp" target="_blank" class="btn btn-outline-info btn-sm">Ver Portal de Donación</a>
            <a href="dashboard.jsp" class="btn btn-outline-light btn-sm">Volver al Dashboard</a>
        </div>
    </div>
</nav>

<div class="container mt-5">
    <!-- TÍTULO -->
    <div class="mb-4">
        <h1>Gestión de Donaciones de Libros</h1>
        <p class="text-muted">Revisa las solicitudes de libros donados por la comunidad e incorpóralos al catálogo.</p>
    </div>

    <% if ("aprobado".equals(exito)) { %>
        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i> Donación aprobada con éxito. El libro se ha incorporado automáticamente al catálogo de libros.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } else if ("rechazado".equals(exito)) { %>
        <div class="alert alert-warning alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-info-circle-fill me-2"></i> Donación desestimada correctamente.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <!-- RESUMEN / TARJETAS SUPERIORES -->
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="card shadow-sm text-center">
                <div class="card-body">
                    <h6 class="text-muted mb-1">Pendientes de Revisión</h6>
                    <h3 class="fw-bold text-warning mb-0"><%= pendientes %></h3>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card shadow-sm text-center">
                <div class="card-body">
                    <h6 class="text-muted mb-1">Aprobadas / En Catálogo</h6>
                    <h3 class="fw-bold text-success mb-0"><%= aprobadas %></h3>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card shadow-sm text-center">
                <div class="card-body">
                    <h6 class="text-muted mb-1">Desestimadas</h6>
                    <h3 class="fw-bold text-secondary mb-0"><%= rechazadas %></h3>
                </div>
            </div>
        </div>
    </div>

    <!-- TABLA DE DONACIONES -->
    <div class="card shadow-sm mb-5">
        <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
            <h5 class="mb-0">Solicitudes de Donación Registradas</h5>
            <input type="text" id="filtroDonacion" class="form-control form-control-sm" placeholder="Buscar por título o donante..." style="max-width: 260px;">
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover align-middle" id="tablaDonaciones">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Libro y Autor</th>
                            <th>Donante</th>
                            <th>Estado Físico</th>
                            <th>Cantidad</th>
                            <th>Fecha</th>
                            <th>Revisión</th>
                            <th class="text-end">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (donaciones != null && !donaciones.isEmpty()) {
                            for (Donacion d : donaciones) {
                                boolean esPendiente = "PENDIENTE".equalsIgnoreCase(d.getEstadoRevision());
                                boolean esAprobado = "APROBADO".equalsIgnoreCase(d.getEstadoRevision());
                        %>
                            <tr>
                                <td><strong>#<%= d.getIdDonacion() %></strong></td>
                                <td>
                                    <strong><%= d.getTituloLibro() %></strong>
                                    <div class="text-muted small">Autor: <%= d.getAutor() != null ? d.getAutor() : "No especificado" %></div>
                                    <div class="text-muted small">Cat: <%= d.getCategoria() != null ? d.getCategoria() : "General" %></div>
                                </td>
                                <td>
                                    <div><%= d.getNombreDonante() %></div>
                                    <div class="text-muted small"><%= d.getCorreoDonante() %></div>
                                </td>
                                <td>
                                    <span class="badge bg-light text-dark border"><%= d.getEstadoConservacion() %></span>
                                </td>
                                <td><strong>1</strong></td>
                                <td class="small text-muted"><%= d.getFechaSolicitud() %></td>
                                <td>
                                    <% if (esPendiente) { %>
                                        <span class="badge bg-warning text-dark"><i class="bi bi-clock-history"></i> PENDIENTE</span>
                                    <% } else if (esAprobado) { %>
                                        <span class="badge bg-success"><i class="bi bi-check-circle"></i> APROBADO</span>
                                    <% } else { %>
                                        <span class="badge bg-secondary"><i class="bi bi-x-circle"></i> RECHAZADO</span>
                                    <% } %>
                                </td>
                                <td class="text-end">
                                    <% if (esPendiente) { %>
                                        <a href="DonacionesServlet?accion=aprobar&id=<%= d.getIdDonacion() %>"
                                           class="btn btn-sm btn-success me-1" title="Aprobar e incorporar al catálogo">
                                            <i class="bi bi-check2"></i> Aprobar
                                        </a>
                                        <a href="DonacionesServlet?accion=rechazar&id=<%= d.getIdDonacion() %>"
                                           class="btn btn-sm btn-outline-danger" title="Rechazar donación">
                                            <i class="bi bi-x"></i> Desestimar
                                        </a>
                                    <% } else { %>
                                        <span class="text-muted small">Procesado</span>
                                    <% } %>
                                </td>
                            </tr>
                        <%  }
                           } else { %>
                            <tr>
                                <td colspan="8" class="text-center py-4 text-muted">No se registran solicitudes de donación.</td>
                            </tr>
                        <% } %>
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
<script>
    document.getElementById('filtroDonacion')?.addEventListener('input', function(e) {
        const q = e.target.value.toLowerCase();
        document.querySelectorAll('#tablaDonaciones tbody tr').forEach(r => {
            r.style.display = r.innerText.toLowerCase().includes(q) ? '' : 'none';
        });
    });
</script>
</body>
</html>
