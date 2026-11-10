const fs = require('fs');
const path = require('path');

const webappDir = path.join(__dirname, 'src', 'main', 'webapp');
const outDir = __dirname;

// Datos completos de libros (32 libros)
const librosData = [
  { id: 1, titulo: "Cien años de soledad", isbn: "9780307474728", anio: 1967, descripcion: "Novela cumbre del realismo mágico sobre la saga de la familia Buendía en Macondo.", stock: 5, autor: "Gabriel García Márquez", categoria: "Literatura", portada: "img/portadas/libro1.svg" },
  { id: 2, titulo: "Don Quijote de la Mancha", isbn: "9788420412146", anio: 1605, descripcion: "Obra maestra de la literatura universal que narra las andanzas del ingenioso hidalgo.", stock: 2, autor: "Miguel de Cervantes", categoria: "Literatura", portada: "img/portadas/libro2.svg" },
  { id: 3, titulo: "El Principito", isbn: "9780156012195", anio: 1943, descripcion: "Obra poética y filosófica sobre el sentido del amor, la amistad y la naturaleza humana.", stock: 8, autor: "Antoine de Saint-Exupéry", categoria: "Literatura", portada: "img/portadas/libro3.svg" },
  { id: 4, titulo: "Clean Code: Manual de desarrollo ágil de software", isbn: "9780132350884", anio: 2008, descripcion: "Principios, patrones y mejores prácticas para escribir código limpio, legible y robusto.", stock: 4, autor: "Robert C. Martin", categoria: "Programación & Software", portada: "img/portadas/libro4.svg" },
  { id: 5, titulo: "The Pragmatic Programmer", isbn: "9780135957059", anio: 1999, descripcion: "Guía de maestría profesional para desarrolladores de software modernos y eficientes.", stock: 3, autor: "Andrew Hunt & David Thomas", categoria: "Programación & Software", portada: "img/portadas/libro5.svg" },
  { id: 6, titulo: "Design Patterns: Elements of Reusable Object-Oriented Software", isbn: "9780201633610", anio: 1994, descripcion: "El catálogo fundamental de 23 patrones de diseño orientados a objetos de la Gang of Four.", stock: 1, autor: "Erich Gamma et al. (GoF)", categoria: "Programación & Software", portada: "img/portadas/libro6.svg" },
  { id: 7, titulo: "Refactoring: Improving the Design of Existing Code", isbn: "9780134757599", anio: 1999, descripcion: "Técnicas comprobadas para reestructurar código existente sin cambiar su comportamiento.", stock: 0, autor: "Martin Fowler", categoria: "Programación & Software", portada: "img/portadas/libro7.svg" },
  { id: 8, titulo: "Introduction to Algorithms (CLRS)", isbn: "9780262033848", anio: 2009, descripcion: "La biblia académica de los algoritmos y estructuras de datos para ciencias de la computación.", stock: 6, autor: "Thomas H. Cormen", categoria: "Programación & Software", portada: "img/portadas/libro8.svg" },
  { id: 9, titulo: "Breve historia del tiempo", isbn: "9788497593724", anio: 1988, descripcion: "Fascinante viaje por el origen del universo, agujeros negros y la física cuántica.", stock: 4, autor: "Stephen Hawking", categoria: "Ciencia & Matemáticas", portada: "img/portadas/libro9.svg" },
  { id: 10, titulo: "Cosmos", isbn: "9788408053682", anio: 1980, descripcion: "Monumental obra de divulgación científica sobre el cosmos, la ciencia y la civilización.", stock: 3, autor: "Carl Sagan", categoria: "Ciencia & Matemáticas", portada: "img/portadas/libro10.svg" },
  { id: 11, titulo: "El gen egoísta", isbn: "9788434501782", anio: 1976, descripcion: "Una visión revolucionaria de la evolución centrada en la perspectiva del gen.", stock: 2, autor: "Richard Dawkins", categoria: "Ciencia & Matemáticas", portada: "img/portadas/libro11.svg" },
  { id: 12, titulo: "Física Universitaria con Física Moderna", isbn: "9786073221900", anio: 2013, descripcion: "Texto estándar de física para estudiantes de ingeniería y ciencias exactas.", stock: 7, autor: "Francis Sears & Mark Zemansky", categoria: "Ciencia & Matemáticas", portada: "img/portadas/libro12.svg" },
  { id: 13, titulo: "Cálculo de una variable: Trascendentes tempranas", isbn: "9786075220154", anio: 2015, descripcion: "Tratado pedagógico integral sobre límites, derivadas, integrales y series.", stock: 5, autor: "James Stewart", categoria: "Ciencia & Matemáticas", portada: "img/portadas/libro13.svg" },
  { id: 14, titulo: "Inteligencia Artificial: Un Enfoque Moderno", isbn: "9788490355480", anio: 2020, descripcion: "El texto de referencia global sobre agentes inteligentes, aprendizaje profundo y robótica.", stock: 2, autor: "Stuart Russell & Peter Norvig", categoria: "Programación & Software", portada: "img/portadas/libro14.svg" },
  { id: 15, titulo: "Sapiens: De animales a dioses", isbn: "9788499926223", anio: 2014, descripcion: "Breve historia de la humanidad desde los primeros cazadores hasta la revolución biotecnológica.", stock: 6, autor: "Yuval Noah Harari", categoria: "Historia & Sociedad", portada: "img/portadas/libro15.svg" },
  { id: 16, titulo: "1984", isbn: "9788499890944", anio: 1949, descripcion: "Inmortal novela distópica sobre el Gran Hermano, la vigilancia masiva y el autoritarismo.", stock: 9, autor: "George Orwell", categoria: "Literatura", portada: "img/portadas/libro16.svg" },
  { id: 17, titulo: "Un mundo feliz", isbn: "9788497594257", anio: 1932, descripcion: "Profética sátira sobre una sociedad futurista condicionada tecnológicamente.", stock: 0, autor: "Aldous Huxley", categoria: "Literatura", portada: "img/portadas/libro17.svg" },
  { id: 18, titulo: "Crónica de una muerte anunciada", isbn: "9780307475404", anio: 1981, descripcion: "Reconstrucción casi periodística del fatídico asesinato de Santiago Nasar.", stock: 4, autor: "Gabriel García Márquez", categoria: "Literatura", portada: "img/portadas/libro18.svg" },
  { id: 19, titulo: "Rayuela", isbn: "9788466331906", anio: 1963, descripcion: "Contranovela revolucionaria de Julio Cortázar que puede leerse en múltiples órdenes.", stock: 3, autor: "Julio Cortázar", categoria: "Literatura", portada: "img/portadas/libro19.svg" },
  { id: 20, titulo: "Ficciones", isbn: "9788420658742", anio: 1944, descripcion: "Colección de cuentos laberínticos sobre espejos, bibliotecas infinitas y paradojas.", stock: 5, autor: "Jorge Luis Borges", categoria: "Literatura", portada: "img/portadas/libro20.svg" },
  { id: 21, titulo: "Hábitos Atómicos", isbn: "9788416883271", anio: 2018, descripcion: "Método comprobado para crear buenos hábitos y romper los malos mediante pequeños cambios.", stock: 10, autor: "James Clear", categoria: "Psicología & Desarrollo", portada: "img/portadas/libro21.svg" },
  { id: 22, titulo: "El hombre en busca de sentido", isbn: "9788425432026", anio: 1946, descripcion: "Sobrecogedor testimonio de Viktor Frankl en campos de concentración y base de la logoterapia.", stock: 4, autor: "Viktor Frankl", categoria: "Psicología & Desarrollo", portada: "img/portadas/libro22.svg" },
  { id: 23, titulo: "Pensar rápido, pensar despacio", isbn: "9788499922072", anio: 2011, descripcion: "Análisis magistral de los dos sistemas que dirigen nuestra mente y toma de decisiones.", stock: 2, autor: "Daniel Kahneman", categoria: "Psicología & Desarrollo", portada: "img/portadas/libro23.svg" },
  { id: 24, titulo: "El arte de la guerra", isbn: "9788497940733", anio: -500, descripcion: "Tratado milenario de estrategia, liderazgo, resolución de conflictos y táctica militar.", stock: 6, autor: "Sun Tzu", categoria: "Filosofía & Estrategia", portada: "img/portadas/libro24.svg" },
  { id: 25, titulo: "Meditaciones", isbn: "9788424939106", anio: 180, descripcion: "Reflexiones íntimas del emperador filósofo Marco Aurelio sobre el deber y la resiliencia.", stock: 3, autor: "Marco Aurelio", categoria: "Filosofía & Estrategia", portada: "img/portadas/libro25.svg" },
  { id: 26, titulo: "Clean Architecture: Guía para el especialista en software", isbn: "9780134494166", anio: 2017, descripcion: "Reglas universales de arquitectura de software para crear sistemas desacoplados y testeables.", stock: 0, autor: "Robert C. Martin", categoria: "Programación & Software", portada: "img/portadas/libro26.svg" },
  { id: 27, titulo: "Head First Java: Aprende Java con programación orientada a objetos", isbn: "9781491910771", anio: 2022, descripcion: "Método multisensorial y visual para dominar Java, POO, hilos y programación concurrente.", stock: 5, autor: "Kathy Sierra & Bert Bates", categoria: "Programación & Software", portada: "img/portadas/libro27.svg" },
  { id: 28, titulo: "Fundamentos de Sistemas de Bases de Datos", isbn: "9786071514066", anio: 2019, descripcion: "Conceptos esenciales del modelo relacional, SQL, normalización, índices y transacciones ACID.", stock: 4, autor: "Abraham Silberschatz & Henry Korth", categoria: "Programación & Software", portada: "img/portadas/libro28.svg" },
  { id: 29, titulo: "Redes de Computadoras", isbn: "9786073208178", anio: 2011, descripcion: "Tratado clásico de arquitectura de redes, capa de transporte, protocolos TCP/IP e Internet.", stock: 3, autor: "Andrew S. Tanenbaum", categoria: "Programación & Software", portada: "img/portadas/libro29.svg" },
  { id: 30, titulo: "El nombre de la rosa", isbn: "9788497592581", anio: 1980, descripcion: "Fascinante novela histórica de intriga monástica, herejías y manuscritos prohibidos.", stock: 2, autor: "Umberto Eco", categoria: "Literatura", portada: "img/portadas/libro30.svg" },
  { id: 31, titulo: "La metamorfosis", isbn: "9788491050292", anio: 1915, descripcion: "Relato existencial sobre la soledad y alienación a través de la transformación de Gregor Samsa.", stock: 7, autor: "Franz Kafka", categoria: "Literatura", portada: "img/portadas/libro31.svg" },
  { id: 32, titulo: "Ensayo sobre la ceguera", isbn: "9788490628720", anio: 1995, descripcion: "Parábola conmovedora sobre la condición humana y la solidaridad, pionera en inclusión y empatía.", stock: 4, autor: "José Saramago", categoria: "Literatura", portada: "img/portadas/libro32.svg" }
];

