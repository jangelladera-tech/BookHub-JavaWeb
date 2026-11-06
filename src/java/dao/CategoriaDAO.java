package dao;

import beans.Categoria;
import conexion.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CategoriaDAO {

    private static List<Categoria> categorias = new ArrayList<>();
    private static int contadorId = 1;

    static {
        categorias.add(new Categoria(
                contadorId++,
                "Novela",
                "Obras narrativas de ficción y literatura clásica."
        ));

        categorias.add(new Categoria(
                contadorId++,
                "Programación",
                "Libros relacionados con ingeniería y desarrollo de software."
        ));

        categorias.add(new Categoria(
                contadorId++,
                "Ciencia",
                "Libros relacionados con ciencias exactas, física e investigación."
        ));
    }

    // ============================
    // LISTAR
    // ============================

    public List<Categoria> listar() {
        String sql = "SELECT id_categoria, nombre, descripcion FROM categorias WHERE nombre NOT LIKE 'ODS 09%' ORDER BY id_categoria ASC";
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql);
                     ResultSet rs = ps.executeQuery()) {
                    List<Categoria> listaBD = new ArrayList<>();
                    while (rs.next()) {
                        listaBD.add(new Categoria(
                                rs.getInt("id_categoria"),
                                rs.getString("nombre"),
                                rs.getString("descripcion")
                        ));
                    }
                    if (!listaBD.isEmpty()) {
                        return listaBD;
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Usando datos en memoria para CategoriaDAO: " + e.getMessage());
        }
        return categorias;
    }

    // ============================
    // OBTENER POR ID
    // ============================

    public Categoria obtenerPorId(int id) {
        String sql = "SELECT id_categoria, nombre, descripcion FROM categorias WHERE id_categoria = ?";
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, id);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            return new Categoria(
                                    rs.getInt("id_categoria"),
                                    rs.getString("nombre"),
                                    rs.getString("descripcion")
                            );
                        }
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Error obtenerPorId CategoriaDAO: " + e.getMessage());
        }

        for (Categoria categoria : categorias) {
            if (categoria.getIdCategoria() == id) {
                return categoria;
            }
        }
        return null;
    }

    // ============================
    // AGREGAR
    // ============================

    public void agregar(Categoria categoria) {
        String sql = "INSERT INTO categorias (nombre, descripcion) VALUES (?, ?)";
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setString(1, categoria.getNombre());
                    ps.setString(2, categoria.getDescripcion());
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            System.out.println("Error agregar CategoriaDAO: " + e.getMessage());
        }

        categoria.setIdCategoria(contadorId++);
        categorias.add(categoria);
    }

    // ============================
    // ACTUALIZAR
    // ============================

    public void actualizar(Categoria categoria) {
        String sql = "UPDATE categorias SET nombre = ?, descripcion = ? WHERE id_categoria = ?";
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setString(1, categoria.getNombre());
                    ps.setString(2, categoria.getDescripcion());
                    ps.setInt(3, categoria.getIdCategoria());
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            System.out.println("Error actualizar CategoriaDAO: " + e.getMessage());
        }

        for (int i = 0; i < categorias.size(); i++) {
            if (categorias.get(i).getIdCategoria() == categoria.getIdCategoria()) {
                categorias.set(i, categoria);
                break;
            }
        }
    }

    // ============================
    // ELIMINAR
    // ============================

    public void eliminar(int id) {
        String sql = "DELETE FROM categorias WHERE id_categoria = ?";
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, id);
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            System.out.println("Error eliminar CategoriaDAO: " + e.getMessage());
        }

        categorias.removeIf(categoria -> categoria.getIdCategoria() == id);
    }
}
