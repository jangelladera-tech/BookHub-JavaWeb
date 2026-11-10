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

    private static List<Autor> autoresMemoria = new ArrayList<>();
    private static int contadorId = 1;

    static {
        Object[][] autoresData = new Object[][]{
            {1, "Gabriel García Márquez", "Colombiana"},
            {2, "Miguel de Cervantes", "Española"},
            {3, "Antoine de Saint-Exupéry", "Francesa"},
            {4, "Robert C. Martin", "Estadounidense"},
            {5, "Andrew Hunt & David Thomas", "Estadounidense"},
            {6, "Erich Gamma et al. (GoF)", "Suiza / Internacional"},
            {7, "Martin Fowler", "Británica"},
            {8, "Thomas H. Cormen", "Estadounidense"},
            {9, "Stephen Hawking", "Británica"},
            {10, "Carl Sagan", "Estadounidense"},
            {11, "Richard Dawkins", "Británica"},
            {12, "Francis Sears & Mark Zemansky", "Estadounidense"},
            {13, "James Stewart", "Canadiense"},
            {14, "Stuart Russell & Peter Norvig", "Estadounidense"},
            {15, "Yuval Noah Harari", "Israelí"},
            {16, "George Orwell", "Británica"},
            {17, "Aldous Huxley", "Británica"},
            {18, "Julio Cortázar", "Argentina"},
            {19, "Jorge Luis Borges", "Argentina"},
            {20, "James Clear", "Estadounidense"},
            {21, "Viktor Frankl", "Austríaca"},
            {22, "Daniel Kahneman", "Israelí / Estadounidense"},
            {23, "Sun Tzu", "China"},
            {24, "Marco Aurelio", "Romana"},
            {25, "Kathy Sierra & Bert Bates", "Estadounidense"},
            {26, "Abraham Silberschatz & Henry Korth", "Estadounidense"},
            {27, "Andrew S. Tanenbaum", "Estadounidense"},
            {28, "Umberto Eco", "Italiana"},
            {29, "Franz Kafka", "Checa"},
            {30, "José Saramago", "Portuguesa"}
        };

        for (Object[] a : autoresData) {
            autoresMemoria.add(new Autor((Integer) a[0], (String) a[1], (String) a[2]));
            contadorId = Math.max(contadorId, (Integer) a[0] + 1);
        }
    }

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
        return new ArrayList<>(autoresMemoria);
    }

    public Autor obtenerPorId(int id) {
        for (Autor a : listar()) {
            if (a.getIdAutor() == id) {
                return a;
            }
        }
        return null;
    }

    public void agregar(Autor autor) {
        String sql = "INSERT INTO autores (nombre, nacionalidad) VALUES (?, ?)";
        int idGenerado = -1;
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, autor.getNombre());
                    ps.setString(2, autor.getNacionalidad());
                    ps.executeUpdate();
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            idGenerado = rs.getInt(1);
                            autor.setIdAutor(idGenerado);
                        }
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Error agregar AutorDAO: " + e.getMessage());
        }

        if (idGenerado == -1) {
            autor.setIdAutor(contadorId++);
        } else {
            contadorId = Math.max(contadorId, idGenerado + 1);
        }
        autoresMemoria.add(autor);
    }

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

        for (int i = 0; i < autoresMemoria.size(); i++) {
            if (autoresMemoria.get(i).getIdAutor() == autor.getIdAutor()) {
                autoresMemoria.set(i, autor);
                break;
            }
        }
    }

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

        autoresMemoria.removeIf(a -> a.getIdAutor() == id);
    }
}
