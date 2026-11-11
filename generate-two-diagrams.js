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
    const lineHeight = 18;
    const headerHeight = stereotype ? 36 : 30;
    const attrHeight = Math.max(attributes.length * lineHeight + 10, 16);
    const methodHeight = methods.length > 0 ? (methods.length * lineHeight + 10) : 0;
    const totalHeight = headerHeight + attrHeight + methodHeight;

    const boxBg = isDark ? '#161b22' : '#ffffff';
    const boxBorder = isDark ? '#30363d' : '#2b579a';
    const textAttr = isDark ? '#e6edf3' : '#1e293b';
    const textMeth = isDark ? '#79c0ff' : '#0f766e';
    const dividerColor = isDark ? '#30363d' : '#94a3b8';

    let svg = `
    <!-- Clase: ${title} -->
    <g transform="translate(${x}, ${y})">
        <rect width="${width}" height="${totalHeight}" rx="4" fill="${boxBg}" stroke="${boxBorder}" stroke-width="1.6"/>
        <path d="M 0 4 C 0 1.8 1.8 0 4 0 L ${width-4} 0 C ${width-1.8} 0 ${width} 1.8 ${width} 4 L ${width} ${headerHeight} L 0 ${headerHeight} Z" fill="${headerColor}"/>
        ${stereotype ? `<text x="${width/2}" y="14" fill="#e2e8f0" font-size="10" font-style="italic" font-family="'Segoe UI', Roboto, sans-serif" text-anchor="middle">&#171;${stereotype}&#187;</text>` : ''}
        <text x="${width/2}" y="${stereotype ? 29 : 20}" fill="#ffffff" font-size="13.5" font-weight="700" font-family="'Segoe UI', Roboto, Helvetica, Arial, sans-serif" text-anchor="middle">${title}</text>
        
        <line x1="0" y1="${headerHeight}" x2="${width}" y2="${headerHeight}" stroke="${boxBorder}" stroke-width="1.2"/>
        <g transform="translate(10, ${headerHeight + 14})">
    `;

    attributes.forEach((attr, i) => {
        const safeAttr = String(attr).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
        svg += `        <text x="0" y="${i * lineHeight}" fill="${textAttr}" font-size="11" font-family="'Segoe UI', Roboto, sans-serif">${safeAttr}</text>\n`;
    });

    svg += `    </g>\n`;

    if (methods.length > 0) {
        const methodStartY = headerHeight + attrHeight;
        svg += `
        <line x1="0" y1="${methodStartY}" x2="${width}" y2="${methodStartY}" stroke="${dividerColor}" stroke-width="1.2"/>
        <g transform="translate(10, ${methodStartY + 14})">
        `;
        methods.forEach((meth, i) => {
            const safeMeth = String(meth).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
            svg += `        <text x="0" y="${i * lineHeight}" fill="${textMeth}" font-size="10.5" font-family="'Consolas', monospace">${safeMeth}</text>\n`;
        });
        svg += `    </g>\n`;
    }

    svg += `    </g>\n`;
    return {
        svg,
        totalHeight,
        width,
        x,
        y,
        bounds: {
            left: x,
            right: x + width,
            top: y,
            bottom: y + totalHeight,
            midX: x + width / 2,
            midY: y + totalHeight / 2
        }
    };
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
    const headerBg = isDark ? '#4338ca' : '#c4b5fd';
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
    return {
        svg,
        totalHeight,
        width,
        x,
        y,
        bounds: {
            left: x,
            right: x + width,
            top: y,
            bottom: y + totalHeight,
            midX: x + width / 2,
            midY: y + totalHeight / 2
        }
    };
}

// =========================================================================
// RENDERIZADOR DE CONECTORES CON CARDINALIDADES VISIBLES (1 a 1...*)
// =========================================================================
function renderConnectorUml({ points, label = '', multFrom = '', multTo = '', isDark = false, hasDiamond = false, dashed = false, labelPos = null }) {
    const stroke = isDark ? '#c9d1d9' : '#1e293b';
    const labelColor = isDark ? '#f0f6fc' : '#0f172a';
    const multColor = isDark ? '#38bdf8' : '#0369a1';
    const diamondFill = isDark ? '#f0f6fc' : '#1e293b';
    const bg = isDark ? '#0d1117' : '#ffffff';
    const dashAttr = dashed ? 'stroke-dasharray="6,4"' : '';

    const pathData = points.reduce((acc, pt, i) => i === 0 ? `M ${pt.x} ${pt.y}` : `${acc} L ${pt.x} ${pt.y}`, '');
    let svg = `<path d="${pathData}" fill="none" stroke="${stroke}" stroke-width="1.8" ${dashAttr} stroke-linejoin="round" stroke-linecap="round"/>\n`;

    // Rombo de agregación en el inicio
    if (hasDiamond) {
        const p0 = points[0];
        const p1 = points[1];
        const angle = Math.atan2(p1.y - p0.y, p1.x - p0.x);
        const size = 7;
        svg += `<polygon points="${p0.x},${p0.y} ${p0.x + Math.cos(angle - 0.5)*size*2},${p0.y + Math.sin(angle - 0.5)*size*2} ${p0.x + Math.cos(angle)*size*2.6},${p0.y + Math.sin(angle)*size*2.6} ${p0.x + Math.cos(angle + 0.5)*size*2},${p0.y + Math.sin(angle + 0.5)*size*2}" fill="${diamondFill}" stroke="${stroke}" stroke-width="1.5"/>\n`;
    }

    // Flecha abierta en el destino
    const pEnd = points[points.length - 1];
    const pPrev = points[points.length - 2];
    const angleEnd = Math.atan2(pEnd.y - pPrev.y, pEnd.x - pPrev.x);
    svg += `<path d="${pEnd.x - Math.cos(angleEnd - 0.4)*10} ${pEnd.y - Math.sin(angleEnd - 0.4)*10} L ${pEnd.x} ${pEnd.y} L ${pEnd.x - Math.cos(angleEnd + 0.4)*10} ${pEnd.y - Math.sin(angleEnd + 0.4)*10}" fill="none" stroke="${stroke}" stroke-width="1.8"/>\n`;

    // Multiplicidad Origen
    if (multFrom) {
        const p0 = points[0];
        const p1 = points[1];
        const dx = p1.x - p0.x;
        const dy = p1.y - p0.y;
        let ox = p0.x + (dx > 0 ? 24 : (dx < 0 ? -24 : 16));
        let oy = p0.y + (dy > 0 ? 20 : (dy < 0 ? -16 : -11));
        svg += `<rect x="${ox - 10}" y="${oy - 9}" width="20" height="15" rx="3" fill="${isDark ? '#161b22' : '#e0f2fe'}" stroke="${multColor}" stroke-width="1.1"/>`;
        svg += `<text x="${ox}" y="${oy + 2}" fill="${multColor}" font-size="11" font-weight="800" font-family="'Consolas', monospace" text-anchor="middle" dominant-baseline="middle">${multFrom}</text>\n`;
    }

    // Multiplicidad Destino
    if (multTo) {
        const dx = pEnd.x - pPrev.x;
        const dy = pEnd.y - pPrev.y;
        let ox = pEnd.x - (dx > 0 ? 28 : (dx < 0 ? -28 : -18));
        let oy = pEnd.y - (dy > 0 ? 20 : (dy < 0 ? -16 : 11));
        svg += `<rect x="${ox - 18}" y="${oy - 9}" width="36" height="15" rx="3" fill="${isDark ? '#161b22' : '#e0f2fe'}" stroke="${multColor}" stroke-width="1.1"/>`;
        svg += `<text x="${ox}" y="${oy + 2}" fill="${multColor}" font-size="11" font-weight="800" font-family="'Consolas', monospace" text-anchor="middle" dominant-baseline="middle">${multTo}</text>\n`;
    }

    // Etiqueta descriptiva
    if (label) {
        let lx, ly;
        if (labelPos) {
            lx = labelPos.x;
            ly = labelPos.y;
        } else {
            const midIdx = Math.floor(points.length / 2);
            lx = (points[midIdx - 1].x + points[midIdx].x) / 2;
            ly = (points[midIdx - 1].y + points[midIdx].y) / 2 - 9;
        }
        const textWidth = label.length * 6.5 + 14;
        svg += `<rect x="${lx - textWidth/2}" y="${ly - 9}" width="${textWidth}" height="17" rx="3" fill="${bg}" stroke="${isDark ? '#30363d' : '#cbd5e1'}" stroke-width="1"/>`;
        svg += `<text x="${lx}" y="${ly + 1}" fill="${labelColor}" font-size="10.5" font-weight="700" font-family="'Segoe UI', Roboto, sans-serif" text-anchor="middle" dominant-baseline="middle">${label}</text>\n`;
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
// 1. GENERACIÓN DEL DIAGRAMA DE CLASES UML (Inspirado fielmente en el ejemplo)
// =========================================================================
function generarDiagramaClasesCompleto(isDark = false) {
    const width = 1680;
    const height = 1000;

    const bg = isDark ? '#0d1117' : '#ffffff';
    const textHeaderColor = isDark ? '#f0f6fc' : '#111827';
    const headerBlue = isDark ? '#1f6feb' : '#5b9bd5';
    const headerSub = isDark ? '#238636' : '#41719c';
    const headerDao = isDark ? '#8957e5' : '#2b579a';

    let content = '';

    // 1. LECTOR (Fila 1, Col 1: x: 60, y: 135)
    const boxLector = renderUmlClassBox({
        x: 60, y: 135, width: 270, headerColor: headerBlue, title: 'Lector', stereotype: 'Usuario Lector', isDark,
        attributes: [
            '- idUsuario : int',
            '- nombre : String',
            '- correo : String',
            '- rol : String = "USUARIO"',
            '- estado : String = "ACTIVO"',
            '- limitePrestamos : int = 3'
        ],
        methods: [
            '+ solicitarPrestamo(Libro) : void',
            '+ donarLibro(Donacion) : void',
            '+ consultarHistorial() : List'
        ]
    });
    content += boxLector.svg;

    // 2. PRESTAMO (Fila 1, Col 2: x: 460, y: 135 - Núcleo de Circulación)
    const boxPrestamo = renderUmlClassBox({
        x: 460, y: 135, width: 290, headerColor: headerBlue, title: 'Prestamo', stereotype: 'modelo.beans', isDark,
        attributes: [
            '- idPrestamo : int',
            '- idUsuario : int',
            '- idLibro : int',
            '- fechaPrestamo : Date',
            '- fechaDevolucion : Date',
            '- estado : String',
            '- usuario : Usuario',
            '- libro : Libro'
        ],
        methods: [
            '+ getIdPrestamo() : int',
            '+ getEstado() : String',
            '+ setEstado(String) : void',
            '+ calcularMora() : double',
            '+ regularizarDevolucion() : void'
        ]
    });
    content += boxPrestamo.svg;

    // 3. BIBLIOTECARIO (Fila 2, Col 2: x: 460, y: 520 - Directamente debajo de Prestamo)
    const boxBibliotecario = renderUmlClassBox({
        x: 460, y: 520, width: 290, headerColor: headerBlue, title: 'Bibliotecario', stereotype: 'Usuario Admin', isDark,
        attributes: [
            '- idPersonal : int',
            '- nombre : String',
            '- correo : String',
            '- rol : String = "ADMIN"',
            '- turno : String',
            '- nivelAcceso : String'
        ],
        methods: [
            '+ aprobarPrestamo(Prestamo) : void',
            '+ validarDonacion(Donacion) : void',
            '+ regularizarMora(int) : void',
            '+ gestionarCatalogo() : void'
        ]
    });
    content += boxBibliotecario.svg;

    // 4. USUARIO (Fila 2, Col 1: x: 60, y: 520 - Superclase bajo Lector)
    const boxUsuario = renderUmlClassBox({
        x: 60, y: 520, width: 270, headerColor: headerDao, title: 'Usuario', stereotype: 'modelo.beans [Superclase]', isDark,
        attributes: [
            '- idUsuario : int',
            '- nombre : String',
            '- correo : String',
            '- password : String',
            '- rol : String',
            '- estado : String'
        ],
        methods: [
            '+ getIdUsuario() : int',
            '+ getNombre() : String',
            '+ getCorreo() : String',
            '+ autenticar() : boolean'
        ]
    });
    content += boxUsuario.svg;

    // 5. CONEXION (Fila 3, Col 1: x: 60, y: 815 - Singleton de Conexión JDBC)
    const boxConexion = renderUmlClassBox({
        x: 60, y: 815, width: 270, headerColor: headerDao, title: 'Conexion', stereotype: 'modelo.conexion', isDark,
        attributes: [
            '- URLS : String[]',
            '- USER : String',
            '- PASSWORDS : String[]'
        ],
        methods: [
            '+ conectar() : Connection',
            '+ cerrar(Connection) : void'
        ]
    });
    content += boxConexion.svg;

    // 6. LIBRO (Fila 1, Col 3: x: 880, y: 135 - Ítem de Catálogo)
    const boxLibro = renderUmlClassBox({
        x: 880, y: 135, width: 300, headerColor: headerBlue, title: 'Libro', stereotype: 'modelo.beans', isDark,
        attributes: [
            '- idLibro : int',
            '- titulo : String',
            '- isbn : String',
            '- anio : int',
            '- stock : int',
            '- idAutor : int',
            '- idCategoria : int',
            '- autor : Autor',
            '- categoria : Categoria'
        ],
        methods: [
            '+ getIdLibro() : int',
            '+ getTitulo() : String',
            '+ getStock() : int',
            '+ setStock(int) : void',
            '+ getAutor() : Autor',
            '+ getCategoria() : Categoria'
        ]
    });
    content += boxLibro.svg;

    // 7. DONACION (Fila 1, Col 4: x: 1300, y: 135 - Material Recibido)
    const boxDonacion = renderUmlClassBox({
        x: 1300, y: 135, width: 300, headerColor: headerBlue, title: 'Donacion', stereotype: 'modelo.beans', isDark,
        attributes: [
            '- idDonacion : int',
            '- idUsuario : int',
            '- tituloLibro : String',
            '- autor : String',
            '- categoria : String',
            '- anio : int',
            '- estadoConservacion : String',
            '- estadoRevision : String'
        ],
        methods: [
            '+ getIdDonacion() : int',
            '+ getEstadoRevision() : String',
            '+ setEstadoRevision(String) : void',
            '+ aprobarDonacion() : void',
            '+ rechazarDonacion() : void'
        ]
    });
    content += boxDonacion.svg;

    // 8. AUTOR (Fila 2, Col 3: x: 880, y: 540 - Clasificación bajo Libro)
    const boxAutor = renderUmlClassBox({
        x: 880, y: 540, width: 280, headerColor: headerSub, title: 'Autor', stereotype: 'modelo.beans', isDark,
        attributes: [
            '- idAutor : int',
            '- nombre : String',
            '- nacionalidad : String'
        ],
        methods: [
            '+ getIdAutor() : int',
            '+ getNombre() : String',
            '+ getNacionalidad() : String'
        ]
    });
    content += boxAutor.svg;

    // 9. CATEGORIA (Fila 2, Col 4: x: 1300, y: 540 - Género / Colección)
    const boxCategoria = renderUmlClassBox({
        x: 1300, y: 540, width: 280, headerColor: headerSub, title: 'Categoria', stereotype: 'modelo.beans', isDark,
        attributes: [
            '- idCategoria : int',
            '- nombre : String',
            '- descripcion : String'
        ],
        methods: [
            '+ getIdCategoria() : int',
            '+ getNombre() : String',
            '+ getDescripcion() : String'
        ]
    });
    content += boxCategoria.svg;

    // ==========================================================
    // CONEXIONES ESTRICTAMENTE ORTOGONALES Y SIN INVASIÓN DE CUADROS
    // ==========================================================

    // 1. LECTOR (1) -> PRESTAMO (1...*) [solicita préstamo con rombo de agregación]
    content += renderConnectorUml({
        points: [
            { x: boxLector.bounds.right, y: 220 },
            { x: boxPrestamo.bounds.left, y: 220 }
        ],
        label: 'solicita', multFrom: '1', multTo: '1...*',
        hasDiamond: true, isDark
    });

    // 2. PRESTAMO (1...*) -> BIBLIOTECARIO (1) [Entrega, recibe y mora - línea discontinua vertical]
    content += renderConnectorUml({
        points: [
            { x: boxPrestamo.bounds.midX, y: boxPrestamo.bounds.bottom },
            { x: boxPrestamo.bounds.midX, y: boxBibliotecario.bounds.top }
        ],
        label: 'Entrega, recibe y mora', multFrom: '1...*', multTo: '1',
        dashed: true, isDark, labelPos: { x: boxPrestamo.bounds.midX + 75, y: (boxPrestamo.bounds.bottom + boxBibliotecario.bounds.top)/2 }
    });

    // 3. PRESTAMO (1...*) -> LIBRO (1) [ejemplar prestado / necesita]
    content += renderConnectorUml({
        points: [
            { x: boxPrestamo.bounds.right, y: 220 },
            { x: boxLibro.bounds.left, y: 220 }
        ],
        label: 'ejemplar prestado', multFrom: '1...*', multTo: '1',
        isDark
    });

    // 4. LIBRO (1) -> DONACION (1...*) [catálogo de ítems como en el ejemplo libro / revista]
    content += renderConnectorUml({
        points: [
            { x: boxLibro.bounds.right, y: 220 },
            { x: boxDonacion.bounds.left, y: 220 }
        ],
        label: 'catálogo / ítem', multFrom: '1', multTo: '1...*',
        isDark
    });

    // 5. AUTOR (1) -> LIBRO (1...*) [escrito por - vertical directo sin cruces]
    content += renderConnectorUml({
        points: [
            { x: boxAutor.bounds.midX, y: boxAutor.bounds.top },
            { x: boxAutor.bounds.midX, y: boxLibro.bounds.bottom }
        ],
        label: 'escrito por', multFrom: '1', multTo: '1...*',
        isDark, labelPos: { x: boxAutor.bounds.midX + 60, y: (boxAutor.bounds.top + boxLibro.bounds.bottom)/2 }
    });

    // 6. CATEGORIA (1) -> LIBRO (1...*) [clasificado en - canal despejado x: 1240]
    content += renderConnectorUml({
        points: [
            { x: boxCategoria.bounds.left, y: 580 },
            { x: 1240, y: 580 },
            { x: 1240, y: 320 },
            { x: boxLibro.bounds.right, y: 320 }
        ],
        label: 'clasificado en', multFrom: '1', multTo: '1...*',
        isDark, labelPos: { x: 1240, y: 450 }
    });

    // 7. LECTOR (1) -> DONACION (1...*) [dona libro - canal superior despejado y: 85]
    content += renderConnectorUml({
        points: [
            { x: boxLector.bounds.midX, y: boxLector.bounds.top },
            { x: boxLector.bounds.midX, y: 85 },
            { x: boxDonacion.bounds.midX, y: 85 },
            { x: boxDonacion.bounds.midX, y: boxDonacion.bounds.top }
        ],
        label: 'dona libro', multFrom: '1', multTo: '1...*',
        isDark, labelPos: { x: 740, y: 75 }
    });

    // 8. BIBLIOTECARIO (1) -> DONACION (1...*) [valida donación - canal inferior despejado y: 760]
    content += renderConnectorUml({
        points: [
            { x: boxBibliotecario.bounds.right, y: 660 },
            { x: 800, y: 660 },
            { x: 800, y: 760 },
            { x: 1640, y: 760 },
            { x: 1640, y: 260 },
            { x: boxDonacion.bounds.right, y: 260 }
        ],
        label: 'valida donación', multFrom: '1', multTo: '1...*',
        isDark, labelPos: { x: 1220, y: 750 }
    });

    // 9. HERENCIA: Lector -> Usuario (Triángulo hueco estándar UML hacia Usuario)
    const genColor = isDark ? '#c9d1d9' : '#1e293b';
    const genBg = isDark ? '#161b22' : '#ffffff';
    content += `
    <!-- Herencia Lector -> Usuario -->
    <line x1="${boxLector.bounds.midX}" y1="${boxLector.bounds.bottom}" x2="${boxLector.bounds.midX}" y2="${boxUsuario.bounds.top - 16}" stroke="${genColor}" stroke-width="1.8"/>
    <polygon points="${boxLector.bounds.midX},${boxUsuario.bounds.top} ${boxLector.bounds.midX - 8},${boxUsuario.bounds.top - 16} ${boxLector.bounds.midX + 8},${boxUsuario.bounds.top - 16}" fill="${genBg}" stroke="${genColor}" stroke-width="1.8"/>
    <rect x="${boxLector.bounds.midX - 44}" y="${(boxLector.bounds.bottom + boxUsuario.bounds.top)/2 - 10}" width="88" height="17" rx="3" fill="${bg}" stroke="${isDark ? '#30363d' : '#cbd5e1'}" stroke-width="1"/>
    <text x="${boxLector.bounds.midX}" y="${(boxLector.bounds.bottom + boxUsuario.bounds.top)/2}" fill="${genColor}" font-size="10.5" font-weight="700" font-family="'Segoe UI', sans-serif" text-anchor="middle" dominant-baseline="middle">&#171;hereda de&#187;</text>

    <!-- Herencia Bibliotecario -> Usuario -->
    <line x1="${boxBibliotecario.bounds.left}" y1="570" x2="${boxUsuario.bounds.right + 16}" y2="570" stroke="${genColor}" stroke-width="1.8"/>
    <polygon points="${boxUsuario.bounds.right},570 ${boxUsuario.bounds.right + 16},562 ${boxUsuario.bounds.right + 16},578" fill="${genBg}" stroke="${genColor}" stroke-width="1.8"/>
    <rect x="${(boxBibliotecario.bounds.left + boxUsuario.bounds.right)/2 - 44}" y="561" width="88" height="17" rx="3" fill="${bg}" stroke="${isDark ? '#30363d' : '#cbd5e1'}" stroke-width="1"/>
    <text x="${(boxBibliotecario.bounds.left + boxUsuario.bounds.right)/2}" y="570" fill="${genColor}" font-size="10.5" font-weight="700" font-family="'Segoe UI', sans-serif" text-anchor="middle" dominant-baseline="middle">&#171;hereda de&#187;</text>

    <!-- Dependencia Usuario -> Conexion -->
    <line x1="${boxUsuario.bounds.midX}" y1="${boxUsuario.bounds.bottom}" x2="${boxUsuario.bounds.midX}" y2="${boxConexion.bounds.top}" stroke="${genColor}" stroke-width="1.8" stroke-dasharray="6,4"/>
    <path d="M ${boxUsuario.bounds.midX - 6} ${boxConexion.bounds.top - 10} L ${boxUsuario.bounds.midX} ${boxConexion.bounds.top} L ${boxUsuario.bounds.midX + 6} ${boxConexion.bounds.top - 10}" fill="none" stroke="${genColor}" stroke-width="1.8"/>
    <rect x="${boxUsuario.bounds.midX + 15}" y="${(boxUsuario.bounds.bottom + boxConexion.bounds.top)/2 - 8}" width="45" height="16" rx="3" fill="${bg}" stroke="${isDark ? '#30363d' : '#cbd5e1'}" stroke-width="1"/>
    <text x="${boxUsuario.bounds.midX + 37}" y="${(boxUsuario.bounds.bottom + boxConexion.bounds.top)/2}" fill="${genColor}" font-size="10" font-weight="700" font-family="'Segoe UI', sans-serif" text-anchor="middle" dominant-baseline="middle">&#171;usa&#187;</text>
    `;

    return `<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${width} ${height}" width="${width}" height="${height}">
    <rect width="${width}" height="${height}" fill="${bg}"/>
    <text x="${width/2}" y="32" fill="${textHeaderColor}" font-size="22" font-weight="800" font-family="'Segoe UI', Roboto, sans-serif" text-anchor="middle">Diagrama de Clases UML - Sistema Bibliotecario BookHub</text>
    <text x="${width/2}" y="52" fill="${isDark ? '#8b949e' : '#4b5563'}" font-size="12" font-family="'Segoe UI', Roboto, sans-serif" text-anchor="middle">Relaciones 1 a Muchos (1...*) • Arquitectura de Servicios Bibliotecarios, Catálogo y Usuarios</text>
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

    // 3. libros (Arriba Centro)
    content += renderErdTableBox({
        x: 430, y: 80, width: 300, title: 'libros', isDark,
        columns: [
            { key: 'PK', name: 'id_libro', type: 'INT (AUTO)' },
            { key: '', name: 'titulo', type: 'VARCHAR(180)' },
            { key: '', name: 'isbn', type: 'VARCHAR(30)' },
            { key: '', name: 'anio', type: 'INT' },
            { key: '', name: 'descripcion', type: 'TEXT' },
            { key: '', name: 'stock', type: 'INT' },
            { key: 'FK1', name: 'id_autor', type: 'INT' },
            { key: 'FK2', name: 'id_categoria', type: 'INT' },
            { key: '', name: 'imagen_portada', type: 'VARCHAR(255)' }
        ]
    }).svg;

    // 4. prestamos (Abajo Centro)
    content += renderErdTableBox({
        x: 430, y: 460, width: 300, title: 'prestamos', isDark,
        columns: [
            { key: 'PK', name: 'id_prestamo', type: 'INT (AUTO)' },
            { key: 'FK1', name: 'id_usuario', type: 'INT' },
            { key: 'FK2', name: 'id_libro', type: 'INT' },
            { key: '', name: 'fecha_prestamo', type: 'DATETIME' },
            { key: '', name: 'fecha_devolucion', type: 'DATETIME' },
            { key: '', name: 'estado', type: 'VARCHAR(30)' }
        ]
    }).svg;

    // 5. usuarios (Arriba Derecha - Eje de Usuarios y Donantes)
    content += renderErdTableBox({
        x: 830, y: 80, width: 280, title: 'usuarios', isDark,
        columns: [
            { key: 'PK', name: 'id_usuario', type: 'INT (AUTO)' },
            { key: '', name: 'nombre', type: 'VARCHAR(120)' },
            { key: '', name: 'correo', type: 'VARCHAR(120)' },
            { key: '', name: 'password', type: 'VARCHAR(255)' },
            { key: '', name: 'rol', type: 'VARCHAR(30)' },
            { key: '', name: 'estado', type: 'VARCHAR(30)' },
            { key: '', name: 'creado_en', type: 'DATETIME' }
        ]
    }).svg;

    // 6. donaciones (Arriba Extremo Derecha - Conectada a usuarios)
    content += renderErdTableBox({
        x: 1160, y: 80, width: 230, title: 'donaciones', isDark,
        columns: [
            { key: 'PK', name: 'id_donacion', type: 'INT (AUTO)' },
            { key: 'FK1', name: 'id_usuario', type: 'INT' },
            { key: '', name: 'titulo_libro', type: 'VARCHAR(180)' },
            { key: '', name: 'autor', type: 'VARCHAR(120)' },
            { key: '', name: 'categoria', type: 'VARCHAR(100)' },
            { key: '', name: 'anio', type: 'INT' },
            { key: '', name: 'estado_conservacion', type: 'VARCHAR(50)' },
            { key: '', name: 'nombre_donante', type: 'VARCHAR(120)' },
            { key: '', name: 'correo_donante', type: 'VARCHAR(120)' },
            { key: '', name: 'estado_revision', type: 'VARCHAR(30)' },
            { key: '', name: 'creado_en', type: 'DATETIME' }
        ]
    }).svg;

    // 7. sanciones (Abajo Derecha)
    content += renderErdTableBox({
        x: 830, y: 460, width: 280, title: 'sanciones', isDark,
        columns: [
            { key: 'PK', name: 'id_sancion', type: 'INT (AUTO)' },
            { key: 'FK1', name: 'id_usuario', type: 'INT' },
            { key: 'FK2', name: 'id_prestamo', type: 'INT' },
            { key: '', name: 'monto_mora', type: 'DECIMAL(8,2)' },
            { key: '', name: 'dias_retraso', type: 'INT' },
            { key: '', name: 'estado_pago', type: 'VARCHAR(30)' },
            { key: '', name: 'fecha_sancion', type: 'DATETIME' }
        ]
    }).svg;

    // 8. historial_prestamos (Abajo Extremo Derecha)
    content += renderErdTableBox({
        x: 1160, y: 460, width: 230, title: 'historial_prestamos', isDark,
        columns: [
            { key: 'PK', name: 'id_historial', type: 'INT (AUTO)' },
            { key: 'FK1', name: 'id_prestamo', type: 'INT' },
            { key: '', name: 'fecha_registro', type: 'DATETIME' },
            { key: '', name: 'observaciones', type: 'VARCHAR(255)' }
        ]
    }).svg;

    // ==========================================================
    // CONEXIONES RELACIONALES (1 a N con Crow's Foot)
    // ==========================================================

    // 1. autores (1) -> libros (N)
    content += renderConnectorErd({
        points: [{ x: 330, y: 125 }, { x: 430, y: 125 }],
        label: '1 : N', isDark
    });

    // 2. categorias (1) -> libros (N)
    content += renderConnectorErd({
        points: [{ x: 330, y: 305 }, { x: 380, y: 305 }, { x: 380, y: 225 }, { x: 430, y: 225 }],
        label: '1 : N', isDark
    });

    // 3. libros (1) -> prestamos (N)
    content += renderConnectorErd({
        points: [{ x: 580, y: 306 }, { x: 580, y: 460 }],
        label: '1 : N', isDark
    });

    // 4. usuarios (1) -> prestamos (N)
    content += renderConnectorErd({
        points: [{ x: 830, y: 245 }, { x: 770, y: 245 }, { x: 770, y: 510 }, { x: 730, y: 510 }],
        label: '1 : N', isDark
    });

    // 5. usuarios (1) -> donaciones (N) [LA CONEXIÓN DE DONACIONES SOLICITADA]
    content += renderConnectorErd({
        points: [{ x: 1110, y: 130 }, { x: 1160, y: 130 }],
        label: '1 : N', isDark
    });

    // 6. usuarios (1) -> sanciones (N)
    content += renderConnectorErd({
        points: [{ x: 970, y: 254 }, { x: 970, y: 460 }],
        label: '1 : N', isDark
    });

    // 7. prestamos (1) -> sanciones (N)
    content += renderConnectorErd({
        points: [{ x: 730, y: 560 }, { x: 830, y: 560 }],
        label: '1 : N', isDark
    });

    // 8. prestamos (1) -> historial_prestamos (N)
    content += renderConnectorErd({
        points: [{ x: 580, y: 622 }, { x: 580, y: 730 }, { x: 1275, y: 730 }, { x: 1275, y: 590 }],
        label: '1 : N', isDark
    });

    return `<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${width} ${height}" width="${width}" height="${height}">
    <rect width="${width}" height="${height}" fill="${bg}"/>
    <text x="${width/2}" y="38" fill="${titleColor}" font-size="22" font-weight="800" font-family="'Segoe UI', Roboto, sans-serif" text-anchor="middle">Modelo Relacional de Base de Datos (ERD) - BookHub</text>
    <text x="${width/2}" y="60" fill="${isDark ? '#8b949e' : '#4b5563'}" font-size="12" font-family="'Segoe UI', Roboto, sans-serif" text-anchor="middle">Cardinalidad 1 a Muchos (1:N) con Notación Pata de Gallo (Crow's Foot) • Módulo Completo de Donaciones</text>
    ${content}
</svg>`;
}

