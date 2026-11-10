# 📚 BOOKHUB — Sistema Web de Gestión de Biblioteca Universitaria

Aplicación web desarrollada en **Java (Jakarta EE 10 / Servlets 6.0 / JSP / MVC / DAO con JDBC y MySQL)** bajo la arquitectura y estructura estándar de **Apache Maven**, configurada para despliegue en **Apache Tomcat 10+**.

---

## ODS 09: Innovación Tecnológica para Personas con Discapacidad

En cumplimiento con el **ODS 09 (Industria, Innovación e Infraestructura - Metas 9.c y 9.1)** y las directrices internacionales de accesibilidad web **WCAG 2.1 (Nivel AAA)**, **BOOKHUB** integra una suite de **tecnologías de asistencia e inclusión digital**, diseñada para que estudiantes e investigadores con discapacidad visual, motriz o cognitiva accedan al catálogo y contenidos en igualdad de condiciones:

1. **Visualización Directa de Portadas y Carátulas:**
   - Visualización directa de las portadas de los libros en la vista de catálogo (`160px x 224px`) con soporte de texto alternativo (`alt`) estructurado, optimizando la identificación visual inmediata sin depender exclusivamente del modal de vista rápida.

2. **Modos de Contraste Calibrados (Sin pérdida de legibilidad):**
   - **Modo Sepia (Lectura Cálida):** Fondo tono papel (`#fbf0d9`) y texto café oscuro (`#2c221e`), ideal para evitar la fatiga visual en sesiones prolongadas.
   - **Modo Pizarra Oscura:** Fondo gris pizarra (`#0f172a`), tarjetas (`#1e293b`) y tipografía clara (`#cbd5e1`), reduciendo el deslumbramiento.
   - **Modo Alto Contraste (WCAG AAA):** Fondo negro absoluto (`#000000`) con tipografía en blanco puro (`#ffffff`), acentos en amarillo accesible (`#ffff00`) y bordes cian (`#00e5ff`). Todas las clases de texto secundario y atenuado están calibradas para garantizar 100% de visibilidad.

3. **Escala Tipográfica Progresiva (100% a 145%):**
   - Selector escalonado de 4 niveles (`100%`, `115%`, `130%` y `145%`) que redimensiona proporcionalmente la interfaz sin desbordamientos de maquetación, con persistencia en `localStorage`.

4. **Apoyo de Lectura y Neurodivergencia:**
   - **Modo Dislexia:** Aplica pesos basales equilibrados, espaciado entre letras (`letter-spacing: 0.05em`) e interlineado ampliado (`line-height: 1.85`).
   - **Máscara de Foco de Lectura:** Guía visual de lectura que atenúa el fondo y proyecta una franja iluminada siguiendo el cursor del ratón, facilitando la concentración en lectores con TDAH o dificultades de fijación ocular.
   - **Subrayado de Enlaces:** Resaltado explícito con subrayado de alto contraste para identificar elementos accionables sin depender únicamente del color.

5. **Síntesis de Voz y Búsqueda por Reconocimiento de Voz:**
   - **Audiolibro Asistido (Text-to-Speech):** Síntesis de voz en español para títulos, fichas bibliográficas y selección de fragmentos de texto en pantalla mediante la Web Speech Synthesis API, con control de velocidad (0.8x, 1.0x, 1.2x).
   - **Búsqueda Manos Libres:** Integración de la Web Speech Recognition API en la barra de navegación para búsqueda bibliográfica por voz.

6. **Laboratorio de Accesibilidad ODS 09 (`innovacion.jsp`):**
   - Panel de evaluación interactivo donde se comprueba el funcionamiento de las herramientas de asistencia, monitor de recursos adaptados y documentación técnica de cumplimiento.

---

## 🔑 Usuarios Pre-creados (1 Admin y 2 Lectores)

En la pantalla de **Iniciar sesión (`login.jsp`)** puedes iniciar sesión directamente o usar los botones de autocompletado rápido:

