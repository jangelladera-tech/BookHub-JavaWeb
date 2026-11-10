-- =====================================================================
-- BASE DE DATOS: bookhub (MySQL) - Sistema Web de Gestión de Biblioteca
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

-- 6. Tabla de Donaciones de Libros
CREATE TABLE IF NOT EXISTS donaciones (
    id_donacion INT AUTO_INCREMENT PRIMARY KEY,
    titulo_libro VARCHAR(200) NOT NULL,
    autor VARCHAR(120) NOT NULL,
    categoria VARCHAR(100) NOT NULL,
    anio INT DEFAULT NULL,
    estado_conservacion VARCHAR(50) NOT NULL,
    nombre_donante VARCHAR(120) NOT NULL,
    correo_donante VARCHAR(120) NOT NULL,
    telefono_donante VARCHAR(30) DEFAULT NULL,
    motivo_mensaje TEXT,
    fecha_solicitud VARCHAR(20) NOT NULL,
    estado_revision VARCHAR(30) NOT NULL DEFAULT 'PENDIENTE'
);

-- =====================================================================
-- DATOS INICIALES: AUTORES (24 Autores Reales)
-- =====================================================================

INSERT INTO autores (id_autor, nombre, nacionalidad) VALUES
(1, 'Gabriel García Márquez', 'Colombiana'),
(2, 'Miguel de Cervantes', 'Española'),
(3, 'Antoine de Saint-Exupéry', 'Francesa'),
(4, 'Robert C. Martin', 'Estadounidense'),
(5, 'Andrew Hunt & David Thomas', 'Estadounidense'),
(6, 'Erich Gamma et al. (GoF)', 'Suiza / Internacional'),
(7, 'Martin Fowler', 'Británica'),
(8, 'Thomas H. Cormen', 'Estadounidense'),
(9, 'Stephen Hawking', 'Británica'),
(10, 'Carl Sagan', 'Estadounidense'),
(11, 'Richard Dawkins', 'Británica'),
(12, 'Francis Sears & Mark Zemansky', 'Estadounidense'),
(13, 'James Stewart', 'Canadiense'),
(14, 'Stuart Russell & Peter Norvig', 'Estadounidense'),
(15, 'Yuval Noah Harari', 'Israelí'),
(16, 'George Orwell', 'Británica'),
(17, 'Aldous Huxley', 'Británica'),
(18, 'Julio Cortázar', 'Argentina'),
(19, 'Jorge Luis Borges', 'Argentina'),
(20, 'James Clear', 'Estadounidense'),
(21, 'Viktor Frankl', 'Austríaca'),
(22, 'Daniel Kahneman', 'Israelí / Estadounidense'),
(23, 'Sun Tzu', 'China'),
(24, 'Marco Aurelio', 'Romana'),
(25, 'Kathy Sierra & Bert Bates', 'Estadounidense'),
(26, 'Abraham Silberschatz & Henry Korth', 'Estadounidense'),
(27, 'Andrew S. Tanenbaum', 'Estadounidense'),
(28, 'Umberto Eco', 'Italiana'),
(29, 'Franz Kafka', 'Checa'),
(30, 'José Saramago', 'Portuguesa')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), nacionalidad = VALUES(nacionalidad);

-- =====================================================================
-- DATOS INICIALES: CATEGORÍAS
-- =====================================================================

INSERT INTO categorias (id_categoria, nombre, descripcion) VALUES
(1, 'Literatura', 'Obras de ficción, novelas universales y poesía clásica.'),
(2, 'Programación & Software', 'Ingeniería, patrones de diseño, arquitectura y lenguajes.'),
(3, 'Ciencia & Matemáticas', 'Física, cálculo, biología, astronomía y método científico.'),
(4, 'Historia & Sociedad', 'Evolución histórica, antropología y civilizaciones.'),
(5, 'Psicología & Desarrollo', 'Ciencia cognitiva, formación de hábitos y liderazgo.'),
(6, 'Filosofía & Estrategia', 'Pensamiento crítico, estoicismo y tratados clásicos.')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), descripcion = VALUES(descripcion);

-- =====================================================================
-- DATOS INICIALES: 32 LIBROS REALES CON STOCK VARIADO Y PORTADAS
-- =====================================================================

