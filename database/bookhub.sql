-- =====================================================================
-- BASE DE DATOS: bookhub (MySQL) - Evaluación T2 SWAD
-- =====================================================================

CREATE DATABASE IF NOT EXISTS bookhub
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE bookhub;

-- 1. Tabla de Autores
CREATE TABLE IF NOT EXISTS autores (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    nacionalidad VARCHAR(80) NOT NULL
);

-- 2. Tabla de Categorías
CREATE TABLE IF NOT EXISTS categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255) NOT NULL
);

-- 3. Tabla de Libros (Relacionada con Autores, Categorías e Imagen de Portada)
CREATE TABLE IF NOT EXISTS libros (
    id_libro INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    isbn VARCHAR(30) NOT NULL,
    anio INT NOT NULL,
    descripcion TEXT NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    id_autor INT DEFAULT 1,
    id_categoria INT DEFAULT 1,
    imagen_portada LONGTEXT DEFAULT NULL,
    CONSTRAINT fk_libro_autor FOREIGN KEY (id_autor) REFERENCES autores(id_autor) ON DELETE SET NULL,
    CONSTRAINT fk_libro_categoria FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria) ON DELETE SET NULL
);

-- 4. Tabla de Usuarios (1 Admin y 2 Lectores pre-creados)
CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    correo VARCHAR(120) NOT NULL UNIQUE,
    password VARCHAR(120) NOT NULL,
    rol VARCHAR(20) NOT NULL DEFAULT 'USUARIO',
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
);

-- 5. Tabla de Préstamos (Relacionada con Usuarios y Libros)
CREATE TABLE IF NOT EXISTS prestamos (
    id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_libro INT NOT NULL,
    fecha_prestamo VARCHAR(20) NOT NULL,
    fecha_devolucion VARCHAR(20) NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'PRESTADO',
    CONSTRAINT fk_prestamo_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    CONSTRAINT fk_prestamo_libro FOREIGN KEY (id_libro) REFERENCES libros(id_libro) ON DELETE CASCADE
);

-- =====================================================================
-- DATOS INICIALES
-- =====================================================================

INSERT INTO autores (id_autor, nombre, nacionalidad) VALUES
(1, 'Gabriel García Márquez', 'Colombiana'),
(2, 'Miguel de Cervantes', 'Española'),
(3, 'Antoine de Saint-Exupéry', 'Francesa'),
(4, 'Robert C. Martin', 'Estadounidense')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre);

INSERT INTO categorias (id_categoria, nombre, descripcion) VALUES
(1, 'Novela', 'Obras narrativas de ficción y literatura clásica.'),
(2, 'Programación', 'Libros relacionados con ingeniería y desarrollo de software.'),
(3, 'Ciencia', 'Libros relacionados con ciencias exactas, física e investigación.')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre);

INSERT INTO libros (id_libro, titulo, isbn, anio, descripcion, stock, id_autor, id_categoria, imagen_portada) VALUES
(1, 'Cien años de soledad', '9780307474728', 1967, 'Novela cumbre del realismo mágico escrita por el colombiano Gabriel García Márquez.', 5, 1, 1, 'img/portadas/libro1.svg'),
(2, 'Don Quijote de la Mancha', '9788420412146', 1605, 'Obra clásica universal de la literatura española escrita por Miguel de Cervantes.', 2, 2, 1, 'img/portadas/libro2.svg'),
(3, 'El Principito', '9780156012195', 1943, 'Obra literaria y filosófica de Antoine de Saint-Exupéry sobre la amistad y el sentido de la vida.', 7, 3, 1, 'img/portadas/libro3.svg'),
(4, 'Clean Code: Manual de desarrollo ágil de software', '9780132350884', 2008, 'Principios, patrones y buenas prácticas para escribir código limpio y mantenible.', 4, 4, 2, 'img/portadas/libro4.svg')
ON DUPLICATE KEY UPDATE titulo = VALUES(titulo), imagen_portada = COALESCE(imagen_portada, VALUES(imagen_portada));

-- 1 Usuario Administrador y 2 Usuarios Lectores ya creados
INSERT INTO usuarios (id_usuario, nombre, correo, password, rol, estado) VALUES
(1, 'Administrador', 'admin@bookhub.com', '123456', 'ADMIN', 'ACTIVO'),
(2, 'Juan Pérez (Lector 1)', 'juan@bookhub.com', '123456', 'USUARIO', 'ACTIVO'),
(3, 'María López (Lector 2)', 'maria@bookhub.com', '123456', 'USUARIO', 'ACTIVO')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre);

INSERT INTO prestamos (id_prestamo, id_usuario, id_libro, fecha_prestamo, fecha_devolucion, estado) VALUES
(1, 2, 1, '23/09/2026', '30/09/2026', 'PRESTADO'),
(2, 3, 2, '22/09/2026', '29/09/2026', 'DEVUELTO')
ON DUPLICATE KEY UPDATE estado = VALUES(estado);
