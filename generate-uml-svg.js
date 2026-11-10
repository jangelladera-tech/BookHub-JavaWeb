const fs = require('fs');
const path = require('path');

// Asegurar carpeta img/uml
const outDir = path.join(__dirname, 'img', 'uml');
const webappOutDir = path.join(__dirname, 'src', 'main', 'webapp', 'img', 'uml');
if (!fs.existsSync(outDir)) fs.mkdirSync(outDir, { recursive: true });
if (!fs.existsSync(webappOutDir)) fs.mkdirSync(webappOutDir, { recursive: true });

function renderClassBox({ x, y, width, headerColor = '#1e3a8a', title, stereotype = '', attributes = [], methods = [] }) {
    const lineHeight = 18;
    const headerHeight = stereotype ? 36 : 28;
    const attrHeight = Math.max(attributes.length * lineHeight + 12, 20);
    const methodHeight = methods.length > 0 ? (methods.length * lineHeight + 12) : 0;
    const totalHeight = headerHeight + attrHeight + methodHeight;

    let svg = `
    <!-- Clase: ${title} -->
    <g transform="translate(${x}, ${y})" filter="url(#dropShadow)">
        <!-- Fondo de tarjeta -->
        <rect width="${width}" height="${totalHeight}" rx="6" fill="#ffffff" stroke="#94a3b8" stroke-width="1.2"/>
        
        <!-- Cabecera -->
        <path d="M 0 6 C 0 2.7 2.7 0 6 0 L ${width - 6} 0 C ${width - 2.7} 0 ${width} 2.7 ${width} 6 L ${width} ${headerHeight} L 0 ${headerHeight} Z" fill="${headerColor}"/>
        ${stereotype ? `<text x="${width/2}" y="14" fill="#cbd5e1" font-size="10.5" font-family="'Segoe UI', Roboto, sans-serif" font-style="italic" text-anchor="middle">&laquo;${stereotype}&raquo;</text>` : ''}
        <text x="${width/2}" y="${stereotype ? 28 : 18}" fill="#ffffff" font-size="13" font-weight="700" font-family="'Segoe UI', Roboto, sans-serif" text-anchor="middle">${title}</text>
        
        <!-- Compartimento de Atributos -->
        <line x1="0" y1="${headerHeight}" x2="${width}" y2="${headerHeight}" stroke="#cbd5e1" stroke-width="1"/>
        <g transform="translate(10, ${headerHeight + 14})">
    `;

    attributes.forEach((attr, i) => {
        svg += `        <text x="0" y="${i * lineHeight}" fill="#1e293b" font-size="11.5" font-family="'Consolas', 'Courier New', monospace">${attr}</text>\n`;
    });

    svg += `    </g>\n`;

    if (methods.length > 0) {
        const methodStartY = headerHeight + attrHeight;
        svg += `
        <!-- Compartimento de Métodos -->
        <line x1="0" y1="${methodStartY}" x2="${width}" y2="${methodStartY}" stroke="#cbd5e1" stroke-width="1"/>
        <g transform="translate(10, ${methodStartY + 14})">
        `;
        methods.forEach((meth, i) => {
            svg += `        <text x="0" y="${i * lineHeight}" fill="#334155" font-size="11" font-family="'Consolas', 'Courier New', monospace">${meth}</text>\n`;
        });
        svg += `    </g>\n`;
    }

    svg += `    </g>\n`;
    return { svg, totalHeight, width, x, y };
}

