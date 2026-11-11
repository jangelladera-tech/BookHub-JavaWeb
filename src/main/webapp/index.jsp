<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.beans.Usuario"%>
<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
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
    <title>BookHub | Biblioteca Universitaria</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
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

        .hero {
            padding: 55px 20px;
            background: linear-gradient(135deg, #ffffff 0%, #f1f5f9 100%);
            border-bottom: 1px solid #e2e8f0;
        }

        .book-card {
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            background: #ffffff;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            overflow: hidden;
        }

        .book-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 18px rgba(0, 0, 0, 0.06);
        }

        .home-cover-wrapper {
            background-color: #f1f5f9;
            height: 230px;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 10px;
            border-bottom: 1px solid #e2e8f0;
        }

        .home-cover-img {
            width: 145px;
            height: 205px;
            object-fit: cover;
            border-radius: 4px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.12);
            display: block;
        }

        .ods-card {
            background-color: #ffffff;
            border: 1px solid #cbd5e1;
            border-left: 4px solid #1e3a8a;
            border-radius: 8px;
        }

        /* Estilos globales de accesibilidad WCAG AAA provistos por a11y-panel.jsp */
    
        /* EFECTO DE DESVANECIMIENTO AL HACER SCROLL */
        .navbar-scroll-fade {
            transition: opacity 0.35s ease, transform 0.35s ease;
        }
        .navbar-scroll-fade.navbar-hidden {
            opacity: 0 !important;
            pointer-events: none !important;
            transform: translateY(-10px);
        }

        /* BOTÓN DE 3 LÍNEAS (HAMBURGUESA) */
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

        /* VENTANA LATERAL (OFFCANVAS) */
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
            padding: 12px 14px;
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

        /* BOTÓN DE AUDIO ULTRA DETALLADO */
        .btn-audio-detailed {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            padding: 6px 14px;
            font-size: 0.82rem;
            font-weight: 600;
            letter-spacing: 0.3px;
            border-radius: 50px;
            background: linear-gradient(135deg, #1e3a8a 0%, #2563eb 100%);
            color: #ffffff !important;
            border: 1px solid rgba(255, 255, 255, 0.25);
            box-shadow: 0 2px 6px rgba(37, 99, 235, 0.25), inset 0 1px 0 rgba(255, 255, 255, 0.2);
            transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
            text-decoration: none;
            cursor: pointer;
        }
        .btn-audio-detailed:hover {
            background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.45);
            transform: translateY(-2px);
            color: #ffffff !important;
        }
        .btn-audio-detailed:active {
            transform: translateY(0);
        }
        .btn-audio-detailed i {
            font-size: 0.95rem;
        }

    </style>
</head>

