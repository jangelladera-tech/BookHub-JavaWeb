<%@page import="java.util.List"%>
<%@page import="beans.Libro"%>
<%@page import="beans.Autor"%>
<%@page import="beans.Categoria"%>
<%@page import="beans.Usuario"%>
<%@page import="dao.AutorDAO"%>
<%@page import="dao.CategoriaDAO"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
    AutorDAO autorDAO = new AutorDAO();
    CategoriaDAO categoriaDAO = new CategoriaDAO();
    List<Autor> listaAutores = autorDAO.listar();
    List<Categoria> listaCategorias = categoriaDAO.listar();
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <title>Gestión de Libros - BOOKHUB</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
              rel="stylesheet">
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
            .portada-mini {
                width: 48px;
                height: 68px;
                object-fit: cover;
                border-radius: 4px;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.18);
            }
            .preview-portada-box {
                width: 90px;
                height: 126px;
                border-radius: 6px;
                border: 1px dashed #adb5bd;
                background-color: #f8f9fa;
                display: flex;
                align-items: center;
                justify-content: center;
                overflow: hidden;
            }
            .preview-portada-box img {
                max-width: 100%;
                max-height: 100%;
                object-fit: contain;
            }
        </style>
    </head>

    <body class="bg-light">

        <!-- OFFCANVAS ADMIN -->
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
                        <a href="LibroServlet" class="sidebar-menu-item active">
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

        <!-- ==================== NAVBAR UNIFICADO ==================== -->
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



        <!-- ==================== CONTENIDO ==================== -->

        <div class="container py-4">

            <!-- TÍTULO -->
            <div class="mb-4">
                <h1 class="fw-bold mb-1"><i class="bi bi-book-half text-info me-2"></i>Gestión de Libros</h1>
                <p class="text-muted">
                    Administra el catálogo de libros y sus imágenes de portada en la biblioteca.
                </p>
            </div>



            <!-- ==================== DETERMINAR SI ESTAMOS EDITANDO ==================== -->

            <%
                Libro libroEditar = (Libro) request.getAttribute("libroEditar");

                boolean editando = libroEditar != null;
            %>



            <!-- ==================== FORMULARIO ==================== -->

            <div class="card shadow-sm mb-5">


                <div class="card-header bg-primary text-white">

                    <h5 class="mb-0">

                        <%= editando ? "Editar libro" : "Agregar nuevo libro"%>

                    </h5>

                </div>



                <div class="card-body">


                    <form action="LibroServlet" method="POST">


                        <!-- Si estamos editando -->

                        <% if (editando) {%>

                        <input type="hidden"
                               name="accion"
                               value="actualizar">

                        <input type="hidden"
                               name="id"
                               value="<%= libroEditar.getIdLibro()%>">

                        <% }%>



                        <div class="row">


                            <!-- TÍTULO -->

                            <div class="col-md-6 mb-3">

                                <label class="form-label">
                                    Título
                                </label>

                                <input type="text"
                                       name="titulo"
                                       class="form-control"
                                       value="<%= editando ? libroEditar.getTitulo() : ""%>"
                                       required>

                            </div>



                            <!-- ISBN -->

                            <div class="col-md-6 mb-3">

                                <label class="form-label">
                                    ISBN
                                </label>

                                <input type="text"
                                       name="isbn"
                                       class="form-control"
                                       value="<%= editando ? libroEditar.getIsbn() : ""%>"
                                       required>

                            </div>


                            <!-- AUTOR -->

                            <div class="col-md-6 mb-3">

                                <label class="form-label">
                                    Autor
                                </label>

                                <select name="idAutor" class="form-select" required>
                                    <% for (Autor a : listaAutores) {
                                           boolean sel = editando && libroEditar.getIdAutor() == a.getIdAutor();
                                    %>
                                        <option value="<%= a.getIdAutor() %>" <%= sel ? "selected" : "" %>>
                                            <%= a.getNombre() %>
                                        </option>
                                    <% } %>
                                </select>

                            </div>


                            <!-- CATEGORÍA -->

                            <div class="col-md-6 mb-3">

                                <label class="form-label">
                                    Categoría
                                </label>

                                <select name="idCategoria" class="form-select" required>
                                    <% for (Categoria c : listaCategorias) {
                                           boolean sel = editando && libroEditar.getIdCategoria() == c.getIdCategoria();
                                    %>
                                        <option value="<%= c.getIdCategoria() %>" <%= sel ? "selected" : "" %>>
                                            <%= c.getNombre() %>
                                        </option>
                                    <% } %>
                                </select>

                            </div>



                            <!-- AÑO -->

                            <div class="col-md-3 mb-3">

                                <label class="form-label">
                                    Año
                                </label>

                                <input type="number"
                                       name="anio"
                                       class="form-control"
                                       value="<%= editando ? libroEditar.getAnio() : ""%>"
                                       required>

                            </div>



                            <!-- STOCK -->

                            <div class="col-md-3 mb-3">

                                <label class="form-label">
                                    Stock
                                </label>

                                <input type="number"
                                       name="stock"
                                       class="form-control"
                                       min="0"
                                       value="<%= editando ? libroEditar.getStock() : ""%>"
                                       required>

                            </div>


                            <!-- IMAGEN DE PORTADA (URL O ARCHIVO DESDE LA PC) -->

                            <div class="col-md-6 mb-3">

                                <label class="form-label">
                                    Imagen de Portada (URL o subir desde tu PC)
                                </label>

                                <div class="d-flex gap-3 align-items-start">
                                    <div class="flex-grow-1">
                                        <input type="text"
                                               name="imagenPortada"
                                               id="inputImagenPortada"
                                               class="form-control mb-2"
                                               placeholder="https://ejemplo.com/portada.jpg o sube un archivo abajo..."
                                               value="<%= editando ? libroEditar.getImagenPortada() : ""%>"
                                               oninput="actualizarVistaPrevia(this.value)">

                                        <input type="file"
                                               id="archivoPortada"
                                               class="form-control form-control-sm"
                                               accept="image/*"
                                               onchange="cargarArchivoPortada(this)">
                                        <small class="text-muted d-block mt-1">
                                            Puedes pegar un enlace de imagen o seleccionar una foto desde tu computadora.
                                        </small>
                                    </div>

                                    <div class="preview-portada-box flex-shrink-0" title="Vista previa de portada">
                                        <img id="imgVistaPrevia"
                                             src="<%= editando ? libroEditar.getImagenPortada() : "img/portadas/default.svg" %>"
                                             alt="Vista previa"
                                             onerror="this.onerror=null;this.src='img/portadas/default.svg';">
                                    </div>
                                </div>

                            </div>



                            <!-- DESCRIPCIÓN -->

                            <div class="col-md-12 mb-3">

                                <label class="form-label">
                                    Descripción
                                </label>

                                <textarea name="descripcion"
                                          class="form-control"
                                          rows="3"
                                          required><%= editando ? libroEditar.getDescripcion() : ""%></textarea>

                            </div>


                        </div>



                        <!-- BOTONES -->

                        <button type="submit" class="btn btn-primary">

                            <%= editando ? "Guardar cambios" : "+ Agregar libro"%>

                        </button>



                        <% if (editando) { %>

                        <a href="LibroServlet"
                           class="btn btn-secondary">

                            Cancelar

                        </a>

                        <% } %>


                    </form>


                </div>

            </div>



            <!-- ==================== TABLA DE LIBROS ==================== -->

            <div class="card shadow-sm">


                <div class="card-header bg-white py-3 d-flex flex-wrap align-items-center justify-content-between gap-2">
                    <h5 class="mb-0 fw-bold">
                        Libros registrados en el catálogo
                    </h5>
                    <div style="max-width: 380px;" class="w-100">
                        <input type="text" id="filtroLibros" class="form-control form-control-sm" placeholder="🔍 Buscar por título, autor, categoría..." onkeyup="filtrarLibros()">
                    </div>
                </div>



                <div class="card-body">


                    <div class="table-responsive">


                        <table class="table table-hover align-middle">


                            <!-- ENCABEZADO -->

                            <thead class="table-dark">

                                <tr>

                                    <th>ID</th>

                                    <th>Portada</th>

                                    <th>Título</th>

                                    <th>Autor</th>

                                    <th>Categoría</th>

                                    <th>ISBN</th>

                                    <th>Año</th>

                                    <th>Stock</th>

                                    <th>Acciones</th>

                                </tr>

                            </thead>



                            <!-- CUERPO -->

                            <tbody>


                                <%

                                    List<Libro> libros
                                            = (List<Libro>) request.getAttribute("libros");

                                    if (libros != null && !libros.isEmpty()) {

                                        for (Libro libro : libros) {

                                %>


                                <tr>


                                    <!-- ID -->

                                    <td>

                                        <%= libro.getIdLibro()%>

                                    </td>


                                    <!-- PORTADA -->

                                    <td>
                                        <img src="<%= libro.getImagenPortada() %>"
                                             alt="Portada"
                                             class="portada-mini"
                                             onerror="this.onerror=null;this.src='img/portadas/default.svg';">
                                    </td>


                                    <!-- TÍTULO -->

                                    <td>

                                        <strong>

                                            <%= libro.getTitulo()%>

                                        </strong>

                                    </td>


                                    <!-- AUTOR -->

                                    <td>
                                        <%= libro.getNombreAutor() %>
                                    </td>


                                    <!-- CATEGORÍA -->

                                    <td>
                                        <span class="badge bg-secondary">
                                            <%= libro.getNombreCategoria() %>
                                        </span>
                                    </td>



                                    <!-- ISBN -->

                                    <td>

                                        <%= libro.getIsbn()%>

                                    </td>


                                    <!-- AÑO -->

                                    <td>

                                        <%= libro.getAnio()%>

                                    </td>


                                    <!-- STOCK -->
                                    <td>
                                        <div class="d-flex align-items-center gap-1">
                                            <a href="LibroServlet?accion=ajustarStock&id=<%= libro.getIdLibro() %>&delta=-1" class="btn btn-outline-danger btn-sm py-0 px-1" title="Restar 1 ejemplar">-</a>
                                            <% if (libro.getStock() > 2) { %>
                                                <span class="badge bg-success" style="min-width: 24px;"><%= libro.getStock() %></span>
                                            <% } else if (libro.getStock() > 0) { %>
                                                <span class="badge bg-warning text-dark" style="min-width: 24px;"><%= libro.getStock() %></span>
                                            <% } else { %>
                                                <span class="badge bg-danger" style="min-width: 24px;">0</span>
                                            <% } %>
                                            <a href="LibroServlet?accion=ajustarStock&id=<%= libro.getIdLibro() %>&delta=1" class="btn btn-outline-success btn-sm py-0 px-1" title="Sumar 1 ejemplar">+</a>
                                        </div>
                                    </td>



                                    <!-- ACCIONES -->

                                    <td>


                                        <!-- EDITAR -->

                                        <a href="LibroServlet?accion=editar&id=<%= libro.getIdLibro()%>"
                                           class="btn btn-sm btn-warning">

                                            Editar

                                        </a>



                                        <!-- ELIMINAR -->

                                        <a href="LibroServlet?accion=eliminar&id=<%= libro.getIdLibro()%>"
                                           class="btn btn-sm btn-danger"
                                           onclick="return confirm('¿Deseas eliminar este libro?');">

                                            Eliminar

                                        </a>


                                    </td>


                                </tr>


                                <%
                                    }

                                } else {
                                %>


                                <!-- SIN LIBROS -->

                                <tr>

                                    <td colspan="9"
                                        class="text-center text-muted">

                                        No hay libros registrados.

                                    </td>

                                </tr>

                                <%                        }

                                %>


                            </tbody>


                        </table>


                    </div>


                </div>


            </div>


        </div>



        <!-- ==================== FOOTER ==================== -->

        <footer class="text-center text-muted mt-5 mb-4">

            BOOKHUB © 2026 — Sistema de Gestión de Biblioteca

        </footer>


        <script>
            function actualizarVistaPrevia(url) {
                const img = document.getElementById("imgVistaPrevia");
                if (url && url.trim() !== "") {
                    img.src = url.trim();
                } else {
                    img.src = "img/portadas/default.svg";
                }
            }

            function cargarArchivoPortada(input) {
                if (!input.files || !input.files[0]) {
                    return;
                }
                const file = input.files[0];
                const reader = new FileReader();
                reader.onload = function (e) {
                    const imgObj = new Image();
                    imgObj.onload = function () {
                        const canvas = document.createElement("canvas");
                        const maxW = 300;
                        const maxH = 420;
                        let w = imgObj.width;
                        let h = imgObj.height;
                        if (w > maxW || h > maxH) {
                            const ratio = Math.min(maxW / w, maxH / h);
                            w = Math.round(w * ratio);
                            h = Math.round(h * ratio);
                        }
                        canvas.width = w;
                        canvas.height = h;
                        const ctx = canvas.getContext("2d");
                        ctx.drawImage(imgObj, 0, 0, w, h);
                        const dataUrl = canvas.toDataURL("image/jpeg", 0.85);
                        document.getElementById("inputImagenPortada").value = dataUrl;
                        document.getElementById("imgVistaPrevia").src = dataUrl;
                    };
                    imgObj.src = e.target.result;
                };
                reader.readAsDataURL(file);
            }

            function filtrarLibros() {
                const term = document.getElementById('filtroLibros').value.toLowerCase();
                const filas = document.querySelectorAll('tbody tr');
                filas.forEach(f => {
                    const texto = f.textContent.toLowerCase();
                    f.style.display = texto.includes(term) ? '' : 'none';
                });
            }
        </script>

        <%@include file="a11y-panel.jsp"%>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
