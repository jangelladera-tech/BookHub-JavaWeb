<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="modelo.beans.Prestamo"%>
<%@page import="modelo.beans.Usuario"%>
<%@page import="modelo.beans.Libro"%>
<%@page import="modelo.dao.UsuarioDAO"%>
<%@page import="modelo.dao.LibroDAO"%>

<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
    List<Prestamo> prestamos = (List<Prestamo>) request.getAttribute("prestamos");
    if (prestamos == null) {
        dao.PrestamoDAO pdao = new dao.PrestamoDAO();
        prestamos = pdao.listar();
    }

    Prestamo prestamoEditar = (Prestamo) request.getAttribute("prestamoEditar");
    boolean editar = prestamoEditar != null;

    UsuarioDAO usuarioDAO = new UsuarioDAO();
    LibroDAO libroDAO = new LibroDAO();

    List<Usuario> usuarios = usuarioDAO.listar();
    List<Libro> libros = libroDAO.listar();

    int totalPrestamos = prestamos != null ? prestamos.size() : 0;
    int prestadosCount = 0;
    int devueltosCount = 0;
    if (prestamos != null) {
        for (Prestamo p : prestamos) {
            if ("PRESTADO".equalsIgnoreCase(p.getEstado())) prestadosCount++;
            else devueltosCount++;
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <!-- Favicon / Logo oficial de la ventana y pestañas -->
    <link rel="icon" type="image/x-icon" href="favicon.ico">
    <link rel="shortcut icon" type="image/x-icon" href="favicon.ico">
    <link rel="icon" type="image/png" sizes="32x32" href="favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="favicon-16x16.png">
    <link rel="icon" type="image/svg+xml" href="img/logo.svg">
    <link rel="apple-touch-icon" href="favicon-180x180.png">

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Préstamos - BOOKHUB Admin</title>
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
            <% if (usuarioSesion != null) { %>
            <div class="p-3 mb-3 rounded-3 bg-danger bg-opacity-10 border border-danger border-opacity-25">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-shield-lock-fill fs-3 text-danger"></i>
                    <div class="overflow-hidden">
                        <div class="fw-semibold text-white text-truncate"><%= usuarioSesion.getNombre() %></div>
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
                <a href="PrestamoServlet" class="sidebar-menu-item active">
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
                <a href="ReportesServlet" class="sidebar-menu-item">
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
            <a href="CatalogoServlet" class="btn btn-outline-info btn-sm d-flex align-items-center gap-1">
                <i class="bi bi-journal-bookmark-fill"></i> <span class="d-none d-sm-inline">Catálogo</span>
            </a>
            <% if (usuarioSesion != null) { %>
                <span class="text-white small d-none d-md-inline ms-1">
                    Admin: <strong><%= usuarioSesion.getNombre() %></strong>
                </span>
            <% } %>
            <a href="LogoutServlet" class="btn btn-outline-danger btn-sm d-flex align-items-center gap-1">
                <i class="bi bi-box-arrow-left"></i> <span>Salir</span>
            </a>
        </div>
    </div>
</nav>

<div class="container py-4">

    <!-- CABECERA -->
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
        <div>
            <h2 class="fw-bold mb-1"><i class="bi bi-card-checklist text-primary me-2"></i>Gestión de Préstamos</h2>
            <p class="text-muted mb-0">Administra registros de préstamos, devoluciones en 1 clic y prórrogas.</p>
        </div>
        <div class="d-flex gap-2">
            <span class="badge bg-primary p-2 fs-6"><i class="bi bi-journal-check"></i> Total: <%= totalPrestamos %></span>
            <span class="badge bg-warning text-dark p-2 fs-6"><i class="bi bi-hourglass-split"></i> Prestados: <%= prestadosCount %></span>
            <span class="badge bg-success p-2 fs-6"><i class="bi bi-check-circle"></i> Devueltos: <%= devueltosCount %></span>
        </div>
    </div>

    <!-- FORMULARIO DE REGISTRO / EDICIÓN -->
    <div class="card shadow-sm mb-4 border-0">
        <div class="card-header bg-white py-3 border-bottom">
            <h5 class="card-title mb-0 fw-semibold">
                <i class="bi <%= editar ? "bi-pencil-square text-warning" : "bi-plus-circle text-primary" %>"></i>
                <%= editar ? "Modificar Préstamo #" + prestamoEditar.getIdPrestamo() : "Registrar Nuevo Préstamo" %>
            </h5>
        </div>
        <div class="card-body p-4">
            <form action="PrestamoServlet" method="POST">
                <% if (editar) { %>
                    <input type="hidden" name="accion" value="actualizar">
                    <input type="hidden" name="idPrestamo" value="<%= prestamoEditar.getIdPrestamo() %>">
                <% } else { %>
                    <input type="hidden" name="accion" value="insertar">
                <% } %>

                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Usuario Lector</label>
                        <select class="form-select" name="idUsuario" required>
                            <option value="">-- Seleccionar usuario --</option>
                            <% if (usuarios != null) {
                                for (Usuario u : usuarios) {
                                    boolean sel = editar && prestamoEditar.getIdUsuario() == u.getIdUsuario();
                            %>
                                <option value="<%= u.getIdUsuario() %>" <%= sel ? "selected" : "" %>>
                                    #<%= u.getIdUsuario() %> - <%= u.getNombre() %> (<%= u.getCorreo() %>)
                                </option>
                            <%  }
                               } %>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Libro a Prestar</label>
                        <select class="form-select" name="idLibro" required>
                            <option value="">-- Seleccionar ejemplar --</option>
                            <% if (libros != null) {
                                for (Libro l : libros) {
                                    boolean sel = editar && prestamoEditar.getIdLibro() == l.getIdLibro();
                            %>
                                <option value="<%= l.getIdLibro() %>" <%= sel ? "selected" : "" %>>
                                    #<%= l.getIdLibro() %> - <%= l.getTitulo() %> (Stock disp: <%= l.getStock() %>)
                                </option>
                            <%  }
                               } %>
                        </select>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Fecha de Préstamo</label>
                        <input type="text" class="form-control" name="fechaPrestamo" placeholder="DD/MM/AAAA" required
                               value="<%= editar ? prestamoEditar.getFechaPrestamo() : "10/11/2026" %>">
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Fecha Límite Devolución</label>
                        <input type="text" class="form-control" name="fechaDevolucion" placeholder="DD/MM/AAAA" required
                               value="<%= editar ? prestamoEditar.getFechaDevolucion() : "17/11/2026" %>">
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Estado Actual</label>
                        <select class="form-select" name="estado" required>
                            <option value="PRESTADO" <%= editar && "PRESTADO".equalsIgnoreCase(prestamoEditar.getEstado()) ? "selected" : "" %>>
                                PRESTADO
                            </option>
                            <option value="DEVUELTO" <%= editar && "DEVUELTO".equalsIgnoreCase(prestamoEditar.getEstado()) ? "selected" : "" %>>
                                DEVUELTO
                            </option>
                        </select>
                    </div>
                </div>

                <div class="mt-4 d-flex gap-2">
                    <button type="submit" class="btn btn-primary px-4">
                        <i class="bi bi-save"></i> <%= editar ? "Guardar Cambios" : "Confirmar Préstamo" %>
                    </button>
                    <% if (editar) { %>
                        <a href="PrestamoServlet" class="btn btn-secondary">Cancelar</a>
                    <% } %>
                </div>
            </form>
        </div>
    </div>

    <!-- TABLA DE PRÉSTAMOS CON FILTROS -->
    <div class="card shadow-sm border-0">
        <div class="card-header bg-white py-3 d-flex flex-wrap justify-content-between align-items-center gap-2">
            <h5 class="card-title mb-0 fw-semibold"><i class="bi bi-list-check"></i> Historial de Préstamos</h5>
            <div class="d-flex gap-2">
                <input type="text" id="filtroPrestamoInput" class="form-control form-control-sm" placeholder="Buscar usuario o libro..." style="max-width: 260px;">
            </div>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0" id="tablaPrestamos">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-3">ID</th>
                            <th>Usuario Lector</th>
                            <th>Libro</th>
                            <th>Fecha Préstamo</th>
                            <th>Fecha Devolución</th>
                            <th>Estado</th>
                            <th class="text-end pe-3">Acciones Rápidas</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (prestamos != null && !prestamos.isEmpty()) {
                            for (Prestamo prestamo : prestamos) {
                                Usuario u = usuarioDAO.obtenerPorId(prestamo.getIdUsuario());
                                Libro l = libroDAO.obtenerPorId(prestamo.getIdLibro());
                                boolean esPrestado = "PRESTADO".equalsIgnoreCase(prestamo.getEstado());
                        %>
                            <tr>
                                <td class="ps-3 fw-bold">#<%= prestamo.getIdPrestamo() %></td>
                                <td>
                                    <div class="fw-semibold"><%= u != null ? u.getNombre() : "Usuario #" + prestamo.getIdUsuario() %></div>
                                    <small class="text-muted"><%= u != null ? u.getCorreo() : "" %></small>
                                </td>
                                <td>
                                    <div class="fw-semibold"><%= l != null ? l.getTitulo() : "Libro #" + prestamo.getIdLibro() %></div>
                                    <small class="text-muted"><%= l != null ? l.getCategoria() : "" %></small>
                                </td>
                                <td><i class="bi bi-calendar-event text-secondary"></i> <%= prestamo.getFechaPrestamo() %></td>
                                <td><i class="bi bi-calendar-check text-secondary"></i> <%= prestamo.getFechaDevolucion() %></td>
                                <td>
                                    <% if (esPrestado) { %>
                                        <span class="badge bg-warning text-dark"><i class="bi bi-hourglass-split"></i> PRESTADO</span>
                                    <% } else { %>
                                        <span class="badge bg-success"><i class="bi bi-check-circle"></i> DEVUELTO</span>
                                    <% } %>
                                </td>
                                <td class="text-end pe-3">
                                    <div class="btn-group btn-group-sm">
                                        <% if (esPrestado) { %>
                                            <a href="PrestamoServlet?accion=devolver&id=<%= prestamo.getIdPrestamo() %>"
                                               class="btn btn-outline-success" title="Registrar devolución inmediata">
                                                <i class="bi bi-check2-circle"></i> Devolver
                                            </a>
                                            <a href="PrestamoServlet?accion=renovar&id=<%= prestamo.getIdPrestamo() %>"
                                               class="btn btn-outline-info" title="Renovar plazo +7 días">
                                                <i class="bi bi-arrow-repeat"></i> +7 días
                                            </a>
                                        <% } %>
                                        <a href="PrestamoServlet?accion=editar&id=<%= prestamo.getIdPrestamo() %>"
                                           class="btn btn-outline-primary" title="Editar">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <a href="PrestamoServlet?accion=eliminar&id=<%= prestamo.getIdPrestamo() %>"
                                           class="btn btn-outline-danger" title="Eliminar"
                                           onclick="return confirm('¿Eliminar registro de préstamo #<%= prestamo.getIdPrestamo() %>?');">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        <%  }
                           } else { %>
                            <tr>
                                <td colspan="7" class="text-center py-4 text-muted">
                                    <i class="bi bi-inbox fs-3 d-block mb-2"></i>
                                    No se encontraron préstamos registrados.
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
    <p class="mb-0 small text-white-50">© 2026 BOOKHUB - Sistema de Gestión de Biblioteca Universitaria</p>
</footer>

<%@include file="a11y-panel.jsp"%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('filtroPrestamoInput')?.addEventListener('input', function(e) {
        const query = e.target.value.toLowerCase();
        const rows = document.querySelectorAll('#tablaPrestamos tbody tr');
        rows.forEach(r => {
            const text = r.innerText.toLowerCase();
            r.style.display = text.includes(query) ? '' : 'none';
        });
    });
</script>
</body>
</html>
