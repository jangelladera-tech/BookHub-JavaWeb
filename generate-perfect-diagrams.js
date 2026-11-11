const fs = require('fs');
const path = require('path');
const { Resvg } = require('@resvg/resvg-js');

const outDir = path.join(__dirname, 'img', 'uml');
const webappOutDir = path.join(__dirname, 'src', 'main', 'webapp', 'img', 'uml');
const desktopDir = 'C:\\Users\\Jesus Angel\\Desktop';

if (!fs.existsSync(outDir)) fs.mkdirSync(outDir, { recursive: true });
if (!fs.existsSync(webappOutDir)) fs.mkdirSync(webappOutDir, { recursive: true });

// =========================================================================
// 1. DIAGRAMA DE CLASES UML (Inspirado exactamente en diagrama-de-clases-uml-ejemplo-1.jpg)
// =========================================================================
function renderUmlClassBox({ x, y, width, headerColor = '#5b9bd5', title, attributes = [], methods = [], isDark = false }) {
    const lineHeight = 19;
    const headerHeight = 32;
    const attrHeight = Math.max(attributes.length * lineHeight + 12, 18);
    const methodHeight = methods.length > 0 ? (methods.length * lineHeight + 12) : 0;
    const totalHeight = headerHeight + attrHeight + methodHeight;

    const boxBg = isDark ? '#161b22' : '#ffffff';
    const boxBorder = isDark ? '#30363d' : '#2b579a';
    const textAttr = isDark ? '#e6edf3' : '#1e293b';
    const textMeth = isDark ? '#79c0ff' : '#1e293b';
    const dividerColor = isDark ? '#30363d' : '#94a3b8';

    let svg = `
    <!-- Clase: ${title} -->
    <g transform="translate(${x}, ${y})">
        <rect width="${width}" height="${totalHeight}" fill="${boxBg}" stroke="${boxBorder}" stroke-width="1.5"/>
        <rect width="${width}" height="${headerHeight}" fill="${headerColor}"/>
        <text x="${width/2}" y="21" fill="#ffffff" font-size="14" font-weight="700" font-family="'Segoe UI', Roboto, Helvetica, Arial, sans-serif" text-anchor="middle">${title}</text>
        
        <line x1="0" y1="${headerHeight}" x2="${width}" y2="${headerHeight}" stroke="${dividerColor}" stroke-width="1.2"/>
        <g transform="translate(10, ${headerHeight + 15})">
    `;

    attributes.forEach((attr, i) => {
        const safeAttr = String(attr).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
        svg += `        <text x="0" y="${i * lineHeight}" fill="${textAttr}" font-size="12" font-family="'Segoe UI', Roboto, sans-serif">${safeAttr}</text>\n`;
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
            svg += `        <text x="0" y="${i * lineHeight}" fill="${textMeth}" font-size="12" font-family="'Segoe UI', Roboto, sans-serif">${safeMeth}</text>\n`;
        });
        svg += `    </g>\n`;
    }

    svg += `    </g>\n`;
    return { svg, totalHeight, width, x, y };
}

