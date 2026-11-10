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
    LibroDAO libroDAO = (LibroDAO) request.getAttribute("libroDAO");
    String exito = request.getParameter("exito");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sanciones y Mora - BOOKHUB ADMIN</title>

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
                <a href="ReportesServlet" class="sidebar-menu-item"><i class="bi bi-graph-up-arrow text-info fs-5"></i> Reportes & Métricas</a>
                <a href="SancionesServlet" class="sidebar-menu-item active"><i class="bi bi-exclamation-octagon-fill text-warning fs-5"></i> Sanciones & Mora</a>
            </div>
        </div>
        <div class="pt-3 border-top border-secondary border-opacity-25 text-center text-white-50 small">
            <span>BookHub v2.0 • Panel Administrativo</span>
        </div>
    </div>
</div>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm py-2" id="mainNavbar">
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
            <a href="dashboard.jsp" class="btn btn-outline-light btn-sm"><i class="bi bi-speedometer2"></i> Dashboard</a>
            <a href="LogoutServlet" class="btn btn-outline-danger btn-sm"><i class="bi bi-box-arrow-left"></i> Salir</a>
        </div>
    </div>
</nav>

<div class="container-fluid px-4 py-4">
    <div class="d-flex align-items-center justify-content-between mb-4 flex-wrap gap-2">
        <div>
            <h2 class="fw-bold mb-1 text-danger"><i class="bi bi-exclamation-octagon-fill"></i> Control de Sanciones, Mora y Retrasos</h2>
            <p class="text-secondary small mb-0">Monitorea los préstamos que han superado la fecha límite estipulada y gestiona las devoluciones y regularizaciones.</p>
        </div>
    </div>

    <% if ("regularizado".equals(exito)) { %>
        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i> Préstamo regularizado correctamente. El ejemplar ha sido devuelto y el stock actualizado.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <!-- TABLA DE MOROSIDAD -->
    <div class="card border-0 shadow-sm">
        <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
            <h5 class="fw-bold mb-0">Préstamos Pendientes de Devolución</h5>
            <span class="badge bg-danger"><%= prestamosMorosos.size() %> en seguimiento</span>
        </div>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light small">
                    <tr>
                        <th>ID Préstamo</th>
                        <th>Lector</th>
                        <th>Libro en Préstamo</th>
                        <th>Fecha de Préstamo</th>
                        <th>Fecha Límite Pactada</th>
                        <th>Estado de Entrega</th>
                        <th class="text-end">Acción de Regularización</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (prestamosMorosos.isEmpty()) { %>
                        <tr>
                            <td colspan="7" class="text-center text-success py-5">
                                <i class="bi bi-emoji-smile fs-2 d-block mb-2"></i>
                                ¡Excelente! No existen préstamos con atraso o pendientes de entrega.
                            </td>
                        </tr>
                    <% } else { %>
                        <% for (Prestamo p : prestamosMorosos) {
                            Usuario u = (usuarioDAO != null) ? usuarioDAO.obtenerPorId(p.getIdUsuario()) : null;
                            Libro l = (libroDAO != null) ? libroDAO.obtenerPorId(p.getIdLibro()) : null;
                        %>
                            <tr>
                                <td><strong>#<%= p.getIdPrestamo() %></strong></td>
                                <td>
                                    <div class="fw-bold"><%= u != null ? u.getNombre() : "Usuario #" + p.getIdUsuario() %></div>
                                    <small class="text-muted"><%= u != null ? u.getCorreo() : "" %></small>
                                </td>
                                <td>
                                    <div class="fw-semibold"><%= l != null ? l.getTitulo() : "Libro #" + p.getIdLibro() %></div>
                                    <small class="text-muted"><%= l != null ? l.getNombreAutor() : "" %></small>
                                </td>
                                <td class="small"><%= p.getFechaPrestamo() %></td>
                                <td class="small text-danger fw-bold"><%= p.getFechaDevolucion() %></td>
                                <td>
                                    <span class="badge bg-danger-subtle text-danger border border-danger">
                                        <i class="bi bi-clock-history"></i> Pendiente de Entrega
                                    </span>
                                </td>
                                <td class="text-end">
                                    <a href="SancionesServlet?accion=regularizar&id=<%= p.getIdPrestamo() %>"
                                       class="btn btn-success btn-sm d-inline-flex align-items-center gap-1"
                                       title="Marcar como devuelto y regularizar al lector"
                                       onclick="return confirm('¿Confirmar recepción del libro y regularizar estado del lector?');">
                                        <i class="bi bi-check2-circle"></i> Regularizar / Devolver
                                    </a>
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