function renderArrow({ x1, y1, x2, y2, label = '', multiplicityFrom = '', multiplicityTo = '', dashed = false, marker = 'arrow' }) {
    const dashAttr = dashed ? 'stroke-dasharray="4,4"' : '';
    let svg = `
    <!-- Relación -->
    <line x1="${x1}" y1="${y1}" x2="${x2}" y2="${y2}" stroke="#475569" stroke-width="1.4" ${dashAttr} marker-end="url(#${marker})"/>
    `;
    if (label) {
        const mx = (x1 + x2) / 2;
        const my = (y1 + y2) / 2 - 6;
        svg += `<text x="${mx}" y="${my}" fill="#0f172a" font-size="10.5" font-weight="600" font-family="'Segoe UI', Roboto, sans-serif" text-anchor="middle" background="#ffffff">${label}</text>\n`;
    }
    if (multiplicityFrom) {
        const ox = x1 < x2 ? x1 + 14 : x1 - 14;
        const oy = y1 < y2 ? y1 + 16 : y1 - 10;
        svg += `<text x="${ox}" y="${oy}" fill="#0284c7" font-size="11" font-weight="700" font-family="'Consolas', monospace" text-anchor="middle">${multiplicityFrom}</text>\n`;
    }
    if (multiplicityTo) {
        const ox = x2 > x1 ? x2 - 16 : x2 + 16;
        const oy = y2 > y1 ? y2 - 12 : y2 + 16;
        svg += `<text x="${ox}" y="${oy}" fill="#0284c7" font-size="11" font-weight="700" font-family="'Consolas', monospace" text-anchor="middle">${multiplicityTo}</text>\n`;
    }
    return svg;
}

function wrapSvg(width, height, content, title) {
    return `<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${width} ${height}" width="${width}" height="${height}">
    <defs>
        <filter id="dropShadow" x="-5%" y="-5%" width="112%" height="115%">
            <feDropShadow dx="0" dy="2" stdDeviation="3" flood-color="#0f172a" flood-opacity="0.12"/>
        </filter>
        <marker id="arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto">
            <path d="M 0 1 L 9 5 L 0 9 z" fill="#475569"/>
        </marker>
        <marker id="navArrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto">
            <path d="M 0 1 L 9 5 L 0 9" fill="none" stroke="#475569" stroke-width="1.5"/>
        </marker>
        <marker id="aggregation" viewBox="0 0 12 12" refX="0" refY="6" markerWidth="8" markerHeight="8" orient="auto">
            <path d="M 0 6 L 6 0 L 12 6 L 6 12 z" fill="#ffffff" stroke="#475569" stroke-width="1.5"/>
        </marker>
    </defs>

    <!-- Fondo general -->
    <rect width="${width}" height="${height}" fill="#f8fafc"/>
    <rect x="8" y="8" width="${width - 16}" height="${height - 16}" rx="8" fill="#ffffff" stroke="#e2e8f0" stroke-width="1"/>

    <!-- Título superior -->
    <text x="30" y="38" fill="#0f172a" font-size="18" font-weight="800" font-family="'Segoe UI', Roboto, sans-serif">${title}</text>
    <text x="30" y="56" fill="#64748b" font-size="12" font-family="'Segoe UI', Roboto, sans-serif">BookHub Biblioteca Universitaria — Arquitectura MVC (Modelo - Vista - Controlador)</text>
    <line x1="30" y1="68" x2="${width - 30}" y2="68" stroke="#e2e8f0" stroke-width="1"/>

    ${content}
</svg>`;
}