function generarDiagramaClasesFiel(isDark = false) {
    const width = 1200;
    const height = 780;

    const bg = isDark ? '#0d1117' : '#ffffff';
    const textHeaderColor = isDark ? '#f0f6fc' : '#111827';
    const strokeLine = isDark ? '#c9d1d9' : '#000000';
    const textLabel = isDark ? '#f0f6fc' : '#000000';
    const diamondFill = isDark ? '#f0f6fc' : '#000000';

    const headerBlue = isDark ? '#1f6feb' : '#5b9bd5';
    const headerSub = isDark ? '#238636' : '#41719c';

    let content = '';

    // ==========================================================
    // CAJAS DE CLASES (Estructura idéntica al ejemplo 1)
    // ==========================================================
    
    // 1. LECTOR / USUARIO (Arriba Izquierda)
    content += renderUmlClassBox({
        x: 60, y: 100, width: 220, headerColor: headerBlue, title: 'Lector', isDark,
        attributes: [
            'ID de usuario : int',
            'Nombre : String',
            'Correo : String',
            'Telefono : String'
        ],
        methods: [
            'Reservar(material)',
            'Entregar(material)'
        ]
    }).svg;

    // 2. PEDIDO / PRESTAMO (Arriba Centro)
    content += renderUmlClassBox({
        x: 420, y: 100, width: 230, headerColor: headerBlue, title: 'Prestamo', isDark,
        attributes: [
            'ID de prestamo : int',
            'ID del usuario : int',
            'Titulo material : String',
            'Codigo material : int'
        ],
        methods: [
            'Reservar(fecha)',
            'Entregar(fecha)'
        ]
    }).svg;

    // 3. BIBLIOTECARIO / ADMIN (Centro Abajo de Prestamo)
    content += renderUmlClassBox({
        x: 420, y: 350, width: 230, headerColor: headerBlue, title: 'Bibliotecario', isDark,
        attributes: [
            'ID de personal : int',
            'Nombre : String',
            'Turno : String'
        ],
        methods: [
            'Reserva(fecha)',
            'Entrega(fecha)'
        ]
    }).svg;

    // 4. LIBRO (Centro Derecha)
    content += renderUmlClassBox({
        x: 730, y: 240, width: 190, headerColor: headerBlue, title: 'Libro', isDark,
        attributes: [
            'Titulo del libro : String',
            'Tipo de libro : String',
            'Autor : String',
            'Editorial : String',
            'Stock : int'
        ],
        methods: [
            'Reservar(fecha)',
            'Entregar(fecha)'
        ]
    }).svg;

    // 5. DONACION / REVISTA (Extrema Derecha)
    content += renderUmlClassBox({
        x: 970, y: 240, width: 190, headerColor: headerBlue, title: 'Donacion', isDark,
        attributes: [
            'Titulo material : String',
            'Tipo de material : String',
            'Donante : String',
            'Estado revision : String'
        ],
        methods: [
            'Registrar(fecha)',
            'Validar(estado)'
        ]
    }).svg;

    // 6 y 7. SUBCLASES DE LECTOR (Abajo Izquierda: Estudiante y Docente)
    content += renderUmlClassBox({
        x: 40, y: 560, width: 190, headerColor: headerSub, title: 'Estudiante', isDark,
        attributes: [
            'Codigo estudiante : String',
            'Carrera : String'
        ],
        methods: [
            'Reservar(libro)',
            'Entregar(libro)'
        ]
    }).svg;

    content += renderUmlClassBox({
        x: 250, y: 560, width: 190, headerColor: headerSub, title: 'Docente', isDark,
        attributes: [
            'Codigo docente : String',
            'Departamento : String'
        ],
        methods: [
            'Reservar(libro)',
            'Entregar(libro)'
        ]
    }).svg;

    // ==========================================================
    // LÍNEAS Y RELACIONES (Cero cruces, destinos exactos)
    // ==========================================================

    // Relación Lector -> Prestamo (Rombo de agregación/composición como en el ejemplo)
    content += `
    <!-- Rombo negro en Lector -->
    <polygon points="280,140 295,133 310,140 295,147" fill="${diamondFill}" stroke="${strokeLine}" stroke-width="1.5"/>
    <line x1="310" y1="140" x2="420" y2="140" stroke="${strokeLine}" stroke-width="1.8"/>
    <text x="395" y="130" fill="${textLabel}" font-size="12" font-weight="700" font-family="'Segoe UI', sans-serif">1...*</text>
    `;

    // Relación Prestamo -> Bibliotecario (Línea discontinua con flecha vertical)
    content += `
    <line x1="535" y1="262" x2="535" y2="350" stroke="${strokeLine}" stroke-width="1.8" stroke-dasharray="6,4" marker-end="url(#arrowSimple)"/>
    <text x="548" y="310" fill="${textLabel}" font-size="12" font-weight="700" font-family="'Segoe UI', sans-serif">1...*</text>
    `;

    // Relación Bibliotecario -> Lector ("Entrega, recibe")
    content += `
    <path d="M 420 420 L 320 420 L 320 220 L 280 220" fill="none" stroke="${strokeLine}" stroke-width="1.8"/>
    <text x="330" y="325" fill="${textLabel}" font-size="11.5" font-weight="600" font-family="'Segoe UI', sans-serif">Entrega,</text>
    <text x="330" y="342" fill="${textLabel}" font-size="11.5" font-weight="600" font-family="'Segoe UI', sans-serif">recibe</text>
    `;

    // Relación Prestamo -> Libro y Donacion ("necesita")
    content += `
    <!-- Rama hacia Libro -->
    <path d="M 650 170 L 825 170 L 825 240" fill="none" stroke="${strokeLine}" stroke-width="1.8"/>
    <text x="715" y="160" fill="${textLabel}" font-size="12" font-weight="600" font-family="'Segoe UI', sans-serif">necesita</text>
    <text x="812" y="230" fill="${textLabel}" font-size="12" font-weight="700" font-family="'Segoe UI', sans-serif">1</text>

    <!-- Rama hacia Donacion / Revista -->
    <path d="M 825 170 L 1065 170 L 1065 240" fill="none" stroke="${strokeLine}" stroke-width="1.8"/>
    <text x="940" y="160" fill="${textLabel}" font-size="12" font-weight="600" font-family="'Segoe UI', sans-serif">necesita</text>
    <text x="1052" y="230" fill="${textLabel}" font-size="12" font-weight="700" font-family="'Segoe UI', sans-serif">1</text>
    `;

    // Relación Lector -> Estudiante y Docente (Líneas verticales con flecha hacia abajo)
    content += `
    <!-- Hacia Estudiante -->
    <line x1="135" y1="280" x2="135" y2="560" stroke="${strokeLine}" stroke-width="1.8" marker-end="url(#arrowSimple)"/>
    <text x="145" y="540" fill="${textLabel}" font-size="12" font-weight="700" font-family="'Segoe UI', sans-serif">1</text>

    <!-- Hacia Docente -->
    <path d="M 230 280 L 230 500 L 345 500 L 345 560" fill="none" stroke="${strokeLine}" stroke-width="1.8" marker-end="url(#arrowSimple)"/>
    <text x="355" y="540" fill="${textLabel}" font-size="12" font-weight="700" font-family="'Segoe UI', sans-serif">1</text>
    `;

    return `<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${width} ${height}" width="${width}" height="${height}">
    <defs>
        <marker id="arrowSimple" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" markerHeight="7" orient="auto">
            <path d="M 0 1 L 9 5 L 0 9 z" fill="${strokeLine}"/>
        </marker>
    </defs>

    <rect width="${width}" height="${height}" fill="${bg}"/>

    <!-- Título idéntico al formato del ejemplo -->
    <text x="${width/2}" y="50" fill="${textHeaderColor}" font-size="22" font-weight="800" font-family="'Segoe UI', Roboto, sans-serif" text-anchor="middle">Diagrama de clases de un sistema de servicios bibliotecarios</text>

    ${content}
</svg>`;
}

