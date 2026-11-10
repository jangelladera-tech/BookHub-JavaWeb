<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="beans.Prestamo"%>
<%@page import="beans.Usuario"%>
<%@page import="beans.Libro"%>
<%@page import="dao.UsuarioDAO"%>
<%@page import="dao.LibroDAO"%>

<%
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
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Préstamos - BOOKHUB Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        .offcanvas-admin {
            width: 300px !important;
            background: #0f172a !important;
            color: #f8fafc;
        }
        .admin-nav-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 14px;
            border-radius: 8px;
            color: #cbd5e1;
            text-decoration: none;
            font-size: 0.92rem;
            transition: all 0.2s ease;
        }
        .admin-nav-link:hover {
            background: rgba(255, 255, 255, 0.08);
            color: #ffffff;
            transform: translateX(3px);
        }
        .admin-nav-link.active {
            background: #2563eb;
            color: #ffffff;
            font-weight: 600;
        }
    </style>
</head>
<body class="bg-light">

<!-- OFFCANVAS ADMIN -->
<div class="offcanvas offcanvas-start offcanvas-admin" tabindex="-1" id="adminSidebar">
    <div class="offcanvas-header border-bottom border-secondary border-opacity-25">
        <div class="d-flex align-items-center gap-2">
            <span class="fs-4">📚</span>
            <div>
                <h5 class="offcanvas-title fw-bold text-white mb-0">BOOKHUB ADMIN</h5>
                <small class="text-white-50" style="font-size: 0.72rem;">Panel de Control Integral</small>
            </div>
        </div>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas"></button>
    </div>
    <div class="offcanvas-body d-flex flex-column justify-content-between p-3">
        <div>
            <p class="text-uppercase text-secondary fw-bold small mb-2 px-2" style="font-size: 0.7rem; letter-spacing: 0.05em;">Apartados Principales</p>
            <div class="d-flex flex-column gap-1 mb-3">
                <a href="index.jsp" class="admin-nav-link">
                    <i class="bi bi-house-door-fill text-warning"></i> Inicio
                </a>
                <a href="CatalogoServlet" class="admin-nav-link">
                    <i class="bi bi-journal-bookmark-fill text-info"></i> Catálogo
                </a>
                <a href="InnovacionServlet" class="admin-nav-link">
                    <i class="bi bi-universal-access-circle text-success"></i> ODS 09: Accesibilidad
                </a>
                <a href="donar.jsp" class="admin-nav-link">
                    <i class="bi bi-gift-fill text-danger"></i> Donar Libros
                </a>
            </div>

            <p class="text-uppercase text-secondary fw-bold small mb-2 px-2" style="font-size: 0.7rem; letter-spacing: 0.05em;">Gestión del Sistema</p>
            <div class="d-flex flex-column gap-1 mb-3">
                <a href="dashboard.jsp" class="admin-nav-link">
                    <i class="bi bi-speedometer2"></i> Dashboard
                </a>
                <a href="LibroServlet" class="admin-nav-link">
                    <i class="bi bi-book-fill"></i> Libros (32 ejemplares)
                </a>
                <a href="CategoriaServlet" class="admin-nav-link">
                    <i class="bi bi-folder-fill"></i> Categorías
                </a>
                <a href="AutorServlet" class="admin-nav-link">
                    <i class="bi bi-person-lines-fill"></i> Autores
                </a>
                <a href="PrestamoServlet" class="admin-nav-link active">
                    <i class="bi bi-clock-history"></i> Préstamos
                </a>
                <a href="UsuarioServlet" class="admin-nav-link">
                    <i class="bi bi-people-fill"></i> Usuarios
                </a>
                <a href="DonacionesServlet" class="admin-nav-link">
                    <i class="bi bi-gift-fill text-danger"></i> Donaciones de Libros
                </a>
                <a href="ReportesServlet" class="admin-nav-link">
                    <i class="bi bi-bar-chart-fill text-info"></i> Reportes y Métricas
                </a>
                <a href="SancionesServlet" class="admin-nav-link">
                    <i class="bi bi-shield-exclamation text-warning"></i> Sanciones y Mora
                </a>
            </div>
        </div>
        <div class="pt-3 border-top border-secondary border-opacity-25">
            <a href="CatalogoServlet" class="admin-nav-link text-info mb-1">
                <i class="bi bi-eye"></i> Ver Catálogo Público
            </a>
            <a href="LoginServlet?accion=logout" class="admin-nav-link text-danger">
                <i class="bi bi-box-arrow-right"></i> Cerrar Sesión
            </a>
        </div>
    </div>
</div>

<!-- NAVBAR -->
<nav class="navbar navbar-dark bg-dark sticky-top shadow-sm py-2">
    <div class="container-fluid px-3 px-lg-4">
        <div class="d-flex align-items-center gap-3">
            <button class="btn btn-outline-light btn-sm" type="button" data-bs-toggle="offcanvas" data-bs-target="#adminSidebar">
                <i class="bi bi-list fs-5"></i>
            </button>
            <a class="navbar-brand fw-bold mb-0" href="dashboard.jsp">BOOKHUB <span class="badge bg-primary ms-1" style="font-size: 0.65rem;">ADMIN</span></a>
        </div>
        <div class="d-flex align-items-center gap-2">
            <a href="dashboard.jsp" class="btn btn-sm btn-outline-light">
                <i class="bi bi-arrow-left"></i> Dashboard
            </a>
        </div>
    </div>
</nav>

<div class="container py-4">

    <!-- CABECERA -->
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
        <div>
            <h2 class="fw-bold mb-1"><i class="bi bi-clock-history text-primary"></i> Gestión de Préstamos</h2>
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
