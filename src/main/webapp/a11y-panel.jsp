<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- =====================================================================
     SISTEMA UNIVERSAL DE ACCESIBILIDAD BOOKHUB (WCAG 2.1 NIVEL AAA)
     Compatible con todas las vistas de Administrador, Usuario y Visitante
     ===================================================================== -->
<style id="a11yGlobalStyles">
    :root {
        --a11y-font-scale: 1;
        --a11y-line-height: 1.5;
    }

    /* -------------------------------------------------------------
       1. MODO SEPIA (Lectura Cálida y Protección Ocular)
       ------------------------------------------------------------- */
    body.a11y-theme-sepia, html.a11y-theme-sepia {
        background-color: #fbf0d9 !important;
        color: #3d2b1f !important;
    }
    body.a11y-theme-sepia .card,
    body.a11y-theme-sepia .modal-content,
    body.a11y-theme-sepia .navbar,
    body.a11y-theme-sepia footer,
    body.a11y-theme-sepia .hero,
    body.a11y-theme-sepia .book-card,
    body.a11y-theme-sepia .ods-card,
    body.a11y-theme-sepia .home-cover-wrapper,
    body.a11y-theme-sepia .book-cover-wrapper,
    body.a11y-theme-sepia .detalle-portada-box,
    body.a11y-theme-sepia .audio-player-card,
    body.a11y-theme-sepia .stat-card,
    body.a11y-theme-sepia .bg-light,
    body.a11y-theme-sepia .bg-white,
    body.a11y-theme-sepia .list-group-item {
        background: #f4e6c0 !important;
        background-color: #f4e6c0 !important;
        color: #3d2b1f !important;
        border-color: #dfcca4 !important;
    }
    body.a11y-theme-sepia h1, body.a11y-theme-sepia h2, body.a11y-theme-sepia h3,
    body.a11y-theme-sepia h4, body.a11y-theme-sepia h5, body.a11y-theme-sepia h6,
    body.a11y-theme-sepia strong, body.a11y-theme-sepia th, body.a11y-theme-sepia b {
        color: #261a12 !important;
    }
    body.a11y-theme-sepia p, body.a11y-theme-sepia span, body.a11y-theme-sepia td,
    body.a11y-theme-sepia li, body.a11y-theme-sepia label, body.a11y-theme-sepia div {
        color: #3d2b1f !important;
    }
    body.a11y-theme-sepia .text-muted, body.a11y-theme-sepia .text-secondary,
    body.a11y-theme-sepia .text-dark, body.a11y-theme-sepia .text-black-50,
    body.a11y-theme-sepia .text-white-50 {
        color: #6c4e38 !important;
    }
    body.a11y-theme-sepia .form-control, body.a11y-theme-sepia .form-select,
    body.a11y-theme-sepia .input-group-text {
        background-color: #fbf0d9 !important;
        color: #3d2b1f !important;
        border-color: #bfa67c !important;
    }
    body.a11y-theme-sepia a {
        color: #8b3a00 !important;
    }
    body.a11y-theme-sepia .btn-primary {
        background-color: #8b3a00 !important;
        border-color: #8b3a00 !important;
        color: #ffffff !important;
    }
    body.a11y-theme-sepia .btn-outline-primary,
    body.a11y-theme-sepia .btn-outline-secondary {
        border-color: #8b3a00 !important;
        color: #8b3a00 !important;
        background-color: transparent !important;
    }
    body.a11y-theme-sepia .table {
        color: #3d2b1f !important;
        background-color: #fbf0d9 !important;
        border-color: #dfcca4 !important;
    }
    body.a11y-theme-sepia .table th {
        background-color: #edd9a9 !important;
        color: #261a12 !important;
    }
    body.a11y-theme-sepia .badge {
        background-color: #dfcca4 !important;
        color: #261a12 !important;
        border: 1px solid #bfa67c !important;
    }

    /* -------------------------------------------------------------
       2. MODO NOCHE / PIZARRA OSCURA (Alto Contraste y Calibración Total)
       ------------------------------------------------------------- */
    body.a11y-theme-dark, html.a11y-theme-dark {
        background-color: #0b1120 !important;
        color: #f8fafc !important;
    }
    body.a11y-theme-dark .card,
    body.a11y-theme-dark .modal-content,
    body.a11y-theme-dark .navbar,
    body.a11y-theme-dark footer,
    body.a11y-theme-dark .hero,
    body.a11y-theme-dark .book-card,
    body.a11y-theme-dark .ods-card,
    body.a11y-theme-dark .home-cover-wrapper,
    body.a11y-theme-dark .book-cover-wrapper,
    body.a11y-theme-dark .detalle-portada-box,
    body.a11y-theme-dark .audio-player-card,
    body.a11y-theme-dark .stat-card,
    body.a11y-theme-dark .bg-light,
    body.a11y-theme-dark .bg-white,
    body.a11y-theme-dark .list-group-item,
    body.a11y-theme-dark .dropdown-menu {
        background: #1e293b !important;
        background-color: #1e293b !important;
        color: #f8fafc !important;
        border-color: #334155 !important;
    }
    body.a11y-theme-dark h1, body.a11y-theme-dark h2, body.a11y-theme-dark h3,
    body.a11y-theme-dark h4, body.a11y-theme-dark h5, body.a11y-theme-dark h6,
    body.a11y-theme-dark strong, body.a11y-theme-dark th, body.a11y-theme-dark b {
        color: #ffffff !important;
    }
    body.a11y-theme-dark p, body.a11y-theme-dark span, body.a11y-theme-dark td,
    body.a11y-theme-dark li, body.a11y-theme-dark label, body.a11y-theme-dark div {
        color: #f1f5f9 !important;
    }
    body.a11y-theme-dark .text-muted, body.a11y-theme-dark .text-secondary,
    body.a11y-theme-dark .text-dark, body.a11y-theme-dark .text-black-50,
    body.a11y-theme-dark .text-white-50 {
        color: #cbd5e1 !important; /* Texto legible claro, nunca gris oscuro */
    }
    body.a11y-theme-dark .form-control, body.a11y-theme-dark .form-select,
    body.a11y-theme-dark .input-group-text {
        background-color: #0f172a !important;
        color: #f8fafc !important;
        border-color: #475569 !important;
    }
    body.a11y-theme-dark .form-control::placeholder,
    body.a11y-theme-dark input::placeholder,
    body.a11y-theme-dark textarea::placeholder {
        color: #94a3b8 !important;
    }
    body.a11y-theme-dark a {
        color: #60a5fa !important;
    }
    body.a11y-theme-dark .dropdown-item {
        color: #f8fafc !important;
    }
    body.a11y-theme-dark .dropdown-item:hover,
    body.a11y-theme-dark .dropdown-item:focus {
        background-color: #334155 !important;
        color: #ffffff !important;
    }
    body.a11y-theme-dark .table {
        color: #f8fafc !important;
        background-color: #1e293b !important;
        border-color: #334155 !important;
    }
    body.a11y-theme-dark .table th {
        background-color: #0f172a !important;
        color: #93c5fd !important;
        border-color: #334155 !important;
    }
    body.a11y-theme-dark .table td {
        background-color: #1e293b !important;
        color: #f8fafc !important;
        border-color: #334155 !important;
    }
    body.a11y-theme-dark .table-striped>tbody>tr:nth-of-type(odd)>* {
        background-color: #162032 !important;
        color: #f8fafc !important;
    }
    body.a11y-theme-dark .table-hover>tbody>tr:hover>* {
        background-color: #273549 !important;
        color: #ffffff !important;
    }
    body.a11y-theme-dark .badge {
        background-color: #334155 !important;
        color: #ffffff !important;
        border: 1px solid #475569 !important;
    }
    body.a11y-theme-dark .badge.bg-success {
        background-color: #065f46 !important;
        color: #a7f3d0 !important;
        border: 1px solid #10b981 !important;
    }
    body.a11y-theme-dark .badge.bg-danger {
        background-color: #7f1d1d !important;
        color: #fecaca !important;
        border: 1px solid #ef4444 !important;
    }
    body.a11y-theme-dark .badge.bg-warning {
        background-color: #78350f !important;
        color: #fde68a !important;
        border: 1px solid #f59e0b !important;
    }
    body.a11y-theme-dark .badge.bg-info {
        background-color: #0c4a6e !important;
        color: #bae6fd !important;
        border: 1px solid #0ea5e9 !important;
    }
    body.a11y-theme-dark .alert {
        background-color: #1e293b !important;
        border-color: #475569 !important;
        color: #f8fafc !important;
    }
    body.a11y-theme-dark .alert-info { border-left: 4px solid #38bdf8 !important; }
    body.a11y-theme-dark .alert-success { border-left: 4px solid #34d399 !important; }
    body.a11y-theme-dark .alert-warning { border-left: 4px solid #fbbf24 !important; }
    body.a11y-theme-dark .alert-danger { border-left: 4px solid #f87171 !important; }

    /* -------------------------------------------------------------
       3. MODO ALTO CONTRASTE (WCAG AAA - Amarillo Puro y Blanco sobre Negro)
       ------------------------------------------------------------- */
    body.a11y-theme-contrast, html.a11y-theme-contrast {
        background-color: #000000 !important;
        color: #ffffff !important;
    }
    body.a11y-theme-contrast .card,
    body.a11y-theme-contrast .modal-content,
    body.a11y-theme-contrast .navbar,
    body.a11y-theme-contrast footer,
    body.a11y-theme-contrast .hero,
    body.a11y-theme-contrast .book-card,
    body.a11y-theme-contrast .ods-card,
    body.a11y-theme-contrast .home-cover-wrapper,
    body.a11y-theme-contrast .book-cover-wrapper,
    body.a11y-theme-contrast .detalle-portada-box,
    body.a11y-theme-contrast .audio-player-card,
    body.a11y-theme-contrast .stat-card,
    body.a11y-theme-contrast .bg-light,
    body.a11y-theme-contrast .bg-white,
    body.a11y-theme-contrast .list-group-item,
    body.a11y-theme-contrast .dropdown-menu {
        background: #000000 !important;
        background-color: #000000 !important;
        color: #ffffff !important;
        border: 2px solid #ffff00 !important;
    }
    body.a11y-theme-contrast h1, body.a11y-theme-contrast h2, body.a11y-theme-contrast h3,
    body.a11y-theme-contrast h4, body.a11y-theme-contrast h5, body.a11y-theme-contrast h6,
    body.a11y-theme-contrast strong, body.a11y-theme-contrast th, body.a11y-theme-contrast b,
    body.a11y-theme-contrast dt {
        color: #ffff00 !important;
        font-weight: 700 !important;
    }
    body.a11y-theme-contrast p, body.a11y-theme-contrast span, body.a11y-theme-contrast td,
    body.a11y-theme-contrast li, body.a11y-theme-contrast label, body.a11y-theme-contrast div,
    body.a11y-theme-contrast dd {
        color: #ffffff !important;
    }
    body.a11y-theme-contrast .text-muted, body.a11y-theme-contrast .text-secondary,
    body.a11y-theme-contrast .text-dark, body.a11y-theme-contrast .text-black-50,
    body.a11y-theme-contrast .text-white-50 {
        color: #ffffff !important;
        font-weight: 600 !important;
    }
    body.a11y-theme-contrast .form-control, body.a11y-theme-contrast .form-select,
    body.a11y-theme-contrast .input-group-text {
        background-color: #000000 !important;
        color: #ffff00 !important;
        border: 2px solid #ffff00 !important;
        font-weight: bold !important;
    }
    body.a11y-theme-contrast .form-control::placeholder,
    body.a11y-theme-contrast input::placeholder,
    body.a11y-theme-contrast textarea::placeholder {
        color: #ffff00 !important;
        opacity: 0.8 !important;
    }
    body.a11y-theme-contrast a {
        color: #00ffff !important;
        text-decoration: underline !important;
        font-weight: 700 !important;
    }
    body.a11y-theme-contrast .dropdown-item {
        color: #ffffff !important;
    }
    body.a11y-theme-contrast .dropdown-item:hover,
    body.a11y-theme-contrast .dropdown-item:focus {
        background-color: #ffff00 !important;
        color: #000000 !important;
        font-weight: bold !important;
    }
    body.a11y-theme-contrast .btn-primary {
        background-color: #ffff00 !important;
        border: 2px solid #ffff00 !important;
        color: #000000 !important;
        font-weight: 800 !important;
    }
    body.a11y-theme-contrast .btn-outline-primary,
    body.a11y-theme-contrast .btn-outline-secondary,
    body.a11y-theme-contrast .btn-outline-light,
    body.a11y-theme-contrast .btn-outline-dark,
    body.a11y-theme-contrast .btn-secondary,
    body.a11y-theme-contrast .btn-light {
        background-color: #000000 !important;
        border: 2px solid #ffff00 !important;
        color: #ffff00 !important;
        font-weight: bold !important;
    }
    body.a11y-theme-contrast .table {
        color: #ffffff !important;
        background-color: #000000 !important;
        border: 2px solid #ffff00 !important;
    }
    body.a11y-theme-contrast .table th {
        background-color: #111111 !important;
        color: #ffff00 !important;
        border: 1px solid #ffff00 !important;
    }
    body.a11y-theme-contrast .table td {
        background-color: #000000 !important;
        color: #ffffff !important;
        border: 1px solid #ffff00 !important;
    }
    body.a11y-theme-contrast .table-striped>tbody>tr:nth-of-type(odd)>* {
        background-color: #111111 !important;
        color: #ffffff !important;
    }
    body.a11y-theme-contrast .table-hover>tbody>tr:hover>* {
        background-color: #222222 !important;
        color: #ffff00 !important;
    }
    body.a11y-theme-contrast .badge {
        background-color: #000000 !important;
        color: #ffff00 !important;
        border: 2px solid #ffff00 !important;
        font-weight: 800 !important;
    }
    body.a11y-theme-contrast .alert {
        background-color: #000000 !important;
        border: 2px solid #ffff00 !important;
        color: #ffffff !important;
    }

    /* -------------------------------------------------------------
       4. ESCALADOR TIPOGRÁFICO PROGRESIVO
       ------------------------------------------------------------- */
    body.a11y-scale-115 { font-size: 1.15rem !important; }
    body.a11y-scale-130 { font-size: 1.30rem !important; }
    body.a11y-scale-145 { font-size: 1.45rem !important; }

    /* -------------------------------------------------------------
       5. MODO DISLEXIA (OpenDyslexic / Tipografía Espaciada)
       ------------------------------------------------------------- */
    body.a11y-dyslexia, body.a11y-dyslexia * {
        font-family: 'Comic Sans MS', 'Atkinson Hyperlegible', Arial, sans-serif !important;
        letter-spacing: 0.06em !important;
        word-spacing: 0.12em !important;
        line-height: 1.85 !important;
    }

    /* -------------------------------------------------------------
       6. SUBRAYADO TOTAL DE ENLACES (Garantizado para todas las palabras)
       ------------------------------------------------------------- */
    body.a11y-underline a,
    body.a11y-underline a *,
    body.a11y-underline .nav-link,
    body.a11y-underline .nav-link *,
    body.a11y-underline .dropdown-item,
    body.a11y-underline .dropdown-item *,
    body.a11y-underline .page-link,
    body.a11y-underline .page-link *,
    body.a11y-underline .breadcrumb-item a,
    body.a11y-underline .breadcrumb-item a *,
    body.a11y-underline .btn-link,
    body.a11y-underline .btn-link *,
    body.a11y-underline [role="link"],
    body.a11y-underline [role="link"] *,
    body.a11y-underline-links a,
    body.a11y-underline-links a *,
    body.a11y-underline-links .nav-link,
    body.a11y-underline-links .nav-link *,
    body.a11y-underline-links .dropdown-item,
    body.a11y-underline-links .dropdown-item *,
    body.a11y-underline-links .page-link,
    body.a11y-underline-links .page-link *,
    body.a11y-underline-links .btn-link,
    body.a11y-underline-links .btn-link *,
    body.a11y-underline-links [role="link"],
    body.a11y-underline-links [role="link"] * {
        text-decoration: underline !important;
        text-decoration-line: underline !important;
        text-decoration-style: solid !important;
        text-decoration-thickness: 2px !important;
        text-underline-offset: 4px !important;
    }

    /* -------------------------------------------------------------
       7. MÁSCARA / REGLA DE LECTURA (TDAH & Concentración)
       ------------------------------------------------------------- */
    #a11yFocusRuler, #a11yReadingRuler {
        display: none;
        position: fixed;
        left: 0;
        right: 0;
        height: 64px;
        background: rgba(37, 99, 235, 0.08);
        border-top: 3px solid #2563eb;
        border-bottom: 3px solid #2563eb;
        box-shadow: 0 0 0 9999px rgba(0, 0, 0, 0.42);
        pointer-events: none;
        z-index: 99999;
        transform: translateY(-50%);
    }

    /* -------------------------------------------------------------
       8. BOTÓN FLOTANTE PARA LEER TEXTO SELECCIONADO (TTS)
       ------------------------------------------------------------- */
    #a11yBtnAudioSel {
        display: none;
        position: absolute;
        z-index: 100000;
        background: #1e3a8a;
        color: #ffffff;
        border: 2px solid #ffffff;
        border-radius: 20px;
        padding: 5px 14px;
        font-size: 0.82rem;
        font-weight: 700;
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.35);
        cursor: pointer;
        transition: transform 0.15s ease, background 0.15s ease;
    }
    #a11yBtnAudioSel:hover {
        background: #2563eb;
        transform: scale(1.06);
    }

    /* -------------------------------------------------------------
       9. BOTÓN FLOTANTE UNIVERSAL DE ACCESIBILIDAD
       ------------------------------------------------------------- */
    .a11y-float-btn {
        position: fixed;
        bottom: 24px;
        right: 24px;
        width: 52px;
        height: 52px;
        border-radius: 50%;
        background: #1e3a8a;
        color: #ffffff;
        border: 2px solid #ffffff;
        box-shadow: 0 4px 18px rgba(0, 0, 0, 0.3);
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        z-index: 9999;
        font-size: 1.45rem;
        transition: transform 0.2s ease, background 0.2s ease, box-shadow 0.2s ease;
    }
    .a11y-float-btn:hover {
        transform: scale(1.1);
        background: #2563eb;
        box-shadow: 0 6px 22px rgba(37, 99, 235, 0.5);
    }

    /* -------------------------------------------------------------
       10. PANEL LATERAL DE ACCESIBILIDAD (DRAWER)
       ------------------------------------------------------------- */
    .a11y-panel {
        position: fixed;
        top: 0;
        right: 0;
        bottom: 0;
        width: 350px;
        max-width: 92vw;
        background: #ffffff;
        color: #1e293b;
        border-left: 1px solid #cbd5e1;
        box-shadow: -8px 0 28px rgba(0, 0, 0, 0.25);
        z-index: 10000;
        overflow-y: auto;
        display: none;
        animation: a11ySlideInRight 0.25s ease-out;
    }
    @keyframes a11ySlideInRight {
        from { transform: translateX(100%); }
        to { transform: translateX(0); }
    }
    .a11y-panel-header {
        background: #1e3a8a;
        color: #ffffff;
        padding: 16px 20px;
        display: flex;
        align-items: center;
        justify-content: space-between;
    }
    .a11y-panel-body {
        padding: 18px 20px;
    }
    .a11y-section-title {
        font-size: 0.76rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.6px;
        color: #64748b;
        margin-bottom: 8px;
        margin-top: 14px;
    }
