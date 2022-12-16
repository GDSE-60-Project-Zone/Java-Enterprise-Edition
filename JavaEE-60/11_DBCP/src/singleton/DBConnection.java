package singleton;

import org.apache.commons.dbcp2.BasicDataSource;

import java.sql.Connection;
import java.sql.SQLException;

public class DBConnection {
    private static DBConnection dbConnection;
    BasicDataSource bds;
    private DBConnection(){
        bds= new BasicDataSource();
        bds.setDriverClassName("com.mysql.jdbc.Driver");
        bds.setUrl("jdbc:mysql://localhost:3306/company");
        bds.setPassword("sanu1234");
        bds.setUsername("root");
        // how many connection
        bds.setMaxTotal(2);
        // how many connection should be initialized from created connections
        bds.setInitialSize(2);

    }
    public static DBConnection getDbConnection(){
        if (dbConnection==null){
            dbConnection= new DBConnection();
        }
        return dbConnection;
    }

    public Connection getConnection() throws SQLException {
        return bds.getConnection();
    }
}