// =========================================================================
// 2. MODELO DE DATOS ERD (Inspirado exactamente en images.png)
// =========================================================================
function renderErdTableBox({ x, y, width, title, columns = [], isDark = false }) {
    const rowHeight = 22;
    const headerHeight = 28;
    const totalHeight = headerHeight + columns.length * rowHeight + 10;

    const boxBg = isDark ? '#161b22' : '#ffffff';
    const boxBorder = isDark ? '#30363d' : '#2d3748';
    const headerBg = isDark ? '#382bf0' : '#c4b5fd'; // Morado / Lila pastel idéntico a images.png
    const headerText = isDark ? '#ffffff' : '#1e1b4b';
    const textName = isDark ? '#f0f6fc' : '#0f172a';
    const textType = isDark ? '#8b949e' : '#4b5563';
    const gridLine = isDark ? '#30363d' : '#cbd5e1';

    let svg = `
    <!-- Tabla ERD: ${title} -->
    <g transform="translate(${x}, ${y})">
        <!-- Contenedor general -->
        <rect width="${width}" height="${totalHeight}" rx="4" fill="${boxBg}" stroke="${boxBorder}" stroke-width="1.4"/>
        
        <!-- Cabecera morada pastel -->
        <path d="M 0 4 C 0 1.8 1.8 0 4 0 L ${width-4} 0 C ${width-1.8} 0 ${width} 1.8 ${width} 4 L ${width} ${headerHeight} L 0 ${headerHeight} Z" fill="${headerBg}"/>
        <text x="${width/2}" y="19" fill="${headerText}" font-size="13" font-weight="700" font-family="'Segoe UI', Roboto, sans-serif" text-anchor="middle">${title}</text>
        
        <line x1="0" y1="${headerHeight}" x2="${width}" y2="${headerHeight}" stroke="${boxBorder}" stroke-width="1.2"/>

        <!-- Líneas divisorias de columnas internas (PK/FK | Nombre | Tipo) -->
        <line x1="42" y1="${headerHeight}" x2="42" y2="${totalHeight}" stroke="${gridLine}" stroke-width="1"/>
        <line x1="${width - 95}" y1="${headerHeight}" x2="${width - 95}" y2="${totalHeight}" stroke="${gridLine}" stroke-width="1"/>

        <!-- Filas de atributos -->
        <g transform="translate(0, ${headerHeight + 16})">
    `;

    columns.forEach((col, i) => {
        const yPos = i * rowHeight;
        const isPk = col.key.includes('PK');
        const isFk = col.key.includes('FK');
        const keyColor = isPk ? '#b91c1c' : (isFk ? '#0369a1' : textType);

        svg += `
        <!-- Fila ${col.name} -->
        <text x="21" y="${yPos}" fill="${keyColor}" font-size="10.5" font-weight="700" font-family="'Consolas', monospace" text-anchor="middle">${col.key}</text>
        <text x="50" y="${yPos}" fill="${textName}" font-size="11.5" font-weight="${isPk ? '700' : '500'}" font-family="'Consolas', monospace">${col.name}</text>
        <text x="${width - 15}" y="${yPos}" fill="${textType}" font-size="11" font-family="'Consolas', monospace" text-anchor="end">${col.type}</text>
        `;
    });

    svg += `    </g>\n    </g>\n`;
    return { svg, totalHeight, width, x, y };
}