<body>

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
                            <i class="bi <%= "ADMIN".equalsIgnoreCase(usuarioSesion.getRol()) ? "bi-shield-lock-fill text-danger" : "bi-person-circle text-info" %> fs-3"></i>
                            <div class="overflow-hidden">
                                <div class="fw-semibold text-white text-truncate"><%= usuarioSesion.getNombre() %></div>
                                <span class="badge <%= "ADMIN".equalsIgnoreCase(usuarioSesion.getRol()) ? "bg-danger" : "bg-primary" %>" style="font-size: 0.68rem;">
                                    <%= usuarioSesion.getRol() %>
                                </span>
                            </div>
                        </div>
                    </div>
                <% } %>
                <!-- APARTADOS PRINCIPALES -->
                <p class="sidebar-subtitle mb-2 px-2">Apartados Principales</p>
                <div class="d-flex flex-column gap-1 mb-4">
                    <a href="index.jsp" class="sidebar-menu-item active">
                        <i class="bi bi-house-door-fill menu-icon text-warning"></i>
                        <div class="flex-grow-1">
                            <div>Inicio</div>
                            <small class="text-white-50" style="font-size: 0.72rem;">Portal principal y novedades</small>
                        </div>
                    </a>

                    <a href="CatalogoServlet" class="sidebar-menu-item">
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

    <!-- NAVEGACIÓN PRINCIPAL (SE DESVANECE AL HACER SCROLL) -->
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

            <!-- Lado derecho: Sesión activa o Iniciar Sesión / Registrarse -->
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


    <!-- HERO -->
    <section class="hero">
        <div class="container">
            <div class="row align-items-center">

                <div class="col-md-7">
                    <span class="badge bg-light text-primary border mb-2 px-2 py-1 small">
                        Biblioteca Universitaria · ODS 9 Accesibilidad
                    </span>

                    <h1 class="display-5 fw-bold mb-3">
                        Tu biblioteca universitaria, digital y accesible
                    </h1>

                    <p class="lead text-secondary mb-4">
                        Consulta el catálogo en tiempo real, utiliza la síntesis de voz asistida y gestiona tus préstamos con autonomía.
                    </p>

                    <div class="d-flex flex-wrap gap-2">
                        <a href="CatalogoServlet" class="btn btn-primary px-3">
                            Explorar catálogo
                        </a>

                        <a href="InnovacionServlet" class="btn btn-outline-secondary px-3">
                            Herramientas ODS 9
                        </a>

                        <button type="button" class="btn btn-link text-decoration-none" onclick="reproducirAudio('Bienvenido a BookHub, sistema web de gestión de biblioteca universitaria con herramientas de accesibilidad.')">
                            Escuchar bienvenida
                        </button>
                    </div>
                </div>

                <div class="col-md-5 text-center mt-4 mt-md-0">
                    <div class="card p-3 shadow-sm border text-start small">
                        <h6 class="fw-bold mb-2">Herramientas de asistencia incluidas:</h6>
                        <p class="text-muted mb-2">Diseñadas para facilitar el acceso a estudiantes con discapacidad o fatiga de lectura:</p>
                        <ul class="list-unstyled mb-0 text-secondary">
                            <li class="mb-1">• <strong>Lector por voz:</strong> Síntesis vocal de títulos y resúmenes.</li>
                            <li class="mb-1">• <strong>Búsqueda por voz:</strong> Dictado para movilidad reducida.</li>
                            <li class="mb-1">• <strong>Contraste adaptativo:</strong> Alto contraste y modo nocturno.</li>
                            <li class="mb-0">• <strong>Apoyo a la lectura:</strong> Tipografía para dislexia y regla guía.</li>
                        </ul>
                    </div>
                </div>

            </div>
        </div>
    </section>


    <!-- BUSCADOR -->
    <section class="container my-4">
        <div class="card shadow-sm border-0">
            <div class="card-body p-3">
                <form action="CatalogoServlet" method="get">
                    <div class="input-group">
                        <input type="text"
                               id="inputBusquedaHome"
                               name="busqueda"
                               class="form-control"
                               placeholder="Buscar por título, autor o ISBN..."
                               required>

                        <button type="button"
                                id="btnMicHome"
                                class="btn btn-outline-secondary"
                                onclick="iniciarVozHome()"
                                title="Dictar búsqueda">
                            Dictar
                        </button>

                        <button type="submit" class="btn btn-primary px-4">
                            Buscar
                        </button>
                    </div>
                    <div id="statusVozHome" class="small text-muted mt-1" style="display: none;"></div>
                </form>
            </div>
        </div>
    </section>


    <!-- DESTACADOS DEL CATÁLOGO -->
    <section class="container mb-5">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="fw-bold mb-0">Libros destacados</h5>
            <a href="CatalogoServlet" class="small text-decoration-none">Ver catálogo completo →</a>
        </div>

        <div class="row g-3">

            <!-- LIBRO 1 -->
            <div class="col-md-4">
                <div class="card book-card h-100">
                    <div class="home-cover-wrapper">
                        <img src="img/portadas/libro1.svg" alt="Cien años de soledad" class="home-cover-img" onerror="this.onerror=null;this.src='img/portadas/default.svg';">
                    </div>
                    <div class="card-body p-3 d-flex flex-column">
                        <div class="mb-1">
                            <span class="badge bg-light text-dark border">Novela</span>
                            <span class="badge bg-success ms-1">Disponible</span>
                        </div>
                        <h6 class="fw-bold mb-1">Cien años de soledad</h6>
                        <p class="text-muted small mb-2">Gabriel García Márquez</p>
                        <p class="card-text text-secondary small mb-3 lh-sm" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                            Novela cumbre del realismo mágico sobre la familia Buendía.
                        </p>
                        <div class="mt-auto d-flex gap-2">
                            <a href="DetalleLibroServlet?id=1" class="btn btn-outline-primary btn-sm flex-grow-1">Ver detalles</a>
                            <button type="button" class="btn-audio-detailed" onclick="reproducirAudio('Cien años de soledad. De Gabriel García Márquez. Novela cumbre del realismo mágico.')">
                                <i class="bi bi-volume-up-fill"></i> <span>Audio</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- LIBRO 2 -->
            <div class="col-md-4">
                <div class="card book-card h-100">
                    <div class="home-cover-wrapper">
                        <img src="img/portadas/libro2.svg" alt="Don Quijote de la Mancha" class="home-cover-img" onerror="this.onerror=null;this.src='img/portadas/default.svg';">
                    </div>
                    <div class="card-body p-3 d-flex flex-column">
                        <div class="mb-1">
                            <span class="badge bg-light text-dark border">Novela</span>
                            <span class="badge bg-success ms-1">Disponible</span>
                        </div>
                        <h6 class="fw-bold mb-1">Don Quijote de la Mancha</h6>
                        <p class="text-muted small mb-2">Miguel de Cervantes</p>
                        <p class="card-text text-secondary small mb-3 lh-sm" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                            Obra clásica universal de la literatura española.
                        </p>
                        <div class="mt-auto d-flex gap-2">
                            <a href="DetalleLibroServlet?id=2" class="btn btn-outline-primary btn-sm flex-grow-1">Ver detalles</a>
                            <button type="button" class="btn-audio-detailed" onclick="reproducirAudio('Don Quijote de la Mancha. De Miguel de Cervantes. Obra clásica universal de la literatura española.')">
                                <i class="bi bi-volume-up-fill"></i> <span>Audio</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- LIBRO 3 -->
            <div class="col-md-4">
                <div class="card book-card h-100">
                    <div class="home-cover-wrapper">
                        <img src="img/portadas/libro3.svg" alt="El Principito" class="home-cover-img" onerror="this.onerror=null;this.src='img/portadas/default.svg';">
                    </div>
                    <div class="card-body p-3 d-flex flex-column">
                        <div class="mb-1">
                            <span class="badge bg-light text-dark border">Novela</span>
                            <span class="badge bg-success ms-1">Disponible</span>
                        </div>
                        <h6 class="fw-bold mb-1">El Principito</h6>
                        <p class="text-muted small mb-2">Antoine de Saint-Exupéry</p>
                        <p class="card-text text-secondary small mb-3 lh-sm" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                            Obra filosófica sobre la amistad y el sentido de la vida.
                        </p>
                        <div class="mt-auto d-flex gap-2">
                            <a href="DetalleLibroServlet?id=3" class="btn btn-outline-primary btn-sm flex-grow-1">Ver detalles</a>
                            <button type="button" class="btn-audio-detailed" onclick="reproducirAudio('El Principito. De Antoine de Saint-Exupéry. Obra sobre la amistad y el sentido de la vida.')">
                                <i class="bi bi-volume-up-fill"></i> <span>Audio</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </section>


    <!-- COMPROMISO ODS 9 -->
    <section class="container mb-5">
        <div class="card ods-card p-4">
            <div class="row align-items-center">
                <div class="col-md-9">
                    <h6 class="fw-bold mb-1 text-primary">ODS 9: Innovación e Infraestructura Inclusiva</h6>
                    <p class="text-secondary small mb-2">
                        El proyecto integra pautas de diseño accesible para asegurar que cualquier estudiante consulte los recursos bibliográficos de forma equitativa.
                    </p>
                    <div class="d-flex gap-2">
                        <a href="InnovacionServlet" class="btn btn-primary btn-sm">Ver Centro ODS 9</a>
                        <button type="button" class="btn btn-outline-secondary btn-sm" onclick="toggleA11yPanel()">Configurar accesibilidad</button>
                    </div>
                </div>
                <div class="col-md-3 text-md-end mt-3 mt-md-0">
                    <span class="badge bg-light text-dark border p-2">HTML5 Web Speech API</span>
                </div>
            </div>
        </div>
    </section>


    


    <!-- FOOTER -->
    <footer class="bg-dark text-white py-4">
        <div class="container text-center">
            <p class="mb-1 fw-bold">BookHub</p>
            <p class="mb-0 small text-secondary">
                Sistema de Gestión de Biblioteca Universitaria
            </p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        function reproducirAudio(texto) {
            if (!('speechSynthesis' in window)) {
                alert('Tu navegador no cuenta con síntesis de voz.');
                return;
            }
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

        function iniciarVozHome() {
            const statusBox = document.getElementById("statusVozHome");
            const input = document.getElementById("inputBusquedaHome");
            const btn = document.getElementById("btnMicHome");
            const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;

            if (!SpeechRecognition) {
                if (statusBox) {
                    statusBox.style.display = "block";
                    statusBox.textContent = "Navegador sin soporte de reconocimiento de voz.";
                }
                return;
            }

            const rec = new SpeechRecognition();
            rec.lang = 'es-ES';
            rec.continuous = false;
            rec.interimResults = false;

            rec.onstart = function () {
                if (statusBox) {
                    statusBox.style.display = "block";
                    statusBox.textContent = "Escuchando... Di el título o autor.";
                }
                if (btn) btn.textContent = "Escuchando...";
            };

            rec.onresult = function (e) {
                const text = e.results[0][0].transcript;
                if (input) input.value = text;
                window.location.href = 'CatalogoServlet?busqueda=' + encodeURIComponent(text);
            };

            rec.onerror = function (e) {
                if (statusBox) {
                    statusBox.style.display = "block";
                    statusBox.textContent = "No se detectó audio.";
                }
            };

            rec.onend = function () {
                if (btn) btn.textContent = "Dictar";
            };

            try { rec.start(); } catch (err) {}
        }

        // Accesibilidad global administrada por a11y-panel.jsp
    </script>
<%@include file="a11y-panel.jsp"%>
</body>
</html>
