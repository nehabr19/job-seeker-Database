<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Preview</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        h1 {
            color: #333;
        }
        p {
            font-size: 16px;
            margin-bottom: 10px;
        }
        a {
            display: inline-block;
            margin: 10px 0;
            padding: 10px 15px;
            background-color: #4CAF50;
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
        }
        a:hover {
            background-color: #45a049;
        }
        .button {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 15px;
            background-color: #007BFF;
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
        }
        .button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <h1>Preview Your Details</h1>
    <p><strong>Name:</strong> ${param.name}</p>
    <p><strong>Email:</strong> ${param.email}</p>
    <p><strong>Phone:</strong> ${param.phone}</p>

    <h2>Resume</h2>
    <% 
        // Get parameters
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        
        // Database connection details
        String URL = "jdbc:mysql://localhost:3306/jobseeker_db";
        String USER = "root";
        String PASSWORD = "root";
        
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
            String sql = "SELECT resume FROM jobseekers WHERE name = ? AND email = ? AND phone = ?";
            statement = connection.prepareStatement(sql);
            statement.setString(1, name);
            statement.setString(2, email);
            statement.setString(3, phone);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                Blob resumeBlob = resultSet.getBlob("resume");
                byte[] resumeBytes = resumeBlob.getBytes(1, (int) resumeBlob.length());
                String resumeBase64 = java.util.Base64.getEncoder().encodeToString(resumeBytes);
                String resumeUrl = "data:application/pdf;base64," + resumeBase64;
    %>
    <a href="<%= resumeUrl %>" download="resume.pdf">Download Resume</a>
    <% 
            } else {
    %>
    <p>Resume not found.</p>
    <% 
            }
        } catch (Exception e) {
            e.printStackTrace();
    %>
    <p>Error occurred: <%= e.getMessage() %></p>
    <% 
        } finally {
            try {
                if (resultSet != null) resultSet.close();
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>
    
    <a class="button" href="confirm.jsp?name=<%= name %>&email=<%= email %>&phone=<%= phone %>">Confirm</a>
</body>
</html>