</style>

<!-- ELEMENTOS FLOTANTES DE ACCESIBILIDAD -->
<div id="a11yFocusRuler"></div>
<div id="a11yReadingRuler"></div>

<button id="a11yBtnAudioSel" type="button" onclick="a11yLeerTextoSeleccionado()">
    <i class="bi bi-volume-up-fill me-1"></i> Escuchar selección
</button>

<button class="a11y-float-btn" type="button" onclick="toggleA11yPanel()" title="Herramientas de Accesibilidad y Lectura (WCAG AAA)" aria-label="Abrir panel de accesibilidad">
    <i class="bi bi-universal-access"></i>
</button>

<!-- PANEL LATERAL DE ACCESIBILIDAD -->
<div class="a11y-panel shadow-lg" id="a11yPanelDrawer">
    <div class="a11y-panel-header">
        <div class="d-flex align-items-center gap-2">
            <i class="bi bi-universal-access fs-4"></i>
            <div>
                <h6 class="mb-0 fw-bold">Accesibilidad BookHub</h6>
                <small class="text-white-50" style="font-size: 0.72rem;">Normas WCAG 2.1 Nivel AAA</small>
            </div>
        </div>
        <button type="button" class="btn-close btn-close-white" onclick="toggleA11yPanel()" aria-label="Cerrar panel"></button>
    </div>

    <div class="a11y-panel-body">
        <!-- 1. CONTRASTE Y TEMAS -->
        <div class="a11y-section-title mt-0">Modo Visual y Contraste</div>
        <div class="d-grid gap-2 mb-3">
            <button class="btn btn-sm btn-outline-dark text-start d-flex align-items-center justify-content-between py-2" id="btnThemeNormal" onclick="setA11yTheme('normal')">
                <span><i class="bi bi-sun-fill me-2 text-warning"></i> Modo Estándar</span>
                <span class="badge bg-secondary" id="badgeThemeNormal">Normal</span>
            </button>
            <button class="btn btn-sm text-start d-flex align-items-center justify-content-between py-2" id="btnThemeSepia" style="background:#fbf0d9; color:#2c221e; border:1px solid #d4c5a9;" onclick="setA11yTheme('sepia')">
                <span><i class="bi bi-book me-2"></i> Sepia (Lectura Cálida)</span>
                <span class="badge bg-dark" id="badgeThemeSepia" style="display:none;">Activo</span>
            </button>
            <button class="btn btn-sm btn-dark text-start d-flex align-items-center justify-content-between py-2" id="btnThemeDark" onclick="setA11yTheme('dark')">
                <span><i class="bi bi-moon-stars-fill me-2 text-info"></i> Modo Pizarra / Noche</span>
                <span class="badge bg-info text-dark" id="badgeThemeDark" style="display:none;">Activo</span>
            </button>
            <button class="btn btn-sm text-start d-flex align-items-center justify-content-between py-2" id="btnThemeContrast" style="background:#000000; color:#ffff00; border:2px solid #ffff00; font-weight:700;" onclick="setA11yTheme('contrast')">
                <span><i class="bi bi-circle-half me-2"></i> Alto Contraste (AAA)</span>
                <span class="badge bg-warning text-dark" id="badgeThemeContrast" style="display:none;">Activo</span>
            </button>
        </div>

        <!-- 2. TAMAÑO DE TEXTO PROGRESIVO -->
        <div class="a11y-section-title">Tamaño de Texto</div>
        <div class="btn-group w-100 mb-3" role="group">
            <button type="button" class="btn btn-outline-primary btn-sm" id="btnScale100" onclick="setA11yScale(100)">100%</button>
            <button type="button" class="btn btn-outline-primary btn-sm" id="btnScale115" onclick="setA11yScale(115)">115%</button>
            <button type="button" class="btn btn-outline-primary btn-sm" id="btnScale130" onclick="setA11yScale(130)">130%</button>
            <button type="button" class="btn btn-outline-primary btn-sm" id="btnScale145" onclick="setA11yScale(145)">145%</button>
        </div>

        <!-- 3. APOYO A LA LECTURA Y NEURODIVERGENCIA -->
        <div class="a11y-section-title">Apoyo a la Lectura & TDAH</div>
        <div class="form-check form-switch mb-2">
            <input class="form-check-input" type="checkbox" id="checkA11yFocusRuler" onchange="toggleA11yFocusRuler(this.checked)">
            <label class="form-check-label small" for="checkA11yFocusRuler">Máscara / Regla de enfoque (TDAH)</label>
        </div>
        <div class="form-check form-switch mb-2">
            <input class="form-check-input" type="checkbox" id="checkA11yDyslexia" onchange="toggleA11yDyslexia(this.checked)">
            <label class="form-check-label small" for="checkA11yDyslexia">Tipografía para Dislexia</label>
        </div>
        <div class="form-check form-switch mb-3">
            <input class="form-check-input" type="checkbox" id="checkA11yUnderline" onchange="toggleA11yUnderline(this.checked)">
            <label class="form-check-label small" for="checkA11yUnderline">Subrayar todos los enlaces</label>
        </div>

        <!-- 4. LECTURA ASISTIDA POR VOZ (TTS) -->
        <div class="a11y-section-title">Lector de Pantalla Asistido</div>
        <p class="text-muted small mb-2">Selecciona cualquier texto en la pantalla con el ratón para escuchar su locución automática.</p>
        <button class="btn btn-outline-primary btn-sm w-100 py-2 d-flex align-items-center justify-content-center gap-2 mb-3" onclick="a11yLeerEncabezados()">
            <i class="bi bi-volume-up-fill"></i> Escuchar Resumen de la Página
        </button>

        <button class="btn btn-outline-secondary btn-sm w-100" onclick="resetA11ySettings()">
            <i class="bi bi-arrow-counterclockwise"></i> Restaurar Configuración
        </button>
    </div>
