const fs = require('fs');
const path = require('path');

const webappDir = path.join(__dirname, 'src', 'main', 'webapp');
const outDir = __dirname;

// Datos completos de los 32 libros reales de BookHub
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

function escapeHtml(str) {
  if (!str) return '';
  return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}

function escapeJs(str) {
  if (!str) return '';
  return str.replace(/'/g, "\\'").replace(/"/g, '&quot;');
}

function replaceUrls(content) {
  return content
    .replace(/href="CatalogoServlet"/g, 'href="catalogo.html"')
    .replace(/action="CatalogoServlet"/g, 'action="catalogo.html"')
    .replace(/href="InnovacionServlet"/g, 'href="innovacion.html"')
    .replace(/href="MisPrestamosServlet"/g, 'href="misPrestamos.html"')
    .replace(/href="DonacionServlet"/g, 'href="donar.html"')
    .replace(/href="DonacionesServlet"/g, 'href="donaciones.html"')
    .replace(/href="LibroServlet"/g, 'href="libros.html"')
    .replace(/href="AutorServlet"/g, 'href="autores.html"')
    .replace(/href="CategoriaServlet"/g, 'href="categorias.html"')
    .replace(/href="PrestamoServlet"/g, 'href="prestamos.html"')
    .replace(/href="ReportesServlet"/g, 'href="reportes.html"')
    .replace(/href="SancionesServlet"/g, 'href="sanciones.html"')
    .replace(/href="UsuarioServlet"/g, 'href="usuarios.html"')
    .replace(/href="LoginServlet"/g, 'href="login.html"')
    .replace(/href="RegistroServlet"/g, 'href="registro.html"')
    .replace(/action="RegistroServlet"/g, 'action="registro.html"')
    .replace(/action="LoginServlet"/g, 'action="login.html"')
    .replace(/href="LogoutServlet"/g, 'href="javascript:void(0)" onclick="cerrarSesion()"')
    .replace(/href="DetalleLibroServlet\?id=([0-9]+)"/g, 'href="detalleLibro.html?id=$1"')
    .replace(/href="DetalleLibroServlet"/g, 'href="detalleLibro.html"')
    .replace(/href="index\.jsp"/g, 'href="index.html"')
    .replace(/href="catalogo\.jsp"/g, 'href="catalogo.html"')
    .replace(/href="innovacion\.jsp"/g, 'href="innovacion.html"')
    .replace(/href="donar\.jsp"/g, 'href="donar.html"')
    .replace(/href="login\.jsp"/g, 'href="login.html"')
    .replace(/href="registro\.jsp"/g, 'href="registro.html"')
    .replace(/href="detalleLibro\.jsp\?id=([0-9]+)"/g, 'href="detalleLibro.html?id=$1"')
    .replace(/href="detalleLibro\.jsp"/g, 'href="detalleLibro.html"')
    .replace(/href="misPrestamos\.jsp"/g, 'href="misPrestamos.html"')
    .replace(/href="dashboard\.jsp"/g, 'href="dashboard.html"')
    .replace(/href="libros\.jsp"/g, 'href="libros.html"')
    .replace(/href="autores\.jsp"/g, 'href="autores.html"')
    .replace(/href="categorias\.jsp"/g, 'href="categorias.html"')
    .replace(/href="prestamos\.jsp"/g, 'href="prestamos.html"')
    .replace(/href="donaciones\.jsp"/g, 'href="donaciones.html"')
    .replace(/href="reportes\.jsp"/g, 'href="reportes.html"')
    .replace(/href="sanciones\.jsp"/g, 'href="sanciones.html"')
    .replace(/href="usuarios\.jsp"/g, 'href="usuarios.html"')
    .replace(/href="usuario\.jsp"/g, 'href="usuario.html"');
}