// =========================================================================
// 1. DIAGRAMA 1: MÓDULO BIBLIOGRÁFICO Y CATÁLOGO
// =========================================================================
function generarDiagramaBibliografico() {
    let content = '';

    // Entidades
    content += renderClassBox({
        x: 30, y: 90, width: 220, headerColor: '#1e40af', title: 'Autor', stereotype: 'Modelo Bean',
        attributes: [
            'idAutor : int',
            'nombre : String',
            'nacionalidad : String'
        ],
        methods: [
            'getIdAutor() : int',
            'setIdAutor(int) : void',
            'getNombre() : String',
            'setNombre(String) : void',
            'getNacionalidad() : String',
            'setNacionalidad(String) : void'
        ]
    }).svg;

    content += renderClassBox({
        x: 290, y: 90, width: 250, headerColor: '#1e40af', title: 'Libro', stereotype: 'Modelo Bean',
        attributes: [
            'idLibro : int',
            'titulo : String',
            'isbn : String',
            'anio : int',
            'descripcion : String',
            'stock : int',
            'idAutor : int',
            'idCategoria : int',
            'imagenPortada : String',
            'autor : Autor',
            'categoria : Categoria'
        ],
        methods: [
            'getIdLibro() : int',
            'getTitulo() : String',
            'getIsbn() : String',
            'getStock() : int',
            'getAutor() : Autor',
            'getCategoria() : Categoria',
            'setStock(int) : void'
        ]
    }).svg;

    content += renderClassBox({
        x: 580, y: 90, width: 220, headerColor: '#1e40af', title: 'Categoria', stereotype: 'Modelo Bean',
        attributes: [
            'idCategoria : int',
            'nombre : String',
            'descripcion : String'
        ],
        methods: [
            'getIdCategoria() : int',
            'setIdCategoria(int) : void',
            'getNombre() : String',
            'setNombre(String) : void',
            'getDescripcion() : String',
            'setDescripcion(String) : void'
        ]
    }).svg;

    // Relaciones entre entidades
    content += renderArrow({ x1: 290, y1: 180, x2: 250, y2: 180, label: 'escrito por', multiplicityFrom: '*', multiplicityTo: '1' });
    content += renderArrow({ x1: 540, y1: 180, x2: 580, y2: 180, label: 'pertenece a', multiplicityFrom: '*', multiplicityTo: '1' });

    // Capa DAO
    content += renderClassBox({
        x: 30, y: 390, width: 220, headerColor: '#0f766e', title: 'AutorDAO', stereotype: 'Modelo DAO',
        attributes: [],
        methods: [
            'listar() : List<Autor>',
            'obtenerPorId(int) : Autor',
            'agregar(Autor) : void',
            'actualizar(Autor) : void',
            'eliminar(int) : void'
        ]
    }).svg;

    content += renderClassBox({
        x: 290, y: 390, width: 250, headerColor: '#0f766e', title: 'LibroDAO', stereotype: 'Modelo DAO',
        attributes: [],
        methods: [
            'listar() : List<Libro>',
            'obtenerPorId(int) : Libro',
            'buscar(String, String) : List<Libro>',
            'agregar(Libro) : void',
            'actualizar(Libro) : void',
            'eliminar(int) : void',
            'actualizarStock(int, int) : void'
        ]
    }).svg;

    content += renderClassBox({
        x: 580, y: 390, width: 220, headerColor: '#0f766e', title: 'CategoriaDAO', stereotype: 'Modelo DAO',
        attributes: [],
        methods: [
            'listar() : List<Categoria>',
            'obtenerPorId(int) : Categoria',
            'agregar(Categoria) : void',
            'actualizar(Categoria) : void',
            'eliminar(int) : void'
        ]
    }).svg;

    // Conexión
    content += renderClassBox({
        x: 840, y: 390, width: 230, headerColor: '#3730a3', title: 'Conexion', stereotype: 'Modelo Conexión',
        attributes: [
            'URLS : String[]',
            'USER : String',
            'PASSWORDS : String[]',
            'cachedUrl : String',
            'cachedPass : String'
        ],
        methods: [
            'conectar() : Connection'
        ]
    }).svg;

    // Dependencias DAO -> Entidades & Conexion
    content += renderArrow({ x1: 140, y1: 390, x2: 140, y2: 305, label: '«gestiona»', dashed: true });
    content += renderArrow({ x1: 415, y1: 390, x2: 415, y2: 360, label: '«gestiona»', dashed: true });
    content += renderArrow({ x1: 690, y1: 390, x2: 690, y2: 305, label: '«gestiona»', dashed: true });
    content += renderArrow({ x1: 800, y1: 440, x2: 840, y2: 440, label: '«usa»', dashed: true });

    // Controladores MVC (Servlets)
    content += renderClassBox({
        x: 30, y: 560, width: 220, headerColor: '#6b21a8', title: 'AutorServlet', stereotype: 'Controlador Servlet',
        attributes: [
            'autorDAO : AutorDAO'
        ],
        methods: [
            'doGet(req, resp) : void',
            'doPost(req, resp) : void'
        ]
    }).svg;

    content += renderClassBox({
        x: 290, y: 560, width: 250, headerColor: '#6b21a8', title: 'CatalogoServlet', stereotype: 'Controlador Servlet',
        attributes: [
            'libroDAO : LibroDAO',
            'categoriaDAO : CategoriaDAO'
        ],
        methods: [
            'doGet(req, resp) : void'
        ]
    }).svg;

    content += renderClassBox({
        x: 580, y: 560, width: 220, headerColor: '#6b21a8', title: 'CategoriaServlet', stereotype: 'Controlador Servlet',
        attributes: [
            'categoriaDAO : CategoriaDAO'
        ],
        methods: [
            'doGet(req, resp) : void',
            'doPost(req, resp) : void'
        ]
    }).svg;

    content += renderClassBox({
        x: 840, y: 560, width: 230, headerColor: '#6b21a8', title: 'LibroServlet', stereotype: 'Controlador Servlet',
        attributes: [
            'libroDAO : LibroDAO',
            'autorDAO : AutorDAO',
            'categoriaDAO : CategoriaDAO'
        ],
        methods: [
            'doGet(req, resp) : void',
            'doPost(req, resp) : void'
        ]
    }).svg;

    // Dependencias Servlets -> DAO
    content += renderArrow({ x1: 140, y1: 560, x2: 140, y2: 500, label: '«usa»', dashed: true });
    content += renderArrow({ x1: 415, y1: 560, x2: 415, y2: 520, label: '«usa»', dashed: true });
    content += renderArrow({ x1: 690, y1: 560, x2: 690, y2: 500, label: '«usa»', dashed: true });
    content += renderArrow({ x1: 840, y1: 600, x2: 540, y2: 460, label: '«usa»', dashed: true });

    return wrapSvg(1100, 710, content, 'Módulo 1: Gestión Bibliográfica y Catálogo (Libros, Autores, Categorías)');
}