| Rol | Nombre | Correo | Contraseña | Estado |
| :--- | :--- | :--- | :--- | :--- |
| **ADMIN** | Administrador | `admin@bookhub.com` | `123456` | `ACTIVO` |
| **USUARIO (Lector 1)** | Juan Pérez (Lector 1) | `juan@bookhub.com` | `123456` | `ACTIVO` |
| **USUARIO (Lector 2)** | María López (Lector 2) | `maria@bookhub.com` | `123456` | `ACTIVO` |

Además, cualquier nuevo lector puede crear su cuenta desde el apartado **Registrarse (`registro.jsp`)**.

---

## 📐 Diagramas de Clases UML Modulares (Arquitectura Completa)

Los diagramas de clases han sido organizados y actualizados cubriendo **todos los apartados del sistema**, estructurados por capas (**Entidades / Beans**, **Acceso a Datos DAO / JDBC** y **Controladores MVC / Servlets**) con una notación ejecutiva y profesional (sin la sobrecarga visual de símbolos `+` o `-`), separados en imágenes de alta resolución:

---

### 1. Módulo Bibliográfico y Catálogo (Libros, Autores, Categorías)
Gestiona el fondo bibliográfico, clasificación por categorías, autores, stock físico y búsqueda multicriterio con portadas digitales.

![Módulo 1: Gestión Bibliográfica y Catálogo](img/uml/diagrama-1-bibliografico.svg)

```mermaid
classDiagram
    class Autor {
        int idAutor
        String nombre
        String nacionalidad
        getIdAutor() int
        setIdAutor(int) void
        getNombre() String
        setNombre(String) void
        getNacionalidad() String
        setNacionalidad(String) void
    }

    class Categoria {
        int idCategoria
        String nombre
        String descripcion
        getIdCategoria() int
        setIdCategoria(int) void
        getNombre() String
        setNombre(String) void
        getDescripcion() String
        setDescripcion(String) void
    }

    class Libro {
        int idLibro
        String titulo
        String isbn
        int anio
        String descripcion
        int stock
        int idAutor
        int idCategoria
        String imagenPortada
        Autor autor
        Categoria categoria
        getIdLibro() int
        getTitulo() String
        getIsbn() String
        getStock() int
        getAutor() Autor
        getCategoria() Categoria
        setStock(int) void
    }

    class AutorDAO {
        listar() List~Autor~
        obtenerPorId(int) Autor
        agregar(Autor) void
        actualizar(Autor) void
        eliminar(int) void
    }

    class CategoriaDAO {
        listar() List~Categoria~
        obtenerPorId(int) Categoria
        agregar(Categoria) void
        actualizar(Categoria) void
        eliminar(int) void
    }

    class LibroDAO {
        listar() List~Libro~
        obtenerPorId(int) Libro
        buscar(String, String) List~Libro~
        agregar(Libro) void
        actualizar(Libro) void
        eliminar(int) void
        actualizarStock(int, int) void
    }

    class Conexion {
        String[] URLS
        String USER
        String[] PASSWORDS
        conectar() Connection
    }

    class CatalogoServlet {
        doGet(req, resp) void
    }

    class LibroServlet {
        doGet(req, resp) void
        doPost(req, resp) void
    }

    class AutorServlet {
        doGet(req, resp) void
        doPost(req, resp) void
    }

    class CategoriaServlet {
        doGet(req, resp) void
        doPost(req, resp) void
    }

    Autor "1" <-- "*" Libro : escrito por
    Categoria "1" <-- "*" Libro : pertenece a
    LibroDAO ..> Conexion : usa
    AutorDAO ..> Conexion : usa
    CategoriaDAO ..> Conexion : usa
    CatalogoServlet ..> LibroDAO : usa
    LibroServlet ..> LibroDAO : usa
    AutorServlet ..> AutorDAO : usa
    CategoriaServlet ..> CategoriaDAO : usa
```

---

### 2. Módulo de Circulación, Préstamos y Sanciones
Controla las solicitudes de préstamos por lectores, aprobaciones administrativas, devoluciones, cálculo de atrasos y emisión de sanciones.

![Módulo 2: Circulación, Préstamos y Sanciones](img/uml/diagrama-2-prestamos-sanciones.svg)

