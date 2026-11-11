<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.beans.Libro"%>
<%@page import="modelo.beans.Usuario"%>
<%@page import="modelo.dao.LibroDAO"%>

<%
    Libro libro = (Libro) request.getAttribute("libro");
    if (libro == null) {
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idParam.trim());
                LibroDAO libroDAO = new LibroDAO();
                libro = libroDAO.obtenerPorId(id);
            } catch (Exception ignored) {}
        }
    }
    if (libro == null) {
        response.sendRedirect("CatalogoServlet");
        return;
    }

    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
    String error = request.getParameter("error");
    String exito = request.getParameter("exito");
    String descLimpia = (libro.getDescripcion() != null) ? libro.getDescripcion().replace("\"", "&quot;").replace("'", "") : "";
    String titLimpio = (libro.getTitulo() != null) ? libro.getTitulo().replace("\"", "&quot;").replace("'", "") : "";
    String autLimpio = (libro.getNombreAutor() != null) ? libro.getNombreAutor().replace("\"", "&quot;").replace("'", "") : "";
    String portadaUrl = libro.getImagenPortada();
    if (portadaUrl == null || portadaUrl.trim().isEmpty()) {
        portadaUrl = "img/portadas/default.svg";
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
    <title><%= libro.getTitulo() %> - BookHub</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        :root {
            --a11y-font-scale: 1;
            --a11y-line-height: 1.5;
        }

        body {
            background-color: #f8fafc;
            color: #1e293b;
            font-size: calc(1rem * var(--a11y-font-scale));
            line-height: var(--a11y-line-height);
            transition: background-color 0.2s ease, color 0.2s ease;
        }

        .detalle-portada-box {
            background-color: #f1f5f9;
            border-radius: 8px;
            padding: 16px;
            text-align: center;
            border: 1px solid #e2e8f0;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .detalle-portada-img {
            width: 200px;
            height: 280px;
            max-width: 100%;
            object-fit: cover;
            border-radius: 6px;
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.16);
            display: block;
        }

        .audio-player-card {
            background-color: #f8fafc;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            padding: 14px 16px;
        }

        /* Estilos globales de accesibilidad WCAG AAA provistos por a11y-panel.jsp */
    </style>

</head>

