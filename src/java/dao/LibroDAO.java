package dao;

import beans.Libro;
import conexion.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class LibroDAO {

    private static List<Libro> librosMemoria = new ArrayList<>();
    private static int contadorId = 1;
    private static boolean columnaVerificada = false;

    static {
        Object[][] librosData = new Object[][]{
            {1, "Cien años de soledad", "9780307474728", 1967, "Novela cumbre del realismo mágico sobre la saga de la familia Buendía en Macondo.", 5, 1, "Gabriel García Márquez", 1, "Literatura", "img/portadas/libro1.svg"},
            {2, "Don Quijote de la Mancha", "9788420412146", 1605, "Obra maestra de la literatura universal que narra las andanzas del ingenioso hidalgo.", 2, 2, "Miguel de Cervantes", 1, "Literatura", "img/portadas/libro2.svg"},
            {3, "El Principito", "9780156012195", 1943, "Obra poética y filosófica sobre el sentido del amor, la amistad y la naturaleza humana.", 8, 3, "Antoine de Saint-Exupéry", 1, "Literatura", "img/portadas/libro3.svg"},
            {4, "Clean Code: Manual de desarrollo ágil de software", "9780132350884", 2008, "Principios, patrones y mejores prácticas para escribir código limpio, legible y robusto.", 4, 4, "Robert C. Martin", 2, "Programación & Software", "img/portadas/libro4.svg"},
            {5, "The Pragmatic Programmer", "9780135957059", 1999, "Guía de maestría profesional para desarrolladores de software modernos y eficientes.", 3, 5, "Andrew Hunt & David Thomas", 2, "Programación & Software", "img/portadas/libro5.svg"},
            {6, "Design Patterns: Elements of Reusable Object-Oriented Software", "9780201633610", 1994, "El catálogo fundamental de 23 patrones de diseño orientados a objetos de la Gang of Four.", 1, 6, "Erich Gamma et al. (GoF)", 2, "Programación & Software", "img/portadas/libro6.svg"},
            {7, "Refactoring: Improving the Design of Existing Code", "9780134757599", 1999, "Técnicas comprobadas para reestructurar código existente sin cambiar su comportamiento.", 0, 7, "Martin Fowler", 2, "Programación & Software", "img/portadas/libro7.svg"},
            {8, "Introduction to Algorithms (CLRS)", "9780262033848", 2009, "La biblia académica de los algoritmos y estructuras de datos para ciencias de la computación.", 6, 8, "Thomas H. Cormen", 2, "Programación & Software", "img/portadas/libro8.svg"},
            {9, "Breve historia del tiempo", "9788497593724", 1988, "Fascinante viaje por el origen del universo, agujeros negros y la física cuántica.", 4, 9, "Stephen Hawking", 3, "Ciencia & Matemáticas", "img/portadas/libro9.svg"},
            {10, "Cosmos", "9788408053682", 1980, "Monumental obra de divulgación científica sobre el cosmos, la ciencia y la civilización.", 3, 10, "Carl Sagan", 3, "Ciencia & Matemáticas", "img/portadas/libro10.svg"},
            {11, "El gen egoísta", "9788434501782", 1976, "Una visión revolucionaria de la evolución centrada en la perspectiva del gen.", 2, 11, "Richard Dawkins", 3, "Ciencia & Matemáticas", "img/portadas/libro11.svg"},
            {12, "Física Universitaria con Física Moderna", "9786073221900", 2013, "Texto estándar de física para estudiantes de ingeniería y ciencias exactas.", 7, 12, "Francis Sears & Mark Zemansky", 3, "Ciencia & Matemáticas", "img/portadas/libro12.svg"},
            {13, "Cálculo de una variable: Trascendentes tempranas", "9786075220154", 2015, "Tratado pedagógico integral sobre límites, derivadas, integrales y series.", 5, 13, "James Stewart", 3, "Ciencia & Matemáticas", "img/portadas/libro13.svg"},
            {14, "Inteligencia Artificial: Un Enfoque Moderno", "9788490355480", 2020, "El texto de referencia global sobre agentes inteligentes, aprendizaje profundo y robótica.", 2, 14, "Stuart Russell & Peter Norvig", 2, "Programación & Software", "img/portadas/libro14.svg"},
            {15, "Sapiens: De animales a dioses", "9788499926223", 2014, "Breve historia de la humanidad desde los primeros cazadores hasta la revolución biotecnológica.", 6, 15, "Yuval Noah Harari", 4, "Historia & Sociedad", "img/portadas/libro15.svg"},
            {16, "1984", "9788499890944", 1949, "Inmortal novela distópica sobre el Gran Hermano, la vigilancia masiva y el autoritarismo.", 9, 16, "George Orwell", 1, "Literatura", "img/portadas/libro16.svg"},
            {17, "Un mundo feliz", "9788497594257", 1932, "Profética sátira sobre una sociedad futurista condicionada tecnológicamente.", 0, 17, "Aldous Huxley", 1, "Literatura", "img/portadas/libro17.svg"},
            {18, "Crónica de una muerte anunciada", "9780307475404", 1981, "Reconstrucción casi periodística del fatídico asesinato de Santiago Nasar.", 4, 1, "Gabriel García Márquez", 1, "Literatura", "img/portadas/libro18.svg"},
            {19, "Rayuela", "9788466331906", 1963, "Contranovela revolucionaria de Julio Cortázar que puede leerse en múltiples órdenes.", 3, 18, "Julio Cortázar", 1, "Literatura", "img/portadas/libro19.svg"},
            {20, "Ficciones", "9788420658742", 1944, "Colección de cuentos laberínticos sobre espejos, bibliotecas infinitas y paradojas.", 5, 19, "Jorge Luis Borges", 1, "Literatura", "img/portadas/libro20.svg"},
            {21, "Hábitos Atómicos", "9788416883271", 2018, "Método comprobado para crear buenos hábitos y romper los malos mediante pequeños cambios.", 10, 20, "James Clear", 5, "Psicología & Desarrollo", "img/portadas/libro21.svg"},
            {22, "El hombre en busca de sentido", "9788425432026", 1946, "Sobrecogedor testimonio de Viktor Frankl en campos de concentración y base de la logoterapia.", 4, 21, "Viktor Frankl", 5, "Psicología & Desarrollo", "img/portadas/libro22.svg"},
            {23, "Pensar rápido, pensar despacio", "9788499922072", 2011, "Análisis magistral de los dos sistemas que dirigen nuestra mente y toma de decisiones.", 2, 22, "Daniel Kahneman", 5, "Psicología & Desarrollo", "img/portadas/libro23.svg"},
            {24, "El arte de la guerra", "9788497940733", -500, "Tratado milenario de estrategia, liderazgo, resolución de conflictos y táctica militar.", 6, 23, "Sun Tzu", 6, "Filosofía & Estrategia", "img/portadas/libro24.svg"},
            {25, "Meditaciones", "9788424939106", 180, "Reflexiones íntimas del emperador filósofo Marco Aurelio sobre el deber y la resiliencia.", 3, 24, "Marco Aurelio", 6, "Filosofía & Estrategia", "img/portadas/libro25.svg"},
            {26, "Clean Architecture: Guía para el especialista en software", "9780134494166", 2017, "Reglas universales de arquitectura de software para crear sistemas desacoplados y testeables.", 0, 4, "Robert C. Martin", 2, "Programación & Software", "img/portadas/libro26.svg"},
            {27, "Head First Java: Aprende Java con programación orientada a objetos", "9781491910771", 2022, "Método multisensorial y visual para dominar Java, POO, hilos y programación concurrente.", 5, 25, "Kathy Sierra & Bert Bates", 2, "Programación & Software", "img/portadas/libro27.svg"},
            {28, "Fundamentos de Sistemas de Bases de Datos", "9786071514066", 2019, "Conceptos esenciales del modelo relacional, SQL, normalización, índices y transacciones ACID.", 4, 26, "Abraham Silberschatz & Henry Korth", 2, "Programación & Software", "img/portadas/libro28.svg"},
            {29, "Redes de Computadoras", "9786073208178", 2011, "Tratado clásico de arquitectura de redes, capa de transporte, protocolos TCP/IP e Internet.", 3, 27, "Andrew S. Tanenbaum", 2, "Programación & Software", "img/portadas/libro29.svg"},
            {30, "El nombre de la rosa", "9788497592581", 1980, "Fascinante novela histórica de intriga monástica, herejías y manuscritos prohibidos.", 2, 28, "Umberto Eco", 1, "Literatura", "img/portadas/libro30.svg"},
            {31, "La metamorfosis", "9788491050292", 1915, "Relato existencial sobre la soledad y alienación a través de la transformación de Gregor Samsa.", 7, 29, "Franz Kafka", 1, "Literatura", "img/portadas/libro31.svg"},
            {32, "Ensayo sobre la ceguera", "9788490628720", 1995, "Parábola conmovedora sobre la condición humana y la solidaridad, pionera en inclusión y empatía.", 4, 30, "José Saramago", 1, "Literatura", "img/portadas/libro32.svg"}
        };

        for (Object[] d : librosData) {
            librosMemoria.add(new Libro(
                    (Integer) d[0],
                    (String) d[1],
                    (String) d[2],
                    (Integer) d[3],
                    (String) d[4],
                    (Integer) d[5],
                    (Integer) d[6],
                    (String) d[7],
                    (Integer) d[8],
                    (String) d[9],
                    (String) d[10]
            ));
            contadorId = Math.max(contadorId, (Integer) d[0] + 1);
        }
    }

    private void asegurarColumnaPortada(Connection con) {
        if (columnaVerificada || con == null) {
            return;
        }
        columnaVerificada = true;
        try (Statement st = con.createStatement()) {
            st.executeUpdate("ALTER TABLE libros ADD COLUMN imagen_portada LONGTEXT");
        } catch (SQLException ignored) {
        }
    }

    public List<Libro> listar() {
        String sql = "SELECT l.id_libro, l.titulo, l.isbn, l.anio, l.descripcion, l.stock, "
                + "l.id_autor, COALESCE(a.nombre, 'Autor General') AS nombre_autor, "
                + "l.id_categoria, COALESCE(c.nombre, 'General') AS nombre_categoria, "
                + "l.imagen_portada "
                + "FROM libros l "
                + "LEFT JOIN autores a ON l.id_autor = a.id_autor "
                + "LEFT JOIN categorias c ON l.id_categoria = c.id_categoria "
                + "ORDER BY l.id_libro ASC";

        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                asegurarColumnaPortada(con);
                try (PreparedStatement ps = con.prepareStatement(sql);
                     ResultSet rs = ps.executeQuery()) {
                    List<Libro> listaBD = new ArrayList<>();
                    while (rs.next()) {
                        listaBD.add(new Libro(
                                rs.getInt("id_libro"),
                                rs.getString("titulo"),
                                rs.getString("isbn"),
                                rs.getInt("anio"),
                                rs.getString("descripcion"),
                                rs.getInt("stock"),
                                rs.getInt("id_autor"),
                                rs.getString("nombre_autor"),
                                rs.getInt("id_categoria"),
                                rs.getString("nombre_categoria"),
                                rs.getString("imagen_portada")
                        ));
                    }
                    if (!listaBD.isEmpty()) {
                        return listaBD;
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Usando datos en memoria para LibroDAO: " + e.getMessage());
        }
        return new ArrayList<>(librosMemoria);
    }

    public List<Libro> buscar(String busqueda, String categoria) {
        List<Libro> todos = listar();
        if ((busqueda == null || busqueda.trim().isEmpty())
                && (categoria == null || categoria.trim().isEmpty() || "todas".equalsIgnoreCase(categoria.trim()))) {
            return todos;
        }

        String q = busqueda != null ? busqueda.trim().toLowerCase() : "";
        String cat = categoria != null ? categoria.trim().toLowerCase() : "";
        if ("todas".equalsIgnoreCase(cat)) {
            cat = "";
        }

        List<Libro> filtrados = new ArrayList<>();
        for (Libro l : todos) {
            boolean coincideTexto = q.isEmpty();
            if (!coincideTexto) {
                String tit = l.getTitulo() != null ? l.getTitulo().toLowerCase() : "";
                String aut = l.getNombreAutor() != null ? l.getNombreAutor().toLowerCase() : "";
                String isbn = l.getIsbn() != null ? l.getIsbn().toLowerCase() : "";
                String desc = l.getDescripcion() != null ? l.getDescripcion().toLowerCase() : "";
                String cname = l.getNombreCategoria() != null ? l.getNombreCategoria().toLowerCase() : "";
                if (tit.contains(q) || aut.contains(q) || isbn.contains(q) || desc.contains(q) || cname.contains(q)) {
                    coincideTexto = true;
                }
            }

            boolean coincideCat = cat.isEmpty();
            if (!coincideCat) {
                String cname = l.getNombreCategoria() != null ? l.getNombreCategoria().toLowerCase() : "";
                if (cname.equalsIgnoreCase(cat) || cname.contains(cat) || String.valueOf(l.getIdCategoria()).equals(cat)) {
                    coincideCat = true;
                }
            }

            if (coincideTexto && coincideCat) {
                filtrados.add(l);
            }
        }
        return filtrados;
    }

    public Libro obtenerPorId(int id) {
        for (Libro libro : listar()) {
            if (libro.getIdLibro() == id) {
                return libro;
            }
        }
        return null;
    }

    public void agregar(Libro libro) {
        String sql = "INSERT INTO libros (titulo, isbn, anio, descripcion, stock, id_autor, id_categoria, imagen_portada) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                asegurarColumnaPortada(con);
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setString(1, libro.getTitulo());
                    ps.setString(2, libro.getIsbn());
                    ps.setInt(3, libro.getAnio());
                    ps.setString(4, libro.getDescripcion());
                    ps.setInt(5, libro.getStock());
                    ps.setInt(6, libro.getIdAutor());
                    ps.setInt(7, libro.getIdCategoria());
                    ps.setString(8, libro.getImagenPortada());
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            System.out.println("Error agregar LibroDAO: " + e.getMessage());
        }

        libro.setIdLibro(contadorId++);
        librosMemoria.add(libro);
    }

    public void actualizar(Libro libro) {
        String sql = "UPDATE libros SET titulo = ?, isbn = ?, anio = ?, descripcion = ?, stock = ?, id_autor = ?, id_categoria = ?, imagen_portada = ? WHERE id_libro = ?";
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                asegurarColumnaPortada(con);
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setString(1, libro.getTitulo());
                    ps.setString(2, libro.getIsbn());
                    ps.setInt(3, libro.getAnio());
                    ps.setString(4, libro.getDescripcion());
                    ps.setInt(5, libro.getStock());
                    ps.setInt(6, libro.getIdAutor());
                    ps.setInt(7, libro.getIdCategoria());
                    ps.setString(8, libro.getImagenPortada());
                    ps.setInt(9, libro.getIdLibro());
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            System.out.println("Error actualizar LibroDAO: " + e.getMessage());
        }

        for (int i = 0; i < librosMemoria.size(); i++) {
            if (librosMemoria.get(i).getIdLibro() == libro.getIdLibro()) {
                librosMemoria.set(i, libro);
                break;
            }
        }
    }

    public boolean ajustarStock(int idLibro, int cambio) {
        String sql = "UPDATE libros SET stock = GREATEST(0, stock + ?) WHERE id_libro = ?";
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, cambio);
                    ps.setInt(2, idLibro);
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            System.out.println("Error ajustarStock LibroDAO: " + e.getMessage());
        }

        for (Libro l : librosMemoria) {
            if (l.getIdLibro() == idLibro) {
                l.setStock(Math.max(0, l.getStock() + cambio));
                return true;
            }
        }
        return false;
    }

    public void eliminar(int id) {
        String sql = "DELETE FROM libros WHERE id_libro = ?";
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, id);
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            System.out.println("Error eliminar LibroDAO: " + e.getMessage());
        }

        librosMemoria.removeIf(l -> l.getIdLibro() == id);
    }
}