// Sincronizador de sesión basado en sessionStorage (por defecto: nadie ha iniciado sesión)
const scriptSincronizacionSesion = `
<script id="bookhubSessionScript">
function sincronizarSesionUI() {
    // Limpieza de datos obsoletos
    try { localStorage.removeItem('bookhub_user'); } catch(e){}

    let user = null;
    try {
        const userStr = sessionStorage.getItem('bookhub_user');
        if (userStr) user = JSON.parse(userStr);
    } catch (e) {}

    const sessionContainer = document.getElementById('navSessionContainer');
    const sideContainer = document.getElementById('sidebarUserSessionContainer');

    if (user && user.nombre) {
        // Usuario autenticado
        if (sessionContainer) {
            if (user.rol === 'ADMIN') {
                sessionContainer.innerHTML = \`
                    <a href="dashboard.html" class="btn btn-warning btn-sm d-flex align-items-center gap-1">
                        <i class="bi bi-speedometer2"></i> <span class="d-none d-sm-inline">Panel Admin</span>
                    </a>
                    <button type="button" onclick="cerrarSesion()" class="btn btn-outline-danger btn-sm d-flex align-items-center gap-1">
                        <i class="bi bi-box-arrow-left"></i> <span>Salir</span>
                    </button>
                \`;
            } else {
                sessionContainer.innerHTML = \`
                    <a href="usuario.html" class="btn btn-light btn-sm d-flex align-items-center gap-1">
                        <i class="bi bi-person-circle"></i> <span class="d-none d-sm-inline">\${user.nombre}</span>
                    </a>
                    <button type="button" onclick="cerrarSesion()" class="btn btn-outline-danger btn-sm d-flex align-items-center gap-1">
                        <i class="bi bi-box-arrow-left"></i> <span>Salir</span>
                    </button>
                \`;
            }
        }

        if (sideContainer) {
            const isAdm = user.rol === 'ADMIN';
            sideContainer.innerHTML = \`
                <div class="p-3 mb-3 rounded-3 bg-secondary bg-opacity-25 border border-secondary border-opacity-25">
                    <div class="d-flex align-items-center gap-2">
                        <i class="bi \${isAdm ? 'bi-shield-lock-fill text-danger' : 'bi-person-circle text-info'} fs-3"></i>
                        <div class="overflow-hidden">
                            <div class="fw-semibold text-white text-truncate">\${user.nombre}</div>
                            <span class="badge \${isAdm ? 'bg-danger' : 'bg-primary'}" style="font-size: 0.68rem;">\${user.rol}</span>
                        </div>
                    </div>
                </div>
            \`;
        }
    } else {
        // Invitado (sin sesión) - EXACTO al estado inicial de Apache NetBeans
        if (sessionContainer) {
            sessionContainer.innerHTML = \`
                <a href="login.html" class="btn btn-light btn-sm d-flex align-items-center gap-1">
                    <i class="bi bi-box-arrow-in-right"></i> <span>Iniciar sesión</span>
                </a>
                <a href="registro.html" class="btn btn-outline-light btn-sm d-flex align-items-center gap-1">
                    <i class="bi bi-person-plus"></i> <span>Registrarse</span>
                </a>
            \`;
        }
        if (sideContainer) {
            sideContainer.innerHTML = '';
        }
    }
}

function cerrarSesion() {
    sessionStorage.removeItem('bookhub_user');
    localStorage.removeItem('bookhub_user');
    window.location.href = 'index.html';
}

document.addEventListener('DOMContentLoaded', sincronizarSesionUI);
</script>
`;

