<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="modelo.beans.Usuario"%>
<%@page import="modelo.beans.Prestamo"%>
<%@page import="modelo.beans.Libro"%>
<%@page import="modelo.dao.PrestamoDAO"%>
<%@page import="modelo.dao.LibroDAO"%>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if (!"USUARIO".equals(usuario.getRol())) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    PrestamoDAO prestamoDAO = new PrestamoDAO();
    LibroDAO libroDAO = new LibroDAO();
    List<Prestamo> misPrestamos = new ArrayList<>();
    int prestamosActivos = 0;
    int prestamosDevueltos = 0;

    try {
        List<Prestamo> lista = prestamoDAO.listar();
        if (lista != null) {
            for (Prestamo p : lista) {
                if (p.getIdUsuario() == usuario.getIdUsuario()) {
                    misPrestamos.add(p);
                    if ("PRESTADO".equalsIgnoreCase(p.getEstado())) {
                        prestamosActivos++;
                    } else {
                        prestamosDevueltos++;
                    }
                }
            }
        }
    } catch (Exception e) {
        // Protección preventiva ante excepciones de BD
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
    <title>BookHub | Mi cuenta</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
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

        /* DISEÑO DE PERFIL DE USUARIO LIMPIO */
        .card-profile {
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            background: #ffffff;
            box-shadow: 0 1px 3px rgba(15, 23, 42, 0.04);
        }
        .user-avatar-box {
            width: 56px;
            height: 56px;
            border-radius: 12px;
            background: #eff6ff;
            color: #1e40af;
            border: 1px solid #bfdbfe;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 1.45rem;
            font-weight: 700;
            flex-shrink: 0;
        }
        .stat-card {
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            background: #ffffff;
            padding: 18px 20px;
            height: 100%;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(15, 23, 42, 0.06);
        }
        .service-card {
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            background: #ffffff;
            height: 100%;
            transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease;
        }
        .service-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(15, 23, 42, 0.06);
            border-color: #cbd5e1;
        }
        .service-icon-wrap {
            width: 44px;
            height: 44px;
            border-radius: 10px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            margin-bottom: 14px;
        }
        .table-loans th {
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #64748b;
            font-weight: 600;
        }
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
            <div class="p-3 mb-3 rounded-3 bg-secondary bg-opacity-25 border border-secondary border-opacity-25">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-person-circle fs-3 text-info"></i>
                    <div class="overflow-hidden">
                        <div class="fw-semibold text-white text-truncate"><%= usuario.getNombre() %></div>
                        <span class="badge bg-primary" style="font-size: 0.68rem;"><%= usuario.getRol() %></span>
                    </div>
                </div>
            </div>

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

            <!-- SERVICIOS -->
            <p class="sidebar-subtitle mb-2 px-2">Servicios</p>
            <div class="d-flex flex-column gap-2 mb-3">
                <a href="CatalogoServlet" class="btn btn-outline-light text-start d-flex align-items-center gap-2 py-2 px-3 rounded-3">
                    <i class="bi bi-search"></i> Explorar Catálogo
                </a>
                <a href="InnovacionServlet" class="btn btn-outline-info text-start d-flex align-items-center gap-2 py-2 px-3 rounded-3">
                    <i class="bi bi-universal-access"></i> Centro ODS 09
                </a>
            </div>
        </div>

        <div class="pt-3 border-top border-secondary border-opacity-25 text-center text-white-50 small">
            <span>BookHub v2.0 • Inclusión Digital</span>
        </div>
    </div>
</div>

<!-- NAVBAR CON BOTÓN DE TRES LÍNEAS -->
<nav class="navbar navbar-dark bg-dark sticky-top shadow-sm py-2 navbar-scroll-fade" id="mainNavbar">
    <div class="container-fluid px-3 px-lg-4">

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

        <!-- Lado derecho: Sesión activa -->
        <div class="d-flex align-items-center gap-2 ms-auto">
            <span class="text-white small d-none d-sm-inline">
                Hola, <strong><%= usuario.getNombre() %></strong>
            </span>

            <a href="LogoutServlet" class="btn btn-outline-danger btn-sm d-flex align-items-center gap-1">
                <i class="bi bi-box-arrow-left"></i> <span>Salir</span>
            </a>
        </div>

    </div>