INSERT INTO libros (id_libro, titulo, isbn, anio, descripcion, stock, id_autor, id_categoria, imagen_portada) VALUES
(1, 'Cien años de soledad', '9780307474728', 1967, 'Novela cumbre del realismo mágico sobre la saga de la familia Buendía en Macondo.', 5, 1, 1, 'img/portadas/libro1.svg'),
(2, 'Don Quijote de la Mancha', '9788420412146', 1605, 'Obra maestra de la literatura universal que narra las andanzas del ingenioso hidalgo.', 2, 2, 1, 'img/portadas/libro2.svg'),
(3, 'El Principito', '9780156012195', 1943, 'Obra poética y filosófica sobre el sentido del amor, la amistad y la naturaleza humana.', 8, 3, 1, 'img/portadas/libro3.svg'),
(4, 'Clean Code: Manual de desarrollo ágil de software', '9780132350884', 2008, 'Principios, patrones y mejores prácticas para escribir código limpio, legible y robusto.', 4, 4, 2, 'img/portadas/libro4.svg'),
(5, 'The Pragmatic Programmer', '9780135957059', 1999, 'Guía de maestría profesional para desarrolladores de software modernos y eficientes.', 3, 5, 2, 'img/portadas/libro5.svg'),
(6, 'Design Patterns: Elements of Reusable Object-Oriented Software', '9780201633610', 1994, 'El catálogo fundamental de 23 patrones de diseño orientados a objetos de la Gang of Four.', 1, 6, 2, 'img/portadas/libro6.svg'),
(7, 'Refactoring: Improving the Design of Existing Code', '9780134757599', 1999, 'Técnicas comprobadas para reestructurar código existente sin cambiar su comportamiento.', 0, 7, 2, 'img/portadas/libro7.svg'),
(8, 'Introduction to Algorithms (CLRS)', '9780262033848', 2009, 'La biblia académica de los algoritmos y estructuras de datos para ciencias de la computación.', 6, 8, 2, 'img/portadas/libro8.svg'),
(9, 'Breve historia del tiempo', '9788497593724', 1988, 'Fascinante viaje por el origen del universo, agujeros negros y la física cuántica.', 4, 9, 3, 'img/portadas/libro9.svg'),
(10, 'Cosmos', '9788408053682', 1980, 'Monumental obra de divulgación científica sobre el cosmos, la ciencia y la civilización.', 3, 10, 3, 'img/portadas/libro10.svg'),
(11, 'El gen egoísta', '9788434501782', 1976, 'Una visión revolucionaria de la evolución centrada en la perspectiva del gen.', 2, 11, 3, 'img/portadas/libro11.svg'),
(12, 'Física Universitaria con Física Moderna', '9786073221900', 2013, 'Texto estándar de física para estudiantes de ingeniería y ciencias exactas.', 7, 12, 3, 'img/portadas/libro12.svg'),
(13, 'Cálculo de una variable: Trascendentes tempranas', '9786075220154', 2015, 'Tratado pedagógico integral sobre límites, derivadas, integrales y series.', 5, 13, 3, 'img/portadas/libro13.svg'),
(14, 'Inteligencia Artificial: Un Enfoque Moderno', '9788490355480', 2020, 'El texto de referencia global sobre agentes inteligentes, aprendizaje profundo y robótica.', 2, 14, 2, 'img/portadas/libro14.svg'),
(15, 'Sapiens: De animales a dioses', '9788499926223', 2014, 'Breve historia de la humanidad desde los primeros cazadores hasta la revolución biotecnológica.', 6, 15, 4, 'img/portadas/libro15.svg'),
(16, '1984', '9788499890944', 1949, 'Inmortal novela distópica sobre el Gran Hermano, la vigilancia masiva y el autoritarismo.', 9, 16, 1, 'img/portadas/libro16.svg'),
(17, 'Un mundo feliz', '9788497594257', 1932, 'Profética sátira sobre una sociedad futurista condicionada tecnológicamente.', 0, 17, 1, 'img/portadas/libro17.svg'),
(18, 'Crónica de una muerte anunciada', '9780307475404', 1981, 'Reconstrucción casi periodística del fatídico asesinato de Santiago Nasar.', 4, 1, 1, 'img/portadas/libro18.svg'),
(19, 'Rayuela', '9788466331906', 1963, 'Contranovela revolucionaria de Julio Cortázar que puede leerse en múltiples órdenes.', 3, 18, 1, 'img/portadas/libro19.svg'),
(20, 'Ficciones', '9788420658742', 1944, 'Colección de cuentos laberínticos sobre espejos, bibliotecas infinitas y paradojas.', 5, 19, 1, 'img/portadas/libro20.svg'),
(21, 'Hábitos Atómicos', '9788416883271', 2018, 'Método comprobado para crear buenos hábitos y romper los malos mediante pequeños cambios.', 10, 20, 5, 'img/portadas/libro21.svg'),
(22, 'El hombre en busca de sentido', '9788425432026', 1946, 'Sobrecogedor testimonio de Viktor Frankl en campos de concentración y base de la logoterapia.', 4, 21, 5, 'img/portadas/libro22.svg'),
(23, 'Pensar rápido, pensar despacio', '9788499922072', 2011, 'Análisis magistral de los dos sistemas que dirigen nuestra mente y toma de decisiones.', 2, 22, 5, 'img/portadas/libro23.svg'),
(24, 'El arte de la guerra', '9788497940733', -500, 'Tratado milenario de estrategia, liderazgo, resolución de conflictos y táctica militar.', 6, 23, 6, 'img/portadas/libro24.svg'),
(25, 'Meditaciones', '9788424939106', 180, 'Reflexiones íntimas del emperador filósofo Marco Aurelio sobre el deber y la resiliencia.', 3, 24, 6, 'img/portadas/libro25.svg'),
(26, 'Clean Architecture: Guía para el especialista en software', '9780134494166', 2017, 'Reglas universales de arquitectura de software para crear sistemas desacoplados y testeables.', 0, 4, 2, 'img/portadas/libro26.svg'),
(27, 'Head First Java: Aprende Java con programación orientada a objetos', '9781491910771', 2022, 'Método multisensorial y visual para dominar Java, POO, hilos y programación concurrente.', 5, 25, 2, 'img/portadas/libro27.svg'),
(28, 'Fundamentos de Sistemas de Bases de Datos', '9786071514066', 2019, 'Conceptos esenciales del modelo relacional, SQL, normalización, índices y transacciones ACID.', 4, 26, 2, 'img/portadas/libro28.svg'),
(29, 'Redes de Computadoras', '9786073208178', 2011, 'Tratado clásico de arquitectura de redes, capa de transporte, protocolos TCP/IP e Internet.', 3, 27, 2, 'img/portadas/libro29.svg'),
(30, 'El nombre de la rosa', '9788497592581', 1980, 'Fascinante novela histórica de intriga monástica, herejías y manuscritos prohibidos.', 2, 28, 1, 'img/portadas/libro30.svg'),
(31, 'La metamorfosis', '9788491050292', 1915, 'Relato existencial sobre la soledad y alienación a través de la transformación de Gregor Samsa.', 7, 29, 1, 'img/portadas/libro31.svg'),
(32, 'Ensayo sobre la ceguera', '9788490628720', 1995, 'Parábola conmovedora sobre la condición humana y la solidaridad, pionera en inclusión y empatía.', 4, 30, 1, 'img/portadas/libro32.svg')
ON DUPLICATE KEY UPDATE titulo = VALUES(titulo), stock = VALUES(stock), imagen_portada = VALUES(imagen_portada);