// -------------------------------------------------------------
// 1. GENERAR INDEX.HTML (100% IDÉNTICO A APACHE INDEX.JSP)
// -------------------------------------------------------------
function generateIndex() {
  let content = fs.readFileSync(path.join(webappDir, 'index.jsp'), 'utf8');

  // Quitar directivas iniciales
  content = content.replace(/<%@page[^>]*%>/g, '');
  content = content.replace(/<%[\s\S]*?Usuario usuarioSesion =[\s\S]*?%>/, '');

  // Reemplazar caja de usuario en sidebar por contenedor vacío dinámico
  content = content.replace(/<% if \(usuarioSesion != null\) \{ %>[\s\S]*?<% \} %>\s*<!-- APARTADOS PRINCIPALES -->/, `<div id="sidebarUserSessionContainer"></div>\n                <!-- APARTADOS PRINCIPALES -->`);

  // Reemplazar navbar de sesión por el contenedor inicial exacto sin sesión
  content = content.replace(/<!-- Lado derecho: Sesión activa o Iniciar Sesión \/ Registrarse -->[\s\S]*?<!-- HERO -->/, `<!-- Lado derecho: Sesión activa o Iniciar Sesión / Registrarse -->
            <div class="d-flex align-items-center gap-2 ms-auto" id="navSessionContainer">
                <a href="login.html" class="btn btn-light btn-sm d-flex align-items-center gap-1">
                    <i class="bi bi-box-arrow-in-right"></i> <span>Iniciar sesión</span>
                </a>
                <a href="registro.html" class="btn btn-outline-light btn-sm d-flex align-items-center gap-1">
                    <i class="bi bi-person-plus"></i> <span>Registrarse</span>
                </a>
            </div>
        </div>
    </nav>


    <!-- HERO -->`);

  const a11yPanelRaw = fs.readFileSync(path.join(webappDir, 'a11y-panel.jsp'), 'utf8').replace(/<%@page[^>]*%>/g, '');
  content = content.replace(/<%@include file="a11y-panel\.jsp"%>/g, a11yPanelRaw);

  content = content.replace('</body>', scriptSincronizacionSesion + '</body>');
  content = replaceUrls(content);

  fs.writeFileSync(path.join(outDir, 'index.html'), content, 'utf8');
  console.log('✓ index.html generado con diseño y sesión idénticos a Apache NetBeans');
}

// -------------------------------------------------------------
// 2. GENERAR LOGIN.HTML (LIMPIO SIN LITERALES JSP NI ALERTAS FANTASMAS)
// -------------------------------------------------------------
function generateLogin() {
  let content = fs.readFileSync(path.join(webappDir, 'login.jsp'), 'utf8');

  content = content.replace(/<%@page[^>]*%>/g, '');

  // Reemplazar bloque de error y registro por placeholder dinámico limpio
  const alertPlaceholder = `
    <!-- CONTENEDOR DINÁMICO DE ALERTAS -->
    <div id="alertContainer"></div>
  `;

  content = content.replace(/<!-- MENSAJE DE ERROR -->[\s\S]*?<!-- FORMULARIO LOGIN -->/, `${alertPlaceholder}\n                            <!-- FORMULARIO LOGIN -->`);

  content = content.replace(/value="<%= correoIngresado != null \? correoIngresado : "" %>"/g, '');

  const a11yPanelRaw = fs.readFileSync(path.join(webappDir, 'a11y-panel.jsp'), 'utf8').replace(/<%@page[^>]*%>/g, '');
  content = content.replace(/<%@include file="a11y-panel\.jsp"%>/g, a11yPanelRaw);

  // Script interactivo de login que soporta Administrador y Lector
  const scriptLogin = `
  <script>
    function completarCredenciales(correo, password) {
        document.getElementById('correoInput').value = correo;
        document.getElementById('passwordInput').value = password;
    }

    function togglePassword() {
        var input = document.getElementById('passwordInput');
        input.type = (input.type === 'password') ? 'text' : 'password';
    }

    document.addEventListener('DOMContentLoaded', () => {
        // Verificar si viene de registro exitoso
        const params = new URLSearchParams(window.location.search);
        if (params.get('registro') === 'exitoso') {
            const container = document.getElementById('alertContainer');
            if (container) {
                container.innerHTML = \`
                    <div class="alert alert-success">
                        ¡Cuenta de lector creada correctamente! Ya puedes iniciar sesión con tu correo y contraseña.
                    </div>
                \`;
            }
        }

        const form = document.getElementById('formLogin') || document.querySelector('form');
        if (form) {
            form.onsubmit = (e) => {
                e.preventDefault();
                const correo = (document.getElementById('correoInput') ? document.getElementById('correoInput').value : '').trim().toLowerCase();
                const pass = document.getElementById('passwordInput') ? document.getElementById('passwordInput').value : '';

                if (correo === 'admin@bookhub.com') {
                    sessionStorage.setItem('bookhub_user', JSON.stringify({
                        nombre: 'Administrador',
                        correo: 'admin@bookhub.com',
                        rol: 'ADMIN'
                    }));
                    window.location.href = 'dashboard.html';
                } else if (correo === 'maria@bookhub.com') {
                    sessionStorage.setItem('bookhub_user', JSON.stringify({
                        nombre: 'María López (Lector 2)',
                        correo: 'maria@bookhub.com',
                        rol: 'USUARIO'
                    }));
                    window.location.href = 'catalogo.html';
                } else {
                    sessionStorage.setItem('bookhub_user', JSON.stringify({
                        nombre: 'Juan Pérez (Lector 1)',
                        correo: correo || 'juan@bookhub.com',
                        rol: 'USUARIO'
                    }));
                    window.location.href = 'catalogo.html';
                }
            };
        }
    });
  </script>
  `;

  content = content.replace(/<script>[\s\S]*?<\/script>/, scriptLogin);
  content = replaceUrls(content);

  fs.writeFileSync(path.join(outDir, 'login.html'), content, 'utf8');
  console.log('✓ login.html generado limpio y fiel a login.jsp');
}

