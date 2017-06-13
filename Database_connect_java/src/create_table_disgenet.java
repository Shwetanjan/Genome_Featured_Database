/**
 * Created by shweta on 07/06/17.
 * This class connects to the GFD database in the server and create the disgenet table in the GFD if not present
 */


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;


import javafx.scene.control.*;

import javax.swing.*;
import  java.awt.*;
import java.awt.event.*;
import java.sql.*;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class create_table_disgenet {

        public static Connection conn = null;
        public static String file = "/Users/mkyong/csv/country.csv";
        public static String line = "";
        public static String splitBy = " ";

        public static void initConnection() {

            // SQL statement for creating a new table
            String sql =  "CREATE TABLE IF NOT EXISTS DisGeNet" +
                    " (id INT PRIMARY KEY AUTO_INCREMENT,\n"
                    + "	rsID VARCHAR(255) NOT NULL,\n"
                    + "	geneID VARCHAR(255) NOT NULL,\n"
                    + "gene_Symbol VARCHAR(255) NOT NULL,\n"
                    + "diseaseID_umls VARCHAR(255) NOT NULL,\n"
                    + "chr INT"
                    + ");";


            try {
                // The newInstance() call is a work around for some
                // broken Java implementations

                Class.forName("com.mysql.jdbc.Driver").newInstance();
                conn = DriverManager.getConnection("jdbc:mysql://localhost/GFD",
                        "root", "S@ttvik");
            } catch (Exception ex) {
                // handle the error
                System.out.println("Exception" + ex.toString());
            }

            try (Statement stmt = conn.createStatement()) {
                // create a new table
                stmt.execute(sql);
            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }




    public void insert_table()

    {

        String query = " insert into users (id, rsID, geneID, gene_Symbol, diseaseID_umls,chr)"
                + " values (?, ?, ?, ?, ?)";

        BufferedReader br = null;

        try {

            br = new BufferedReader(new FileReader(file));

            while ((line = br.readLine()) != null) {

                if (line.startsWith("rs")) {

                    // use tab as separator
                    String[] disgentArray = line.split(splitBy);
                    

                    // create the mysql insert preparedstatement
                    PreparedStatement preparedStmt = conn.prepareStatement(query);
                    preparedStmt.setInt(1, "");
                    preparedStmt.setString(2, "");
                    preparedStmt.setString(3, );
                    preparedStmt.setString(4, );
                    preparedStmt.setString(5, );
                    preparedStmt.setInt(6, 5000);

                    // execute the preparedstatement
                    preparedStmt.execute();

                }
            }

        } catch (Exception e) {
            System.err.println("Got an exception!");
            System.err.println(e.getMessage());
        } finally {
            if (br != null) {
                try {
                    br.close();
                    conn.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }

            }
        }
    }



        public static void main(String[] args) {
            initConnection();
        }
    }

