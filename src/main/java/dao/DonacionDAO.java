package dao;

import beans.Donacion;
import conexion.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class DonacionDAO {

    private static List<Donacion> donacionesMemoria = new ArrayList<>();
    private static int contadorId = 1;
    private static boolean tablaVerificada = false;

    static {
        donacionesMemoria.add(new Donacion(
                contadorId++,
                "El código Da Vinci",
                "Dan Brown",
                "Misterio / Novela",
                2003,
                "EXCELENTE",
                "Carlos Mendoza (Docente)",
                "carlos.mendoza@universidad.edu.pe",
                "987654321",
                "Ejemplar en perfecto estado de mi colección personal para la biblioteca.",
                "07/11/2026",
                "PENDIENTE"
        ));

        donacionesMemoria.add(new Donacion(
                contadorId++,
                "Python Crash Course",
                "Eric Matthes",
                "Programación",
                2019,
                "BUENO",
                "Lucía Fernández (Estudiante Ing.)",
                "lucia.fernandez@universidad.edu.pe",
                "912345678",
                "Manual práctico de introducción a Python para el laboratorio de sistemas.",
                "08/11/2026",
                "PENDIENTE"
        ));

        donacionesMemoria.add(new Donacion(
                contadorId++,
                "La ciudad y los perros",
                "Mario Vargas Llosa",
                "Literatura",
                1963,
                "EXCELENTE",
                "Egresado Promoción 2024",
                "donaciones@comunidad.pe",
                "999888777",
                "Clásico peruano para consulta de estudiantes de humanidades.",
                "05/11/2026",
                "APROBADO"
        ));
    }

    private void asegurarTabla(Connection con) {
        if (tablaVerificada || con == null) {
            return;
        }
        tablaVerificada = true;
        String sql = "CREATE TABLE IF NOT EXISTS donaciones ("
                + "id_donacion INT AUTO_INCREMENT PRIMARY KEY, "
                + "titulo_libro VARCHAR(200) NOT NULL, "
                + "autor VARCHAR(120) NOT NULL, "
                + "categoria VARCHAR(100) NOT NULL, "
                + "anio INT DEFAULT NULL, "
                + "estado_conservacion VARCHAR(50) NOT NULL, "
                + "nombre_donante VARCHAR(120) NOT NULL, "
                + "correo_donante VARCHAR(120) NOT NULL, "
                + "telefono_donante VARCHAR(30) DEFAULT NULL, "
                + "motivo_mensaje TEXT, "
                + "fecha_solicitud VARCHAR(20) NOT NULL, "
                + "estado_revision VARCHAR(30) NOT NULL DEFAULT 'PENDIENTE'"
                + ")";
        try (Statement st = con.createStatement()) {
            st.executeUpdate(sql);
        } catch (SQLException ignored) {
        }
    }

    public List<Donacion> listar() {
        String sql = "SELECT * FROM donaciones ORDER BY id_donacion DESC";
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                asegurarTabla(con);
                try (PreparedStatement ps = con.prepareStatement(sql);
                     ResultSet rs = ps.executeQuery()) {
                    List<Donacion> lista = new ArrayList<>();
                    while (rs.next()) {
                        lista.add(new Donacion(
                                rs.getInt("id_donacion"),
                                rs.getString("titulo_libro"),
                                rs.getString("autor"),
                                rs.getString("categoria"),
                                rs.getInt("anio"),
                                rs.getString("estado_conservacion"),
                                rs.getString("nombre_donante"),
                                rs.getString("correo_donante"),
                                rs.getString("telefono_donante"),
                                rs.getString("motivo_mensaje"),
                                rs.getString("fecha_solicitud"),
                                rs.getString("estado_revision")
                        ));
                    }
                    if (!lista.isEmpty()) {
                        return lista;
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Error en DonacionDAO.listar: " + e.getMessage());
        }
        return new ArrayList<>(donacionesMemoria);
    }

    public Donacion obtenerPorId(int id) {
        for (Donacion d : listar()) {
            if (d.getIdDonacion() == id) {
                return d;
            }
        }
        return null;
    }

    public boolean registrar(Donacion d) {
        String sql = "INSERT INTO donaciones (titulo_libro, autor, categoria, anio, "
                + "estado_conservacion, nombre_donante, correo_donante, telefono_donante, "
                + "motivo_mensaje, fecha_solicitud, estado_revision) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        int idGenerado = -1;
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                asegurarTabla(con);
                try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, d.getTituloLibro());
                    ps.setString(2, d.getAutor());
                    ps.setString(3, d.getCategoria());
                    ps.setInt(4, d.getAnio());
                    ps.setString(5, d.getEstadoConservacion());
                    ps.setString(6, d.getNombreDonante());
                    ps.setString(7, d.getCorreoDonante());
                    ps.setString(8, d.getTelefonoDonante());
                    ps.setString(9, d.getMotivoMensaje());
                    ps.setString(10, d.getFechaSolicitud());
                    ps.setString(11, d.getEstadoRevision() != null ? d.getEstadoRevision() : "PENDIENTE");
                    int res = ps.executeUpdate();
                    if (res > 0) {
                        try (ResultSet rs = ps.getGeneratedKeys()) {
                            if (rs.next()) {
                                idGenerado = rs.getInt(1);
                                d.setIdDonacion(idGenerado);
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Error en DonacionDAO.registrar: " + e.getMessage());
        }

        if (idGenerado == -1) {
            d.setIdDonacion(contadorId++);
        } else {
            contadorId = Math.max(contadorId, idGenerado + 1);
        }
        if (d.getEstadoRevision() == null) {
            d.setEstadoRevision("PENDIENTE");
        }
        donacionesMemoria.add(0, d);
        return true;
    }

    public boolean cambiarEstado(int idDonacion, String nuevoEstado) {
        String sql = "UPDATE donaciones SET estado_revision = ? WHERE id_donacion = ?";
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setString(1, nuevoEstado);
                    ps.setInt(2, idDonacion);
                    ps.executeUpdate();
                }
            }
        } catch (Exception e) {
            System.err.println("Error en DonacionDAO.cambiarEstado: " + e.getMessage());
        }

        for (Donacion d : donacionesMemoria) {
            if (d.getIdDonacion() == idDonacion) {
                d.setEstadoRevision(nuevoEstado);
                return true;
            }
        }
        return true;
    }

    public int contarPendientes() {
        int count = 0;
        for (Donacion d : listar()) {
            if ("PENDIENTE".equalsIgnoreCase(d.getEstadoRevision())) {
                count++;
            }
        }
        return count;
    }
}