// -------------------------------------------------------------
// 3. GENERAR REGISTRO.HTML (IDÉNTICO A REGISTRO.JSP DE APACHE)
// -------------------------------------------------------------
function generateRegistro() {
  let content = fs.readFileSync(path.join(webappDir, 'registro.jsp'), 'utf8');

  content = content.replace(/<%@page[^>]*%>/g, '');

  // Quitar el bloque de mensaje de error JSP
  content = content.replace(/<!-- MENSAJE DE ERROR -->[\s\S]*?<form action="RegistroServlet"/, `<div id="alertRegistro"></div>\n                        <form id="formRegistro" action="javascript:void(0)"`);

  content = content.replace(/value="<%= nombreIngresado != null \? nombreIngresado : "" %>"/g, '');
  content = content.replace(/value="<%= correoIngresado != null \? correoIngresado : "" %>"/g, '');

  const a11yPanelRaw = fs.readFileSync(path.join(webappDir, 'a11y-panel.jsp'), 'utf8').replace(/<%@page[^>]*%>/g, '');
  content = content.replace(/<%@include file="a11y-panel\.jsp"%>/g, a11yPanelRaw);

  const scriptRegistro = `
  <script>
    document.addEventListener('DOMContentLoaded', () => {
        const form = document.getElementById('formRegistro');
        if (form) {
            form.onsubmit = (e) => {
                e.preventDefault();
                const pass = form.querySelector('input[name="password"]').value;
                const confirm = form.querySelector('input[name="confirmarPassword"]').value;
                if (pass !== confirm) {
                    const alertEl = document.getElementById('alertRegistro');
                    if (alertEl) {
                        alertEl.innerHTML = '<div class="alert alert-danger">Las contraseñas no coinciden. Por favor verifícalas.</div>';
                    }
                    return;
                }
                // Redireccionar a login con parámetro idéntico a RegistroServlet
                window.location.href = 'login.html?registro=exitoso';
            };
        }
    });
  </script>
  `;

  content = content.replace('</body>', scriptRegistro + '</body>');
  content = replaceUrls(content);

  fs.writeFileSync(path.join(outDir, 'registro.html'), content, 'utf8');
  console.log('✓ registro.html generado con diseño exacto de registro.jsp');
}

