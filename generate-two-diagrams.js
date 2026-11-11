const fs = require('fs');
const path = require('path');
const { Resvg } = require('@resvg/resvg-js');

const outDir = path.join(__dirname, 'img', 'uml');
const webappOutDir = path.join(__dirname, 'src', 'main', 'webapp', 'img', 'uml');
const desktopDir = 'C:\\Users\\Jesus Angel\\Desktop';

if (!fs.existsSync(outDir)) fs.mkdirSync(outDir, { recursive: true });
if (!fs.existsSync(webappOutDir)) fs.mkdirSync(webappOutDir, { recursive: true });

// =========================================================================
// RENDERIZADOR DE CAJA DE CLASE UML
// =========================================================================
function renderClassBox({ x, y, width, headerColor = '#1f6feb', title, stereotype = '', attributes = [], methods = [], isDark = false }) {
    const lineHeight = 18;
    const headerHeight = stereotype ? 36 : 28;
    const attrHeight = Math.max(attributes.length * lineHeight + 12, 16);
    const methodHeight = methods.length > 0 ? (methods.length * lineHeight + 12) : 0;
    const totalHeight = headerHeight + attrHeight + methodHeight;

    const boxBg = isDark ? '#161b22' : '#ffffff';
    const boxBorder = isDark ? '#30363d' : '#94a3b8';
    const textAttr = isDark ? '#e6edf3' : '#1e293b';
    const textMeth = isDark ? '#79c0ff' : '#0f766e';
    const dividerColor = isDark ? '#30363d' : '#cbd5e1';

    let svg = `
    <!-- Clase: ${title} -->
    <g transform="translate(${x}, ${y})" filter="url(#dropShadow)">
        <rect width="${width}" height="${totalHeight}" rx="6" fill="${boxBg}" stroke="${boxBorder}" stroke-width="1.2"/>
        <path d="M 0 6 C 0 2.7 2.7 0 6 0 L ${width - 6} 0 C ${width - 2.7} 0 ${width} 2.7 ${width} 6 L ${width} ${headerHeight} L 0 ${headerHeight} Z" fill="${headerColor}"/>
        ${stereotype ? `<text x="${width/2}" y="14" fill="#cbd5e1" font-size="10" font-family="'Segoe UI', Roboto, sans-serif" font-style="italic" text-anchor="middle">&#171;${stereotype}&#187;</text>` : ''}
        <text x="${width/2}" y="${stereotype ? 28 : 18}" fill="#ffffff" font-size="12.5" font-weight="700" font-family="'Segoe UI', Roboto, sans-serif" text-anchor="middle">${title}</text>
        
        <line x1="0" y1="${headerHeight}" x2="${width}" y2="${headerHeight}" stroke="${dividerColor}" stroke-width="1"/>
        <g transform="translate(10, ${headerHeight + 14})">
    `;

    attributes.forEach((attr, i) => {
        const safeAttr = String(attr).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
        svg += `        <text x="0" y="${i * lineHeight}" fill="${textAttr}" font-size="11" font-family="'Consolas', 'Courier New', monospace">${safeAttr}</text>\n`;
    });

    svg += `    </g>\n`;

    if (methods.length > 0) {
        const methodStartY = headerHeight + attrHeight;
        svg += `
        <line x1="0" y1="${methodStartY}" x2="${width}" y2="${methodStartY}" stroke="${dividerColor}" stroke-width="1"/>
        <g transform="translate(10, ${methodStartY + 14})">
        `;
        methods.forEach((meth, i) => {
            const safeMeth = String(meth).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
            svg += `        <text x="0" y="${i * lineHeight}" fill="${textMeth}" font-size="10.5" font-family="'Consolas', 'Courier New', monospace">${safeMeth}</text>\n`;
        });
        svg += `    </g>\n`;
    }

    svg += `    </g>\n`;
    return { svg, totalHeight, width, x, y };
}

// =========================================================================
// RENDERIZADOR DE TABLA ERD (BASE DE DATOS)
// =========================================================================
function renderTableBox({ x, y, width, title, columns = [], isDark = false }) {
    const headerHeight = 28;
    const rowHeight = 20;
    const totalHeight = headerHeight + columns.length * rowHeight + 12;

    const boxBg = isDark ? '#161b22' : '#ffffff';
    const boxBorder = isDark ? '#30363d' : '#94a3b8';
    const headerColor = isDark ? '#238636' : '#0f766e';
    const textName = isDark ? '#f0f6fc' : '#0f172a';
    const textType = isDark ? '#8b949e' : '#64748b';
    const dividerColor = isDark ? '#30363d' : '#cbd5e1';

    let svg = `
    <!-- Tabla: ${title} -->
    <g transform="translate(${x}, ${y})" filter="url(#dropShadow)">
        <rect width="${width}" height="${totalHeight}" rx="6" fill="${boxBg}" stroke="${boxBorder}" stroke-width="1.2"/>
        <path d="M 0 6 C 0 2.7 2.7 0 6 0 L ${width - 6} 0 C ${width - 2.7} 0 ${width} 2.7 ${width} 6 L ${width} ${headerHeight} L 0 ${headerHeight} Z" fill="${headerColor}"/>
        <text x="${width/2}" y="18" fill="#ffffff" font-size="12" font-weight="700" font-family="'Consolas', monospace" text-anchor="middle">${title}</text>
        <line x1="0" y1="${headerHeight}" x2="${width}" y2="${headerHeight}" stroke="${dividerColor}" stroke-width="1"/>
        <g transform="translate(10, ${headerHeight + 14})">
    `;

    columns.forEach((col, i) => {
        const isPk = col.key === 'PK';
        const isFk = col.key === 'FK';
        const badgeColor = isPk ? '#ef4444' : (isFk ? '#0ea5e9' : 'transparent');
        const badgeText = isPk ? '#ffffff' : (isFk ? '#ffffff' : textType);
        
        svg += `    <g transform="translate(0, ${i * rowHeight})">`;
        if (col.key) {
            svg += `<rect x="0" y="-10" width="24" height="15" rx="3" fill="${badgeColor}"/>`;
            svg += `<text x="12" y="1" fill="${badgeText}" font-size="9" font-weight="800" font-family="'Consolas', monospace" text-anchor="middle">${col.key}</text>`;
        }
        svg += `<text x="32" y="1" fill="${textName}" font-size="11.5" font-weight="${isPk ? '700' : '500'}" font-family="'Consolas', monospace">${col.name}</text>`;
        svg += `<text x="${width - 20}" y="1" fill="${textType}" font-size="11" font-family="'Consolas', monospace" text-anchor="end">${col.type}</text>`;
        svg += `</g>\n`;
    });

    svg += `    </g>\n    </g>\n`;
    return { svg, totalHeight, width, x, y };
}

// =========================================================================
// RENDERIZADOR DE CONECTORES Y LÍNEAS ORTOGONALES
// =========================================================================
function renderOrthogonalLine({ points, label = '', multiplicityFrom = '', multiplicityTo = '', dashed = false, marker = 'arrow', isDark = false, labelPos = null }) {
    const strokeColor = isDark ? '#8b949e' : '#475569';
    const textColor = isDark ? '#f0f6fc' : '#0f172a';
    const multColor = isDark ? '#79c0ff' : '#0284c7';
    const dashAttr = dashed ? 'stroke-dasharray="5,5"' : '';

    const pathData = points.reduce((acc, pt, i) => i === 0 ? `M ${pt.x} ${pt.y}` : `${acc} L ${pt.x} ${pt.y}`, '');

    let svg = `<path d="${pathData}" fill="none" stroke="${strokeColor}" stroke-width="1.6" ${dashAttr} marker-end="url(#${marker})" stroke-linejoin="round" stroke-linecap="round"/>\n`;

    if (label) {
        let lx, ly;
        if (labelPos) {
            lx = labelPos.x;
            ly = labelPos.y;
        } else {
            const midIdx = Math.floor(points.length / 2);
            lx = (points[midIdx - 1].x + points[midIdx].x) / 2;
            ly = (points[midIdx - 1].y + points[midIdx].y) / 2 - 8;
        }
        svg += `<text x="${lx}" y="${ly}" fill="${textColor}" font-size="11" font-weight="600" font-family="'Segoe UI', Roboto, sans-serif" text-anchor="middle">${label}</text>\n`;
    }

    if (multiplicityFrom && points.length >= 2) {
        const p1 = points[0];
        const p2 = points[1];
        const dx = p2.x - p1.x;
        const dy = p2.y - p1.y;
        const ox = p1.x + (dx !== 0 ? Math.sign(dx) * 16 : 14);
        const oy = p1.y + (dy !== 0 ? Math.sign(dy) * 16 : -6);
        svg += `<text x="${ox}" y="${oy}" fill="${multColor}" font-size="11.5" font-weight="700" font-family="'Consolas', monospace" text-anchor="middle">${multiplicityFrom}</text>\n`;
    }

    if (multiplicityTo && points.length >= 2) {
        const pEnd = points[points.length - 1];
        const pPrev = points[points.length - 2];
        const dx = pEnd.x - pPrev.x;
        const dy = pEnd.y - pPrev.y;
        const ox = pEnd.x - (dx !== 0 ? Math.sign(dx) * 22 : 14);
        const oy = pEnd.y - (dy !== 0 ? Math.sign(dy) * 20 : -6);
        svg += `<text x="${ox}" y="${oy}" fill="${multColor}" font-size="11.5" font-weight="700" font-family="'Consolas', monospace" text-anchor="middle">${multiplicityTo}</text>\n`;
    }

    return svg;
}

// =========================================================================
// 1. GENERADOR DE DIAGRAMA DE CLASES UML (Versiones Light y Dark)
// =========================================================================
function buildUMLDiagram(isDark) {
    const width = 1240;
    const height = 980;

    const bg = isDark ? '#0d1117' : '#f8fafc';
    const innerBg = isDark ? '#161b22' : '#ffffff';
    const border = isDark ? '#30363d' : '#e2e8f0';
    const titleColor = isDark ? '#f0f6fc' : '#0f172a';
    const subColor = isDark ? '#8b949e' : '#64748b';
    const divider = isDark ? '#30363d' : '#cbd5e1';

    const headerBean = isDark ? '#1f6feb' : '#1e40af';
    const headerDao = isDark ? '#238636' : '#0f766e';
    const headerConn = isDark ? '#8957e5' : '#3730a3';

    let content = '';

    // ================= COLUMNA 1 (X: 50): Autores y Categorías =================
    content += renderClassBox({
        x: 50, y: 90, width: 250, headerColor: headerBean, title: 'Autor', stereotype: 'modelo.beans', isDark,
        attributes: ['idAutor : int', 'nombre : String', 'nacionalidad : String'],
        methods: ['getIdAutor() : int', 'getNombre() : String', 'getNacionalidad() : String']
    }).svg;

    content += renderClassBox({
        x: 50, y: 310, width: 250, headerColor: headerBean, title: 'Categoria', stereotype: 'modelo.beans', isDark,
        attributes: ['idCategoria : int', 'nombre : String', 'descripcion : String'],
        methods: ['getIdCategoria() : int', 'getNombre() : String', 'getDescripcion() : String']
    }).svg;

    content += renderClassBox({
        x: 50, y: 530, width: 250, headerColor: headerDao, title: 'AutorDAO', stereotype: 'modelo.dao', isDark,
        attributes: [],
        methods: ['listar() : List<Autor>', 'obtenerPorId(int) : Autor', 'agregar(Autor) : void', 'actualizar(Autor) : void', 'eliminar(int) : void']
    }).svg;

    content += renderClassBox({
        x: 50, y: 730, width: 250, headerColor: headerDao, title: 'CategoriaDAO', stereotype: 'modelo.dao', isDark,
        attributes: [],
        methods: ['listar() : List<Categoria>', 'obtenerPorId(int) : Categoria', 'agregar(Categoria) : void', 'actualizar(Categoria) : void', 'eliminar(int) : void']
    }).svg;

    // ================= COLUMNA 2 (X: 430): Libros y Donaciones =================
    content += renderClassBox({
        x: 430, y: 90, width: 300, headerColor: headerBean, title: 'Libro', stereotype: 'modelo.beans', isDark,
        attributes: [
            'idLibro : int', 'titulo : String', 'isbn : String', 'anio : int',
            'descripcion : String', 'stock : int', 'idAutor : int', 'idCategoria : int',
            'imagenPortada : String', 'autor : Autor', 'categoria : Categoria'
        ],
        methods: [
            'getIdLibro() : int', 'getTitulo() : String', 'getStock() : int',
            'getAutor() : Autor', 'getCategoria() : Categoria', 'setStock(int) : void'
        ]
    }).svg;

    content += renderClassBox({
        x: 430, y: 490, width: 300, headerColor: headerBean, title: 'Donacion', stereotype: 'modelo.beans', isDark,
        attributes: [
            'idDonacion : int', 'tituloLibro : String', 'autor : String', 'categoria : String',
            'anio : int', 'estadoConservacion : String', 'nombreDonante : String',
            'correoDonante : String', 'estadoRevision : String'
        ],
        methods: [
            'getIdDonacion() : int', 'getTituloLibro() : String',
            'getEstadoRevision() : String', 'setEstadoRevision(String) : void'
        ]
    }).svg;

    content += renderClassBox({
        x: 430, y: 760, width: 300, headerColor: headerDao, title: 'LibroDAO', stereotype: 'modelo.dao', isDark,
        attributes: [],
        methods: [
            'listar() : List<Libro>', 'obtenerPorId(int) : Libro', 'buscar(String, String) : List<Libro>',
            'agregar(Libro) : void', 'actualizar(Libro) : void', 'actualizarStock(int, int) : void'
        ]
    }).svg;

    // ================= COLUMNA 3 (X: 860): Usuarios, Préstamos y DAO =================
    content += renderClassBox({
        x: 860, y: 90, width: 280, headerColor: headerBean, title: 'Usuario', stereotype: 'modelo.beans', isDark,
        attributes: [
            'idUsuario : int', 'nombre : String', 'correo : String',
            'password : String', 'rol : String', 'estado : String'
        ],
        methods: [
            'getIdUsuario() : int', 'getNombre() : String', 'getCorreo() : String',
            'getRol() : String', 'getEstado() : String'
        ]
    }).svg;

    content += renderClassBox({
        x: 860, y: 360, width: 280, headerColor: headerBean, title: 'Prestamo', stereotype: 'modelo.beans', isDark,
        attributes: [
            'idPrestamo : int', 'idUsuario : int', 'idLibro : int',
            'fechaPrestamo : String', 'fechaDevolucion : String', 'estado : String',
            'usuario : Usuario', 'libro : Libro'
        ],
        methods: [
            'getIdPrestamo() : int', 'getIdUsuario() : int', 'getIdLibro() : int',
            'getEstado() : String', 'setEstado(String) : void'
        ]
    }).svg;

    content += renderClassBox({
        x: 860, y: 640, width: 280, headerColor: headerDao, title: 'UsuarioDAO', stereotype: 'modelo.dao', isDark,
        attributes: [],
        methods: [
            'listar() : List<Usuario>', 'obtenerPorId(int) : Usuario',
            'autenticar(String, String) : Usuario', 'agregar(Usuario) : void', 'actualizar(Usuario) : void'
        ]
    }).svg;

    content += renderClassBox({
        x: 860, y: 810, width: 280, headerColor: headerDao, title: 'PrestamoDAO', stereotype: 'modelo.dao', isDark,
        attributes: [],
        methods: [
            'listar() : List<Prestamo>', 'listarMorosos() : List<Prestamo>',
            'listarPorUsuario(int) : List<Prestamo>', 'obtenerPorId(int) : Prestamo',
            'agregar(Prestamo) : void', 'actualizar(Prestamo) : void'
        ]
    }).svg;

    // ================= BLOQUE CENTRAL BASE: DonacionDAO y Conexion =================
    content += renderClassBox({
        x: 430, y: 960 - 20, width: 300, headerColor: headerDao, title: 'DonacionDAO', stereotype: 'modelo.dao', isDark,
        attributes: [],
        methods: ['listar() : List<Donacion>', 'obtenerPorId(int) : Donacion', 'agregar(Donacion) : void']
    }).svg;

    // ================= LÍNEAS DE RELACIÓN ORTOGONALES Y CLARAS =================
    
    // 1. Autor -> Libro (Asociación 1 a N)
    content += renderOrthogonalLine({
        points: [{ x: 300, y: 170 }, { x: 430, y: 170 }],
        label: 'escrito por', multiplicityFrom: '1', multiplicityTo: '*',
        marker: 'arrow', isDark
    });

    // 2. Categoria -> Libro (Asociación 1 a N)
    content += renderOrthogonalLine({
        points: [{ x: 300, y: 370 }, { x: 360, y: 370 }, { x: 360, y: 250 }, { x: 430, y: 250 }],
        label: 'clasificado en', multiplicityFrom: '1', multiplicityTo: '*',
        marker: 'arrow', isDark, labelPos: { x: 375, y: 310 }
    });

    // 3. Usuario -> Prestamo (Asociación 1 a N)
    content += renderOrthogonalLine({
        points: [{ x: 1000, y: 310 }, { x: 1000, y: 360 }],
        label: 'solicita', multiplicityFrom: '1', multiplicityTo: '*',
        marker: 'arrow', isDark, labelPos: { x: 1040, y: 335 }
    });

    // 4. Libro -> Prestamo (Asociación 1 a N)
    content += renderOrthogonalLine({
        points: [{ x: 730, y: 220 }, { x: 790, y: 220 }, { x: 790, y: 440 }, { x: 860, y: 440 }],
        label: 'incluye ejemplar', multiplicityFrom: '1', multiplicityTo: '*',
        marker: 'arrow', isDark, labelPos: { x: 790, y: 330 }
    });

    // 5. Usuario -> Donacion (Asociación 1 a N)
    content += renderOrthogonalLine({
        points: [{ x: 860, y: 280 }, { x: 800, y: 280 }, { x: 800, y: 550 }, { x: 730, y: 550 }],
        label: 'dona', multiplicityFrom: '1', multiplicityTo: '*',
        marker: 'arrow', isDark, labelPos: { x: 800, y: 415 }
    });

    // 6. Dependencias DAO -> Entidades Beans (Líneas Discontinuas «administra»)
    content += renderOrthogonalLine({
        points: [{ x: 175, y: 530 }, { x: 175, y: 265 }],
        label: '«administra»', dashed: true, marker: 'arrow', isDark, labelPos: { x: 225, y: 395 }
    });

    content += renderOrthogonalLine({
        points: [{ x: 580, y: 760 }, { x: 580, y: 456 }],
        label: '«administra»', dashed: true, marker: 'arrow', isDark, labelPos: { x: 630, y: 620 }
    });

    content += renderOrthogonalLine({
        points: [{ x: 1000, y: 640 }, { x: 1000, y: 595 }],
        label: '«persiste»', dashed: true, marker: 'arrow', isDark, labelPos: { x: 1045, y: 620 }
    });

    // Marco SVG
    return `<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${width} ${height}" width="${width}" height="${height}">
    <defs>
        <filter id="dropShadow" x="-5%" y="-5%" width="112%" height="115%">
            <feDropShadow dx="0" dy="2" stdDeviation="3" flood-color="#000000" flood-opacity="${isDark ? '0.4' : '0.12'}"/>
        </filter>
        <marker id="arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto">
            <path d="M 0 1 L 9 5 L 0 9 z" fill="${isDark ? '#8b949e' : '#475569'}"/>
        </marker>
    </defs>

    <rect width="${width}" height="${height}" fill="${bg}"/>
    <rect x="8" y="8" width="${width - 16}" height="${height - 16}" rx="8" fill="${innerBg}" stroke="${border}" stroke-width="1.2"/>

    <!-- Título y Subtítulo -->
    <text x="35" y="42" fill="${titleColor}" font-size="20" font-weight="800" font-family="'Segoe UI', Roboto, sans-serif">Diagrama de Clases UML del Sistema BookHub</text>
    <text x="35" y="64" fill="${subColor}" font-size="12" font-family="'Segoe UI', Roboto, sans-serif">Arquitectura MVC • Entidades de Dominio (modelo.beans) y Capa DAO (modelo.dao)</text>
    <line x1="35" y1="74" x2="${width - 35}" y2="74" stroke="${divider}" stroke-width="1"/>

    ${content}
</svg>`;
}

// =========================================================================
// 2. GENERADOR DE MODELO DE DATOS ERD (Versiones Light y Dark)
// =========================================================================
function buildERDDiagram(isDark) {
    const width = 1200;
    const height = 750;

    const bg = isDark ? '#0d1117' : '#f8fafc';
    const innerBg = isDark ? '#161b22' : '#ffffff';
    const border = isDark ? '#30363d' : '#e2e8f0';
    const titleColor = isDark ? '#f0f6fc' : '#0f172a';
    const subColor = isDark ? '#8b949e' : '#64748b';
    const divider = isDark ? '#30363d' : '#cbd5e1';

    let content = '';

    // Columna 1 (X: 50): autores y categorias
    content += renderTableBox({
        x: 50, y: 100, width: 280, title: 'autores', isDark,
        columns: [
            { key: 'PK', name: 'id_autor', type: 'INT (AUTO_INC)' },
            { key: '', name: 'nombre', type: 'VARCHAR(120)' },
            { key: '', name: 'nacionalidad', type: 'VARCHAR(80)' }
        ]
    }).svg;

    content += renderTableBox({
        x: 50, y: 280, width: 280, title: 'categorias', isDark,
        columns: [
            { key: 'PK', name: 'id_categoria', type: 'INT (AUTO_INC)' },
            { key: '', name: 'nombre', type: 'VARCHAR(100)' },
            { key: '', name: 'descripcion', type: 'VARCHAR(255)' }
        ]
    }).svg;

    // Columna 2 (X: 430): libros y prestamos
    content += renderTableBox({
        x: 430, y: 100, width: 330, title: 'libros', isDark,
        columns: [
            { key: 'PK', name: 'id_libro', type: 'INT (AUTO_INC)' },
            { key: '', name: 'titulo', type: 'VARCHAR(200)' },
            { key: '', name: 'isbn', type: 'VARCHAR(30)' },
            { key: '', name: 'anio', type: 'INT' },
            { key: '', name: 'descripcion', type: 'TEXT' },
            { key: '', name: 'stock', type: 'INT DEFAULT 0' },
            { key: 'FK', name: 'id_autor', type: 'INT (autores)' },
            { key: 'FK', name: 'id_categoria', type: 'INT (categorias)' },
            { key: '', name: 'imagen_portada', type: 'LONGTEXT' }
        ]
    }).svg;

    content += renderTableBox({
        x: 430, y: 460, width: 330, title: 'prestamos', isDark,
        columns: [
            { key: 'PK', name: 'id_prestamo', type: 'INT (AUTO_INC)' },
            { key: 'FK', name: 'id_usuario', type: 'INT (usuarios)' },
            { key: 'FK', name: 'id_libro', type: 'INT (libros)' },
            { key: '', name: 'fecha_prestamo', type: 'VARCHAR(20)' },
            { key: '', name: 'fecha_devolucion', type: 'VARCHAR(20)' },
            { key: '', name: 'estado', type: 'VARCHAR(20)' }
        ]
    }).svg;

    // Columna 3 (X: 860): usuarios y donaciones
    content += renderTableBox({
        x: 860, y: 100, width: 290, title: 'usuarios', isDark,
        columns: [
            { key: 'PK', name: 'id_usuario', type: 'INT (AUTO_INC)' },
            { key: '', name: 'nombre', type: 'VARCHAR(120)' },
            { key: '', name: 'correo', type: 'VARCHAR(120) UNIQUE' },
            { key: '', name: 'password', type: 'VARCHAR(120)' },
            { key: '', name: 'rol', type: 'VARCHAR(20)' },
            { key: '', name: 'estado', type: 'VARCHAR(20)' }
        ]
    }).svg;

    content += renderTableBox({
        x: 860, y: 370, width: 310, title: 'donaciones', isDark,
        columns: [
            { key: 'PK', name: 'id_donacion', type: 'INT (AUTO_INC)' },
            { key: '', name: 'titulo_libro', type: 'VARCHAR(200)' },
            { key: '', name: 'autor', type: 'VARCHAR(120)' },
            { key: '', name: 'categoria', type: 'VARCHAR(100)' },
            { key: '', name: 'anio', type: 'INT' },
            { key: '', name: 'estado_conservacion', type: 'VARCHAR(50)' },
            { key: '', name: 'nombre_donante', type: 'VARCHAR(120)' },
            { key: '', name: 'correo_donante', type: 'VARCHAR(120)' },
            { key: '', name: 'telefono_donante', type: 'VARCHAR(30)' },
            { key: '', name: 'motivo_mensaje', type: 'TEXT' },
            { key: '', name: 'fecha_solicitud', type: 'VARCHAR(20)' },
            { key: '', name: 'estado_revision', type: 'VARCHAR(30)' }
        ]
    }).svg;

    // ================= LÍNEAS DE RELACIÓN ORTOGONALES DE CLAVES FORÁNEAS =================
    
    // 1. autores (PK: id_autor) -> libros (FK: id_autor)
    content += renderOrthogonalLine({
        points: [{ x: 330, y: 142 }, { x: 380, y: 142 }, { x: 380, y: 264 }, { x: 430, y: 264 }],
        label: 'fk_libro_autor (1:N)', multiplicityFrom: '1', multiplicityTo: 'N',
        marker: 'crow', isDark, labelPos: { x: 380, y: 200 }
    });

    // 2. categorias (PK: id_categoria) -> libros (FK: id_categoria)
    content += renderOrthogonalLine({
        points: [{ x: 330, y: 322 }, { x: 400, y: 322 }, { x: 400, y: 284 }, { x: 430, y: 284 }],
        label: 'fk_libro_categoria (1:N)', multiplicityFrom: '1', multiplicityTo: 'N',
        marker: 'crow', isDark, labelPos: { x: 375, y: 345 }
    });

    // 3. libros (PK: id_libro) -> prestamos (FK: id_libro)
    content += renderOrthogonalLine({
        points: [{ x: 540, y: 385 }, { x: 540, y: 460 }],
        label: 'fk_prestamo_libro (1:N)', multiplicityFrom: '1', multiplicityTo: 'N',
        marker: 'crow', isDark, labelPos: { x: 605, y: 422 }
    });

    // 4. usuarios (PK: id_usuario) -> prestamos (FK: id_usuario)
    content += renderOrthogonalLine({
        points: [{ x: 860, y: 142 }, { x: 810, y: 142 }, { x: 810, y: 502 }, { x: 760, y: 502 }],
        label: 'fk_prestamo_usuario (1:N)', multiplicityFrom: '1', multiplicityTo: 'N',
        marker: 'crow', isDark, labelPos: { x: 810, y: 300 }
    });

    return `<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${width} ${height}" width="${width}" height="${height}">
    <defs>
        <filter id="dropShadow" x="-5%" y="-5%" width="112%" height="115%">
            <feDropShadow dx="0" dy="2" stdDeviation="3" flood-color="#000000" flood-opacity="${isDark ? '0.4' : '0.12'}"/>
        </filter>
        <marker id="crow" viewBox="0 0 12 12" refX="10" refY="6" markerWidth="8" markerHeight="8" orient="auto">
            <path d="M 0 0 L 10 6 L 0 12 M 10 0 L 10 12" fill="none" stroke="${isDark ? '#238636' : '#0f766e'}" stroke-width="1.6"/>
        </marker>
    </defs>

    <rect width="${width}" height="${height}" fill="${bg}"/>
    <rect x="8" y="8" width="${width - 16}" height="${height - 16}" rx="8" fill="${innerBg}" stroke="${border}" stroke-width="1.2"/>

    <!-- Título y Subtítulo -->
    <text x="35" y="42" fill="${titleColor}" font-size="20" font-weight="800" font-family="'Segoe UI', Roboto, sans-serif">Modelo de Datos Relacional (Base de Datos MySQL: bookhub)</text>
    <text x="35" y="64" fill="${subColor}" font-size="12" font-family="'Segoe UI', Roboto, sans-serif">Esquema Físico de Tablas, Claves Primarias (PK), Claves Foráneas (FK) y Cardinalidades</text>
    <line x1="35" y1="74" x2="${width - 35}" y2="74" stroke="${divider}" stroke-width="1"/>

    ${content}
</svg>`;
}

// =========================================================================
// EJECUCIÓN: GENERAR AMBOS DIAGRAMAS (LIGHT Y DARK) Y EXPORTAR A ESCRITORIO
// =========================================================================

// 1. UML Light & Dark
const umlLightSvg = buildUMLDiagram(false);
const umlDarkSvg = buildUMLDiagram(true);

fs.writeFileSync(path.join(outDir, 'diagrama-clases-uml.svg'), umlLightSvg, 'utf8');
fs.writeFileSync(path.join(webappOutDir, 'diagrama-clases-uml.svg'), umlLightSvg, 'utf8');

fs.writeFileSync(path.join(outDir, 'diagrama-clases-uml-dark.svg'), umlDarkSvg, 'utf8');
fs.writeFileSync(path.join(webappOutDir, 'diagrama-clases-uml-dark.svg'), umlDarkSvg, 'utf8');

// 2. ERD Light & Dark
const erdLightSvg = buildERDDiagram(false);
const erdDarkSvg = buildERDDiagram(true);

fs.writeFileSync(path.join(outDir, 'modelo-de-datos.svg'), erdLightSvg, 'utf8');
fs.writeFileSync(path.join(webappOutDir, 'modelo-de-datos.svg'), erdLightSvg, 'utf8');

fs.writeFileSync(path.join(outDir, 'modelo-de-datos-dark.svg'), erdDarkSvg, 'utf8');
fs.writeFileSync(path.join(webappOutDir, 'modelo-de-datos-dark.svg'), erdDarkSvg, 'utf8');

console.log('✓ Archivos SVG generados con éxito.');

// 3. RENDERIZAR A PNG EN ALTA DEFINICIÓN PARA EL ESCRITORIO
// Diagrama de Clases UML - Versión Fondo Negro Oficial
const resvgUmlDark = new Resvg(umlDarkSvg, { fitTo: { mode: 'width', value: 2480 }, background: '#0d1117' });
const umlDarkPngBuffer = resvgUmlDark.render().asPng();
fs.writeFileSync(path.join(desktopDir, 'diagrama-clases-uml-negro.png'), umlDarkPngBuffer);
fs.writeFileSync(path.join(desktopDir, 'Diagrama_Clases_UML.png'), umlDarkPngBuffer);
fs.writeFileSync(path.join(desktopDir, 'diagrama-clases-uml.svg'), umlDarkSvg);
console.log('✓ Diagrama de Clases UML (Fondo Negro) colocado en el Escritorio.');

// Diagrama de Clases UML - Versión Fondo Blanco también disponible
const resvgUmlLight = new Resvg(umlLightSvg, { fitTo: { mode: 'width', value: 2480 }, background: '#ffffff' });
fs.writeFileSync(path.join(desktopDir, 'diagrama-clases-uml-blanco.png'), resvgUmlLight.render().asPng());

// Modelo de Datos ERD - Versión Fondo Negro Oficial
const resvgErdDark = new Resvg(erdDarkSvg, { fitTo: { mode: 'width', value: 2400 }, background: '#0d1117' });
const erdDarkPngBuffer = resvgErdDark.render().asPng();
fs.writeFileSync(path.join(desktopDir, 'modelo-de-datos-negro.png'), erdDarkPngBuffer);
fs.writeFileSync(path.join(desktopDir, 'Modelo_de_Datos.png'), erdDarkPngBuffer);
fs.writeFileSync(path.join(desktopDir, 'modelo-de-datos.svg'), erdDarkSvg);
console.log('✓ Modelo de Datos ERD (Fondo Negro) colocado en el Escritorio.');

// Modelo de Datos ERD - Versión Fondo Blanco también disponible
const resvgErdLight = new Resvg(erdLightSvg, { fitTo: { mode: 'width', value: 2400 }, background: '#ffffff' });
fs.writeFileSync(path.join(desktopDir, 'modelo-de-datos-blanco.png'), resvgErdLight.render().asPng());

console.log('--- TODOS LOS DIAGRAMAS RENDERIZADOS CON LÍNEAS ORTOGONALES PERFECTAS ---');