```mermaid
classDiagram
    class Usuario {
        int idUsuario
        String nombre
        String correo
        String rol
        String estado
        getIdUsuario() int
        getNombre() String
        getRol() String
    }

    class Libro {
        int idLibro
        String titulo
        int stock
        String isbn
        getIdLibro() int
        getTitulo() String
        getStock() int
    }

    class Prestamo {
        int idPrestamo
        int idUsuario
        int idLibro
        String fechaPrestamo
        String fechaDevolucion
        String estado
        Usuario usuario
        Libro libro
        getIdPrestamo() int
        getIdUsuario() int
        getIdLibro() int
        getFechaPrestamo() String
        getFechaDevolucion() String
        getEstado() String
        setEstado(String) void
    }

    class PrestamoDAO {
        listar() List~Prestamo~
        listarPorUsuario(int) List~Prestamo~
        obtenerPorId(int) Prestamo
        agregar(Prestamo) void
        actualizar(Prestamo) void
        eliminar(int) void
    }

    class Conexion {
        String[] URLS
        String USER
        conectar() Connection
    }

    class PrestamoServlet {
        doGet(req, resp) void
        doPost(req, resp) void
    }

    class SolicitarPrestamoServlet {
        doPost(req, resp) void
    }

    class MisPrestamosServlet {
        doGet(req, resp) void
    }

    class SancionesServlet {
        doGet(req, resp) void
        doPost(req, resp) void
    }

    Usuario "1" <-- "*" Prestamo : solicita
    Libro "1" <-- "*" Prestamo : ejemplar prestado
    PrestamoDAO ..> Conexion : usa
    PrestamoServlet ..> PrestamoDAO : gestiona
    SolicitarPrestamoServlet ..> PrestamoDAO : solicita
    MisPrestamosServlet ..> PrestamoDAO : consulta
    SancionesServlet ..> PrestamoDAO : audita atrasos
```

---

### 3. Módulo de Usuarios, Autenticación y Seguridad
Maneja el registro de lectores, inicio de sesión seguro, control de sesiones HTTP y filtro perimetral de seguridad para rutas administrativas.

![Módulo 3: Usuarios, Autenticación y Seguridad](img/uml/diagrama-3-usuarios-seguridad.svg)

```mermaid
classDiagram
    class Usuario {
        int idUsuario
        String nombre
        String correo
        String password
        String rol
        String estado
        getIdUsuario() int
        getNombre() String
        getCorreo() String
        getPassword() String
        getRol() String
        getEstado() String
        setEstado(String) void
    }

    class UsuarioDAO {
        listar() List~Usuario~
        obtenerPorId(int) Usuario
        autenticar(String, String) Usuario
        agregar(Usuario) void
        actualizar(Usuario) void
        eliminar(int) void
    }

    class Conexion {
        String[] URLS
        String USER
        conectar() Connection
    }

    class AdminFilter {
        init(FilterConfig) void
        doFilter(ServletRequest, ServletResponse, FilterChain) void
        destroy() void
    }

    class LoginServlet {
        doGet(req, resp) void
        doPost(req, resp) void
    }

    class LogoutServlet {
        doGet(req, resp) void
    }

    class RegistroServlet {
        doGet(req, resp) void
        doPost(req, resp) void
    }

    class UsuarioServlet {
        doGet(req, resp) void
        doPost(req, resp) void
    }

    UsuarioDAO ..> Conexion : usa
    LoginServlet ..> UsuarioDAO : autentica
    RegistroServlet ..> UsuarioDAO : registra
    UsuarioServlet ..> UsuarioDAO : administra
    AdminFilter ..> Usuario : verifica rol ADMIN
```

---

### 4. Módulo de Donaciones Comunitarias, Reportes e Innovación ODS 09
Permite la postulación ciudadana de donaciones de libros, panel de auditoría y revisión de ejemplares donados, reportes gerenciales e integración del laboratorio accesible de tecnologías de asistencia ODS 09.

![Módulo 4: Donaciones, Reportes e Innovación ODS 09](img/uml/diagrama-4-donaciones-reportes.svg)

