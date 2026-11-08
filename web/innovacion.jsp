<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="beans.Libro"%>
<%@page import="beans.Prestamo"%>
<%@page import="beans.Usuario"%>
<%@page import="dao.LibroDAO"%>
<%@page import="dao.PrestamoDAO"%>

<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");

    List<Libro> libros = (List<Libro>) request.getAttribute("libros");
    Map<Integer, Integer> prestamosActivosPorLibro =
            (Map<Integer, Integer>) request.getAttribute("prestamosActivosPorLibro");

    Integer librosRegistradosAttr = (Integer) request.getAttribute("librosRegistrados");
    Integer stockBajoAttr = (Integer) request.getAttribute("stockBajo");
    Integer prestamosActivosAttr = (Integer) request.getAttribute("prestamosActivos");
    Integer librosAgotadosAttr = (Integer) request.getAttribute("librosAgotados");

    // Respaldo por si se accede directamente a innovacion.jsp sin pasar por InnovacionServlet
    if (libros == null || librosRegistradosAttr == null) {
        LibroDAO libroDAO = new LibroDAO();
        PrestamoDAO prestamoDAO = new PrestamoDAO();
        libros = libroDAO.listar();
        List<Prestamo> prestamos = prestamoDAO.listar();

        prestamosActivosPorLibro = new HashMap<>();
        int calcPrestamosActivos = 0;
        for (Prestamo p : prestamos) {
            if (p.getEstado() != null && "PRESTADO".equalsIgnoreCase(p.getEstado().trim())) {
                calcPrestamosActivos++;
                int idLib = p.getIdLibro();
                prestamosActivosPorLibro.put(idLib, prestamosActivosPorLibro.getOrDefault(idLib, 0) + 1);
            }
        }

        int calcStockBajo = 0;
        int calcAgotados = 0;
        for (Libro l : libros) {
            if (l.getStock() == 0) {
                calcAgotados++;
            } else if (l.getStock() >= 1 && l.getStock() <= 2) {
                calcStockBajo++;
            }
        }

        librosRegistradosAttr = libros.size();
        stockBajoAttr = calcStockBajo;
        prestamosActivosAttr = calcPrestamosActivos;
        librosAgotadosAttr = calcAgotados;
    }

    int librosRegistrados = librosRegistradosAttr;
    int stockBajo = stockBajoAttr;
    int prestamosActivos = prestamosActivosAttr;
    int librosAgotados = librosAgotadosAttr;
