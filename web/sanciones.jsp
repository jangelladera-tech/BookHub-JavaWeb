<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="beans.Prestamo"%>
<%@page import="beans.Libro"%>
<%@page import="beans.Usuario"%>
<%@page import="dao.LibroDAO"%>
<%@page import="dao.UsuarioDAO"%>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null || !"ADMIN".equals(usuario.getRol())) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Prestamo> prestamosMorosos = (List<Prestamo>) request.getAttribute("prestamosMorosos");
    if (prestamosMorosos == null) {
        response.sendRedirect("SancionesServlet");
        return;
    }

    UsuarioDAO usuarioDAO = (UsuarioDAO) request.getAttribute("usuarioDAO");
    if (usuarioDAO == null) usuarioDAO = new UsuarioDAO();
    LibroDAO libroDAO = (LibroDAO) request.getAttribute("libroDAO");
    if (libroDAO == null) libroDAO = new LibroDAO();

    String exito = request.getParameter("exito");
    int totalMorosos = prestamosMorosos.size();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sanciones y Mora - BOOKHUB</title>
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
                <a href="DonacionesServlet" class="sidebar-menu-item"><i class="bi bi-gift-fill text-danger fs-5"></i> Donaciones de Libros</a>
                <a href="ReportesServlet" class="sidebar-menu-item"><i class="bi bi-graph-up-arrow text-info fs-5"></i> Reportes y Métricas</a>
                <a href="SancionesServlet" class="sidebar-menu-item active"><i class="bi bi-exclamation-octagon-fill text-warning fs-5"></i> Sanciones y Mora</a>
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
            <a href="PrestamoServlet" class="btn btn-outline-info btn-sm">Ver Todos los Préstamos</a>
            <a href="dashboard.jsp" class="btn btn-outline-light btn-sm">Volver al Dashboard</a>
        </div>
    </div>
</nav>

<div class="container mt-5">
    <!-- TÍTULO -->
    <div class="mb-4">
        <h1>Gestión de Sanciones y Préstamos en Mora</h1>
        <p class="text-muted">Monitorea los préstamos que han superado la fecha límite estipulada y regulariza devoluciones atrasadas.</p>
    </div>

    <% if ("regularizado".equals(exito)) { %>
        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i> Préstamo regularizado correctamente. Se ha registrado la devolución y restaurado el stock del libro.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <!-- RESUMEN SUPERIOR -->
    <div class="row g-3 mb-4">
        <div class="col-md-6">
            <div class="card shadow-sm text-center">
                <div class="card-body">
                    <h6 class="text-muted mb-1">Préstamos con Fecha Vencida</h6>
                    <h3 class="fw-bold text-danger mb-0"><%= totalMorosos %></h3>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card shadow-sm text-center">
                <div class="card-body">
                    <h6 class="text-muted mb-1">Cálculo de Penalidad Estándar</h6>
                    <h3 class="fw-bold text-warning mb-0">S/. 1.00 <span class="fs-6 fw-normal text-muted">/ día de mora</span></h3>
                </div>
            </div>
        </div>
    </div>

    <!-- TABLA DE MOROSIDAD -->
    <div class="card shadow-sm mb-5">
        <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
            <h5 class="mb-0">Préstamos Vencidos Pendientes de Regularización</h5>
            <input type="text" id="filtroMora" class="form-control form-control-sm" placeholder="Buscar por lector o libro..." style="max-width: 260px;">
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover align-middle" id="tablaMora">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Lector con Retraso</th>
                            <th>Libro Prestado</th>
                            <th>Fecha Límite</th>
                            <th>Días de Retraso</th>
                            <th>Mora Estimada</th>
                            <th class="text-end">Acción Rápida</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (prestamosMorosos != null && !prestamosMorosos.isEmpty()) {
                            for (Prestamo p : prestamosMorosos) {
                                Usuario u = usuarioDAO.obtenerPorId(p.getIdUsuario());
                                Libro l = libroDAO.obtenerPorId(p.getIdLibro());
                        %>
                            <tr>
                                <td><strong>#<%= p.getIdPrestamo() %></strong></td>
                                <td>
                                    <strong><%= u != null ? u.getNombre() : "Usuario #" + p.getIdUsuario() %></strong>
                                    <div class="text-muted small"><%= u != null ? u.getCorreo() : "" %></div>
                                </td>
                                <td>
                                    <strong><%= l != null ? l.getTitulo() : "Libro #" + p.getIdLibro() %></strong>
                                    <div class="text-muted small"><%= l != null ? l.getNombreCategoria() : "" %></div>
                                </td>
                                <td>
                                    <span class="badge bg-light text-dark border">
                                        <i class="bi bi-calendar-x text-danger"></i> <%= p.getFechaDevolucion() %>
                                    </span>
                                </td>
                                <td>
                                    <span class="badge bg-danger">7 días</span>
                                </td>
                                <td>
                                    <strong>S/. 7.00</strong>
                                </td>
                                <td class="text-end">
                                    <a href="SancionesServlet?accion=regularizar&id=<%= p.getIdPrestamo() %>"
                                       class="btn btn-sm btn-success"
                                       title="Confirmar devolución y regularizar mora">
                                        <i class="bi bi-check2-circle"></i> Regularizar
                                    </a>
                                </td>
                            </tr>
                        <%  }
                           } else { %>
                            <tr>
                                <td colspan="7" class="text-center py-4 text-muted">
                                    <i class="bi bi-check-circle-fill text-success fs-3 d-block mb-2"></i>
                                    ¡Excelente! No hay préstamos con mora ni retraso en este momento.
                                </td>
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
    document.getElementById('filtroMora')?.addEventListener('input', function(e) {
        const q = e.target.value.toLowerCase();
        document.querySelectorAll('#tablaMora tbody tr').forEach(r => {
            r.style.display = r.innerText.toLowerCase().includes(q) ? '' : 'none';
        });
    });
</script>
</body>
</html>
