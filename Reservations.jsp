<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ page import ="java.sql.*" %>
<!DOCTYPE html>
<html lang="en-US">
<head>
    
    <meta charset="UTF-8">
    <title>Travel Agency User Portal</title>
    <link rel="stylesheet" type="text/css" href="style/index.css" />
</head>
<body>

<%
if(request.getParameter("Name")==""){

String FNumber=request.getParameter("FlightNumber");


Class.forName("com.mysql.jdbc.Driver").newInstance();
Connection con = DriverManager.getConnection("jdbc:mysql://cs336db.cunxqv1yfwcg.us-east-2.rds.amazonaws.com:3306/cs336","admin", "password123");
//Statement st = con.createStatement();
String select = "select FlightNumber, Email, Books.TicketNumber from Books, AssociatedWith  where AssociatedWith.TicketNumber = Books.TicketNumber and FlightNumber= (?)";
PreparedStatement ps=con.prepareStatement(select);
ps.setString(1,FNumber);
ResultSet rs=ps.executeQuery();
out.print("<table>");

//make a row
out.print("<tr>");
//make a column
out.print("<td>");
//print out column header
out.print("FlightNumber");
out.print("</td>");
//make a column
out.print("<td>");
out.print("Email");
out.print("</td>");
//make a column
out.print("<td>");
out.print("TicketNumber");
out.print("</td>");
out.print("</tr>");
while (rs.next()) {
	//make a row
	out.print("<tr>");
	//make a column
	out.print("<td>");
	//Print out current bar name:
	out.print(rs.getString("FlightNumber"));
	out.print("</td>");
	out.print("<td>");
	//Print out current beer name:
	out.print(rs.getString("Email"));
	out.print("</td>");
	out.print("<td>");
	//Print out current price
	out.print(rs.getString("TicketNumber"));
	out.print("</td>");
	out.print("</tr>");

}
out.print("</table>");}

else if (request.getParameter("FlightNumber")==""){
	String Name=request.getParameter("Name");


	Class.forName("com.mysql.jdbc.Driver").newInstance();
	Connection con = DriverManager.getConnection("jdbc:mysql://cs336db.cunxqv1yfwcg.us-east-2.rds.amazonaws.com:3306/cs336","admin", "password123");
	//Statement st = con.createStatement();
	String select = "select * from Ticket WHERE TicketNumber in(SELECT TicketNumber FROM Books WHERE Email in(select email from account where fname=(?)))";

	PreparedStatement ps=con.prepareStatement(select);
	ps.setString(1,Name);
	ResultSet rs=ps.executeQuery();
	out.print("<table>");

	//make a row
	out.print("<tr>");
	//make a column
	out.print("<td>");
	//print out column header
	out.print("TicketNumber");
	out.print("</td>");
	//make a column
	out.print("<td>");
	out.print("Fare");
	out.print("</td>");
	//make a column
	out.print("<td>");
	out.print("BookingFee");
	out.print("</td>");
	out.print("<td>");
	out.print("Class");
	out.print("</td>");
	out.print("<td>");
	out.print("Purchase_Date");
	out.print("</td>");
	out.print("</tr>");
	while (rs.next()) {
		//make a row
		out.print("<tr>");
		//make a column
		out.print("<td>");
		//Print out current bar name:
		out.print(rs.getString("TicketNumber"));
		out.print("</td>");
		out.print("<td>");
		//Print out current beer name:
		out.print(rs.getString("Fare"));
		out.print("</td>");
		out.print("<td>");
		//Print out current price
		out.print(rs.getString("BookingFee"));
		out.print("</td>");
		out.print("<td>");
		//Print out current price
		out.print(rs.getString("Class"));
		out.print("</td>");
		out.print("<td>");
		//Print out current price
		out.print(rs.getString("PurchaseDate"));
		out.print("</td>");
		out.print("</tr>");

	}
	out.print("</table>");}

else
	out.println("Please enter only one");

%>

</body>
<a href="logout.jsp">Logout</a>
</html>