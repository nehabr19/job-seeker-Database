package com.jobseeker.controller;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/SignupServlet")
@MultipartConfig
public class SignupServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String URL = "jdbc:mysql://localhost:3306/";
    private static final String DB_NAME = "jobseeker_db";
    private static final String USER = "root";
    private static final String PASSWORD = "root";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        Part resumePart = request.getPart("resume");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            createDatabaseAndTable();

            try (Connection connection = DriverManager.getConnection(URL + DB_NAME, USER, PASSWORD)) {
                String insertSQL = "INSERT INTO jobseekers (name, email, phone, resume) VALUES (?, ?, ?, ?)";
                PreparedStatement preparedStatement = connection.prepareStatement(insertSQL);
                preparedStatement.setString(1, name);
                preparedStatement.setString(2, email);
                preparedStatement.setString(3, phone);

                // Read the input stream from the file part and set it as a BLOB
                InputStream resumeInputStream = resumePart.getInputStream();
                preparedStatement.setBlob(4, resumeInputStream);

                int rowsAffected = preparedStatement.executeUpdate();

                // Redirect to the preview page with all parameters
                response.sendRedirect("preview.jsp?name=" + name + "&email=" + email + "&phone=" + phone);
            }
        } catch (ClassNotFoundException e) {
            response.getWriter().println("MySQL JDBC Driver not found: " + e.getMessage());
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }

    private void createDatabaseAndTable() throws SQLException {
        try (Connection connection = DriverManager.getConnection(URL, USER, PASSWORD);
             Statement statement = connection.createStatement()) {

            String createDatabaseSQL = "CREATE DATABASE IF NOT EXISTS " + DB_NAME;
            statement.executeUpdate(createDatabaseSQL);

            String useDatabaseSQL = "USE " + DB_NAME;
            statement.executeUpdate(useDatabaseSQL);

            String createTableSQL = """
                CREATE TABLE IF NOT EXISTS jobseekers (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    name VARCHAR(100) NOT NULL,
                    email VARCHAR(100) NOT NULL,
                    phone VARCHAR(15) NOT NULL,
                    resume LONGBLOB NOT NULL
                )
            """;
            statement.executeUpdate(createTableSQL);
        }
    }
}