%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Innovación para la Discapacidad (ODS 09) - BOOKHUB</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>
        :root {
            --ods-color: #fd6925;
            --ods-dark: #b8430e;
            --a11y-font-scale: 1;
        }

        body {
            background-color: #f5f7fa;
            font-size: calc(1rem * var(--a11y-font-scale));
            transition: background-color 0.25s ease, color 0.25s ease;
        }

        /* HERO ODS 09 INCLUSIÓN */
        .hero-innovacion {
            background: linear-gradient(135deg, #0d6efd 0%, #1a237e 60%, #fd6925 100%);
            color: #ffffff;
            padding: 55px 0 65px;
            position: relative;
            overflow: hidden;
        }

        .hero-innovacion::after {
            content: "♿";
            position: absolute;
            right: 4%;
            bottom: -35px;
            font-size: 15rem;
            opacity: 0.08;
            pointer-events: none;
        }

        .badge-ods {
            background-color: var(--ods-color);
            color: #ffffff;
            font-weight: 600;
        }

        /* TARJETAS DE IMPACTO */
        .kpi-card {
            border: 1px solid rgba(0, 0, 0, 0.07);
            border-radius: 14px;
            transition: transform 0.25s ease, box-shadow 0.25s ease;
            cursor: pointer;
            background: #ffffff;
        }

        .kpi-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 25px rgba(0, 0, 0, 0.12) !important;
        }

        .kpi-card.active-filter {
            outline: 3px solid #0d6efd;
        }

        .kpi-icon {
            width: 54px;
            height: 54px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.6rem;
        }

        .portada-tabla {
            width: 44px;
            height: 60px;
            object-fit: cover;
            border-radius: 4px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15);
        }

        /* LABORATORIO INTERACTIVO */
        .lab-card {
            border-radius: 14px;
            border: 1px solid rgba(0, 0, 0, 0.08);
            background: #ffffff;
            transition: box-shadow 0.2s ease;
        }

        .lab-card:hover {
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
        }

        /* ONDAS DE VOZ ANIMADAS */
        .sound-wave-box {
            display: inline-flex;
            align-items: center;
            gap: 3px;
            height: 20px;
            vertical-align: middle;
        }

        .sound-bar {
            width: 3px;
            height: 6px;
            background-color: #0d6efd;
            border-radius: 2px;
            animation: soundWave 1s infinite ease-in-out;
        }

        .sound-bar:nth-child(2) { animation-delay: 0.2s; }
        .sound-bar:nth-child(3) { animation-delay: 0.4s; }
        .sound-bar:nth-child(4) { animation-delay: 0.1s; }
        .sound-bar:nth-child(5) { animation-delay: 0.3s; }

        @keyframes soundWave {
            0%, 100% { height: 4px; }
            50% { height: 18px; }
        }

        /* ESTILOS DE ACCESIBILIDAD UNIVERSAL (WCAG AAA) */
        body.a11y-high-contrast {
            background-color: #000000 !important;
            color: #ffff00 !important;
        }

        body.a11y-high-contrast .card,
        body.a11y-high-contrast .navbar,
        body.a11y-high-contrast .table,
        body.a11y-high-contrast footer {
            background-color: #121212 !important;
            color: #ffffff !important;
            border-color: #ffff00 !important;
        }

        body.a11y-high-contrast a,
        body.a11y-high-contrast h1,
        body.a11y-high-contrast h2,
        body.a11y-high-contrast h3,
        body.a11y-high-contrast h4,
        body.a11y-high-contrast h5,
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

        body.a11y-dark-mode .card,
        body.a11y-dark-mode .table {
            background-color: #242a33 !important;
            color: #e4e7eb !important;
            border-color: #343d4a !important;
        }

        body.a11y-dyslexia {
            font-family: 'OpenDyslexic', 'Comic Sans MS', 'Arial Rounded MT Bold', sans-serif !important;
            letter-spacing: 0.06em !important;
            word-spacing: 0.12em !important;
            line-height: 1.8 !important;
        }

        body.a11y-highlight-focus *:focus {
            outline: 3px solid #ff9800 !important;
            outline-offset: 3px !important;
        }

        /* REGLA DE LECTURA VISUAL */
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

        /* WIDGET FLOTANTE */
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
            transition: transform 0.2s ease, background 0.2s ease;
        }

        .a11y-float-btn:hover {
            transform: scale(1.1);
            background: #e05515;
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
            animation: fadeInPanel 0.2s ease-out;
        }

        @keyframes fadeInPanel {
            from { opacity: 0; transform: translateY(12px); }
            to { opacity: 1; transform: translateY(0); }
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

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg bg-dark navbar-dark sticky-top">
    <div class="container">

        <a class="navbar-brand fw-bold" href="index.html">
            📚 BOOKHUB
        </a>

        <button class="navbar-toggler" type="button"
                data-bs-toggle="collapse"
                data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">

            <ul class="navbar-nav ms-auto align-items-lg-center">

                <li class="nav-item">
                    <a class="nav-link" href="index.html">
                        Inicio
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="CatalogoServlet">
                        Catálogo
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link active fw-bold text-warning" href="InnovacionServlet">
                        ♿ ODS 09: Inclusión
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="MisPrestamosServlet">
                        Mis préstamos
                    </a>
                </li>

                <li class="nav-item">
                    <button class="btn btn-outline-warning btn-sm ms-lg-2 my-2 my-lg-0"
                            type="button"
                            onclick="toggleA11yPanel()"
                            title="Panel de accesibilidad para personas con discapacidad">
                        ♿ Accesibilidad
                    </button>
                </li>

                <% if (usuarioSesion != null) { %>
                    <% if ("ADMIN".equals(usuarioSesion.getRol())) { %>
                        <li class="nav-item">
                            <a class="btn btn-outline-light btn-sm ms-lg-2 mt-2 mt-lg-0" href="dashboard.jsp">
                                Panel Admin
                            </a>
                        </li>
                    <% } else { %>
                        <li class="nav-item">
                            <a class="btn btn-outline-light btn-sm ms-lg-2 mt-2 mt-lg-0" href="usuario.jsp">
                                Mi cuenta (<%= usuarioSesion.getNombre() %>)
                            </a>
                        </li>
                    <% } %>
                    <li class="nav-item">
                        <a class="btn btn-danger btn-sm ms-lg-2 mt-2 mt-lg-0" href="LogoutServlet">
                            Cerrar sesión
                        </a>
                    </li>
                <% } else { %>
                    <li class="nav-item">
                        <a class="btn btn-outline-light btn-sm ms-lg-2 mt-2 mt-lg-0" href="registro.jsp">
                            Registrarse
                        </a>
                    </li>

                    <li class="nav-item">
                        <a class="btn btn-primary btn-sm ms-lg-2 mt-2 mt-lg-0" href="login.jsp">
                            Iniciar sesión
                        </a>
                    </li>
                <% } %>

            </ul>

        </div>
    </div>
</nav>


<!-- ENCABEZADO: CENTRO DE INNOVACIÓN INCLUSIVA (ODS 09) -->
<section class="hero-innovacion">
    <div class="container position-relative">
        <div class="row align-items-center">
            <div class="col-lg-8">
                <div class="d-flex align-items-center gap-2 mb-3 flex-wrap">
                    <span class="badge badge-ods px-3 py-2 fs-6">
                        🎯 ODS 09: INDUSTRIA, INNOVACIÓN E INFRAESTRUCTURA
                    </span>
                    <span class="badge bg-light text-dark px-3 py-2 fs-6">
                        ♿ TECNOLOGÍAS PARA PERSONAS CON DISCAPACIDAD
                    </span>
                </div>
                <h1 class="display-5 fw-bold mb-3">
                    Biblioteca Universitaria Inclusiva y Accesible
                </h1>
                <p class="lead mb-4 opacity-95">
                    El <strong>ODS 09 (Meta 9.c y 9.1)</strong> promueve infraestructuras tecnológicas inclusivas y acceso universal. En <strong>BookHub</strong> transformamos la lectura digital integrando <strong>síntesis de voz (Text-to-Speech)</strong>, <strong>búsqueda por reconocimiento vocal</strong>, <strong>alto contraste WCAG AAA</strong> y <strong>asistencia para dislexia</strong>, garantizando que ninguna persona se quede atrás en su formación académica.
                </p>
                <div class="d-flex flex-wrap gap-2">
                    <button class="btn btn-warning fw-bold px-4 py-2" onclick="probarVozTexto('Bienvenido a BookHub. Esta biblioteca cuenta con narración asistida por voz para personas con discapacidad visual y de lectura.')">
                        🔊 Escuchar Presentación en Audio
                    </button>
                    <a href="#laboratorioA11y" class="btn btn-outline-light px-3 py-2">
                        🧪 Probar Laboratorio Interactivo
                    </a>
                    <a href="CatalogoServlet" class="btn btn-light px-3 py-2">
                        📚 Explorar Catálogo Accesible
                    </a>
                </div>
            </div>
            <div class="col-lg-4 text-center mt-4 mt-lg-0">
                <div class="bg-white bg-opacity-10 p-4 rounded-4 border border-white border-opacity-25 shadow-sm text-start">
                    <h6 class="fw-bold text-warning mb-3">
                        ✨ Innovaciones activas en BookHub:
                    </h6>
                    <ul class="list-unstyled mb-0 small">
                        <li class="mb-2">🎧 <strong>Lector por voz (TTS):</strong> Lectura automática de sinopsis y fichas.</li>
                        <li class="mb-2">🎙️ <strong>Búsqueda por voz (STT):</strong> Consulta manos libres para discapacidad motriz.</li>
                        <li class="mb-2">🌓 <strong>Alto contraste:</strong> Adaptación visual para baja visión y daltonismo.</li>
                        <li class="mb-0">🧠 <strong>Modo Dislexia & Regla:</strong> Tipografía optimizada y guía visual.</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</section>


<!-- CONTENIDO PRINCIPAL -->
<div class="container py-5">

    <!-- 4 PILARES DE INNOVACIÓN TECNOLÓGICA INCLUSIVA (ODS 09) -->
    <div class="row g-4 mb-5">

        <!-- 1. SÍNTESIS DE VOZ Y AUDIOLIBROS -->
        <div class="col-sm-6 col-xl-3">
            <div class="card kpi-card shadow-sm h-100 border-start border-primary border-4"
                 onclick="filtrarTabla('todos', this)">
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div>
                            <p class="text-muted small fw-bold text-uppercase mb-1">
                                Cobertura Audiolibro (TTS)
                            </p>
                            <h2 class="display-5 fw-bold text-primary mb-0">
                                100%
                            </h2>
                        </div>
                        <div class="kpi-icon bg-primary bg-opacity-10 text-primary">
                            🔊
                        </div>
                    </div>
                    <p class="small text-muted mb-0">
                        Los <strong><%= librosRegistrados %> títulos</strong> cuentan con lectura sintética por voz en español para personas con baja visión o ceguera.
                    </p>
                </div>
            </div>
        </div>

        <!-- 2. BÚSQUEDA MANOS LIBRES (DICTADO) -->
        <div class="col-sm-6 col-xl-3">
            <div class="card kpi-card shadow-sm h-100 border-start border-warning border-4"
                 onclick="scrollAlLab('dictado')">
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div>
                            <p class="text-muted small fw-bold text-uppercase mb-1">
                                Búsqueda por Voz (STT)
                            </p>
                            <h2 class="display-5 fw-bold text-warning mb-0">
                                Activa
                            </h2>
                        </div>
                        <div class="kpi-icon bg-warning bg-opacity-10 text-warning">
                            🎙️
                        </div>
                    </div>
                    <p class="small text-muted mb-0">
                        Reconocimiento de voz integrado para usuarios con limitaciones motoras en extremidades superiores.
                    </p>
                </div>
            </div>
        </div>

        <!-- 3. ACCESIBILIDAD COGNITIVA & DISLEXIA -->
        <div class="col-sm-6 col-xl-3">
            <div class="card kpi-card shadow-sm h-100 border-start border-success border-4"
                 onclick="toggleDyslexiaMode()">
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div>
                            <p class="text-muted small fw-bold text-uppercase mb-1">
                                Dislexia y TDAH
                            </p>
                            <h2 class="display-5 fw-bold text-success mb-0">
                                WCAG
                            </h2>
                        </div>
                        <div class="kpi-icon bg-success bg-opacity-10 text-success">
                            🧠
                        </div>
                    </div>
                    <p class="small text-muted mb-0">
                        Fuente de alta legibilidad, interlineado amplio y regla visual de lectura para facilitar la concentración.
                    </p>
                </div>
            </div>
        </div>

        <!-- 4. RECURSOS DISPONIBLES EN PRÉSTAMO -->
        <div class="col-sm-6 col-xl-3">
            <div class="card kpi-card shadow-sm h-100 border-start border-danger border-4"
                 onclick="filtrarTabla('bajo', this)">
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div>
                            <p class="text-muted small fw-bold text-uppercase mb-1">
                                Alertas de Disponibilidad
                            </p>
                            <h2 class="display-5 fw-bold text-danger mb-0">
                                <%= stockBajo + librosAgotados %>
                            </h2>
                        </div>
                        <div class="kpi-icon bg-danger bg-opacity-10 text-danger">
                            ⚠️
                        </div>
                    </div>
                    <p class="small text-muted mb-0">
                        <strong><%= stockBajo %> en stock bajo</strong> y <strong><%= librosAgotados %> agotados</strong>. La digitalización asegura acceso universal.
                    </p>
                </div>
            </div>
        </div>

    </div>


    <!-- LABORATORIO INTERACTIVO: PRUEBA LAS TECNOLOGÍAS INCLUSIVAS ODS 09 -->
    <div id="laboratorioA11y" class="card shadow-sm border-0 mb-5">
        <div class="card-header bg-white py-3 border-bottom">
            <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
                <div>
                    <h5 class="fw-bold mb-1 text-primary">
                        🧪 Laboratorio Interactivo de Tecnologías de Asistencia (ODS 09)
                    </h5>
                    <p class="text-muted small mb-0">
                        Experimenta en vivo cómo las personas con diferentes tipos de discapacidad interactúan con BookHub.
                    </p>
                </div>
                <span class="badge bg-primary px-3 py-2">
                    Web Speech API · WCAG 2.1 AAA
                </span>
            </div>
        </div>

        <div class="card-body p-4">
            <div class="row g-4">

                <!-- HERRAMIENTA 1: AUDIOLIBRO Y SÍNTESIS DE VOZ -->
                <div class="col-md-4">
                    <div class="p-3 border rounded-3 h-100 lab-card d-flex flex-column">
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <span class="fs-4">🔊</span>
                            <h6 class="fw-bold mb-0">Síntesis de Voz (TTS)</h6>
                        </div>
                        <p class="small text-muted">
                            Asistencia para lectores con discapacidad visual o fatiga. Escucha cualquier texto con entonación natural.
                        </p>

                        <div class="mb-3">
                            <label class="form-label small fw-bold">Texto de prueba:</label>
                            <textarea id="labTtsTexto" class="form-control form-control-sm" rows="3">Cien años de soledad relata la historia de la familia Buendía en el pueblo mítico de Macondo.</textarea>
                        </div>

                        <div class="d-flex align-items-center gap-2 mb-3">
                            <label class="small text-muted">Velocidad:</label>
                            <select id="labTtsSpeed" class="form-select form-select-sm" style="width: auto;">
                                <option value="0.8">0.8x (Lenta)</option>
                                <option value="1.0" selected>1.0x (Normal)</option>
                                <option value="1.2">1.2x (Rápida)</option>
                            </select>
                        </div>

                        <div class="mt-auto d-flex gap-2">
                            <button type="button" class="btn btn-primary btn-sm flex-grow-1" onclick="ejecutarLabTTS()">
                                ▶️ Reproducir Audio
                            </button>
                            <button type="button" class="btn btn-outline-secondary btn-sm" onclick="detenerVoz()">
                                ⏹️ Parar
                            </button>
                        </div>
                    </div>
                </div>

                <!-- HERRAMIENTA 2: RECONOCIMIENTO Y BÚSQUEDA POR VOZ -->
                <div class="col-md-4">
                    <div class="p-3 border rounded-3 h-100 lab-card d-flex flex-column" id="moduloDictado">
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <span class="fs-4">🎙️</span>
                            <h6 class="fw-bold mb-0">Búsqueda Manos Libres (STT)</h6>
                        </div>
                        <p class="small text-muted">
                            Asistencia para usuarios con discapacidad física/motriz. Dicta el nombre de un libro o autor sin necesidad de teclear.
                        </p>

                        <div class="p-3 bg-light rounded-3 text-center mb-3">
                            <div id="sttEstado" class="small text-muted mb-2">
                                Presiona el botón para iniciar el dictado
                            </div>
                            <button type="button" id="btnSttLab" class="btn btn-warning rounded-circle p-3 shadow-sm" onclick="toggleSttLab()" title="Hablar">
                                🎤
                            </button>
                            <div id="sttResultado" class="fw-bold mt-2 text-primary small" style="min-height: 24px;">
                                ...
                            </div>
                        </div>

                        <div class="mt-auto">
                            <a id="btnIrACatalogoConVoz" href="CatalogoServlet" class="btn btn-outline-warning text-dark btn-sm w-100">
                                🔍 Buscar este libro en el Catálogo
                            </a>
                        </div>
                    </div>
                </div>

                <!-- HERRAMIENTA 3: ADAPTABILIDAD VISUAL Y NEURODIVERGENCIA -->
                <div class="col-md-4">
                    <div class="p-3 border rounded-3 h-100 lab-card d-flex flex-column">
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <span class="fs-4">🌓</span>
                            <h6 class="fw-bold mb-0">Diseño Visual Inclusivo</h6>
                        </div>
                        <p class="small text-muted">
                            Simula en 1 clic los filtros visuales adaptados según el tipo de necesidad sensorial del lector.
                        </p>

                        <div class="d-grid gap-2 mb-3">
                            <button type="button" class="btn btn-outline-dark btn-sm text-start" onclick="toggleHighContrast()">
                                🟡 <strong>Alto Contraste WCAG AAA</strong> (Baja visión)
                            </button>
                            <button type="button" class="btn btn-outline-secondary btn-sm text-start" onclick="toggleDyslexiaMode()">
                                📖 <strong>Modo Dislexia & TDAH</strong> (Tipografía amigable)
                            </button>
                            <button type="button" class="btn btn-outline-info text-dark btn-sm text-start" onclick="toggleReadingRuler()">
                                📏 <strong>Regla de Lectura Guiada</strong>
                            </button>
                            <button type="button" class="btn btn-outline-secondary btn-sm text-start" onclick="toggleMonochrome()">
                                ⚪ <strong>Simular Daltonismo Monocromático</strong>
                            </button>
                        </div>

                        <div class="mt-auto">
                            <button type="button" class="btn btn-light btn-sm w-100 border text-danger" onclick="restablecerA11y()">
                                ↺ Restablecer modos visuales
                            </button>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>


    <!-- CATÁLOGO CON SOPORTE DE ACCESIBILIDAD Y AUDIOLIBRO -->
    <div class="card shadow-sm border-0">
        <div class="card-header bg-white py-3 d-flex flex-wrap justify-content-between align-items-center gap-2 border-bottom">
            <div>
                <h5 class="fw-bold mb-1">
                    📚 Catálogo Inclusivo: Recursos Bibliográficos Adaptados
                </h5>
                <p class="text-muted small mb-0">
                    Todos los libros cuentan con síntesis de voz interactiva para garantizar el derecho a la lectura accesible.
                </p>
            </div>

            <div class="d-flex flex-wrap gap-2">
                <button type="button" class="btn btn-sm btn-primary btn-filtro-tabla" id="btnTodos" onclick="filtrarTabla('todos', null)">
                    Todos (<%= librosRegistrados %>)
                </button>
                <button type="button" class="btn btn-sm btn-outline-warning text-dark btn-filtro-tabla" id="btnBajo" onclick="filtrarTabla('bajo', null)">
                    Stock bajo (<%= stockBajo %>)
                </button>
                <button type="button" class="btn btn-sm btn-outline-info text-dark btn-filtro-tabla" id="btnPrestados" onclick="filtrarTabla('prestados', null)">
                    Con préstamos (<%= prestamosActivos %>)
                </button>
                <button type="button" class="btn btn-sm btn-outline-danger btn-filtro-tabla" id="btnAgotado" onclick="filtrarTabla('agotado', null)">
                    Agotados (<%= librosAgotados %>)
                </button>
            </div>
        </div>

        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-4">Recurso Bibliográfico</th>
                            <th>Categoría</th>
                            <th class="text-center">Soporte Inclusivo</th>
                            <th class="text-center">Stock Actual</th>
                            <th>Estado de Disponibilidad</th>
                            <th class="text-end pe-4">Acción Accesible</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (libros != null && !libros.isEmpty()) {
                               for (Libro libro : libros) {
                                   int stock = libro.getStock();
                                   int activosLibro = (prestamosActivosPorLibro != null)
                                           ? prestamosActivosPorLibro.getOrDefault(libro.getIdLibro(), 0)
                                           : 0;

                                   String estadoFiltro;
                                   String badgeClase;
                                   String textoEstado;

                                   if (stock == 0) {
                                       estadoFiltro = "agotado";
                                       badgeClase = "bg-danger";
                                       textoEstado = "Agotado (0 disp.)";
                                   } else if (stock >= 1 && stock <= 2) {
                                       estadoFiltro = "bajo";
                                       badgeClase = "bg-warning text-dark";
                                       textoEstado = "Stock bajo (" + stock + " disp.)";
                                   } else {
                                       estadoFiltro = "optimo";
                                       badgeClase = "bg-success";
                                       textoEstado = "Disponible (" + stock + " disp.)";
                                   }

                                   String textoParaLeer = libro.getTitulo() + ". Del autor " + libro.getNombreAutor()
                                           + ". Categoría " + libro.getNombreCategoria() + ". " + libro.getDescripcion();
                                   textoParaLeer = textoParaLeer.replace("\"", "").replace("'", "");
                        %>
                            <tr class="fila-recurso"
                                data-estado="<%= estadoFiltro %>"
                                data-prestamos="<%= activosLibro %>">
                                <td class="ps-4">
                                    <div class="d-flex align-items-center gap-3">
                                        <img src="<%= libro.getImagenPortada() %>"
                                             alt="Portada"
                                             class="portada-tabla"
                                             onerror="this.onerror=null;this.src='img/portadas/default.svg';">
                                        <div>
                                            <div class="fw-bold"><%= libro.getTitulo() %></div>
                                            <div class="text-muted small"><%= libro.getNombreAutor() %> · ISBN: <%= libro.getIsbn() %></div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <span class="badge bg-secondary">
                                        <%= libro.getNombreCategoria() %>
                                    </span>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25" title="Lectura por voz activada">
                                        🎧 Audio TTS
                                    </span>
                                    <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25" title="Texto adaptable a macrotipo">
                                        🔤 Macrotipo
                                    </span>
                                </td>
                                <td class="text-center fw-bold">
                                    <%= stock %>
                                </td>
                                <td>
                                    <span class="badge <%= badgeClase %>">
                                        <%= textoEstado %>
                                    </span>
                                    <% if (activosLibro > 0) { %>
                                        <span class="badge bg-info text-dark ms-1">
                                            <%= activosLibro %> prestados
                                        </span>
                                    <% } %>
                                </td>
                                <td class="text-end pe-4">
                                    <div class="btn-group btn-group-sm">
                                        <button type="button"
                                                class="btn btn-outline-success"
                                                onclick="probarVozTexto('<%= textoParaLeer %>')"
                                                title="Escuchar ficha del libro en voz alta">
                                            🔊 Escuchar
                                        </button>
                                        <a href="DetalleLibroServlet?id=<%= libro.getIdLibro() %>"
                                           class="btn btn-outline-primary"
                                           title="Ver ficha completa">
                                            Ficha
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        <%     }
                           } else { %>
                            <tr>
                                <td colspan="6" class="text-center py-4 text-muted">
                                    No hay libros registrados en el catálogo.
                                </td>
                            </tr>
                        <% } %>
                        <tr id="filaSinResultados" style="display: none;">
                            <td colspan="6" class="text-center py-4 text-muted">
                                No hay recursos bibliográficos en este filtro actualmente.
                            </td>
                        </tr>
                    </tbody>
                </table>
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
            <!-- TAMAÑO DE TEXTO -->
            <div class="mb-3">
                <div class="a11y-opt-title">🔠 Tamaño de texto</div>
                <div class="btn-group w-100">
                    <button type="button" class="btn btn-outline-secondary btn-sm" onclick="ajustarFuente(-0.1)">A -</button>
                    <button type="button" class="btn btn-outline-secondary btn-sm" onclick="ajustarFuente(0)">Normal</button>
                    <button type="button" class="btn btn-outline-secondary btn-sm" onclick="ajustarFuente(0.15)">A +</button>
                </div>
            </div>

            <!-- CONTRASTE Y MODOS VISUALES -->
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

            <!-- LECTURA Y NEURODIVERGENCIA -->
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

            <!-- LECTOR POR VOZ DE LA PÁGINA -->
            <div class="mb-3">
                <div class="a11y-opt-title">🗣️ Lector por Voz Asistido</div>
                <div class="d-grid gap-1">
                    <button type="button" class="btn btn-success btn-sm text-start" onclick="leerTextoPrincipal()">
                        🔊 <strong>Leer página completa</strong>
                    </button>
                    <button type="button" class="btn btn-outline-danger btn-sm text-start" onclick="detenerVoz()">
                        ⏹️ Detener audio
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


<!-- FOOTER -->
<footer class="bg-dark text-white py-4 mt-5">
    <div class="container text-center">
        <p class="mb-1">
            <strong>BOOKHUB</strong>
        </p>
        <p class="mb-0 small text-secondary">
            Sistema Web de Gestión de Biblioteca Universitaria · Centro de Innovación Tecnológica Inclusiva (ODS 09)
        </p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // ESTADO GLOBAL DE ACCESIBILIDAD (PERSISTIDO EN LOCALSTORAGE)
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
        } catch (e) {
            console.warn('Error cargando preferencias de accesibilidad:', e);
        }
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
        if (a11yState.highContrast) {
            a11yState.darkMode = false;
        }
        aplicarA11yState();
        guardarA11yPrefs();
    }

    function toggleDarkMode() {
        a11yState.darkMode = !a11yState.darkMode;
        if (a11yState.darkMode) {
            a11yState.highContrast = false;
        }
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
        detenerVoz();
    }

    // SEGUIMIENTO DE LA REGLA DE LECTURA
    document.addEventListener('mousemove', function(e) {
        const ruler = document.getElementById('a11yReadingRuler');
        if (ruler && a11yState.readingRuler) {
            ruler.style.top = e.clientY + 'px';
        }
    });

    // MOTOR DE SÍNTESIS DE VOZ (TEXT-TO-SPEECH)
    function probarVozTexto(texto, velocidad = 1.0) {
        if (!('speechSynthesis' in window)) {
            alert('Tu navegador no cuenta con soporte nativo de síntesis de voz.');
            return;
        }
        window.speechSynthesis.cancel();
        const utterance = new SpeechSynthesisUtterance(texto);
        utterance.lang = 'es-ES';
        utterance.rate = parseFloat(velocidad) || 1.0;
        utterance.pitch = 1.0;
        window.speechSynthesis.speak(utterance);
    }

    function ejecutarLabTTS() {
        const texto = document.getElementById('labTtsTexto').value;
        const vel = document.getElementById('labTtsSpeed').value;
        probarVozTexto(texto, vel);
    }

    function detenerVoz() {
        if ('speechSynthesis' in window) {
            window.speechSynthesis.cancel();
        }
    }

    function leerTextoPrincipal() {
        const contenido = document.querySelector('.hero-innovacion').innerText
            + ". " + document.querySelector('#laboratorioA11y').innerText;
        probarVozTexto(contenido, 1.0);
    }

    // MOTOR DE RECONOCIMIENTO DE VOZ (SPEECH-TO-TEXT)
    let recognition = null;
    let escuchando = false;

    function iniciarReconocimientoVoz() {
        const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
        if (!SpeechRecognition) {
            return null;
        }
        const rec = new SpeechRecognition();
        rec.lang = 'es-ES';
        rec.continuous = false;
        rec.interimResults = false;
        return rec;
    }

    function toggleSttLab() {
        if (!('SpeechRecognition' in window) && !('webkitSpeechRecognition' in window)) {
            document.getElementById('sttEstado').innerText = 'Navegador sin soporte de voz (usa Chrome o Edge).';
            return;
        }

        if (!recognition) {
            recognition = iniciarReconocimientoVoz();
            if (!recognition) return;

            recognition.onstart = function() {
                escuchando = true;
                document.getElementById('sttEstado').innerHTML = '🔴 <span class="text-danger fw-bold">Escuchando... di el libro a buscar</span>';
                document.getElementById('btnSttLab').classList.add('btn-danger');
                document.getElementById('btnSttLab').classList.remove('btn-warning');
            };

            recognition.onresult = function(event) {
                const transcript = event.results[0][0].transcript;
                document.getElementById('sttResultado').innerText = '"' + transcript + '"';
                document.getElementById('sttEstado').innerText = '✅ Texto reconocido con éxito:';
                const btnIr = document.getElementById('btnIrACatalogoConVoz');
                if (btnIr) {
                    btnIr.href = 'CatalogoServlet?busqueda=' + encodeURIComponent(transcript);
                }
            };

            recognition.onerror = function(event) {
                document.getElementById('sttEstado').innerText = '⚠️ No se pudo reconocer audio (' + event.error + '). Intenta de nuevo.';
            };

            recognition.onend = function() {
                escuchando = false;
                document.getElementById('btnSttLab').classList.remove('btn-danger');
                document.getElementById('btnSttLab').classList.add('btn-warning');
            };
        }

        if (!escuchando) {
            try {
                recognition.start();
            } catch(e) {}
        } else {
            recognition.stop();
        }
    }

    function scrollAlLab(tipo) {
        const lab = document.getElementById('laboratorioA11y');
        if (lab) {
            lab.scrollIntoView({ behavior: 'smooth' });
        }
        if (tipo === 'dictado') {
            setTimeout(() => toggleSttLab(), 600);
        }
    }

    // FILTRO DE RECURSOS EN TABLA
    function filtrarTabla(criterio, cardElemento) {
        const filas = document.querySelectorAll(".fila-recurso");
        const filaSinResultados = document.getElementById("filaSinResultados");
        let visibles = 0;

        document.querySelectorAll(".kpi-card").forEach(c => c.classList.remove("active-filter"));
        if (cardElemento) {
            cardElemento.classList.add("active-filter");
        }

        filas.forEach(fila => {
            const estado = fila.getAttribute("data-estado");
            const prestamos = parseInt(fila.getAttribute("data-prestamos") || "0", 10);
            let mostrar = false;

            if (criterio === "todos") {
                mostrar = true;
            } else if (criterio === "bajo") {
                mostrar = (estado === "bajo");
            } else if (criterio === "agotado") {
                mostrar = (estado === "agotado");
            } else if (criterio === "prestados") {
                mostrar = (prestamos > 0);
            }

            if (mostrar) {
                fila.style.display = "";
                visibles++;
            } else {
                fila.style.display = "none";
            }
        });

        if (filaSinResultados) {
            filaSinResultados.style.display = (visibles === 0) ? "" : "none";
        }
    }

    // INICIALIZAR AL CARGAR
    document.addEventListener('DOMContentLoaded', cargarA11yPrefs);
</script>

</body>
</html>