// =========================================================================
// 2. DIAGRAMA 2: MÓDULO DE PRÉSTAMOS, CIRCULACIÓN Y SANCIONES
// =========================================================================
function generarDiagramaPrestamos() {
    let content = '';

    // Entidades
    content += renderClassBox({
        x: 30, y: 90, width: 230, headerColor: '#1e40af', title: 'Usuario', stereotype: 'Modelo Bean',
        attributes: [
            'idUsuario : int',
            'nombre : String',
            'correo : String',
            'rol : String',
            'estado : String'
        ],
        methods: [
            'getIdUsuario() : int',
            'getNombre() : String',
            'getRol() : String'
        ]
    }).svg;

    content += renderClassBox({
        x: 330, y: 90, width: 280, headerColor: '#1e40af', title: 'Prestamo', stereotype: 'Modelo Bean',
        attributes: [
            'idPrestamo : int',
            'idUsuario : int',
            'idLibro : int',
            'fechaPrestamo : String',
            'fechaDevolucion : String',
            'estado : String',
            'usuario : Usuario',
            'libro : Libro'
        ],
        methods: [
            'getIdPrestamo() : int',
            'getIdUsuario() : int',
            'getIdLibro() : int',
            'getFechaPrestamo() : String',
            'getFechaDevolucion() : String',
            'getEstado() : String',
            'setEstado(String) : void'
        ]
    }).svg;

    content += renderClassBox({
        x: 680, y: 90, width: 230, headerColor: '#1e40af', title: 'Libro', stereotype: 'Modelo Bean',
        attributes: [
            'idLibro : int',
            'titulo : String',
            'stock : int',
            'isbn : String'
        ],
        methods: [
            'getIdLibro() : int',
            'getTitulo() : String',
            'getStock() : int'
        ]
    }).svg;

    // Relaciones
    content += renderArrow({ x1: 330, y1: 170, x2: 260, y2: 170, label: 'solicitado por', multiplicityFrom: '*', multiplicityTo: '1' });
    content += renderArrow({ x1: 610, y1: 170, x2: 680, y2: 170, label: 'asociado a', multiplicityFrom: '*', multiplicityTo: '1' });

    // DAO y Conexión
    content += renderClassBox({
        x: 330, y: 370, width: 280, headerColor: '#0f766e', title: 'PrestamoDAO', stereotype: 'Modelo DAO',
        attributes: [],
        methods: [
            'listar() : List<Prestamo>',
            'listarPorUsuario(int) : List<Prestamo>',
            'obtenerPorId(int) : Prestamo',
            'agregar(Prestamo) : void',
            'actualizar(Prestamo) : void',
            'eliminar(int) : void'
        ]
    }).svg;

    content += renderClassBox({
        x: 680, y: 370, width: 230, headerColor: '#3730a3', title: 'Conexion', stereotype: 'Modelo Conexión',
        attributes: [
            'URLS : String[]',
            'USER : String'
        ],
        methods: [
            'conectar() : Connection'
        ]
    }).svg;

    content += renderArrow({ x1: 470, y1: 370, x2: 470, y2: 330, label: '«gestiona»', dashed: true });
    content += renderArrow({ x1: 610, y1: 420, x2: 680, y2: 420, label: '«usa»', dashed: true });

    // Servlets
    content += renderClassBox({
        x: 30, y: 540, width: 230, headerColor: '#6b21a8', title: 'PrestamoServlet', stereotype: 'Controlador Servlet (Admin)',
        attributes: [
            'prestamoDAO : PrestamoDAO',
            'libroDAO : LibroDAO'
        ],
        methods: [
            'doGet(req, resp) : void',
            'doPost(req, resp) : void'
        ]
    }).svg;

    content += renderClassBox({
        x: 290, y: 540, width: 230, headerColor: '#6b21a8', title: 'SolicitarPrestamoServlet', stereotype: 'Controlador Servlet (Lector)',
        attributes: [
            'prestamoDAO : PrestamoDAO',
            'libroDAO : LibroDAO'
        ],
        methods: [
            'doPost(req, resp) : void'
        ]
    }).svg;

    content += renderClassBox({
        x: 550, y: 540, width: 210, headerColor: '#6b21a8', title: 'MisPrestamosServlet', stereotype: 'Controlador Servlet (Lector)',
        attributes: [
            'prestamoDAO : PrestamoDAO'
        ],
        methods: [
            'doGet(req, resp) : void'
        ]
    }).svg;

    content += renderClassBox({
        x: 790, y: 540, width: 210, headerColor: '#6b21a8', title: 'SancionesServlet', stereotype: 'Controlador Servlet (Admin)',
        attributes: [
            'prestamoDAO : PrestamoDAO'
        ],
        methods: [
            'doGet(req, resp) : void',
            'doPost(req, resp) : void'
        ]
    }).svg;

    // Conexiones de Servlets hacia PrestamoDAO
    content += renderArrow({ x1: 145, y1: 540, x2: 340, y2: 490, label: '«usa»', dashed: true });
    content += renderArrow({ x1: 405, y1: 540, x2: 440, y2: 490, label: '«usa»', dashed: true });
    content += renderArrow({ x1: 655, y1: 540, x2: 560, y2: 490, label: '«usa»', dashed: true });
    content += renderArrow({ x1: 895, y1: 540, x2: 610, y2: 480, label: '«usa»', dashed: true });

    return wrapSvg(1030, 690, content, 'Módulo 2: Circulación, Préstamos, Devoluciones y Sanciones');
}

