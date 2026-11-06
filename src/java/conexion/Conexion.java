package conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    private static final String URL_3306 =
            "jdbc:mysql://localhost:3306/bookhub?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&characterEncoding=UTF-8";

    private static final String URL_3307 =
            "jdbc:mysql://localhost:3307/bookhub?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&characterEncoding=UTF-8";

    private static final String USER = "root";
    private static final String PASS_LOCAL = "123456789";
    private static final String PASS_VACIA = "";

    public static Connection conectar() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("Driver MySQL no encontrado: " + e.getMessage());
            return null;
        }

        // 1. Intentar puerto 3306 con contraseña local (123456789)
        try {
            Connection conexion = DriverManager.getConnection(URL_3306, USER, PASS_LOCAL);
            System.out.println("Conexion exitosa con MySQL (localhost:3306/bookhub)");
            return conexion;
        } catch (SQLException ignored) {
        }

        // 2. Intentar puerto 3306 sin contraseña (XAMPP/Laragon)
        try {
            Connection conexion = DriverManager.getConnection(URL_3306, USER, PASS_VACIA);
            System.out.println("Conexion exitosa con MySQL (localhost:3306/bookhub)");
            return conexion;
        } catch (SQLException ignored) {
        }

        // 3. Intentar puerto 3307 con o sin contraseña
        try {
            Connection conexion = DriverManager.getConnection(URL_3307, USER, PASS_LOCAL);
            System.out.println("Conexion exitosa con MySQL (localhost:3307/bookhub)");
            return conexion;
        } catch (SQLException ignored) {
        }

        try {
            Connection conexion = DriverManager.getConnection(URL_3307, USER, PASS_VACIA);
            System.out.println("Conexion exitosa con MySQL (localhost:3307/bookhub)");
            return conexion;
        } catch (SQLException e) {
            System.out.println("Error de conexion MySQL: " + e.getMessage());
            return null;
        }
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
