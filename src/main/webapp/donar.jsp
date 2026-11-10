<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="beans.Usuario"%>
<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
    String exito = request.getParameter("exito");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <!-- Favicon / Logo de pestaña del navegador -->
    <link rel="icon" type="image/svg+xml" href="img/logo.svg">
    <link rel="alternate icon" type="image/x-icon" href="favicon.ico">
    <link rel="apple-touch-icon" href="img/logo.svg">

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Donar Libros a la Biblioteca - BookHub</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        body {
            background-color: #f8fafc;
            color: #1e293b;
        }
        .navbar-scroll-fade {
            transition: opacity 0.35s ease, transform 0.35s ease;
        }
        .navbar-scroll-fade.navbar-hidden {
            opacity: 0 !important;
            pointer-events: none !important;
            transform: translateY(-10px);
        }
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
        .btn-sidebar-toggle:hover {
            background: rgba(255, 255, 255, 0.22);
            transform: scale(1.05);
        }
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
        .sidebar-subtitle {
            font-size: 0.72rem;
            letter-spacing: 0.08em;
            color: #94a3b8;
            font-weight: 700;
            text-transform: uppercase;
        }
        .donation-hero {
            background: linear-gradient(135deg, #0f172a 0%, #1e3a8a 100%);
            color: #ffffff;
            padding: 45px 0;
            border-bottom: 1px solid #334155;
        }
        .card-donation {
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
            background: #ffffff;
        }
        .step-badge {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: #2563eb;
            color: #ffffff;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }
    </style>
</head>

<body>

<!-- OFFCANVAS -->
<div class="offcanvas offcanvas-start offcanvas-bookhub shadow-lg" tabindex="-1" id="sidebarBookHub">
    <div class="offcanvas-header border-bottom border-secondary border-opacity-25 pb-3">
        <div class="d-flex align-items-center gap-2">
            <img src="img/logo.svg" alt="BookHub Logo" width="36" height="36" class="d-inline-block">
            <div>
                <h5 class="offcanvas-title fw-bold text-white mb-0">BookHub</h5>
                <small class="text-white-50" style="font-size: 0.72rem;">Biblioteca Universitaria</small>
            </div>
        </div>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas"></button>
    </div>

    <div class="offcanvas-body d-flex flex-column justify-content-between p-3">
        <div>
            <p class="sidebar-subtitle mb-2 px-2">Apartados Principales</p>
            <div class="d-flex flex-column gap-1 mb-4">
                <a href="index.jsp" class="sidebar-menu-item">
                    <i class="bi bi-house-door-fill text-warning fs-5"></i>
                    <div>Inicio</div>
                </a>
                <a href="CatalogoServlet" class="sidebar-menu-item">
                    <i class="bi bi-journal-bookmark-fill text-info fs-5"></i>
                    <div>Catálogo</div>
                </a>
                <a href="InnovacionServlet" class="sidebar-menu-item">
                    <i class="bi bi-universal-access-circle text-success fs-5"></i>
                    <div>ODS 09: Accesibilidad</div>
                </a>
                <a href="MisPrestamosServlet" class="sidebar-menu-item">
                    <i class="bi bi-clock-history text-warning fs-5"></i>
                    <div>Mis Préstamos</div>
                </a>
                <a href="DonacionServlet" class="sidebar-menu-item active">
                    <i class="bi bi-gift-fill text-danger fs-5"></i>
                    <div>Donar Libros</div>
                </a>
            </div>
        </div>
        <div class="pt-3 border-top border-secondary border-opacity-25 text-center text-white-50 small">
            <span>BookHub v2.0 • Inclusión & Solidaridad</span>
        </div>
    </div>
</div>

<!-- NAVBAR -->
<nav class="navbar navbar-dark bg-dark sticky-top shadow-sm py-2 navbar-scroll-fade" id="mainNavbar">
    <div class="container-fluid px-3 px-lg-4">
        <div class="d-flex align-items-center gap-2">
            <button class="btn-sidebar-toggle" type="button" data-bs-toggle="offcanvas" data-bs-target="#sidebarBookHub">
                <i class="bi bi-list fs-3"></i>
            </button>
            <a class="navbar-brand fw-bold d-flex align-items-center gap-2 m-0" href="index.jsp">
                <img src="img/logo.svg" alt="BookHub Logo" width="34" height="34" class="d-inline-block">
                <span>BookHub</span>
            </a>
        </div>

        <div class="d-flex align-items-center gap-2 ms-auto">
            <% if (usuarioSesion != null) { %>
                <a href="usuario.jsp" class="btn btn-light btn-sm"><i class="bi bi-person-circle"></i> <%= usuarioSesion.getNombre() %></a>
                <a href="LogoutServlet" class="btn btn-outline-danger btn-sm">Salir</a>
            <% } else { %>
                <a href="login.jsp" class="btn btn-light btn-sm"><i class="bi bi-box-arrow-in-right"></i> Iniciar sesión</a>
                <a href="registro.jsp" class="btn btn-outline-light btn-sm"><i class="bi bi-person-plus"></i> Registrarse</a>
            <% } %>
        </div>
    </div>
</nav>

<!-- HERO -->
<section class="donation-hero text-center">
    <div class="container">
        <span class="badge bg-warning text-dark mb-2 px-3 py-1 fw-bold">🎁 Programa Solidario de Donaciones</span>
        <h1 class="fw-bold mb-2">Dona un Libro, Ilumina una Mente</h1>
        <p class="lead text-white-50 mx-auto" style="max-width: 680px;">
            Contribuye al acervo bibliográfico de nuestra comunidad universitaria. Cada ejemplar donado será catalogado e integrado para el beneficio de miles de estudiantes.
        </p>
    </div>
</section>

<!-- CONTENIDO -->
<div class="container py-5">
    <% if ("registrado".equals(exito)) { %>
        <div class="alert alert-success alert-dismissible fade show p-4 shadow-sm mb-4" role="alert">
            <div class="d-flex align-items-center gap-3">
                <i class="bi bi-check-circle-fill fs-2 text-success"></i>
                <div>
                    <h5 class="alert-heading fw-bold mb-1">¡Muchísimas gracias por tu donación!</h5>
                    <p class="mb-0 text-secondary">Tu solicitud de donación ha sido enviada al equipo bibliotecario. En breve revisarán los detalles para incorporarlo al catálogo general.</p>
                </div>
            </div>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <div class="row g-4 justify-content-center">
        <!-- FORMULARIO -->
        <div class="col-lg-8">
            <div class="card card-donation p-4 p-md-5">
                <h4 class="fw-bold mb-4 text-primary d-flex align-items-center gap-2">
                    <i class="bi bi-journal-plus"></i> Registrar Nueva Donación de Libro
                </h4>

                <form action="DonacionServlet" method="POST">
                    <!-- PASO 1: DATOS DEL LIBRO -->
                    <div class="mb-4">
                        <h6 class="fw-bold text-uppercase text-secondary small mb-3">1. Información del Libro</h6>
                        <div class="row g-3">
                            <div class="col-md-8">
                                <label class="form-label small fw-semibold">Título de la Obra *</label>
                                <input type="text" name="titulo" class="form-control" placeholder="Ej. El código Da Vinci" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-semibold">Año de Edición</label>
                                <input type="number" name="anio" class="form-control" placeholder="Ej. 2018" min="1500" max="2026">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Autor o Coautores *</label>
                                <input type="text" name="autor" class="form-control" placeholder="Ej. Dan Brown" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Categoría Temática *</label>
                                <select name="categoria" class="form-select" required>
                                    <option value="Literatura">Literatura / Novela</option>
                                    <option value="Programación & Software">Programación & Software</option>
                                    <option value="Ciencia & Matemáticas">Ciencia & Matemáticas</option>
                                    <option value="Historia & Sociedad">Historia & Sociedad</option>
                                    <option value="Psicología & Desarrollo">Psicología & Desarrollo</option>
                                    <option value="Filosofía & Estrategia">Filosofía & Estrategia</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <label class="form-label small fw-semibold">Estado de Conservación del Ejemplar *</label>
                                <div class="d-flex gap-3 flex-wrap">
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="estadoConservacion" id="cond1" value="EXCELENTE" checked>
                                        <label class="form-check-label small" for="cond1">🌟 Excelente (Como nuevo)</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="estadoConservacion" id="cond2" value="BUENO">
                                        <label class="form-check-label small" for="cond2">👍 Bueno (Completo, leves marcas)</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="estadoConservacion" id="cond3" value="REGULAR">
                                        <label class="form-check-label small" for="cond3">📖 Regular (Legible y utilizable)</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <hr class="my-4">

                    <!-- PASO 2: DATOS DEL DONANTE -->
                    <div class="mb-4">
                        <h6 class="fw-bold text-uppercase text-secondary small mb-3">2. Datos del Donante</h6>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Nombre Completo / Entidad *</label>
                                <input type="text" name="nombreDonante" class="form-control" placeholder="Ej. Carlos Mendoza" required value="<%= usuarioSesion != null ? usuarioSesion.getNombre() : "" %>">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Correo Electrónico *</label>
                                <input type="email" name="correoDonante" class="form-control" placeholder="carlos@universidad.edu.pe" required value="<%= usuarioSesion != null ? usuarioSesion.getCorreo() : "" %>">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Teléfono de Contacto</label>
                                <input type="text" name="telefonoDonante" class="form-control" placeholder="987654321">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Dedicatoria o Mensaje (Opcional)</label>
                                <textarea name="motivo" class="form-control" rows="1" placeholder="Ej. Para los estudiantes de primer ciclo..."></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="d-grid mt-4">
                        <button type="submit" class="btn btn-primary btn-lg fw-bold d-flex align-items-center justify-content-center gap-2">
                            <i class="bi bi-send-check"></i> Enviar Donación para Aprobación
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- LATERAL INFORMATIVO -->
        <div class="col-lg-4">
            <div class="card card-donation p-4 mb-4">
                <h5 class="fw-bold mb-3"><i class="bi bi-info-circle text-primary"></i> ¿Cómo funciona el proceso?</h5>
                <ol class="ps-3 mb-0 small text-secondary d-flex flex-column gap-2">
                    <li><strong>Registro digital:</strong> Completas este formulario con los datos de tu libro.</li>
                    <li><strong>Revisión administrativa:</strong> El bibliotecario valida que el ejemplar sea apto.</li>
                    <li><strong>Incorporación:</strong> Al ser aprobado, se crea automáticamente en el catálogo y queda disponible para préstamo.</li>
                    <li><strong>Entrega física:</strong> Te contactaremos para coordinar la entrega en el mostrador central.</li>
                </ol>
            </div>

            <div class="card card-donation p-4 bg-primary text-white border-0">
                <h6 class="fw-bold mb-2">Compromiso ODS 09</h6>
                <p class="small text-white-50 mb-3">Las donaciones enriquecen nuestra infraestructura bibliográfica digital e inclusiva, garantizando igualdad de acceso a recursos de aprendizaje.</p>
                <a href="CatalogoServlet" class="btn btn-light btn-sm fw-semibold">Explorar Catálogo Actual</a>
            </div>
        </div>
    </div>
</div>

<footer class="bg-dark text-white text-center py-4 mt-5">
    <p class="mb-0 text-white-50 small">BOOKHUB • Sistema Web de Gestión de Biblioteca Universitaria</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    window.addEventListener('scroll', function() {
        const navbar = document.getElementById('mainNavbar');
        if (!navbar) return;
        const currentScrollY = window.pageYOffset || document.documentElement.scrollTop;
        if (currentScrollY > 70) {
            navbar.classList.add('navbar-hidden');
        } else {
            navbar.classList.remove('navbar-hidden');
        }
    }, { passive: true });
</script>
<%@include file="a11y-panel.jsp"%>
</body>
</html>