// =========================================================================
// 3. DIAGRAMA 3: MÓDULO DE USUARIOS, AUTENTICACIÓN Y SEGURIDAD
// =========================================================================
function generarDiagramaUsuarios() {
    let content = '';

    // Entidad
    content += renderClassBox({
        x: 350, y: 90, width: 260, headerColor: '#1e40af', title: 'Usuario', stereotype: 'Modelo Bean',
        attributes: [
            'idUsuario : int',
            'nombre : String',
            'correo : String',
            'password : String',
            'rol : String',
            'estado : String'
        ],
        methods: [
            'getIdUsuario() : int',
            'getNombre() : String',
            'getCorreo() : String',
            'getPassword() : String',
            'getRol() : String',
            'getEstado() : String',
            'setEstado(String) : void'
        ]
    }).svg;

    // DAO y Conexión
    content += renderClassBox({
        x: 350, y: 330, width: 260, headerColor: '#0f766e', title: 'UsuarioDAO', stereotype: 'Modelo DAO',
        attributes: [],
        methods: [
            'listar() : List<Usuario>',
            'obtenerPorId(int) : Usuario',
            'autenticar(String, String) : Usuario',
            'agregar(Usuario) : void',
            'actualizar(Usuario) : void',
            'eliminar(int) : void'
        ]
    }).svg;

    content += renderClassBox({
        x: 690, y: 330, width: 220, headerColor: '#3730a3', title: 'Conexion', stereotype: 'Modelo Conexión',
        attributes: [
            'URLS : String[]',
            'USER : String'
        ],
        methods: [
            'conectar() : Connection'
        ]
    }).svg;

    content += renderArrow({ x1: 480, y1: 330, x2: 480, y2: 280, label: '«gestiona»', dashed: true });
    content += renderArrow({ x1: 610, y1: 390, x2: 690, y2: 390, label: '«usa»', dashed: true });

    // Filtro de Seguridad
    content += renderClassBox({
        x: 50, y: 330, width: 240, headerColor: '#991b1b', title: 'AdminFilter', stereotype: 'Controlador Filtro (Seguridad)',
        attributes: [],
        methods: [
            'init(FilterConfig) : void',
            'doFilter(ServletRequest, resp, chain) : void',
            'destroy() : void'
        ]
    }).svg;

    // Servlets
    content += renderClassBox({
        x: 30, y: 510, width: 210, headerColor: '#6b21a8', title: 'LoginServlet', stereotype: 'Controlador Servlet',
        attributes: [
            'usuarioDAO : UsuarioDAO'
        ],
        methods: [
            'doGet(req, resp) : void',
            'doPost(req, resp) : void'
        ]
    }).svg;

    content += renderClassBox({
        x: 270, y: 510, width: 200, headerColor: '#6b21a8', title: 'LogoutServlet', stereotype: 'Controlador Servlet',
        attributes: [],
        methods: [
            'doGet(req, resp) : void'
        ]
    }).svg;

    content += renderClassBox({
        x: 500, y: 510, width: 210, headerColor: '#6b21a8', title: 'RegistroServlet', stereotype: 'Controlador Servlet',
        attributes: [
            'usuarioDAO : UsuarioDAO'
        ],
        methods: [
            'doGet(req, resp) : void',
            'doPost(req, resp) : void'
        ]
    }).svg;

    content += renderClassBox({
        x: 740, y: 510, width: 210, headerColor: '#6b21a8', title: 'UsuarioServlet', stereotype: 'Controlador Servlet (Admin)',
        attributes: [
            'usuarioDAO : UsuarioDAO'
        ],
        methods: [
            'doGet(req, resp) : void',
            'doPost(req, resp) : void'
        ]
    }).svg;

    // Dependencias Servlets -> DAO
    content += renderArrow({ x1: 135, y1: 510, x2: 350, y2: 440, label: '«usa»', dashed: true });
    content += renderArrow({ x1: 605, y1: 510, x2: 540, y2: 460, label: '«usa»', dashed: true });
    content += renderArrow({ x1: 845, y1: 510, x2: 610, y2: 440, label: '«usa»', dashed: true });
    content += renderArrow({ x1: 50, y1: 370, x2: 30, y2: 370, label: '', dashed: true });

    return wrapSvg(980, 660, content, 'Módulo 3: Usuarios, Autenticación, Sesiones y Filtro de Seguridad');
}