const autoresData = [
  { id: 1, nombre: "Gabriel García Márquez", nacionalidad: "Colombiana" },
  { id: 2, nombre: "Miguel de Cervantes", nacionalidad: "Española" },
  { id: 3, nombre: "Antoine de Saint-Exupéry", nacionalidad: "Francesa" },
  { id: 4, nombre: "Robert C. Martin", nacionalidad: "Estadounidense" },
  { id: 5, nombre: "Andrew Hunt & David Thomas", nacionalidad: "Estadounidense" },
  { id: 6, nombre: "Erich Gamma et al. (GoF)", nacionalidad: "Suiza / Internacional" },
  { id: 7, nombre: "Martin Fowler", nacionalidad: "Británica" },
  { id: 8, nombre: "Thomas H. Cormen", nacionalidad: "Estadounidense" },
  { id: 9, nombre: "Stephen Hawking", nacionalidad: "Británica" },
  { id: 10, nombre: "Carl Sagan", nacionalidad: "Estadounidense" },
  { id: 11, nombre: "Richard Dawkins", nacionalidad: "Británica" },
  { id: 12, nombre: "Francis Sears & Mark Zemansky", nacionalidad: "Estadounidense" },
  { id: 13, nombre: "James Stewart", nacionalidad: "Canadiense" },
  { id: 14, nombre: "Stuart Russell & Peter Norvig", nacionalidad: "Estadounidense" },
  { id: 15, nombre: "Yuval Noah Harari", nacionalidad: "Israelí" },
  { id: 16, nombre: "George Orwell", nacionalidad: "Británica" },
  { id: 17, nombre: "Aldous Huxley", nacionalidad: "Británica" },
  { id: 18, nombre: "Julio Cortázar", nacionalidad: "Argentina" },
  { id: 19, nombre: "Jorge Luis Borges", nacionalidad: "Argentina" },
  { id: 20, nombre: "James Clear", nacionalidad: "Estadounidense" },
  { id: 21, nombre: "Viktor Frankl", nacionalidad: "Austríaca" },
  { id: 22, nombre: "Daniel Kahneman", nacionalidad: "Israelí / Estadounidense" },
  { id: 23, nombre: "Sun Tzu", nacionalidad: "China" },
  { id: 24, nombre: "Marco Aurelio", nacionalidad: "Romana" },
  { id: 25, nombre: "Kathy Sierra & Bert Bates", nacionalidad: "Estadounidense" },
  { id: 26, nombre: "Abraham Silberschatz & Henry Korth", nacionalidad: "Estadounidense" },
  { id: 27, nombre: "Andrew S. Tanenbaum", nacionalidad: "Estadounidense" },
  { id: 28, nombre: "Umberto Eco", nacionalidad: "Italiana" },
  { id: 29, nombre: "Franz Kafka", nacionalidad: "Checa" },
  { id: 30, nombre: "José Saramago", nacionalidad: "Portuguesa" }
];