function generarModeloDatosFiel(isDark = false) {
    const width = 1260;
    const height = 820;

    const bg = isDark ? '#0d1117' : '#ffffff';
    const titleColor = isDark ? '#f0f6fc' : '#1e1b4b';
    const strokeLine = isDark ? '#c9d1d9' : '#1e293b';

    let content = '';

    // ==========================================================
    // DISPOSICIÓN DE TABLAS IDÉNTICA A images.png (Cero cruces)
    // ==========================================================

    // 1. autores (Arriba Izquierda)
    content += renderErdTableBox({
        x: 60, y: 70, width: 280, title: 'autores', isDark,
        columns: [
            { key: 'PK', name: 'id_autor', type: 'INT' },
            { key: '', name: 'nombre', type: 'VARCHAR(120)' },
            { key: '', name: 'nacionalidad', type: 'VARCHAR(80)' }
        ]
    }).svg;

    // 2. libros (Arriba Centro)
    content += renderErdTableBox({
        x: 440, y: 70, width: 340, title: 'libros', isDark,
        columns: [
            { key: 'PK', name: 'id_libro', type: 'INT' },
            { key: '', name: 'titulo', type: 'VARCHAR(200)' },
            { key: '', name: 'isbn', type: 'VARCHAR(30)' },
            { key: '', name: 'anio', type: 'INT' },
            { key: '', name: 'stock', type: 'INT' },
            { key: 'FK1', name: 'id_autor', type: 'INT' },
            { key: 'FK2', name: 'id_categoria', type: 'INT' }
        ]
    }).svg;

    // 3. categorias (Medio Izquierda)
    content += renderErdTableBox({
        x: 60, y: 270, width: 280, title: 'categorias', isDark,
        columns: [
            { key: 'PK', name: 'id_categoria', type: 'INT' },
            { key: '', name: 'nombre', type: 'VARCHAR(100)' },
            { key: '', name: 'descripcion', type: 'VARCHAR(255)' }
        ]
    }).svg;

    // 4. prestamos (Centro Abajo)
    content += renderErdTableBox({
        x: 440, y: 390, width: 340, title: 'prestamos', isDark,
        columns: [
            { key: 'PK', name: 'id_prestamo', type: 'INT' },
            { key: 'FK1', name: 'id_usuario', type: 'INT' },
            { key: 'FK2', name: 'id_libro', type: 'INT' },
            { key: '', name: 'fecha_prestamo', type: 'VARCHAR(20)' },
            { key: '', name: 'fecha_devolucion', type: 'VARCHAR(20)' },
            { key: '', name: 'estado', type: 'VARCHAR(20)' }
        ]
    }).svg;

    // 5. usuarios (Derecha Arriba)
    content += renderErdTableBox({
        x: 880, y: 70, width: 310, title: 'usuarios', isDark,
        columns: [
            { key: 'PK', name: 'id_usuario', type: 'INT' },
            { key: '', name: 'nombre', type: 'VARCHAR(120)' },
            { key: '', name: 'correo', type: 'VARCHAR(120)' },
            { key: '', name: 'password', type: 'VARCHAR(120)' },
            { key: '', name: 'rol', type: 'VARCHAR(20)' },
            { key: '', name: 'estado', type: 'VARCHAR(20)' }
        ]
    }).svg;

    // 6. donaciones (Derecha Abajo)
    content += renderErdTableBox({
        x: 880, y: 390, width: 310, title: 'donaciones', isDark,
        columns: [
            { key: 'PK', name: 'id_donacion', type: 'INT' },
            { key: '', name: 'titulo_libro', type: 'VARCHAR(200)' },
            { key: '', name: 'autor', type: 'VARCHAR(120)' },
            { key: '', name: 'categoria', type: 'VARCHAR(100)' },
            { key: '', name: 'anio', type: 'INT' },
            { key: '', name: 'nombre_donante', type: 'VARCHAR(120)' },
            { key: '', name: 'estado_revision', type: 'VARCHAR(30)' }
        ]
    }).svg;

    // ==========================================================
    // LÍNEAS DE RELACIÓN EXACTAS ESTILO CROW'S FOOT (images.png)
    // Cero cruces, ángulos rectos perfectos con círculo y pata
    // ==========================================================

    // Símbolo Pata de Gallo (Crow's foot) + Círculo exacto al ejemplo
    // 1. autores.id_autor (PK) <---- (FK1) libros.id_autor
    content += `
    <!-- autores -> libros -->
    <path d="M 340 114 L 390 114 L 390 206 L 440 206" fill="none" stroke="${strokeLine}" stroke-width="1.8"/>
    <!-- Extremo PK (Uno): Barra vertical -->
    <line x1="348" y1="108" x2="348" y2="120" stroke="${strokeLine}" stroke-width="1.8"/>
    <!-- Extremo FK (Muchos): Círculo + Pata de gallo -->
    <circle cx="426" cy="206" r="4" fill="${bg}" stroke="${strokeLine}" stroke-width="1.8"/>
    <path d="M 440 200 L 430 206 L 440 212" fill="none" stroke="${strokeLine}" stroke-width="1.8"/>
    `;

    // 2. categorias.id_categoria (PK) <---- (FK2) libros.id_categoria
    content += `
    <!-- categorias -> libros -->
    <path d="M 340 314 L 390 314 L 390 228 L 440 228" fill="none" stroke="${strokeLine}" stroke-width="1.8"/>
    <!-- Extremo PK (Uno): Barra vertical -->
    <line x1="348" y1="308" x2="348" y2="320" stroke="${strokeLine}" stroke-width="1.8"/>
    <!-- Extremo FK (Muchos): Círculo + Pata de gallo -->
    <circle cx="426" cy="228" r="4" fill="${bg}" stroke="${strokeLine}" stroke-width="1.8"/>
    <path d="M 440 222 L 430 228 L 440 234" fill="none" stroke="${strokeLine}" stroke-width="1.8"/>
    `;

    // 3. libros.id_libro (PK) <---- (FK2) prestamos.id_libro
    content += `
    <!-- libros -> prestamos (Vertical puro hacia abajo) -->
    <line x1="560" y1="262" x2="560" y2="390" stroke="${strokeLine}" stroke-width="1.8"/>
    <!-- Extremo PK (Uno): Barra horizontal -->
    <line x1="554" y1="270" x2="566" y2="270" stroke="${strokeLine}" stroke-width="1.8"/>
    <!-- Extremo FK (Muchos): Círculo + Pata de gallo -->
    <circle cx="560" cy="376" r="4" fill="${bg}" stroke="${strokeLine}" stroke-width="1.8"/>
    <path d="M 554 390 L 560 380 L 566 390" fill="none" stroke="${strokeLine}" stroke-width="1.8"/>
    `;

    // 4. usuarios.id_usuario (PK) <---- (FK1) prestamos.id_usuario
    content += `
    <!-- usuarios -> prestamos (Canal limpio a la derecha) -->
    <path d="M 880 114 L 830 114 L 830 436 L 780 436" fill="none" stroke="${strokeLine}" stroke-width="1.8"/>
    <!-- Extremo PK (Uno): Barra vertical -->
    <line x1="872" y1="108" x2="872" y2="120" stroke="${strokeLine}" stroke-width="1.8"/>
    <!-- Extremo FK (Muchos): Círculo + Pata de gallo -->
    <circle cx="794" cy="436" r="4" fill="${bg}" stroke="${strokeLine}" stroke-width="1.8"/>
    <path d="M 780 430 L 790 436 L 780 442" fill="none" stroke="${strokeLine}" stroke-width="1.8"/>
    `;

    return `<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${width} ${height}" width="${width}" height="${height}">
    <rect width="${width}" height="${height}" fill="${bg}"/>

    <!-- Título superior -->
    <text x="${width/2}" y="42" fill="${titleColor}" font-size="20" font-weight="800" font-family="'Segoe UI', Roboto, sans-serif" text-anchor="middle">Modelo de Datos Relacional (Base de Datos MySQL: bookhub)</text>

    ${content}
</svg>`;
}

