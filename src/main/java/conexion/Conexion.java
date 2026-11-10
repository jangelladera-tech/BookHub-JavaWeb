package conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    private static final String[] URLS = {
        "jdbc:mysql://localhost:3306/bookhub?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&characterEncoding=UTF-8",
        "jdbc:mysql://127.0.0.1:3306/bookhub?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&characterEncoding=UTF-8",
        "jdbc:mysql://localhost:3307/bookhub?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&characterEncoding=UTF-8"
    };

    private static final String USER = "root";
    private static final String[] PASSWORDS = {
        "12345",
        "",
        "root",
        "123456",
        "123456789",
        "admin"
    };

    private static volatile String cachedUrl = null;
    private static volatile String cachedPass = null;

    public static Connection conectar() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("Driver MySQL no encontrado: " + e.getMessage());
            return null;
        }

        // Si ya encontramos una combinación que funciona, intentamos primero con ella
        if (cachedUrl != null && cachedPass != null) {
            try {
                Connection con = DriverManager.getConnection(cachedUrl, USER, cachedPass);
                if (con != null && !con.isClosed()) {
                    return con;
                }
            } catch (SQLException ignored) {
                cachedUrl = null;
                cachedPass = null;
            }
        }

        for (String url : URLS) {
            for (String pass : PASSWORDS) {
                try {
                    Connection conexion = DriverManager.getConnection(url, USER, pass);
                    if (conexion != null && !conexion.isClosed()) {
                        cachedUrl = url;
                        cachedPass = pass;
                        System.out.println("Conexion exitosa con MySQL: " + url + " (usuario: " + USER + ")");
                        return conexion;
                    }
                } catch (SQLException ignored) {
                }
            }
        }

        System.err.println("Error de conexion MySQL: No se pudo conectar a la base de datos 'bookhub'.");
        return null;
    }

    public static void main(String[] args) {
        try (Connection con = conectar()) {
            if (con != null && !con.isClosed()) {
                System.out.println("==========================================");
                System.out.println("CONEXION EXITOSA CON MYSQL - BD: bookhub");
                System.out.println("==========================================");
            } else {
                System.out.println("No se pudo establecer la conexion con MySQL.");
            }
        } catch (SQLException e) {
            System.out.println("Error al verificar conexion: " + e.getMessage());
        }
    }
}