</nav>


<!-- CONTENIDO PRINCIPAL -->
<div class="container py-4">

    <!-- PERFIL INSTITUCIONAL DEL LECTOR -->
    <div class="card card-profile p-4 mb-4">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
            <div class="d-flex align-items-center gap-3">
                <div class="user-avatar-box">
                    <%= (usuario.getNombre() != null && !usuario.getNombre().isEmpty()) ? usuario.getNombre().substring(0, 1).toUpperCase() : "U" %>
                </div>
                <div>
                    <div class="d-flex flex-wrap align-items-center gap-2 mb-1">
                        <h4 class="fw-bold mb-0 text-dark"><%= usuario.getNombre() %></h4>
                        <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">
                            <i class="bi bi-check-circle-fill me-1"></i>Membresía activa
                        </span>
                    </div>
                    <div class="text-secondary small d-flex flex-wrap align-items-center gap-3">
                        <span><i class="bi bi-envelope me-1"></i><%= usuario.getCorreo() %></span>
                        <span><i class="bi bi-person-badge me-1"></i>ID de Lector: #<%= String.format("%04d", usuario.getIdUsuario()) %></span>
                        <span><i class="bi bi-building me-1"></i>Comunidad Universitaria</span>
                    </div>
                </div>
            </div>

            <div class="d-flex align-items-center gap-2">
                <a href="CatalogoServlet" class="btn btn-primary btn-sm d-flex align-items-center gap-1 px-3 py-2">
                    <i class="bi bi-journal-bookmark-fill"></i> <span>Ir al Catálogo</span>
                </a>
                <a href="MisPrestamosServlet" class="btn btn-outline-secondary btn-sm d-flex align-items-center gap-1 px-3 py-2">
                    <i class="bi bi-clock-history"></i> <span>Mis Préstamos</span>
                </a>
            </div>
        </div>
    </div>

    <!-- TARJETAS DE INDICADORES / ACTIVIDAD DEL LECTOR -->
    <div class="row g-3 mb-4">
        <div class="col-sm-6 col-lg-4">
            <div class="stat-card">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <span class="text-secondary small fw-semibold">Libros en préstamo</span>
                    <span class="badge <%= prestamosActivos > 0 ? "bg-warning text-dark" : "bg-light text-secondary border" %>">
                        <%= prestamosActivos > 0 ? "En curso" : "Sin pendientes" %>
                    </span>
                </div>
                <div class="d-flex align-items-baseline gap-2">
                    <h2 class="fw-bold mb-0 text-dark"><%= prestamosActivos %></h2>
                    <span class="text-muted small">ejemplar<%= prestamosActivos != 1 ? "es" : "" %> activo<%= prestamosActivos != 1 ? "s" : "" %></span>
                </div>
                <div class="mt-2 pt-2 border-top">
                    <a href="MisPrestamosServlet" class="small text-decoration-none text-primary d-inline-flex align-items-center gap-1">
                        Ver detalles de fechas <i class="bi bi-arrow-right"></i>
                    </a>
                </div>
            </div>
        </div>

        <div class="col-sm-6 col-lg-4">
            <div class="stat-card">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <span class="text-secondary small fw-semibold">Préstamos completados</span>
                    <span class="badge bg-success-subtle text-success border border-success-subtle">
                        Historial
                    </span>
                </div>
                <div class="d-flex align-items-baseline gap-2">
                    <h2 class="fw-bold mb-0 text-dark"><%= prestamosDevueltos %></h2>
                    <span class="text-muted small">libro<%= prestamosDevueltos != 1 ? "s" : "" %> devuelto<%= prestamosDevueltos != 1 ? "s" : "" %></span>
                </div>
                <div class="mt-2 pt-2 border-top">
                    <span class="small text-muted">Registro histórico en biblioteca</span>
                </div>
            </div>
        </div>

        <div class="col-sm-12 col-lg-4">
            <div class="stat-card">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <span class="text-secondary small fw-semibold">Estado de cuenta</span>
                    <span class="badge bg-success text-white">Regular</span>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-shield-check fs-3 text-success"></i>
                    <div>
                        <div class="fw-semibold text-dark">Sin sanciones ni mora</div>
                        <div class="text-muted small">Habilitado para solicitar libros</div>
                    </div>
                </div>
                <div class="mt-2 pt-2 border-top">
                    <span class="small text-muted">Límite de préstamo: hasta 3 libros</span>
                </div>
            </div>
        </div>
    </div>

    <!-- BUSCADOR RÁPIDO DE CATÁLOGO -->
    <div class="card card-profile p-4 mb-4">
        <div class="row align-items-center">
            <div class="col-lg-5 mb-3 mb-lg-0">
                <h5 class="fw-bold mb-1 text-dark">
                    <i class="bi bi-search text-primary me-2"></i>Búsqueda en el acervo bibliográfico
                </h5>
                <p class="text-muted small mb-0">
                    Consulta al instante la disponibilidad de títulos, autores y materias en catálogo.
                </p>
            </div>
            <div class="col-lg-7">
                <form action="CatalogoServlet" method="get">
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0">
                            <i class="bi bi-search text-muted"></i>
                        </span>
                        <input type="text"
                               name="busqueda"
                               class="form-control border-start-0"
                               placeholder="Ingresa título, autor o tema de tu interés..."
                               required>
                        <button type="submit" class="btn btn-primary px-4">
                            Buscar libro
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- LIBROS ACTUALES EN PRÉSTAMO (SI EXISTEN) -->
    <% if (prestamosActivos > 0) { %>
    <div class="card card-profile mb-4">
        <div class="card-header bg-white py-3 border-bottom d-flex align-items-center justify-content-between">
            <div class="fw-semibold text-dark">
                <i class="bi bi-book-half text-primary me-2"></i>Libros que tienes en préstamo actualmente
            </div>
            <a href="MisPrestamosServlet" class="btn btn-sm btn-outline-primary">
                Ver todos mis préstamos
            </a>
        </div>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0 table-loans">
                <thead class="table-light">
                    <tr>
                        <th class="ps-4">Libro</th>
                        <th>Fecha de Préstamo</th>
                        <th>Fecha Límite de Devolución</th>
                        <th>Estado</th>
                        <th class="text-end pe-4">Acción</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (Prestamo p : misPrestamos) {
                            if ("PRESTADO".equalsIgnoreCase(p.getEstado())) {
                                Libro libro = null;
                                try {
                                    libro = libroDAO.obtenerPorId(p.getIdLibro());
                                } catch (Exception e) {}
                                String tituloLibro = libro != null ? libro.getTitulo() : ("Libro #" + p.getIdLibro());
                                String autorLibro = libro != null ? libro.getNombreAutor() : "Biblioteca BookHub";
                    %>
                    <tr>
                        <td class="ps-4">
                            <div class="fw-semibold text-dark"><%= tituloLibro %></div>
                            <small class="text-muted"><%= autorLibro %></small>
                        </td>
                        <td><%= p.getFechaPrestamo() != null ? p.getFechaPrestamo() : "-" %></td>
                        <td>
                            <span class="badge bg-light text-dark border">
                                <i class="bi bi-calendar-event me-1"></i><%= p.getFechaDevolucion() != null ? p.getFechaDevolucion() : "-" %>
                            </span>
                        </td>
                        <td>
                            <span class="badge bg-warning text-dark">
                                <i class="bi bi-hourglass-split me-1"></i>Prestado
                            </span>
                        </td>
                        <td class="text-end pe-4">
                            <a href="DetalleLibroServlet?id=<%= p.getIdLibro() %>" class="btn btn-sm btn-outline-secondary">
                                Ver ficha
                            </a>
                        </td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
    <% } %>

    <!-- SERVICIOS DISPONIBLES EN LA BIBLIOTECA -->
    <h5 class="fw-bold text-dark mb-3">
        <i class="bi bi-grid-fill text-primary me-2"></i>Servicios para la comunidad lectora
    </h5>

    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="card service-card p-4">
                <div class="service-icon-wrap bg-primary-subtle text-primary">
                    <i class="bi bi-journal-text"></i>
                </div>
                <h6 class="fw-bold text-dark mb-1">Catálogo General</h6>
                <p class="text-muted small mb-3">
                    Explora libros en literatura, ciencias exactas, ingeniería, historia y más, con disponibilidad en tiempo real.
                </p>
                <div class="mt-auto">
                    <a href="CatalogoServlet" class="btn btn-sm btn-outline-primary w-100">
                        Explorar acervo
                    </a>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card service-card p-4">
                <div class="service-icon-wrap bg-danger-subtle text-danger">
                    <i class="bi bi-gift"></i>
                </div>
                <h6 class="fw-bold text-dark mb-1">Donación de Libros</h6>
                <p class="text-muted small mb-3">
                    Comparte libros con otros lectores mediante nuestro programa solidario de donación bibliográfica.
                </p>
                <div class="mt-auto">
                    <a href="donar.jsp" class="btn btn-sm btn-outline-danger w-100">
                        Donar un ejemplar
                    </a>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card service-card p-4">
                <div class="service-icon-wrap bg-success-subtle text-success">
                    <i class="bi bi-universal-access"></i>
                </div>
                <h6 class="fw-bold text-dark mb-1">Inclusión y Accesibilidad (ODS 9)</h6>
                <p class="text-muted small mb-3">
                    Lectura con síntesis de voz, dictado de búsqueda, tipografías para dislexia y modo de alto contraste.
                </p>
                <div class="mt-auto">
                    <a href="InnovacionServlet" class="btn btn-sm btn-outline-success w-100">
                        Centro de accesibilidad
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- GUÍA DE SERVICIO Y NORMAS DE PRÉSTAMO -->
    <div class="card card-profile p-4">
        <h6 class="fw-bold text-dark mb-3">
            <i class="bi bi-info-circle text-primary me-2"></i>Guía y normas de préstamo universitario
        </h6>
        <div class="row g-3 small text-secondary">
            <div class="col-md-4">
                <div class="p-3 rounded-2 bg-light border">
                    <div class="fw-semibold text-dark mb-1">
                        <i class="bi bi-calendar-check text-primary me-1"></i> Plazo de préstamo
                    </div>
                    <div>Los ejemplares se otorgan por un período regular de 7 días naturales, renovables si no existen reservas.</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="p-3 rounded-2 bg-light border">
                    <div class="fw-semibold text-dark mb-1">
                        <i class="bi bi-arrow-repeat text-success me-1"></i> Devolución responsable
                    </div>
                    <div>Puedes entregar los libros en ventanilla de atención o registrar su entrega con el personal encargado.</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="p-3 rounded-2 bg-light border">
                    <div class="fw-semibold text-dark mb-1">
                        <i class="bi bi-headset text-info me-1"></i> Asistencia al lector
                    </div>
                    <div>Si necesitas adaptaciones de lectura asistida o consultas especializadas, consulta al equipo de biblioteca.</div>
                </div>
            </div>
        </div>
    </div>

</div>

<!-- FOOTER -->
<footer class="bg-dark text-white py-4 mt-5">
    <div class="container text-center">
        <p class="mb-1 fw-semibold">BookHub</p>
        <p class="mb-0 small text-white-50">
            Sistema de Gestión de Biblioteca Universitaria • Inclusión Digital ODS 9
        </p>
    </div>
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
