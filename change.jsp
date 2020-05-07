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
<%
Class.forName("com.mysql.jdbc.Driver").newInstance();
Connection con = DriverManager.getConnection("jdbc:mysql://cs336db.cunxqv1yfwcg.us-east-2.rds.amazonaws.com:3306/cs336","admin", "password123");
Statement st = con.createStatement();
ResultSet rs;
String Email=request.getParameter("email");
String Password=request.getParameter("password");
String First_Name=request.getParameter("fname");	
String Last_Name=request.getParameter("lname");
String Address=request.getParameter("address");
String Account_Type= request.getParameter("accountcol");
String query = String.format("SELECT * FROM account WHERE email = \"%s\" ", Email);
rs = st.executeQuery(query);
if (rs.next()) {
	
	String edit = String.format("update account set password=(?),fname=(?),lname=(?),address=(?),accountcol=(?) where email=\"%s\" ", Email);
	PreparedStatement ps = con.prepareStatement(edit);
	
	ps.setString(1, Password);
	ps.setString(2,First_Name );
	ps.setString(3, Last_Name);
	ps.setString(4, Address);
	ps.setString(5, Account_Type);
	//Run the query against the DB
	ps.executeUpdate();
	out.println("Account information edited. Go back to see new account list.");
}
else {
	if(Email=="")
		out.println("Not enough information added");
	else{
String insert = "INSERT INTO account VALUES (?, ?, ?, ?, ?, ?)";
//Create a Prepared SQL statement allowing you to introduce the parameters of the query
PreparedStatement ps = con.prepareStatement(insert);
ps.setString(1, Email);
ps.setString(2, Password);
ps.setString(3,First_Name );
ps.setString(4, Last_Name);
ps.setString(5, Address);
ps.setString(6, Account_Type);
//Run the query against the DB
ps.executeUpdate();
out.println("Account information added. Go back to see new account list.");
}}
%>
<br> <a href="admin.jsp">Go Back</a></p>
</body>
<a href="logout.jsp">Logout</a>
</html>