</div>

<script id="a11yGlobalScript">
    // Almacenamiento unificado y retrocompatible con todas las versiones anteriores
    const A11Y_PRIMARY_KEY = 'bookhub_a11y_state';
    const A11Y_LEGACY_KEYS = ['bookhub_a11y_prefs', 'bookhub_a11y_suite'];

    let a11yState = {
        theme: 'normal',
        scale: 100,
        dyslexia: false,
        underline: false,
        focusRuler: false
    };

    function loadA11yState() {
        try {
            let saved = localStorage.getItem(A11Y_PRIMARY_KEY);
            if (!saved) {
                for (const key of A11Y_LEGACY_KEYS) {
                    saved = localStorage.getItem(key);
                    if (saved) break;
                }
            }
            if (saved) {
                const parsed = JSON.parse(saved);
                // Normalizar tema si vino con formato antiguo
                if (parsed.theme === 'default') parsed.theme = 'normal';
                if (parsed.scale && parsed.scale < 10) parsed.scale = Math.round(parsed.scale * 100);
                if (parsed.ruler !== undefined && parsed.focusRuler === undefined) parsed.focusRuler = parsed.ruler;
                a11yState = Object.assign(a11yState, parsed);
            }
        } catch (e) {}
        applyA11yState();
    }

    function saveA11yState() {
        try {
            const json = JSON.stringify(a11yState);
            localStorage.setItem(A11Y_PRIMARY_KEY, json);
            // Sincronizar claves de compatibilidad
            A11Y_LEGACY_KEYS.forEach(k => localStorage.setItem(k, json));
        } catch (e) {}
    }

    function applyA11yState() {
        // 1. Clases de tema en body y html
        const themes = ['a11y-theme-sepia', 'a11y-theme-dark', 'a11y-theme-contrast'];
        document.body.classList.remove(...themes);
        document.documentElement.classList.remove(...themes);

        if (a11yState.theme === 'sepia') {
            document.body.classList.add('a11y-theme-sepia');
            document.documentElement.classList.add('a11y-theme-sepia');
        } else if (a11yState.theme === 'dark') {
            document.body.classList.add('a11y-theme-dark');
            document.documentElement.classList.add('a11y-theme-dark');
        } else if (a11yState.theme === 'contrast') {
            document.body.classList.add('a11y-theme-contrast');
            document.documentElement.classList.add('a11y-theme-contrast');
        }

        // Badges del panel
        const bNormal = document.getElementById('badgeThemeNormal');
        const bSepia = document.getElementById('badgeThemeSepia');
        const bDark = document.getElementById('badgeThemeDark');
        const bContrast = document.getElementById('badgeThemeContrast');
        if (bNormal) bNormal.style.display = a11yState.theme === 'normal' ? '' : 'none';
        if (bSepia) bSepia.style.display = a11yState.theme === 'sepia' ? '' : 'none';
        if (bDark) bDark.style.display = a11yState.theme === 'dark' ? '' : 'none';
        if (bContrast) bContrast.style.display = a11yState.theme === 'contrast' ? '' : 'none';

        // 2. Escala tipográfica
        const scales = ['a11y-scale-115', 'a11y-scale-130', 'a11y-scale-145'];
        document.body.classList.remove(...scales);
        document.documentElement.classList.remove(...scales);

        ['btnScale100', 'btnScale115', 'btnScale130', 'btnScale145'].forEach(id => {
            const btn = document.getElementById(id);
            if (btn) btn.classList.remove('active', 'btn-primary');
        });

        const fontScale = (a11yState.scale || 100) / 100;
        document.documentElement.style.setProperty('--a11y-font-scale', fontScale);
        const lh = fontScale >= 1.3 ? 1.75 : (fontScale >= 1.15 ? 1.65 : 1.5);
        document.documentElement.style.setProperty('--a11y-line-height', lh);

        if (a11yState.scale === 115) {
            document.body.classList.add('a11y-scale-115');
            document.getElementById('btnScale115')?.classList.add('active', 'btn-primary');
        } else if (a11yState.scale === 130) {
            document.body.classList.add('a11y-scale-130');
            document.getElementById('btnScale130')?.classList.add('active', 'btn-primary');
        } else if (a11yState.scale === 145) {
            document.body.classList.add('a11y-scale-145');
            document.getElementById('btnScale145')?.classList.add('active', 'btn-primary');
        } else {
            document.getElementById('btnScale100')?.classList.add('active', 'btn-primary');
        }

        // 3. Dislexia
        document.body.classList.toggle('a11y-dyslexia', !!a11yState.dyslexia);
        document.documentElement.classList.toggle('a11y-dyslexia', !!a11yState.dyslexia);
        const cDys = document.getElementById('checkA11yDyslexia');
        if (cDys) cDys.checked = !!a11yState.dyslexia;

        // 4. Subrayado total de enlaces (soporta tanto a11y-underline como a11y-underline-links)
        document.body.classList.toggle('a11y-underline', !!a11yState.underline);
        document.body.classList.toggle('a11y-underline-links', !!a11yState.underline);
        document.documentElement.classList.toggle('a11y-underline', !!a11yState.underline);
        document.documentElement.classList.toggle('a11y-underline-links', !!a11yState.underline);
        const cUnd = document.getElementById('checkA11yUnderline');
        if (cUnd) cUnd.checked = !!a11yState.underline;

        // 5. Regla de enfoque de lectura
        const ruler1 = document.getElementById('a11yFocusRuler');
        const ruler2 = document.getElementById('a11yReadingRuler');
        if (ruler1) ruler1.style.display = a11yState.focusRuler ? 'block' : 'none';
        if (ruler2) ruler2.style.display = a11yState.focusRuler ? 'block' : 'none';
        const cRul = document.getElementById('checkA11yFocusRuler');
        if (cRul) cRul.checked = !!a11yState.focusRuler;
    }

    function toggleA11yPanel() {
        const p = document.getElementById('a11yPanelDrawer') || document.getElementById('a11yPanel');
        if (p) {
            p.style.display = (p.style.display === 'block') ? 'none' : 'block';
        }
    }

    function setA11yTheme(theme) {
        a11yState.theme = theme;
        applyA11yState();
        saveA11yState();
    }

    function setA11yScale(scale) {
        a11yState.scale = scale;
        applyA11yState();
        saveA11yState();
    }

    function toggleA11yDyslexia(checked) {
        a11yState.dyslexia = checked !== undefined ? checked : !a11yState.dyslexia;
        applyA11yState();
        saveA11yState();
    }

    function toggleA11yUnderline(checked) {
        a11yState.underline = checked !== undefined ? checked : !a11yState.underline;
        applyA11yState();
        saveA11yState();
    }

    function toggleA11yFocusRuler(checked) {
        a11yState.focusRuler = checked !== undefined ? checked : !a11yState.focusRuler;
        applyA11yState();
        saveA11yState();
    }

    function resetA11ySettings() {
        a11yState = { theme: 'normal', scale: 100, dyslexia: false, underline: false, focusRuler: false };
        applyA11yState();
        saveA11yState();
        if ('speechSynthesis' in window) window.speechSynthesis.cancel();
    }

    // Movimiento fluido de la regla de lectura con el ratón
    document.addEventListener('mousemove', (e) => {
        if (!a11yState.focusRuler) return;
        const ruler1 = document.getElementById('a11yFocusRuler');
        const ruler2 = document.getElementById('a11yReadingRuler');
        if (ruler1) ruler1.style.top = e.clientY + 'px';
        if (ruler2) ruler2.style.top = e.clientY + 'px';
    });

    // Síntesis de voz (TTS) para lectura asistida
    function a11yHablar(texto) {
        if (!('speechSynthesis' in window) || !texto) return;
        window.speechSynthesis.cancel();
        const utter = new SpeechSynthesisUtterance(texto);
        utter.lang = 'es-ES';
        utter.rate = 1.0;
        window.speechSynthesis.speak(utter);
    }

    function a11yLeerEncabezados() {
        const h1 = document.querySelector('h1, h2');
        const p = document.querySelector('p.text-muted, p');
        let texto = '';
        if (h1) texto += h1.innerText + '. ';
        if (p) texto += p.innerText;
        if (!texto) texto = document.title;
        a11yHablar(texto);
    }

    let a11ySelectedText = '';
    document.addEventListener('mouseup', (e) => {
        const btn = document.getElementById('a11yBtnAudioSel');
        if (!btn) return;
        const sel = window.getSelection().toString().trim();
        if (sel && sel.length > 2) {
            a11ySelectedText = sel;
            btn.style.left = Math.min(window.innerWidth - 170, e.pageX + 10) + 'px';
            btn.style.top = Math.max(10, e.pageY - 40) + 'px';
            btn.style.display = 'block';
        } else {
            setTimeout(() => {
                if (btn && !window.getSelection().toString().trim()) {
                    btn.style.display = 'none';
                }
            }, 250);
        }
    });

    function a11yLeerTextoSeleccionado() {
        if (a11ySelectedText) {
            a11yHablar(a11ySelectedText);
            const btn = document.getElementById('a11yBtnAudioSel');
            if (btn) btn.style.display = 'none';
        }
    }

    // Inicializar inmediatamente y sincronizar al cargar el DOM
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', loadA11yState);
    } else {
        loadA11yState();
    }
</script>