<body class="bg-light">

    <!-- VENTANA A LA MANO IZQUIERDA (SIDEBAR OFFCANVAS) -->
    <div class="offcanvas offcanvas-start offcanvas-bookhub shadow-lg"
         tabindex="-1"
         id="sidebarBookHub"
         aria-labelledby="sidebarBookHubLabel">

        <div class="offcanvas-header border-bottom border-secondary border-opacity-25 pb-3">
            <div class="d-flex align-items-center gap-2">
                <img src="img/logo.svg" alt="BookHub Logo" width="36" height="36" class="d-inline-block">
                <div>
                    <h5 class="offcanvas-title fw-bold text-white mb-0" id="sidebarBookHubLabel">BookHub</h5>
                    <small class="text-white-50" style="font-size: 0.72rem;">Biblioteca Universitaria</small>
                </div>
            </div>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas" aria-label="Cerrar"></button>
        </div>

        <div class="offcanvas-body d-flex flex-column justify-content-between p-3">
            <div>
                <% if (usuarioSesion != null) { %>
                    <div class="p-3 mb-3 rounded-3 bg-secondary bg-opacity-25 border border-secondary border-opacity-25">
                        <div class="d-flex align-items-center gap-2">
                            <i class="bi bi-person-circle fs-3 text-info"></i>
                            <div class="overflow-hidden">
                                <div class="fw-semibold text-white text-truncate"><%= usuarioSesion.getNombre() %></div>
                                <span class="badge <%= "ADMIN".equals(usuarioSesion.getRol()) ? "bg-danger" : "bg-primary" %>" style="font-size: 0.68rem;">
                                    <%= usuarioSesion.getRol() %>
                                </span>
                            </div>
                        </div>
                    </div>
                <% } %>

                <!-- APARTADOS PRINCIPALES -->
                <p class="sidebar-subtitle mb-2 px-2">Apartados Principales</p>
                <div class="d-flex flex-column gap-1 mb-4">
                    <a href="index.jsp" class="sidebar-menu-item">
                        <i class="bi bi-house-door-fill menu-icon text-warning"></i>
                        <div class="flex-grow-1">
                            <div>Inicio</div>
                            <small class="text-white-50" style="font-size: 0.72rem;">Portal principal y novedades</small>
                        </div>
                    </a>

                    <a href="CatalogoServlet" class="sidebar-menu-item active">
                        <i class="bi bi-journal-bookmark-fill menu-icon text-info"></i>
                        <div class="flex-grow-1">
                            <div>Catálogo</div>
                            <small class="text-white-50" style="font-size: 0.72rem;">Explorar libros y categorías</small>
                        </div>
                    </a>

                    <a href="InnovacionServlet" class="sidebar-menu-item">
                        <i class="bi bi-universal-access-circle menu-icon text-success"></i>
                        <div class="flex-grow-1">
                            <div>ODS 09: Accesibilidad</div>
                            <small class="text-white-50" style="font-size: 0.72rem;">Inclusión asistiva WCAG</small>
                        </div>
                    </a>

                    <a href="MisPrestamosServlet" class="sidebar-menu-item">
                        <i class="bi bi-clock-history menu-icon text-warning"></i>
                        <div class="flex-grow-1">
                            <div>Mis Préstamos</div>
                            <small class="text-white-50" style="font-size: 0.72rem;">Libros prestados y fechas</small>
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

                <!-- HERRAMIENTAS Y ACCESIBILIDAD -->
                <p class="sidebar-subtitle mb-2 px-2">Herramientas & Inclusión</p>
                <div class="d-flex flex-column gap-2 mb-3">
                    <button class="btn btn-outline-info text-start d-flex align-items-center gap-2 py-2 px-3 rounded-3"
                            type="button"
                            onclick="toggleA11yPanel()">
                        <i class="bi bi-eye"></i> Panel Accesibilidad (WCAG)
                    </button>
                    <a href="CatalogoServlet" class="btn btn-outline-light text-start d-flex align-items-center gap-2 py-2 px-3 rounded-3">
                        <i class="bi bi-mic"></i> Búsqueda por Voz
                    </a>
                </div>
            </div>

            <div class="pt-3 border-top border-secondary border-opacity-25 text-center text-white-50 small">
                <span>BookHub v2.0 • Inclusión Digital</span>
            </div>
        </div>
    </div>

    <!-- NAVBAR CON BOTÓN DE TRES LÍNEAS (SE DESVANECE AL HACER SCROLL) -->
    <nav class="navbar navbar-dark bg-dark sticky-top shadow-sm py-2 navbar-scroll-fade" id="mainNavbar">

        <div class="container-fluid px-3 px-lg-4">

            <!-- Lado izquierdo: Botón de tres líneas + Logo -->
            <div class="d-flex align-items-center gap-2">
                <button class="btn-sidebar-toggle"
                        type="button"
                        data-bs-toggle="offcanvas"
                        data-bs-target="#sidebarBookHub"
                        aria-controls="sidebarBookHub"
                        title="Abrir menú de apartados (Inicio, Catálogo, ODS 09, Mis préstamos)"
                        aria-label="Menú principal de 3 líneas">
                    <i class="bi bi-list fs-3"></i>
                </button>

                <a class="navbar-brand fw-bold d-flex align-items-center gap-2 m-0" href="index.jsp">
                    <img src="img/logo.svg" alt="BookHub Logo" width="34" height="34" class="d-inline-block">
                    <span>BookHub</span>
                </a>
            </div>

            <!-- Lado derecho: EXCLUSIVAMENTE Iniciar Sesión / Registrarse (o Perfil / Salir) -->
            <div class="d-flex align-items-center gap-2 ms-auto">
                <% if (usuarioSesion != null) { %>
                    <% if ("ADMIN".equals(usuarioSesion.getRol())) { %>
                        <a href="dashboard.jsp" class="btn btn-warning btn-sm d-flex align-items-center gap-1">
                            <i class="bi bi-speedometer2"></i> <span class="d-none d-sm-inline">Panel Admin</span>
                        </a>
                    <% } else { %>
                        <a href="usuario.jsp" class="btn btn-light btn-sm d-flex align-items-center gap-1">
                            <i class="bi bi-person-circle"></i> <span class="d-none d-sm-inline"><%= usuarioSesion.getNombre() %></span>
                        </a>
                    <% } %>
                    <a href="LogoutServlet" class="btn btn-outline-danger btn-sm d-flex align-items-center gap-1">
                        <i class="bi bi-box-arrow-left"></i> <span>Salir</span>
                    </a>
                <% } else { %>
                    <a href="login.jsp" class="btn btn-light btn-sm d-flex align-items-center gap-1">
                        <i class="bi bi-box-arrow-in-right"></i> <span>Iniciar sesión</span>
                    </a>
                    <a href="registro.jsp" class="btn btn-outline-light btn-sm d-flex align-items-center gap-1">
                        <i class="bi bi-person-plus"></i> <span>Registrarse</span>
                    </a>
                <% } %>
            </div>

        </div>

    </nav>


    <div class="container py-4">

        <div class="row justify-content-center">

            <div class="col-lg-9">

                <% if ("prestado".equals(exito)) { %>
                    <div class="alert alert-success">
                        <strong>Préstamo registrado.</strong> Tienes 7 días para la devolución. Puedes consultarlo en <a href="MisPrestamosServlet" class="alert-link">Mis préstamos</a>.
                    </div>
                <% } else if ("yaPrestado".equals(error)) { %>
                    <div class="alert alert-warning">
                        Ya cuentas con un préstamo activo de este libro. Revisa <a href="MisPrestamosServlet" class="alert-link">Mis préstamos</a>.
                    </div>
                <% } else if ("sinStock".equals(error)) { %>
                    <div class="alert alert-secondary">
                        No hay ejemplares disponibles en este momento.
                    </div>
                <% } %>

                <div class="card shadow-sm border-0">

                    <div class="card-body p-4">

                        <div class="row g-4 align-items-start">

                            <!-- PORTADA -->
                            <div class="col-md-4 text-center">
                                <div class="detalle-portada-box">
                                    <img src="<%= portadaUrl %>"
                                         alt="Portada de <%= libro.getTitulo() %>"
                                         class="detalle-portada-img"
                                         onerror="this.onerror=null;this.src='img/portadas/default.svg';">
                                </div>
                            </div>

                            <!-- DATOS DEL LIBRO -->
                            <div class="col-md-8">

                                <div class="mb-2">
                                    <span class="badge bg-secondary">
                                        <%= libro.getNombreCategoria() %>
                                    </span>
                                    <span class="text-muted small ms-2">
                                        Año <%= libro.getAnio() %>
                                    </span>
                                </div>

                                <h3 class="fw-bold mb-1">
                                    <%= libro.getTitulo() %>
                                </h3>

                                <p class="text-muted mb-3">
                                    Por <%= libro.getNombreAutor() %>
                                </p>

                                <!-- REPRODUCTOR DE TEXTO ACCESIBLE -->
                                <div class="audio-player-card mb-3">
                                    <div class="d-flex align-items-center justify-content-between mb-2">
                                        <div>
                                            <div class="fw-bold small text-dark">Lector por voz (Accesibilidad)</div>
                                            <small class="text-muted" style="font-size: 0.78rem;">Síntesis de voz para personas con baja visión o ceguera</small>
                                        </div>
                                        <div id="statusAudio" class="badge bg-light text-secondary border">Listo</div>
                                    </div>

                                    <div class="d-flex align-items-center gap-2 flex-wrap">
                                        <button type="button" class="btn-audio-detailed" id="btnPlayAudio" onclick="reproducirAudioLibro()">
                                            <i class="bi bi-volume-up-fill"></i> <span>Audio</span>
                                        </button>
                                        <button type="button" class="btn btn-outline-secondary btn-sm" id="btnPauseAudio" onclick="pausarAudioLibro()" style="display:none;">
                                            Pausar
                                        </button>
                                        <button type="button" class="btn btn-outline-danger btn-sm" id="btnStopAudio" onclick="detenerAudioLibro()" style="display:none;">
                                            Detener
                                        </button>

                                        <div class="ms-auto d-flex align-items-center gap-1">
                                            <small class="text-muted" style="font-size: 0.78rem;">Velocidad:</small>
                                            <select id="audioSpeed" class="form-select form-select-sm" style="width: auto;" onchange="cambiarVelocidadAudio()">
                                                <option value="0.8">0.8x</option>
                                                <option value="1.0" selected>1.0x</option>
                                                <option value="1.2">1.2x</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <table class="table table-sm table-borderless mb-3 small">
                                    <tbody>
                                        <tr>
                                            <th class="text-muted" style="width: 130px;">ISBN:</th>
                                            <td><%= libro.getIsbn() %></td>
                                        </tr>
                                        <tr>
                                            <th class="text-muted">Categoría:</th>
                                            <td><%= libro.getNombreCategoria() %></td>
                                        </tr>
                                        <tr>
                                            <th class="text-muted">Disponibilidad:</th>
                                            <td>
                                                <% if (libro.getStock() > 0) { %>
                                                    <span class="badge bg-success">Disponible</span>
                                                    <span class="ms-1 text-muted"><%= libro.getStock() %> ejemplares</span>
                                                <% } else { %>
                                                    <span class="badge bg-secondary">Agotado</span>
                                                <% } %>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>

                                <div class="mb-4">
                                    <h6 class="fw-bold text-muted small text-uppercase">Sinopsis</h6>
                                    <p class="text-secondary small lh-base mb-0" id="textoDescripcion">
                                        <%= libro.getDescripcion() %>
                                    </p>
                                </div>

                                <div class="d-flex flex-wrap gap-2 pt-2 border-top">
                                    <% if (libro.getStock() > 0) { %>
                                        <a href="SolicitarPrestamoServlet?idLibro=<%= libro.getIdLibro() %>"
                                           class="btn btn-primary btn-sm px-4">
                                            Solicitar préstamo
                                        </a>
                                    <% } else { %>
                                        <button class="btn btn-secondary btn-sm" disabled>
                                            Sin stock disponible
                                        </button>
                                    <% } %>

                                    <a href="CatalogoServlet" class="btn btn-outline-secondary btn-sm">
                                        Volver al catálogo
                                    </a>
                                </div>

                            </div>

                        </div>

                    </div>

                </div>

            </div>

        </div>

    </div>


    


    <footer class="bg-dark text-white text-center py-4 mt-5">
        <div class="container">
            <p class="mb-1 fw-bold">BookHub</p>
            <p class="mb-0 small text-secondary">
                Sistema de Gestión de Biblioteca Universitaria
            </p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- SCRIPTS DE AUDIO Y ACCESIBILIDAD SUITE -->
    <script>
        const textoCompletoLibro = "Título: <%= titLimpio %>. Autor: <%= autLimpio %>. Año: <%= libro.getAnio() %>. <%= descLimpia %>";
        let audioPausado = false;

        function reproducirAudioLibro() {
            if (!('speechSynthesis' in window)) {
                alert('Tu navegador no cuenta con soporte para reproducción por voz.');
                return;
            }

            if (audioPausado && window.speechSynthesis.paused) {
                window.speechSynthesis.resume();
                audioPausado = false;
                actualizarUIReinicio();
                return;
            }

            window.speechSynthesis.cancel();
            const vel = parseFloat(document.getElementById('audioSpeed').value) || 1.0;
            const utterance = new SpeechSynthesisUtterance(textoCompletoLibro);
            utterance.lang = 'es-ES';
            utterance.rate = vel;

            utterance.onstart = function() {
                actualizarUIReinicio();
            };

            utterance.onend = function() {
                actualizarUIDetenido();
            };

            utterance.onerror = function() {
                actualizarUIDetenido();
            };

            window.speechSynthesis.speak(utterance);
        }

        function pausarAudioLibro() {
            if ('speechSynthesis' in window) {
                if (window.speechSynthesis.speaking && !window.speechSynthesis.paused) {
                    window.speechSynthesis.pause();
                    audioPausado = true;
                    document.getElementById('btnPauseAudio').textContent = 'Reanudar';
                    document.getElementById('statusAudio').textContent = 'Pausado';
                } else if (window.speechSynthesis.paused) {
                    window.speechSynthesis.resume();
                    audioPausado = false;
                    document.getElementById('btnPauseAudio').textContent = 'Pausar';
                    document.getElementById('statusAudio').textContent = 'Reproduciendo';
                }
            }
        }

        function detenerAudioLibro() {
            if ('speechSynthesis' in window) {
                window.speechSynthesis.cancel();
                audioPausado = false;
                actualizarUIDetenido();
            }
        }

        function cambiarVelocidadAudio() {
            if (window.speechSynthesis.speaking) {
                reproducirAudioLibro();
            }
        }

        function actualizarUIReinicio() {
            document.getElementById('btnPlayAudio').style.display = 'none';
            document.getElementById('btnPauseAudio').style.display = 'inline-block';
            document.getElementById('btnPauseAudio').textContent = 'Pausar';
            document.getElementById('btnStopAudio').style.display = 'inline-block';
            document.getElementById('statusAudio').textContent = 'Reproduciendo';
            document.getElementById('statusAudio').className = 'badge bg-success';
        }

        function actualizarUIDetenido() {
            document.getElementById('btnPlayAudio').style.display = 'inline-block';
            document.getElementById('btnPauseAudio').style.display = 'none';
            document.getElementById('btnStopAudio').style.display = 'none';
            document.getElementById('statusAudio').textContent = 'Listo';
            document.getElementById('statusAudio').className = 'badge bg-light text-secondary border';
            audioPausado = false;
        }

        // REPRODUCIR CUALQUIER TEXTO
        function reproducirAudio(texto) {
            if (!('speechSynthesis' in window)) return;
            window.speechSynthesis.cancel();
            const utterance = new SpeechSynthesisUtterance(texto);
            utterance.lang = 'es-ES';
            utterance.rate = 1.0;
            window.speechSynthesis.speak(utterance);
        }

        // ESCUCHAR TEXTO SELECCIONADO
        document.addEventListener('mouseup', function(e) {
            const sel = window.getSelection().toString().trim();
            const btn = document.getElementById('a11yBtnAudioSel');
            if (btn) {
                if (sel.length >= 3) {
                    btn.style.display = 'block';
                    btn.style.top = (e.pageY + 12) + 'px';
                    btn.style.left = Math.min(window.innerWidth - 180, e.pageX) + 'px';
                    btn.setAttribute('data-texto', sel);
                } else {
                    btn.style.display = 'none';
                }
            }
        });

        function leerTextoSeleccionado() {
            const btn = document.getElementById('a11yBtnAudioSel');
            if (btn) {
                const texto = btn.getAttribute('data-texto');
                if (texto) {
                    reproducirAudio(texto);
                    btn.style.display = 'none';
                }
            }
        }

        // Accesibilidad global administrada por a11y-panel.jsp
    </script>

</body>

</html>
