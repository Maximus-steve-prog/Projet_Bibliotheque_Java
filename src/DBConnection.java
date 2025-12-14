package projet_bibliotheque.src;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.io.FileInputStream;
import java.io.IOException;

public class DBConnection {
    private static final String CONFIG_FILE = "config/database.properties";
    
    public static Connection getConnection() {
        Properties props = new Properties(); 
        try {
            FileInputStream in = new FileInputStream(CONFIG_FILE);
            props.load(in);
            in.close();
            
            String url = props.getProperty("db.url");
            String username = props.getProperty("db.username");
            String password = props.getProperty("db.password");
            
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Return a new connection each time
            return DriverManager.getConnection(url, username, password);
            
        } catch (ClassNotFoundException e) {
            System.err.println("Driver MySQL non trouvé. Assurez-vous d'avoir ajouté mysql-connector-java.jar au classpath.");
            e.printStackTrace();
        } catch (IOException e) {
            System.err.println("Erreur de lecture du fichier de configuration: " + e.getMessage());
            System.err.println("Vérifiez que le fichier config/database.properties existe.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Erreur de connexion à MySQL: " + e.getMessage());
            System.err.println("Vérifiez que MySQL est démarré et que la base de données existe.");
            e.printStackTrace();
        }
        return null;
    }
    
    public static void testConnection() {
        try (Connection conn = getConnection()) {
            if (conn != null && !conn.isClosed()) {
                System.out.println("Connexion à la base de données MySQL établie.");
                System.out.println("Test de connexion réussi!");
                System.out.println("Base de données: " + conn.getMetaData().getDatabaseProductName());
                System.out.println("Version: " + conn.getMetaData().getDatabaseProductVersion());
            } else {
                System.out.println("Échec du test de connexion");
            }
        } catch (SQLException e) {
            System.err.println("Test de connexion échoué: " + e.getMessage());
            System.err.println("Assurez-vous que:");
            System.err.println("1. MySQL est démarré");
            System.err.println("2. La base 'bibliotheque_db' existe");
            System.err.println("3. Les identifiants dans config/database.properties sont corrects");
        }
    }
}