// =========================================================================
// FUNCIÓN AUXILIAR: RENDERIZAR SVG A PNG DE ALTA RESOLUCIÓN
// =========================================================================
function renderSvgToPng(svgString, pngPath, targetWidth = 2800) {
    const resvg = new Resvg(svgString, {
        fitTo: {
            mode: 'width',
            value: targetWidth
        },
        font: {
            loadSystemFonts: true
        }
    });
    const pngData = resvg.render();
    const pngBuffer = pngData.asPng();
    fs.writeFileSync(pngPath, pngBuffer);
}

// =========================================================================
// EJECUCIÓN PRINCIPAL
// =========================================================================
console.log('Generando Diagrama de Clases UML y Modelo de Datos con orden visual riguroso...');

// 1. DIAGRAMA DE CLASES UML
const umlDarkSvg = generarDiagramaClasesCompleto(true);
const umlLightSvg = generarDiagramaClasesCompleto(false);

// Guardar SVGs
fs.writeFileSync(path.join(outDir, 'diagrama-clases-uml-dark.svg'), umlDarkSvg);
fs.writeFileSync(path.join(outDir, 'diagrama-clases-uml.svg'), umlLightSvg);
fs.writeFileSync(path.join(webappOutDir, 'diagrama-clases-uml-dark.svg'), umlDarkSvg);
fs.writeFileSync(path.join(webappOutDir, 'diagrama-clases-uml.svg'), umlLightSvg);
fs.writeFileSync(path.join(desktopDir, 'diagrama-clases-uml.svg'), umlLightSvg);

