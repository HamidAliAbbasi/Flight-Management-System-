<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ page import="java.sql.*, com.mysql.jdbc.Driver"%>
<!DOCTYPE html>
<html lang="en-US">
<head>
    
    <meta charset="UTF-8">
    <title>Travel Agency User Portal</title>
    <link rel="stylesheet" type="text/css" href="style/index.css" />
</head>
<body>
    <div class="login-page">
        <div class="form">
            <div id="loginText">Login</div>
            <% 
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                if (email != null && password != null) {
                    Class.forName("com.mysql.jdbc.Driver").newInstance();
                    Connection con = DriverManager.getConnection("jdbc:mysql://cs336db.cunxqv1yfwcg.us-east-2.rds.amazonaws.com:3306/cs336","admin", "password123");
                    Statement st = con.createStatement();
                    ResultSet rs;
                    String query = String.format("SELECT * FROM account WHERE email = \"%s\" AND password = \"%s\"", email, password);
                    rs = st.executeQuery(query);
                    if (rs.next()){
              
                        session.setAttribute("email", email); // the username will be stored in the session
                        session.setAttribute("fname", rs.getString("fname")); // the username will be stored in the session
                        session.setAttribute("lname", rs.getString("lname")); // the username will be stored in the session
                        session.setAttribute("accountcol", rs.getString("accountcol")); // the username will be stored in the session
                        response.sendRedirect("success.jsp");
                    } else {
                        out.println("Invalid login");
                    }
                }
            %>
            <form method="POST">
                <input name="email" type="text" placeholder="email" />
                <input name="password" type="password" placeholder="password" />
                <button>Login</button>
                <p class="message">Not registered?<a href="register.jsp">Register</a></p>
                
            </form>
        </div>
    </div>
</body>
</html>
