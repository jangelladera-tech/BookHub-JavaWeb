# 📚 BOOKHUB — Sistema Web de Gestión de Biblioteca Universitaria

Aplicación web desarrollada en **Java (Jakarta EE / Servlets / JSP / MVC / DAO con JDBC y MySQL)** manteniendo la estructura original de proyecto **NetBeans / Apache Ant (`build.xml`, `nbproject/`)**, configurada para **Apache Tomcat 10** y **JDK 24**.

---

## 📊 Panel de Innovación Bibliotecaria (ODS 09)

**BOOKHUB** incorpora el apartado **Panel de Innovación Bibliotecaria** (accesible desde el botón **ODS 09** en la barra de navegación), diseñado para mejorar la disponibilidad de los recursos bibliográficos mediante el uso de datos y apoyar la toma de decisiones sobre la biblioteca a través de **4 indicadores en tiempo real** conectados a `LibroDAO` y `PrestamoDAO`:
- **Libros registrados:** Total de títulos registrados en el catálogo.
- **Stock bajo:** Libros con **1 a 2 ejemplares** disponibles (alerta preventiva de reposición).
- **Préstamos activos:** Total de préstamos vigentes (`PRESTADO`) en la biblioteca.
- **Libros agotados:** Libros con **0 ejemplares** disponibles que requieren acción inmediata.

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

## 🗂️ Estructura del Proyecto (NetBeans / Apache Ant)

```text
BookHub/
├── build.xml                        # Script de compilación Apache Ant (NetBeans)
├── nbproject/                       # Configuración de Apache Tomcat 10 y JDK 24
├── database/
│   └── bookhub.sql                  # Script MySQL con tablas y datos semilla
├── src/
│   ├── conf/MANIFEST.MF
│   └── java/
│       ├── beans/                   # Modelo de clases (Autor, Categoria, Libro, Prestamo, Usuario)
│       ├── conexion/                # Clase Conexion JDBC MySQL (puerto 3307 / 3306)
│       ├── dao/                     # Capa DAO con PreparedStatement + respaldo en memoria
│       └── servlets/                # Controladores MVC y filtro de seguridad AdminFilter
└── web/                             # Vistas JSP, index.html y configuración WEB-INF/META-INF
```