const categoriasData = [
  { id: 1, nombre: "Literatura", descripcion: "Obras de ficción, novelas universales y poesía clásica." },
  { id: 2, nombre: "Programación & Software", descripcion: "Ingeniería, patrones de diseño, arquitectura y lenguajes." },
  { id: 3, nombre: "Ciencia & Matemáticas", descripcion: "Física, cálculo, biología, astronomía y método científico." },
  { id: 4, nombre: "Historia & Sociedad", descripcion: "Evolución histórica, antropología y civilizaciones." },
  { id: 5, nombre: "Psicología & Desarrollo", descripcion: "Ciencia cognitiva, formación de hábitos y liderazgo." },
  { id: 6, nombre: "Filosofía & Estrategia", descripcion: "Pensamiento crítico, estoicismo y tratados clásicos." }
];

// Helper para escapar HTML
function escapeHtml(str) {
  if (!str) return '';
  return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}

// Leer a11y-panel.jsp para incluirlo
const a11yPanelRaw = fs.readFileSync(path.join(webappDir, 'a11y-panel.jsp'), 'utf8');
const a11yPanelClean = a11yPanelRaw.replace(/<%@page[^>]*%>/g, '');

// Reemplazos globales de URLs (servlets y jsps a html)
function replaceUrls(content) {
  return content
    .replace(/CatalogoServlet/g, 'catalogo.html')
    .replace(/InnovacionServlet/g, 'innovacion.html')
    .replace(/MisPrestamosServlet/g, 'misPrestamos.html')
    .replace(/DonacionServlet/g, 'donar.html')
    .replace(/DonacionesServlet/g, 'donaciones.html')
    .replace(/LibroServlet/g, 'libros.html')
    .replace(/AutorServlet/g, 'autores.html')
    .replace(/CategoriaServlet/g, 'categorias.html')
    .replace(/PrestamoServlet/g, 'prestamos.html')
    .replace(/ReportesServlet/g, 'reportes.html')
    .replace(/SancionesServlet/g, 'sanciones.html')
    .replace(/UsuarioServlet/g, 'usuarios.html')
    .replace(/LoginServlet/g, 'login.html')
    .replace(/RegistroServlet/g, 'registro.html')
    .replace(/LogoutServlet/g, 'login.html')
    .replace(/DetalleLibroServlet\?id=/g, 'detalleLibro.html?id=')
    .replace(/DetalleLibroServlet/g, 'detalleLibro.html')
    .replace(/index\.jsp/g, 'index.html')
    .replace(/catalogo\.jsp/g, 'catalogo.html')
    .replace(/innovacion\.jsp/g, 'innovacion.html')
    .replace(/donar\.jsp/g, 'donar.html')
    .replace(/login\.jsp/g, 'login.html')
    .replace(/registro\.jsp/g, 'registro.html')
    .replace(/detalleLibro\.jsp\?id=/g, 'detalleLibro.html?id=')
    .replace(/detalleLibro\.jsp/g, 'detalleLibro.html')
    .replace(/misPrestamos\.jsp/g, 'misPrestamos.html')
    .replace(/dashboard\.jsp/g, 'dashboard.html')
    .replace(/libros\.jsp/g, 'libros.html')
    .replace(/autores\.jsp/g, 'autores.html')
    .replace(/categorias\.jsp/g, 'categorias.html')
    .replace(/prestamos\.jsp/g, 'prestamos.html')
    .replace(/donaciones\.jsp/g, 'donaciones.html')
    .replace(/reportes\.jsp/g, 'reportes.html')
    .replace(/sanciones\.jsp/g, 'sanciones.html')
    .replace(/usuarios\.jsp/g, 'usuarios.html')
    .replace(/usuario\.jsp/g, 'usuario.html');
}