// =========================================================================
// 4. DIAGRAMA 4: MÓDULO DE DONACIONES, REPORTES E INNOVACIÓN ODS 09
// =========================================================================
function generarDiagramaDonacionesReportes() {
    let content = '';

    // Entidad Donacion
    content += renderClassBox({
        x: 50, y: 90, width: 280, headerColor: '#1e40af', title: 'Donacion', stereotype: 'Modelo Bean',
        attributes: [
            'idDonacion : int',
            'tituloLibro : String',
            'autor : String',
            'categoria : String',
            'anio : int',
            'estadoConservacion : String',
            'nombreDonante : String',
            'correoDonante : String',
            'telefonoDonante : String',
            'motivoMensaje : String',
            'fechaSolicitud : String',
            'estadoRevision : String'
        ],
        methods: [
            'getIdDonacion() : int',
            'getTituloLibro() : String',
            'getAutor() : String',
            'getEstadoRevision() : String',
            'setEstadoRevision(String) : void'
        ]
    }).svg;

    // DonacionDAO y Conexión
    content += renderClassBox({
        x: 400, y: 90, width: 260, headerColor: '#0f766e', title: 'DonacionDAO', stereotype: 'Modelo DAO',
        attributes: [],
        methods: [
            'listar() : List<Donacion>',
            'obtenerPorId(int) : Donacion',
            'agregar(Donacion) : void',
            'actualizar(Donacion) : void',
            'eliminar(int) : void'
        ]
    }).svg;

    content += renderClassBox({
        x: 720, y: 90, width: 220, headerColor: '#3730a3', title: 'Conexion', stereotype: 'Modelo Conexión',
        attributes: [
            'URLS : String[]',
            'USER : String'
        ],
        methods: [
            'conectar() : Connection'
        ]
    }).svg;

    content += renderArrow({ x1: 400, y1: 170, x2: 330, y2: 170, label: '«gestiona»', dashed: true });
    content += renderArrow({ x1: 660, y1: 170, x2: 720, y2: 170, label: '«usa»', dashed: true });

    // Servlets Donacion / Donaciones
    content += renderClassBox({
        x: 50, y: 440, width: 230, headerColor: '#6b21a8', title: 'DonacionServlet', stereotype: 'Controlador Servlet (Público)',
        attributes: [
            'donacionDAO : DonacionDAO'
        ],
        methods: [
            'doGet(req, resp) : void',
            'doPost(req, resp) : void'
        ]
    }).svg;

    content += renderClassBox({
        x: 320, y: 440, width: 240, headerColor: '#6b21a8', title: 'DonacionesServlet', stereotype: 'Controlador Servlet (Admin)',
        attributes: [
            'donacionDAO : DonacionDAO'
        ],
        methods: [
            'doGet(req, resp) : void',
            'doPost(req, resp) : void'
        ]
    }).svg;

    content += renderClassBox({
        x: 600, y: 440, width: 220, headerColor: '#6b21a8', title: 'ReportesServlet', stereotype: 'Controlador Servlet (Admin)',
        attributes: [
            'prestamoDAO : PrestamoDAO',
            'libroDAO : LibroDAO',
            'usuarioDAO : UsuarioDAO'
        ],
        methods: [
            'doGet(req, resp) : void'
        ]
    }).svg;

    content += renderClassBox({
        x: 850, y: 440, width: 220, headerColor: '#6b21a8', title: 'InnovacionServlet', stereotype: 'Controlador Servlet (ODS 09)',
        attributes: [
            'herramientasAccesibilidad : List'
        ],
        methods: [
            'doGet(req, resp) : void'
        ]
    }).svg;

    // Dependencias
    content += renderArrow({ x1: 165, y1: 440, x2: 440, y2: 250, label: '«usa»', dashed: true });
    content += renderArrow({ x1: 440, y1: 440, x2: 500, y2: 250, label: '«usa»', dashed: true });

    return wrapSvg(1100, 590, content, 'Módulo 4: Donaciones Comunitarias, Reportes e Innovación Accesible ODS 09');
}