// Renderizar PNGs en Escritorio
renderSvgToPng(umlDarkSvg, path.join(desktopDir, 'diagrama-clases-uml-negro.png'), 2800);
renderSvgToPng(umlDarkSvg, path.join(desktopDir, 'Diagrama_Clases_UML.png'), 2800);
renderSvgToPng(umlLightSvg, path.join(desktopDir, 'diagrama-clases-uml-blanco.png'), 2800);
console.log('✓ Diagrama de Clases UML renderizado (sin invasión de cuadros, con rutas ortogonales y multiplicidades 1...* claras).');

// 2. MODELO DE DATOS ERD
const erdDarkSvg = generarModeloDatosCompleto(true);
const erdLightSvg = generarModeloDatosCompleto(false);

fs.writeFileSync(path.join(outDir, 'modelo-de-datos-dark.svg'), erdDarkSvg);
fs.writeFileSync(path.join(outDir, 'modelo-de-datos.svg'), erdLightSvg);
fs.writeFileSync(path.join(webappOutDir, 'modelo-de-datos-dark.svg'), erdDarkSvg);
fs.writeFileSync(path.join(webappOutDir, 'modelo-de-datos.svg'), erdLightSvg);
fs.writeFileSync(path.join(desktopDir, 'modelo-de-datos.svg'), erdLightSvg);

renderSvgToPng(erdDarkSvg, path.join(desktopDir, 'modelo-de-datos-negro.png'), 2600);
renderSvgToPng(erdDarkSvg, path.join(desktopDir, 'Modelo_de_Datos.png'), 2600);
renderSvgToPng(erdLightSvg, path.join(desktopDir, 'modelo-de-datos-blanco.png'), 2600);
console.log('✓ Modelo de Datos ERD renderizado (donaciones vinculada a usuarios con 1:N).');

console.log('--- GENERACIÓN COMPLETADA EXITOSAMENTE ---');