// =========================================================================
// GENERACIÓN Y EXPORTACIÓN A PROYECTO Y ESCRITORIO
// =========================================================================

// 1. DIAGRAMA DE CLASES (Light y Dark)
const umlLight = generarDiagramaClasesFiel(false);
const umlDark = generarDiagramaClasesFiel(true);

fs.writeFileSync(path.join(outDir, 'diagrama-clases-uml.svg'), umlLight, 'utf8');
fs.writeFileSync(path.join(webappOutDir, 'diagrama-clases-uml.svg'), umlLight, 'utf8');
fs.writeFileSync(path.join(outDir, 'diagrama-clases-uml-dark.svg'), umlDark, 'utf8');
fs.writeFileSync(path.join(webappOutDir, 'diagrama-clases-uml-dark.svg'), umlDark, 'utf8');

// Renderizar PNG para escritorio
const resvgUmlDark = new Resvg(umlDark, { fitTo: { mode: 'width', value: 2400 }, background: '#0d1117' });
const pngUmlDark = resvgUmlDark.render().asPng();
fs.writeFileSync(path.join(desktopDir, 'diagrama-clases-uml-negro.png'), pngUmlDark);
fs.writeFileSync(path.join(desktopDir, 'Diagrama_Clases_UML.png'), pngUmlDark);
fs.writeFileSync(path.join(desktopDir, 'diagrama-clases-uml.svg'), umlDark);