// -------------------------------------------------------------
// 1. GENERAR INDEX.HTML
// -------------------------------------------------------------
function generateIndex() {
  let content = fs.readFileSync(path.join(webappDir, 'index.jsp'), 'utf8');
  content = content.replace(/<%@page[^>]*%>/g, '');
  content = content.replace(/<%@include file="a11y-panel\.jsp"%>/g, a11yPanelClean);
  
  // Reemplazar bloque de sesión por la opción estándar de lector / login
  content = content.replace(/<%\s*if\s*\(usuarioSesion\s*!=\s*null\)\s*\{[\s\S]*?<%[\s\S]*?\}\s*else\s*\{[\s\S]*?%>([\s\S]*?)<%\s*\}\s*%>/, '$1');
  content = content.replace(/<%[\s\S]*?%>/g, '');
  content = content.replace(/<%=[\s\S]*?%>/g, '');
  
  content = replaceUrls(content);
  fs.writeFileSync(path.join(outDir, 'index.html'), content, 'utf8');
  console.log('✓ index.html generado con éxito');
}

// -------------------------------------------------------------
// 2. GENERAR CATALOGO.HTML
// -------------------------------------------------------------
function generateCatalogo() {
  let content = fs.readFileSync(path.join(webappDir, 'catalogo.jsp'), 'utf8');
  content = content.replace(/<%@page[^>]*%>/g, '');
  content = content.replace(/<%@include file="a11y-panel\.jsp"%>/g, a11yPanelClean);

  // Reemplazar sidebar info de sesión por demo
  content = content.replace(/<%\s*if\s*\(usuarioSesion\s*!=\s*null\)\s*\{[\s\S]*?<%[\s\S]*?\}\s*%>/, `
    <div class="p-3 mb-3 rounded-3 bg-secondary bg-opacity-25 border border-secondary border-opacity-25">
        <div class="d-flex align-items-center gap-2">
            <i class="bi bi-person-circle fs-3 text-info"></i>
            <div class="overflow-hidden">
                <div class="fw-semibold text-white text-truncate">Lector Invitado</div>
                <span class="badge bg-primary" style="font-size: 0.68rem;">LECTOR</span>
            </div>
        </div>
    </div>
  `);

  content = content.replace(/<%\s*if\s*\(usuarioSesion\s*!=\s*null\)\s*\{[\s\S]*?<%[\s\S]*?\}\s*else\s*\{[\s\S]*?%>([\s\S]*?)<%\s*\}\s*%>/, '$1');

  // Reemplazar el loop JSP por las 32 tarjetas de libros
  const bookCardsHtml = librosData.map(l => {
    const tituloEsc = escapeHtml(l.titulo);
    const autorEsc = escapeHtml(l.autor);
    const catEsc = escapeHtml(l.categoria);
    const descEsc = escapeHtml(l.descripcion);
    const stockBadge = l.stock > 0 
      ? `<span class="badge bg-success stock-floating-badge shadow-sm">Disponible (${l.stock})</span>`
      : `<span class="badge bg-secondary stock-floating-badge shadow-sm">Agotado</span>`;

    return `
      <div class="col-md-4 libro-item" data-stock="${l.stock}" data-categoria="${catEsc.toLowerCase()}">
          <div class="card book-card h-100 shadow-sm">
              <div class="book-cover-wrapper">
                  ${stockBadge}
                  <a href="detalleLibro.html?id=${l.id}" class="cover-link" title="Ver ficha de ${tituloEsc}">
                      <img src="${l.portada}" alt="Portada de ${tituloEsc}" class="book-cover-img" onerror="this.onerror=null;this.src='img/portadas/default.svg';">
                  </a>
                  <button type="button" class="btn btn-sm quick-view-btn shadow-sm"
                          data-id="${l.id}"
                          data-titulo="${tituloEsc}"
                          data-autor="${autorEsc}"
                          data-categoria="${catEsc}"
                          data-isbn="${l.isbn}"
                          data-anio="${l.anio}"
                          data-stock="${l.stock}"
                          data-descripcion="${descEsc}"
                          data-portada="${l.portada}"
                          onclick="abrirVistaRapida(this)">
                      Vista rápida
                  </button>
              </div>
              <div class="card-body d-flex flex-column p-3">
                  <div class="d-flex justify-content-between align-items-center mb-2">
                      <span class="badge bg-light text-dark border">${catEsc}</span>
                      <span class="text-muted small">${l.anio}</span>
                  </div>
                  <h6 class="card-title fw-bold mb-1">${tituloEsc}</h6>
                  <p class="text-muted small mb-1">${autorEsc}</p>
                  <p class="card-text text-secondary small mb-3 flex-grow-1" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                      ${descEsc}
                  </p>
                  <div class="d-flex gap-2 align-items-center mt-auto">
                      <a href="detalleLibro.html?id=${l.id}" class="btn btn-outline-primary btn-sm flex-grow-1">
                          <i class="bi bi-eye"></i> Ver detalles
                      </a>
                      <button type="button" class="btn-audio-detailed" onclick="reproducirAudio('${tituloEsc.replace(/'/g, "\\'")}. De ${autorEsc.replace(/'/g, "\\'")}. ${descEsc.replace(/'/g, "\\'")}')">
                          <i class="bi bi-volume-up-fill"></i> <span>Audio</span>
                      </button>
                  </div>
              </div>
          </div>
      </div>
    `;
  }).join('\n');

  content = content.replace(/<div class="row g-4" id="listaLibros">[\s\S]*?<\/div>\s*<\/div>\s*<\/div>/, `
    <div class="row g-4" id="listaLibros">
      ${bookCardsHtml}
    </div>
  </div></div>`);

  content = content.replace(/<%=[\s\S]*?%>/g, '');
  content = content.replace(/<%[\s\S]*?%>/g, '');

  // Script interactivo de filtrado y búsqueda
  const filterScript = `
  <script>
    function aplicarFiltrosInteractivos() {
        const busqueda = (document.getElementById('busquedaLibro') ? document.getElementById('busquedaLibro').value : '').toLowerCase().trim();
        const categoriaSel = (document.getElementById('filtroCategoria') ? document.getElementById('filtroCategoria').value : '').toLowerCase().trim();
        const soloDisp = document.getElementById('soloDisponibles') ? document.getElementById('soloDisponibles').checked : false;

        const items = document.querySelectorAll('.libro-item');
        let contador = 0;

        items.forEach(item => {
            const stock = parseInt(item.getAttribute('data-stock') || '0');
            const cat = (item.getAttribute('data-categoria') || '').toLowerCase();
            const cardText = item.innerText.toLowerCase();

            let coincide = true;
            if (busqueda && !cardText.includes(busqueda)) coincide = false;
            if (categoriaSel && categoriaSel !== 'todas' && !cat.includes(categoriaSel)) coincide = false;
            if (soloDisp && stock <= 0) coincide = false;

            if (coincide) {
                item.style.display = '';
                contador++;
            } else {
                item.style.display = 'none';
            }
        });

        const badgeTotal = document.getElementById('contadorLibrosBadge');
        if (badgeTotal) badgeTotal.textContent = contador + ' libros';
    }

    function filtrarPorChip(cat, btn) {
        document.querySelectorAll('.chip-filtro').forEach(b => {
            b.classList.remove('btn-primary', 'active');
            b.classList.add('btn-outline-secondary');
        });
        btn.classList.remove('btn-outline-secondary');
        btn.classList.add('btn-primary', 'active');

        const select = document.getElementById('filtroCategoria');
        if (select) {
            select.value = cat;
        }
        aplicarFiltrosInteractivos();
    }

    document.addEventListener('DOMContentLoaded', () => {
        const inputBusqueda = document.getElementById('busquedaLibro');
        if (inputBusqueda) {
            inputBusqueda.addEventListener('input', aplicarFiltrosInteractivos);
        }
        const selectCat = document.getElementById('filtroCategoria');
        if (selectCat) {
            selectCat.addEventListener('change', aplicarFiltrosInteractivos);
        }
        aplicarFiltrosInteractivos();
    });
  </script>
  `;

  content = content.replace('</body>', filterScript + '</body>');
  content = replaceUrls(content);
  fs.writeFileSync(path.join(outDir, 'catalogo.html'), content, 'utf8');
  console.log('✓ catalogo.html generado con 32 libros');
}

