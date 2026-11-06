package dao;

import beans.Prestamo;
import conexion.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PrestamoDAO {

    private static List<Prestamo> prestamos = new ArrayList<>();
    private static int contadorId = 1;

    static {
        prestamos.add(new Prestamo(
                contadorId++,
                2,
                1,
                "23/09/2026",
                "30/09/2026",
                "PRESTADO"
        ));

        prestamos.add(new Prestamo(
                contadorId++,
                3,
                2,
                "22/09/2026",
                "29/09/2026",
                "DEVUELTO"
        ));
    }

    public List<Prestamo> listar() {
        String sql = "SELECT id_prestamo, id_usuario, id_libro, fecha_prestamo, fecha_devolucion, estado FROM prestamos ORDER BY id_prestamo ASC";
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql);
                     ResultSet rs = ps.executeQuery()) {
                    List<Prestamo> listaBD = new ArrayList<>();
                    while (rs.next()) {
                        listaBD.add(new Prestamo(
                                rs.getInt("id_prestamo"),
                                rs.getInt("id_usuario"),
                                rs.getInt("id_libro"),
                                rs.getString("fecha_prestamo"),
                                rs.getString("fecha_devolucion"),
                                rs.getString("estado")
                        ));
                    }
                    if (!listaBD.isEmpty()) {
                        return listaBD;
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Usando datos en memoria para PrestamoDAO: " + e.getMessage());
        }
        return prestamos;
    }

    public Prestamo obtenerPorId(int id) {
        String sql = "SELECT id_prestamo, id_usuario, id_libro, fecha_prestamo, fecha_devolucion, estado FROM prestamos WHERE id_prestamo = ?";
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, id);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            return new Prestamo(
                                    rs.getInt("id_prestamo"),
                                    rs.getInt("id_usuario"),
                                    rs.getInt("id_libro"),
                                    rs.getString("fecha_prestamo"),
                                    rs.getString("fecha_devolucion"),
                                    rs.getString("estado")
                            );
                        }
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Error obtenerPorId PrestamoDAO: " + e.getMessage());
        }

        for (Prestamo prestamo : prestamos) {
            if (prestamo.getIdPrestamo() == id) {
                return prestamo;
            }
        }
        return null;
    }

    public void agregar(Prestamo prestamo) {
        String sql = "INSERT INTO prestamos (id_usuario, id_libro, fecha_prestamo, fecha_devolucion, estado) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, prestamo.getIdUsuario());
                    ps.setInt(2, prestamo.getIdLibro());
                    ps.setString(3, prestamo.getFechaPrestamo());
                    ps.setString(4, prestamo.getFechaDevolucion());
                    ps.setString(5, prestamo.getEstado());
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            System.out.println("Error agregar PrestamoDAO: " + e.getMessage());
        }

        prestamo.setIdPrestamo(contadorId++);
        prestamos.add(prestamo);
    }

    public void actualizar(Prestamo prestamo) {
        String sql = "UPDATE prestamos SET id_usuario = ?, id_libro = ?, fecha_prestamo = ?, fecha_devolucion = ?, estado = ? WHERE id_prestamo = ?";
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, prestamo.getIdUsuario());
                    ps.setInt(2, prestamo.getIdLibro());
                    ps.setString(3, prestamo.getFechaPrestamo());
                    ps.setString(4, prestamo.getFechaDevolucion());
                    ps.setString(5, prestamo.getEstado());
                    ps.setInt(6, prestamo.getIdPrestamo());
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            System.out.println("Error actualizar PrestamoDAO: " + e.getMessage());
        }

        for (int i = 0; i < prestamos.size(); i++) {
            if (prestamos.get(i).getIdPrestamo() == prestamo.getIdPrestamo()) {
                prestamos.set(i, prestamo);
                break;
            }
        }
    }

    public void eliminar(int id) {
        String sql = "DELETE FROM prestamos WHERE id_prestamo = ?";
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, id);
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            System.out.println("Error eliminar PrestamoDAO: " + e.getMessage());
        }

        prestamos.removeIf(prestamo -> prestamo.getIdPrestamo() == id);
    }
}
