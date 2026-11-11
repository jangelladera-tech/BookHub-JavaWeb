const fs = require('fs');
const path = require('path');
const { Resvg } = require('@resvg/resvg-js');

const outDir = path.join(__dirname, 'img', 'uml');
const webappOutDir = path.join(__dirname, 'src', 'main', 'webapp', 'img', 'uml');
const desktopDir = 'C:\\Users\\Jesus Angel\\Desktop';

if (!fs.existsSync(outDir)) fs.mkdirSync(outDir, { recursive: true });
if (!fs.existsSync(webappOutDir)) fs.mkdirSync(webappOutDir, { recursive: true });

// =========================================================================
// 1. RENDERIZADOR UML CLASS BOX (Estilo profesional azul / gris)
// =========================================================================
function renderUmlClassBox({ x, y, width, headerColor = '#5b9bd5', title, stereotype = '', attributes = [], methods = [], isDark = false }) {
    const lineHeight = 19;
    const headerHeight = stereotype ? 38 : 32;
    const attrHeight = Math.max(attributes.length * lineHeight + 12, 18);
    const methodHeight = methods.length > 0 ? (methods.length * lineHeight + 12) : 0;
    const totalHeight = headerHeight + attrHeight + methodHeight;

    const boxBg = isDark ? '#161b22' : '#ffffff';
    const boxBorder = isDark ? '#30363d' : '#2b579a';
    const textAttr = isDark ? '#e6edf3' : '#1e293b';
    const textMeth = isDark ? '#79c0ff' : '#0f766e';
    const dividerColor = isDark ? '#30363d' : '#94a3b8';

    let svg = `
    <!-- Clase: ${title} -->
    <g transform="translate(${x}, ${y})">
        <rect width="${width}" height="${totalHeight}" fill="${boxBg}" stroke="${boxBorder}" stroke-width="1.5"/>
        <rect width="${width}" height="${headerHeight}" fill="${headerColor}"/>
        ${stereotype ? `<text x="${width/2}" y="15" fill="#e2e8f0" font-size="10" font-style="italic" font-family="'Segoe UI', Roboto, sans-serif" text-anchor="middle">&#171;${stereotype}&#187;</text>` : ''}
        <text x="${width/2}" y="${stereotype ? 30 : 21}" fill="#ffffff" font-size="14" font-weight="700" font-family="'Segoe UI', Roboto, Helvetica, Arial, sans-serif" text-anchor="middle">${title}</text>
        
        <line x1="0" y1="${headerHeight}" x2="${width}" y2="${headerHeight}" stroke="${dividerColor}" stroke-width="1.2"/>
        <g transform="translate(10, ${headerHeight + 15})">
    `;

    attributes.forEach((attr, i) => {
        const safeAttr = String(attr).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
        svg += `        <text x="0" y="${i * lineHeight}" fill="${textAttr}" font-size="11.5" font-family="'Segoe UI', Roboto, sans-serif">${safeAttr}</text>\n`;
    });

    svg += `    </g>\n`;

    if (methods.length > 0) {
        const methodStartY = headerHeight + attrHeight;
        svg += `
        <line x1="0" y1="${methodStartY}" x2="${width}" y2="${methodStartY}" stroke="${dividerColor}" stroke-width="1.2"/>
        <g transform="translate(10, ${methodStartY + 15})">
        `;
        methods.forEach((meth, i) => {
            const safeMeth = String(meth).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
            svg += `        <text x="0" y="${i * lineHeight}" fill="${textMeth}" font-size="11" font-family="'Consolas', monospace">${safeMeth}</text>\n`;
        });
        svg += `    </g>\n`;
    }

    svg += `    </g>\n`;
    return { svg, totalHeight, width, x, y };
}

// =========================================================================
// 2. RENDERIZADOR ERD TABLE BOX (Estilo relacional morado pastel / 3 columnas)
// =========================================================================
function renderErdTableBox({ x, y, width, title, columns = [], isDark = false }) {
    const rowHeight = 22;
    const headerHeight = 28;
    const totalHeight = headerHeight + columns.length * rowHeight + 10;

    const boxBg = isDark ? '#161b22' : '#ffffff';
    const boxBorder = isDark ? '#30363d' : '#2d3748';
    const headerBg = isDark ? '#4338ca' : '#c4b5fd'; // Morado pastel idéntico a images.png
    const headerText = isDark ? '#ffffff' : '#1e1b4b';
    const textName = isDark ? '#f0f6fc' : '#0f172a';
    const textType = isDark ? '#8b949e' : '#4b5563';
    const gridLine = isDark ? '#30363d' : '#cbd5e1';

    let svg = `
    <!-- Tabla ERD: ${title} -->
    <g transform="translate(${x}, ${y})">
        <rect width="${width}" height="${totalHeight}" rx="4" fill="${boxBg}" stroke="${boxBorder}" stroke-width="1.4"/>
        <path d="M 0 4 C 0 1.8 1.8 0 4 0 L ${width-4} 0 C ${width-1.8} 0 ${width} 1.8 ${width} 4 L ${width} ${headerHeight} L 0 ${headerHeight} Z" fill="${headerBg}"/>
        <text x="${width/2}" y="19" fill="${headerText}" font-size="13" font-weight="700" font-family="'Segoe UI', Roboto, sans-serif" text-anchor="middle">${title}</text>
        
        <line x1="0" y1="${headerHeight}" x2="${width}" y2="${headerHeight}" stroke="${boxBorder}" stroke-width="1.2"/>
        <line x1="42" y1="${headerHeight}" x2="42" y2="${totalHeight}" stroke="${gridLine}" stroke-width="1"/>
        <line x1="${width - 100}" y1="${headerHeight}" x2="${width - 100}" y2="${totalHeight}" stroke="${gridLine}" stroke-width="1"/>

        <g transform="translate(0, ${headerHeight + 16})">
    `;

    columns.forEach((col, i) => {
        const yPos = i * rowHeight;
        const isPk = col.key.includes('PK');
        const isFk = col.key.includes('FK');
        const keyColor = isPk ? '#b91c1c' : (isFk ? '#0369a1' : textType);

        svg += `
        <text x="21" y="${yPos}" fill="${keyColor}" font-size="10.5" font-weight="700" font-family="'Consolas', monospace" text-anchor="middle">${col.key}</text>
        <text x="50" y="${yPos}" fill="${textName}" font-size="11.5" font-weight="${isPk ? '700' : '500'}" font-family="'Consolas', monospace">${col.name}</text>
        <text x="${width - 12}" y="${yPos}" fill="${textType}" font-size="11" font-family="'Consolas', monospace" text-anchor="end">${col.type}</text>
        `;
    });

    svg += `    </g>\n    </g>\n`;
    return { svg, totalHeight, width, x, y };
}

// =========================================================================
// RENDERIZADOR DE CONECTORES CON CARDINALIDADES VISIBLES (1 a 1...*)
// =========================================================================
function renderConnectorUml({ points, label = '', multFrom = '1', multTo = '1...*', isDark = false, hasDiamond = false, dashed = false }) {
    const stroke = isDark ? '#c9d1d9' : '#1e293b';
    const labelColor = isDark ? '#f0f6fc' : '#0f172a';
    const multColor = isDark ? '#38bdf8' : '#0369a1'; // Azul vivo para destacar relación 1 a muchos
    const diamondFill = isDark ? '#f0f6fc' : '#1e293b';
    const dashAttr = dashed ? 'stroke-dasharray="6,4"' : '';

    const pathData = points.reduce((acc, pt, i) => i === 0 ? `M ${pt.x} ${pt.y}` : `${acc} L ${pt.x} ${pt.y}`, '');

    let svg = `<path d="${pathData}" fill="none" stroke="${stroke}" stroke-width="1.8" ${dashAttr} stroke-linejoin="round" stroke-linecap="round"/>\n`;

    // Rombo de agregación en el inicio
    if (hasDiamond) {
        const p0 = points[0];
        const p1 = points[1];
        const angle = Math.atan2(p1.y - p0.y, p1.x - p0.x);
        const size = 8;
        svg += `<polygon points="${p0.x},${p0.y} ${p0.x + Math.cos(angle - 0.5)*size*2},${p0.y + Math.sin(angle - 0.5)*size*2} ${p0.x + Math.cos(angle)*size*2.6},${p0.y + Math.sin(angle)*size*2.6} ${p0.x + Math.cos(angle + 0.5)*size*2},${p0.y + Math.sin(angle + 0.5)*size*2}" fill="${diamondFill}" stroke="${stroke}" stroke-width="1.5"/>\n`;
    }

    // Flecha abierta en el destino
    const pEnd = points[points.length - 1];
    const pPrev = points[points.length - 2];
    const angleEnd = Math.atan2(pEnd.y - pPrev.y, pEnd.x - pPrev.x);
    svg += `<path d="${pEnd.x - Math.cos(angleEnd - 0.4)*10} ${pEnd.y - Math.sin(angleEnd - 0.4)*10} L ${pEnd.x} ${pEnd.y} L ${pEnd.x - Math.cos(angleEnd + 0.4)*10} ${pEnd.y - Math.sin(angleEnd + 0.4)*10}" fill="none" stroke="${stroke}" stroke-width="1.8"/>\n`;

    // Multiplicidad Origen (1)
    if (multFrom) {
        const p0 = points[0];
        const p1 = points[1];
        const dx = p1.x - p0.x;
        const dy = p1.y - p0.y;
        const ox = p0.x + (dx !== 0 ? Math.sign(dx) * 20 : 16);
        const oy = p0.y + (dy !== 0 ? Math.sign(dy) * 16 : -8);
        svg += `<rect x="${ox - 10}" y="${oy - 11}" width="20" height="15" rx="3" fill="${isDark ? '#1e293b' : '#e0f2fe'}" stroke="${multColor}" stroke-width="1"/>`;
        svg += `<text x="${ox}" y="${oy}" fill="${multColor}" font-size="11.5" font-weight="800" font-family="'Consolas', monospace" text-anchor="middle">${multFrom}</text>\n`;
    }

    // Multiplicidad Destino (1...*)
    if (multTo) {
        const dx = pEnd.x - pPrev.x;
        const dy = pEnd.y - pPrev.y;
        const ox = pEnd.x - (dx !== 0 ? Math.sign(dx) * 28 : 16);
        const oy = pEnd.y - (dy !== 0 ? Math.sign(dy) * 22 : -8);
        svg += `<rect x="${ox - 18}" y="${oy - 11}" width="36" height="15" rx="3" fill="${isDark ? '#1e293b' : '#e0f2fe'}" stroke="${multColor}" stroke-width="1"/>`;
        svg += `<text x="${ox}" y="${oy}" fill="${multColor}" font-size="11.5" font-weight="800" font-family="'Consolas', monospace" text-anchor="middle">${multTo}</text>\n`;
    }

    // Etiqueta descriptiva
    if (label) {
        const midIdx = Math.floor(points.length / 2);
        const lx = (points[midIdx - 1].x + points[midIdx].x) / 2;
        const ly = (points[midIdx - 1].y + points[midIdx].y) / 2 - 8;
        svg += `<text x="${lx}" y="${ly}" fill="${labelColor}" font-size="11" font-weight="700" font-family="'Segoe UI', Roboto, sans-serif" text-anchor="middle">${label}</text>\n`;
    }

    return svg;
}

function renderConnectorErd({ points, label = '', isDark = false }) {
    const stroke = isDark ? '#c9d1d9' : '#1e293b';
    const badgeColor = isDark ? '#0284c7' : '#0284c7';
    const bg = isDark ? '#0d1117' : '#ffffff';

    const pathData = points.reduce((acc, pt, i) => i === 0 ? `M ${pt.x} ${pt.y}` : `${acc} L ${pt.x} ${pt.y}`, '');

    let svg = `<path d="${pathData}" fill="none" stroke="${stroke}" stroke-width="1.8" stroke-linejoin="round" stroke-linecap="round"/>\n`;

    // Extremo 1 (PK): Barra perpendicular
    const p0 = points[0];
    const p1 = points[1];
    if (p1.x !== p0.x) {
        svg += `<line x1="${p0.x + Math.sign(p1.x - p0.x)*8}" y1="${p0.y - 7}" x2="${p0.x + Math.sign(p1.x - p0.x)*8}" y2="${p0.y + 7}" stroke="${stroke}" stroke-width="2"/>`;
    } else {
        svg += `<line x1="${p0.x - 7}" y1="${p0.y + Math.sign(p1.y - p0.y)*8}" x2="${p0.x + 7}" y2="${p0.y + Math.sign(p1.y - p0.y)*8}" stroke="${stroke}" stroke-width="2"/>`;
    }

    // Extremo N (FK): Círculo + Pata de gallo (Crow's foot)
    const pEnd = points[points.length - 1];
    const pPrev = points[points.length - 2];
    const dx = pEnd.x - pPrev.x;
    const dy = pEnd.y - pPrev.y;

    if (dx !== 0) {
        const dir = Math.sign(dx);
        svg += `<circle cx="${pEnd.x - dir*14}" cy="${pEnd.y}" r="4" fill="${bg}" stroke="${stroke}" stroke-width="1.8"/>`;
        svg += `<path d="M ${pEnd.x} ${pEnd.y - 7} L ${pEnd.x - dir*10} ${pEnd.y} L ${pEnd.x} ${pEnd.y + 7}" fill="none" stroke="${stroke}" stroke-width="1.8"/>`;
    } else {
        const dir = Math.sign(dy);
        svg += `<circle cx="${pEnd.x}" cy="${pEnd.y - dir*14}" r="4" fill="${bg}" stroke="${stroke}" stroke-width="1.8"/>`;
        svg += `<path d="M ${pEnd.x - 7} ${pEnd.y} L ${pEnd.x} ${pEnd.y - dir*10} L ${pEnd.x + 7} ${pEnd.y}" fill="none" stroke="${stroke}" stroke-width="1.8"/>`;
    }

    // Etiqueta con cardinalidad 1:N
    if (label) {
        const midIdx = Math.floor(points.length / 2);
        const lx = (points[midIdx - 1].x + points[midIdx].x) / 2;
        const ly = (points[midIdx - 1].y + points[midIdx].y) / 2 - 8;
        svg += `<rect x="${lx - 55}" y="${ly - 10}" width="110" height="15" rx="3" fill="${isDark ? '#161b22' : '#f0fdf4'}" stroke="${badgeColor}" stroke-width="1"/>`;
        svg += `<text x="${lx}" y="${ly + 1}" fill="${badgeColor}" font-size="10.5" font-weight="700" font-family="'Consolas', monospace" text-anchor="middle">${label}</text>\n`;
    }

    return svg;
}

// =========================================================================
// 1. GENERACIÓN DEL DIAGRAMA DE CLASES UML COMPLETO Y ORDENADO
// =========================================================================
function generarDiagramaClasesCompleto(isDark = false) {
    const width = 1480;
    const height = 940;

    const bg = isDark ? '#0d1117' : '#ffffff';
    const textHeaderColor = isDark ? '#f0f6fc' : '#111827';
    const headerBlue = isDark ? '#1f6feb' : '#5b9bd5';
    const headerSub = isDark ? '#238636' : '#41719c';
    const headerDao = isDark ? '#8957e5' : '#2b579a';

    let content = '';

    // ==========================================================
    // COLUMNA 1 (X: 50): Autores y Categorías (Catálogo Base)
    // ==========================================================
    content += renderUmlClassBox({
        x: 50, y: 90, width: 260, headerColor: headerBlue, title: 'Autor', stereotype: 'modelo.beans', isDark,
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

    content += renderUmlClassBox({
        x: 50, y: 290, width: 260, headerColor: headerBlue, title: 'Categoria', stereotype: 'modelo.beans', isDark,
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

    // ==========================================================
    // COLUMNA 2 (X: 410): Libro y Préstamo (Núcleo de Circulación)
    // ==========================================================
    content += renderUmlClassBox({
        x: 410, y: 90, width: 310, headerColor: headerBlue, title: 'Libro', stereotype: 'modelo.beans', isDark,
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
            'setStock(int) : void',
            'getAutor() : Autor',
            'getCategoria() : Categoria'
        ]
    }).svg;

    content += renderUmlClassBox({
        x: 410, y: 470, width: 310, headerColor: headerBlue, title: 'Prestamo', stereotype: 'modelo.beans', isDark,
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
            'getEstado() : String',
            'setEstado(String) : void',
            'calcularMora() : double',
            'regularizarDevolucion() : void'
        ]
    }).svg;

    // ==========================================================
    // COLUMNA 3 (X: 810): Donación y Lector
    // ==========================================================
    content += renderUmlClassBox({
        x: 810, y: 90, width: 300, headerColor: headerBlue, title: 'Donacion', stereotype: 'modelo.beans', isDark,
        attributes: [
            'idDonacion : int',
            'idUsuario : int',
            'tituloLibro : String',
            'autor : String',
            'categoria : String',
            'anio : int',
            'estadoConservacion : String',
            'nombreDonante : String',
            'correoDonante : String',
            'estadoRevision : String'
        ],
        methods: [
            'getIdDonacion() : int',
            'getEstadoRevision() : String',
            'setEstadoRevision(String) : void',
            'aprobarDonacion() : void',
            'rechazarDonacion() : void'
        ]
    }).svg;

    content += renderUmlClassBox({
        x: 810, y: 470, width: 300, headerColor: headerSub, title: 'Lector', stereotype: 'Usuario Lector', isDark,
        attributes: [
            'idUsuario : int',
            'nombre : String',
            'correo : String',
            'rol : String = "USUARIO"',
            'estado : String = "ACTIVO"',
            'limitePrestamos : int = 3'
        ],
        methods: [
            'solicitarPrestamo(Libro) : void',
            'donarLibro(Donacion) : void',
            'consultarHistorial() : List'
        ]
    }).svg;

    // ==========================================================
    // COLUMNA 4 (X: 1190): Bibliotecario / Admin
    // ==========================================================
    content += renderUmlClassBox({
        x: 1190, y: 470, width: 250, headerColor: headerSub, title: 'Bibliotecario', stereotype: 'Usuario Admin', isDark,
        attributes: [
            'idPersonal : int',
            'nombre : String',
            'correo : String',
            'rol : String = "ADMIN"',
            'turno : String',
            'nivelAcceso : String'
        ],
        methods: [
            'aprobarPrestamo(Prestamo) : void',
            'validarDonacion(Donacion) : void',
            'regularizarMora(int) : void',
            'gestionarCatalogo() : void'
        ]
    }).svg;

    // ==========================================================
    // FILA INFERIOR (Y: 760): Superclase Usuario y Conexion
    // ==========================================================
    content += renderUmlClassBox({
        x: 970, y: 750, width: 280, headerColor: headerDao, title: 'Usuario', stereotype: 'modelo.beans [Superclase]', isDark,
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
            'autenticar() : boolean'
        ]
    }).svg;

    content += renderUmlClassBox({
        x: 410, y: 770, width: 310, headerColor: headerDao, title: 'Conexion', stereotype: 'modelo.conexion', isDark,
        attributes: [
            'URLS : String[]',
            'USER : String',
            'PASSWORDS : String[]'
        ],
        methods: [
            'conectar() : Connection'
        ]
    }).svg;

    // ==========================================================
    // RELACIONES 1 A MUCHOS (1 a 1...*) - Trazado limpio sin cruces
    // ==========================================================

    // 1. Autor (1) -> Libro (1...*) ["escrito por"]
    content += renderConnectorUml({
        points: [{ x: 310, y: 160 }, { x: 410, y: 160 }],
        label: 'escrito por', multFrom: '1', multTo: '1...*',
        isDark
    });

    // 2. Categoria (1) -> Libro (1...*) ["clasificado en"]
    content += renderConnectorUml({
        points: [{ x: 310, y: 350 }, { x: 360, y: 350 }, { x: 360, y: 240 }, { x: 410, y: 240 }],
        label: 'clasificado en', multFrom: '1', multTo: '1...*',
        isDark
    });

    // 3. Libro (1) -> Prestamo (1...*) ["ejemplar prestado"]
    content += renderConnectorUml({
        points: [{ x: 565, y: 382 }, { x: 565, y: 470 }],
        label: 'ejemplar prestado', multFrom: '1', multTo: '1...*',
        isDark
    });

    // 4. Lector (1) -> Prestamo (1...*) ["solicita préstamo"]
    content += renderConnectorUml({
        points: [{ x: 810, y: 530 }, { x: 720, y: 530 }],
        label: 'solicita', multFrom: '1', multTo: '1...*',
        hasDiamond: true, isDark
    });

    // 5. Lector (1) -> Donacion (1...*) ["aporta donación"]
    content += renderConnectorUml({
        points: [{ x: 960, y: 470 }, { x: 960, y: 360 }],
        label: 'dona libro', multFrom: '1', multTo: '1...*',
        isDark
    });

    // 6. Bibliotecario (1) -> Prestamo (1...*) ["gestiona devolución"]
    content += renderConnectorUml({
        points: [{ x: 1190, y: 590 }, { x: 1150, y: 590 }, { x: 1150, y: 680 }, { x: 565, y: 680 }, { x: 565, y: 640 }],
        label: 'Entrega, recibe y regulariza mora', multFrom: '1', multTo: '1...*',
        dashed: true, isDark
    });

    // 7. Bibliotecario (1) -> Donacion (1...*) ["valida estado"]
    content += renderConnectorUml({
        points: [{ x: 1315, y: 470 }, { x: 1315, y: 210 }, { x: 1110, y: 210 }],
        label: 'valida donación', multFrom: '1', multTo: '1...*',
        isDark
    });

    // 8. Generalización: Lector y Bibliotecario heredan de Usuario
    const genLineColor = isDark ? '#c9d1d9' : '#1e293b';
    content += `
    <!-- Herencia Lector -> Usuario -->
    <path d="M 960 635 L 960 700 L 1050 700 L 1050 750" fill="none" stroke="${genLineColor}" stroke-width="1.8"/>
    <!-- Herencia Bibliotecario -> Usuario -->
    <path d="M 1315 635 L 1315 700 L 1150 700 L 1150 750" fill="none" stroke="${genLineColor}" stroke-width="1.8"/>
    <!-- Triángulo de generalización UML apuntando a Usuario -->
    <polygon points="1100,735 1110,750 1090,750" fill="${isDark ? '#0d1117' : '#ffffff'}" stroke="${genLineColor}" stroke-width="1.8"/>
    <text x="1100" y="725" fill="${isDark ? '#cbd5e1' : '#4b5563'}" font-size="11" font-weight="600" font-family="'Segoe UI', sans-serif" text-anchor="middle">&#171;herencia&#187;</text>
    `;

    return `<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${width} ${height}" width="${width}" height="${height}">
    <rect width="${width}" height="${height}" fill="${bg}"/>
    <text x="${width/2}" y="45" fill="${textHeaderColor}" font-size="22" font-weight="800" font-family="'Segoe UI', Roboto, sans-serif" text-anchor="middle">Diagrama de Clases UML - Sistema Bibliotecario BookHub</text>
    <text x="${width/2}" y="68" fill="${isDark ? '#8b949e' : '#4b5563'}" font-size="12.5" font-family="'Segoe UI', Roboto, sans-serif" text-anchor="middle">Relaciones 1 a Muchos (1...*) • Arquitectura de Dominio, Catálogo, Préstamos y Donaciones</text>
    ${content}
</svg>`;
}

// =========================================================================
// 2. GENERACIÓN DEL MODELO DE DATOS ERD COMPLETO Y TOTALMENTE RELACIONADO
// =========================================================================
function generarModeloDatosCompleto(isDark = false) {
    const width = 1420;
    const height = 860;

    const bg = isDark ? '#0d1117' : '#ffffff';
    const titleColor = isDark ? '#f0f6fc' : '#1e1b4b';

    let content = '';

    // ==========================================================
    // TABLAS CON TODA LA INFORMACIÓN DEL SISTEMA
    // ==========================================================

    // 1. autores (Arriba Izquierda)
    content += renderErdTableBox({
        x: 50, y: 80, width: 280, title: 'autores', isDark,
        columns: [
            { key: 'PK', name: 'id_autor', type: 'INT (AUTO)' },
            { key: '', name: 'nombre', type: 'VARCHAR(120)' },
            { key: '', name: 'nacionalidad', type: 'VARCHAR(80)' }
        ]
    }).svg;

    // 2. categorias (Medio Izquierda)
    content += renderErdTableBox({
        x: 50, y: 260, width: 280, title: 'categorias', isDark,
        columns: [
            { key: 'PK', name: 'id_categoria', type: 'INT (AUTO)' },
            { key: '', name: 'nombre', type: 'VARCHAR(100)' },
            { key: '', name: 'descripcion', type: 'VARCHAR(255)' }
        ]
    }).svg;

    // 3. libros (Centro Arriba)
    content += renderErdTableBox({
        x: 430, y: 80, width: 350, title: 'libros', isDark,
        columns: [
            { key: 'PK', name: 'id_libro', type: 'INT (AUTO)' },
            { key: '', name: 'titulo', type: 'VARCHAR(200)' },
            { key: '', name: 'isbn', type: 'VARCHAR(30)' },
            { key: '', name: 'anio', type: 'INT' },
            { key: '', name: 'descripcion', type: 'TEXT' },
            { key: '', name: 'stock', type: 'INT DEFAULT 0' },
            { key: 'FK1', name: 'id_autor', type: 'INT (autores)' },
            { key: 'FK2', name: 'id_categoria', type: 'INT (categorias)' },
            { key: '', name: 'imagen_portada', type: 'LONGTEXT' }
        ]
    }).svg;

    // 4. prestamos (Centro Abajo)
    content += renderErdTableBox({
        x: 430, y: 450, width: 350, title: 'prestamos', isDark,
        columns: [
            { key: 'PK', name: 'id_prestamo', type: 'INT (AUTO)' },
            { key: 'FK1', name: 'id_usuario', type: 'INT (usuarios)' },
            { key: 'FK2', name: 'id_libro', type: 'INT (libros)' },
            { key: '', name: 'fecha_prestamo', type: 'VARCHAR(20)' },
            { key: '', name: 'fecha_devolucion', type: 'VARCHAR(20)' },
            { key: '', name: 'estado', type: 'VARCHAR(20)' }
        ]
    }).svg;

    // 5. usuarios (Derecha Arriba)
    content += renderErdTableBox({
        x: 910, y: 80, width: 320, title: 'usuarios', isDark,
        columns: [
            { key: 'PK', name: 'id_usuario', type: 'INT (AUTO)' },
            { key: '', name: 'nombre', type: 'VARCHAR(120)' },
            { key: '', name: 'correo', type: 'VARCHAR(120) UNIQUE' },
            { key: '', name: 'password', type: 'VARCHAR(120)' },
            { key: '', name: 'rol', type: 'VARCHAR(20)' },
            { key: '', name: 'estado', type: 'VARCHAR(20)' }
        ]
    }).svg;

    // 6. donaciones (Derecha Abajo) - AHORA 100% RELACIONADA
    content += renderErdTableBox({
        x: 910, y: 390, width: 350, title: 'donaciones', isDark,
        columns: [
            { key: 'PK', name: 'id_donacion', type: 'INT (AUTO)' },
            { key: 'FK1', name: 'id_usuario', type: 'INT (usuarios)' },
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

    // ==========================================================
    // LÍNEAS DE RELACIÓN ORTOGONALES CROW'S FOOT (1 a N)
    // Cero cruces, destinos exactos a las claves foráneas
    // ==========================================================

    // 1. autores (PK: id_autor) -> libros (FK1: id_autor)
    content += renderConnectorErd({
        points: [{ x: 330, y: 124 }, { x: 380, y: 124 }, { x: 380, y: 248 }, { x: 430, y: 248 }],
        label: 'fk_libro_autor (1:N)', isDark
    });

    // 2. categorias (PK: id_categoria) -> libros (FK2: id_categoria)
    content += renderConnectorErd({
        points: [{ x: 330, y: 304 }, { x: 380, y: 304 }, { x: 380, y: 270 }, { x: 430, y: 270 }],
        label: 'fk_libro_categoria (1:N)', isDark
    });

    // 3. libros (PK: id_libro) -> prestamos (FK2: id_libro)
    content += renderConnectorErd({
        points: [{ x: 550, y: 310 }, { x: 550, y: 450 }],
        label: 'fk_prestamo_libro (1:N)', isDark
    });

    // 4. usuarios (PK: id_usuario) -> prestamos (FK1: id_usuario)
    content += renderConnectorErd({
        points: [{ x: 910, y: 124 }, { x: 840, y: 124 }, { x: 840, y: 494 }, { x: 780, y: 494 }],
        label: 'fk_prestamo_usuario (1:N)', isDark
    });

    // 5. usuarios (PK: id_usuario) -> donaciones (FK1: id_usuario) [RELACIÓN DIRECTA DE DONACIONES]
    content += renderConnectorErd({
        points: [{ x: 1060, y: 245 }, { x: 1060, y: 390 }],
        label: 'fk_donacion_usuario (1:N)', isDark
    });

    return `<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${width} ${height}" width="${width}" height="${height}">
    <rect width="${width}" height="${height}" fill="${bg}"/>
    <text x="${width/2}" y="45" fill="${titleColor}" font-size="22" font-weight="800" font-family="'Segoe UI', Roboto, sans-serif" text-anchor="middle">Modelo de Datos Relacional (Base de Datos MySQL: bookhub)</text>
    <text x="${width/2}" y="68" fill="${isDark ? '#8b949e' : '#4b5563'}" font-size="12.5" font-family="'Segoe UI', Roboto, sans-serif" text-anchor="middle">Esquema Completo de Tablas • Claves Primarias (PK), Claves Foráneas (FK) y Cardinalidad Crow's Foot (1:N)</text>
    ${content}
</svg>`;
}

// =========================================================================
// GENERAR Y EXPORTAR (LIGHT, DARK, PNG HD Y ESCRITORIO)
// =========================================================================

// 1. DIAGRAMA DE CLASES
const umlLight = generarDiagramaClasesCompleto(false);
const umlDark = generarDiagramaClasesCompleto(true);

fs.writeFileSync(path.join(outDir, 'diagrama-clases-uml.svg'), umlLight, 'utf8');
fs.writeFileSync(path.join(webappOutDir, 'diagrama-clases-uml.svg'), umlLight, 'utf8');
fs.writeFileSync(path.join(outDir, 'diagrama-clases-uml-dark.svg'), umlDark, 'utf8');
fs.writeFileSync(path.join(webappOutDir, 'diagrama-clases-uml-dark.svg'), umlDark, 'utf8');

const resvgUmlDark = new Resvg(umlDark, { fitTo: { mode: 'width', value: 2600 }, background: '#0d1117' });
const pngUmlDark = resvgUmlDark.render().asPng();
fs.writeFileSync(path.join(desktopDir, 'diagrama-clases-uml-negro.png'), pngUmlDark);
fs.writeFileSync(path.join(desktopDir, 'Diagrama_Clases_UML.png'), pngUmlDark);
fs.writeFileSync(path.join(desktopDir, 'diagrama-clases-uml.svg'), umlDark);

const resvgUmlLight = new Resvg(umlLight, { fitTo: { mode: 'width', value: 2600 }, background: '#ffffff' });
fs.writeFileSync(path.join(desktopDir, 'diagrama-clases-uml-blanco.png'), resvgUmlLight.render().asPng());

console.log('✓ Diagrama de Clases UML completo generado (con Autor, Categoria, Donacion y relaciones 1...* visibles).');

// 2. MODELO DE DATOS ERD
const erdLight = generarModeloDatosCompleto(false);
const erdDark = generarModeloDatosCompleto(true);

fs.writeFileSync(path.join(outDir, 'modelo-de-datos.svg'), erdLight, 'utf8');
fs.writeFileSync(path.join(webappOutDir, 'modelo-de-datos.svg'), erdLight, 'utf8');
fs.writeFileSync(path.join(outDir, 'modelo-de-datos-dark.svg'), erdDark, 'utf8');
fs.writeFileSync(path.join(webappOutDir, 'modelo-de-datos-dark.svg'), erdDark, 'utf8');

const resvgErdDark = new Resvg(erdDark, { fitTo: { mode: 'width', value: 2600 }, background: '#0d1117' });
const pngErdDark = resvgErdDark.render().asPng();
fs.writeFileSync(path.join(desktopDir, 'modelo-de-datos-negro.png'), pngErdDark);
fs.writeFileSync(path.join(desktopDir, 'Modelo_de_Datos.png'), pngErdDark);
fs.writeFileSync(path.join(desktopDir, 'modelo-de-datos.svg'), erdDark);

const resvgErdLight = new Resvg(erdLight, { fitTo: { mode: 'width', value: 2600 }, background: '#ffffff' });
fs.writeFileSync(path.join(desktopDir, 'modelo-de-datos-blanco.png'), resvgErdLight.render().asPng());

console.log('✓ Modelo de Datos ERD completo generado (con donaciones conectada a usuarios y cardinalidades 1:N).');
console.log('--- ACTUALIZACIÓN FINALIZADA CON ÉXITO ---');