// -------------------------------------------------------------
// 3. GENERAR DETALLELIBRO.HTML
// -------------------------------------------------------------
function generateDetalleLibro() {
  let content = fs.readFileSync(path.join(webappDir, 'detalleLibro.jsp'), 'utf8');
  content = content.replace(/<%@page[^>]*%>/g, '');
  content = content.replace(/<%@include file="a11y-panel\.jsp"%>/g, a11yPanelClean);

  const dynamicScript = `
  <script>
    const librosData = ${JSON.stringify(librosData)};

    document.addEventListener('DOMContentLoaded', () => {
        const urlParams = new URLSearchParams(window.location.search);
        const bookId = parseInt(urlParams.get('id')) || 1;
        const libro = librosData.find(l => l.id === bookId) || librosData[0];

        document.title = libro.titulo + " - BookHub";
        
        // Elementos a poblar
        const titleElements = document.querySelectorAll('h1, h2');
        titleElements.forEach(el => {
            if (el.classList.contains('fw-bold') && !el.closest('.modal') && !el.closest('.offcanvas')) {
                el.textContent = libro.titulo;
            }
        });

        const coverImg = document.querySelector('.detalle-portada-box img') || document.querySelector('.book-cover-img');
        if (coverImg) {
            coverImg.src = libro.portada;
            coverImg.alt = "Portada de " + libro.titulo;
        }

        const labels = document.querySelectorAll('li, p, div, span');
        labels.forEach(el => {
            if (el.textContent.includes('Autor:')) {
                el.innerHTML = '<strong>Autor:</strong> ' + libro.autor;
            } else if (el.textContent.includes('Categoría:')) {
                el.innerHTML = '<strong>Categoría:</strong> <span class="badge bg-info text-dark">' + libro.categoria + '</span>';
            } else if (el.textContent.includes('Año:') || el.textContent.includes('Publicación:')) {
                el.innerHTML = '<strong>Año de Publicación:</strong> ' + libro.anio;
            } else if (el.textContent.includes('ISBN:')) {
                el.innerHTML = '<strong>ISBN:</strong> ' + libro.isbn;
            } else if (el.textContent.includes('Stock disponible:') || el.textContent.includes('Disponibilidad:')) {
                el.innerHTML = '<strong>Disponibilidad:</strong> ' + (libro.stock > 0 
                    ? '<span class="badge bg-success">Disponible (' + libro.stock + ' ejemplares)</span>'
                    : '<span class="badge bg-danger">Agotado</span>');
            }
        });

        // Resumen / descripción
        const descParagraph = document.querySelector('.lead') || document.querySelector('.book-description');
        if (descParagraph) {
            descParagraph.textContent = libro.descripcion;
        }

        // Configurar botones de audio
        const btnAudios = document.querySelectorAll('button[onclick*="reproducirAudio"]');
        btnAudios.forEach(btn => {
            btn.onclick = () => {
                reproducirAudio(libro.titulo + ". De " + libro.autor + ". " + libro.descripcion);
            };
        });
    });
  </script>
  `;

  content = content.replace(/<%=[\s\S]*?%>/g, '');
  content = content.replace(/<%[\s\S]*?%>/g, '');
  content = content.replace('</body>', dynamicScript + '</body>');
  content = replaceUrls(content);
  fs.writeFileSync(path.join(outDir, 'detalleLibro.html'), content, 'utf8');
  console.log('✓ detalleLibro.html generado con éxito');
}

