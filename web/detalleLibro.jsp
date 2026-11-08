<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="beans.Libro"%>

<%
    Libro libro = (Libro) request.getAttribute("libro");
    if (libro == null) {
        response.sendRedirect("CatalogoServlet");
        return;
    }

    String error = request.getParameter("error");
    String exito = request.getParameter("exito");
    boolean esOds = libro.getNombreCategoria() != null
            && libro.getNombreCategoria().toUpperCase().contains("ODS 09");
    String descLimpia = (libro.getDescripcion() != null) ? libro.getDescripcion().replace("\"", "&quot;").replace("'", "") : "";
    String titLimpio = (libro.getTitulo() != null) ? libro.getTitulo().replace("\"", "&quot;").replace("'", "") : "";
    String autLimpio = (libro.getNombreAutor() != null) ? libro.getNombreAutor().replace("\"", "&quot;").replace("'", "") : "";
%>

<!DOCTYPE html>
<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title><%= libro.getTitulo()%> - BOOKHUB (ODS 09)</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
              rel="stylesheet">

        <style>
            :root {
                --a11y-font-scale: 1;
            }

            body {
                font-size: calc(1rem * var(--a11y-font-scale));
                transition: background-color 0.25s ease, color 0.25s ease;
            }

            .badge-ods {
                background-color: #fd6925;
                color: #ffffff;
            }
            .detalle-portada-box {
                background: linear-gradient(180deg, #f8f9fa 0%, #e9ecef 100%);
                border-radius: 12px;
                padding: 24px;
                text-align: center;
                border: 1px solid rgba(0, 0, 0, 0.08);
            }
            .detalle-portada-img {
                max-height: 330px;
                width: auto;
                max-width: 100%;
                border-radius: 8px;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.22);
            }

            /* PANEL AUDIOLIBRO ODS 09 */
            .audio-player-card {
                background: linear-gradient(135deg, #f8f9fa, #e9ecef);
                border: 2px solid #fd6925;
                border-radius: 12px;
                padding: 16px 20px;
            }

            .sound-wave-box {
                display: none;
                align-items: center;
                gap: 4px;
                height: 24px;
            }
            .sound-bar {
                width: 4px;
                height: 8px;
                background-color: #fd6925;
                border-radius: 2px;
                animation: soundWave 0.8s infinite ease-in-out;
            }
            .sound-bar:nth-child(2) { animation-delay: 0.15s; }
            .sound-bar:nth-child(3) { animation-delay: 0.3s; }
            .sound-bar:nth-child(4) { animation-delay: 0.45s; }
            .sound-bar:nth-child(5) { animation-delay: 0.2s; }
            @keyframes soundWave {
                0%, 100% { height: 6px; }
                50% { height: 22px; }
            }

            /* ACCESIBILIDAD UNIVERSAL */
            body.a11y-high-contrast {
                background-color: #000000 !important;
                color: #ffff00 !important;
            }
            body.a11y-high-contrast .card,
            body.a11y-high-contrast .navbar,
            body.a11y-high-contrast footer {
                background-color: #121212 !important;
                color: #ffffff !important;
                border-color: #ffff00 !important;
            }
            body.a11y-high-contrast a,
            body.a11y-high-contrast h1,
            body.a11y-high-contrast h2,
            body.a11y-high-contrast h3,
            body.a11y-high-contrast strong {
                color: #ffff00 !important;
            }
            body.a11y-high-contrast .btn-primary {
                background-color: #ffff00 !important;
                color: #000000 !important;
                border-color: #ffff00 !important;
                font-weight: bold;
            }
            body.a11y-monochrome {
                filter: grayscale(100%) !important;
            }
            body.a11y-dark-mode {
                background-color: #1a1e24 !important;
                color: #e4e7eb !important;
            }
            body.a11y-dark-mode .card {
                background-color: #242a33 !important;
                color: #e4e7eb !important;
                border-color: #343d4a !important;
            }
            body.a11y-dyslexia {
                font-family: 'OpenDyslexic', 'Comic Sans MS', sans-serif !important;
                letter-spacing: 0.06em !important;
                word-spacing: 0.12em !important;
                line-height: 1.8 !important;
            }
            body.a11y-highlight-focus *:focus {
                outline: 3px solid #ff9800 !important;
                outline-offset: 3px !important;
            }

            #a11yReadingRuler {
                display: none;
                position: fixed;
                left: 0;
                width: 100vw;
                height: 38px;
                background: rgba(253, 105, 37, 0.18);
                border-top: 2px dashed #fd6925;
                border-bottom: 2px dashed #fd6925;
                pointer-events: none;
                z-index: 99999;
                transform: translateY(-50%);
            }

            .a11y-float-btn {
                position: fixed;
                bottom: 25px;
                right: 25px;
                width: 58px;
                height: 58px;
                border-radius: 50%;
                background: #fd6925;
                color: #ffffff;
                border: 3px solid #ffffff;
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.28);
                font-size: 1.6rem;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                z-index: 9999;
                transition: transform 0.2s ease;
            }
            .a11y-float-btn:hover {
                transform: scale(1.1);
            }
            .a11y-float-badge {
                position: absolute;
                top: -4px;
                right: -4px;
                background: #0d6efd;
                color: #ffffff;
                font-size: 0.65rem;
                font-weight: bold;
                padding: 2px 6px;
                border-radius: 10px;
                border: 1px solid #ffffff;
            }
            .a11y-panel {
                position: fixed;
                bottom: 95px;
                right: 25px;
                width: 340px;
                max-width: 90vw;
                background: #ffffff;
                border-radius: 16px;
                border: 1px solid rgba(0, 0, 0, 0.12);
                box-shadow: 0 16px 36px rgba(0, 0, 0, 0.22);
                z-index: 9999;
                overflow: hidden;
                display: none;
            }
            .a11y-panel-header {
                background: linear-gradient(135deg, #fd6925, #0d6efd);
                color: #ffffff;
                padding: 14px 18px;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }
            .a11y-panel-body {
                padding: 16px;
                max-height: 480px;
                overflow-y: auto;
            }
            .a11y-opt-title {
                font-size: 0.78rem;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                color: #6c757d;
                margin-bottom: 6px;
            }
        </style>

    </head>

    <body class="bg-light">

        <!-- NAVBAR -->
        <nav class="navbar navbar-dark bg-primary sticky-top">

            <div class="container">

                <a class="navbar-brand fw-bold"
                   href="index.html">
                    📚 BOOKHUB
                </a>

                <div class="d-flex align-items-center gap-2">
                    <a href="InnovacionServlet"
                       class="btn btn-outline-warning text-white fw-bold btn-sm">
                        ♿ ODS 09: Inclusión
                    </a>
                    <button type="button"
                            class="btn btn-warning btn-sm fw-bold text-dark"
                            onclick="toggleA11yPanel()">
                        ♿ Accesibilidad
                    </button>
                    <a href="MisPrestamosServlet"
                       class="btn btn-outline-light btn-sm">
                        Mis préstamos
                    </a>
                    <a href="CatalogoServlet"
                       class="btn btn-light btn-sm">
                        ← Volver al catálogo
                    </a>
                </div>

            </div>

        </nav>


        <div class="container py-5">

            <div class="row justify-content-center">

                <div class="col-md-10">

                    <% if ("prestado".equals(exito)) { %>
                        <div class="alert alert-success">
                            ✅ <strong>¡Préstamo registrado exitosamente!</strong> Tienes 7 días para devolver el ejemplar. Puedes consultarlo en <a href="MisPrestamosServlet" class="alert-link">Mis préstamos</a>.
                        </div>
                    <% } else if ("yaPrestado".equals(error)) { %>
                        <div class="alert alert-warning">
                            ⚠️ Ya tienes un préstamo activo de este libro. Revisa <a href="MisPrestamosServlet" class="alert-link">Mis préstamos</a>.
                        </div>
                    <% } else if ("sinStock".equals(error)) { %>
                        <div class="alert alert-danger">
                            ❌ Lo sentimos, este libro no cuenta con ejemplares disponibles en este momento.
                        </div>
                    <% } %>

                    <div class="card shadow-sm">

                        <div class="card-body p-4 p-md-5">

                            <div class="row g-4 align-items-start">

                                <!-- COLUMNA PORTADA -->
                                <div class="col-md-4">
                                    <div class="detalle-portada-box">
                                        <img src="<%= libro.getImagenPortada() %>"
                                             alt="Portada de <%= libro.getTitulo() %>"
                                             class="detalle-portada-img"
                                             onerror="this.onerror=null;this.src='img/portadas/default.svg';">
                                    </div>

                                    <!-- DISTINTIVOS DE ACCESIBILIDAD ODS 09 -->
                                    <div class="mt-3 p-3 bg-light rounded-3 text-start small border">
                                        <div class="fw-bold text-primary mb-2">
                                            ♿ Formatos Inclusivos (ODS 09):
                                        </div>
                                        <div class="d-flex flex-wrap gap-1 mb-1">
                                            <span class="badge bg-success">🎧 Audiolibro TTS</span>
                                            <span class="badge bg-primary">🔤 Macrotipo</span>
                                            <span class="badge bg-info text-dark">🧠 Lectura Fácil</span>
                                        </div>
                                        <span class="text-muted" style="font-size: 0.78rem;">
                                            Adaptable para personas con discapacidad visual, auditiva o motriz.
                                        </span>
                                    </div>
                                </div>

                                <!-- COLUMNA INFORMACIÓN -->
                                <div class="col-md-8">

                                    <div class="d-flex align-items-center gap-2 mb-2">
                                        <span class="badge <%= esOds ? "badge-ods" : "bg-primary" %>">
                                            <%= libro.getNombreCategoria() %>
                                        </span>
                                        <span class="badge bg-warning text-dark fw-bold">
                                            ODS 09 Inclusivo
                                        </span>
                                    </div>

                                    <h2 class="fw-bold mb-3">
                                        <%= libro.getTitulo()%>
                                    </h2>

                                    <!-- REPRODUCTOR DE AUDIOLIBRO INTEGRADO ODS 09 -->
                                    <div class="audio-player-card mb-4 shadow-sm">
                                        <div class="d-flex align-items-center justify-content-between mb-2 flex-wrap gap-2">
                                            <div class="d-flex align-items-center gap-2">
                                                <span class="fs-4">🎧</span>
                                                <div>
                                                    <h6 class="mb-0 fw-bold">Audiolibro & Lectura Asistida</h6>
                                                    <small class="text-muted">Narración por voz en tiempo real para baja visión y ceguera</small>
                                                </div>
                                            </div>

                                            <div class="sound-wave-box" id="soundWaves">
                                                <div class="sound-bar"></div>
                                                <div class="sound-bar"></div>
                                                <div class="sound-bar"></div>
                                                <div class="sound-bar"></div>
                                                <div class="sound-bar"></div>
                                            </div>
                                        </div>

                                        <div class="d-flex align-items-center gap-2 flex-wrap mt-2">
                                            <button type="button" class="btn btn-success fw-bold" id="btnPlayAudio" onclick="reproducirAudioLibro()">
                                                ▶️ Escuchar Libro
                                            </button>
                                            <button type="button" class="btn btn-outline-warning text-dark" id="btnPauseAudio" onclick="pausarAudioLibro()" style="display:none;">
                                                ⏸️ Pausar
                                            </button>
                                            <button type="button" class="btn btn-outline-danger" id="btnStopAudio" onclick="detenerAudioLibro()" style="display:none;">
                                                ⏹️ Detener
                                            </button>

                                            <div class="ms-auto d-flex align-items-center gap-1">
                                                <small class="text-muted me-1">Velocidad:</small>
                                                <select id="audioSpeed" class="form-select form-select-sm" style="width: auto;" onchange="cambiarVelocidadAudio()">
                                                    <option value="0.8">0.8x</option>
                                                    <option value="1.0" selected>1.0x</option>
                                                    <option value="1.2">1.2x</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-4 fw-bold">Autor</div>
                                        <div class="col-md-8"><%= libro.getNombreAutor() %></div>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-4 fw-bold">Categoría</div>
                                        <div class="col-md-8"><%= libro.getNombreCategoria() %></div>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-4 fw-bold">ISBN</div>
                                        <div class="col-md-8"><%= libro.getIsbn()%></div>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-4 fw-bold">Año de publicación</div>
                                        <div class="col-md-8"><%= libro.getAnio()%></div>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-4 fw-bold">Descripción</div>
                                        <div class="col-md-8 text-secondary lh-base" id="textoDescripcion">
                                            <%= libro.getDescripcion()%>
                                        </div>
                                    </div>

                                    <div class="row mb-4">
                                        <div class="col-md-4 fw-bold">Disponibilidad</div>
                                        <div class="col-md-8">
                                            <% if (libro.getStock() > 0) {%>
                                                <span class="badge bg-success">
                                                    Disponible
                                                </span>
                                                <span class="ms-2">
                                                    <%= libro.getStock()%> ejemplares físicos
                                                </span>
                                            <% } else { %>
                                                <span class="badge bg-danger">
                                                    No disponible
                                                </span>
                                            <% } %>
                                        </div>
                                    </div>

                                    <hr>

                                    <div class="d-flex flex-wrap gap-2">
                                        <% if (libro.getStock() > 0) { %>
                                            <a href="SolicitarPrestamoServlet?idLibro=<%= libro.getIdLibro() %>"
                                               class="btn btn-primary px-4">
                                                📖 Solicitar préstamo
                                            </a>
                                        <% } else { %>
                                            <button class="btn btn-secondary" disabled>
                                                Libro no disponible
                                            </button>
                                        <% } %>

                                        <a href="CatalogoServlet"
                                           class="btn btn-outline-secondary">
                                            ← Volver al catálogo
                                        </a>

                                        <a href="InnovacionServlet"
                                           class="btn btn-outline-warning text-dark">
                                            ♿ Centro ODS 09
                                        </a>
                                    </div>

                                </div>

                            </div>

                        </div>

                    </div>

                </div>

            </div>

        </div>


        <!-- REGLA DE LECTURA VISUAL (TDAH / DISLEXIA) -->
        <div id="a11yReadingRuler"></div>


        <!-- WIDGET FLOTANTE DE ACCESIBILIDAD UNIVERSAL (ODS 09) -->
        <div id="bookhubA11yWidget">
            <button class="a11y-float-btn"
                    id="btnA11yToggle"
                    type="button"
                    onclick="toggleA11yPanel()"
                    aria-label="Abrir panel de accesibilidad ODS 09"
                    title="Herramientas de Accesibilidad Universal ODS 09">
                ♿
                <span class="a11y-float-badge">ODS 9</span>
            </button>

            <div class="a11y-panel shadow-lg" id="a11yPanel">
                <div class="a11y-panel-header">
                    <div class="d-flex align-items-center gap-2">
                        <span class="fs-5">♿</span>
                        <div>
                            <h6 class="mb-0 fw-bold">Inclusión & Accesibilidad</h6>
                            <small class="opacity-75">ODS 09 · BookHub</small>
                        </div>
                    </div>
                    <button type="button" class="btn-close btn-close-white" onclick="toggleA11yPanel()" aria-label="Cerrar"></button>
                </div>

                <div class="a11y-panel-body">
                    <div class="mb-3">
                        <div class="a11y-opt-title">🔠 Tamaño de texto</div>
                        <div class="btn-group w-100">
                            <button type="button" class="btn btn-outline-secondary btn-sm" onclick="ajustarFuente(-0.1)">A -</button>
                            <button type="button" class="btn btn-outline-secondary btn-sm" onclick="ajustarFuente(0)">Normal</button>
                            <button type="button" class="btn btn-outline-secondary btn-sm" onclick="ajustarFuente(0.15)">A +</button>
                        </div>
                    </div>

                    <div class="mb-3">
                        <div class="a11y-opt-title">🌓 Visión y Contraste</div>
                        <div class="d-grid gap-1">
                            <button type="button" class="btn btn-outline-dark btn-sm text-start" onclick="toggleHighContrast()">
                                🟡 <strong>Alto contraste</strong> (Baja visión)
                            </button>
                            <button type="button" class="btn btn-outline-dark btn-sm text-start" onclick="toggleDarkMode()">
                                🌑 <strong>Modo Oscuro suave</strong> (Fotofobia)
                            </button>
                            <button type="button" class="btn btn-outline-dark btn-sm text-start" onclick="toggleMonochrome()">
                                ⚪ <strong>Monocromático</strong> (Daltonismo)
                            </button>
                        </div>
                    </div>

                    <div class="mb-3">
                        <div class="a11y-opt-title">🧠 Neurodivergencia & Lectura</div>
                        <div class="d-grid gap-1">
                            <button type="button" class="btn btn-outline-primary btn-sm text-start" onclick="toggleDyslexiaMode()">
                                📖 <strong>Fuente para Dislexia</strong>
                            </button>
                            <button type="button" class="btn btn-outline-primary btn-sm text-start" onclick="toggleReadingRuler()">
                                📏 <strong>Regla guía de lectura</strong>
                            </button>
                            <button type="button" class="btn btn-outline-secondary btn-sm text-start" onclick="toggleFocusHighlight()">
                                🎯 <strong>Resaltar foco del teclado (Tab)</strong>
                            </button>
                        </div>
                    </div>

                    <div class="pt-2 text-center border-top">
                        <button type="button" class="btn btn-link btn-sm text-danger text-decoration-none" onclick="restablecerA11y()">
                            ↺ Restablecer valores por defecto
                        </button>
                    </div>
                </div>
            </div>
        </div>


        <footer class="bg-dark text-white text-center py-4 mt-5">
            <p class="mb-0 small">
                © 2026 BOOKHUB - Biblioteca Universitaria Inclusiva · ODS 09 Tecnologías para la Discapacidad
            </p>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <!-- MOTOR DE AUDIOLIBRO Y ACCESIBILIDAD -->
        <script>
            const textoCompletoLibro = "Libro: <%= titLimpio %>. Escrito por: <%= autLimpio %>. Publicado en el año <%= libro.getAnio() %>. <%= descLimpia %>";
            let audioPausado = false;

            function reproducirAudioLibro() {
                if (!('speechSynthesis' in window)) {
                    alert('Tu navegador no cuenta con soporte para reproducir audio por voz.');
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
                        document.getElementById('btnPauseAudio').textContent = '▶️ Reanudar';
                        document.getElementById('soundWaves').style.display = 'none';
                    } else if (window.speechSynthesis.paused) {
                        window.speechSynthesis.resume();
                        audioPausado = false;
                        document.getElementById('btnPauseAudio').textContent = '⏸️ Pausar';
                        document.getElementById('soundWaves').style.display = 'inline-flex';
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
                document.getElementById('btnPauseAudio').textContent = '⏸️ Pausar';
                document.getElementById('btnStopAudio').style.display = 'inline-block';
                document.getElementById('soundWaves').style.display = 'inline-flex';
            }

            function actualizarUIDetenido() {
                document.getElementById('btnPlayAudio').style.display = 'inline-block';
                document.getElementById('btnPauseAudio').style.display = 'none';
                document.getElementById('btnStopAudio').style.display = 'none';
                document.getElementById('soundWaves').style.display = 'none';
                audioPausado = false;
            }

            // ACCESIBILIDAD GLOBAL
            let a11yState = {
                fontScale: 1,
                highContrast: false,
                darkMode: false,
                monochrome: false,
                dyslexia: false,
                readingRuler: false,
                focusHighlight: false
            };

            function cargarA11yPrefs() {
                try {
                    const guardado = localStorage.getItem('bookhub_a11y_prefs');
                    if (guardado) {
                        a11yState = Object.assign(a11yState, JSON.parse(guardado));
                        aplicarA11yState();
                    }
                } catch (e) {}
            }

            function guardarA11yPrefs() {
                try {
                    localStorage.setItem('bookhub_a11y_prefs', JSON.stringify(a11yState));
                } catch (e) {}
            }

            function aplicarA11yState() {
                document.documentElement.style.setProperty('--a11y-font-scale', a11yState.fontScale);
                document.body.classList.toggle('a11y-high-contrast', !!a11yState.highContrast);
                document.body.classList.toggle('a11y-dark-mode', !!a11yState.darkMode);
                document.body.classList.toggle('a11y-monochrome', !!a11yState.monochrome);
                document.body.classList.toggle('a11y-dyslexia', !!a11yState.dyslexia);
                document.body.classList.toggle('a11y-highlight-focus', !!a11yState.focusHighlight);

                const ruler = document.getElementById('a11yReadingRuler');
                if (ruler) {
                    ruler.style.display = a11yState.readingRuler ? 'block' : 'none';
                }
            }

            function toggleA11yPanel() {
                const panel = document.getElementById('a11yPanel');
                if (panel) {
                    panel.style.display = (panel.style.display === 'block') ? 'none' : 'block';
                }
            }

            function ajustarFuente(delta) {
                if (delta === 0) {
                    a11yState.fontScale = 1;
                } else {
                    a11yState.fontScale = Math.min(1.4, Math.max(0.85, a11yState.fontScale + delta));
                }
                aplicarA11yState();
                guardarA11yPrefs();
            }

            function toggleHighContrast() {
                a11yState.highContrast = !a11yState.highContrast;
                if (a11yState.highContrast) a11yState.darkMode = false;
                aplicarA11yState();
                guardarA11yPrefs();
            }

            function toggleDarkMode() {
                a11yState.darkMode = !a11yState.darkMode;
                if (a11yState.darkMode) a11yState.highContrast = false;
                aplicarA11yState();
                guardarA11yPrefs();
            }

            function toggleMonochrome() {
                a11yState.monochrome = !a11yState.monochrome;
                aplicarA11yState();
                guardarA11yPrefs();
            }

            function toggleDyslexiaMode() {
                a11yState.dyslexia = !a11yState.dyslexia;
                aplicarA11yState();
                guardarA11yPrefs();
            }

            function toggleReadingRuler() {
                a11yState.readingRuler = !a11yState.readingRuler;
                aplicarA11yState();
                guardarA11yPrefs();
            }

            function toggleFocusHighlight() {
                a11yState.focusHighlight = !a11yState.focusHighlight;
                aplicarA11yState();
                guardarA11yPrefs();
            }

            function restablecerA11y() {
                a11yState = {
                    fontScale: 1,
                    highContrast: false,
                    darkMode: false,
                    monochrome: false,
                    dyslexia: false,
                    readingRuler: false,
                    focusHighlight: false
                };
                aplicarA11yState();
                guardarA11yPrefs();
                detenerAudioLibro();
            }

            document.addEventListener('mousemove', function(e) {
                const ruler = document.getElementById('a11yReadingRuler');
                if (ruler && a11yState.readingRuler) {
                    ruler.style.top = e.clientY + 'px';
                }
            });

            document.addEventListener('DOMContentLoaded', cargarA11yPrefs);
        </script>

    </body>

</html>
