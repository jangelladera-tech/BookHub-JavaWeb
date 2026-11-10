<%@page import="java.util.List"%>
<%@page import="beans.Categoria"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    List<Categoria> categorias = (List<Categoria>) request.getAttribute("categorias");
    if (categorias == null) {
        dao.CategoriaDAO cdao = new dao.CategoriaDAO();
        categorias = cdao.listar();
    }

    Categoria categoriaEditar = (Categoria) request.getAttribute("categoriaEditar");
    boolean editando = categoriaEditar != null;
    int totalCategorias = categorias != null ? categorias.size() : 0;
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Categorías - BOOKHUB Admin</title>
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
                <a href="CategoriaServlet" class="admin-nav-link active">
                    <i class="bi bi-folder-fill"></i> Categorías
                </a>
                <a href="AutorServlet" class="admin-nav-link">
                    <i class="bi bi-person-lines-fill"></i> Autores
                </a>
                <a href="PrestamoServlet" class="admin-nav-link">
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
            <h2 class="fw-bold mb-1"><i class="bi bi-folder-fill text-primary"></i> Gestión de Categorías</h2>
            <p class="text-muted mb-0">Organización temática del acervo bibliográfico de BOOKHUB.</p>
        </div>
        <div>
            <span class="badge bg-primary p-2 fs-6"><i class="bi bi-tags"></i> Total: <%= totalCategorias %> Categorías</span>
        </div>
    </div>

    <!-- FORMULARIO -->
    <div class="card shadow-sm mb-4 border-0">
        <div class="card-header bg-white py-3 border-bottom">
            <h5 class="card-title mb-0 fw-semibold">
                <i class="bi <%= editando ? "bi-pencil-square text-warning" : "bi-plus-circle text-primary" %>"></i>
                <%= editando ? "Modificar Categoría #" + categoriaEditar.getIdCategoria() : "Agregar Nueva Categoría" %>
            </h5>
        </div>
        <div class="card-body p-4">
            <form action="CategoriaServlet" method="POST">
                <% if (editando) { %>
                    <input type="hidden" name="accion" value="actualizar">
                    <input type="hidden" name="idCategoria" value="<%= categoriaEditar.getIdCategoria() %>">
                <% } else { %>
                    <input type="hidden" name="accion" value="insertar">
                <% } %>

                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Nombre de la Categoría</label>
                        <input type="text" class="form-control" name="nombre" required placeholder="Ej: Inteligencia Artificial"
                               value="<%= editando ? categoriaEditar.getNombre() : "" %>">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Descripción o Alcance</label>
                        <input type="text" class="form-control" name="descripcion" placeholder="Breve descripción de las temáticas incluidas"
                               value="<%= editando ? categoriaEditar.getDescripcion() : "" %>">
                    </div>
                </div>

                <div class="mt-4 d-flex gap-2">
                    <button type="submit" class="btn btn-primary px-4">
                        <i class="bi bi-save"></i> <%= editando ? "Guardar Cambios" : "Guardar Categoría" %>
                    </button>
                    <% if (editando) { %>
                        <a href="CategoriaServlet" class="btn btn-secondary">Cancelar</a>
                    <% } %>
                </div>
            </form>
        </div>
    </div>

    <!-- TABLA -->
    <div class="card shadow-sm border-0">
        <div class="card-header bg-white py-3 d-flex flex-wrap justify-content-between align-items-center gap-2">
            <h5 class="card-title mb-0 fw-semibold"><i class="bi bi-collection"></i> Categorías Registradas</h5>
            <input type="text" id="filtroCategoriaInput" class="form-control form-control-sm" placeholder="Buscar categoría..." style="max-width: 240px;">
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0" id="tablaCategorias">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-3">ID</th>
                            <th>Nombre</th>
                            <th>Descripción</th>
                            <th class="text-end pe-3">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (categorias != null && !categorias.isEmpty()) {
                            for (Categoria cat : categorias) {
                        %>
                            <tr>
                                <td class="ps-3 fw-bold">#<%= cat.getIdCategoria() %></td>
                                <td>
                                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle fs-6">
                                        <i class="bi bi-bookmark-fill me-1"></i><%= cat.getNombre() %>
                                    </span>
                                </td>
                                <td class="text-muted"><%= cat.getDescripcion() != null ? cat.getDescripcion() : "Sin descripción" %></td>
                                <td class="text-end pe-3">
                                    <div class="btn-group btn-group-sm">
                                        <a href="CategoriaServlet?accion=editar&id=<%= cat.getIdCategoria() %>" class="btn btn-outline-primary" title="Editar">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <a href="CategoriaServlet?accion=eliminar&id=<%= cat.getIdCategoria() %>" class="btn btn-outline-danger" title="Eliminar"
                                           onclick="return confirm('¿Eliminar categoría <%= cat.getNombre() %>?');">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        <%  }
                           } else { %>
                            <tr>
                                <td colspan="4" class="text-center py-4 text-muted">No hay categorías registradas.</td>
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
    document.getElementById('filtroCategoriaInput')?.addEventListener('input', function(e) {
        const query = e.target.value.toLowerCase();
        const rows = document.querySelectorAll('#tablaCategorias tbody tr');
        rows.forEach(r => {
            const text = r.innerText.toLowerCase();
            r.style.display = text.includes(query) ? '' : 'none';
        });
    });
</script>
</body>
</html>
