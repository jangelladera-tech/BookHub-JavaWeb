<%@page import="java.util.List"%>
<%@page import="beans.Libro"%>
<%@page import="beans.Autor"%>
<%@page import="beans.Categoria"%>
<%@page import="dao.AutorDAO"%>
<%@page import="dao.CategoriaDAO"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
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

        <style>
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


        <!-- ==================== NAVBAR ==================== -->

        <nav class="navbar navbar-dark bg-dark">

            <div class="container">

                <a class="navbar-brand fw-bold" href="dashboard.jsp">
                    BOOKHUB
                </a>

                <div class="d-flex gap-2">
                    <a href="CatalogoServlet" class="btn btn-outline-info btn-sm">
                        Ver Catálogo
                    </a>
                    <a href="dashboard.jsp" class="btn btn-outline-light btn-sm">
                        Volver al Dashboard
                    </a>
                </div>

            </div>

        </nav>



        <!-- ==================== CONTENIDO ==================== -->

        <div class="container mt-5">


            <!-- TÍTULO -->

            <div class="mb-4">

                <h1>Gestión de Libros</h1>

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


                <div class="card-header">

                    <h5 class="mb-0">
                        Libros registrados
                    </h5>

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

                                        <% if (libro.getStock() > 0) {%>

                                        <span class="badge bg-success">

                                            <%= libro.getStock()%>
                                            disponibles

                                        </span>

                                        <% } else { %>

                                        <span class="badge bg-danger">

                                            Sin stock

                                        </span>

                                        <% }%>

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
        </script>

    </body>
</html>