const resvgUmlLight = new Resvg(umlLight, { fitTo: { mode: 'width', value: 2400 }, background: '#ffffff' });
fs.writeFileSync(path.join(desktopDir, 'diagrama-clases-uml-blanco.png'), resvgUmlLight.render().asPng());

console.log('✓ Diagrama de Clases adaptado fielmente al ejemplo 1.');

// 2. MODELO DE DATOS ERD (Light y Dark)
const erdLight = generarModeloDatosFiel(false);
const erdDark = generarModeloDatosFiel(true);

fs.writeFileSync(path.join(outDir, 'modelo-de-datos.svg'), erdLight, 'utf8');
fs.writeFileSync(path.join(webappOutDir, 'modelo-de-datos.svg'), erdLight, 'utf8');
fs.writeFileSync(path.join(outDir, 'modelo-de-datos-dark.svg'), erdDark, 'utf8');
fs.writeFileSync(path.join(webappOutDir, 'modelo-de-datos-dark.svg'), erdDark, 'utf8');

// Renderizar PNG para escritorio
const resvgErdDark = new Resvg(erdDark, { fitTo: { mode: 'width', value: 2520 }, background: '#0d1117' });
const pngErdDark = resvgErdDark.render().asPng();
fs.writeFileSync(path.join(desktopDir, 'modelo-de-datos-negro.png'), pngErdDark);
fs.writeFileSync(path.join(desktopDir, 'Modelo_de_Datos.png'), pngErdDark);
fs.writeFileSync(path.join(desktopDir, 'modelo-de-datos.svg'), erdDark);

const resvgErdLight = new Resvg(erdLight, { fitTo: { mode: 'width', value: 2520 }, background: '#ffffff' });
fs.writeFileSync(path.join(desktopDir, 'modelo-de-datos-blanco.png'), resvgErdLight.render().asPng());

console.log('✓ Modelo de Datos adaptado fielmente al ejemplo 2 (images.png).');
console.log('--- AMBOS DIAGRAMAS GENERADOS Y COLOCADOS EN EL ESCRITORIO CON ÉXITO ---');