-- =====================================================================
-- DATOS INICIALES: USUARIOS
-- =====================================================================

INSERT INTO usuarios (id_usuario, nombre, correo, password, rol, estado) VALUES
(1, 'Administrador General', 'admin@bookhub.com', '123456', 'ADMIN', 'ACTIVO'),
(2, 'Juan Pérez (Lector 1)', 'juan@bookhub.com', '123456', 'USUARIO', 'ACTIVO'),
(3, 'María López (Lector 2)', 'maria@bookhub.com', '123456', 'USUARIO', 'ACTIVO')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre);

-- =====================================================================
-- DATOS INICIALES: PRÉSTAMOS
-- =====================================================================

INSERT INTO prestamos (id_prestamo, id_usuario, id_libro, fecha_prestamo, fecha_devolucion, estado) VALUES
(1, 2, 1, '23/09/2026', '30/09/2026', 'PRESTADO'),
(2, 3, 2, '22/09/2026', '29/09/2026', 'DEVUELTO'),
(3, 2, 7, '01/11/2026', '08/11/2026', 'PRESTADO'),
(4, 3, 17, '28/10/2026', '04/11/2026', 'PRESTADO'),
(5, 2, 26, '02/11/2026', '09/11/2026', 'PRESTADO')
ON DUPLICATE KEY UPDATE estado = VALUES(estado);

-- =====================================================================
-- DATOS INICIALES: DONACIONES
-- =====================================================================

INSERT INTO donaciones (id_donacion, titulo_libro, autor, categoria, anio, estado_conservacion, nombre_donante, correo_donante, telefono_donante, motivo_mensaje, fecha_solicitud, estado_revision) VALUES
(1, 'El código Da Vinci', 'Dan Brown', 'Literatura', 2003, 'EXCELENTE', 'Carlos Mendoza (Docente)', 'carlos.mendoza@universidad.edu.pe', '987654321', 'Ejemplar en perfecto estado de mi colección personal para la biblioteca.', '07/11/2026', 'PENDIENTE'),
(2, 'Python Crash Course', 'Eric Matthes', 'Programación & Software', 2019, 'BUENO', 'Lucía Fernández (Estudiante Ing.)', 'lucia.fernandez@universidad.edu.pe', '912345678', 'Manual práctico de introducción a Python para el laboratorio de sistemas.', '08/11/2026', 'PENDIENTE'),
(3, 'La ciudad y los perros', 'Mario Vargas Llosa', 'Literatura', 1963, 'EXCELENTE', 'Egresado Promoción 2024', 'donaciones@comunidad.pe', '999888777', 'Clásico de la narrativa para consulta de estudiantes de humanidades.', '05/11/2026', 'APROBADO')
ON DUPLICATE KEY UPDATE estado_revision = VALUES(estado_revision);