// -------------------------------------------------------------
// 4. GENERAR INNOVACION.HTML
// -------------------------------------------------------------
function generateInnovacion() {
  let content = fs.readFileSync(path.join(webappDir, 'innovacion.jsp'), 'utf8');
  content = content.replace(/<%@page[^>]*%>/g, '');
  content = content.replace(/<%@include file="a11y-panel\.jsp"%>/g, a11yPanelClean);
  content = content.replace(/<%\s*if\s*\(usuarioSesion\s*!=\s*null\)\s*\{[\s\S]*?<%[\s\S]*?\}\s*else\s*\{[\s\S]*?%>([\s\S]*?)<%\s*\}\s*%>/, '$1');
  content = content.replace(/<%[\s\S]*?%>/g, '');
  content = content.replace(/<%=[\s\S]*?%>/g, '');

  content = replaceUrls(content);
  fs.writeFileSync(path.join(outDir, 'innovacion.html'), content, 'utf8');
  console.log('✓ innovacion.html generado con éxito');
}

// -------------------------------------------------------------
// 5. GENERAR DONAR.HTML
// -------------------------------------------------------------
function generateDonar() {
  let content = fs.readFileSync(path.join(webappDir, 'donar.jsp'), 'utf8');
  content = content.replace(/<%@page[^>]*%>/g, '');
  content = content.replace(/<%@include file="a11y-panel\.jsp"%>/g, a11yPanelClean);
  content = content.replace(/<%[\s\S]*?%>/g, '');
  content = content.replace(/<%=[\s\S]*?%>/g, '');

  const scriptDonar = `
  <script>
    document.addEventListener('DOMContentLoaded', () => {
        const form = document.querySelector('form');
        if (form) {
            form.onsubmit = (e) => {
                e.preventDefault();
                alert("¡Muchas gracias por tu donación a BookHub! Tu registro ha sido procesado.");
                form.reset();
            };
        }
    });
  </script>
  `;
  content = content.replace('</body>', scriptDonar + '</body>');
  content = replaceUrls(content);
  fs.writeFileSync(path.join(outDir, 'donar.html'), content, 'utf8');
  console.log('✓ donar.html generado con éxito');
}

// -------------------------------------------------------------
// 6. GENERAR LOGIN.HTML Y REGISTRO.HTML
// -------------------------------------------------------------
function generateAuth() {
  // LOGIN
  let loginContent = fs.readFileSync(path.join(webappDir, 'login.jsp'), 'utf8');
  loginContent = loginContent.replace(/<%@page[^>]*%>/g, '');
  loginContent = loginContent.replace(/<%@include file="a11y-panel\.jsp"%>/g, a11yPanelClean);
  loginContent = loginContent.replace(/<%[\s\S]*?%>/g, '');
  loginContent = loginContent.replace(/<%=[\s\S]*?%>/g, '');

  const loginScript = `
  <script>
    function autocompletar(correo, pass) {
        const elCorreo = document.getElementById('correo') || document.querySelector('input[type="email"]');
        const elPass = document.getElementById('password') || document.querySelector('input[type="password"]');
        if (elCorreo) elCorreo.value = correo;
        if (elPass) elPass.value = pass;
    }

    document.addEventListener('DOMContentLoaded', () => {
        const form = document.querySelector('form');
        if (form) {
            form.onsubmit = (e) => {
                e.preventDefault();
                const elCorreo = document.getElementById('correo') || document.querySelector('input[type="email"]');
                const correo = elCorreo ? elCorreo.value.trim() : '';
                if (correo.includes('admin')) {
                    localStorage.setItem('bookhub_user', JSON.stringify({ nombre: 'Administrador', rol: 'ADMIN' }));
                    window.location.href = 'dashboard.html';
                } else {
                    localStorage.setItem('bookhub_user', JSON.stringify({ nombre: 'Juan Pérez (Lector)', rol: 'USUARIO' }));
                    window.location.href = 'catalogo.html';
                }
            };
        }
    });
  </script>
  `;
  loginContent = loginContent.replace('</body>', loginScript + '</body>');
  loginContent = replaceUrls(loginContent);
  fs.writeFileSync(path.join(outDir, 'login.html'), loginContent, 'utf8');
  console.log('✓ login.html generado con éxito');

  // REGISTRO
  let regContent = fs.readFileSync(path.join(webappDir, 'registro.jsp'), 'utf8');
  regContent = regContent.replace(/<%@page[^>]*%>/g, '');
  regContent = regContent.replace(/<%@include file="a11y-panel\.jsp"%>/g, a11yPanelClean);
  regContent = regContent.replace(/<%[\s\S]*?%>/g, '');
  regContent = regContent.replace(/<%=[\s\S]*?%>/g, '');

  const regScript = `
  <script>
    document.addEventListener('DOMContentLoaded', () => {
        const form = document.querySelector('form');
        if (form) {
            form.onsubmit = (e) => {
                e.preventDefault();
                alert("¡Cuenta de lector creada con éxito! Ahora puedes iniciar sesión.");
                window.location.href = 'login.html';
            };
        }
    });
  </script>
  `;
  regContent = regContent.replace('</body>', regScript + '</body>');
  regContent = replaceUrls(regContent);
  fs.writeFileSync(path.join(outDir, 'registro.html'), regContent, 'utf8');
  console.log('✓ registro.html generado con éxito');
}