// -------------------------------------------------------------
// 4. GENERAR DASHBOARD.HTML
// -------------------------------------------------------------
function generateDashboard() {
  let content = fs.readFileSync(path.join(webappDir, 'dashboard.jsp'), 'utf8');

  content = content.replace(/<%@page[^>]*%>/g, '');
  content = content.replace(/<%[\s\S]*?if \(!\"ADMIN\"\.equals[\s\S]*?%>/, '');

  content = content.replace(/<%= usuario\.getNombre\(\) %>/g, 'Administrador');

  const a11yPanelRaw = fs.readFileSync(path.join(webappDir, 'a11y-panel.jsp'), 'utf8').replace(/<%@page[^>]*%>/g, '');
  content = content.replace(/<%@include file="a11y-panel\.jsp"%>/g, a11yPanelRaw);

  content = content.replace(/href="LogoutServlet"/g, 'href="javascript:void(0)" onclick="cerrarSesion()"');

  content = content.replace('</body>', scriptSincronizacionSesion + '</body>');
  content = replaceUrls(content);

  fs.writeFileSync(path.join(outDir, 'dashboard.html'), content, 'utf8');
  console.log('✓ dashboard.html generado con acceso directo de Administrador');
}

// -------------------------------------------------------------
// 5. GENERAR CATALOGO.HTML
// -------------------------------------------------------------
function generateCatalogo() {
  let content = fs.readFileSync(path.join(webappDir, 'catalogo.jsp'), 'utf8');

  content = content.replace(/<%@page[^>]*%>/g, '');
  content = content.replace(/<%[\s\S]*?int totalLibros =[\s\S]*?%>/, '');

  const a11yPanelRaw = fs.readFileSync(path.join(webappDir, 'a11y-panel.jsp'), 'utf8').replace(/<%@page[^>]*%>/g, '');
  content = content.replace(/<%@include file="a11y-panel\.jsp"%>/g, a11yPanelRaw);

  // Sidebar usuario dinámico
  content = content.replace(/<% if \(usuarioSesion != null\) \{ %>[\s\S]*?<% \} %>/, '<div id="sidebarUserSessionContainer"></div>');

  // Navbar sesión dinámico
  content = content.replace(/<!-- Lado derecho: EXCLUSIVAMENTE Iniciar Sesión \/ Registrarse[\s\S]*?<\/div>\s*<\/div>\s*<\/nav>/, `<!-- Lado derecho -->
            <div class="d-flex align-items-center gap-2 ms-auto" id="navSessionContainer">
                <a href="login.html" class="btn btn-light btn-sm d-flex align-items-center gap-1">
                    <i class="bi bi-box-arrow-in-right"></i> <span>Iniciar sesión</span>
                </a>
                <a href="registro.html" class="btn btn-outline-light btn-sm d-flex align-items-center gap-1">
                    <i class="bi bi-person-plus"></i> <span>Registrarse</span>
                </a>
            </div>
        </div>
    </nav>`);

  const cardsHtml = librosData.map(l => {
    const titEsc = escapeHtml(l.titulo);
    const autEsc = escapeHtml(l.autor);
    const catEsc = escapeHtml(l.categoria);
    const descEsc = escapeHtml(l.descripcion);
    const badge = l.stock > 0 
      ? `<span class="badge bg-success stock-floating-badge shadow-sm">Disponible (${l.stock})</span>`
      : `<span class="badge bg-secondary stock-floating-badge shadow-sm">Agotado</span>`;

    return `
      <div class="col-md-4 libro-item" data-stock="${l.stock}" data-categoria="${catEsc.toLowerCase()}">
          <div class="card book-card h-100 shadow-sm">
              <div class="book-cover-wrapper">
                  ${badge}
                  <a href="detalleLibro.html?id=${l.id}" class="cover-link" title="Ver ficha de ${titEsc}">
                      <img src="${l.portada}" alt="Portada de ${titEsc}" class="book-cover-img" onerror="this.onerror=null;this.src='img/portadas/default.svg';">
                  </a>
                  <button type="button" class="btn btn-sm quick-view-btn shadow-sm"
                          data-id="${l.id}"
                          data-titulo="${titEsc}"
                          data-autor="${autEsc}"
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
                  <h6 class="card-title fw-bold mb-1">${titEsc}</h6>
                  <p class="text-muted small mb-1">${autEsc}</p>
                  <p class="card-text text-secondary small mb-3 lh-sm" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                      ${descEsc}
                  </p>
                  <div class="mt-auto pt-2 border-top">
                      <div class="d-grid gap-2">
                          <button type="button" class="btn-audio-detailed w-100" onclick="reproducirAudio('${escapeJs(titEsc)}. De ${escapeJs(autEsc)}. ${escapeJs(descEsc)}')">
                              <i class="bi bi-volume-up-fill"></i> <span>Audio</span>
                          </button>
                          <div class="d-flex gap-2">
                              <a href="detalleLibro.html?id=${l.id}" class="btn btn-primary btn-sm flex-grow-1">Detalles</a>
                              <a href="detalleLibro.html?id=${l.id}&prestamo=1" class="btn btn-outline-primary btn-sm">Préstamo</a>
                          </div>
                      </div>
                  </div>
              </div>
          </div>
      </div>`;
  }).join('\n');

  content = content.replace(/<div class="row g-4" id="listaLibros">[\s\S]*?<\/div>\s*<\/div>\s*<!-- MODAL DE VISTA RÁPIDA -->/, `
    <div class="row g-4" id="listaLibros">
      ${cardsHtml}
    </div>
</div>
<!-- MODAL DE VISTA RÁPIDA -->`);

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
        if (btn) {
            btn.classList.remove('btn-outline-secondary');
            btn.classList.add('btn-primary', 'active');
        }

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

  content = content.replace('</body>', filterScript + scriptSincronizacionSesion + '</body>');
  content = replaceUrls(content);

  fs.writeFileSync(path.join(outDir, 'catalogo.html'), content, 'utf8');
  console.log('✓ catalogo.html generado');
}

// -------------------------------------------------------------
// 6. GENERAR INNOVACION.HTML
// -------------------------------------------------------------
function generateInnovacion() {
  let content = fs.readFileSync(path.join(webappDir, 'innovacion.jsp'), 'utf8');

  content = content.replace(/<%@page[^>]*%>/g, '');
  content = content.replace(/<%[\s\S]*?librosRegistradosAttr =[\s\S]*?%>/, '');

  const a11yPanelRaw = fs.readFileSync(path.join(webappDir, 'a11y-panel.jsp'), 'utf8').replace(/<%@page[^>]*%>/g, '');
  content = content.replace(/<%@include file="a11y-panel\.jsp"%>/g, a11yPanelRaw);

  content = content.replace(/<% if \(usuarioSesion != null\) \{ %>[\s\S]*?<% \} %>/, '<div id="sidebarUserSessionContainer"></div>');
  content = content.replace(/<!-- Lado derecho: EXCLUSIVAMENTE Iniciar Sesión \/ Registrarse[\s\S]*?<\/div>\s*<\/div>\s*<\/nav>/, `<!-- Lado derecho -->
            <div class="d-flex align-items-center gap-2 ms-auto" id="navSessionContainer">
                <a href="login.html" class="btn btn-light btn-sm d-flex align-items-center gap-1">
                    <i class="bi bi-box-arrow-in-right"></i> <span>Iniciar sesión</span>
                </a>
                <a href="registro.html" class="btn btn-outline-light btn-sm d-flex align-items-center gap-1">
                    <i class="bi bi-person-plus"></i> <span>Registrarse</span>
                </a>
            </div>
        </div>
    </nav>`);

  content = content.replace(/<%=[\s\S]*?%>/g, '');
  content = content.replace(/<%[\s\S]*?%>/g, '');

  content = content.replace('</body>', scriptSincronizacionSesion + '</body>');
  content = replaceUrls(content);

  fs.writeFileSync(path.join(outDir, 'innovacion.html'), content, 'utf8');
  console.log('✓ innovacion.html generado');
}

// -------------------------------------------------------------
// 7. GENERAR DETALLELIBRO.HTML
// -------------------------------------------------------------
function generateDetalleLibro() {
  let content = fs.readFileSync(path.join(webappDir, 'detalleLibro.jsp'), 'utf8');

  content = content.replace(/<%@page[^>]*%>/g, '');
  content = content.replace(/<%[\s\S]*?String portadaUrl =[\s\S]*?%>/, '');

  const a11yPanelRaw = fs.readFileSync(path.join(webappDir, 'a11y-panel.jsp'), 'utf8').replace(/<%@page[^>]*%>/g, '');
  content = content.replace(/<%@include file="a11y-panel\.jsp"%>/g, a11yPanelRaw);

  content = content.replace(/<!-- Lado derecho: EXCLUSIVAMENTE Volver al catálogo -->[\s\S]*?<\/div>\s*<\/div>\s*<\/nav>/, `
    <div class="d-flex align-items-center gap-2 ms-auto">
        <a href="catalogo.html" class="btn btn-outline-light btn-sm d-flex align-items-center gap-1">
            <i class="bi bi-arrow-left"></i> <span>Volver al Catálogo</span>
        </a>
    </div>
</div>
</nav>`);

  content = content.replace(/<%=[\s\S]*?%>/g, '');
  content = content.replace(/<%[\s\S]*?%>/g, '');

  const dynamicScript = `
  <script>
    const librosData = ${JSON.stringify(librosData)};

    document.addEventListener('DOMContentLoaded', () => {
        const urlParams = new URLSearchParams(window.location.search);
        const bookId = parseInt(urlParams.get('id')) || 1;
        const libro = librosData.find(l => l.id === bookId) || librosData[0];

        document.title = libro.titulo + " - BookHub";

        const titleEl = document.querySelector('h1.fw-bold') || document.querySelector('h2.fw-bold');
        if (titleEl) titleEl.textContent = libro.titulo;

        const imgEl = document.querySelector('.detalle-portada-box img') || document.querySelector('.book-cover-img');
        if (imgEl) {
            imgEl.src = libro.portada;
            imgEl.alt = "Portada de " + libro.titulo;
        }

        const items = document.querySelectorAll('p, div, span, li');
        items.forEach(el => {
            if (el.textContent.includes('Autor:')) {
                el.innerHTML = '<strong>Autor:</strong> ' + libro.autor;
            } else if (el.textContent.includes('Categoría:')) {
                el.innerHTML = '<strong>Categoría:</strong> <span class="badge bg-info text-dark">' + libro.categoria + '</span>';
            } else if (el.textContent.includes('Año:') || el.textContent.includes('Publicación:')) {
                el.innerHTML = '<strong>Año:</strong> ' + libro.anio;
            } else if (el.textContent.includes('ISBN:')) {
                el.innerHTML = '<strong>ISBN:</strong> ' + libro.isbn;
            } else if (el.textContent.includes('Disponibilidad:') || el.textContent.includes('Stock:')) {
                el.innerHTML = '<strong>Disponibilidad:</strong> ' + (libro.stock > 0 
                    ? '<span class="badge bg-success">Disponible (' + libro.stock + ' ejemplares)</span>'
                    : '<span class="badge bg-secondary">Agotado</span>');
            }
        });

        const descEl = document.querySelector('.lead') || document.querySelector('.card-text');
        if (descEl) descEl.textContent = libro.descripcion;

        const btnAudio = document.querySelector('.btn-audio-detailed') || document.querySelector('button[onclick*="reproducirAudio"]');
        if (btnAudio) {
            btnAudio.onclick = () => {
                reproducirAudio(libro.titulo + ". De " + libro.autor + ". " + libro.descripcion);
            };
        }

        if (urlParams.get('prestamo') === '1') {
            setTimeout(() => {
                alert("¡Solicitud de préstamo procesada para: " + libro.titulo + "! Puedes recoger el ejemplar en el mostrador central.");
            }, 300);
        }
    });
  </script>
  `;

  content = content.replace('</body>', dynamicScript + scriptSincronizacionSesion + '</body>');
  content = replaceUrls(content);

  fs.writeFileSync(path.join(outDir, 'detalleLibro.html'), content, 'utf8');
  console.log('✓ detalleLibro.html generado');
}

// -------------------------------------------------------------
// 8. GENERAR RESTO DE PÁGINAS ADMINISTRATIVAS Y DE LECTOR
// -------------------------------------------------------------
function generateAllRemaining() {
  const pages = [
    'donar.jsp',
    'misPrestamos.jsp',
    'usuario.jsp',
    'libros.jsp',
    'autores.jsp',
    'categorias.jsp',
    'prestamos.jsp',
    'donaciones.jsp',
    'reportes.jsp',
    'sanciones.jsp',
    'usuarios.jsp'
  ];

  const a11yPanelRaw = fs.readFileSync(path.join(webappDir, 'a11y-panel.jsp'), 'utf8').replace(/<%@page[^>]*%>/g, '');

  pages.forEach(file => {
    const srcPath = path.join(webappDir, file);
    if (!fs.existsSync(srcPath)) return;
    let content = fs.readFileSync(srcPath, 'utf8');

    content = content.replace(/<%@page[^>]*%>/g, '');
    content = content.replace(/<%@include file="a11y-panel\.jsp"%>/g, a11yPanelRaw);

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
            </td>
        </tr>`).join('\n');
      content = content.replace(/<tbody>[\s\S]*?<\/tbody>/, `<tbody>${rows}</tbody>`);
    } else if (file === 'autores.jsp') {
      const rows = autoresData.map(a => `
        <tr>
            <td>${a.id}</td>
            <td><strong>${escapeHtml(a.nombre)}</strong></td>
            <td>${escapeHtml(a.nacionalidad)}</td>
            <td>
                <button class="btn btn-sm btn-outline-warning" onclick="alert('Editar autor: ${escapeHtml(a.nombre)}')"><i class="bi bi-pencil"></i></button>
            </td>
        </tr>`).join('\n');
      content = content.replace(/<tbody>[\s\S]*?<\/tbody>/, `<tbody>${rows}</tbody>`);
    } else if (file === 'categorias.jsp') {
      const rows = categoriasData.map(c => `
        <tr>
            <td>${c.id}</td>
            <td><strong>${escapeHtml(c.nombre)}</strong></td>
            <td>${escapeHtml(c.descripcion)}</td>
            <td>
                <button class="btn btn-sm btn-outline-warning" onclick="alert('Editar categoría: ${escapeHtml(c.nombre)}')"><i class="bi bi-pencil"></i></button>
            </td>
        </tr>`).join('\n');
      content = content.replace(/<tbody>[\s\S]*?<\/tbody>/, `<tbody>${rows}</tbody>`);
    }

    content = content.replace(/<%=[\s\S]*?%>/g, '');
    content = content.replace(/<%[\s\S]*?%>/g, '');

    content = content.replace('</body>', scriptSincronizacionSesion + '</body>');
    content = replaceUrls(content);

    const outName = file.replace('.jsp', '.html');
    fs.writeFileSync(path.join(outDir, outName), content, 'utf8');
    console.log(`✓ ${outName} generado`);
  });
}

// -------------------------------------------------------------
// 9. VALIDAR BALANCE DE DIVS
// -------------------------------------------------------------
function validateDivs() {
  const files = ['index.html', 'catalogo.html', 'innovacion.html', 'detalleLibro.html', 'dashboard.html', 'login.html', 'registro.html', 'donar.html', 'misPrestamos.html'];
  files.forEach(f => {
    if (!fs.existsSync(f)) return;
    const content = fs.readFileSync(f, 'utf8');
    const openDivs = (content.match(/<div\b/g) || []).length;
    const closeDivs = (content.match(/<\/div>/g) || []).length;
    console.log(`[VALIDACION] ${f}: open=${openDivs}, close=${closeDivs}, diff=${openDivs - closeDivs}`);
  });
}

console.log('--- REGENERANDO CON ESTRUCTURA EXACTA APACHE ---');
generateIndex();
generateLogin();
generateRegistro();
generateDashboard();
generateCatalogo();
generateInnovacion();
generateDetalleLibro();
generateAllRemaining();
validateDivs();
console.log('--- FINALIZADO ---');
