package dao;

import beans.Usuario;
import conexion.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    private static List<Usuario> usuarios = new ArrayList<>();
    private static int contadorId = 1;

    static {
        // 1 Usuario Administrador pre-creado
        usuarios.add(new Usuario(
                contadorId++,
                "Administrador",
                "admin@bookhub.com",
                "123456",
                "ADMIN",
                "ACTIVO"
        ));

        // 2 Usuarios de Lectores pre-creados
        usuarios.add(new Usuario(
                contadorId++,
                "Juan Pérez (Lector 1)",
                "juan@bookhub.com",
                "123456",
                "USUARIO",
                "ACTIVO"
        ));

        usuarios.add(new Usuario(
                contadorId++,
                "María López (Lector 2)",
                "maria@bookhub.com",
                "123456",
                "USUARIO",
                "ACTIVO"
        ));
    }

    // ============================
    // LISTAR
    // ============================

    public List<Usuario> listar() {
        String sql = "SELECT id_usuario, nombre, correo, password, rol, estado FROM usuarios ORDER BY id_usuario ASC";
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql);
                     ResultSet rs = ps.executeQuery()) {
                    List<Usuario> listaBD = new ArrayList<>();
                    while (rs.next()) {
                        listaBD.add(new Usuario(
                                rs.getInt("id_usuario"),
                                rs.getString("nombre"),
                                rs.getString("correo"),
                                rs.getString("password"),
                                rs.getString("rol"),
                                rs.getString("estado")
                        ));
                    }
                    if (!listaBD.isEmpty()) {
                        return listaBD;
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Usando datos en memoria para UsuarioDAO: " + e.getMessage());
        }
        return usuarios;
    }

    // ============================
    // OBTENER POR ID
    // ============================

    public Usuario obtenerPorId(int id) {
        String sql = "SELECT id_usuario, nombre, correo, password, rol, estado FROM usuarios WHERE id_usuario = ?";
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, id);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            return new Usuario(
                                    rs.getInt("id_usuario"),
                                    rs.getString("nombre"),
                                    rs.getString("correo"),
                                    rs.getString("password"),
                                    rs.getString("rol"),
                                    rs.getString("estado")
                            );
                        }
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Error obtenerPorId UsuarioDAO: " + e.getMessage());
        }

        for (Usuario usuario : usuarios) {
            if (usuario.getIdUsuario() == id) {
                return usuario;
            }
        }
        return null;
    }

    // ============================
    // AUTENTICAR LOGIN
    // ============================

    public Usuario autenticar(String correo, String password) {
        if (correo == null || password == null) {
            return null;
        }
        String correoLimpio = correo.trim();
        String passLimpio = password.trim();

        for (Usuario usuario : listar()) {
            if (usuario.getCorreo().equalsIgnoreCase(correoLimpio)
                    && usuario.getPassword().equals(passLimpio)) {
                return usuario;
            }
        }
        return null;
    }

    // ============================
    // AGREGAR
    // ============================

    public void agregar(Usuario usuario) {
        String sql = "INSERT INTO usuarios (nombre, correo, password, rol, estado) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setString(1, usuario.getNombre());
                    ps.setString(2, usuario.getCorreo());
                    ps.setString(3, usuario.getPassword());
                    ps.setString(4, usuario.getRol());
                    ps.setString(5, usuario.getEstado());
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            System.out.println("Error agregar UsuarioDAO: " + e.getMessage());
        }

        usuario.setIdUsuario(contadorId++);
        usuarios.add(usuario);
    }

    // ============================
    // ACTUALIZAR
    // ============================

    public void actualizar(Usuario usuario) {
        String sql = "UPDATE usuarios SET nombre = ?, correo = ?, password = ?, rol = ?, estado = ? WHERE id_usuario = ?";
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setString(1, usuario.getNombre());
                    ps.setString(2, usuario.getCorreo());
                    ps.setString(3, usuario.getPassword());
                    ps.setString(4, usuario.getRol());
                    ps.setString(5, usuario.getEstado());
                    ps.setInt(6, usuario.getIdUsuario());
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            System.out.println("Error actualizar UsuarioDAO: " + e.getMessage());
        }

        for (int i = 0; i < usuarios.size(); i++) {
            if (usuarios.get(i).getIdUsuario() == usuario.getIdUsuario()) {
                usuarios.set(i, usuario);
                break;
            }
        }
    }

    // ============================
    // ELIMINAR
    // ============================

    public void eliminar(int id) {
        String sql = "DELETE FROM usuarios WHERE id_usuario = ?";
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, id);
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            System.out.println("Error eliminar UsuarioDAO: " + e.getMessage());
        }

        usuarios.removeIf(usuario -> usuario.getIdUsuario() == id);
    }
}
