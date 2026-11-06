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

    private static List<Libro> libros = new ArrayList<>();
    private static int contadorId = 1;
    private static boolean columnaVerificada = false;

    static {
        libros.add(new Libro(
                contadorId++,
                "Cien años de soledad",
                "9780307474728",
                1967,
                "Novela cumbre del realismo mágico escrita por el colombiano Gabriel García Márquez.",
                5,
                1,
                "Gabriel García Márquez",
                1,
                "Novela",
                "img/portadas/libro1.svg"
        ));

        libros.add(new Libro(
                contadorId++,
                "Don Quijote de la Mancha",
                "9788420412146",
                1605,
                "Obra clásica universal de la literatura española escrita por Miguel de Cervantes.",
                2,
                2,
                "Miguel de Cervantes",
                1,
                "Novela",
                "img/portadas/libro2.svg"
        ));

        libros.add(new Libro(
                contadorId++,
                "El Principito",
                "9780156012195",
                1943,
                "Obra literaria y filosófica de Antoine de Saint-Exupéry sobre la amistad y el sentido de la vida.",
                7,
                3,
                "Antoine de Saint-Exupéry",
                1,
                "Novela",
                "img/portadas/libro3.svg"
        ));

        libros.add(new Libro(
                contadorId++,
                "Clean Code: Manual de desarrollo ágil de software",
                "9780132350884",
                2008,
                "Principios, patrones y buenas prácticas para escribir código limpio y mantenible.",
                4,
                4,
                "Robert C. Martin",
                2,
                "Programación",
                "img/portadas/libro4.svg"
        ));
    }

    private void asegurarColumnaPortada(Connection con) {
        if (columnaVerificada || con == null) {
            return;
        }
        columnaVerificada = true;
        try (Statement st = con.createStatement()) {
            st.executeUpdate("ALTER TABLE libros ADD COLUMN imagen_portada LONGTEXT");
        } catch (SQLException ignored) {
            // La columna ya existe
        }
        try (Statement st = con.createStatement()) {
            st.executeUpdate("DELETE FROM libros WHERE titulo LIKE '%(ODS 09)%'");
            st.executeUpdate("DELETE FROM categorias WHERE nombre LIKE 'ODS 09%'");
            st.executeUpdate("DELETE FROM autores WHERE nombre IN ('Klaus Schwab', 'ONU Hábitat / CEPAL')");
        } catch (SQLException ignored) {
        }
    }

    // ============================
    // LISTAR
    // ============================

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

        return libros;
    }

    // ============================
    // OBTENER POR ID
    // ============================

    public Libro obtenerPorId(int id) {
        String sql = "SELECT l.id_libro, l.titulo, l.isbn, l.anio, l.descripcion, l.stock, "
                + "l.id_autor, COALESCE(a.nombre, 'Autor General') AS nombre_autor, "
                + "l.id_categoria, COALESCE(c.nombre, 'General') AS nombre_categoria, "
                + "l.imagen_portada "
                + "FROM libros l "
                + "LEFT JOIN autores a ON l.id_autor = a.id_autor "
                + "LEFT JOIN categorias c ON l.id_categoria = c.id_categoria "
                + "WHERE l.id_libro = ?";

        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                asegurarColumnaPortada(con);
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, id);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            return new Libro(
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
                            );
                        }
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Error obtenerPorId LibroDAO: " + e.getMessage());
        }

        for (Libro libro : libros) {
            if (libro.getIdLibro() == id) {
                return libro;
            }
        }
        return null;
    }

    // ============================
    // BUSCAR / FILTRAR CATÁLOGO
    // ============================

    public List<Libro> buscar(String termino, String categoriaFiltro) {
        List<Libro> base = listar();
        List<Libro> resultado = new ArrayList<>();

        String q = (termino != null) ? termino.trim().toLowerCase() : "";
        String cat = (categoriaFiltro != null) ? categoriaFiltro.trim().toLowerCase() : "";

        for (Libro libro : base) {
            boolean coincideTexto = q.isEmpty()
                    || (libro.getTitulo() != null && libro.getTitulo().toLowerCase().contains(q))
                    || (libro.getNombreAutor() != null && libro.getNombreAutor().toLowerCase().contains(q))
                    || (libro.getNombreCategoria() != null && libro.getNombreCategoria().toLowerCase().contains(q))
                    || (libro.getIsbn() != null && libro.getIsbn().toLowerCase().contains(q))
                    || (libro.getDescripcion() != null && libro.getDescripcion().toLowerCase().contains(q));

            boolean coincideCategoria = cat.isEmpty()
                    || "todas".equals(cat)
                    || (libro.getNombreCategoria() != null && libro.getNombreCategoria().toLowerCase().contains(cat));

            if (coincideTexto && coincideCategoria) {
                resultado.add(libro);
            }
        }
        return resultado;
    }

    // ============================
    // AGREGAR
    // ============================

    public void agregar(Libro libro) {
        if (libro.getNombreAutor() == null || libro.getNombreAutor().isEmpty()) {
            libro.setNombreAutor("Autor General");
        }
        if (libro.getNombreCategoria() == null || libro.getNombreCategoria().isEmpty()) {
            libro.setNombreCategoria("General");
        }

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
                    ps.setInt(6, libro.getIdAutor() > 0 ? libro.getIdAutor() : 1);
                    ps.setInt(7, libro.getIdCategoria() > 0 ? libro.getIdCategoria() : 1);
                    ps.setString(8, libro.getImagenPortada());
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            System.out.println("Error agregar LibroDAO: " + e.getMessage());
        }

        libro.setIdLibro(contadorId++);
        libros.add(libro);
    }

    // ============================
    // ACTUALIZAR
    // ============================

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
                    ps.setInt(6, libro.getIdAutor() > 0 ? libro.getIdAutor() : 1);
                    ps.setInt(7, libro.getIdCategoria() > 0 ? libro.getIdCategoria() : 1);
                    ps.setString(8, libro.getImagenPortada());
                    ps.setInt(9, libro.getIdLibro());
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            System.out.println("Error actualizar LibroDAO: " + e.getMessage());
        }

        for (int i = 0; i < libros.size(); i++) {
            if (libros.get(i).getIdLibro() == libro.getIdLibro()) {
                Libro actual = libros.get(i);
                if (libro.getNombreAutor() == null || libro.getNombreAutor().isEmpty()) {
                    libro.setIdAutor(actual.getIdAutor());
                    libro.setNombreAutor(actual.getNombreAutor());
                }
                if (libro.getNombreCategoria() == null || libro.getNombreCategoria().isEmpty()) {
                    libro.setIdCategoria(actual.getIdCategoria());
                    libro.setNombreCategoria(actual.getNombreCategoria());
                }
                libros.set(i, libro);
                break;
            }
        }
    }

    // ============================
    // ELIMINAR
    // ============================

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

        libros.removeIf(libro -> libro.getIdLibro() == id);
    }
}
