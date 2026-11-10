package modelo.dao;

import modelo.beans.Categoria;
import modelo.conexion.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CategoriaDAO {

    private static List<Categoria> categoriasMemoria = new ArrayList<>();
    private static int contadorId = 1;

    static {
        Object[][] catsData = new Object[][]{
            {1, "Literatura", "Obras de ficción, novelas universales y poesía clásica."},
            {2, "Programación & Software", "Ingeniería, patrones de diseño, arquitectura y lenguajes."},
            {3, "Ciencia & Matemáticas", "Física, cálculo, biología, astronomía y método científico."},
            {4, "Historia & Sociedad", "Evolución histórica, antropología y civilizaciones."},
            {5, "Psicología & Desarrollo", "Ciencia cognitiva, formación de hábitos y liderazgo."},
            {6, "Filosofía & Estrategia", "Pensamiento crítico, estoicismo y tratados clásicos."}
        };

        for (Object[] c : catsData) {
            categoriasMemoria.add(new Categoria((Integer) c[0], (String) c[1], (String) c[2]));
            contadorId = Math.max(contadorId, (Integer) c[0] + 1);
        }
    }

    public List<Categoria> listar() {
        String sql = "SELECT id_categoria, nombre, descripcion FROM categorias ORDER BY id_categoria ASC";
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
        return new ArrayList<>(categoriasMemoria);
    }

    public Categoria obtenerPorId(int id) {
        for (Categoria c : listar()) {
            if (c.getIdCategoria() == id) {
                return c;
            }
        }
        return null;
    }

    public void agregar(Categoria categoria) {
        String sql = "INSERT INTO categorias (nombre, descripcion) VALUES (?, ?)";
        int idGenerado = -1;
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, categoria.getNombre());
                    ps.setString(2, categoria.getDescripcion());
                    ps.executeUpdate();
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            idGenerado = rs.getInt(1);
                            categoria.setIdCategoria(idGenerado);
                        }
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Error agregar CategoriaDAO: " + e.getMessage());
        }

        if (idGenerado == -1) {
            categoria.setIdCategoria(contadorId++);
        } else {
            contadorId = Math.max(contadorId, idGenerado + 1);
        }
        categoriasMemoria.add(categoria);
    }

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

        for (int i = 0; i < categoriasMemoria.size(); i++) {
            if (categoriasMemoria.get(i).getIdCategoria() == categoria.getIdCategoria()) {
                categoriasMemoria.set(i, categoria);
                break;
            }
        }
    }

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

        categoriasMemoria.removeIf(c -> c.getIdCategoria() == id);
    }
}