// =========================================================================
// 5. DIAGRAMA 5: MODELO GENERAL DE DOMINIO (BEANS DE TODA LA BIBLIOTECA)
// =========================================================================
function generarDiagramaDominioGeneral() {
    let content = '';

    content += renderClassBox({
        x: 30, y: 90, width: 220, headerColor: '#1e40af', title: 'Autor', stereotype: 'Modelo Bean',
        attributes: [
            'idAutor : int',
            'nombre : String',
            'nacionalidad : String'
        ],
        methods: [
            'getIdAutor() : int',
            'getNombre() : String',
            'getNacionalidad() : String'
        ]
    }).svg;

    content += renderClassBox({
        x: 300, y: 90, width: 240, headerColor: '#1e40af', title: 'Libro', stereotype: 'Modelo Bean',
        attributes: [
            'idLibro : int',
            'titulo : String',
            'isbn : String',
            'anio : int',
            'descripcion : String',
            'stock : int',
            'idAutor : int',
            'idCategoria : int',
            'imagenPortada : String',
            'autor : Autor',
            'categoria : Categoria'
        ],
        methods: [
            'getIdLibro() : int',
            'getTitulo() : String',
            'getStock() : int',
            'getAutor() : Autor',
            'getCategoria() : Categoria'
        ]
    }).svg;

    content += renderClassBox({
        x: 590, y: 90, width: 220, headerColor: '#1e40af', title: 'Categoria', stereotype: 'Modelo Bean',
        attributes: [
            'idCategoria : int',
            'nombre : String',
            'descripcion : String'
        ],
        methods: [
            'getIdCategoria() : int',
            'getNombre() : String',
            'getDescripcion() : String'
        ]
    }).svg;

    content += renderClassBox({
        x: 300, y: 400, width: 240, headerColor: '#1e40af', title: 'Prestamo', stereotype: 'Modelo Bean',
        attributes: [
            'idPrestamo : int',
            'idUsuario : int',
            'idLibro : int',
            'fechaPrestamo : String',
            'fechaDevolucion : String',
            'estado : String',
            'usuario : Usuario',
            'libro : Libro'
        ],
        methods: [
            'getIdPrestamo() : int',
            'getIdUsuario() : int',
            'getIdLibro() : int',
            'getEstado() : String'
        ]
    }).svg;

    content += renderClassBox({
        x: 30, y: 400, width: 220, headerColor: '#1e40af', title: 'Usuario', stereotype: 'Modelo Bean',
        attributes: [
            'idUsuario : int',
            'nombre : String',
            'correo : String',
            'password : String',
            'rol : String',
            'estado : String'
        ],
        methods: [
            'getIdUsuario() : int',
            'getNombre() : String',
            'getCorreo() : String',
            'getRol() : String'
        ]
    }).svg;

    content += renderClassBox({
        x: 590, y: 400, width: 240, headerColor: '#1e40af', title: 'Donacion', stereotype: 'Modelo Bean',
        attributes: [
            'idDonacion : int',
            'tituloLibro : String',
            'autor : String',
            'categoria : String',
            'anio : int',
            'estadoConservacion : String',
            'nombreDonante : String',
            'correoDonante : String',
            'motivoMensaje : String',
            'estadoRevision : String'
        ],
        methods: [
            'getIdDonacion() : int',
            'getTituloLibro() : String',
            'getEstadoRevision() : String'
        ]
    }).svg;

    // Relaciones
    content += renderArrow({ x1: 300, y1: 170, x2: 250, y2: 170, label: 'escrito por', multiplicityFrom: '*', multiplicityTo: '1' });
    content += renderArrow({ x1: 540, y1: 170, x2: 590, y2: 170, label: 'pertenece a', multiplicityFrom: '*', multiplicityTo: '1' });
    content += renderArrow({ x1: 420, y1: 400, x2: 420, y2: 350, label: 'ejemplar prestado', multiplicityFrom: '*', multiplicityTo: '1' });
    content += renderArrow({ x1: 300, y1: 480, x2: 250, y2: 480, label: 'solicitado por', multiplicityFrom: '*', multiplicityTo: '1' });

    return wrapSvg(860, 680, content, 'Modelo Integral de Dominio y Entidades (Beans)');
}

// Generar todos los archivos
const files = [
    { name: 'diagrama-1-bibliografico.svg', fn: generarDiagramaBibliografico },
    { name: 'diagrama-2-prestamos-sanciones.svg', fn: generarDiagramaPrestamos },
    { name: 'diagrama-3-usuarios-seguridad.svg', fn: generarDiagramaUsuarios },
    { name: 'diagrama-4-donaciones-reportes.svg', fn: generarDiagramaDonacionesReportes },
    { name: 'diagrama-5-dominio-general.svg', fn: generarDiagramaDominioGeneral }
];

files.forEach(({ name, fn }) => {
    const svg = fn();
    fs.writeFileSync(path.join(outDir, name), svg, 'utf8');
    fs.writeFileSync(path.join(webappOutDir, name), svg, 'utf8');
    console.log(`Generado: ${name}`);
});

console.log('Todos los diagramas UML fueron generados con éxito.');
