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

## 📐 Diagrama de Clases UML (Entregable 1 y 2 - Evaluación T2 SWAD)

```mermaid
classDiagram
    class Autor {
        -int idAutor
        -String nombre
        -String nacionalidad
        +getIdAutor() int
        +setIdAutor(int) void
        +getNombre() String
        +setNombre(String) void
        +getNacionalidad() String
        +setNacionalidad(String) void
    }

    class Categoria {
        -int idCategoria
        -String nombre
        -String descripcion
        +getIdCategoria() int
        +setIdCategoria(int) void
        +getNombre() String
        +setNombre(String) void
        +getDescripcion() String
        +setDescripcion(String) void
    }

    class Libro {
        -int idLibro
        -String titulo
        -String isbn
        -int anio
        -String descripcion
        -int stock
        -int idAutor
        -int idCategoria
        -String nombreAutor
        -String nombreCategoria
        -Autor autor
        -Categoria categoria
        +getIdLibro() int
        +getTitulo() String
        +getIsbn() String
        +getAnio() int
        +getDescripcion() String
        +getStock() int
        +getAutor() Autor
        +getCategoria() Categoria
    }

    class Usuario {
        -int idUsuario
        -String nombre
        -String correo
        -String password
        -String rol
        -String estado
        +getIdUsuario() int
        +getNombre() String
        +getCorreo() String
        +getPassword() String
        +getRol() String
        +getEstado() String
    }

    class Prestamo {
        -int idPrestamo
        -int idUsuario
        -int idLibro
        -String fechaPrestamo
        -String fechaDevolucion
        -String estado
        -Usuario usuario
        -Libro libro
        +getIdPrestamo() int
        +getIdUsuario() int
        +getIdLibro() int
        +getFechaPrestamo() String
        +getFechaDevolucion() String
        +getEstado() String
    }

    class Conexion {
        -String URL_3307$
        -String URL_3306$
        -String USER$
        -String PASSWORD$
        +conectar()$ Connection
    }

    class LibroDAO {
        +listar() List~Libro~
        +obtenerPorId(int) Libro
        +buscar(String, String) List~Libro~
        +agregar(Libro) void
        +actualizar(Libro) void
        +eliminar(int) void
    }

    class AutorDAO {
        +listar() List~Autor~
        +obtenerPorId(int) Autor
        +agregar(Autor) void
        +actualizar(Autor) void
        +eliminar(int) void
    }

    class CategoriaDAO {
        +listar() List~Categoria~
        +obtenerPorId(int) Categoria
        +agregar(Categoria) void
        +actualizar(Categoria) void
        +eliminar(int) void
    }

    class UsuarioDAO {
        +listar() List~Usuario~
        +obtenerPorId(int) Usuario
        +autenticar(String, String) Usuario
        +agregar(Usuario) void
        +actualizar(Usuario) void
        +eliminar(int) void
    }

    class PrestamoDAO {
        +listar() List~Prestamo~
        +obtenerPorId(int) Prestamo
        +agregar(Prestamo) void
        +actualizar(Prestamo) void
        +eliminar(int) void
    }

    Autor "1" <-- "*" Libro : escrito por
    Categoria "1" <-- "*" Libro : pertenece a
    Usuario "1" <-- "*" Prestamo : solicita
    Libro "1" <-- "*" Prestamo : incluye
    LibroDAO ..> Conexion : usa
    AutorDAO ..> Conexion : usa
    CategoriaDAO ..> Conexion : usa
    UsuarioDAO ..> Conexion : usa
    PrestamoDAO ..> Conexion : usa
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
