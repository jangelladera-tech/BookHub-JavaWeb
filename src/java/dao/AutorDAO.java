package dao;

import beans.Autor;
import conexion.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AutorDAO {

    private static List<Autor> autores = new ArrayList<>();
    private static int contadorId = 1;

    static {
        autores.add(new Autor(
                contadorId++,
                "Gabriel García Márquez",
                "Colombiana"
        ));

        autores.add(new Autor(
                contadorId++,
                "Miguel de Cervantes",
                "Española"
        ));

        autores.add(new Autor(
                contadorId++,
                "Antoine de Saint-Exupéry",
                "Francesa"
        ));

        autores.add(new Autor(
                contadorId++,
                "Robert C. Martin",
                "Estadounidense"
        ));
    }

    // ============================
    // LISTAR
    // ============================

    public List<Autor> listar() {
        String sql = "SELECT id_autor, nombre, nacionalidad FROM autores ORDER BY id_autor ASC";
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql);
                     ResultSet rs = ps.executeQuery()) {
                    List<Autor> listaBD = new ArrayList<>();
                    while (rs.next()) {
                        listaBD.add(new Autor(
                                rs.getInt("id_autor"),
                                rs.getString("nombre"),
                                rs.getString("nacionalidad")
                        ));
                    }
                    if (!listaBD.isEmpty()) {
                        return listaBD;
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Usando datos en memoria para AutorDAO: " + e.getMessage());
        }
        return autores;
    }

    // ============================
    // OBTENER POR ID
    // ============================

    public Autor obtenerPorId(int id) {
        String sql = "SELECT id_autor, nombre, nacionalidad FROM autores WHERE id_autor = ?";
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, id);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            return new Autor(
                                    rs.getInt("id_autor"),
                                    rs.getString("nombre"),
                                    rs.getString("nacionalidad")
                            );
                        }
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Error obtenerPorId AutorDAO: " + e.getMessage());
        }

        for (Autor autor : autores) {
            if (autor.getIdAutor() == id) {
                return autor;
            }
        }
        return null;
    }

    // ============================
    // AGREGAR
    // ============================

    public void agregar(Autor autor) {
        String sql = "INSERT INTO autores (nombre, nacionalidad) VALUES (?, ?)";
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setString(1, autor.getNombre());
                    ps.setString(2, autor.getNacionalidad());
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            System.out.println("Error agregar AutorDAO: " + e.getMessage());
        }

        autor.setIdAutor(contadorId++);
        autores.add(autor);
    }

    // ============================
    // ACTUALIZAR
    // ============================

    public void actualizar(Autor autor) {
        String sql = "UPDATE autores SET nombre = ?, nacionalidad = ? WHERE id_autor = ?";
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setString(1, autor.getNombre());
                    ps.setString(2, autor.getNacionalidad());
                    ps.setInt(3, autor.getIdAutor());
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            System.out.println("Error actualizar AutorDAO: " + e.getMessage());
        }

        for (int i = 0; i < autores.size(); i++) {
            if (autores.get(i).getIdAutor() == autor.getIdAutor()) {
                autores.set(i, autor);
                break;
            }
        }
    }

    // ============================
    // ELIMINAR
    // ============================

    public void eliminar(int id) {
        String sql = "DELETE FROM autores WHERE id_autor = ?";
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, id);
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            System.out.println("Error eliminar AutorDAO: " + e.getMessage());
        }

        autores.removeIf(autor -> autor.getIdAutor() == id);
    }
}
