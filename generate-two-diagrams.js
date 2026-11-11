const fs = require('fs');
const path = require('path');

const outDir = path.join(__dirname, 'img', 'uml');
const webappOutDir = path.join(__dirname, 'src', 'main', 'webapp', 'img', 'uml');
if (!fs.existsSync(outDir)) fs.mkdirSync(outDir, { recursive: true });
if (!fs.existsSync(webappOutDir)) fs.mkdirSync(webappOutDir, { recursive: true });

function renderClassBox({ x, y, width, headerColor = '#1e40af', title, stereotype = '', attributes = [], methods = [] }) {
    const lineHeight = 18;
    const headerHeight = stereotype ? 36 : 28;
    const attrHeight = Math.max(attributes.length * lineHeight + 12, 16);
    const methodHeight = methods.length > 0 ? (methods.length * lineHeight + 12) : 0;
    const totalHeight = headerHeight + attrHeight + methodHeight;

    let svg = `
    <!-- Clase: ${title} -->
    <g transform="translate(${x}, ${y})" filter="url(#dropShadow)">
        <rect width="${width}" height="${totalHeight}" rx="6" fill="#ffffff" stroke="#94a3b8" stroke-width="1.2"/>
        <path d="M 0 6 C 0 2.7 2.7 0 6 0 L ${width - 6} 0 C ${width - 2.7} 0 ${width} 2.7 ${width} 6 L ${width} ${headerHeight} L 0 ${headerHeight} Z" fill="${headerColor}"/>
        ${stereotype ? `<text x="${width/2}" y="14" fill="#cbd5e1" font-size="10" font-family="'Segoe UI', Roboto, sans-serif" font-style="italic" text-anchor="middle">&#171;${stereotype}&#187;</text>` : ''}
        <text x="${width/2}" y="${stereotype ? 28 : 18}" fill="#ffffff" font-size="12.5" font-weight="700" font-family="'Segoe UI', Roboto, sans-serif" text-anchor="middle">${title}</text>
        
        <line x1="0" y1="${headerHeight}" x2="${width}" y2="${headerHeight}" stroke="#cbd5e1" stroke-width="1"/>
        <g transform="translate(10, ${headerHeight + 14})">
    `;

    attributes.forEach((attr, i) => {
        const safeAttr = String(attr).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
        svg += `        <text x="0" y="${i * lineHeight}" fill="#1e293b" font-size="11" font-family="'Consolas', 'Courier New', monospace">${safeAttr}</text>\n`;
    });

    svg += `    </g>\n`;

    if (methods.length > 0) {
        const methodStartY = headerHeight + attrHeight;
        svg += `
        <line x1="0" y1="${methodStartY}" x2="${width}" y2="${methodStartY}" stroke="#cbd5e1" stroke-width="1"/>
        <g transform="translate(10, ${methodStartY + 14})">
        `;
        methods.forEach((meth, i) => {
            const safeMeth = String(meth).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
            svg += `        <text x="0" y="${i * lineHeight}" fill="#334155" font-size="10.5" font-family="'Consolas', 'Courier New', monospace">${safeMeth}</text>\n`;
        });
        svg += `    </g>\n`;
    }

    svg += `    </g>\n`;
    return { svg, totalHeight, width, x, y };
}

function renderTableBox({ x, y, width, title, columns = [] }) {
    const lineHeight = 20;
    const headerHeight = 32;
    const bodyHeight = columns.length * lineHeight + 10;
    const totalHeight = headerHeight + bodyHeight;

    let svg = `
    <!-- Tabla: ${title} -->
    <g transform="translate(${x}, ${y})" filter="url(#dropShadow)">
        <rect width="${width}" height="${totalHeight}" rx="6" fill="#ffffff" stroke="#94a3b8" stroke-width="1.2"/>
        <path d="M 0 6 C 0 2.7 2.7 0 6 0 L ${width - 6} 0 C ${width - 2.7} 0 ${width} 2.7 ${width} 6 L ${width} ${headerHeight} L 0 ${headerHeight} Z" fill="#0f766e"/>
        <text x="12" y="21" fill="#ccfbf1" font-size="11" font-weight="700" font-family="'Segoe UI', Roboto, sans-serif">TABLE</text>
        <text x="${width/2}" y="21" fill="#ffffff" font-size="13" font-weight="700" font-family="'Segoe UI', Roboto, sans-serif" text-anchor="middle">${title}</text>
        
        <line x1="0" y1="${headerHeight}" x2="${width}" y2="${headerHeight}" stroke="#cbd5e1" stroke-width="1"/>
        <g transform="translate(10, ${headerHeight + 15})">
    `;

    columns.forEach((col, i) => {
        const isPk = col.key === 'PK';
        const isFk = col.key === 'FK';
        const badgeColor = isPk ? '#b91c1c' : (isFk ? '#2563eb' : '#64748b');
        const badgeBg = isPk ? '#fee2e2' : (isFk ? '#dbeafe' : '#f1f5f9');

        svg += `        <g transform="translate(0, ${i * lineHeight})">`;
        if (col.key) {
            svg += `<rect x="0" y="-10" width="24" height="14" rx="3" fill="${badgeBg}"/>`;
            svg += `<text x="12" y="1" fill="${badgeColor}" font-size="9" font-weight="800" font-family="'Consolas', monospace" text-anchor="middle">${col.key}</text>`;
        }
        svg += `<text x="32" y="1" fill="#0f172a" font-size="11.5" font-weight="${isPk ? '700' : '500'}" font-family="'Consolas', monospace">${col.name}</text>`;
        svg += `<text x="${width - 20}" y="1" fill="#64748b" font-size="11" font-family="'Consolas', monospace" text-anchor="end">${col.type}</text>`;
        svg += `</g>\n`;
    });

    svg += `    </g>\n    </g>\n`;
    return { svg, totalHeight, width, x, y };
}

function renderArrow({ x1, y1, x2, y2, label = '', multiplicityFrom = '', multiplicityTo = '', dashed = false, marker = 'arrow' }) {
    const dashAttr = dashed ? 'stroke-dasharray="4,4"' : '';
    let svg = `
    <line x1="${x1}" y1="${y1}" x2="${x2}" y2="${y2}" stroke="#475569" stroke-width="1.4" ${dashAttr} marker-end="url(#${marker})"/>
    `;
    if (label) {
        const mx = (x1 + x2) / 2;
        const my = (y1 + y2) / 2 - 6;
        svg += `<text x="${mx}" y="${my}" fill="#0f172a" font-size="10.5" font-weight="600" font-family="'Segoe UI', Roboto, sans-serif" text-anchor="middle">${label}</text>\n`;
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

function wrapSvg(width, height, content, title, subtitle) {
    return `<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${width} ${height}" width="${width}" height="${height}">
    <defs>
        <filter id="dropShadow" x="-5%" y="-5%" width="112%" height="115%">
            <feDropShadow dx="0" dy="2" stdDeviation="3" flood-color="#0f172a" flood-opacity="0.12"/>
        </filter>
        <marker id="arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto">
            <path d="M 0 1 L 9 5 L 0 9 z" fill="#475569"/>
        </marker>
        <marker id="crow" viewBox="0 0 12 12" refX="10" refY="6" markerWidth="8" markerHeight="8" orient="auto">
            <path d="M 0 0 L 10 6 L 0 12 M 10 0 L 10 12" fill="none" stroke="#0f766e" stroke-width="1.5"/>
        </marker>
    </defs>

    <rect width="${width}" height="${height}" fill="#f8fafc"/>
    <rect x="8" y="8" width="${width - 16}" height="${height - 16}" rx="8" fill="#ffffff" stroke="#e2e8f0" stroke-width="1"/>

    <text x="30" y="38" fill="#0f172a" font-size="18" font-weight="800" font-family="'Segoe UI', Roboto, sans-serif">${title}</text>
    <text x="30" y="56" fill="#64748b" font-size="12" font-family="'Segoe UI', Roboto, sans-serif">${subtitle}</text>
    <line x1="30" y1="68" x2="${width - 30}" y2="68" stroke="#e2e8f0" stroke-width="1"/>

    ${content}
</svg>`;
}

// =========================================================================
// 1. DIAGRAMA DE CLASES UML (COMPLETO)
// =========================================================================
function generarDiagramaClasesUML() {
    let content = '';

    // Fila 1: Entidades de Dominio
    content += renderClassBox({
        x: 30, y: 90, width: 220, headerColor: '#1e40af', title: 'Autor', stereotype: 'modelo.beans',
        attributes: [
            'idAutor : int',
            'nombre : String',
            'nacionalidad : String'
        ],
        methods: [
            'getIdAutor() : int',
            'setIdAutor(int) : void',
            'getNombre() : String',
            'setNombre(String) : void'
        ]
    }).svg;

    content += renderClassBox({
        x: 290, y: 90, width: 250, headerColor: '#1e40af', title: 'Libro', stereotype: 'modelo.beans',
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
            'getCategoria() : Categoria',
            'setStock(int) : void'
        ]
    }).svg;

    content += renderClassBox({
        x: 580, y: 90, width: 220, headerColor: '#1e40af', title: 'Categoria', stereotype: 'modelo.beans',
        attributes: [
            'idCategoria : int',
            'nombre : String',
            'descripcion : String'
        ],
        methods: [
            'getIdCategoria() : int',
            'setIdCategoria(int) : void',
            'getNombre() : String',
            'setNombre(String) : void'
        ]
    }).svg;

    content += renderClassBox({
        x: 840, y: 90, width: 230, headerColor: '#1e40af', title: 'Usuario', stereotype: 'modelo.beans',
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

    // Fila 2: Prestamo y Donacion
    content += renderClassBox({
        x: 290, y: 450, width: 250, headerColor: '#1e40af', title: 'Prestamo', stereotype: 'modelo.beans',
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
            'setEstado(String) : void'
        ]
    }).svg;

    content += renderClassBox({
        x: 580, y: 450, width: 250, headerColor: '#1e40af', title: 'Donacion', stereotype: 'modelo.beans',
        attributes: [
            'idDonacion : int',
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
            'getTituloLibro() : String',
            'getEstadoRevision() : String',
            'setEstadoRevision(String) : void'
        ]
    }).svg;

    // Relaciones entre entidades
    content += renderArrow({ x1: 290, y1: 170, x2: 250, y2: 170, label: 'escrito por', multiplicityFrom: '*', multiplicityTo: '1' });
    content += renderArrow({ x1: 540, y1: 170, x2: 580, y2: 170, label: 'clasificado en', multiplicityFrom: '*', multiplicityTo: '1' });
    content += renderArrow({ x1: 415, y1: 450, x2: 415, y2: 410, label: 'ejemplar prestado', multiplicityFrom: '*', multiplicityTo: '1' });
    content += renderArrow({ x1: 540, y1: 520, x2: 840, y2: 230, label: 'solicitado por', multiplicityFrom: '*', multiplicityTo: '1' });

    // Fila 3: Capa DAO y Conexion
    content += renderClassBox({
        x: 30, y: 310, width: 220, headerColor: '#0f766e', title: 'AutorDAO', stereotype: 'modelo.dao',
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
        x: 30, y: 490, width: 220, headerColor: '#0f766e', title: 'CategoriaDAO', stereotype: 'modelo.dao',
        attributes: [],
        methods: [
            'listar() : List<Categoria>',
            'obtenerPorId(int) : Categoria',
            'agregar(Categoria) : void',
            'actualizar(Categoria) : void',
            'eliminar(int) : void'
        ]
    }).svg;

    content += renderClassBox({
        x: 870, y: 310, width: 220, headerColor: '#0f766e', title: 'UsuarioDAO', stereotype: 'modelo.dao',
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
        x: 870, y: 490, width: 220, headerColor: '#0f766e', title: 'PrestamoDAO', stereotype: 'modelo.dao',
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
        x: 580, y: 710, width: 250, headerColor: '#0f766e', title: 'DonacionDAO', stereotype: 'modelo.dao',
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
        x: 290, y: 710, width: 250, headerColor: '#0f766e', title: 'LibroDAO', stereotype: 'modelo.dao',
        attributes: [],
        methods: [
            'listar() : List<Libro>',
            'obtenerPorId(int) : Libro',
            'buscar(String, String) : List<Libro>',
            'agregar(Libro) : void',
            'actualizar(Libro) : void',
            'actualizarStock(int, int) : void'
        ]
    }).svg;

    content += renderClassBox({
        x: 870, y: 690, width: 220, headerColor: '#3730a3', title: 'Conexion', stereotype: 'modelo.conexion',
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

    // Dependencias DAO -> Entidades y Conexión
    content += renderArrow({ x1: 290, y1: 760, x2: 250, y2: 760, label: '', dashed: true });
    content += renderArrow({ x1: 870, y1: 760, x2: 830, y2: 760, label: '«usa»', dashed: true });

    return wrapSvg(1120, 890, content, 'Diagrama de Clases UML del Sistema BookHub', 'Arquitectura MVC — Paquetes modelo.beans, modelo.dao y modelo.conexion');
}

// =========================================================================
// 2. MODELO DE DATOS (BASE DE DATOS MYSQL - RELACIONAL ERD)
// =========================================================================
function generarModeloDeDatos() {
    let content = '';

    // Tabla autores
    content += renderTableBox({
        x: 40, y: 90, width: 270, title: 'autores',
        columns: [
            { key: 'PK', name: 'id_autor', type: 'INT (AUTO_INC)' },
            { key: '', name: 'nombre', type: 'VARCHAR(120)' },
            { key: '', name: 'nacionalidad', type: 'VARCHAR(80)' }
        ]
    }).svg;

    // Tabla categorias
    content += renderTableBox({
        x: 40, y: 240, width: 270, title: 'categorias',
        columns: [
            { key: 'PK', name: 'id_categoria', type: 'INT (AUTO_INC)' },
            { key: '', name: 'nombre', type: 'VARCHAR(100)' },
            { key: '', name: 'descripcion', type: 'VARCHAR(255)' }
        ]
    }).svg;

    // Tabla libros
    content += renderTableBox({
        x: 390, y: 90, width: 310, title: 'libros',
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

    // Tabla usuarios
    content += renderTableBox({
        x: 770, y: 90, width: 290, title: 'usuarios',
        columns: [
            { key: 'PK', name: 'id_usuario', type: 'INT (AUTO_INC)' },
            { key: '', name: 'nombre', type: 'VARCHAR(120)' },
            { key: '', name: 'correo', type: 'VARCHAR(120) UNIQUE' },
            { key: '', name: 'password', type: 'VARCHAR(120)' },
            { key: '', name: 'rol', type: 'VARCHAR(20)' },
            { key: '', name: 'estado', type: 'VARCHAR(20)' }
        ]
    }).svg;

    // Tabla prestamos
    content += renderTableBox({
        x: 580, y: 380, width: 310, title: 'prestamos',
        columns: [
            { key: 'PK', name: 'id_prestamo', type: 'INT (AUTO_INC)' },
            { key: 'FK', name: 'id_usuario', type: 'INT (usuarios)' },
            { key: 'FK', name: 'id_libro', type: 'INT (libros)' },
            { key: '', name: 'fecha_prestamo', type: 'VARCHAR(20)' },
            { key: '', name: 'fecha_devolucion', type: 'VARCHAR(20)' },
            { key: '', name: 'estado', type: 'VARCHAR(20)' }
        ]
    }).svg;

    // Tabla donaciones
    content += renderTableBox({
        x: 40, y: 390, width: 310, title: 'donaciones',
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

    // Líneas de Relación (Foreign Keys)
    // autores -> libros
    content += renderArrow({ x1: 310, y1: 150, x2: 390, y2: 150, label: 'fk_libro_autor (1:N)', marker: 'crow' });

    // categorias -> libros
    content += renderArrow({ x1: 310, y1: 270, x2: 390, y2: 240, label: 'fk_libro_categoria (1:N)', marker: 'crow' });

    // libros -> prestamos
    content += renderArrow({ x1: 545, y1: 320, x2: 630, y2: 380, label: 'fk_prestamo_libro (1:N)', marker: 'crow' });

    // usuarios -> prestamos
    content += renderArrow({ x1: 870, y1: 260, x2: 780, y2: 380, label: 'fk_prestamo_usuario (1:N)', marker: 'crow' });

    return wrapSvg(1100, 680, content, 'Modelo de Datos Relacional (Base de Datos MySQL: bookhub)', 'Esquema de Tablas, Claves Primarias (PK), Claves Foráneas (FK) y Cardinalidades');
}

// Generar los 2 archivos
const file1 = generarDiagramaClasesUML();
fs.writeFileSync(path.join(outDir, 'diagrama-clases-uml.svg'), file1, 'utf8');
fs.writeFileSync(path.join(webappOutDir, 'diagrama-clases-uml.svg'), file1, 'utf8');
console.log('Generado: diagrama-clases-uml.svg');

const file2 = generarModeloDeDatos();
fs.writeFileSync(path.join(outDir, 'modelo-de-datos.svg'), file2, 'utf8');
fs.writeFileSync(path.join(webappOutDir, 'modelo-de-datos.svg'), file2, 'utf8');
console.log('Generado: modelo-de-datos.svg');

console.log('Los 2 diagramas fueron generados con éxito.');