// -------------------------------------------------------------
// 7. GENERAR MISPRESTAMOS.HTML
// -------------------------------------------------------------
function generateMisPrestamos() {
  let content = fs.readFileSync(path.join(webappDir, 'misPrestamos.jsp'), 'utf8');
  content = content.replace(/<%@page[^>]*%>/g, '');
  content = content.replace(/<%@include file="a11y-panel\.jsp"%>/g, a11yPanelClean);
  content = content.replace(/<%[\s\S]*?%>/g, '');
  content = content.replace(/<%=[\s\S]*?%>/g, '');

  const tableHtml = `
    <div class="table-responsive">
        <table class="table table-hover align-middle">
            <thead class="table-light">
                <tr>
                    <th>Libro</th>
                    <th>Fecha Préstamo</th>
                    <th>Fecha Devolución</th>
                    <th>Estado</th>
                    <th class="text-end">Acciones</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>
                        <div class="d-flex align-items-center gap-2">
                            <img src="img/portadas/libro1.svg" width="36" height="50" style="object-fit:cover;border-radius:4px;">
                            <div>
                                <strong>Cien años de soledad</strong>
                                <div class="text-muted small">Gabriel García Márquez</div>
                            </div>
                        </div>
                    </td>
                    <td>23/09/2026</td>
                    <td>30/11/2026</td>
                    <td><span class="badge bg-warning text-dark">PRESTADO</span></td>
                    <td class="text-end">
                        <button class="btn btn-sm btn-outline-primary" onclick="alert('Plazo renovado por 7 días más.')">Renovar plazo</button>
                        <button class="btn btn-sm btn-outline-success" onclick="alert('Devolución registrada. Presenta el ejemplar en el mostrador.')">Devolver</button>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="d-flex align-items-center gap-2">
                            <img src="img/portadas/libro7.svg" width="36" height="50" style="object-fit:cover;border-radius:4px;">
                            <div>
                                <strong>Refactoring: Improving the Design of Existing Code</strong>
                                <div class="text-muted small">Martin Fowler</div>
                            </div>
                        </div>
                    </td>
                    <td>01/11/2026</td>
                    <td>08/12/2026</td>
                    <td><span class="badge bg-warning text-dark">PRESTADO</span></td>
                    <td class="text-end">
                        <button class="btn btn-sm btn-outline-primary" onclick="alert('Plazo renovado por 7 días más.')">Renovar plazo</button>
                        <button class="btn btn-sm btn-outline-success" onclick="alert('Devolución registrada.')">Devolver</button>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="d-flex align-items-center gap-2">
                            <img src="img/portadas/libro2.svg" width="36" height="50" style="object-fit:cover;border-radius:4px;">
                            <div>
                                <strong>Don Quijote de la Mancha</strong>
                                <div class="text-muted small">Miguel de Cervantes</div>
                            </div>
                        </div>
                    </td>
                    <td>22/09/2026</td>
                    <td>29/09/2026</td>
                    <td><span class="badge bg-success">DEVUELTO</span></td>
                    <td class="text-end text-muted small">Entregado a tiempo</td>
                </tr>
            </tbody>
        </table>
    </div>
  `;

  content = content.replace(/<div class="card-body">[\s\S]*?<\/div>\s*<\/div>/, `<div class="card-body">${tableHtml}</div></div>`);
  content = replaceUrls(content);
  fs.writeFileSync(path.join(outDir, 'misPrestamos.html'), content, 'utf8');
  console.log('✓ misPrestamos.html generado con éxito');
}

// -------------------------------------------------------------
// 8. GENERAR DASHBOARD Y VISTAS ADMIN
// -------------------------------------------------------------
function generateAdminPages() {
  const adminFiles = [
    'dashboard.jsp',
    'libros.jsp',
    'autores.jsp',
    'categorias.jsp',
    'prestamos.jsp',
    'donaciones.jsp',
    'reportes.jsp',
    'sanciones.jsp',
    'usuarios.jsp',
    'usuario.jsp'
  ];

  adminFiles.forEach(file => {
    const srcPath = path.join(webappDir, file);
    if (!fs.existsSync(srcPath)) return;
    let content = fs.readFileSync(srcPath, 'utf8');
    content = content.replace(/<%@page[^>]*%>/g, '');
    content = content.replace(/<%@include file="a11y-panel\.jsp"%>/g, a11yPanelClean);

    // Si es libros.jsp, podemos inyectar las filas de libros si hay tabla
    if (file === 'libros.jsp') {
      const rows = librosData.map(l => `
        <tr>
            <td>${l.id}</td>
            <td>
                <img src="${l.portada}" width="28" height="38" class="me-2" style="object-fit:cover;border-radius:3px;">
                <strong>${escapeHtml(l.titulo)}</strong>
            </td>
            <td>${escapeHtml(l.autor)}</td>
            <td><span class="badge bg-light text-dark border">${escapeHtml(l.categoria)}</span></td>
            <td><code>${l.isbn}</code></td>
            <td>${l.anio}</td>
            <td><span class="badge ${l.stock > 0 ? 'bg-success' : 'bg-danger'}">${l.stock}</span></td>
            <td>
                <button class="btn btn-sm btn-outline-warning" onclick="alert('Editar libro: ${escapeHtml(l.titulo)}')"><i class="bi bi-pencil"></i></button>
                <button class="btn btn-sm btn-outline-danger" onclick="alert('Acción de eliminación protegida en demostración.')"><i class="bi bi-trash"></i></button>
            </td>
        </tr>
      `).join('\n');
      content = content.replace(/<tbody>[\s\S]*?<\/tbody>/, `<tbody>${rows}</tbody>`);
    } else if (file === 'autores.jsp') {
      const rows = autoresData.map(a => `
        <tr>
            <td>${a.id}</td>
            <td><strong>${escapeHtml(a.nombre)}</strong></td>
            <td>${escapeHtml(a.nacionalidad)}</td>
            <td>
                <button class="btn btn-sm btn-outline-warning" onclick="alert('Editar autor: ${escapeHtml(a.nombre)}')"><i class="bi bi-pencil"></i></button>
                <button class="btn btn-sm btn-outline-danger" onclick="alert('Acción de eliminación protegida.')"><i class="bi bi-trash"></i></button>
            </td>
        </tr>
      `).join('\n');
      content = content.replace(/<tbody>[\s\S]*?<\/tbody>/, `<tbody>${rows}</tbody>`);
    } else if (file === 'categorias.jsp') {
      const rows = categoriasData.map(c => `
        <tr>
            <td>${c.id}</td>
            <td><strong>${escapeHtml(c.nombre)}</strong></td>
            <td>${escapeHtml(c.descripcion)}</td>
            <td>
                <button class="btn btn-sm btn-outline-warning" onclick="alert('Editar categoría: ${escapeHtml(c.nombre)}')"><i class="bi bi-pencil"></i></button>
                <button class="btn btn-sm btn-outline-danger" onclick="alert('Acción de eliminación protegida.')"><i class="bi bi-trash"></i></button>
            </td>
        </tr>
      `).join('\n');
      content = content.replace(/<tbody>[\s\S]*?<\/tbody>/, `<tbody>${rows}</tbody>`);
    }

    content = content.replace(/<%[\s\S]*?%>/g, '');
    content = content.replace(/<%=[\s\S]*?%>/g, '');

    content = replaceUrls(content);
    const outFile = file.replace('.jsp', '.html');
    fs.writeFileSync(path.join(outDir, outFile), content, 'utf8');
    console.log(`✓ ${outFile} generado con éxito`);
  });
}

