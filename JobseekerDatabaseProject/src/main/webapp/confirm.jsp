<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirmation</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        .confirmation-message {
            font-size: 18px;
            color: #4CAF50;
            margin-bottom: 20px;
        }
        .confirm-button {
            display: inline-block;
            padding: 10px 20px;
            font-size: 16px;
            color: white;
            background-color: #4CAF50;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .cancel-button {
            display: inline-block;
            padding: 10px 20px;
            font-size: 16px;
            color: white;
            background-color: #f44336;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-left: 10px;
        }
    </style>
</head>
<body>
    <h1>Confirmation</h1>
    <div class="confirmation-message">
        <p>Your resume has been submitted successfully.</p>
    </div>
    
    <form action="index.jsp" method="get">
        <button type="submit" class="confirm-button">Go to Home</button>
    </form>
</body>
</html>