```mermaid
classDiagram
    class Donacion {
        int idDonacion
        String tituloLibro
        String autor
        String categoria
        int anio
        String estadoConservacion
        String nombreDonante
        String correoDonante
        String telefonoDonante
        String motivoMensaje
        String fechaSolicitud
        String estadoRevision
        getIdDonacion() int
        getTituloLibro() String
        getAutor() String
        getEstadoRevision() String
        setEstadoRevision(String) void
    }

    class DonacionDAO {
        listar() List~Donacion~
        obtenerPorId(int) Donacion
        agregar(Donacion) void
        actualizar(Donacion) void
        eliminar(int) void
    }

    class Conexion {
        String[] URLS
        String USER
        conectar() Connection
    }

    class DonacionServlet {
        doGet(req, resp) void
        doPost(req, resp) void
    }

    class DonacionesServlet {
        doGet(req, resp) void
        doPost(req, resp) void
    }

    class ReportesServlet {
        doGet(req, resp) void
    }

    class InnovacionServlet {
        doGet(req, resp) void
    }

    DonacionDAO ..> Conexion : usa
    DonacionServlet ..> DonacionDAO : registra postulacion
    DonacionesServlet ..> DonacionDAO : aprueba o rechaza
    ReportesServlet ..> Conexion : compila metricas
```

---

### 5. Modelo General Integral de Entidades de Dominio
Visión holística de las 6 entidades de datos del ecosistema BookHub y sus relaciones de cardinalidad.

![Modelo General de Entidades de Dominio](img/uml/diagrama-5-dominio-general.svg)

```mermaid
classDiagram
    class Autor {
        int idAutor
        String nombre
        String nacionalidad
        getIdAutor() int
        getNombre() String
    }

    class Categoria {
        int idCategoria
        String nombre
        String descripcion
        getIdCategoria() int
        getNombre() String
    }

    class Libro {
        int idLibro
        String titulo
        String isbn
        int anio
        int stock
        int idAutor
        int idCategoria
        getIdLibro() int
        getTitulo() String
        getStock() int
    }

    class Usuario {
        int idUsuario
        String nombre
        String correo
        String rol
        String estado
        getIdUsuario() int
        getNombre() String
        getRol() String
    }

    class Prestamo {
        int idPrestamo
        int idUsuario
        int idLibro
        String fechaPrestamo
        String fechaDevolucion
        String estado
        getIdPrestamo() int
        getEstado() String
    }

    class Donacion {
        int idDonacion
        String tituloLibro
        String autor
        String categoria
        int anio
        String estadoConservacion
        String nombreDonante
        String estadoRevision
        getIdDonacion() int
        getTituloLibro() String
        getEstadoRevision() String
    }

    Autor "1" <-- "*" Libro : escrito por
    Categoria "1" <-- "*" Libro : clasificado en
    Libro "1" <-- "*" Prestamo : ejemplar prestado
    Usuario "1" <-- "*" Prestamo : solicitado por
```

---

## 🗂️ Estructura del Proyecto (Apache Maven Standard Layout)

```text
BookHub/
├── pom.xml                          # Configuración Maven (Jakarta EE 10, MySQL Connector 8.4.0)
├── database/
│   └── bookhub.sql                  # Script MySQL con tablas y datos semilla
└── src/
    ├── main/
    │   ├── java/
    │   │   ├── beans/               # Modelo de clases (Autor, Categoria, Libro, Prestamo, Usuario)
    │   │   ├── conexion/            # Clase Conexion JDBC MySQL (puerto 3307 / 3306)
    │   │   ├── dao/                 # Capa DAO con PreparedStatement + respaldo en memoria
    │   │   └── servlets/            # Controladores MVC y filtro de seguridad AdminFilter
    │   ├── resources/               # Archivos de configuración y propiedades
    │   └── webapp/                  # Recursos Web de la aplicación
    │       ├── img/                 # Recursos gráficos y portadas SVG
    │       ├── META-INF/
    │       │   └── context.xml      # Configuración de contexto Tomcat
    │       ├── WEB-INF/
    │       │   └── web.xml          # Descriptor de despliegue Jakarta EE 6.0
    │       ├── *.jsp                # Vistas JSP
    │       └── index.html           # Página de inicio
    └── test/
        └── java/                    # Pruebas unitarias
```