// -------------------------------------------------------------
// 9. GENERAR 404.HTML UNIVERSAL
// -------------------------------------------------------------
function generate404() {
  const html = `<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Página no encontrada - BookHub</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script>
        // REDIRECCIONADOR AUTOMÁTICO PARA GITHUB PAGES
        (function() {
            const path = window.location.pathname;
            const search = window.location.search;
            const hash = window.location.hash;

            const map = {
                'CatalogoServlet': 'catalogo.html',
                'catalogo.jsp': 'catalogo.html',
                'InnovacionServlet': 'innovacion.html',
                'innovacion.jsp': 'innovacion.html',
                'MisPrestamosServlet': 'misPrestamos.html',
                'misPrestamos.jsp': 'misPrestamos.html',
                'donar.jsp': 'donar.html',
                'DonacionServlet': 'donar.html',
                'login.jsp': 'login.html',
                'LoginServlet': 'login.html',
                'registro.jsp': 'registro.html',
                'RegistroServlet': 'registro.html',
                'DetalleLibroServlet': 'detalleLibro.html',
                'detalleLibro.jsp': 'detalleLibro.html',
                'dashboard.jsp': 'dashboard.html',
                'libros.jsp': 'libros.html',
                'LibroServlet': 'libros.html',
                'autores.jsp': 'autores.html',
                'AutorServlet': 'autores.html',
                'categorias.jsp': 'categorias.html',
                'CategoriaServlet': 'categorias.html',
                'prestamos.jsp': 'prestamos.html',
                'PrestamoServlet': 'prestamos.html',
                'donaciones.jsp': 'donaciones.html',
                'DonacionesServlet': 'donaciones.html',
                'reportes.jsp': 'reportes.html',
                'ReportesServlet': 'reportes.html',
                'sanciones.jsp': 'sanciones.html',
                'SancionesServlet': 'sanciones.html',
                'usuarios.jsp': 'usuarios.html',
                'UsuarioServlet': 'usuarios.html',
                'usuario.jsp': 'usuario.html',
                'LogoutServlet': 'login.html',
                'index.jsp': 'index.html'
            };

            for (const [key, dest] of Object.entries(map)) {
                if (path.endsWith(key) || path.includes('/' + key)) {
                    window.location.replace(dest + search + hash);
                    return;
                }
            }
        })();
    </script>
    <style>
        body {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            min-height: 100vh;
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .error-card {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 16px;
            padding: 40px;
            max-width: 540px;
            text-align: center;
            backdrop-filter: blur(10px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
        }
    </style>
</head>
<body>
    <div class="error-card">
        <div class="display-1 text-warning mb-3">📚 404</div>
        <h2 class="fw-bold mb-2">Página no encontrada</h2>
        <p class="text-white-50 mb-4">
            El recurso bibliográfico o sección a la que intentas acceder ha cambiado o no está disponible en este servidor estático.
        </p>
        <div class="d-flex flex-wrap gap-2 justify-content-center">
            <a href="index.html" class="btn btn-primary px-4 py-2">
                <i class="bi bi-house-door-fill me-1"></i> Ir al Inicio
            </a>
            <a href="catalogo.html" class="btn btn-outline-light px-4 py-2">
                <i class="bi bi-journal-bookmark-fill me-1"></i> Ver Catálogo
            </a>
            <a href="innovacion.html" class="btn btn-outline-info px-4 py-2">
                <i class="bi bi-universal-access me-1"></i> Accesibilidad ODS 09
            </a>
        </div>
    </div>
</body>
</html>`;

  fs.writeFileSync(path.join(outDir, '404.html'), html, 'utf8');
  console.log('✓ 404.html generado con éxito');
}

// Ejecutar todos
console.log('Iniciando generación de páginas estáticas para GitHub Pages...');
generateIndex();
generateCatalogo();
generateDetalleLibro();
generateInnovacion();
generateDonar();
generateAuth();
generateMisPrestamos();
generateAdminPages();
generate404();
console.log('¡Todas las páginas estáticas fueron generadas correctamente!');
